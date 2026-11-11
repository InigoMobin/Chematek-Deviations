report 66608 "CHM Return Shipment"
{
    // Chematek Return Shipment (DDT - Documento di trasporto, D.P.R. 472/1996), printed from the Posted Return Shipment
    // (goods returned to the vendor from a Purchase Return Order).
    // Based on the standard "Purchase - Return Shipment" (report 6636, BC 28 W1), extended with the columns used by the
    // Chematek RDLC layout (DataSet_Result, 138 fields).
    // The layout was derived from the Chematek Sales Shipment layout, so several column names still use sales wording
    // (CustomerAddress, SelltoCustomerNo, SalesPersonName, ...). They are kept exactly as they are because the RDLC
    // layout binds to them by name; the comments show the purchase data behind each of them.
    // Decimal columns automatically get a companion "<Name>Format" field in the RDLC dataset,
    // which is why no "...Format" columns are declared here.
    // The page header and footer read their values through Code.SetData / Code.GetData from the first and last row,
    // so everything they print is declared on the Header data item and is available on every row of the dataset.
    // To print it from the Posted Return Shipment, set it up in Report Selections - Purchase, usage "Return Shipment".

    Caption = 'CHM Return Shipment';
    UsageCategory = None;
    DefaultRenderingLayout = ReturnShipmentRDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Header; "Return Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'Posted Return Shipment';

            // Document header captions
            column(PaymentTermsDescription_Lbl; PaymentTermsCaptionLbl)
            {

            }
            column(PaymentMethodDescription_Lbl; PaymentMethodCaptionLbl)
            {

            }
            column(SalesPerson_Lbl; PurchaserCaptionLbl)
            {

            }
            column(OperatorName_Lbl; OperatorCaptionLbl)
            {

            }
            column(DateLbl; DateCaptionLbl)
            {

            }
            column(LocationLbl; ShipmentFromCaptionLbl)
            {

            }
            column(CustomerVendorNoLbl; VendorNoCaptionLbl)
            {

            }
            column(CustomerVendorContactLbl; ContactCaptionLbl)
            {

            }
            column(ShipmentMethodDescription_Lbl; ShipmentMethodCaptionLbl)
            {

            }
            column(VatRegNoLbl; VATRegNoCaptionLbl)
            {

            }
            column(FiscalCodeLbl; FiscalCodeCaptionLbl)
            {

            }
            // Printed above ShippingAgent (the carrier).
            column(ShptByLbl; ShippingAgentCaptionLbl)
            {

            }
            column(ShptMethodLbl; ShipmentMethodCaptionLbl)
            {

            }
            column(ReasonCaption; ReasonCaptionLbl)
            {

            }

            // Page footer captions (shipment data and signatures)
            column(ShptStartLbl; TransportStartCaptionLbl)
            {

            }
            column(SigDriverLbl; DriverSignatureCaptionLbl)
            {

            }
            column(SigRecipientLbl; RecipientSignatureCaptionLbl)
            {

            }
            column(SigAgentLbl; CarrierSignatureCaptionLbl)
            {

            }
            column(NoPalletsLbl; NoOfPalletsCaptionLbl)
            {

            }
            column(DriverLbl; DriverCaptionLbl)
            {

            }
            column(NoParcelsLbl; NoOfParcelsCaptionLbl)
            {

            }
            column(GoodsAppLbl; GoodsAppearanceCaptionLbl)
            {

            }
            column(GrossWLbl; GrossWeightCaptionLbl)
            {

            }
            column(PlateLbl; VehiclePlateCaptionLbl)
            {

            }
            column(NetWLbl; NetWeightCaptionLbl)
            {

            }
            column(VolumeLbl; VolumeCaptionLbl)
            {

            }

            // Not printed: the layout of the original report declares it; it is always empty
            // (the font-encoded barcode of the document no. is in BarCodeShipNo).
            column(Barcode; BarcodeImageText)
            {

            }
            // Logos: Company Information > Picture (left) and Chematek Customizations Setup (others)
            column(FooterLogo; CHMSetup."Footer Logo")
            {

            }
            column(LeftHeaderLogo; CompanyInfo.Picture)
            {

            }
            column(RightHeaderLogo; CHMSetup."Right Header Logo")
            {

            }
            column(Iso9001Logo; CHMSetup."ISO 9001 Logo")
            {

            }
            column(ASSICCLogo; CHMSetup."ASSICC Logo")
            {

            }
            column(ShowIso; ShowIso)
            {

            }
            // Printed in the page footer: the user who posted the return shipment.
            column(AssignedUserID; Header."User ID")
            {

            }
            column(OperatorName; OperatorName)
            {

            }
            // Reason code (DEV-005), the "causale del trasporto".
            column(ReasonCode; ReasonCodeText)
            {

            }
            column(ShippingAgent; ShippingAgentName)
            {

            }
            // Shipment from: the location the goods leave from.
            column(LocationName; LocationName)
            {

            }
            column(LocationAddress; LocationAddress)
            {

            }
            column(LocationCity; LocationCity)
            {

            }
            // The Return Shipment Header has no Order Date: the document date is used.
            column(OrderDate; Format(Header."Document Date"))
            {

            }
            column(ShptBy; ShippingAgentName)
            {

            }
            column(ShptMethod; ShipmentMethod.Description)
            {

            }
            column(PostingDate; Format(Header."Posting Date"))
            {

            }
            column(ShipmentStartingDateTime; ShipmentStartingDateTime)
            {

            }
            // Fiscal Code of the consignee (buy-from vendor).
            column(FiscalCodeNo; FiscalCodeNo)
            {

            }

            // Addresses
            // CustomerAddress = consignee (buy-from vendor), ShipToAddress = place of destination (ship-to address of
            // the return, which BC fills with the vendor / order address on a purchase return order).
            column(CustomerAddress1; VendAddr[1])
            {

            }
            column(CustomerAddress2; VendAddr[2])
            {

            }
            column(CustomerAddress3; VendAddr[3])
            {

            }
            column(CustomerAddress4; VendAddr[4])
            {

            }
            column(CustomerAddress5; VendAddr[5])
            {

            }
            column(CustomerAddress6; VendAddr[6])
            {

            }
            column(CustomerAddress7; VendAddr[7])
            {

            }
            column(CustomerAddress8; VendAddr[8])
            {

            }
            // Buy-from contact e-mail (SellToContactEmail) and pay-to contact e-mail (BillToContactEmail).
            column(SellToContactEmailLbl; BuyFromContactEmailLbl)
            {

            }
            column(BillToContactEmailLbl; PayToContactEmailLbl)
            {

            }
            column(SellToContactEmail; BuyFromContactEmail)
            {

            }
            column(SellToContactName; Header."Buy-from Contact")
            {

            }
            column(BillToContactEmail; PayToContact."E-Mail")
            {

            }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
            {

            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {

            }
            // Document title (DDT)
            column(Shipment_Lbl; TransportDocumentLbl)
            {

            }
            // Printed under the "Date" caption next to the document no.: the date of the transport document,
            // which is the posting date of the return shipment.
            column(ShipmentDate; Format(Header."Posting Date"))
            {

            }
            column(ShipmentDate_Lbl; ShipmentDateCaptionLbl)
            {

            }
            // The place of destination is mandatory on a DDT, so the ship-to box (and its caption) is always printed.
            column(ShowShippingAddress; ShowShippingAddr)
            {

            }
            column(ShipToAddress_Lbl; ShipToAddressCaptionLbl)
            {

            }
            column(ShipToAddress1; ShipToAddr[1])
            {

            }
            column(ShipToAddress2; ShipToAddr[2])
            {

            }
            column(ShipToAddress3; ShipToAddr[3])
            {

            }
            column(ShipToAddress4; ShipToAddr[4])
            {

            }
            column(ShipToAddress5; ShipToAddr[5])
            {

            }
            column(ShipToAddress6; ShipToAddr[6])
            {

            }
            column(ShipToAddress7; ShipToAddr[7])
            {

            }
            column(ShipToAddress8; ShipToAddr[8])
            {

            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {

            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {

            }
            column(DocumentCopyText; DocumentCopyText)
            {

            }
            column(DocumentDate; Format(Header."Document Date"))
            {

            }
            column(DocumentNo; Header."No.")
            {

            }
            column(DocumentNo_Lbl; DocumentNoCaptionLbl)
            {

            }
            column(SalesPersonText_Lbl; PurchaserText)
            {

            }
            // Purchaser of the return shipment.
            column(SalesPersonName; SalespersonPurchaser.Name)
            {

            }
            // Printed under "Vendor No.": the buy-from vendor.
            column(SelltoCustomerNo; Header."Buy-from Vendor No.")
            {

            }
            // Printed as the caption above the consignee (buy-from vendor) address box.
            column(SelltoCustomerNo_Lbl; ConsigneeCaptionLbl)
            {

            }
            column(VATRegistrationNo; VATRegistrationNo)
            {

            }
            column(VATRegistrationNo_Lbl; BuyFromVendor.FieldCaption("VAT Registration No."))
            {

            }
            column(Copy_Lbl; CopyLbl)
            {

            }
            column(Page_Lbl; PageLbl)
            {

            }
            column(Invoice_Lbl; InvoiceLbl)
            {

            }
            // The Return Shipment Header has no Work Description: always empty (not printed by the layout).
            column(ShowWorkDescription; ShowWorkDescription)
            {

            }
            column(DescrLav; WorkDescriptionText)
            {

            }
            column(CurrencyCode; CurrCode)
            {

            }

            // Shipment data printed in the page footer (see SetShipmentDataFields)
            column(NoOfParcels; NoOfParcels)
            {

            }
            column(GrossWeight; TotalGrossWeight) { DecimalPlaces = 0 : 5; }
            column(NetWeight; TotalNetWeight) { DecimalPlaces = 0 : 5; }
            column(Volume; TotalVolume) { DecimalPlaces = 0 : 5; }
            column(NoOfPallets; NoOfPallets)
            {

            }
            column(GoodsAppearance; GoodsAppearanceText)
            {

            }

            // Font-encoded Code 39 of the return shipment no. (not printed by the current layout).
            column(BarCodeShipNo; BarcodeShipmentNo)
            {

            }
            // Comments of the posted return shipment (header comments), printed under the lines.
            column(AppNote; AppNoteText)
            {

            }
            column(ResaDescr; ShipmentMethod.Description)
            {

            }
            // Base64 image (PNG) printed in the footer. See GetSignPicture.
            column(SignPicture; SignPictureText)
            {

            }

            // Line table captions (header row of the lines table and the rows under each line)
            column(ItemNo_Line_Lbl; LineNoCaptionLbl)
            {

            }
            column(Description_Line_Lbl; LineDescriptionCaptionLbl)
            {

            }
            column(Quantity_Line_Lbl; LineQuantityCaptionLbl)
            {

            }
            column(UnitOfMeasure_Lbl; LineUoMCaptionLbl)
            {

            }
            column(LotNo_Caption; LotNoCaptionLbl)
            {

            }
            column(CountryOfOrigin_Caption; CountryOfOriginCaptionLbl)
            {

            }
            column(Tariff_No_Caption; TariffNoCaptionLbl)
            {

            }
            column(UN_Caption; UNNoCaptionLbl)
            {

            }
            column(ADR_Class_Caption; ADRClassCaptionLbl)
            {

            }
            // Caption of Line_UnitCost.
            column(UnitPrice_Line_Lbl; LineUnitCostCaptionLbl)
            {

            }

            dataitem(Line; "Return Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");

                // The layout groups the lines table on DocumentNo + Line_LineNo.
                column(Line_LineNo; "Line No.")
                {

                }
                column(Line_Description; Description)
                {

                }
                column(Line_ItemNo; "No.")
                {

                }
                column(ShipmentDate_Line_Lbl; ShipmentDateCaptionLbl)
                {

                }
                column(Line_Quantity; Quantity) { DecimalPlaces = 0 : 5; }
                // Direct unit cost of the returned goods, in the currency of the return.
                column(Line_UnitCost; "Direct Unit Cost")
                {
                    AutoFormatType = 2;
                    AutoFormatExpression = Header."Currency Code";
                }
                column(UnitOfMeasure; "Unit of Measure")
                {

                }
                column(Line_UoMCode; "Unit of Measure Code")
                {

                }

                // Item / dangerous goods information (see GetLineItemInfo)
                column(ItemHazardousDescr; ItemHazardousDescr)
                {

                }
                column(Hazardous; Hazardous)
                {

                }
                column(TariffNo; TariffNo)
                {

                }
                column(ADRClass; ADRClass)
                {

                }
                column(ItemUN; ItemUN)
                {

                }
                column(ItemADRDescr; ItemADRDescr)
                {

                }
                column(ItemADRLabel; ItemADRLabel)
                {

                }
                column(ItemADRPackingGroup; ItemADRPackingGroup)
                {

                }
                column(ItemGalleryCode; ItemGalleryCode)
                {

                }
                column(CountryOrigin; CountryOrigin)
                {

                }

                // Lots returned on the line (posted item tracking). Filled in FillLotBuffer.
                // Quantities are in the unit of measure of the return shipment line.
                // The layout prints one row per lot under the line, only when TrackingSpecBufferLotNo is filled.
                dataitem(TrackingSpecBuffer; "Tracking Specification")
                {
                    DataItemTableView = sorting("Entry No.");
                    UseTemporary = true;

                    column(TrackingSpecBufferItemNo; "Item No.")
                    {

                    }
                    column(TrackingSpecBufferLotNo; "Lot No.")
                    {

                    }
                    column(TrackingSpecBufferDesc; Description)
                    {

                    }
                    column(TrackingSpecBufferQty; "Qty. to Handle") { DecimalPlaces = 0 : 5; }
                    column(QuantityCaption; LineQuantityCaptionLbl)
                    {

                    }
                    column(LotNoCaption; LotNoCaptionLbl)
                    {

                    }
                    column(DescriptionCaption; LineDescriptionCaptionLbl)
                    {

                    }
                    column(NoCaption; LineNoCaptionLbl)
                    {

                    }

                    trigger OnPreDataItem()
                    begin
                        TrackingSpecBuffer.SetRange("Source Ref. No.", Line."Line No.");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    Clear(SkippedLineNos);
                    MoreLines := Line.Find('+');
                    while MoreLines and (Line.Description = '') and (Line."No." = '') and (Line.Quantity = 0) do
                        MoreLines := Line.Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break();
                    Line.SetFilter("Line No.", '<=%1', Line."Line No.");
                end;

                trigger OnAfterGetRecord()
                begin
                    if SkipLine(Line) then begin
                        SkippedLineNos.Add(Line."Line No.");
                        CurrReport.Skip();
                    end;

                    GetLineItemInfo(Line);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // The return shipment is printed in the language of the user running the report, not in the
                // vendor's language (Header."Language Code"), same as the other Chematek posted documents.
                ReportLanguageCode := LanguageMgt.GetUserLanguageCode();
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(ReportLanguageCode);
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                FormatAddr.SetLanguageCode(ReportLanguageCode);

                if not IsReportInPreviewMode() then
                    Codeunit.Run(Codeunit::"Return Shipment - Printed", Header);

                if not BuyFromVendor.Get(Header."Buy-from Vendor No.") then
                    Clear(BuyFromVendor);

                FormatAddressFields();
                FormatDocumentFields();
                SetContactFields();

                if Header."Currency Code" <> '' then
                    CurrCode := Header."Currency Code"
                else
                    CurrCode := GLSetup."LCY Code";

                ShowWorkDescription := false;
                WorkDescriptionText := '';

                SetChematekHeaderFields();
                SetShipmentDataFields();
                FillLotBuffer();
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(LogInteractionReq; LogInteraction)
                    {
                        ApplicationArea = PurchReturnOrder;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                    field(DisplayAsmInformationReq; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders.';
                    }
                    field(ArchiveDocumentReq; ArchiveDocument)
                    {
                        ApplicationArea = PurchReturnOrder;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies if the document is archived after you preview or print it.';
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteraction := LogInteractionTemplateExists();
            LogInteractionEnable := LogInteraction;
        end;
    }

    rendering
    {
        layout(ReturnShipmentRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMPostedReturnShipment.rdl';
            Caption = 'Chematek Return Shipment';
            Summary = 'Chematek transport document (DDT) for goods returned to the vendor, with shipment data, lot numbers and dangerous goods information per line.';
        }
    }

    // Report parameters declared in the RDLC layout (Parameters!<Name>.Value).
    // The layout prints Page_Caption and CustomerVendorMail_Caption; the others are declared
    // because the layout declares them as parameters.
    labels
    {
        BillToAddress_Caption = 'Vendor';
        CustomerVendorContact_Caption = 'Contact';
        CustomerVendorMail_Caption = 'E-Mail';
        CustomerVendorNo_Caption = 'Vendor No.';
        DocumentNo_Caption = 'Document No.';
        FiscalCode_Caption = 'Fiscal Code';
        GoodsAppearance_Caption = 'Goods Appearance';
        GrossWeight_Caption = 'Gross Weight';
        Line_Amount_Caption = 'Amount';
        Line_Description_Caption = 'Description';
        Line_ItemNo_Caption = 'Item No.';
        Line_LineDiscountPerc_Caption = 'Disc. %';
        Line_OrderQuantity_Caption = 'Order Qty.';
        Line_Quantity_Caption = 'Quantity';
        Line_ShipmentDate_Caption = 'Shipment Date';
        Line_Type_Descr_Caption = 'Type';
        Line_UnitPrice_Caption = 'Unit Cost';
        Line_UoM_Caption = 'UoM';
        Line_VATIdentifier_Caption = 'VAT';
        NetWeightCaption = 'Net Weight';
        NoOfParcels_Caption = 'No. of Parcels';
        OperatorName_Caption = 'Operator';
        OrderConf_Title = 'Transport Document';
        OrderDate_Caption = 'Order Date';
        Our_Bank = 'Our Bank';
        Page_Caption = 'Page';
        Payment_Amount_Caption = 'Amount Due';
        Payment_DueDate_Caption = 'Due Date';
        PaymentMethod_Caption = 'Payment Method';
        PaymentTerms_Caption = 'Payment Terms';
        PostingDate_Caption = 'Posting Date';
        Reason_Caption = 'Reason';
        ReturnAddr_Caption = 'Return Address';
        Salesperson_Caption = 'Purchaser';
        ShipmentDate_Caption = 'Shipment Date';
        ShipToAddress_Caption = 'Ship-to Address';
        ShpAgent_Caption = 'Shipping Agent';
        ShptBy_Caption = 'Shipped By';
        ShptMethod_Caption = 'Shipment Method';
        ShptStart_Caption = 'Shipment Start';
        SigDriver_Caption = 'Driver Signature';
        SigRecipient_Caption = 'Recipient Signature';
        SigShpAgent_Caption = 'Shipping Agent Signature';
        Total_DocumentTotalCaption = 'Document Total';
        Total_DocumentTotalVatExclCaption = 'Total Excl. VAT';
        Total_NetAmountToPayCaption = 'Net Amount to Pay';
        Total_TotalAmountCaption = 'Total VAT';
        Total_TotalBaseCaption = 'Taxable Amount';
        Total_TotalCaption = 'Subtotal';
        Total_TotalInvDiscCaption = 'Invoice Discount Amount';
        ValidTo_Caption = 'Valid To';
        VAT_InvDisc_Caption = 'Invoice Discount';
        VAT_Line_VATIdentifier_Caption = 'VAT Code';
        VAT_VATAmount_Caption = 'VAT Amount';
        VAT_VATBase_Caption = 'VAT Base';
        VAT_VATPercent_Caption = 'VAT %';
        VAT_VATText_Caption = 'VAT Description';
        VATClausesCaption = 'VAT Clauses';
        VATRegNo_Caption = 'VAT Reg. No.';
        Volume_Caption = 'Volume';
        YourReference_Caption = 'Your Reference';
        TariffNoLbl = 'Tariff No.';
        CountryOfOriginLbl = 'Country of Origin';
        Location_Caption = 'Location';
        Targa_Caption = 'Vehicle Plate';
        Conducente_Caption = 'Driver';
        NoOfPallets_Caption = 'No. of Pallets';
        DPR_Caption = '(Presidential Decree no. 472 of 14/08/1996)';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
    end;

    trigger OnPreReport()
    begin
        if Header.GetFilters() = '' then
            Error(NoFilterSetErr);

        if not CurrReport.UseRequestPage then
            LogInteraction := LogInteractionTemplateExists();

        LoadDocumentLogos();
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if Header.FindSet() then
                repeat
                    SegManagement.LogDocument(
                      Enum::"Interaction Log Entry Document Type"::"Purch. Return Shipment".AsInteger(), Header."No.", 0, 0, Database::Vendor,
                      Header."Buy-from Vendor No.", Header."Purchaser Code", '', Header."Posting Description", '');
                until Header.Next() = 0;

        // TODO (pending decision): "Archive Document" is on the agreed request page, but a posted return shipment has
        // no standard archive (ArchiveManagement only archives open purchase documents). Implement the agreed behaviour
        // here (for example, attach the printed DDT as PDF to the posted return shipment), skipping preview mode.
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        CHMSetup: Record "CHM Customizations Setup";
        BuyFromVendor: Record Vendor;
        BuyFromContact: Record Contact;
        PayToContact: Record Contact;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        LanguageMgt: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        VendAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        SkippedLineNos: List of [Integer];
        ShowShippingAddr: Boolean;
        ShowWorkDescription: Boolean;
        MoreLines: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        ArchiveDocument: Boolean;
        ReportLanguageCode: Code[10];
        CurrCode: Text[10];
        PurchaserText: Text[50];
        BuyFromContactEmail: Text[80];
        WorkDescriptionText: Text;
        DocumentCopyText: Text;

        // Chematek header fields
        OperatorName: Text;
        LocationName: Text;
        LocationAddress: Text;
        LocationCity: Text;
        ReasonCodeText: Text;
        FiscalCodeNo: Text;
        VATRegistrationNo: Text;
        ShippingAgentName: Text;
        AppNoteText: Text;
        BarcodeShipmentNo: Text;
        BarcodeImageText: Text;
        SignPictureText: Text;
        ShowIso: Boolean;

        // Shipment data
        GoodsAppearanceText: Text;
        ShipmentStartingDateTime: Text;
        TotalGrossWeight: Decimal;
        TotalNetWeight: Decimal;
        TotalVolume: Decimal;
        NoOfParcels: Integer;
        NoOfPallets: Integer;

        // Line item / dangerous goods fields
        TariffNo: Text;
        ADRClass: Text;
        ItemUN: Text;
        ItemADRDescr: Text;
        ItemADRLabel: Text;
        ItemADRPackingGroup: Text;
        ItemGalleryCode: Text;
        ItemHazardousDescr: Text;
        Hazardous: Boolean;
        CountryOrigin: Text;

        // Lot buffer
        LotBufferEntryNo: Integer;

        // Captions
        TransportDocumentLbl: Label 'Transport Document';
        DocumentNoCaptionLbl: Label 'Document No.';
        ConsigneeCaptionLbl: Label 'Consignee';
        ShipToAddressCaptionLbl: Label 'Ship-to Address';
        DateCaptionLbl: Label 'Date';
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        ReasonCaptionLbl: Label 'Reason';
        VendorNoCaptionLbl: Label 'Vendor No.';
        ContactCaptionLbl: Label 'Contact';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        FiscalCodeCaptionLbl: Label 'Fiscal Code';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        PaymentMethodCaptionLbl: Label 'Payment Method';
        PurchaserCaptionLbl: Label 'Purchaser';
        OperatorCaptionLbl: Label 'Operator';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        ShipmentFromCaptionLbl: Label 'Shipment from';
        ShippingAgentCaptionLbl: Label 'Shipping Agent';
        GoodsAppearanceCaptionLbl: Label 'Goods Appearance';
        NoOfParcelsCaptionLbl: Label 'No. of Parcels';
        NoOfPalletsCaptionLbl: Label 'No. of Pallets';
        NetWeightCaptionLbl: Label 'Net Weight';
        GrossWeightCaptionLbl: Label 'Gross Weight';
        VolumeCaptionLbl: Label 'Volume';
        TransportStartCaptionLbl: Label 'Transport Start Date/Time';
        VehiclePlateCaptionLbl: Label 'Vehicle Plate';
        DriverCaptionLbl: Label 'Driver';
        DriverSignatureCaptionLbl: Label 'Driver Signature';
        CarrierSignatureCaptionLbl: Label 'Carrier Signature';
        RecipientSignatureCaptionLbl: Label 'Recipient Signature';
        LineNoCaptionLbl: Label 'Item No.';
        LineDescriptionCaptionLbl: Label 'Description';
        LineQuantityCaptionLbl: Label 'Quantity';
        LineUoMCaptionLbl: Label 'UoM';
        LineUnitCostCaptionLbl: Label 'Unit Cost';
        LotNoCaptionLbl: Label 'Lot No.';
        CountryOfOriginCaptionLbl: Label 'Country of Origin:';
        TariffNoCaptionLbl: Label 'Tariff No.:';
        UNNoCaptionLbl: Label 'UN No.:';
        ADRClassCaptionLbl: Label 'ADR Class:';
        BuyFromContactEmailLbl: Label 'Buy-from Contact E-Mail';
        PayToContactEmailLbl: Label 'Pay-to Contact E-Mail';
        CopyLbl: Label 'Copy';
        PageLbl: Label 'Page';
        InvoiceLbl: Label 'Invoice';
        DateTimeTok: Label '%1 %2', Locked = true;
        Code39CharsTok: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-. $/+%', Locked = true;
        ShippingAgentCodeFieldTok: Label 'Shipping Agent Code', Locked = true;
        ShippingStartingDateFieldTok: Label 'Shipping Starting Date', Locked = true;
        ShippingStartingTimeFieldTok: Label 'Shipping Starting Time', Locked = true;
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidentally printing all documents.';

    /// <summary>
    /// Initializes the request options when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean; NewArchiveDocument: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
        ArchiveDocument := NewArchiveDocument;
    end;

    local procedure LogInteractionTemplateExists(): Boolean
    begin
        exit(SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Purch. Return Shipment") <> '');
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields()
    begin
        // Consignee (destinatario): the buy-from vendor. Place of destination: the ship-to address of the return.
        FormatAddr.PurchShptBuyFrom(VendAddr, Header);
        FormatAddr.PurchShptShipTo(ShipToAddr, Header);
        ShowShippingAddr := true;
    end;

    local procedure FormatDocumentFields()
    begin
        FormatDocument.SetPurchaser(SalespersonPurchaser, Header."Purchaser Code", PurchaserText);
        FormatDocument.SetPaymentTerms(PaymentTerms, Header."Payment Terms Code", ReportLanguageCode);
        FormatDocument.SetPaymentMethod(PaymentMethod, Header."Payment Method Code", ReportLanguageCode);
        FormatDocument.SetShipmentMethod(ShipmentMethod, Header."Shipment Method Code", ReportLanguageCode);
    end;

    local procedure SetContactFields()
    begin
        // Buy-from contact e-mail, otherwise the vendor e-mail.
        Clear(BuyFromContact);
        Clear(PayToContact);
        if BuyFromContact.Get(Header."Buy-from Contact No.") then;
        if PayToContact.Get(Header."Pay-to Contact No.") then;
        BuyFromContactEmail := BuyFromContact."E-Mail";
        if BuyFromContactEmail = '' then
            BuyFromContactEmail := BuyFromVendor."E-Mail";
    end;

    local procedure SetChematekHeaderFields()
    var
        Location: Record Location;
        ReasonCode: Record "Reason Code";
    begin
        // Operator: the user who posted the return shipment.
        OperatorName := GetUserFullName(Header."User ID");

        // Shipment from: the location the goods leave from.
        LocationName := '';
        LocationAddress := '';
        LocationCity := '';
        if Header."Location Code" <> '' then
            if Location.Get(Header."Location Code") then begin
                LocationName := Location.Name;
                LocationAddress := Location.Address;
                if Location."Address 2" <> '' then
                    LocationAddress += ' ' + Location."Address 2";
                LocationCity := DelChr(Location."Post Code" + ' ' + Location.City, '<>', ' ');
                if Location.County <> '' then
                    LocationCity += ' (' + Location.County + ')';
            end;

        // Reason code (DEV-005), the "causale del trasporto": print the description, fall back to the code.
        // It flows from the Purchase Return Order to the posted return shipment (standard field).
        ReasonCodeText := Header."Reason Code";
        if Header."Reason Code" <> '' then
            if ReasonCode.Get(Header."Reason Code") then
                if ReasonCode.Description <> '' then
                    ReasonCodeText := ReasonCode.Description;

        ShippingAgentName := GetShippingAgentName();

        // VAT Reg. No. and Fiscal Code of the consignee (buy-from vendor).
        VATRegistrationNo := Header."VAT Registration No.";
        if VATRegistrationNo = '' then
            VATRegistrationNo := BuyFromVendor."VAT Registration No.";
        FiscalCodeNo := GetVendorFiscalCode(Header."Buy-from Vendor No.");

        AppNoteText := GetReturnShipmentComments();
        BarcodeShipmentNo := EncodeCode39(Header."No.");
        BarcodeImageText := '';
        SignPictureText := GetSignPicture();
    end;

    local procedure GetShippingAgentName(): Text
    var
        ShippingAgent: Record "Shipping Agent";
        CHMManagement: Codeunit "CHM Management";
        ShippingAgentCode: Code[10];
    begin
        // The W1 Return Shipment Header has no Shipping Agent; the Italian localization adds "Shipping Agent Code".
        // The field is read by name (same as report 66606 "CHM Purchase Order"), so the report compiles and runs on
        // both versions and prints the carrier automatically where the field exists. Prints the agent name, else the code.
        ShippingAgentCode := CopyStr(CHMManagement.GetFieldValueByName(Header, Database::"Return Shipment Header", ShippingAgentCodeFieldTok), 1, MaxStrLen(ShippingAgentCode));
        if ShippingAgentCode = '' then
            exit('');
        if ShippingAgent.Get(ShippingAgentCode) then
            if ShippingAgent.Name <> '' then
                exit(ShippingAgent.Name);
        exit(ShippingAgentCode);
    end;

    local procedure SetShipmentDataFields()
    var
        ReturnShipmentLine: Record "Return Shipment Line";
    begin
        // TODO (pending decision): the shipment data of DEV-001 / DEV-002 (weights, parcels, pallets, volume, goods
        // appearance) exists only on the Posted Sales Shipment, not on the Posted Return Shipment.
        // Until the agreed source is confirmed, weights, volume and parcels are calculated from the lines, the same way
        // as the standard purchase statistics (item card values copied to the line x quantity).
        // Pallets and goods appearance have no standard source and are left blank, to be filled in by hand.
        TotalGrossWeight := 0;
        TotalNetWeight := 0;
        TotalVolume := 0;
        NoOfParcels := 0;
        NoOfPallets := 0;
        GoodsAppearanceText := '';

        // Correction lines (Undo Return Shipment) are included: they cancel the quantity of the undone line.
        ReturnShipmentLine.SetRange("Document No.", Header."No.");
        ReturnShipmentLine.SetFilter(Type, '<>%1', ReturnShipmentLine.Type::" ");
        ReturnShipmentLine.SetFilter(Quantity, '<>0');
        if ReturnShipmentLine.FindSet() then
            repeat
                TotalGrossWeight += ReturnShipmentLine.Quantity * ReturnShipmentLine."Gross Weight";
                TotalNetWeight += ReturnShipmentLine.Quantity * ReturnShipmentLine."Net Weight";
                TotalVolume += ReturnShipmentLine.Quantity * ReturnShipmentLine."Unit Volume";
                if ReturnShipmentLine."Units per Parcel" > 0 then
                    NoOfParcels += Round(ReturnShipmentLine.Quantity / ReturnShipmentLine."Units per Parcel", 1, '>');
            until ReturnShipmentLine.Next() = 0;

        TotalGrossWeight := Round(TotalGrossWeight, 0.00001);
        TotalNetWeight := Round(TotalNetWeight, 0.00001);
        TotalVolume := Round(TotalVolume, 0.00001);
        if NoOfParcels < 0 then
            NoOfParcels := 0;

        ShipmentStartingDateTime := GetTransportStartDateTime();
    end;

    local procedure GetTransportStartDateTime(): Text
    var
        CHMManagement: Codeunit "CHM Management";
        StartingDateText: Text;
        StartingTimeText: Text;
    begin
        // Standard W1 has no transport start date / time on the return shipment. The Italian localization adds
        // "Shipping Starting Date" / "Shipping Starting Time", read by name so the extension compiles without a
        // dependency on the IT base app. When the fields do not exist or are blank, the value is left blank,
        // to be filled in by hand.
        StartingDateText := CHMManagement.GetFieldValueByName(Header, Database::"Return Shipment Header", ShippingStartingDateFieldTok);
        StartingTimeText := CHMManagement.GetFieldValueByName(Header, Database::"Return Shipment Header", ShippingStartingTimeFieldTok);
        if StartingDateText = '' then
            exit('');
        if StartingTimeText = '' then
            exit(StartingDateText);
        exit(StrSubstNo(DateTimeTok, StartingDateText, StartingTimeText));
    end;

    local procedure GetReturnShipmentComments() Result: Text
    var
        PurchCommentLine: Record "Purch. Comment Line";
        TypeHelper: Codeunit "Type Helper";
    begin
        // Header comments of the posted return shipment (Comments action on the Posted Return Shipment).
        PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Posted Return Shipment");
        PurchCommentLine.SetRange("No.", Header."No.");
        PurchCommentLine.SetRange("Document Line No.", 0);
        if PurchCommentLine.FindSet() then
            repeat
                if PurchCommentLine.Comment <> '' then begin
                    if Result <> '' then
                        Result += TypeHelper.CRLFSeparator();
                    Result += PurchCommentLine.Comment;
                end;
            until PurchCommentLine.Next() = 0;
    end;

    local procedure GetSignPicture(): Text
    begin
        // TODO (pending decision): the layout prints a signature image (PNG, base64) in the footer. Standard BC
        // has no signature image; fill this from the agreed source. Until then nothing is printed.
        exit('');
    end;

    local procedure GetUserFullName(UserName: Code[50]): Text
    var
        User: Record User;
    begin
        if UserName = '' then
            exit('');
        User.SetRange("User Name", UserName);
        if User.FindFirst() then
            if User."Full Name" <> '' then
                exit(User."Full Name");
        exit(UserName);
    end;

    local procedure GetVendorFiscalCode(VendorNo: Code[20]): Text
    var
        CHMManagement: Codeunit "CHM Management";
    begin
        // Fiscal Code from the vendor card (Italian localization field, see codeunit 66602 "CHM Management").
        exit(CHMManagement.GetVendorFiscalCode(VendorNo));
    end;

    local procedure SkipLine(ReturnShipmentLine: Record "Return Shipment Line"): Boolean
    begin
        // Correction lines (Undo Return Shipment) are not printed, same as the standard report.
        if ReturnShipmentLine.Correction then
            exit(true);
        // A DDT lists only the goods that were shipped: lines without quantity are not printed,
        // and neither are the comment / extended text lines attached to them.
        if (ReturnShipmentLine.Type <> ReturnShipmentLine.Type::" ") and (ReturnShipmentLine.Quantity = 0) then
            exit(true);
        if ReturnShipmentLine."Attached to Line No." <> 0 then
            if SkippedLineNos.Contains(ReturnShipmentLine."Attached to Line No.") then
                exit(true);
        exit(false);
    end;

    local procedure GetLineItemInfo(ReturnShipmentLine: Record "Return Shipment Line")
    var
        Item: Record Item;
        CountryRegion: Record "Country/Region";
    begin
        Hazardous := false;
        ItemHazardousDescr := '';
        ADRClass := '';
        ItemUN := '';
        ItemADRDescr := '';
        ItemADRLabel := '';
        ItemADRPackingGroup := '';
        ItemGalleryCode := '';
        TariffNo := '';
        CountryOrigin := '';

        if ReturnShipmentLine.Type <> ReturnShipmentLine.Type::Item then
            exit;
        if not Item.Get(ReturnShipmentLine."No.") then
            exit;

        TariffNo := Item."Tariff No.";
        if Item."Country/Region of Origin Code" <> '' then begin
            CountryOrigin := Item."Country/Region of Origin Code";
            if CountryRegion.Get(Item."Country/Region of Origin Code") then
                if CountryRegion.Name <> '' then
                    CountryOrigin := CountryRegion.Name;
        end;

        GetItemDangerousGoodsInfo(Item);
    end;

    local procedure GetItemDangerousGoodsInfo(Item: Record Item)
    begin
        // TODO (pending decision): standard BC has no dangerous goods fields on the item.
        // Fill Hazardous, ItemHazardousDescr, ADRClass, ItemUN, ItemADRDescr, ItemADRLabel,
        // ItemADRPackingGroup and ItemGalleryCode from the agreed source (same as the other Chematek reports).
        // Until then the ADR / UN rows under the line are not printed.
    end;

    local procedure FillLotBuffer()
    var
        ReturnShipmentLine: Record "Return Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Lots returned on each item line, taken from the item ledger entries of the line.
        // Return shipment entries are negative (goods leave the warehouse), so the absolute quantity is printed.
        TrackingSpecBuffer.Reset();
        TrackingSpecBuffer.DeleteAll();
        LotBufferEntryNo := 0;

        ReturnShipmentLine.SetRange("Document No.", Header."No.");
        ReturnShipmentLine.SetRange(Type, ReturnShipmentLine.Type::Item);
        ReturnShipmentLine.SetFilter("No.", '<>%1', '');
        ReturnShipmentLine.SetFilter(Quantity, '<>0');
        if not ReturnShipmentLine.FindSet() then
            exit;
        repeat
            ItemLedgerEntry.SetRange("Document No.", ReturnShipmentLine."Document No.");
            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Purchase Return Shipment");
            ItemLedgerEntry.SetRange("Document Line No.", ReturnShipmentLine."Line No.");
            ItemLedgerEntry.SetRange("Item No.", ReturnShipmentLine."No.");
            ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
            if ItemLedgerEntry.FindSet() then
                repeat
                    AddLotToBuffer(ReturnShipmentLine, ItemLedgerEntry."Lot No.", Abs(ItemLedgerEntry.Quantity));
                until ItemLedgerEntry.Next() = 0;
        until ReturnShipmentLine.Next() = 0;
    end;

    local procedure AddLotToBuffer(ReturnShipmentLine: Record "Return Shipment Line"; LotNo: Code[50]; QtyBase: Decimal)
    begin
        if QtyBase = 0 then
            exit;

        // One row per return shipment line and lot.
        TrackingSpecBuffer.Reset();
        TrackingSpecBuffer.SetRange("Source Ref. No.", ReturnShipmentLine."Line No.");
        TrackingSpecBuffer.SetRange("Lot No.", LotNo);
        if TrackingSpecBuffer.FindFirst() then begin
            TrackingSpecBuffer."Quantity (Base)" += QtyBase;
            TrackingSpecBuffer."Qty. to Handle" := CalcLineQty(TrackingSpecBuffer."Quantity (Base)", ReturnShipmentLine."Qty. per Unit of Measure");
            TrackingSpecBuffer.Modify();
        end else begin
            LotBufferEntryNo += 1;
            TrackingSpecBuffer.Init();
            TrackingSpecBuffer."Entry No." := LotBufferEntryNo;
            TrackingSpecBuffer."Source Type" := Database::"Return Shipment Line";
            TrackingSpecBuffer."Source ID" := ReturnShipmentLine."Document No.";
            TrackingSpecBuffer."Source Ref. No." := ReturnShipmentLine."Line No.";
            TrackingSpecBuffer."Item No." := ReturnShipmentLine."No.";
            TrackingSpecBuffer."Variant Code" := ReturnShipmentLine."Variant Code";
            TrackingSpecBuffer.Description := ReturnShipmentLine.Description;
            TrackingSpecBuffer."Lot No." := LotNo;
            TrackingSpecBuffer."Qty. per Unit of Measure" := ReturnShipmentLine."Qty. per Unit of Measure";
            TrackingSpecBuffer."Quantity (Base)" := QtyBase;
            TrackingSpecBuffer."Qty. to Handle" := CalcLineQty(QtyBase, ReturnShipmentLine."Qty. per Unit of Measure");
            TrackingSpecBuffer.Insert();
        end;
        TrackingSpecBuffer.Reset();
    end;

    local procedure CalcLineQty(QtyBase: Decimal; QtyPerUoM: Decimal): Decimal
    begin
        if QtyPerUoM = 0 then
            exit(QtyBase);
        exit(Round(QtyBase / QtyPerUoM, 0.00001));
    end;

    local procedure EncodeCode39(Value: Text): Text
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
    begin
        // Font-encoded Code 39 of the return shipment no. (same as report 66600 "CHM Michelin Labels").
        // Code 39 supports only upper-case letters, digits and - . space $ / + %
        Value := UpperCase(Value);
        Value := DelChr(Value, '=', DelChr(Value, '=', Code39CharsTok));
        if Value = '' then
            exit('');

        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        exit(BarcodeFontProvider.EncodeFont(Value, BarcodeSymbology));
    end;

    local procedure LoadDocumentLogos()
    begin
        CHMSetup.SetAutoCalcFields("Right Header Logo", "Footer Logo", "ISO 9001 Logo", "ASSICC Logo");
        if not CHMSetup.Get() then
            CHMSetup.Init();
        // Show ISO controls the ISO certification text (certificate number / revision) in the footer.
        ShowIso := CHMSetup."Show ISO";
    end;
}
