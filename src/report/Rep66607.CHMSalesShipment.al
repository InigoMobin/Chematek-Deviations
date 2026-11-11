report 66607 "CHM Sales Shipment"
{
    Caption = 'CHM Sales Shipment';
    UsageCategory = None;
    DefaultRenderingLayout = SalesShipmentRDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Header; "Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Posted Sales Shipment';

            column(SelltoCustomerNo_Lbl; ConsigneeCaptionLbl)
            {
            }
            column(CustomerAddress1; CustAddr[1])
            {
            }
            column(CustomerAddress2; CustAddr[2])
            {
            }
            column(CustomerAddress3; CustAddr[3])
            {
            }
            column(CustomerAddress4; CustAddr[4])
            {
            }
            column(CustomerAddress5; CustAddr[5])
            {
            }
            column(CustomerAddress6; CustAddr[6])
            {
            }
            column(CustomerAddress7; CustAddr[7])
            {
            }
            column(CustomerAddress8; CustAddr[8])
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
            column(PaymentTermsDescription_Lbl; PaymentTermsCaptionLbl)
            {
            }
            column(PaymentMethodDescription_Lbl; PaymentMethodCaptionLbl)
            {
            }
            column(OurBankAccountLbl; OurBankCaptionLbl)
            {
            }
            column(SalesPerson_Lbl; SalespersonCaptionLbl)
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
            column(CustomerVendorNoLbl; CustomerNoCaptionLbl)
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
            column(SelltoCustomerNo; Header."Sell-to Customer No.")
            {
            }
            column(Barcode; BarcodeImageText)
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
            column(LocationName; LocationName)
            {
            }
            column(LocationAddress; LocationAddress)
            {
            }
            column(LocationCity; LocationCity)
            {
            }
            column(FiscalCodeNo; FiscalCodeNo)
            {
            }
            column(DocumentNo; Header."No.")
            {
            }
            column(SalesPersonName; SalespersonPurchaser.Name)
            {
            }
            column(OperatorName; OperatorName)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(SellToContactEmail; SellToContactEmail)
            {
            }
            column(SellToContactName; Header."Sell-to Contact")
            {
            }
            column(ShipmentDate; Format(Header."Posting Date"))
            {
            }
            column(OurBankAccount; OurBankAccountText)
            {
            }
            column(SellToContactEmailLbl; SellToContactEmailLbl)
            {
            }
            column(VATRegistrationNo; VATRegistrationNo)
            {
            }
            column(ShptMethod; ShipmentMethod.Description)
            {
            }
            column(ShippingAgent; ShippingAgentName)
            {
            }
            column(ReasonCode; ReasonCodeText)
            {
            }
            column(FooterLogo; CHMSetup."Footer Logo")
            {
            }
            column(GoodsAppearance; GoodsAppearanceText)
            {
            }
            column(NoOfParcels; Header."CHM Total Parcel")
            {
            }
            column(GrossWeight; Header."CHM Total Gross Weight")
            {
                DecimalPlaces = 0 : 5;
            }
            column(NetWeight; Header."CHM Total Net Weight")
            {
                DecimalPlaces = 0 : 5;
            }
            column(Volume; Header."CHM Non-reusable Packaging")
            {
                DecimalPlaces = 0 : 5;
            }
            column(NoOfPallets; Header."CHM Total Pallet")
            {
            }
            column(ShipmentStartingDateTime; ShipmentStartingDateTime)
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
            column(PlasticLbl; NonReusablePackagingCaptionLbl)
            {
            }
            column(ShowPlastic; ShowPlastic)
            {
            }
            column(AssignedUserID; Header."User ID")
            {
            }
            column(OrderDate; Format(Header."Order Date"))
            {
            }
            column(ShptBy; ShippingAgentName)
            {
            }
            column(PostingDate; Format(Header."Posting Date"))
            {
            }
            column(RequestedDeliveryDate; Format(Header."Requested Delivery Date"))
            {
            }
            column(BillToContactEmailLbl; BillToContactEmailLbl)
            {
            }
            column(BillToContactEmail; BillToContact."E-Mail")
            {
            }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
            {
            }
            column(YourReference; Header."Your Reference")
            {
            }
            column(YourReference_Lbl; Header.FieldCaption("Your Reference"))
            {
            }
            column(ShipmentMethodDescription; ShipmentMethod.Description)
            {
            }
            column(Shipment_Lbl; TransportDocumentLbl)
            {
            }
            column(ShipmentDate_Lbl; Header.FieldCaption("Shipment Date"))
            {
            }
            column(ShowShippingAddress; ShowShippingAddr)
            {
            }
            column(DocumentCopyText; DocumentCopyText)
            {
            }
            column(BilltoCustumerNo; Header."Bill-to Customer No.")
            {
            }
            column(BilltoCustomerNo_Lbl; Header.FieldCaption("Bill-to Customer No."))
            {
            }
            column(DocumentDate; Format(Header."Document Date"))
            {
            }
            column(DocumentDate_Lbl; Header.FieldCaption("Document Date"))
            {
            }
            column(DueDate; Format(Header."Due Date"))
            {
            }
            column(DueDate_Lbl; Header.FieldCaption("Due Date"))
            {
            }
            column(DocumentNo_Lbl; DocumentNoCaptionLbl)
            {
            }
            column(QuoteNo; Header."Quote No.")
            {
            }
            column(QuoteNo_Lbl; Header.FieldCaption("Quote No."))
            {
            }
            column(SalesPersonText_Lbl; SalesPersonText)
            {
            }
            column(VATRegistrationNo_Lbl; SellToCust.FieldCaption("VAT Registration No."))
            {
            }
            column(GlobalLocationNumber; SellToCust.GLN)
            {
            }
            column(GlobalLocationNumber_Lbl; SellToCust.FieldCaption(GLN))
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
            column(ExtDocNo_SalesHeader; Header."External Document No.")
            {
            }
            column(ExtDocNo_SalesHeader_Lbl; Header.FieldCaption("External Document No."))
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
            column(BillAndShipSame; BillAndShipSame)
            {
            }
            column(gLocationDesc; LocationName)
            {
            }
            column(WorkDescriptionLine; WorkDescriptionText)
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
            dataitem(Line; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");

                column(Line_ItemNo; "No.")
                {
                }
                column(Line_Description; Description)
                {
                }
                column(Line_Quantity; Quantity)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Line_UoMCode; "Unit of Measure Code")
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
                column(Line_Type; Type.AsInteger())
                {
                }
                column(Line_LineNo; "Line No.")
                {
                }
                column(Line_RequestedDeliveryDate; Format("Requested Delivery Date"))
                {
                }
                column(Line_ShipmentDate; Format("Shipment Date"))
                {
                }
                column(ShipmentDate_Line_Lbl; FieldCaption("Shipment Date"))
                {
                }
                column(Line_PlannedShipmentDate; Format("Planned Shipment Date"))
                {
                }
                column(PlannedShipmentDate_Line_Lbl; FieldCaption("Planned Shipment Date"))
                {
                }
                column(Type_Line; Format(Type))
                {
                }
                column(UnitOfMeasure; "Unit of Measure")
                {
                }
                column(ItemReferenceNo; "Item Reference No.")
                {
                }
                column(ItemReferenceNo_Lbl; FieldCaption("Item Reference No."))
                {
                }
                column(ItemHazardousDescr; ItemHazardousDescr)
                {
                }
                column(Hazardous; Hazardous)
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
                    column(TrackingSpecBufferPackageNo; "Package No.")
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
                    column(PackageNoCaptionLbl; PackageNoCaptionText)
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

                    trigger OnAfterGetRecord()
                    begin
                        if TrackingSpecBuffer."Package No." <> '' then
                            PackageNoCaptionText := PackageNoCaptionLbl
                        else
                            PackageNoCaptionText := '';
                    end;
                }
                dataitem(AssemblyLine; "Posted Assembly Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.");

                    column(LineNo_AssemblyLine; "No.")
                    {
                    }
                    column(Description_AssemblyLine; Description)
                    {
                    }
                    column(Quantity_AssemblyLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(UnitOfMeasure_AssemblyLine; CHMMgmt.GetUOMText("Unit of Measure Code"))
                    {
                    }
                    column(VariantCode_AssemblyLine; "Variant Code")
                    {
                    }

                    trigger OnPreDataItem()
                    var
                        PostedAsmHeader: Record "Posted Assembly Header";
                    begin
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        if not Line.AsmToShipmentExists(PostedAsmHeader) then
                            CurrReport.Break();
                        AssemblyLine.SetRange("Document No.", PostedAsmHeader."No.");
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
                    Codeunit.Run(Codeunit::"Sales Shpt.-Printed", Header);

                FormatAddressFields();
                FormatDocumentFields();

                Clear(SellToContact);
                Clear(BillToContact);
                if SellToContact.Get(Header."Sell-to Contact No.") then;
                if BillToContact.Get(Header."Bill-to Contact No.") then;
                SellToContactEmail := SellToContact."E-Mail";
                if SellToContactEmail = '' then
                    SellToContactEmail := Header."Sell-to E-Mail";

                if not SellToCust.Get(Header."Sell-to Customer No.") then
                    Clear(SellToCust);

                CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);
                OurBankAccountText := CHMMgmt.GetBankAccountText(CompanyBankAccount);

                if Header."Currency Code" <> '' then
                    CurrCode := Header."Currency Code"
                else
                    CurrCode := GLSetup."LCY Code";

                ShowWorkDescription := CHMMgmt.GetSalesShipmentWorkDescription(Header, WorkDescriptionText);
                SetChematekHeaderFields();
                SetShipmentDataFields();
                CHMMgmt.FillSalesShipmentLotBuffer(Header."No.", TrackingSpecBuffer);
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
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                    field(DisplayAsmInformationReq; DisplayAssemblyInformation)
                    {
                        ApplicationArea = Assembly;
                        Caption = 'Show Assembly Components';
                        ToolTip = 'Specifies if you want the report to include information about components that were used in linked assembly orders that supplied the item(s) being sold.';
                    }
                    field(ArchiveDocumentReq; ArchiveDocument)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Archive Document';
                        ToolTip = 'Specifies if the document is archived after you preview or print it.';
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Sales Shpt. Note");
            LogInteractionEnable := LogInteraction;
        end;
    }

    rendering
    {
        layout(SalesShipmentRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMSalesShipment.rdl';
            Caption = 'Chematek Sales Shipment';
            Summary = 'Chematek transport document (DDT) with shipment data, lot numbers and dangerous goods information per line.';
        }
    }

    labels
    {
        BillToAddress_Caption = 'Bill-to Address';
        CustomerVendorContact_Caption = 'Contact';
        CustomerVendorMail_Caption = 'E-Mail';
        DocumentNo_Caption = 'Document No.';
        Line_Amount_Caption = 'Amount';
        Line_Description_Caption = 'Description';
        Line_ItemNo_Caption = 'Item No.';
        Line_LineDiscountPerc_Caption = 'Disc. %';
        Line_OrderQuantity_Caption = 'Order Quantity';
        Line_Quantity_Caption = 'Quantity';
        Line_ShipmentDate_Caption = 'Shipment Date';
        Line_Type_Descr_Caption = 'Type';
        Line_UnitPrice_Caption = 'Unit Price';
        Line_UoM_Caption = 'UoM';
        Line_VATIdentifier_Caption = 'VAT';
        OrderConf_Title = 'Order Confirmation';
        OrderDate_Caption = 'Order Date';
        Page_Caption = 'Page';
        Payment_Amount_Caption = 'Amount Due';
        Payment_DueDate_Caption = 'Due Date';
        ReturnAddr_Caption = 'Return Address';
        Salesperson_Caption = 'Salesperson';
        ShipmentDate_Caption = 'Shipment Date';
        ShipToAddress_Caption = 'Ship-to Address';
        ShpAgent_Caption = 'Shipping Agent';
        Total_DocumentTotalCaption = 'Document Total';
        Total_DocumentTotalVatExclCaption = 'Document Total Excl. VAT';
        Total_NetAmountToPayCaption = 'Net Amount to Pay';
        Total_TotalAmountCaption = 'Total VAT';
        Total_TotalBaseCaption = 'Taxable Amount';
        Total_TotalCaption = 'Subtotal';
        ValidTo_Caption = 'Valid To';
        VAT_InvDisc_Caption = 'Invoice Discount';
        VAT_Line_VATIdentifier_Caption = 'VAT Code';
        VAT_VATText_Caption = 'VAT Description';
        VATClausesCaption = 'VAT Clause';
        VATRegNo_Caption = 'VAT Reg. No.';
        Volume_Caption = 'Volume';
        YourReference_Caption = 'Your Reference';
        TariffNoLbl = 'Tariff No.';
        CountryOfOriginLbl = 'Country of Origin';
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
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Sales Shpt. Note");

        CHMMgmt.GetDocumentSetup(CHMSetup);
        ShowIso := CHMSetup."Show ISO";
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) then
            if Header.FindSet() then
                repeat
                    if Header."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Sales Shpt. Note".AsInteger(), Header."No.", 0, 0, Database::Contact,
                          Header."Bill-to Contact No.", Header."Salesperson Code", Header."Campaign No.", Header."Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Sales Shpt. Note".AsInteger(), Header."No.", 0, 0, Database::Customer,
                          Header."Bill-to Customer No.", Header."Salesperson Code", Header."Campaign No.", Header."Posting Description", '');
                until Header.Next() = 0;

        // TODO (pending decision): "Archive Document" is on the agreed request page, but a posted sales shipment has
        // no standard archive (ArchiveManagement only archives open sales documents). Implement the agreed behaviour
        // here (for example, attach the printed DDT as PDF to the posted shipment), skipping preview mode.
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        CHMSetup: Record "CHM Customizations Setup";
        CompanyBankAccount: Record "Bank Account";
        SellToCust: Record Customer;
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        LanguageMgt: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CHMMgmt: Codeunit "CHM Customization Mgmt.";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        SkippedLineNos: List of [Integer];
        ShowShippingAddr: Boolean;
        BillAndShipSame: Boolean;
        ShowWorkDescription: Boolean;
        MoreLines: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        ArchiveDocument: Boolean;
        ReportLanguageCode: Code[10];
        CurrCode: Text[10];
        SalesPersonText: Text[50];
        SellToContactEmail: Text[80];
        OurBankAccountText: Text;
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
        ShowPlastic: Boolean;
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
        PackageNoCaptionText: Text;
        TransportDocumentLbl: Label 'Transport Document';
        DocumentNoCaptionLbl: Label 'Document No.';
        ConsigneeCaptionLbl: Label 'Consignee';
        ShipToAddressCaptionLbl: Label 'Ship-to Address';
        DateCaptionLbl: Label 'Date';
        ReasonCaptionLbl: Label 'Reason';
        CustomerNoCaptionLbl: Label 'Customer No.';
        ContactCaptionLbl: Label 'Contact';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        FiscalCodeCaptionLbl: Label 'Fiscal Code';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        PaymentMethodCaptionLbl: Label 'Payment Method';
        SalespersonCaptionLbl: Label 'Salesperson';
        OperatorCaptionLbl: Label 'Operator';
        OurBankCaptionLbl: Label 'Our Bank';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        ShipmentFromCaptionLbl: Label 'Shipment from';
        ShippingAgentCaptionLbl: Label 'Shipping Agent';
        GoodsAppearanceCaptionLbl: Label 'Goods Appearance';
        NoOfParcelsCaptionLbl: Label 'No. of Parcels';
        NoOfPalletsCaptionLbl: Label 'No. of Pallets';
        NetWeightCaptionLbl: Label 'Net Weight';
        GrossWeightCaptionLbl: Label 'Gross Weight';
        VolumeCaptionLbl: Label 'Volume';
        NonReusablePackagingCaptionLbl: Label 'Non-reusable Packaging';
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
        LotNoCaptionLbl: Label 'Lot No.';
        PackageNoCaptionLbl: Label 'Package No.';
        CountryOfOriginCaptionLbl: Label 'Country of Origin:';
        TariffNoCaptionLbl: Label 'Tariff No.:';
        UNNoCaptionLbl: Label 'UN No.:';
        ADRClassCaptionLbl: Label 'ADR Class:';
        SellToContactEmailLbl: Label 'Sell-to Contact E-Mail';
        BillToContactEmailLbl: Label 'Bill-to Contact E-Mail';
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
        ArchiveDocument := NewArchiveDocument;
    end;

    /// <summary>
    /// Formats the consignee (sell-to customer) and place of destination (ship-to) addresses.
    /// </summary>
    local procedure FormatAddressFields()
    begin
        FormatAddr.SalesShptSellTo(CustAddr, Header);
        FormatAddr.SalesShptShipTo(ShipToAddr, Header);
        BillAndShipSame := CHMMgmt.AddressesAreEqual(CustAddr, ShipToAddr);
        ShowShippingAddr := true;
    end;

    /// <summary>
    /// Sets the salesperson / purchaser, payment terms, payment method and shipment method texts printed on the document.
    /// </summary>
    local procedure FormatDocumentFields()
    begin
        FormatDocument.SetSalesPerson(SalespersonPurchaser, Header."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, Header."Payment Terms Code", ReportLanguageCode);
        FormatDocument.SetPaymentMethod(PaymentMethod, Header."Payment Method Code", ReportLanguageCode);
        FormatDocument.SetShipmentMethod(ShipmentMethod, Header."Shipment Method Code", ReportLanguageCode);
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

        VATRegistrationNo := SellToCust."VAT Registration No.";
        if VATRegistrationNo = '' then
            VATRegistrationNo := Header."VAT Registration No.";
        FiscalCodeNo := CHMMgmt.GetCustomerFiscalCode(Header."Sell-to Customer No.");

        AppNoteText := CHMMgmt.GetSalesShipmentComments(Header."No.");
        BarcodeShipmentNo := CHMMgmt.EncodeCode39(Header."No.");
        BarcodeImageText := '';
        SignPictureText := CHMMgmt.GetSignPicture();
    end;

    /// <summary>
    /// Fills the shipment data of the DDT: goods appearance, non-reusable packaging and transport start.
    /// </summary>
    local procedure SetShipmentDataFields()
    begin
        GoodsAppearanceText := CHMMgmt.GetGoodsAppearanceText(Header."CHM Goods Appearance");
        ShowPlastic := Header."CHM Non-reusable Packaging" <> 0;
        ShipmentStartingDateTime := CHMMgmt.GetTransportStartDateTime(Header, Database::"Sales Shipment Header");
    end;

    /// <summary>
    /// Returns true for lines that are not printed on the DDT: corrections, lines without quantity and the lines attached to them.
    /// </summary>
    local procedure SkipLine(SalesShipmentLine: Record "Sales Shipment Line"): Boolean
    begin
        if SalesShipmentLine.Correction then
            exit(true);
        if (SalesShipmentLine.Type <> SalesShipmentLine.Type::" ") and (SalesShipmentLine.Quantity = 0) then
            exit(true);
        if SalesShipmentLine."Attached to Line No." <> 0 then
            if SkippedLineNos.Contains(SalesShipmentLine."Attached to Line No.") then
                exit(true);
        exit(false);
    end;

    /// <summary>
    /// Fills the item data printed under the line: tariff no., country of origin and dangerous goods data.
    /// </summary>
    local procedure GetLineItemInfo(SalesShipmentLine: Record "Sales Shipment Line")
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

        if SalesShipmentLine.Type <> SalesShipmentLine.Type::Item then
            exit;
        if not Item.Get(SalesShipmentLine."No.") then
            exit;

        CHMMgmt.GetItemCustomsInfo(Item, TariffNo, CountryOrigin);
        CHMMgmt.GetItemDangerousGoodsInfo(Item, Hazardous, ItemHazardousDescr, ADRClass, ItemUN, ItemADRDescr, ItemADRLabel, ItemADRPackingGroup, ItemGalleryCode);
    end;
}
