report 66600 "CHM Michelin Labels"
{
    Caption = 'Michelin Labels';
    UsageCategory = None;
    DefaultRenderingLayout = MichelinLabelsRDLC;

    dataset
    {
        dataitem(Labels; "CHM Michelin Labels")
        {
            DataItemTableView = sorting(Index);
            UseTemporary = true;

            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));

                // Unique per printed label: the RDL groups and page-breaks on this column
                column(Number; LabelCounter) { }

                // Ship from / Ship to
                column(Ship_from_Name; Labels."Ship-from Name") { }
                column(Ship_from_Address; Labels."Ship-from Address") { }
                column(Ship_from_City; Labels."Ship-from City") { }
                column(Ship_from_Post_Code; Labels."Ship-from Post Code") { }
                column(Ship_from_County; Labels."Ship-from County") { }
                column(Ship_from_Country; Labels."Ship-from Country") { }
                column(Ship_to_Name; Labels."Ship-to Name") { }
                column(Ship_to_Address; Labels."Ship-to Address") { }
                column(Ship_to_City; Labels."Ship-to City") { }
                column(Ship_to_Post_Code; Labels."Ship-to Post Code") { }
                column(Ship_to_County; Labels."Ship-to County") { }
                column(Ship_to_Country; Labels."Ship-to Country") { }

                // Human-readable values (same names as the existing RDL)
                column(SupplierCode; SupplierCode) { }
                column(Lot_No_; Labels."Lot No.") { }
                column(Michelin_Purch__Order; Labels."Michelin Purch. Order") { }
                column(Item_No_; Labels."Item No.") { }
                column(Description; Labels.Description) { }
                column(Label_SN; LabelSN) { }
                column(Production_Date; ProductionDateText) { }
                column(Quantity; QuantityText) { }
                column(BidimCode; BidimCode) { }
                column(Sales_Shpt_Code; Labels."Sales Shpt. Code") { }
                column(Sales_Order_No_; Labels."Sales Order No.") { }

                // Font-encoded barcodes (replace the old TM* / TenantMedia images)
                column(Barcode_SupplierCode; BarcodeSupplierCode) { }
                column(Barcode_LotNo; BarcodeLotNo) { }
                column(Barcode_MichelinPO; BarcodeMichelinPO) { }
                column(Barcode_ItemNo; BarcodeItemNo) { }
                column(Barcode_LabelSN; BarcodeLabelSN) { }
                column(Barcode_ProdDate; BarcodeProdDate) { }
                column(Barcode_Qty; BarcodeQty) { }
                column(Barcode_QRCode; BarcodeQRCode) { }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfCopies);
                end;

                trigger OnAfterGetRecord()
                begin
                    LabelCounter += 1;
                    LabelSN := GetNextLabelSN();
                    BuildLabelBarcodes();
                end;
            }

            trigger OnPreDataItem()
            begin
                if Labels.IsEmpty() then
                    Error(NothingToPrintErr);
                if NoOfCopies < 1 then
                    NoOfCopies := 1;

                SalesReceivablesSetup.Get();
                SalesReceivablesSetup.TestField("CHM Michelin Label Nos.");
            end;

            trigger OnAfterGetRecord()
            begin
                SupplierCode := GetSupplierCode(Labels."Sales Shpt. Code");

                ProductionDateText := Labels."Production Date";
                if ProductionDateText = '' then
                    ProductionDateText := '00.00.00';

                QuantityText := Format(Labels.Quantity, 0, '<Integer,6><Filler Character,0>');

                BarcodeSupplierCode := EncodeCode39(SupplierCode);
                BarcodeLotNo := EncodeCode39(Labels."Lot No.");
                BarcodeMichelinPO := EncodeCode39(Labels."Michelin Purch. Order");
                BarcodeItemNo := EncodeCode39(Labels."Item No.");
                BarcodeProdDate := EncodeCode39(ProductionDateText);
                BarcodeQty := EncodeCode39(QuantityText);
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NoOfCopiesReq; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of copies';
                        MinValue = 1;
                        ToolTip = 'Specifies how many copies of each label are printed.';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(MichelinLabelsRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMMichelinLabels.rdl';
            Caption = 'Michelin Labels (RDLC)';
            Summary = 'Michelin barcode label, one label per A5 landscape page.';
        }
    }

    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoOfCopies: Integer;
        LabelCounter: Integer;
        SupplierCode: Code[20];
        LabelSN: Code[20];
        ProductionDateText: Text[8];
        QuantityText: Text[10];
        BidimCode: Text;
        BarcodeSupplierCode: Text;
        BarcodeLotNo: Text;
        BarcodeMichelinPO: Text;
        BarcodeItemNo: Text;
        BarcodeLabelSN: Text;
        BarcodeProdDate: Text;
        BarcodeQty: Text;
        BarcodeQRCode: Text;
        LastShipmentNo: Code[20];
        NothingToPrintErr: Label 'There are no labels to print.';
        Code39CharsTok: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-. $/+%', Locked = true;

    /// <summary>
    /// Called from the Michelin labels page with the selected lines and the number of copies.
    /// </summary>
    procedure SetData(var TempMichelinLabels: Record "CHM Michelin Labels" temporary; NewNoOfCopies: Integer)
    begin
        Labels.Reset();
        Labels.DeleteAll();
        if TempMichelinLabels.FindSet() then
            repeat
                Labels := TempMichelinLabels;
                Labels.Insert();
            until TempMichelinLabels.Next() = 0;
        NoOfCopies := NewNoOfCopies;
    end;

    local procedure BuildLabelBarcodes()
    begin
        // Values that change per printed label (label serial no. and the QR code that contains it)
        BarcodeLabelSN := EncodeCode39(LabelSN);
        BidimCode := SupplierCode + Labels."Item No." + LabelSN + Labels."Lot No." + QuantityText + ProductionDateText;
        BarcodeQRCode := EncodeQRCode(BidimCode);
    end;

    local procedure GetNextLabelSN(): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        exit(NoSeries.GetNextNo(SalesReceivablesSetup."CHM Michelin Label Nos."));
    end;

    local procedure GetSupplierCode(ShipmentNo: Code[20]): Code[20]
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        Customer: Record Customer;
    begin
        if ShipmentNo = LastShipmentNo then
            exit(SupplierCode);
        LastShipmentNo := ShipmentNo;

        if not SalesShipmentHeader.Get(ShipmentNo) then
            exit('');
        if not Customer.Get(SalesShipmentHeader."Sell-to Customer No.") then
            exit('');
        exit(Customer."CHM Michelin Supplier Code");
    end;

    local procedure EncodeCode39(Value: Text): Text
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
    begin
        // Code 39 supports only upper-case letters, digits and - . space $ / + %
        Value := UpperCase(Value);
        Value := DelChr(Value, '=', DelChr(Value, '=', Code39CharsTok));
        if Value = '' then
            exit('');

        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        exit(BarcodeFontProvider.EncodeFont(Value, BarcodeSymbology));
    end;

    local procedure EncodeQRCode(Value: Text): Text
    var
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
    begin
        if Value = '' then
            exit('');

        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        exit(BarcodeFontProvider2D.EncodeFont(Value, BarcodeSymbology2D));
    end;
}
