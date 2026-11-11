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

                column(Number; LabelCounter)
                {

                }

                column(Ship_from_Name; Labels."Ship-from Name")
                {

                }
                column(Ship_from_Address; Labels."Ship-from Address")
                {

                }
                column(Ship_from_City; Labels."Ship-from City")
                {

                }
                column(Ship_from_Post_Code; Labels."Ship-from Post Code")
                {

                }
                column(Ship_from_County; Labels."Ship-from County")
                {

                }
                column(Ship_from_Country; Labels."Ship-from Country")
                {

                }
                column(Ship_to_Name; Labels."Ship-to Name")
                {

                }
                column(Ship_to_Address; Labels."Ship-to Address")
                {

                }
                column(Ship_to_City; Labels."Ship-to City")
                {

                }
                column(Ship_to_Post_Code; Labels."Ship-to Post Code")
                {

                }
                column(Ship_to_County; Labels."Ship-to County")
                {

                }
                column(Ship_to_Country; Labels."Ship-to Country")
                {

                }

                column(SupplierCode; SupplierCode)
                {

                }
                column(Lot_No_; Labels."Lot No.")
                {

                }
                column(Michelin_Purch__Order; Labels."Michelin Purch. Order")
                {

                }
                column(Item_No_; Labels."Item No.")
                {

                }
                column(Description; Labels.Description)
                {

                }
                column(Label_SN; LabelSN)
                {

                }
                column(Production_Date; ProductionDateText)
                {

                }
                column(Quantity; QuantityText)
                {

                }
                column(BidimCode; BidimCode)
                {

                }
                column(Sales_Shpt_Code; Labels."Sales Shpt. Code")
                {

                }
                column(Sales_Order_No_; Labels."Sales Order No.")
                {

                }

                column(Barcode_SupplierCode; BarcodeSupplierCode)
                {

                }
                column(Barcode_LotNo; BarcodeLotNo)
                {

                }
                column(Barcode_MichelinPO; BarcodeMichelinPO)
                {

                }
                column(Barcode_ItemNo; BarcodeItemNo)
                {

                }
                column(Barcode_LabelSN; BarcodeLabelSN)
                {

                }
                column(Barcode_ProdDate; BarcodeProdDate)
                {

                }
                column(Barcode_Qty; BarcodeQty)
                {

                }
                column(Barcode_QRCode; BarcodeQRCode)
                {

                }

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, NoOfCopies);
                end;

                trigger OnAfterGetRecord()
                begin
                    LabelCounter += 1;
                    LabelSN := CHMMgmt.GetNextMichelinLabelSN(SalesReceivablesSetup."CHM Michelin Label Nos.");
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
                if Labels."Sales Shpt. Code" <> LastShipmentNo then begin
                    LastShipmentNo := Labels."Sales Shpt. Code";
                    SupplierCode := CHMMgmt.GetMichelinSupplierCode(Labels."Sales Shpt. Code");
                end;

                ProductionDateText := Labels."Production Date";
                if ProductionDateText = '' then
                    ProductionDateText := '00.00.00';

                QuantityText := Format(Labels.Quantity, 0, '<Integer,6><Filler Character,0>');

                BarcodeSupplierCode := CHMMgmt.EncodeCode39(SupplierCode);
                BarcodeLotNo := CHMMgmt.EncodeCode39(Labels."Lot No.");
                BarcodeMichelinPO := CHMMgmt.EncodeCode39(Labels."Michelin Purch. Order");
                BarcodeItemNo := CHMMgmt.EncodeCode39(Labels."Item No.");
                BarcodeProdDate := CHMMgmt.EncodeCode39(ProductionDateText);
                BarcodeQty := CHMMgmt.EncodeCode39(QuantityText);
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
        CHMMgmt: Codeunit "CHM Customization Mgmt.";
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

    /// <summary>
    /// Loads the label lines to print and the number of copies (called from the Michelin labels page).
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

    /// <summary>
    /// Builds the label serial no. barcode and the QR code of each printed label.
    /// </summary>
    local procedure BuildLabelBarcodes()
    begin
        BarcodeLabelSN := CHMMgmt.EncodeCode39(LabelSN);
        BidimCode := SupplierCode + Labels."Item No." + LabelSN + Labels."Lot No." + QuantityText + ProductionDateText;
        BarcodeQRCode := CHMMgmt.EncodeQRCode(BidimCode);
    end;
}
