report 66607 "CHM Sales Shipment"
{
    // Chematek Sales Shipment (DDT - Documento di trasporto, D.P.R. 472/1996), printed from the Posted Sales Shipment.
    // Based on the standard "Sales - Shipment" (report 208, BC 28 W1), extended with the columns used by the
    // Chematek RDLC layout (DataSet_Result, 172 fields).
    // Column names must stay exactly as they are: the RDLC layout binds to them by name.
    // Decimal columns automatically get a companion "<n>Format" field in the RDLC dataset,
    // which is why no "...Format" columns are declared here.
    // The page header and footer read their values through Code.SetData / Code.GetData from the first and last row,
    // so everything they print is declared on the Header data item and is available on every row of the dataset.
    // To print it from the Posted Sales Shipment, set it up in Report Selections - Sales, usage "Shipment".

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

            // Addresses
            // The layout prints SelltoCustomerNo_Lbl as the caption above the customer (sell-to) address box
            // and ShipToAddress_Lbl above the place of destination (ship-to address).
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

            // Document header captions
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

            // Chematek header fields
            column(SelltoCustomerNo; Header."Sell-to Customer No.")
            {

            }
            // Not printed: the layout prints the barcode from BarCodeShipNo with the IDAutomationC39M font, like the
            // other Chematek reports (see report 66600 "CHM Michelin Labels"). Kept so the dataset of the original
            // layout stays complete; it is always empty.
            column(Barcode; BarcodeImageText)
            {

            }
            // Logos: Company Information > Picture (left) and Chematek Customizations Setup (others)
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
            // Shipment from: the location on the shipment
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
            // Printed under the "Date" caption next to the document no.: the date of the transport document,
            // which is the posting date of the shipment.
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

            // Shipment data entered on the posted sales shipment (DEV-001 / DEV-002), printed in the page footer
            column(GoodsAppearance; GoodsAppearanceText)
            {

            }
            column(NoOfParcels; Header."CHM Total Parcel")
            {

            }
            column(GrossWeight; Header."CHM Total Gross Weight") { DecimalPlaces = 0 : 5; }
            column(NetWeight; Header."CHM Total Net Weight") { DecimalPlaces = 0 : 5; }
            // The layout prints Volume on the plastic row (next to PlasticLbl, only when ShowPlastic is true),
            // so this column carries the non-reusable packaging quantity of the shipment (same as the posted invoice).
            column(Volume; Header."CHM Non-reusable Packaging") { DecimalPlaces = 0 : 5; }
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

            // Standard sales shipment header fields
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
            // Document title (DDT)
            column(Shipment_Lbl; TransportDocumentLbl)
            {

            }
            column(ShipmentDate_Lbl; Header.FieldCaption("Shipment Date"))
            {

            }
            // The place of destination is mandatory on a DDT, so the ship-to box (and its caption) is always printed.
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
            // Font-encoded Code 39 of the shipment no., printed in the page header with the IDAutomationC39M font.
            column(BarCodeShipNo; BarcodeShipmentNo)
            {

            }
            // Comments of the posted shipment (header comments), printed under the lines.
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
            column(BillAndShipSame; BillAndShipSame)
            {

            }
            // Printed under the lines (same as report 66606 "CHM Purchase Order").
            column(gLocationDesc; LocationName)
            {

            }
            // The work description is a header column and not a separate data item: the layout groups the lines on
            // Line_LineNo, so extra data item rows would be printed as an empty line at the top of the lines table.
            column(WorkDescriptionLine; WorkDescriptionText)
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
                column(Line_Quantity; Quantity) { DecimalPlaces = 0 : 5; }
                column(Line_UoMCode; "Unit of Measure Code")
                {

                }

                // Item / dangerous goods information (see GetLineItemInfo)
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
                // The layout hides the item no. for G/L account (1) and charge (item) (5) lines.
                column(Line_Type; Type.AsInteger())
                {

                }
                // The layout groups the lines table on DocumentNo + Line_LineNo.
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

                // Lots / packages shipped on the line (posted item tracking). Filled in FillLotBuffer.
                // Quantities are in the unit of measure of the shipment line.
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
                    column(TrackingSpecBufferPackageNo; "Package No.")
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
                    // Filled per row: the layout prints "<caption> <package no.>" after the lot no.,
                    // so the caption is blank when the row has no package no.
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
                // Components of the assembly-to-order shipped on the line ("Show Assembly Components").
                // The layout prints one row per component under the line, only when LineNo_AssemblyLine is filled.
                dataitem(AssemblyLine; "Posted Assembly Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.");

                    column(LineNo_AssemblyLine; "No.")
                    {

                    }
                    column(Description_AssemblyLine; Description)
                    {

                    }
                    column(Quantity_AssemblyLine; Quantity) { DecimalPlaces = 0 : 5; }
                    column(UnitOfMeasure_AssemblyLine; GetUOMText("Unit of Measure Code"))
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
                // The shipment is printed in the language of the user running the report, not in the
                // customer's language (Header."Language Code"), same as the other Chematek posted documents.
                ReportLanguageCode := LanguageMgt.GetUserLanguageCode();
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(ReportLanguageCode);
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                FormatAddr.SetLanguageCode(ReportLanguageCode);

                if not IsReportInPreviewMode() then
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
                SetOurBankAccountText();

                if Header."Currency Code" <> '' then
                    CurrCode := Header."Currency Code"
                else
                    CurrCode := GLSetup."LCY Code";

                SetWorkDescription();
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
            LogInteraction := LogInteractionTemplateExists();
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

    // Report parameters declared in the RDLC layout (Parameters!<Name>.Value).
    // The layout prints Page_Caption, CustomerVendorMail_Caption and DPR_Caption; the others are declared
    // because the layout declares them as parameters.
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
            LogInteraction := LogInteractionTemplateExists();

        LoadDocumentLogos();
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
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
        ShowPlastic: Boolean;

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
        PackageNoCaptionText: Text;

        // Captions
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
        BankAccountIBANTok: Label '%1 - %2', Locked = true;
        DateTimeTok: Label '%1 %2', Locked = true;
        Code39CharsTok: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-. $/+%', Locked = true;
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
        exit(SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Shpt. Note") <> '');
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure FormatAddressFields()
    begin
        // Consignee (destinatario): the sell-to customer. Place of destination: the ship-to address.
        FormatAddr.SalesShptSellTo(CustAddr, Header);
        FormatAddr.SalesShptShipTo(ShipToAddr, Header);
        BillAndShipSame := AddressesAreEqual(CustAddr, ShipToAddr);
        ShowShippingAddr := true;
    end;

    local procedure AddressesAreEqual(FirstAddr: array[8] of Text[100]; SecondAddr: array[8] of Text[100]): Boolean
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(FirstAddr) do
            if FirstAddr[i] <> SecondAddr[i] then
                exit(false);
        exit(true);
    end;

    local procedure FormatDocumentFields()
    begin
        FormatDocument.SetSalesPerson(SalespersonPurchaser, Header."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, Header."Payment Terms Code", ReportLanguageCode);
        FormatDocument.SetPaymentMethod(PaymentMethod, Header."Payment Method Code", ReportLanguageCode);
        FormatDocument.SetShipmentMethod(ShipmentMethod, Header."Shipment Method Code", ReportLanguageCode);
    end;

    local procedure SetOurBankAccountText()
    begin
        // Bank name followed by the IBAN (not printed by the current layout).
        OurBankAccountText := CompanyBankAccount.Name;
        if CompanyBankAccount.IBAN <> '' then
            if OurBankAccountText = '' then
                OurBankAccountText := CompanyBankAccount.IBAN
            else
                OurBankAccountText := StrSubstNo(BankAccountIBANTok, OurBankAccountText, CompanyBankAccount.IBAN);
    end;

    local procedure SetWorkDescription()
    var
        TypeHelper: Codeunit "Type Helper";
        WorkDescriptionInStream: InStream;
    begin
        WorkDescriptionText := '';
        Header.CalcFields("Work Description");
        ShowWorkDescription := Header."Work Description".HasValue();
        if not ShowWorkDescription then
            exit;
        Header."Work Description".CreateInStream(WorkDescriptionInStream, TextEncoding::UTF8);
        WorkDescriptionText := TypeHelper.ReadAsTextWithSeparator(WorkDescriptionInStream, TypeHelper.LFSeparator());
    end;

    local procedure SetChematekHeaderFields()
    var
        Location: Record Location;
        ReasonCode: Record "Reason Code";
        ShippingAgent: Record "Shipping Agent";
    begin
        // Operator: the user who posted the shipment.
        OperatorName := GetUserFullName(Header."User ID");

        // Shipment from: the location on the shipment.
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
        ReasonCodeText := Header."Reason Code";
        if Header."Reason Code" <> '' then
            if ReasonCode.Get(Header."Reason Code") then
                if ReasonCode.Description <> '' then
                    ReasonCodeText := ReasonCode.Description;

        // Carrier: the shipping agent name, fall back to the code.
        ShippingAgentName := Header."Shipping Agent Code";
        if Header."Shipping Agent Code" <> '' then
            if ShippingAgent.Get(Header."Shipping Agent Code") then
                if ShippingAgent.Name <> '' then
                    ShippingAgentName := ShippingAgent.Name;

        // VAT Reg. No. and Fiscal Code of the consignee (sell-to customer).
        VATRegistrationNo := SellToCust."VAT Registration No.";
        if VATRegistrationNo = '' then
            VATRegistrationNo := Header."VAT Registration No.";
        FiscalCodeNo := GetCustomerFiscalCode(Header."Sell-to Customer No.");

        AppNoteText := GetShipmentComments();
        BarcodeShipmentNo := EncodeCode39(Header."No.");
        BarcodeImageText := '';
        SignPictureText := GetSignPicture();
    end;

    local procedure SetShipmentDataFields()
    var
        GoodsAppearance: Record "CHM Goods Appearance";
    begin
        // Goods appearance: print the description, fall back to the code.
        GoodsAppearanceText := Header."CHM Goods Appearance";
        if Header."CHM Goods Appearance" <> '' then
            if GoodsAppearance.Get(Header."CHM Goods Appearance") then
                if GoodsAppearance.Description <> '' then
                    GoodsAppearanceText := GoodsAppearance.Description;

        ShowPlastic := Header."CHM Non-reusable Packaging" <> 0;
        ShipmentStartingDateTime := GetTransportStartDateTime();
    end;

    local procedure GetTransportStartDateTime(): Text
    var
        CHMManagement: Codeunit "CHM Management";
        StartingDateText: Text;
        StartingTimeText: Text;
    begin
        // TODO (pending decision): standard W1 has no transport start date / time on the shipment. The Italian
        // localization adds "Shipping Starting Date" / "Shipping Starting Time", read by name so the extension
        // compiles without a dependency on the IT base app. When the fields do not exist or are blank, the
        // value is left blank, to be filled in by hand.
        StartingDateText := CHMManagement.GetFieldValueByName(Header, Database::"Sales Shipment Header", ShippingStartingDateFieldTok);
        StartingTimeText := CHMManagement.GetFieldValueByName(Header, Database::"Sales Shipment Header", ShippingStartingTimeFieldTok);
        if StartingDateText = '' then
            exit('');
        if StartingTimeText = '' then
            exit(StartingDateText);
        exit(StrSubstNo(DateTimeTok, StartingDateText, StartingTimeText));
    end;

    local procedure GetShipmentComments() Result: Text
    var
        SalesCommentLine: Record "Sales Comment Line";
        TypeHelper: Codeunit "Type Helper";
    begin
        // Header comments of the posted shipment (Comments action on the Posted Sales Shipment).
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Shipment);
        SalesCommentLine.SetRange("No.", Header."No.");
        SalesCommentLine.SetRange("Document Line No.", 0);
        if SalesCommentLine.FindSet() then
            repeat
                if SalesCommentLine.Comment <> '' then begin
                    if Result <> '' then
                        Result += TypeHelper.CRLFSeparator();
                    Result += SalesCommentLine.Comment;
                end;
            until SalesCommentLine.Next() = 0;
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

    local procedure GetCustomerFiscalCode(CustomerNo: Code[20]): Text
    var
        CHMManagement: Codeunit "CHM Management";
    begin
        // Fiscal Code from the customer card (Italian localization field, see codeunit 66602 "CHM Management").
        exit(CHMManagement.GetCustomerFiscalCode(CustomerNo));
    end;

    local procedure SkipLine(SalesShipmentLine: Record "Sales Shipment Line"): Boolean
    begin
        // Correction lines (Undo Shipment) are not printed, same as the standard report.
        if SalesShipmentLine.Correction then
            exit(true);
        // A DDT lists only the goods that were shipped: lines without quantity are not printed,
        // and neither are the comment / extended text lines attached to them.
        if (SalesShipmentLine.Type <> SalesShipmentLine.Type::" ") and (SalesShipmentLine.Quantity = 0) then
            exit(true);
        if SalesShipmentLine."Attached to Line No." <> 0 then
            if SkippedLineNos.Contains(SalesShipmentLine."Attached to Line No.") then
                exit(true);
        exit(false);
    end;

    local procedure GetLineItemInfo(SalesShipmentLine: Record "Sales Shipment Line")
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

        if SalesShipmentLine.Type <> SalesShipmentLine.Type::Item then
            exit;
        if not Item.Get(SalesShipmentLine."No.") then
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
        SalesShipmentLine: Record "Sales Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Lots / packages shipped on each item line, taken from the item ledger entries of the line.
        TrackingSpecBuffer.Reset();
        TrackingSpecBuffer.DeleteAll();
        LotBufferEntryNo := 0;

        SalesShipmentLine.SetRange("Document No.", Header."No.");
        SalesShipmentLine.SetRange(Type, SalesShipmentLine.Type::Item);
        SalesShipmentLine.SetFilter("No.", '<>%1', '');
        SalesShipmentLine.SetFilter(Quantity, '<>0');
        if not SalesShipmentLine.FindSet() then
            exit;
        repeat
            ItemLedgerEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
            ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
            ItemLedgerEntry.SetRange("Document Line No.", SalesShipmentLine."Line No.");
            ItemLedgerEntry.SetRange("Item No.", SalesShipmentLine."No.");
            if ItemLedgerEntry.FindSet() then
                repeat
                    if (ItemLedgerEntry."Lot No." <> '') or (ItemLedgerEntry."Package No." <> '') then
                        AddLotToBuffer(SalesShipmentLine, ItemLedgerEntry."Lot No.", ItemLedgerEntry."Package No.", Abs(ItemLedgerEntry.Quantity));
                until ItemLedgerEntry.Next() = 0;
        until SalesShipmentLine.Next() = 0;
    end;

    local procedure AddLotToBuffer(SalesShipmentLine: Record "Sales Shipment Line"; LotNo: Code[50]; PackageNo: Code[50]; QtyBase: Decimal)
    begin
        if QtyBase = 0 then
            exit;

        // One row per shipment line, lot and package.
        TrackingSpecBuffer.Reset();
        TrackingSpecBuffer.SetRange("Source Ref. No.", SalesShipmentLine."Line No.");
        TrackingSpecBuffer.SetRange("Lot No.", LotNo);
        TrackingSpecBuffer.SetRange("Package No.", PackageNo);
        if TrackingSpecBuffer.FindFirst() then begin
            TrackingSpecBuffer."Quantity (Base)" += QtyBase;
            TrackingSpecBuffer."Qty. to Handle" := CalcLineQty(TrackingSpecBuffer."Quantity (Base)", SalesShipmentLine."Qty. per Unit of Measure");
            TrackingSpecBuffer.Modify();
        end else begin
            LotBufferEntryNo += 1;
            TrackingSpecBuffer.Init();
            TrackingSpecBuffer."Entry No." := LotBufferEntryNo;
            TrackingSpecBuffer."Source Type" := Database::"Sales Shipment Line";
            TrackingSpecBuffer."Source ID" := SalesShipmentLine."Document No.";
            TrackingSpecBuffer."Source Ref. No." := SalesShipmentLine."Line No.";
            TrackingSpecBuffer."Item No." := SalesShipmentLine."No.";
            TrackingSpecBuffer."Variant Code" := SalesShipmentLine."Variant Code";
            TrackingSpecBuffer.Description := SalesShipmentLine.Description;
            TrackingSpecBuffer."Lot No." := LotNo;
            TrackingSpecBuffer."Package No." := PackageNo;
            TrackingSpecBuffer."Qty. per Unit of Measure" := SalesShipmentLine."Qty. per Unit of Measure";
            TrackingSpecBuffer."Quantity (Base)" := QtyBase;
            TrackingSpecBuffer."Qty. to Handle" := CalcLineQty(QtyBase, SalesShipmentLine."Qty. per Unit of Measure");
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
        // Font-encoded Code 39 of the shipment no. (same as report 66600 "CHM Michelin Labels").
        // The layout prints it in a textbox with the IDAutomationC39M font (font size from Code.BarcodeFontSize).
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

    local procedure GetUOMText(UOMCode: Code[10]): Text[50]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;
}
