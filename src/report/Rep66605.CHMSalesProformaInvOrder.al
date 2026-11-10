report 66605 "CHM Sales Proforma Inv. Order"
{
    // Chematek Sales Proforma Invoice printed from a Sales Order.
    // Same data contract as "CHM Sales Order Confirmation" (report 66602): the proforma RDLC layout
    // (DataSet_Result) was derived from the order confirmation layout, so the column names below must
    // stay exactly as they are because the layout binds to them by name.
    // Differences from the order confirmation:
    //   - Document title is "Proforma Invoice" (DocumentTypeLabel).
    //   - Prints the IBAN of the customer bank account (CustomerBankAccount_IBAN).
    //   - No "shipped lots" block and no item reference description (not used by the proforma layout).
    // Decimal columns automatically get a companion "<Name>Format" field in the RDLC dataset,
    // which is why no "...Format" columns are declared here.
    // To print it from the Sales Order (action Pro Forma Invoice), set it up in
    // Report Selections - Sales, usage "Pro Forma Invoice".

    Caption = 'CHM Sales Proforma Invoice from order';
    UsageCategory = None;
    DefaultRenderingLayout = SalesProformaInvRDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Header; "Sales Header")
        {
            // Only orders are printed: the restriction is set in a hidden filter group in OnPreReport,
            // so "Document Type" can still be shown as a filter field on the request page.
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.", "Bill-to Customer No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';

            // Addresses
            column(BillToAddress_Lbl; BillToAddressCaptionLbl) { }
            column(CustomerAddress1; CustAddr[1]) { }
            column(CustomerAddress2; CustAddr[2]) { }
            column(CustomerAddress3; CustAddr[3]) { }
            column(CustomerAddress4; CustAddr[4]) { }
            column(CustomerAddress5; CustAddr[5]) { }
            column(CustomerAddress6; CustAddr[6]) { }
            column(CustomerAddress7; CustAddr[7]) { }
            column(CustomerAddress8; CustAddr[8]) { }
            column(ShipToAddress_Lbl; ShipToAddressCaptionLbl) { }
            column(ShipToAddress1; ShipToAddr[1]) { }
            column(ShipToAddress2; ShipToAddr[2]) { }
            column(ShipToAddress3; ShipToAddr[3]) { }
            column(ShipToAddress4; ShipToAddr[4]) { }
            column(ShipToAddress5; ShipToAddr[5]) { }
            column(ShipToAddress6; ShipToAddr[6]) { }
            column(ShipToAddress7; ShipToAddr[7]) { }
            column(ShipToAddress8; ShipToAddr[8]) { }

            // Document header captions
            column(DocumentTypeLabel; ProformaInvoiceCaptionLbl) { }
            column(DocumentNoLbl; DocumentNoCaptionLbl) { }
            column(DateLbl; DateCaptionLbl) { }
            column(ReasonLbl; ReasonCaptionLbl) { }
            column(CustomerVendorNoLbl; CustomerNoCaptionLbl) { }
            column(VatRegNoLbl; VATRegNoCaptionLbl) { }
            column(FiscalCodeLbl; FiscalCodeCaptionLbl) { }
            column(PaymentTermsDescLbl; PaymentTermsCaptionLbl) { }
            column(PaymentMethodDescLbl; PaymentMethodCaptionLbl) { }
            column(SalespersonLbl; SalespersonCaptionLbl) { }
            column(OperatorNameLbl; OperatorCaptionLbl) { }
            column(ShptTermsLbl; DeliveryTermsCaptionLbl) { }
            column(OurBankAccountLbl; OurBankCaptionLbl) { }
            column(ShptByLbl; ShippingAgentCaptionLbl) { }
            column(YourReferenceLbl; YourReferenceCaptionLbl) { }
            // In the layout this caption sits above the Requested Delivery Date (RequestedDeliveryDate).
            column(ExpShptReqDate; RequestedDeliveryDateCaptionLbl) { }
            column(ShptMethodLbl; ShipmentMethodCaptionLbl) { }

            // Totals / VAT summary / payment captions
            column(Total_NetAmountToPayCaption; NetAmountToPayCaptionLbl) { }
            column(Total_TotalAmountCaption; TotalVATCaptionLbl) { }
            column(Total_TotalBaseCaption; TaxableAmountCaptionLbl) { }
            column(Total_TotalInvDiscCaption; InvDiscountAmtLbl) { }
            column(Total_TotalCaption; SubtotalLbl) { }
            column(Total_DocumentTotalCaption; DocumentTotalCaptionLbl) { }
            column(VAT_InvDisc_Caption; InvDiscountAmtLbl) { }
            column(VAT_Line_VATIdentifier_Caption; VATCodeCaptionLbl) { }
            column(VAT_VATAmount_Caption; VATAmtLbl) { }
            column(VAT_VATBase_Caption; TaxableAmountCaptionLbl) { }
            column(VAT_VATPercent_Caption; VATPercentageLbl) { }
            column(VAT_VATText_Caption; VATDescriptionCaptionLbl) { }
            column(Payment_Amount_Caption; PaymentAmountCaptionLbl) { }
            column(Payment_DueDate_Caption; DueDateCaptionLbl) { }
            column(ShipmentFrom_Caption; ShipmentFromCaptionLbl) { }

            // Logos: Company Information > Picture (left) and Chematek Customizations Setup (others)
            column(FooterLogo; CHMSetup."Footer Logo") { }
            column(LeftHeaderLogo; CompanyInfo.Picture) { }
            column(RightHeaderLogo; CHMSetup."Right Header Logo") { }
            column(Iso9001Logo; CHMSetup."ISO 9001 Logo") { }
            column(ASSICCLogo; CHMSetup."ASSICC Logo") { }
            column(ShowIso; ShowIso) { }

            // Chematek header fields
            column(AssignedUserID; Header."Assigned User ID") { }
            column(OperatorName; OperatorName) { }
            column(LocationName; LocationName) { }
            column(LocationAddress; LocationAddress) { }
            column(LocationCity; LocationCity) { }
            column(ViewLocation; ViewLocation) { }
            column(ReasonCode; ReasonCodeText) { }
            column(CompanyPicture; DummyCompanyInfo.Picture) { }
            column(OrderDate; Format(Header."Order Date")) { }
            column(CompanyIBAN; CompanyBankAccount.IBAN) { }
            column(CompanyIBAN_Lbl; CompanyBankAccount.FieldCaption(IBAN)) { }
            // IBAN of the customer bank account (see GetCustomerBankAccountIBAN), printed next to the "IBAN" caption.
            column(CustomerBankAccount_IBAN; CustomerBankAccountIBAN) { }
            column(CompanyLogoPosition; CompanyLogoPosition) { }
            column(CompanyLegalStatement; LegalStatementLbl) { }
            column(ShptBy; ShippingAgentName) { }
            column(ShptMethod; Header."Shipment Method Code") { }
            column(RequestedDeliveryDate; Format(Header."Requested Delivery Date")) { }
            column(FiscalCodeNo; FiscalCodeNo) { }

            // Contacts
            column(SellToContactPhoneNoLbl; SellToContactPhoneNoLbl) { }
            column(SellToContactMobilePhoneNoLbl; SellToContactMobilePhoneNoLbl) { }
            column(SellToContactEmailLbl; SellToContactEmailLbl) { }
            column(BillToContactPhoneNoLbl; BillToContactPhoneNoLbl) { }
            column(BillToContactMobilePhoneNoLbl; BillToContactMobilePhoneNoLbl) { }
            column(BillToContactEmailLbl; BillToContactEmailLbl) { }
            column(SellToContactPhoneNo; SellToContact."Phone No.") { }
            column(SellToContactMobilePhoneNo; SellToContact."Mobile Phone No.") { }
            column(SellToContactEmail; SellToContactEmail) { }
            column(SellToContactName; Header."Sell-to Contact") { }
            column(BillToContactPhoneNo; BillToContact."Phone No.") { }
            column(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.") { }
            column(BillToContactEmail; BillToContact."E-Mail") { }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1)) { }

            // Standard order confirmation header fields
            column(YourReference; Header."Your Reference") { }
            column(YourReference_Lbl; Header.FieldCaption("Your Reference")) { }
            column(ShipmentMethodDescription; ShipmentMethod.Description) { }
            column(ShipmentMethodDescription_Lbl; ShipmentMethodCaptionLbl) { }
            column(Shipment_Lbl; ShipmentLbl) { }
            column(ShipmentDate; Format(Header."Shipment Date")) { }
            column(ShipmentDate_Lbl; Header.FieldCaption("Shipment Date")) { }
            column(ShowShippingAddress; ShowShippingAddr) { }
            column(BillAndShipSame; not ShowShippingAddr) { }
            column(PaymentTermsDescription; PaymentTerms.Description) { }
            column(PaymentTermsDescription_Lbl; PaymentTermsCaptionLbl) { }
            column(PaymentMethodDescription; PaymentMethod.Description) { }
            column(PaymentMethodDescription_Lbl; PaymentMethodCaptionLbl) { }
            column(DocumentCopyText; ProformaInvoiceCaptionLbl) { }
            column(BilltoCustumerNo; Header."Bill-to Customer No.") { }
            column(BilltoCustomerNo_Lbl; Header.FieldCaption("Bill-to Customer No.")) { }
            column(DocumentDate; Format(Header."Document Date")) { }
            column(DocumentDate_Lbl; Header.FieldCaption("Document Date")) { }
            column(DueDate; Format(Header."Due Date")) { }
            column(DueDate_Lbl; Header.FieldCaption("Due Date")) { }
            column(DocumentNo; Header."No.") { }
            column(DocumentNo_Lbl; DocumentNoCaptionLbl) { }
            column(QuoteNo; Header."Quote No.") { }
            column(QuoteNo_Lbl; QuoteNoCaptionLbl) { }
            column(PricesIncludingVAT; Header."Prices Including VAT") { }
            column(PricesIncludingVAT_Lbl; Header.FieldCaption("Prices Including VAT")) { }
            column(PricesIncludingVATYesNo; Format(Header."Prices Including VAT")) { }
            column(SalesPerson_Lbl; SalespersonCaptionLbl) { }
            column(SalesPersonText_Lbl; SalesPersonText) { }
            column(SalesPersonName; SalespersonPurchaser.Name) { }
            column(SelltoCustomerNo; Header."Sell-to Customer No.") { }
            column(SelltoCustomerNo_Lbl; Header.FieldCaption("Sell-to Customer No.")) { }
            column(VATRegistrationNo; Header.GetCustomerVATRegistrationNumber()) { }
            column(VATRegistrationNo_Lbl; Header.GetCustomerVATRegistrationNumberLbl()) { }
            column(SellToFaxNo; SellToCust."Fax No.") { }
            column(SellToPhoneNo; Header."Sell-to Phone No.") { }
            column(LegalEntityType; Cust.GetLegalEntityType()) { }
            column(LegalEntityType_Lbl; Cust.GetLegalEntityTypeLbl()) { }
            column(Copy_Lbl; CopyLbl) { }
            column(InvoiceDiscountBaseAmount_Lbl; InvDiscBaseAmtLbl) { }
            column(InvoiceDiscountAmount_Lbl; InvDiscountAmtLbl) { }
            column(LineAmountAfterInvoiceDiscount_Lbl; LineAmtAfterInvDiscLbl) { }
            column(LocalCurrency_Lbl; LocalCurrencyLbl) { }
            column(ExchangeRateAsText; ExchangeRateText) { }
            column(Page_Lbl; PageLbl) { }
            column(SalesInvoiceLineDiscount_Lbl; SalesInvLineDiscLbl) { }
            column(Invoice_Lbl; OrderCaptionLbl) { }
            column(Subtotal_Lbl; SubtotalLbl) { }
            column(Total_Lbl; TotalLbl) { }
            column(VATAmount_Lbl; VATAmtLbl) { }
            column(VATBase_Lbl; VATBaseLbl) { }
            column(VATAmountSpecification_Lbl; VATAmtSpecificationLbl) { }
            column(VATClauses_Lbl; VATClausesLbl) { }
            column(VATIdentifier_Lbl; VATIdentifierLbl) { }
            column(VATPercentage_Lbl; VATPercentageLbl) { }
            column(VATClause_Lbl; VATClause.TableCaption()) { }
            column(ExtDocNo_SalesHeader; Header."External Document No.") { }
            column(ExtDocNo_SalesHeader_Lbl; Header.FieldCaption("External Document No.")) { }
            column(ShowWorkDescription; ShowWorkDescription) { }
            // Full work description text, printed in the page footer of the layout.
            column(DescrLav; WorkDescriptionText) { }
            column(CurrencyCode; CurrCode) { }

            // Line table captions (header row of the lines table)
            column(Line_NoLbl; LineNoCaptionLbl) { }
            column(Line_DesciptionLbl; LineDescriptionCaptionLbl) { }
            column(Line_QuantityLbl; LineQuantityCaptionLbl) { }
            column(Line_UMLbl; LineUoMCaptionLbl) { }
            column(Line_PriceLbl; LinePriceCaptionLbl) { }
            column(Line_DiscPercLbl; LineDiscPctCaptionLbl) { }
            column(Line_AmountLbl; LineAmountCaptionLbl) { }
            column(Line_VATLbl; LineVATCaptionLbl) { }
            column(Line_ShptReqDate; LineShipmentDateCaptionLbl) { }
            column(LotNo_Caption; LotNoCaptionLbl) { }
            column(CountryOfOrigin_Caption; CountryOfOriginCaptionLbl) { }
            column(Tariff_No_Caption; TariffNoCaptionLbl) { }
            column(UN_Caption; UNNoCaptionLbl) { }
            column(ADR_Class_Caption; ADRClassCaptionLbl) { }

            // Document totals (calculated in CalcDocumentTotals, available on every row)
            column(TotalNetAmount; TotalAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATBaseLCY; TotalVATBaseLCY) { }
            column(TotalAmountIncludingVAT; TotalAmountInclVAT)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATAmount; TotalAmountVAT)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATAmountLCY; TotalVATAmountLCY) { }
            column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT) { }
            column(TotalVATAmountText; TotalVATAmountText) { }
            column(TotalExcludingVATText; TotalExclVATText) { }
            column(TotalIncludingVATText; TotalInclVATText) { }
            column(TotalSubTotal; TotalSubTotal)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalSubTotalMinusInvoiceDiscount; TotalSubTotal + TotalInvDiscAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalLineDiscount; TotalLineDiscount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalText; TotalText) { }

            // VAT clauses summary: 4 fixed slots (see FillVATClauseSummary)
            column(VAT_ClauseCode1; VATClauseSlotCode[1]) { }
            column(VAT_ClauseDescription1; VATClauseSlotDescription[1]) { }
            column(VAT_ClauseCode2; VATClauseSlotCode[2]) { }
            column(VAT_ClauseDescription2; VATClauseSlotDescription[2]) { }
            column(VAT_ClauseCode3; VATClauseSlotCode[3]) { }
            column(VAT_ClauseDescription3; VATClauseSlotDescription[3]) { }
            column(VAT_ClauseCode4; VATClauseSlotCode[4]) { }
            column(VAT_ClauseDescription4; VATClauseSlotDescription[4]) { }
            column(ShowVATClauseTab; ShowVATClauseTab) { }

            // VAT summary: 4 fixed slots (see FillVATSummary). Names/casing match the layout.
            column(CodIVA1; VATSlotCode[1]) { }
            column(CodIVA2; VATSlotCode[2]) { }
            column(CodIva3; VATSlotCode[3]) { }
            column(CodIva4; VATSlotCode[4]) { }
            column(VatPerc1; VATSlotPct[1]) { DecimalPlaces = 0 : 5; }
            column(VatPerc2; VATSlotPct[2]) { DecimalPlaces = 0 : 5; }
            column(VatPerc3; VATSlotPct[3]) { DecimalPlaces = 0 : 5; }
            column(VatPerc4; VATSlotPct[4]) { DecimalPlaces = 0 : 5; }
            column(DesIVA1; VATSlotDescription[1]) { }
            column(DesIVA2; VATSlotDescription[2]) { }
            column(DesIVA3; VATSlotDescription[3]) { }
            column(DesIVA4; VATSlotDescription[4]) { }
            column(VatBase1; VATSlotBase[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatBase2; VATSlotBase[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatBase3; VATSlotBase[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatBase4; VATSlotBase[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount1; VATSlotAmount[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount2; VATSlotAmount[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount3; VATSlotAmount[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount4; VATSlotAmount[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            // Invoice discount per VAT rate (same 4 slots as the VAT summary).
            column(DiscountAmount1; VATSlotDiscount[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DiscountAmount2; VATSlotDiscount[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DiscountAmount3; VATSlotDiscount[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DiscountAmount4; VATSlotDiscount[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }

            // Payment schedule: 4 fixed slots (see FillPaymentSchedule)
            column(DueDate1; DueDateSlot[1]) { }
            column(DueDate2; DueDateSlot[2]) { }
            column(DueDate3; DueDateSlot[3]) { }
            column(DueDate4; DueDateSlot[4]) { }
            column(DueAmount1; DueAmountSlot[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount2; DueAmountSlot[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount3; DueAmountSlot[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount4; DueAmountSlot[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }

            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                UseTemporary = true;

                // The layout groups the lines table on DocumentNo + Line_LineNo and filters out
                // rows where Line_LineNo is empty, so this column must only be filled on line rows.
                column(Line_LineNo; "Line No.") { }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountExcludingVAT_Line_Lbl; FieldCaption(Amount)) { }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountIncludingVAT_Line_Lbl; FieldCaption("Amount Including VAT")) { }
                column(Line_RequestedDeliveryDate; Format("Requested Delivery Date")) { }
                column(Line_Description; Description) { }
                column(Description_Line_Lbl; FieldCaption(Description)) { }
                column(Line_LineDiscountPerc; "Line Discount %") { DecimalPlaces = 0 : 5; }
                column(LineDiscountPercentText_Line; LineDiscountPctText) { }
                column(Line_Amount; "Line Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_Line_Lbl; FieldCaption("Line Amount")) { }
                column(Line_ItemNo; "No.") { }
                column(Line_Type; Format(Type)) { }
                column(ItemNo_Line_Lbl; FieldCaption("No.")) { }
                column(Line_ShipmentDate; Format("Shipment Date")) { }
                column(ShipmentDate_Line_Lbl; FieldCaption("Shipment Date")) { }
                column(Line_PlannedShipmentDate; Format("Planned Shipment Date")) { }
                column(PlannedShipmentDate_Line_Lbl; FieldCaption("Planned Shipment Date")) { }
                column(Line_Quantity; Quantity) { DecimalPlaces = 0 : 5; }
                column(Quantity_Line_Lbl; FieldCaption(Quantity)) { }
                column(Type_Line; Format(Type)) { }
                column(Line_UnitPrice; "Unit Price")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(UnitPrice_Lbl; FieldCaption("Unit Price")) { }
                column(UnitOfMeasure; "Unit of Measure") { }
                column(Line_UoMCode; "Unit of Measure Code") { }
                column(UnitOfMeasure_Lbl; FieldCaption("Unit of Measure")) { }
                column(Line_VATIdentifier; "VAT Identifier") { }
                column(VATIdentifier_Line_Lbl; FieldCaption("VAT Identifier")) { }
                column(VATPct_Line; FormattedVATPct) { }
                column(VATPct_Line_Lbl; FieldCaption("VAT %")) { }
                column(TransHeaderAmount; TransHeaderAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(ItemReferenceNo; "Item Reference No.") { }
                column(ItemReferenceNo_Lbl; FieldCaption("Item Reference No.")) { }

                // Item / dangerous goods information (see GetLineItemInfo)
                column(ItemHazardousDescr; ItemHazardousDescr) { }
                column(Hazardous; Hazardous) { }
                column(TariffNo; TariffNo) { }
                column(ADRClass; ADRClass) { }
                column(ItemUN; ItemUN) { }
                column(ItemUNValue; ItemUNValue) { }
                column(CountryOrigin; CountryOrigin) { }

                // VAT exemption (declaration of intent) printed under the line (see GetLineVATExemption).
                // The layout shows the row only when VATExemptNo_CHMDocVATExemptionLink is filled.
                column(DocumentNo_CHMDocVATExemptionLink; VATExemptDocumentNo) { }
                column(LineNo_CHMDocVATExemptionLink; VATExemptLineNo) { }
                column(NoVATExemption_CHMDocVATExemptionLink; NoVATExemption) { }
                column(Source_CHMDocVATExemptionLink; VATExemptSource) { }
                column(VATExemptStartingDate_CHMDocVATExemptionLink; VATExemptStartingDate) { }
                column(VATExemptEndingDate_CHMDocVATExemptionLink; VATExemptEndingDate) { }
                column(VATExemptNo_CHMDocVATExemptionLink; VATExemptNo) { }
                column(VATExemptionType_CHMDocVATExemptionLink; VATExemptionType) { }

                dataitem(AssemblyLine; "Assembly Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

                    column(LineNo_AssemblyLine; "No.") { }
                    column(Description_AssemblyLine; Description) { }
                    column(Quantity_AssemblyLine; Quantity) { DecimalPlaces = 0 : 5; }
                    column(UnitOfMeasure_AssemblyLine; GetUOMText("Unit of Measure Code")) { }
                    column(VariantCode_AssemblyLine; "Variant Code") { }

                    trigger OnPreDataItem()
                    begin
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        if not AsmInfoExistsForLine then
                            CurrReport.Break();
                        AssemblyLine.SetRange("Document Type", AsmHeader."Document Type");
                        AssemblyLine.SetRange("Document No.", AsmHeader."No.");
                    end;
                }
                // Lots assigned to the quantity still to be shipped (item tracking lines of the order line).
                // Filled in FillLotBuffers. Quantities are in the unit of measure of the order line.
                dataitem(TrackingSpecBuffer; "Tracking Specification")
                {
                    DataItemTableView = sorting("Entry No.");
                    UseTemporary = true;

                    column(TrackingSpecBufferItemNo; "Item No.") { }
                    column(TrackingSpecBufferLotNo; "Lot No.") { }
                    column(TrackingSpecBufferDesc; Description) { }
                    column(TrackingSpecBufferQty; "Qty. to Handle") { DecimalPlaces = 0 : 5; }
                    column(QuantityCaption; LineQuantityCaptionLbl) { }
                    column(LotNoCaption; LotNoCaptionLbl) { }
                    column(DescriptionCaption; LineDescriptionCaptionLbl) { }
                    column(NoCaption; LineNoCaptionLbl) { }

                    trigger OnPreDataItem()
                    begin
                        TrackingSpecBuffer.SetRange("Source Ref. No.", Line."Line No.");
                    end;
                }
                trigger OnPreDataItem()
                begin
                    MoreLines := Line.Find('+');
                    while MoreLines and (Line.Description = '') and (Line."No." = '') and (Line.Quantity = 0) and (Line.Amount = 0) do
                        MoreLines := Line.Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break();
                    Line.SetFilter("Line No.", '<=%1', Line."Line No.");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                    FirstLineHasBeenOutput := false;
                    DummyCompanyInfo.Picture := CompanyInfo.Picture;
                end;

                trigger OnAfterGetRecord()
                begin
                    if Line.Type = Line.Type::"G/L Account" then
                        Line."No." := '';

                    if Line."Line Discount %" = 0 then
                        LineDiscountPctText := ''
                    else
                        LineDiscountPctText := StrSubstNo(LineDiscountPctTok, -Round(Line."Line Discount %", 0.1));

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := Line."Line Amount";

                    FormatDocument.SetSalesLine(Line, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount);

                    GetLineItemInfo(Line);
                    GetLineVATExemption(Line);

                    AsmInfoExistsForLine := false;
                    if DisplayAssemblyInformation then
                        AsmInfoExistsForLine := Line.AsmToOrderExists(AsmHeader);

                    if FirstLineHasBeenOutput then
                        Clear(DummyCompanyInfo.Picture);
                    FirstLineHasBeenOutput := true;
                end;
            }
            dataitem(WorkDescriptionLines; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 .. 99999));

                column(WorkDescriptionLine; WorkDescriptionLine) { }

                trigger OnPreDataItem()
                begin
                    if not ShowWorkDescription then
                        CurrReport.Break();
                    Header."Work Description".CreateInStream(WorkDescriptionInstream, TextEncoding::UTF8);
                end;

                trigger OnAfterGetRecord()
                var
                    TypeHelper: Codeunit "Type Helper";
                begin
                    if WorkDescriptionInstream.EOS then
                        CurrReport.Break();
                    WorkDescriptionLine := TypeHelper.ReadAsTextWithSeparator(WorkDescriptionInstream, TypeHelper.LFSeparator());
                    if WorkDescriptionLine = '' then
                        CurrReport.Break();
                end;

                trigger OnPostDataItem()
                begin
                    Clear(WorkDescriptionInstream);
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;

                column(InvoiceDiscountAmount_VATAmountLine; "Invoice Discount Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountAmount_VATAmountLine_Lbl; FieldCaption("Invoice Discount Amount")) { }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine_Lbl; FieldCaption("Inv. Disc. Base Amount")) { }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_VatAmountLine_Lbl; FieldCaption("Line Amount")) { }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmount_VatAmountLine_Lbl; FieldCaption("VAT Amount")) { }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY) { }
                column(VATAmountLCY_VATAmountLine_Lbl; VATAmountLCYLbl) { }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATBase_VatAmountLine_Lbl; FieldCaption("VAT Base")) { }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY) { }
                column(VATBaseLCY_VATAmountLine_Lbl; VATBaseLCYLbl) { }
                column(VATIdentifier_VatAmountLine; "VAT Identifier") { }
                column(VATIdentifier_VatAmountLine_Lbl; FieldCaption("VAT Identifier")) { }
                column(VATPct_VatAmountLine; "VAT %") { DecimalPlaces = 0 : 5; }
                column(VATPct_VatAmountLine_Lbl; FieldCaption("VAT %")) { }
                column(NoOfVATIdentifiers; Count) { }

                trigger OnPreDataItem()
                begin
                    Clear(VATBaseLCY);
                    Clear(VATAmountLCY);
                    VATClauseLine.DeleteAll();
                end;

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY := VATAmountLine.GetBaseLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");
                    VATAmountLCY := VATAmountLine.GetAmountLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");

                    if VATAmountLine."VAT Clause Code" <> '' then begin
                        VATClauseLine := VATAmountLine;
                        if VATClauseLine.Insert() then;
                    end;
                end;
            }
            dataitem(VATClauseLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;

                column(VATIdentifier_VATClauseLine; "VAT Identifier") { }
                column(Code_VATClauseLine; VATClause.Code) { }
                column(Code_VATClauseLine_Lbl; VATClause.FieldCaption(Code)) { }
                column(Description_VATClauseLine; VATClauseText) { }
                column(Description2_VATClauseLine; VATClause."Description 2") { }
                column(VATAmount_VATClauseLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(NoOfVATClauses; Count) { }

                trigger OnAfterGetRecord()
                begin
                    if VATClauseLine."VAT Clause Code" = '' then
                        CurrReport.Skip();
                    if not VATClause.Get(VATClauseLine."VAT Clause Code") then
                        CurrReport.Skip();
                    VATClauseText := VATClause.GetDescriptionText(Header);
                end;
            }
            dataitem(ReportTotalsLine; "Report Totals Buffer")
            {
                DataItemTableView = sorting("Line No.");
                UseTemporary = true;

                column(Description_ReportTotalsLine; Description) { }
                column(Amount_ReportTotalsLine; Amount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted") { }
                column(FontBold_ReportTotalsLine; "Font Bold") { }
                column(FontUnderline_ReportTotalsLine; "Font Underline") { }

                trigger OnPreDataItem()
                begin
                    CreateReportTotalLines();
                end;
            }
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                column(GreetingText; GreetingLbl) { }
                column(BodyText; BodyLbl) { }
                column(ClosingText; ClosingLbl) { }
                column(PmtDiscText; PmtDiscText) { }

                trigger OnPreDataItem()
                begin
                    PmtDiscText := '';
                    if Header."Payment Discount %" <> 0 then
                        PmtDiscText := StrSubstNo(PmtDiscTxt, Header."Pmt. Discount Date", Header."Payment Discount %");
                end;
            }

            trigger OnPreDataItem()
            begin
                FirstLineHasBeenOutput := false;
            end;

            trigger OnAfterGetRecord()
            var
                ArchiveManagement: Codeunit ArchiveManagement;
                SalesPost: Codeunit "Sales-Post";
            begin
                FirstLineHasBeenOutput := false;
                Clear(Line);
                Clear(SalesPost);
                VATAmountLine.DeleteAll();
                Line.DeleteAll();
                SalesPost.GetSalesLines(Header, Line, 0);
                Line.CalcVATAmountLines(0, Header, Line, VATAmountLine);
                Line.UpdateVATOnLines(0, Header, Line, VATAmountLine);

                if not IsReportInPreviewMode() then
                    Codeunit.Run(Codeunit::"Sales-Printed", Header);

                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(Header."Language Code");
                FormatAddr.SetLanguageCode(Header."Language Code");

                Header.CalcFields("Work Description");
                ShowWorkDescription := Header."Work Description".HasValue();
                WorkDescriptionText := Header.GetWorkDescription();

                FormatAddr.SalesHeaderBillTo(CustAddr, Header);
                ShowShippingAddr := FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, Header);

                if not CompanyBankAccount.Get(Header."Company Bank Account Code") then
                    CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);

                if not Cust.Get(Header."Bill-to Customer No.") then
                    Clear(Cust);
                if not SellToCust.Get(Header."Sell-to Customer No.") then
                    Clear(SellToCust);

                SetCurrencyInfo(Header);
                FormatDocumentFields(Header);
                CustomerBankAccountIBAN := GetCustomerBankAccountIBAN(Header);

                Clear(SellToContact);
                Clear(BillToContact);
                if SellToContact.Get(Header."Sell-to Contact No.") then;
                if BillToContact.Get(Header."Bill-to Contact No.") then;
                SellToContactEmail := SellToContact."E-Mail";
                if SellToContactEmail = '' then
                    SellToContactEmail := Header."Sell-to E-Mail";

                SetChematekHeaderFields(Header);
                FillLotBuffers();
                CalcDocumentTotals();
                FillVATSummary();
                FillVATClauseSummary();
                FillPaymentSchedule();

                if not IsReportInPreviewMode() and
                   (CurrReport.UseRequestPage and ArchiveDocument or
                    not CurrReport.UseRequestPage and SalesSetup."Archive Orders")
                then
                    ArchiveManagement.StoreSalesDocument(Header, LogInteraction);
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

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
            ArchiveDocument := SalesSetup."Archive Orders";
        end;

        trigger OnOpenPage()
        begin
            if Header.GetFilter("Document Type") = '' then
                Header.SetRange("Document Type", Header."Document Type"::Order);
            InitLogInteraction();
            LogInteractionEnable := LogInteraction;
        end;
    }

    rendering
    {
        layout(SalesProformaInvRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMSalesProformaInvoice.rdl';
            Caption = 'Chematek Sales Proforma Invoice';
            Summary = 'Chematek proforma invoice from a sales order with VAT summary, VAT clauses, payment schedule, customer IBAN, lot numbers and dangerous goods information per line.';
        }
    }

    // Report parameters declared in the RDLC layout (Parameters!<Name>.Value).
    labels
    {
        BillToAddress_Caption = 'Bill-to Address';
        CustomerVendorContact_Caption = 'Contact';
        CustomerVendorMail_Caption = 'E-Mail';
        CustomerVendorNo_Caption = 'Customer No.';
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
        Line_UnitPrice_Caption = 'Unit Price';
        Line_UoM_Caption = 'UoM';
        Line_VATIdentifier_Caption = 'VAT';
        NetWeightCaption = 'Net Weight';
        NoOfParcels_Caption = 'No. of Parcels';
        OperatorName_Caption = 'Operator';
        OrderConf_Title = 'Proforma Invoice';
        OrderDate_Caption = 'Order Date';
        Our_Bank = 'Our Bank';
        Page_Caption = 'Page';
        PaymentMethod_Caption = 'Payment Method';
        PaymentTerms_Caption = 'Payment Terms';
        PostingDate_Caption = 'Posting Date';
        Reason_Caption = 'Reason';
        ReturnAddr_Caption = 'Return Address';
        Salesperson_Caption = 'Salesperson';
        ShipmentDate_Caption = 'Shipment Date';
        ShipToAddress_Caption = 'Ship-to Address';
        ShpAgent_Caption = 'Shipping Agent';
        ShptBy_Caption = 'Shipped By';
        ShptMethod_Caption = 'Shipment Method';
        ShptStart_Caption = 'Shipment Start';
        SigDriver_Caption = 'Driver Signature';
        SigRecipient_Caption = 'Recipient Signature';
        SigShpAgent_Caption = 'Shipping Agent Signature';
        Total_DocumentTotalVatExclCaption = 'Total Excl. VAT';
        ValidTo_Caption = 'Valid To';
        VATClausesCaption = 'VAT Clauses';
        VATRegNo_Caption = 'VAT Reg. No.';
        Volume_Caption = 'Volume';
        YourReference_Caption = 'Your Reference';
        TariffNoLbl = 'Tariff No.';
        CountryOfOriginLbl = 'Country of Origin';
        Location_Caption = 'Location';
    }

    trigger OnInitReport()
    var
        SalesHeader: Record "Sales Header";
    begin
        GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        SalesSetup.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();

        if SalesHeader.GetLegalStatement() <> '' then
            LegalStatementLbl := SalesHeader.GetLegalStatement();
    end;

    trigger OnPreReport()
    begin
        if Header.GetFilters() = '' then
            Error(NoFilterSetErr);

        // Proforma "from order": only sales orders are printed, whatever the visible filters are.
        Header.FilterGroup(10);
        Header.SetRange("Document Type", Header."Document Type"::Order);
        Header.FilterGroup(0);

        if not CurrReport.UseRequestPage then
            InitLogInteraction();

        CompanyLogoPosition := SalesSetup."Logo Position on Documents";
        LoadDocumentLogos();
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if Header.FindSet() then
                repeat
                    Header.CalcFields("No. of Archived Versions");
                    if Header."Bill-to Contact No." <> '' then
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Sales Ord. Cnfrmn.".AsInteger(), Header."No.", Header."Doc. No. Occurrence",
                          Header."No. of Archived Versions", Database::Contact, Header."Bill-to Contact No.",
                          Header."Salesperson Code", Header."Campaign No.", Header."Posting Description", Header."Opportunity No.")
                    else
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Sales Ord. Cnfrmn.".AsInteger(), Header."No.", Header."Doc. No. Occurrence",
                          Header."No. of Archived Versions", Database::Customer, Header."Bill-to Customer No.",
                          Header."Salesperson Code", Header."Campaign No.", Header."Posting Description", Header."Opportunity No.");
                until Header.Next() = 0;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        DummyCompanyInfo: Record "Company Information";
        CHMSetup: Record "CHM Customizations Setup";
        CompanyBankAccount: Record "Bank Account";
        Cust: Record Customer;
        SellToCust: Record Customer;
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        VATClause: Record "VAT Clause";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        AsmHeader: Record "Assembly Header";
        LanguageMgt: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        WorkDescriptionInstream: InStream;
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        WorkDescriptionLine: Text;
        WorkDescriptionText: Text;
        ShowWorkDescription: Boolean;
        ShowShippingAddr: Boolean;
        MoreLines: Boolean;
        FirstLineHasBeenOutput: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        CompanyLogoPosition: Integer;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        PmtDiscText: Text;
        LegalStatementLbl: Text;
        CurrCode: Text[10];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalVATAmountText: Text[30];
        SalesPersonText: Text[50];
        SellToContactEmail: Text[80];
        VATClauseText: Text;
        LineDiscountPctText: Text;
        FormattedVATPct: Text;
        FormattedUnitPrice: Text;
        FormattedQuantity: Text;
        FormattedLineAmount: Text;

        // Totals
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        TotalLineDiscount: Decimal;
        TransHeaderAmount: Decimal;
        PrevLineAmount: Decimal;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;

        // Chematek header fields
        OperatorName: Text;
        LocationName: Text;
        LocationAddress: Text;
        LocationCity: Text;
        ViewLocation: Boolean;
        ReasonCodeText: Text;
        ShippingAgentName: Text;
        FiscalCodeNo: Text;
        CustomerBankAccountIBAN: Text;
        ShowIso: Boolean;

        // Line item / dangerous goods fields
        ItemHazardousDescr: Text;
        Hazardous: Boolean;
        TariffNo: Text;
        ADRClass: Text;
        ItemUN: Text;
        ItemUNValue: Text;
        CountryOrigin: Text;

        // Line VAT exemption fields
        VATExemptDocumentNo: Code[20];
        VATExemptLineNo: Integer;
        NoVATExemption: Boolean;
        VATExemptSource: Text;
        VATExemptStartingDate: Text;
        VATExemptEndingDate: Text;
        VATExemptNo: Text;
        VATExemptionType: Text;
        LotBufferEntryNo: Integer;

        // Fixed slots used by the layout
        VATSlotCode: array[4] of Code[20];
        VATSlotDescription: array[4] of Text;
        VATSlotPct: array[4] of Decimal;
        VATSlotBase: array[4] of Decimal;
        VATSlotAmount: array[4] of Decimal;
        VATSlotDiscount: array[4] of Decimal;
        VATClauseSlotCode: array[4] of Code[20];
        VATClauseSlotDescription: array[4] of Text;
        ShowVATClauseTab: Boolean;
        DueDateSlot: array[4] of Text;
        DueAmountSlot: array[4] of Decimal;

        // Captions
        ProformaInvoiceCaptionLbl: Label 'Proforma Invoice';
        OrderCaptionLbl: Label 'Order';
        QuoteNoCaptionLbl: Label 'Quote No.';
        BillToAddressCaptionLbl: Label 'Bill-to Address';
        ShipToAddressCaptionLbl: Label 'Ship-to Address';
        DocumentNoCaptionLbl: Label 'No.';
        DateCaptionLbl: Label 'Date';
        ReasonCaptionLbl: Label 'Reason';
        CustomerNoCaptionLbl: Label 'Customer No.';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        FiscalCodeCaptionLbl: Label 'Fiscal Code';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        PaymentMethodCaptionLbl: Label 'Payment Method';
        SalespersonCaptionLbl: Label 'Salesperson';
        OperatorCaptionLbl: Label 'Operator';
        DeliveryTermsCaptionLbl: Label 'Delivery Terms';
        OurBankCaptionLbl: Label 'Our Bank';
        ShippingAgentCaptionLbl: Label 'Shipping Agent';
        YourReferenceCaptionLbl: Label 'Your Reference';
        RequestedDeliveryDateCaptionLbl: Label 'Delivery Date';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        NetAmountToPayCaptionLbl: Label 'Net Amount to Pay';
        TotalVATCaptionLbl: Label 'Total VAT';
        TaxableAmountCaptionLbl: Label 'Taxable Amount';
        DocumentTotalCaptionLbl: Label 'Document Total';
        VATCodeCaptionLbl: Label 'VAT Code';
        VATDescriptionCaptionLbl: Label 'VAT Description';
        PaymentAmountCaptionLbl: Label 'Amount Due';
        DueDateCaptionLbl: Label 'Due Date';
        ShipmentFromCaptionLbl: Label 'Shipment from';
        LineNoCaptionLbl: Label 'Item No.';
        LineDescriptionCaptionLbl: Label 'Description';
        LineQuantityCaptionLbl: Label 'Quantity';
        LineUoMCaptionLbl: Label 'UoM';
        LinePriceCaptionLbl: Label 'Unit Price';
        LineDiscPctCaptionLbl: Label 'Disc. %';
        LineAmountCaptionLbl: Label 'Amount';
        LineVATCaptionLbl: Label 'VAT';
        LineShipmentDateCaptionLbl: Label 'Shipment Date';
        LotNoCaptionLbl: Label 'Lot No.';
        CountryOfOriginCaptionLbl: Label 'Country of Origin:';
        TariffNoCaptionLbl: Label 'Tariff No.:';
        UNNoCaptionLbl: Label 'UN No.:';
        ADRClassCaptionLbl: Label 'ADR Class:';

        // Standard report 1305 texts
        CopyLbl: Label 'Copy';
        InvDiscBaseAmtLbl: Label 'Invoice Discount Base Amount';
        InvDiscountAmtLbl: Label 'Invoice Discount';
        LineAmtAfterInvDiscLbl: Label 'Payment Discount on VAT';
        LocalCurrencyLbl: Label 'Local Currency';
        PageLbl: Label 'Page';
        SalesInvLineDiscLbl: Label 'Discount %';
        ShipmentLbl: Label 'Shipment';
        SubtotalLbl: Label 'Subtotal';
        TotalLbl: Label 'Total';
        VATAmtSpecificationLbl: Label 'VAT Amount Specification';
        VATAmtLbl: Label 'VAT Amount';
        VATAmountLCYLbl: Label 'VAT Amount (LCY)';
        VATBaseLbl: Label 'VAT Base';
        VATBaseLCYLbl: Label 'VAT Base (LCY)';
        VATClausesLbl: Label 'VAT Clause';
        VATIdentifierLbl: Label 'VAT Identifier';
        VATPercentageLbl: Label 'VAT %';
        SellToContactPhoneNoLbl: Label 'Sell-to Contact Phone No.';
        SellToContactMobilePhoneNoLbl: Label 'Sell-to Contact Mobile Phone No.';
        SellToContactEmailLbl: Label 'Sell-to Contact E-Mail';
        BillToContactPhoneNoLbl: Label 'Bill-to Contact Phone No.';
        BillToContactMobilePhoneNoLbl: Label 'Bill-to Contact Mobile Phone No.';
        BillToContactEmailLbl: Label 'Bill-to Contact E-Mail';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Thank you for your business. Your proforma invoice is attached to this message.';
        PmtDiscTxt: Label 'If we receive the payment before %1, you are eligible for a %2% payment discount.', Comment = '%1 = Discount Due Date %2 = value of Payment Discount % ';
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';
        LCYTxt: Label ' (LCY)';
        LineDiscountPctTok: Label '%1%', Locked = true;
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidentally printing all documents.';

    /// <summary>
    /// Initializes the request options when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; NewDisplayAssemblyInformation: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := NewDisplayAssemblyInformation;
    end;

    /// <summary>
    /// Initializes the request options, including archiving, when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; NewDisplayAssemblyInformation: Boolean; NewArchiveDocument: Boolean)
    begin
        InitializeRequest(NewLogInteraction, NewDisplayAssemblyInformation);
        ArchiveDocument := NewArchiveDocument;
    end;

    local procedure InitLogInteraction()
    begin
        // BC has no interaction document type for proforma invoices: the proforma is logged as an
        // order confirmation, like the order it is printed from.
        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Ord. Cnfrmn.") <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure SetCurrencyInfo(SalesHeader: Record "Sales Header")
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        ExchangeRateText := '';
        if SalesHeader."Currency Code" <> '' then begin
            CurrencyExchangeRate.FindCurrency(SalesHeader."Posting Date", SalesHeader."Currency Code", 1);
            CalculatedExchRate :=
              Round(1 / SalesHeader."Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
            ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
            CurrCode := SalesHeader."Currency Code";
        end else
            CurrCode := GLSetup."LCY Code";
    end;

    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        FormatDocument.SetTotalLabels(SalesHeader.GetCurrencySymbol(), TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesHeader."Payment Terms Code", SalesHeader."Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesHeader."Payment Method Code", SalesHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");
    end;

    local procedure SetChematekHeaderFields(SalesHeader: Record "Sales Header")
    var
        Location: Record Location;
        ReasonCode: Record "Reason Code";
        ShippingAgent: Record "Shipping Agent";
    begin
        // Operator: the user assigned to the order, otherwise the user printing it.
        if SalesHeader."Assigned User ID" <> '' then
            OperatorName := GetUserFullName(SalesHeader."Assigned User ID")
        else
            OperatorName := GetUserFullName(CopyStr(UserId(), 1, 50));

        // Shipment from: the location on the order.
        LocationName := '';
        LocationAddress := '';
        LocationCity := '';
        if SalesHeader."Location Code" <> '' then
            if Location.Get(SalesHeader."Location Code") then begin
                LocationName := Location.Name;
                LocationAddress := Location.Address;
                if Location."Address 2" <> '' then
                    LocationAddress += ' ' + Location."Address 2";
                LocationCity := DelChr(Location."Post Code" + ' ' + Location.City, '<>', ' ');
                if Location.County <> '' then
                    LocationCity += ' (' + Location.County + ')';
            end;
        ViewLocation := LocationAddress <> '';

        // Reason code (DEV-005): print the description, fall back to the code.
        ReasonCodeText := SalesHeader."Reason Code";
        if SalesHeader."Reason Code" <> '' then
            if ReasonCode.Get(SalesHeader."Reason Code") then
                if ReasonCode.Description <> '' then
                    ReasonCodeText := ReasonCode.Description;

        ShippingAgentName := SalesHeader."Shipping Agent Code";
        if SalesHeader."Shipping Agent Code" <> '' then
            if ShippingAgent.Get(SalesHeader."Shipping Agent Code") then
                if ShippingAgent.Name <> '' then
                    ShippingAgentName := ShippingAgent.Name;

        FiscalCodeNo := GetCustomerFiscalCode(SalesHeader."Bill-to Customer No.");
    end;

    local procedure GetCustomerBankAccountIBAN(SalesHeader: Record "Sales Header"): Text
    var
        BillToCustomer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        // Preferred bank account of the bill-to customer.
        if not BillToCustomer.Get(SalesHeader."Bill-to Customer No.") then
            exit('');
        if BillToCustomer."Preferred Bank Account Code" = '' then
            exit('');
        if not CustomerBankAccount.Get(BillToCustomer."No.", BillToCustomer."Preferred Bank Account Code") then
            exit('');
        exit(CustomerBankAccount.IBAN);
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

    local procedure CalcDocumentTotals()
    var
        TempSalesLineCalc: Record "Sales Line" temporary;
        TempVATAmountLineCalc: Record "VAT Amount Line" temporary;
    begin
        TotalSubTotal := 0;
        TotalInvDiscAmount := 0;
        TotalAmount := 0;
        TotalAmountVAT := 0;
        TotalAmountInclVAT := 0;
        TotalPaymentDiscOnVAT := 0;
        TotalVATBaseLCY := 0;
        TotalVATAmountLCY := 0;
        TotalLineDiscount := 0;

        TempSalesLineCalc.Copy(Line, true);
        TempSalesLineCalc.Reset();
        if TempSalesLineCalc.FindSet() then
            repeat
                TotalSubTotal += TempSalesLineCalc."Line Amount";
                TotalLineDiscount += TempSalesLineCalc."Line Discount Amount";
                TotalInvDiscAmount -= TempSalesLineCalc."Inv. Discount Amount";
                TotalAmount += TempSalesLineCalc.Amount;
                TotalAmountVAT += TempSalesLineCalc."Amount Including VAT" - TempSalesLineCalc.Amount;
                TotalAmountInclVAT += TempSalesLineCalc."Amount Including VAT";
                TotalPaymentDiscOnVAT += -(TempSalesLineCalc."Line Amount" - TempSalesLineCalc."Inv. Discount Amount" - TempSalesLineCalc."Amount Including VAT");
            until TempSalesLineCalc.Next() = 0;

        TempVATAmountLineCalc.Copy(VATAmountLine, true);
        TempVATAmountLineCalc.Reset();
        if TempVATAmountLineCalc.FindSet() then
            repeat
                TotalVATBaseLCY += TempVATAmountLineCalc.GetBaseLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");
                TotalVATAmountLCY += TempVATAmountLineCalc.GetAmountLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");
            until TempVATAmountLineCalc.Next() = 0;

        TotalVATAmountText := VATAmountLine.VATAmountText();
    end;

    local procedure FillVATSummary()
    var
        TempVATAmountLineCalc: Record "VAT Amount Line" temporary;
        SlotNo: Integer;
    begin
        // The layout prints at most 4 VAT rates. Additional rates are not printed in the summary.
        Clear(VATSlotCode);
        Clear(VATSlotDescription);
        Clear(VATSlotPct);
        Clear(VATSlotBase);
        Clear(VATSlotAmount);
        Clear(VATSlotDiscount);

        TempVATAmountLineCalc.Copy(VATAmountLine, true);
        TempVATAmountLineCalc.Reset();
        if TempVATAmountLineCalc.FindSet() then
            repeat
                SlotNo += 1;
                if SlotNo <= ArrayLen(VATSlotCode) then begin
                    VATSlotCode[SlotNo] := TempVATAmountLineCalc."VAT Identifier";
                    VATSlotDescription[SlotNo] := GetVATDescription(TempVATAmountLineCalc);
                    VATSlotPct[SlotNo] := TempVATAmountLineCalc."VAT %";
                    VATSlotBase[SlotNo] := TempVATAmountLineCalc."VAT Base";
                    VATSlotAmount[SlotNo] := TempVATAmountLineCalc."VAT Amount";
                    VATSlotDiscount[SlotNo] := TempVATAmountLineCalc."Invoice Discount Amount";
                end;
            until TempVATAmountLineCalc.Next() = 0;
    end;

    local procedure GetVATDescription(VATAmountLineRec: Record "VAT Amount Line"): Text
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.SetRange("VAT Bus. Posting Group", Header."VAT Bus. Posting Group");
        VATPostingSetup.SetRange("VAT Identifier", VATAmountLineRec."VAT Identifier");
        if VATPostingSetup.FindFirst() then
            if VATPostingSetup.Description <> '' then
                exit(VATPostingSetup.Description);
        exit(VATAmountLineRec."VAT Identifier");
    end;

    local procedure FillVATClauseSummary()
    var
        TempVATAmountLineCalc: Record "VAT Amount Line" temporary;
        VATClauseRec: Record "VAT Clause";
        SlotNo: Integer;
        i: Integer;
        AlreadyAdded: Boolean;
    begin
        Clear(VATClauseSlotCode);
        Clear(VATClauseSlotDescription);

        TempVATAmountLineCalc.Copy(VATAmountLine, true);
        TempVATAmountLineCalc.Reset();
        TempVATAmountLineCalc.SetFilter("VAT Clause Code", '<>%1', '');
        if TempVATAmountLineCalc.FindSet() then
            repeat
                AlreadyAdded := false;
                for i := 1 to SlotNo do
                    if VATClauseSlotCode[i] = TempVATAmountLineCalc."VAT Clause Code" then
                        AlreadyAdded := true;
                if not AlreadyAdded and (SlotNo < ArrayLen(VATClauseSlotCode)) then
                    if VATClauseRec.Get(TempVATAmountLineCalc."VAT Clause Code") then begin
                        SlotNo += 1;
                        VATClauseSlotCode[SlotNo] := VATClauseRec.Code;
                        VATClauseSlotDescription[SlotNo] := VATClauseRec.GetDescriptionText(Header);
                    end;
            until TempVATAmountLineCalc.Next() = 0;

        ShowVATClauseTab := SlotNo > 0;
    end;

    local procedure FillPaymentSchedule()
    begin
        // Standard BC (W1) has one due date per document, so only the first slot is used.
        // The other 3 slots are kept because the layout expects them.
        Clear(DueDateSlot);
        Clear(DueAmountSlot);
        if TotalAmountInclVAT = 0 then
            exit;
        DueDateSlot[1] := Format(Header."Due Date");
        DueAmountSlot[1] := TotalAmountInclVAT;
    end;

    local procedure GetLineItemInfo(SalesLine: Record "Sales Line")
    var
        Item: Record Item;
        CountryRegion: Record "Country/Region";
    begin
        Hazardous := false;
        ItemHazardousDescr := '';
        ADRClass := '';
        ItemUN := '';
        ItemUNValue := '';
        TariffNo := '';
        CountryOrigin := '';

        if SalesLine.Type <> SalesLine.Type::Item then
            exit;
        if not Item.Get(SalesLine."No.") then
            exit;

        TariffNo := Item."Tariff No.";
        if Item."Country/Region of Origin Code" <> '' then begin
            CountryOrigin := Item."Country/Region of Origin Code";
            if CountryRegion.Get(Item."Country/Region of Origin Code") then
                if CountryRegion.Name <> '' then
                    CountryOrigin := CountryRegion.Name;
        end;

        GetItemDangerousGoodsInfo(Item, Hazardous, ItemHazardousDescr, ADRClass, ItemUN);
        // The layout shows the UN row when ItemUNValue is filled and prints ItemUN.
        ItemUNValue := ItemUN;
    end;

    local procedure GetItemDangerousGoodsInfo(Item: Record Item; var IsHazardous: Boolean; var HazardousDescription: Text; var ADRClassCode: Text; var UNNo: Text)
    begin
        // TODO (pending decision): standard BC has no dangerous goods fields on the item.
        // Fill these from the agreed source (new Item table extension fields, item attributes
        // or an existing extension). Until then the hazardous / ADR / UN rows are not printed.
        IsHazardous := false;
        HazardousDescription := '';
        ADRClassCode := '';
        UNNo := '';
    end;

    local procedure GetCustomerFiscalCode(CustomerNo: Code[20]): Text
    begin
        // TODO (pending decision): standard BC has no Fiscal Code (Codice Fiscale) on the customer.
        // Return it from the agreed source for CustomerNo, e.g. a Customer table extension field.
        exit('');
    end;

    local procedure GetLineVATExemption(SalesLine: Record "Sales Line")
    begin
        VATExemptDocumentNo := '';
        VATExemptLineNo := 0;
        NoVATExemption := false;
        VATExemptSource := '';
        VATExemptStartingDate := '';
        VATExemptEndingDate := '';
        VATExemptNo := '';
        VATExemptionType := '';

        // TODO (pending decision): the old layout read these values from the "CHM Doc VAT Exemption Link"
        // table, which does not exist in this extension. Fill them from the agreed source for SalesLine
        // (e.g. the VAT exemption / declaration of intent of the customer). Until then the VAT exemption
        // row under the line is not printed.
    end;

    local procedure FillLotBuffers()
    var
        TempSalesLineCalc: Record "Sales Line" temporary;
        ReservEntry: Record "Reservation Entry";
    begin
        TrackingSpecBuffer.Reset();
        TrackingSpecBuffer.DeleteAll();
        LotBufferEntryNo := 0;

        TempSalesLineCalc.Copy(Line, true);
        TempSalesLineCalc.Reset();
        TempSalesLineCalc.SetRange(Type, TempSalesLineCalc.Type::Item);
        TempSalesLineCalc.SetFilter("No.", '<>%1', '');
        if not TempSalesLineCalc.FindSet() then
            exit;
        repeat
            // Lots on the item tracking lines for the quantity still to be shipped.
            ReservEntry.Reset();
            ReservEntry.SetSourceFilter(
              Database::"Sales Line", TempSalesLineCalc."Document Type".AsInteger(), TempSalesLineCalc."Document No.", TempSalesLineCalc."Line No.", false);
            ReservEntry.SetSourceFilter('', 0);
            ReservEntry.SetFilter("Lot No.", '<>%1', '');
            if ReservEntry.FindSet() then
                repeat
                    AddLotToBuffer(TrackingSpecBuffer, TempSalesLineCalc, ReservEntry."Lot No.", Abs(ReservEntry."Quantity (Base)"));
                until ReservEntry.Next() = 0;

        until TempSalesLineCalc.Next() = 0;
    end;

    local procedure AddLotToBuffer(var TempLotBuffer: Record "Tracking Specification" temporary; SalesLine: Record "Sales Line"; LotNo: Code[50]; QtyBase: Decimal)
    begin
        if QtyBase = 0 then
            exit;

        // One row per order line and lot.
        TempLotBuffer.Reset();
        TempLotBuffer.SetRange("Source Ref. No.", SalesLine."Line No.");
        TempLotBuffer.SetRange("Lot No.", LotNo);
        if TempLotBuffer.FindFirst() then begin
            TempLotBuffer."Quantity (Base)" += QtyBase;
            TempLotBuffer."Qty. to Handle" := CalcLineQty(TempLotBuffer."Quantity (Base)", SalesLine."Qty. per Unit of Measure");
            TempLotBuffer.Modify();
        end else begin
            LotBufferEntryNo += 1;
            TempLotBuffer.Init();
            TempLotBuffer."Entry No." := LotBufferEntryNo;
            TempLotBuffer."Source Type" := Database::"Sales Line";
            TempLotBuffer."Source Subtype" := SalesLine."Document Type".AsInteger();
            TempLotBuffer."Source ID" := SalesLine."Document No.";
            TempLotBuffer."Source Ref. No." := SalesLine."Line No.";
            TempLotBuffer."Item No." := SalesLine."No.";
            TempLotBuffer."Variant Code" := SalesLine."Variant Code";
            TempLotBuffer.Description := SalesLine.Description;
            TempLotBuffer."Lot No." := LotNo;
            TempLotBuffer."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
            TempLotBuffer."Quantity (Base)" := QtyBase;
            TempLotBuffer."Qty. to Handle" := CalcLineQty(QtyBase, SalesLine."Qty. per Unit of Measure");
            TempLotBuffer.Insert();
        end;
        TempLotBuffer.Reset();
    end;

    local procedure CalcLineQty(QtyBase: Decimal; QtyPerUoM: Decimal): Decimal
    begin
        if QtyPerUoM = 0 then
            exit(QtyBase);
        exit(Round(QtyBase / QtyPerUoM, 0.00001));
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

    local procedure CreateReportTotalLines()
    begin
        ReportTotalsLine.DeleteAll();
        if (TotalInvDiscAmount <> 0) or (TotalAmountVAT <> 0) then
            ReportTotalsLine.Add(SubtotalLbl, TotalSubTotal, true, false, false, Header."Currency Code");
        if TotalInvDiscAmount <> 0 then begin
            ReportTotalsLine.Add(InvDiscountAmtLbl, TotalInvDiscAmount, false, false, false, Header."Currency Code");
            if TotalAmountVAT <> 0 then
                ReportTotalsLine.Add(TotalExclVATText, TotalAmount, true, false, false, Header."Currency Code");
        end;
        if TotalAmountVAT <> 0 then begin
            ReportTotalsLine.Add(VATAmountLine.VATAmountText(), TotalAmountVAT, false, true, false, Header."Currency Code");
            if TotalVATAmountLCY <> TotalAmountVAT then
                ReportTotalsLine.Add(VATAmountLine.VATAmountText() + LCYTxt, TotalVATAmountLCY, false, true, false);
        end;
    end;
}
