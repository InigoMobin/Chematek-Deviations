report 66608 "CHM Return Shipment"
{
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
            column(ShptByLbl; ShippingAgentCaptionLbl)
            {
            }
            column(ShptMethodLbl; ShipmentMethodCaptionLbl)
            {
            }
            column(ReasonCaption; ReasonCaptionLbl)
            {
            }
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
            column(Barcode; BarcodeImageText)
            {
            }
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
            column(AssignedUserID; Header."User ID")
            {
            }
            column(OperatorName; OperatorName)
            {
            }
            column(ReasonCode; ReasonCodeText)
            {
            }
            column(ShippingAgent; ShippingAgentName)
            {
            }
            column(LocationName; LocationName)
            {
            }
            column(LocationAddress; LocationAddress)
            {
            }
            column(LocationCity; LocationCity)
            {
            }
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
            column(FiscalCodeNo; FiscalCodeNo)
            {
            }
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
            column(Shipment_Lbl; TransportDocumentLbl)
            {
            }
            column(ShipmentDate; Format(Header."Posting Date"))
            {
            }
            column(ShipmentDate_Lbl; ShipmentDateCaptionLbl)
            {
            }
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
            column(SalesPersonName; SalespersonPurchaser.Name)
            {
            }
            column(SelltoCustomerNo; Header."Buy-from Vendor No.")
            {
            }
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
            column(ShowWorkDescription; ShowWorkDescription)
            {
            }
            column(DescrLav; WorkDescriptionText)
            {
            }
            column(CurrencyCode; CurrCode)
            {
            }
            column(NoOfParcels; NoOfParcels)
            {
            }
            column(GrossWeight; TotalGrossWeight)
            {
                DecimalPlaces = 0 : 5;
            }
            column(NetWeight; TotalNetWeight)
            {
                DecimalPlaces = 0 : 5;
            }
            column(Volume; TotalVolume)
            {
                DecimalPlaces = 0 : 5;
            }
            column(NoOfPallets; NoOfPallets)
            {
            }
            column(GoodsAppearance; GoodsAppearanceText)
            {
            }
            column(BarCodeShipNo; BarcodeShipmentNo)
            {
            }
            column(AppNote; AppNoteText)
            {
            }
            column(ResaDescr; ShipmentMethod.Description)
            {
            }
            column(SignPicture; SignPictureText)
            {
            }
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
            column(UnitPrice_Line_Lbl; LineUnitCostCaptionLbl)
            {
            }
            dataitem(Line; "Return Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");

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
                column(Line_Quantity; Quantity)
                {
                    DecimalPlaces = 0 : 5;
                }
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
                    column(TrackingSpecBufferQty; "Qty. to Handle")
                    {
                        DecimalPlaces = 0 : 5;
                    }
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
                ReportLanguageCode := LanguageMgt.GetUserLanguageCode();
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(ReportLanguageCode);
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                FormatAddr.SetLanguageCode(ReportLanguageCode);

                if not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) then
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
                CHMMgmt.FillReturnShipmentLotBuffer(Header."No.", TrackingSpecBuffer);
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
                }
            }
        }

        trigger OnInit()
        begin
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Purch. Return Shipment");
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
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Purch. Return Shipment");

        CHMMgmt.GetDocumentSetup(CHMSetup);
        ShowIso := CHMSetup."Show ISO";
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) then
            if Header.FindSet() then
                repeat
                    SegManagement.LogDocument(
                      Enum::"Interaction Log Entry Document Type"::"Purch. Return Shipment".AsInteger(), Header."No.", 0, 0, Database::Vendor,
                      Header."Buy-from Vendor No.", Header."Purchaser Code", '', Header."Posting Description", '');
                until Header.Next() = 0;
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
        CHMMgmt: Codeunit "CHM Customization Mgmt.";
        VendAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        SkippedLineNos: List of [Integer];
        ShowShippingAddr: Boolean;
        ShowWorkDescription: Boolean;
        MoreLines: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        ReportLanguageCode: Code[10];
        CurrCode: Text[10];
        PurchaserText: Text[50];
        BuyFromContactEmail: Text[80];
        WorkDescriptionText: Text;
        DocumentCopyText: Text;
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
        GoodsAppearanceText: Text;
        ShipmentStartingDateTime: Text;
        TotalGrossWeight: Decimal;
        TotalNetWeight: Decimal;
        TotalVolume: Decimal;
        NoOfParcels: Integer;
        NoOfPallets: Integer;
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
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidentally printing all documents.';

    /// <summary>
    /// Sets the request options, including archiving, when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean; NewArchiveDocument: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    /// <summary>
    /// Formats the consignee (buy-from vendor) and place of destination (ship-to) addresses.
    /// </summary>
    local procedure FormatAddressFields()
    begin
        FormatAddr.PurchShptBuyFrom(VendAddr, Header);
        FormatAddr.PurchShptShipTo(ShipToAddr, Header);
        ShowShippingAddr := true;
    end;

    /// <summary>
    /// Sets the salesperson / purchaser, payment terms, payment method and shipment method texts printed on the document.
    /// </summary>
    local procedure FormatDocumentFields()
    begin
        FormatDocument.SetPurchaser(SalespersonPurchaser, Header."Purchaser Code", PurchaserText);
        FormatDocument.SetPaymentTerms(PaymentTerms, Header."Payment Terms Code", ReportLanguageCode);
        FormatDocument.SetPaymentMethod(PaymentMethod, Header."Payment Method Code", ReportLanguageCode);
        FormatDocument.SetShipmentMethod(ShipmentMethod, Header."Shipment Method Code", ReportLanguageCode);
    end;

    /// <summary>
    /// Sets the buy-from and pay-to contacts and the contact e-mail printed on the document.
    /// </summary>
    local procedure SetContactFields()
    begin
        Clear(BuyFromContact);
        Clear(PayToContact);
        if BuyFromContact.Get(Header."Buy-from Contact No.") then;
        if PayToContact.Get(Header."Pay-to Contact No.") then;
        BuyFromContactEmail := BuyFromContact."E-Mail";
        if BuyFromContactEmail = '' then
            BuyFromContactEmail := BuyFromVendor."E-Mail";
    end;

    /// <summary>
    /// Fills the Chematek header fields of the DDT: operator, shipment from, reason code, carrier, VAT / fiscal code, comments, barcode and signature.
    /// </summary>
    local procedure SetChematekHeaderFields()
    begin
        OperatorName := CHMMgmt.GetUserFullName(Header."User ID");
        CHMMgmt.GetLocationAddress(Header."Location Code", LocationName, LocationAddress, LocationCity);
        ReasonCodeText := CHMMgmt.GetReasonCodeText(Header."Reason Code");
        ShippingAgentName := CHMMgmt.GetShippingAgentName(Header."Shipping Agent Code");

        VATRegistrationNo := Header."VAT Registration No.";
        if VATRegistrationNo = '' then
            VATRegistrationNo := BuyFromVendor."VAT Registration No.";
        FiscalCodeNo := CHMMgmt.GetVendorFiscalCode(Header."Buy-from Vendor No.");

        AppNoteText := CHMMgmt.GetReturnShipmentComments(Header."No.");
        BarcodeShipmentNo := CHMMgmt.EncodeCode39(Header."No.");
        BarcodeImageText := '';
        SignPictureText := CHMMgmt.GetSignPicture();
    end;

    /// <summary>
    /// Fills the shipment data of the DDT: weights, volume, parcels, pallets, goods appearance and transport start.
    /// </summary>
    local procedure SetShipmentDataFields()
    begin
        CHMMgmt.CalcReturnShipmentTotals(Header, TotalGrossWeight, TotalNetWeight, TotalVolume, NoOfParcels, NoOfPallets);
        GoodsAppearanceText := CHMMgmt.GetGoodsAppearanceText(Header."CHM Goods Appearance");
        ShipmentStartingDateTime := CHMMgmt.GetTransportStartDateTime(Header);
    end;

    /// <summary>
    /// Returns true for lines that are not printed on the DDT: corrections, lines without quantity and the lines attached to them.
    /// </summary>
    local procedure SkipLine(ReturnShipmentLine: Record "Return Shipment Line"): Boolean
    begin
        if ReturnShipmentLine.Correction then
            exit(true);
        if (ReturnShipmentLine.Type <> ReturnShipmentLine.Type::" ") and (ReturnShipmentLine.Quantity = 0) then
            exit(true);
        if ReturnShipmentLine."Attached to Line No." <> 0 then
            if SkippedLineNos.Contains(ReturnShipmentLine."Attached to Line No.") then
                exit(true);
        exit(false);
    end;

    /// <summary>
    /// Fills the item data printed under the line: tariff no., country of origin and dangerous goods data.
    /// </summary>
    local procedure GetLineItemInfo(ReturnShipmentLine: Record "Return Shipment Line")
    var
        Item: Record Item;
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

        CHMMgmt.GetItemCustomsInfo(Item, TariffNo, CountryOrigin);
        CHMMgmt.GetItemDangerousGoodsInfo(Item, Hazardous, ItemHazardousDescr, ADRClass, ItemUN, ItemADRDescr, ItemADRLabel, ItemADRPackingGroup, ItemGalleryCode);
    end;
}
