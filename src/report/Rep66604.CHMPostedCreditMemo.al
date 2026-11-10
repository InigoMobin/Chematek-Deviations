report 66604 "CHM Posted Credit Memo"
{
    // Chematek Posted Sales Credit Memo.
    // Based on the standard "Standard Sales - Credit Memo" (report 1307, BC 28 W1), extended with the
    // columns used by the Chematek RDLC layout (DataSet_Result, 323 fields + their Format companions).
    // The layout shares its structure with the CHM Posted Sales Invoice layout (report 66603), so the
    // column names, the fixed VAT / due date slots and the Chematek header fields follow that report.
    // Column names must stay exactly as they are: the RDLC layout binds to them by name.
    // Decimal columns automatically get a companion "<n>Format" field in the RDLC dataset,
    // which is why no "...Format" columns are declared here.
    // Everything the page header / footer reads (captions, totals, VAT summary, due dates, shipment
    // data) is declared on the Header data item, so it is available on every row of the dataset.

    Caption = 'CHM Posted Credit Memo';
    UsageCategory = None;
    DefaultRenderingLayout = PostedCreditMemoRDLC;
    PreviewMode = PrintLayout;
    Permissions = tabledata "Sales Shipment Buffer" = rimd;

    dataset
    {
        dataitem(Header; "Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Bill-to Customer No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Posted Sales Credit Memo';

            // Addresses
            // The layout prints SelltoCustomerNo_Lbl as the caption above the customer address box,
            // so it carries the "Bill-to Address" caption (the customer no. has its own caption, CustomerVendorNoLbl).
            column(SelltoCustomerNo_Lbl; BillToAddressCaptionLbl)
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
            column(ShowShippingAddress; ShowShippingAddr)
            {

            }
            column(BillAndShipSame; not ShowShippingAddr)
            {

            }
            column(CustomerPostalBarCode; FormatAddr.PostalBarCode(1))
            {

            }

            // Document header captions
            // The layout prints SalesInvoiceLbl as the document title (the column name comes from the invoice layout).
            column(SalesInvoiceLbl; SalesCrMemoLbl)
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
            column(SellToContactEmailLbl; SellToContactEmailLbl)
            {

            }
            column(BillToContactEmailLbl; BillToContactEmailLbl)
            {

            }
            column(SellToContactPhoneNoLbl; SellToContactPhoneNoLbl)
            {

            }
            column(SellToContactMobilePhoneNoLbl; SellToContactMobilePhoneNoLbl)
            {

            }
            column(BillToContactPhoneNoLbl; BillToContactPhoneNoLbl)
            {

            }
            column(BillToContactMobilePhoneNoLbl; BillToContactMobilePhoneNoLbl)
            {

            }
            column(ShptMethodLbl; ShipmentMethodCaptionLbl)
            {

            }
            column(ShptTermsLbl; DeliveryTermsCaptionLbl)
            {

            }
            column(ReasonLbl; ReasonCaptionLbl)
            {

            }
            column(DocumentNo_Lbl; CrMemoNoLbl)
            {

            }
            column(CompanyPhoneNo_Lbl; CompanyInfoPhoneNoLbl)
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
            column(FooterLogo; CHMSetup."Footer Logo")
            {

            }
            column(ShowIso; ShowIso)
            {

            }

            // Chematek header fields
            column(SelltoCustomerNo; Header."Sell-to Customer No.")
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
            column(AssignedUserID; Header."User ID")
            {

            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {

            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {

            }
            column(SellToContactNo; Header."Sell-to Contact No.")
            {

            }
            column(SellToContactName; Header."Sell-to Contact")
            {

            }
            column(SellToContactEmail; SellToContactEmail)
            {

            }
            column(SellToContactPhoneNo; SellToContact."Phone No.")
            {

            }
            column(SellToContactMobilePhoneNo; SellToContact."Mobile Phone No.")
            {

            }
            column(BillToContactEmail; BillToContact."E-Mail")
            {

            }
            column(BillToContactPhoneNo; BillToContact."Phone No.")
            {

            }
            column(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.")
            {

            }
            column(SellToPhoneNo; Header."Sell-to Phone No.")
            {

            }
            column(ShipmentDate; Format(Header."Shipment Date"))
            {

            }
            column(ShipmentDate_Lbl; Header.FieldCaption("Shipment Date"))
            {

            }
            column(OurBankAccount; OurBankAccountText)
            {

            }
            column(OurBank; CompanyBankAccount.Name)
            {

            }
            column(CompanyBankName; CompanyBankAccount.Name)
            {

            }
            column(CompanyBankName_Lbl; CompanyInfoBankNameLbl)
            {

            }
            column(CompanyBankAccountNo; CompanyBankAccount."Bank Account No.")
            {

            }
            column(CompanyBankAccountNo_Lbl; CompanyInfoBankAccNoLbl)
            {

            }
            column(CompanyIBAN; CompanyBankAccount.IBAN)
            {

            }
            column(CompanyIBAN_Lbl; CompanyBankAccount.FieldCaption(IBAN))
            {

            }
            column(CompanySWIFT; CompanyBankAccount."SWIFT Code")
            {

            }
            column(SWIFTCode; CompanyBankAccount."SWIFT Code")
            {

            }
            column(CompanySWIFT_Lbl; CompanyBankAccount.FieldCaption("SWIFT Code"))
            {

            }
            column(VATRegistrationNo; Header.GetCustomerVATRegistrationNumber())
            {

            }
            column(VATRegistrationNo_Lbl; Header.GetCustomerVATRegistrationNumberLbl())
            {

            }
            // "Resa" = delivery terms. Printed under the Delivery Terms caption (ShptTermsLbl).
            column(ResaDescr; ShipmentMethod.Description)
            {

            }
            column(ReasonCode; ReasonCodeText)
            {

            }
            column(Source_Code; Header."Source Code")
            {

            }
            column(LocationAddress; LocationAddress)
            {

            }
            column(ShipmentFrom_Caption; ShipmentFromCaptionLbl)
            {

            }
            column(CurrencyCode; CurrCode)
            {

            }
            column(Salesperson; SalespersonPurchaser.Name)
            {

            }

            // Shipment data. A credit memo has no posted sales shipment, so these stay 0 and the
            // layout does not print them (see CalcShipmentTotals).
            column(NoOfParcels; TotalParcels)
            {

            }
            column(NoOfPallets; TotalPallets)
            {

            }
            column(NetWeight; TotalNetWeight) { DecimalPlaces = 0 : 5; }
            column(GrossWeight; TotalGrossWeight) { DecimalPlaces = 0 : 5; }
            column(NoPalletsLbl; NoOfPalletsCaptionLbl)
            {

            }
            column(NoParcelsLbl; NoOfParcelsCaptionLbl)
            {

            }
            column(GrossWLbl; GrossWeightCaptionLbl)
            {

            }
            column(NetWLbl; NetWeightCaptionLbl)
            {

            }

            // Totals / VAT summary / payment captions
            column(Total_NetAmountToPayCaption; NetAmountToPayCaptionLbl)
            {

            }
            column(Total_TotalAmountCaption; TotalVATCaptionLbl)
            {

            }
            column(Total_TotalBaseCaption; TaxableAmountCaptionLbl)
            {

            }
            column(Total_TotalInvDiscCaption; InvDiscountAmtLbl)
            {

            }
            column(Total_TotalCaption; SubtotalLbl)
            {

            }
            column(Total_DocumentTotalCaption; DocumentTotalCaptionLbl)
            {

            }
            column(VAT_InvDisc_Caption; InvDiscountAmtLbl)
            {

            }
            column(VAT_Line_VATIdentifier_Caption; VATCodeCaptionLbl)
            {

            }
            column(VAT_VATAmount_Caption; VATAmtLbl)
            {

            }
            column(VAT_VATBase_Caption; TaxableAmountCaptionLbl)
            {

            }
            column(VAT_VATPercent_Caption; VATPercentageLbl)
            {

            }
            column(VAT_VATText_Caption; VATDescriptionCaptionLbl)
            {

            }
            column(Payment_Amount_Caption; PaymentAmountCaptionLbl)
            {

            }
            column(Payment_DueDate_Caption; DueDateCaptionLbl)
            {

            }

            // Line table captions (header row of the lines table)
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
            column(Price_Lbl; LinePriceCaptionLbl)
            {

            }
            column(UnitPrice_Lbl; LinePriceCaptionLbl)
            {

            }
            column(SalesInvoiceLineDiscount_Lbl; LineDiscPctCaptionLbl)
            {

            }
            column(SalesCrMemoLineDiscount_Lbl; LineDiscPctCaptionLbl)
            {

            }
            column(LineAmount_Lbl; LineAmountCaptionLbl)
            {

            }
            column(VATIdentifier_Lbl; LineVATCaptionLbl)
            {

            }
            column(AmountExcludingVAT_Line_Lbl; AmountExclVATCaptionLbl)
            {

            }
            column(AmountIncludingVAT_Line_Lbl; AmountInclVATCaptionLbl)
            {

            }
            column(LineAmount_Line_Lbl; LineAmountCaptionLbl)
            {

            }
            column(VATIdentifier_Line_Lbl; LineVATCaptionLbl)
            {

            }
            column(VATPct_Line_Lbl; VATPercentageLbl)
            {

            }
            column(Qty_Lbl; QtyLbl)
            {

            }
            column(PricePer_Lbl; PricePerLbl)
            {

            }
            column(Unit_Lbl; UnitLbl)
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

            // Company information
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber())
            {

            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl())
            {

            }

            // Standard sales credit memo header fields
            column(DisplayAdditionalFeeNote; DisplayAdditionalFeeNote)
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
            column(Shipment_Lbl; ShipmentLbl)
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
            column(PricesIncludingVAT; Header."Prices Including VAT")
            {

            }
            column(PricesIncludingVAT_Lbl; Header.FieldCaption("Prices Including VAT"))
            {

            }
            column(PricesIncludingVATYesNo; Format(Header."Prices Including VAT"))
            {

            }
            column(SalesPersonBlank_Lbl; SalesPersonText)
            {

            }
            column(From_Lbl; FromLbl)
            {

            }
            column(BilledTo_Lbl; BilledToLbl)
            {

            }
            column(ChecksPayable_Lbl; ChecksPayableText)
            {

            }
            column(LegalEntityType; Cust.GetLegalEntityType())
            {

            }
            column(LegalEntityType_Lbl; Cust.GetLegalEntityTypeLbl())
            {

            }
            column(Copy_Lbl; CopyLbl)
            {

            }
            column(EMail_Header_Lbl; EMailLbl)
            {

            }
            column(HomePage_Header_Lbl; HomePageLbl)
            {

            }
            column(InvoiceDiscountBaseAmount_Lbl; InvDiscBaseAmtLbl)
            {

            }
            column(InvoiceDiscountAmount_Lbl; InvDiscountAmtLbl)
            {

            }
            column(LineAmountAfterInvoiceDiscount_Lbl; LineAmtAfterInvDiscLbl)
            {

            }
            column(LocalCurrency_Lbl; LocalCurrencyLbl)
            {

            }
            column(ExchangeRateAsText; ExchangeRateText)
            {

            }
            column(Page_Lbl; PageLbl)
            {

            }
            column(Questions_Lbl; QuestionsLbl)
            {

            }
            column(Contact_Lbl; CompanyInfo.GetContactUsText())
            {

            }
            column(DocumentTitle_Lbl; SalesCrMemoLbl)
            {

            }
            column(YourDocumentTitle_Lbl; YourSalesCrMemoLbl)
            {

            }
            column(Thanks_Lbl; ThanksLbl)
            {

            }
            column(ShowWorkDescription; ShowWorkDescription)
            {

            }
            column(RemainingAmount; RemainingAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(RemainingAmountText; RemainingAmountTxt)
            {

            }
            column(Subtotal_Lbl; SubtotalLbl)
            {

            }
            column(Total_Lbl; TotalLbl)
            {

            }
            column(VATAmount_Lbl; VATAmtLbl)
            {

            }
            column(VATBase_Lbl; VATBaseLbl)
            {

            }
            column(VATAmountSpecification_Lbl; VATAmtSpecificationLbl)
            {

            }
            column(VATClauses_Lbl; VATClausesLbl)
            {

            }
            column(VATPercentage_Lbl; VATPercentageLbl)
            {

            }
            column(VATClause_Lbl; VATClause.TableCaption())
            {

            }
            column(PackageTrackingNo; Header."Package Tracking No.")
            {

            }
            column(PackageTrackingNo_Lbl; Header.FieldCaption("Package Tracking No."))
            {

            }
            column(ShippingAgentCode; Header."Shipping Agent Code")
            {

            }
            column(ShippingAgentCode_Lbl; Header.FieldCaption("Shipping Agent Code"))
            {

            }
            column(PaymentInstructions_Txt; PaymentInstructionsTxt)
            {

            }
            column(ExternalDocumentNo; Header."External Document No.")
            {

            }
            column(ExternalDocumentNo_Lbl; Header.FieldCaption("External Document No."))
            {

            }

            // VAT summary: 4 fixed slots (see FillVATSummary). Names/casing match the layout.
            column(CodIVA1; VATSlotCode[1])
            {

            }
            column(CodIVA2; VATSlotCode[2])
            {

            }
            column(CodIva3; VATSlotCode[3])
            {

            }
            column(CodIva4; VATSlotCode[4])
            {

            }
            column(VatPerc1; VATSlotPct[1]) { DecimalPlaces = 0 : 5; }
            column(VatPerc2; VATSlotPct[2]) { DecimalPlaces = 0 : 5; }
            column(VatPerc3; VATSlotPct[3]) { DecimalPlaces = 0 : 5; }
            column(VatPerc4; VATSlotPct[4]) { DecimalPlaces = 0 : 5; }
            column(DesIVA1; VATSlotDescription[1])
            {

            }
            column(DesIVA2; VATSlotDescription[2])
            {

            }
            column(DesIVA3; VATSlotDescription[3])
            {

            }
            column(DesIVA4; VATSlotDescription[4])
            {

            }
            column(VatBase1; VATSlotBase[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatBase2; VATSlotBase[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatBase3; VATSlotBase[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatBase4; VATSlotBase[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount1; VATSlotAmount[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount2; VATSlotAmount[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount3; VATSlotAmount[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(VatAmount4; VATSlotAmount[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }

            // Payment schedule: 4 fixed slots (see FillPaymentSchedule)
            column(DueDate1; DueDateSlot[1])
            {

            }
            column(DueDate2; DueDateSlot[2])
            {

            }
            column(DueDate3; DueDateSlot[3])
            {

            }
            column(DueDate4; DueDateSlot[4])
            {

            }
            column(DueAmount1; DueAmountSlot[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount2; DueAmountSlot[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount3; DueAmountSlot[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount4; DueAmountSlot[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }

            // Document totals (calculated in CalcDocumentTotals, available on every row)
            column(TotalNetAmount; TotalAmount) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalVATBaseLCY; TotalVATBaseLCY) { AutoFormatType = 1; }
            column(TotalAmountIncludingVAT; TotalAmountInclVAT) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalVATAmount; TotalAmountVAT) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalVATAmountLCY; TotalVATAmountLCY) { AutoFormatType = 1; }
            column(TotalInvoiceDiscountAmount; TotalInvDiscAmount) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            // The layout adds this value to the Subtotal and to the Taxable Amount (see CalcDocumentTotals).
            column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalVATAmountText; TotalVATAmountText)
            {

            }
            column(TotalExcludingVATText; TotalExclVATText)
            {

            }
            column(TotalIncludingVATText; TotalInclVATText)
            {

            }
            column(TotalSubTotal; TotalSubTotal) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalSubTotalMinusInvoiceDiscount; TotalSubTotal + TotalInvDiscAmount) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalText; TotalText)
            {

            }
            column(TotalAmountExclInclVAT; TotalAmountExclInclVATValue) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(TotalAmountExclInclVATText; TotalAmountExclInclVATTextValue)
            {

            }

            dataitem(WorkDescriptionLines; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 .. 99999));

                column(WorkDescriptionLine; WorkDescriptionLine)
                {

                }

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
            dataitem(Line; "Sales Cr.Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");

                // The layout groups the lines table on LineNo_Line, so this column must only be filled on line rows.
                column(LineNo_Line; "Line No.")
                {

                }
                column(Type_Line; Format(Type))
                {

                }
                column(ItemNo_Line; "No.")
                {

                }
                column(Description_Line; Description)
                {

                }
                column(Quantity_Line; FormattedQuantity)
                {

                }
                column(UnitOfMeasure; "Unit of Measure")
                {

                }
                column(UnitPrice; FormattedUnitPrice)
                {

                }
                column(LineDiscountPercent_Line; "Line Discount %") { DecimalPlaces = 0 : 5; }
                column(LineDiscountPercentText_Line; LineDiscountPctText)
                {

                }
                column(LineAmount_Line; FormattedLineAmount)
                {

                }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = Line.GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = Line.GetCurrencyCode();
                    AutoFormatType = 1;
                }
                column(VATIdentifier_Line; "VAT Identifier")
                {

                }
                column(VATPct_Line; FormattedVATPct)
                {

                }
                column(CrossReferenceNo_Line; "Item Reference No.")
                {

                }
                column(CrossReferenceNo_Line_Lbl; FieldCaption("Item Reference No."))
                {

                }
                column(ShipmentDate_Line; Format("Shipment Date"))
                {

                }
                column(ShipmentDate_Line_Lbl; PostedShipmentDateLbl)
                {

                }
                column(TransHeaderAmount; TransHeaderAmount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }

                // Project (job) information
                column(JobNo_Lbl; JobNoLbl)
                {

                }
                column(JobNo; JobNo)
                {

                }
                column(JobTaskNo_Lbl; JobTaskNoLbl)
                {

                }
                column(JobTaskNo; JobTaskNo)
                {

                }
                column(JobTaskDescription; JobTaskDescription)
                {

                }
                column(JobTaskDesc_Lbl; JobTaskDescLbl)
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
                column(CountryOrigin; CountryOrigin)
                {

                }

                // VAT exemption (declaration of intent) printed under the line (see GetLineVATExemption).
                // The layout shows the row only when VATExemptNo_CHMDocVATExemptionLink is filled.
                column(DocumentNo_CHMDocVATExemptionLink; VATExemptDocumentNo)
                {

                }
                column(LineNo_CHMDocVATExemptionLink; VATExemptLineNo)
                {

                }
                column(NoVATExemption_CHMDocVATExemptionLink; NoVATExemption)
                {

                }
                column(Source_CHMDocVATExemptionLink; VATExemptSource)
                {

                }
                column(VATExemptStartingDate_CHMDocVATExemptionLink; VATExemptStartingDate)
                {

                }
                column(VATExemptEndingDate_CHMDocVATExemptionLink; VATExemptEndingDate)
                {

                }
                column(VATExemptNo_CHMDocVATExemptionLink; VATExemptNo)
                {

                }
                column(VATExemptionType_CHMDocVATExemptionLink; VATExemptionType)
                {

                }

                // Lots credited on the line (posted item tracking of the return receipt). Filled in FillLotBuffer.
                // Quantities are in the unit of measure of the credit memo line.
                dataitem(ItemTrackingLine; "Tracking Specification")
                {
                    DataItemTableView = sorting("Entry No.");
                    UseTemporary = true;

                    column(ItemTrackingLineLotNo; "Lot No.")
                    {

                    }
                    column(ItemTrackingLineQty; "Qty. to Handle") { DecimalPlaces = 0 : 5; }

                    trigger OnPreDataItem()
                    begin
                        ItemTrackingLine.SetRange("Source Ref. No.", Line."Line No.");
                    end;
                }
                // "Show Shipments": for a credit memo these are the return receipts of the line.
                dataitem(ShipmentLine; "Sales Shipment Buffer")
                {
                    DataItemTableView = sorting("Document No.", "Line No.", "Entry No.");
                    UseTemporary = true;

                    column(DocumentNo_ShipmentLine; "Document No.")
                    {

                    }
                    column(PostingDate_ShipmentLine; Format("Posting Date"))
                    {

                    }
                    column(PostingDate_ShipmentLine_Lbl; FieldCaption("Posting Date"))
                    {

                    }
                    column(Quantity_ShipmentLine; Quantity) { DecimalPlaces = 0 : 5; }
                    column(Quantity_ShipmentLine_Lbl; FieldCaption(Quantity))
                    {

                    }

                    trigger OnPreDataItem()
                    begin
                        if not DisplayShipmentInformation then
                            CurrReport.Break();
                        ShipmentLine.SetRange("Line No.", Line."Line No.");
                    end;
                }
                dataitem(AssemblyLine; "Posted Assembly Line")
                {
                    DataItemTableView = sorting("Document No.", "Line No.");
                    UseTemporary = true;

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
                    begin
                        Clear(AssemblyLine);
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        AssemblyLine.GetAssemblyLinesForDocument(
                          AssemblyLine, Enum::"Item Ledger Document Type"::"Sales Credit Memo", Line."Document No.", Line."Line No.");
                    end;
                }

                trigger OnPreDataItem()
                begin
                    ShipmentLine.Reset();
                    ShipmentLine.DeleteAll();
                    MoreLines := Line.Find('+');
                    while MoreLines and (Line.Description = '') and (Line."No." = '') and (Line.Quantity = 0) and (Line.Amount = 0) do
                        MoreLines := Line.Next(-1) <> 0;
                    if not MoreLines then
                        CurrReport.Break();
                    Line.SetFilter("Line No.", '<=%1', Line."Line No.");
                    TransHeaderAmount := 0;
                    PrevLineAmount := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    InitializeShipmentLine();
                    if Line.Type = Line.Type::"G/L Account" then
                        Line."No." := '';

                    if Line."Line Discount %" = 0 then
                        LineDiscountPctText := ''
                    else
                        LineDiscountPctText := StrSubstNo(LineDiscountPctTok, -Round(Line."Line Discount %", 0.1));

                    TransHeaderAmount += PrevLineAmount;
                    PrevLineAmount := Line."Line Amount";

                    FormatDocument.SetSalesCrMemoLine(Line, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount);

                    SetLineJobInfo(Line);
                    GetLineItemInfo(Line);
                    GetLineVATExemption(Line);
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
                column(InvoiceDiscountAmount_VATAmountLine_Lbl; FieldCaption("Invoice Discount Amount"))
                {

                }
                column(InvoiceDiscountBaseAmount_VATAmountLine; "Inv. Disc. Base Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(InvoiceDiscountBaseAmount_VATAmountLine_Lbl; FieldCaption("Inv. Disc. Base Amount"))
                {

                }
                column(LineAmount_VatAmountLine; "Line Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_VatAmountLine_Lbl; FieldCaption("Line Amount"))
                {

                }
                column(VATAmount_VatAmountLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATAmount_VatAmountLine_Lbl; FieldCaption("VAT Amount"))
                {

                }
                column(VATAmountLCY_VATAmountLine; VATAmountLCY) { AutoFormatType = 1; }
                column(VATAmountLCY_VATAmountLine_Lbl; VATAmountLCYLbl)
                {

                }
                column(VATBase_VatAmountLine; "VAT Base")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(VATBase_VatAmountLine_Lbl; FieldCaption("VAT Base"))
                {

                }
                column(VATBaseLCY_VATAmountLine; VATBaseLCY) { AutoFormatType = 1; }
                column(VATBaseLCY_VATAmountLine_Lbl; VATBaseLCYLbl)
                {

                }
                column(VATIdentifier_VatAmountLine; "VAT Identifier")
                {

                }
                column(VATIdentifier_VatAmountLine_Lbl; FieldCaption("VAT Identifier"))
                {

                }
                column(VATPct_VatAmountLine; "VAT %") { DecimalPlaces = 0 : 5; }
                column(VATPct_VatAmountLine_Lbl; FieldCaption("VAT %"))
                {

                }
                column(NoOfVATIdentifiers; Count)
                {

                }

                trigger OnPreDataItem()
                begin
                    Clear(VATBaseLCY);
                    Clear(VATAmountLCY);
                    VATClauseLine.Reset();
                    VATClauseLine.DeleteAll();
                end;

                trigger OnAfterGetRecord()
                begin
                    VATBaseLCY := VATAmountLine.GetBaseLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");
                    VATAmountLCY := VATAmountLine.GetAmountLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");

                    if (VATAmountLine."VAT Clause Code" <> '') and ShouldInsertVATClauseLine() then begin
                        VATClauseLine := VATAmountLine;
                        if VATClauseLine.Insert() then;
                    end;
                end;
            }
            dataitem(VATClauseLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;

                column(VATClausesHeader; VATClausesText)
                {

                }
                column(VATIdentifier_VATClauseLine; "VAT Identifier")
                {

                }
                column(Code_VATClauseLine; VATClause.Code)
                {

                }
                column(Code_VATClauseLine_Lbl; VATClause.FieldCaption(Code))
                {

                }
                column(Description_VATClauseLine; VATClauseText)
                {

                }
                column(Description2_VATClauseLine; VATClause."Description 2")
                {

                }
                column(VATAmount_VATClauseLine; "VAT Amount")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(NoOfVATClauses; Count)
                {

                }

                trigger OnPreDataItem()
                begin
                    if VATClauseLine.Count() = 0 then
                        VATClausesText := ''
                    else
                        VATClausesText := VATClausesLbl;
                end;

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

                column(Description_ReportTotalsLine; Description)
                {

                }
                column(Amount_ReportTotalsLine; Amount)
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountFormatted_ReportTotalsLine; "Amount Formatted")
                {

                }
                column(FontBold_ReportTotalsLine; "Font Bold")
                {

                }
                column(FontUnderline_ReportTotalsLine; "Font Underline")
                {

                }

                trigger OnPreDataItem()
                begin
                    CreateReportTotalLines();
                end;
            }
            dataitem(LineFee; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending) where(Number = filter(1 ..));

                column(LineFeeCaptionText; TempLineFeeNoteOnReportHist.ReportText)
                {

                }

                trigger OnAfterGetRecord()
                begin
                    if not DisplayAdditionalFeeNote then
                        CurrReport.Break();

                    if LineFee.Number = 1 then begin
                        if not TempLineFeeNoteOnReportHist.FindSet() then
                            CurrReport.Break();
                    end else
                        if TempLineFeeNoteOnReportHist.Next() = 0 then
                            CurrReport.Break();
                end;
            }
            // Payment services (online payment links) only apply to invoices. The data item is never
            // filled for a credit memo; it is kept because the layout's dataset declares these fields.
            dataitem(PaymentReportingArgument; "Payment Reporting Argument")
            {
                DataItemTableView = sorting("Key");
                UseTemporary = true;

                column(PaymentServiceLogo; Logo)
                {

                }
                column(PaymentServiceLogo_UrlText; "URL Caption")
                {

                }
                column(PaymentServiceLogo_Url; GetTargetURL())
                {

                }
                column(PaymentServiceText_UrlText; "URL Caption")
                {

                }
                column(PaymentServiceText_Url; GetTargetURL())
                {

                }
            }
            dataitem(LeftHeader; "Name/Value Buffer")
            {
                DataItemTableView = sorting(ID);
                UseTemporary = true;

                column(LeftHeaderName; Name)
                {

                }
                column(LeftHeaderValue; Value)
                {

                }
            }
            dataitem(RightHeader; "Name/Value Buffer")
            {
                DataItemTableView = sorting(ID);
                UseTemporary = true;

                column(RightHeaderName; Name)
                {

                }
                column(RightHeaderValue; Value)
                {

                }
            }

            trigger OnAfterGetRecord()
            begin
                // The credit memo is printed in the language of the user running the report, not in the
                // customer's language (Header."Language Code"), the same as the CHM Posted Sales Invoice.
                ReportLanguageCode := LanguageMgt.GetUserLanguageCode();
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(ReportLanguageCode);
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                FormatAddr.SetLanguageCode(ReportLanguageCode);

                if not IsReportInPreviewMode() then
                    Codeunit.Run(Codeunit::"Sales Cr. Memo-Printed", Header);

                Header.CalcFields("Work Description");
                ShowWorkDescription := Header."Work Description".HasValue();

                ChecksPayableText := StrSubstNo(ChecksPayableLbl, CompanyInfo.Name);

                FormatAddr.SalesCrMemoBillTo(CustAddr, Header);
                ShowShippingAddr := FormatAddr.SalesCrMemoShipTo(ShipToAddr, CustAddr, Header);
                FormatDocumentFields(Header);

                Clear(SellToContact);
                Clear(BillToContact);
                if SellToContact.Get(Header."Sell-to Contact No.") then;
                if BillToContact.Get(Header."Bill-to Contact No.") then;
                SellToContactEmail := SellToContact."E-Mail";
                if SellToContactEmail = '' then
                    SellToContactEmail := Header."Sell-to E-Mail";

                if not CompanyBankAccount.Get(Header."Company Bank Account Code") then
                    CompanyBankAccount.CopyBankFieldsFromCompanyInfo(CompanyInfo);
                SetOurBankAccountText();

                if not Cust.Get(Header."Bill-to Customer No.") then
                    Clear(Cust);

                SetCurrencyInfo();

                FillLeftHeader();
                FillRightHeader();
                GetLineFeeNoteOnReportHist(Header."No.");
                SetRemainingAmount();

                SetChematekHeaderFields();
                CalcShipmentTotals();
                FillLotBuffer();
                CalcDocumentTotals();
                FillVATSummary();
                FillPaymentSchedule();
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
                    field(DisplayShipmentInformationReq; DisplayShipmentInformation)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Shipments';
                        ToolTip = 'Specifies that shipments are shown on the document.';
                    }
                    field(DisplayAdditionalFeeNoteReq; DisplayAdditionalFeeNote)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Additional Fee Note';
                        ToolTip = 'Specifies if you want notes about additional fees to be shown on the document.';
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
        layout(PostedCreditMemoRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMPostedCreditMemo.rdl';
            Caption = 'Chematek Posted Credit Memo';
            Summary = 'Chematek posted sales credit memo with VAT summary, due dates, lot numbers and dangerous goods information per line.';
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
        GrossWeight_Caption = 'Gross Weight';
        Line_Amount_Caption = 'Amount';
        Line_Description_Caption = 'Description';
        Line_ItemNo_Caption = 'Item No.';
        Line_LineDiscountPerc_Caption = 'Disc. %';
        Line_Quantity_Caption = 'Quantity';
        Line_UnitPrice_Caption = 'Unit Price';
        Line_UoM_Caption = 'UoM';
        Line_VATIdentifier_Caption = 'VAT';
        NetWeightCaption = 'Net Weight';
        NoOfPallets_Caption = 'No. of Pallets';
        NoOfParcels_Caption = 'No. of Parcels';
        Our_Bank = 'Our Bank';
        Page_Caption = 'Page';
        PaymentMethod_Caption = 'Payment Method';
        PaymentTerms_Caption = 'Payment Terms';
        PostingDate_Caption = 'Posting Date';
        Reason_Caption = 'Reason';
        Salesperson_Caption = 'Salesperson';
        ShipToAddress_Caption = 'Ship-to Address';
        ShptMethod_Caption = 'Shipment Method';
        SWIFTCode_caption = 'SWIFT Code';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        CompanyInfo.VerifyAndSetPaymentInfo();
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
                          Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo".AsInteger(), Header."No.", 0, 0, Database::Contact,
                          Header."Bill-to Contact No.", Header."Salesperson Code", Header."Campaign No.", Header."Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo".AsInteger(), Header."No.", 0, 0, Database::Customer,
                          Header."Bill-to Customer No.", Header."Salesperson Code", Header."Campaign No.", Header."Posting Description", '');
                until Header.Next() = 0;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        CHMSetup: Record "CHM Customizations Setup";
        CompanyBankAccount: Record "Bank Account";
        Cust: Record Customer;
        SellToContact: Record Contact;
        BillToContact: Record Contact;
        VATClause: Record "VAT Clause";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
        LanguageMgt: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        WorkDescriptionInstream: InStream;
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        WorkDescriptionLine: Text;
        ShowWorkDescription: Boolean;
        ShowShippingAddr: Boolean;
        MoreLines: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        DisplayShipmentInformation: Boolean;
        DisplayAdditionalFeeNote: Boolean;
        CalculatedExchRate: Decimal;
        ExchangeRateText: Text;
        ChecksPayableText: Text;
        PaymentInstructionsTxt: Text;
        RemainingAmountTxt: Text;
        ReportLanguageCode: Code[10];
        CurrCode: Text[10];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalVATAmountText: Text[30];
        TotalAmountExclInclVATTextValue: Text;
        SalesPersonText: Text[50];
        SellToContactEmail: Text[80];
        OurBankAccountText: Text;
        VATClauseText: Text;
        VATClausesText: Text;
        LineDiscountPctText: Text;
        FormattedVATPct: Text;
        FormattedUnitPrice: Text;
        FormattedQuantity: Text;
        FormattedLineAmount: Text;

        // Totals
        RemainingAmount: Decimal;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalPaymentDiscOnVAT: Decimal;
        TotalVATBaseLCY: Decimal;
        TotalVATAmountLCY: Decimal;
        TotalAmountExclInclVATValue: Decimal;
        TransHeaderAmount: Decimal;
        PrevLineAmount: Decimal;
        VATBaseLCY: Decimal;
        VATAmountLCY: Decimal;

        // Chematek header fields
        OperatorName: Text;
        LocationAddress: Text;
        ReasonCodeText: Text;
        FiscalCodeNo: Text;
        ShowIso: Boolean;

        // Shipment data (not available on a credit memo, see CalcShipmentTotals)
        TotalParcels: Integer;
        TotalPallets: Integer;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;

        // Line project fields
        JobNo: Code[20];
        JobTaskNo: Code[20];
        JobNoLbl: Text;
        JobTaskNoLbl: Text;
        JobTaskDescription: Text[100];

        // Line item / dangerous goods fields
        TariffNo: Text;
        ADRClass: Text;
        ItemUN: Text;
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
        DueDateSlot: array[4] of Text;
        DueAmountSlot: array[4] of Decimal;

        // Captions
        SalesCrMemoLbl: Label 'Credit Memo';
        YourSalesCrMemoLbl: Label 'Your Credit Memo';
        CrMemoNoLbl: Label 'Credit Memo No.';
        BillToAddressCaptionLbl: Label 'Bill-to Address';
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
        DeliveryTermsCaptionLbl: Label 'Delivery Terms';
        OurBankCaptionLbl: Label 'Our Bank';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        ShipmentFromCaptionLbl: Label 'Shipment from';
        NetAmountToPayCaptionLbl: Label 'Net Amount to Pay';
        TotalVATCaptionLbl: Label 'Total VAT';
        TaxableAmountCaptionLbl: Label 'Taxable Amount';
        DocumentTotalCaptionLbl: Label 'Document Total';
        VATCodeCaptionLbl: Label 'VAT Code';
        VATDescriptionCaptionLbl: Label 'VAT Description';
        PaymentAmountCaptionLbl: Label 'Amount Due';
        DueDateCaptionLbl: Label 'Due Date';
        NoOfParcelsCaptionLbl: Label 'No. of Parcels';
        NoOfPalletsCaptionLbl: Label 'No. of Pallets';
        NetWeightCaptionLbl: Label 'Net Weight';
        GrossWeightCaptionLbl: Label 'Gross Weight';
        LineNoCaptionLbl: Label 'Item No.';
        LineDescriptionCaptionLbl: Label 'Description';
        LineQuantityCaptionLbl: Label 'Quantity';
        LineUoMCaptionLbl: Label 'UoM';
        LinePriceCaptionLbl: Label 'Unit Price';
        LineDiscPctCaptionLbl: Label 'Disc. %';
        LineAmountCaptionLbl: Label 'Amount';
        LineVATCaptionLbl: Label 'VAT';
        AmountExclVATCaptionLbl: Label 'Amount Excl. VAT';
        AmountInclVATCaptionLbl: Label 'Amount Incl. VAT';
        LotNoCaptionLbl: Label 'Lot No.';
        CountryOfOriginCaptionLbl: Label 'Country of Origin:';
        TariffNoCaptionLbl: Label 'Tariff No.:';
        UNNoCaptionLbl: Label 'UN No.:';
        ADRClassCaptionLbl: Label 'ADR Class:';
        PostedShipmentDateLbl: Label 'Shipment Date';
        JobNoCaptionLbl: Label 'Project No.';
        JobTaskNoCaptionLbl: Label 'Project Task No.';
        JobTaskDescLbl: Label 'Project Task Description';

        // Standard report 1307 texts
        CompanyInfoPhoneNoLbl: Label 'Phone No.';
        CompanyInfoBankNameLbl: Label 'Bank';
        CompanyInfoBankAccNoLbl: Label 'Account No.';
        CopyLbl: Label 'Copy';
        EMailLbl: Label 'Email';
        HomePageLbl: Label 'Home Page';
        InvDiscBaseAmtLbl: Label 'Invoice Discount Base Amount';
        InvDiscountAmtLbl: Label 'Invoice Discount';
        LineAmtAfterInvDiscLbl: Label 'Payment Discount on VAT';
        LocalCurrencyLbl: Label 'Local Currency';
        PageLbl: Label 'Page';
        ShipmentLbl: Label 'Shipment';
        SubtotalLbl: Label 'Subtotal';
        TotalLbl: Label 'Total';
        VATAmtSpecificationLbl: Label 'VAT Amount Specification';
        VATAmtLbl: Label 'VAT Amount';
        VATAmountLCYLbl: Label 'VAT Amount (LCY)';
        VATBaseLbl: Label 'VAT Base';
        VATBaseLCYLbl: Label 'VAT Base (LCY)';
        VATClausesLbl: Label 'VAT Clause';
        VATPercentageLbl: Label 'VAT %';
        SellToContactPhoneNoLbl: Label 'Sell-to Contact Phone No.';
        SellToContactMobilePhoneNoLbl: Label 'Sell-to Contact Mobile Phone No.';
        SellToContactEmailLbl: Label 'Sell-to Contact E-Mail';
        BillToContactPhoneNoLbl: Label 'Bill-to Contact Phone No.';
        BillToContactMobilePhoneNoLbl: Label 'Bill-to Contact Mobile Phone No.';
        BillToContactEmailLbl: Label 'Bill-to Contact E-Mail';
        UnitLbl: Label 'Unit';
        QtyLbl: Label 'Qty', Comment = 'Short form of Quantity';
        PricePerLbl: Label 'Price per';
        FromLbl: Label 'From';
        BilledToLbl: Label 'Billed to';
        ChecksPayableLbl: Label 'Please make checks payable to %1', Comment = '%1 = company name';
        QuestionsLbl: Label 'Questions?';
        ThanksLbl: Label 'Thank You!';
        FullyAppliedLbl: Label 'The credit memo has been fully applied.';
        PartiallyAppliedLbl: Label 'The credit memo has been partially applied. The remaining amount is %1', Comment = '%1 = an amount';
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';
        LCYTxt: Label ' (LCY)';
        BankAccountIBANTok: Label '%1 - %2', Locked = true;
        LineDiscountPctTok: Label '%1%', Locked = true;
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidentally printing all documents.';

    /// <summary>
    /// Initializes the request options when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    /// <summary>
    /// Initializes all request options when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean; DisplayShipmentInfo: Boolean; DisplayAddFeeNote: Boolean)
    begin
        InitializeRequest(NewLogInteraction, DisplayAsmInfo);
        DisplayShipmentInformation := DisplayShipmentInfo;
        DisplayAdditionalFeeNote := DisplayAddFeeNote;
    end;

    local procedure LogInteractionTemplateExists(): Boolean
    begin
        exit(SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo") <> '');
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure SetCurrencyInfo()
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        ExchangeRateText := '';
        if Header."Currency Code" <> '' then begin
            CurrencyExchangeRate.FindCurrency(Header."Posting Date", Header."Currency Code", 1);
            CalculatedExchRate :=
              Round(1 / Header."Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
            ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
            CurrCode := Header."Currency Code";
        end else
            CurrCode := GLSetup."LCY Code";
    end;

    local procedure FormatDocumentFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatDocument.SetTotalLabels(SalesCrMemoHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesCrMemoHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesCrMemoHeader."Payment Terms Code", ReportLanguageCode);
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesCrMemoHeader."Payment Method Code", ReportLanguageCode);
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesCrMemoHeader."Shipment Method Code", ReportLanguageCode);
    end;

    local procedure SetOurBankAccountText()
    begin
        // Printed under "Our Bank": bank name followed by the IBAN.
        OurBankAccountText := CompanyBankAccount.Name;
        if CompanyBankAccount.IBAN <> '' then
            if OurBankAccountText = '' then
                OurBankAccountText := CompanyBankAccount.IBAN
            else
                OurBankAccountText := StrSubstNo(BankAccountIBANTok, OurBankAccountText, CompanyBankAccount.IBAN);
    end;

    local procedure SetRemainingAmount()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        // Standard BC has no GetRemainingAmount() on the credit memo header, so it is read from the
        // customer ledger entry of the credit memo. Printed as a positive amount.
        RemainingAmount := 0;
        RemainingAmountTxt := '';

        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", Header."No.");
        CustLedgerEntry.SetRange("Customer No.", Header."Bill-to Customer No.");
        CustLedgerEntry.SetAutoCalcFields(Amount, "Remaining Amount");
        if not CustLedgerEntry.FindFirst() then
            exit;

        RemainingAmount := Abs(CustLedgerEntry."Remaining Amount");
        if RemainingAmount = 0 then
            RemainingAmountTxt := FullyAppliedLbl
        else
            if RemainingAmount <> Abs(CustLedgerEntry.Amount) then
                RemainingAmountTxt := StrSubstNo(PartiallyAppliedLbl, Format(RemainingAmount, 0, '<Precision,2><Standard Format,0>'));
    end;

    local procedure SetChematekHeaderFields()
    var
        Location: Record Location;
        ReasonCode: Record "Reason Code";
    begin
        // Operator: the user who posted the credit memo.
        OperatorName := GetUserFullName(Header."User ID");

        // Shipment from: the location on the credit memo.
        LocationAddress := '';
        if Header."Location Code" <> '' then
            if Location.Get(Header."Location Code") then
                LocationAddress := FormatLocationAddress(Location);

        // Reason code (DEV-005, entered on the Sales Return Order): print the description, fall back to the code.
        ReasonCodeText := Header."Reason Code";
        if Header."Reason Code" <> '' then
            if ReasonCode.Get(Header."Reason Code") then
                if ReasonCode.Description <> '' then
                    ReasonCodeText := ReasonCode.Description;

        FiscalCodeNo := GetCustomerFiscalCode(Header."Bill-to Customer No.");
    end;

    local procedure FormatLocationAddress(Location: Record Location) Result: Text
    var
        CityText: Text;
    begin
        Result := Location.Address;
        if Location."Address 2" <> '' then
            Result := DelChr(Result + ' ' + Location."Address 2", '<>', ' ');
        CityText := DelChr(Location."Post Code" + ' ' + Location.City, '<>', ' ');
        if Location.County <> '' then
            CityText += ' (' + Location.County + ')';
        if CityText <> '' then
            if Result = '' then
                Result := CityText
            else
                Result += ' - ' + CityText;
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

    local procedure CalcShipmentTotals()
    begin
        // TODO (pending decision): parcels, pallets and weights are entered on the posted sales shipment
        // (DEV-002). A credit memo is linked to return receipts, which have no Chematek shipment fields,
        // so nothing is printed (the layout hides these values when they are 0).
        TotalParcels := 0;
        TotalPallets := 0;
        TotalNetWeight := 0;
        TotalGrossWeight := 0;
    end;

    local procedure CalcDocumentTotals()
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        TotalSubTotal := 0;
        TotalInvDiscAmount := 0;
        TotalAmount := 0;
        TotalAmountVAT := 0;
        TotalAmountInclVAT := 0;
        TotalPaymentDiscOnVAT := 0;
        TotalVATBaseLCY := 0;
        TotalVATAmountLCY := 0;

        VATAmountLine.Reset();
        VATAmountLine.DeleteAll();

        SalesCrMemoLine.SetRange("Document No.", Header."No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                InsertVATAmountLine(SalesCrMemoLine);
                TotalSubTotal += SalesCrMemoLine."Line Amount";
                TotalInvDiscAmount -= SalesCrMemoLine."Inv. Discount Amount";
                TotalAmount += SalesCrMemoLine.Amount;
                TotalAmountVAT += SalesCrMemoLine."Amount Including VAT" - SalesCrMemoLine.Amount;
                TotalAmountInclVAT += SalesCrMemoLine."Amount Including VAT";
            until SalesCrMemoLine.Next() = 0;

        // The layout prints "Subtotal" as TotalSubTotal + TotalPaymentDiscountOnVAT and "Taxable Amount" as
        // TotalSubTotalMinusInvoiceDiscount + TotalPaymentDiscountOnVAT. This value is the difference between
        // the amount excluding VAT and the line amounts after invoice discount: 0 when prices exclude VAT,
        // and minus the VAT when prices include VAT, so both totals are always printed excluding VAT.
        TotalPaymentDiscOnVAT := TotalAmount - (TotalSubTotal + TotalInvDiscAmount);

        VATAmountLine.Reset();
        if VATAmountLine.FindSet() then
            repeat
                TotalVATBaseLCY += VATAmountLine.GetBaseLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");
                TotalVATAmountLCY += VATAmountLine.GetAmountLCY(Header."Posting Date", Header."Currency Code", Header."Currency Factor");
            until VATAmountLine.Next() = 0;
        TotalVATAmountText := VATAmountLine.VATAmountText();

        if Header."Prices Including VAT" then begin
            TotalAmountExclInclVATTextValue := TotalExclVATText;
            TotalAmountExclInclVATValue := TotalAmount;
        end else begin
            TotalAmountExclInclVATTextValue := TotalInclVATText;
            TotalAmountExclInclVATValue := TotalAmountInclVAT;
        end;
    end;

    local procedure InsertVATAmountLine(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        VATAmountLine.Init();
        VATAmountLine."VAT Identifier" := SalesCrMemoLine."VAT Identifier";
        VATAmountLine."VAT Calculation Type" := SalesCrMemoLine."VAT Calculation Type";
        VATAmountLine."Tax Group Code" := SalesCrMemoLine."Tax Group Code";
        VATAmountLine."VAT %" := SalesCrMemoLine."VAT %";
        VATAmountLine."VAT Base" := SalesCrMemoLine.Amount;
        VATAmountLine."Amount Including VAT" := SalesCrMemoLine."Amount Including VAT";
        VATAmountLine."Line Amount" := SalesCrMemoLine."Line Amount";
        if SalesCrMemoLine."Allow Invoice Disc." then
            VATAmountLine."Inv. Disc. Base Amount" := SalesCrMemoLine."Line Amount";
        VATAmountLine."Invoice Discount Amount" := SalesCrMemoLine."Inv. Discount Amount";
        VATAmountLine."VAT Clause Code" := SalesCrMemoLine."VAT Clause Code";
        VATAmountLine.InsertLine();
    end;

    local procedure ShouldInsertVATClauseLine(): Boolean
    var
        TempVATClauseLine: Record "VAT Amount Line" temporary;
    begin
        if VATAmountLine."VAT Amount" <> 0 then
            exit(true);
        TempVATClauseLine.Copy(VATClauseLine, true);
        TempVATClauseLine.SetRange("VAT Identifier", VATAmountLine."VAT Identifier");
        TempVATClauseLine.SetRange("VAT Clause Code", VATAmountLine."VAT Clause Code");
        TempVATClauseLine.SetRange("VAT Amount", VATAmountLine."VAT Amount");
        exit(TempVATClauseLine.IsEmpty());
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

    local procedure FillPaymentSchedule()
    begin
        // Same as the CHM Posted Sales Invoice: one due date per document, so only the first slot is used.
        // The other 3 slots are kept because the layout expects them.
        Clear(DueDateSlot);
        Clear(DueAmountSlot);
        if TotalAmountInclVAT = 0 then
            exit;
        DueDateSlot[1] := Format(Header."Due Date");
        DueAmountSlot[1] := TotalAmountInclVAT;
    end;

    local procedure CreateReportTotalLines()
    begin
        ReportTotalsLine.DeleteAll();
        if (TotalInvDiscAmount <> 0) or (TotalAmountVAT <> 0) then
            ReportTotalsLine.Add(SubtotalLbl, TotalSubTotal, true, false, false, Header."Currency Code");
        if TotalInvDiscAmount <> 0 then begin
            ReportTotalsLine.Add(InvDiscountAmtLbl, TotalInvDiscAmount, false, false, false, Header."Currency Code");
            if TotalAmountVAT <> 0 then
                if Header."Prices Including VAT" then
                    ReportTotalsLine.Add(TotalInclVATText, TotalAmountInclVAT, true, false, false, Header."Currency Code")
                else
                    ReportTotalsLine.Add(TotalExclVATText, TotalAmount, true, false, false, Header."Currency Code");
        end;
        if TotalAmountVAT <> 0 then begin
            ReportTotalsLine.Add(VATAmountLine.VATAmountText(), TotalAmountVAT, false, true, false, Header."Currency Code");
            if TotalVATAmountLCY <> TotalAmountVAT then
                ReportTotalsLine.Add(VATAmountLine.VATAmountText() + LCYTxt, TotalVATAmountLCY, false, true, false);
        end;
    end;

    local procedure InitializeShipmentLine()
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
        // "Show Shipments" on a credit memo lists the return receipts of the line (standard report 1307).
        if not DisplayShipmentInformation then
            exit;
        if Line."Return Receipt No." <> '' then
            if ReturnReceiptHeader.Get(Line."Return Receipt No.") then
                exit;
        if Header."Return Order No." = '' then
            exit;
        if Line.Type = Line.Type::" " then
            exit;
        ShipmentLine.GetLinesForSalesCreditMemoLine(Line, Header);
        ShipmentLine.Reset();
        ShipmentLine.SetRange("Line No.", Line."Line No.");
        if not ShipmentLine.IsEmpty() then begin
            ShipmentLine.CalcSums(Quantity);
            if ShipmentLine.Quantity <> Line.Quantity then begin
                ShipmentLine.DeleteAll();
                exit;
            end;
        end;
    end;

    local procedure SetLineJobInfo(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        JobNo := SalesCrMemoLine."Job No.";
        JobTaskNo := SalesCrMemoLine."Job Task No.";

        if JobTaskNo <> '' then begin
            JobTaskNoLbl := JobTaskNoCaptionLbl;
            JobTaskDescription := GetJobTaskDescription(JobNo, JobTaskNo);
        end else begin
            JobTaskDescription := '';
            JobTaskNoLbl := '';
        end;

        if JobNo <> '' then
            JobNoLbl := JobNoCaptionLbl
        else
            JobNoLbl := '';
    end;

    local procedure GetJobTaskDescription(JobNoValue: Code[20]; JobTaskNoValue: Code[20]): Text[100]
    var
        JobTask: Record "Job Task";
    begin
        JobTask.SetRange("Job No.", JobNoValue);
        JobTask.SetRange("Job Task No.", JobTaskNoValue);
        if JobTask.FindFirst() then
            exit(JobTask.Description);
        exit('');
    end;

    local procedure GetLineItemInfo(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        Item: Record Item;
        CountryRegion: Record "Country/Region";
    begin
        ADRClass := '';
        ItemUN := '';
        TariffNo := '';
        CountryOrigin := '';

        if SalesCrMemoLine.Type <> SalesCrMemoLine.Type::Item then
            exit;
        if not Item.Get(SalesCrMemoLine."No.") then
            exit;

        TariffNo := Item."Tariff No.";
        if Item."Country/Region of Origin Code" <> '' then begin
            CountryOrigin := Item."Country/Region of Origin Code";
            if CountryRegion.Get(Item."Country/Region of Origin Code") then
                if CountryRegion.Name <> '' then
                    CountryOrigin := CountryRegion.Name;
        end;

        GetItemDangerousGoodsInfo(Item, ADRClass, ItemUN);
    end;

    local procedure GetItemDangerousGoodsInfo(Item: Record Item; var ADRClassCode: Text; var UNNo: Text)
    begin
        // TODO (pending decision): standard BC has no dangerous goods fields on the item.
        // Fill these from the agreed source (same decision as the Sales Quote / Order Confirmation / Invoice reports).
        // Until then the ADR / UN rows under the line are not printed.
        ADRClassCode := '';
        UNNo := '';
    end;

    local procedure GetCustomerFiscalCode(CustomerNo: Code[20]): Text
    var
        CHMManagement: Codeunit "CHM Management";
    begin
        // Fiscal Code from the customer card (Italian localization field, see codeunit 66602 "CHM Management").
        exit(CHMManagement.GetCustomerFiscalCode(CustomerNo));
    end;

    local procedure GetLineVATExemption(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        CHMManagement: Codeunit "CHM Management";
        StartingDate: Date;
        EndingDate: Date;
    begin
        VATExemptDocumentNo := SalesCrMemoLine."Document No.";
        VATExemptLineNo := SalesCrMemoLine."Line No.";
        NoVATExemption := true;
        VATExemptSource := '';
        VATExemptStartingDate := '';
        VATExemptEndingDate := '';
        VATExemptNo := '';
        VATExemptionType := '';

        // Declaration of intent of the bill-to customer from the Italian "VAT Exemption" table (see codeunit
        // 66602 "CHM Management"), valid on the posting date of the credit memo. Printed under every line
        // without VAT; comment lines are skipped.
        // The layout shows the row only when VATExemptNo is filled.
        if (SalesCrMemoLine.Type = SalesCrMemoLine.Type::" ") or (SalesCrMemoLine."VAT %" <> 0) then
            exit;
        if not CHMManagement.FindCustomerVATExemption(Header."Bill-to Customer No.", Header."Posting Date", VATExemptNo, StartingDate, EndingDate, VATExemptSource) then
            exit;

        NoVATExemption := false;
        VATExemptStartingDate := Format(StartingDate);
        if EndingDate <> 0D then
            VATExemptEndingDate := Format(EndingDate);
    end;

    local procedure FillLotBuffer()
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
    begin
        // Lots credited on each item line, taken from the item ledger entries (return receipts) of the line.
        ItemTrackingLine.Reset();
        ItemTrackingLine.DeleteAll();
        LotBufferEntryNo := 0;

        SalesCrMemoLine.SetRange("Document No.", Header."No.");
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
        SalesCrMemoLine.SetFilter("No.", '<>%1', '');
        if not SalesCrMemoLine.FindSet() then
            exit;
        repeat
            SalesCrMemoLine.GetItemLedgEntries(TempItemLedgerEntry, true);
            TempItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
            if TempItemLedgerEntry.FindSet() then
                repeat
                    AddLotToBuffer(SalesCrMemoLine, TempItemLedgerEntry."Lot No.", Abs(TempItemLedgerEntry.Quantity));
                until TempItemLedgerEntry.Next() = 0;
        until SalesCrMemoLine.Next() = 0;
    end;

    local procedure AddLotToBuffer(SalesCrMemoLine: Record "Sales Cr.Memo Line"; LotNo: Code[50]; QtyBase: Decimal)
    begin
        if QtyBase = 0 then
            exit;

        // One row per credit memo line and lot.
        ItemTrackingLine.Reset();
        ItemTrackingLine.SetRange("Source Ref. No.", SalesCrMemoLine."Line No.");
        ItemTrackingLine.SetRange("Lot No.", LotNo);
        if ItemTrackingLine.FindFirst() then begin
            ItemTrackingLine."Quantity (Base)" += QtyBase;
            ItemTrackingLine."Qty. to Handle" := CalcLineQty(ItemTrackingLine."Quantity (Base)", SalesCrMemoLine."Qty. per Unit of Measure");
            ItemTrackingLine.Modify();
        end else begin
            LotBufferEntryNo += 1;
            ItemTrackingLine.Init();
            ItemTrackingLine."Entry No." := LotBufferEntryNo;
            ItemTrackingLine."Source Type" := Database::"Sales Cr.Memo Line";
            ItemTrackingLine."Source ID" := SalesCrMemoLine."Document No.";
            ItemTrackingLine."Source Ref. No." := SalesCrMemoLine."Line No.";
            ItemTrackingLine."Item No." := SalesCrMemoLine."No.";
            ItemTrackingLine."Variant Code" := SalesCrMemoLine."Variant Code";
            ItemTrackingLine.Description := SalesCrMemoLine.Description;
            ItemTrackingLine."Lot No." := LotNo;
            ItemTrackingLine."Qty. per Unit of Measure" := SalesCrMemoLine."Qty. per Unit of Measure";
            ItemTrackingLine."Quantity (Base)" := QtyBase;
            ItemTrackingLine."Qty. to Handle" := CalcLineQty(QtyBase, SalesCrMemoLine."Qty. per Unit of Measure");
            ItemTrackingLine.Insert();
        end;
        ItemTrackingLine.Reset();
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

    local procedure GetLineFeeNoteOnReportHist(SalesCrMemoHeaderNo: Code[20])
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", SalesCrMemoHeaderNo);
        if not CustLedgerEntry.FindFirst() then
            exit;
        if not Customer.Get(CustLedgerEntry."Customer No.") then
            exit;

        LineFeeNoteOnReportHist.SetRange("Cust. Ledger Entry No", CustLedgerEntry."Entry No.");
        LineFeeNoteOnReportHist.SetRange("Language Code", Customer."Language Code");
        if LineFeeNoteOnReportHist.FindSet() then
            repeat
                TempLineFeeNoteOnReportHist.Init();
                TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                TempLineFeeNoteOnReportHist.Insert();
            until LineFeeNoteOnReportHist.Next() = 0
        else begin
            LineFeeNoteOnReportHist.SetRange("Language Code", LanguageMgt.GetUserLanguageCode());
            if LineFeeNoteOnReportHist.FindSet() then
                repeat
                    TempLineFeeNoteOnReportHist.Init();
                    TempLineFeeNoteOnReportHist.Copy(LineFeeNoteOnReportHist);
                    TempLineFeeNoteOnReportHist.Insert();
                until LineFeeNoteOnReportHist.Next() = 0;
        end;
    end;

    local procedure FillLeftHeader()
    begin
        LeftHeader.DeleteAll();
        FillNameValueTable(LeftHeader, Header.FieldCaption("External Document No."), Header."External Document No.");
        FillNameValueTable(LeftHeader, Header.FieldCaption("Bill-to Customer No."), Header."Bill-to Customer No.");
        FillNameValueTable(LeftHeader, Header.GetCustomerVATRegistrationNumberLbl(), Header.GetCustomerVATRegistrationNumber());
        FillNameValueTable(LeftHeader, CrMemoNoLbl, Header."No.");
        FillNameValueTable(LeftHeader, Header.FieldCaption("Return Order No."), Header."Return Order No.");
        FillNameValueTable(LeftHeader, Header.FieldCaption("Document Date"), Format(Header."Document Date", 0, 4));
        FillNameValueTable(LeftHeader, Header.FieldCaption("Due Date"), Format(Header."Due Date", 0, 4));
        FillNameValueTable(LeftHeader, PaymentTermsCaptionLbl, PaymentTerms.Description);
        FillNameValueTable(LeftHeader, PaymentMethodCaptionLbl, PaymentMethod.Description);
        FillNameValueTable(LeftHeader, Cust.GetLegalEntityTypeLbl(), Cust.GetLegalEntityType());
        FillNameValueTable(LeftHeader, ShipmentMethodCaptionLbl, ShipmentMethod.Description);
    end;

    local procedure FillRightHeader()
    begin
        RightHeader.DeleteAll();
        FillNameValueTable(RightHeader, CompanyInfo.FieldCaption("E-Mail"), CompanyInfo."E-Mail");
        FillNameValueTable(RightHeader, CompanyInfo.FieldCaption("Home Page"), CompanyInfo."Home Page");
        FillNameValueTable(RightHeader, CompanyInfo.FieldCaption("Phone No."), CompanyInfo."Phone No.");
        FillNameValueTable(RightHeader, CompanyInfo.GetRegistrationNumberLbl(), CompanyInfo.GetRegistrationNumber());
        FillNameValueTable(RightHeader, CompanyInfo.GetVATRegistrationNumberLbl(), CompanyInfo.GetVATRegistrationNumber());
        FillNameValueTable(RightHeader, OurBankCaptionLbl, CompanyBankAccount.Name);
        FillNameValueTable(RightHeader, CompanyBankAccount.FieldCaption(IBAN), CompanyBankAccount.IBAN);
        FillNameValueTable(RightHeader, CompanyBankAccount.FieldCaption("SWIFT Code"), CompanyBankAccount."SWIFT Code");
    end;

    local procedure FillNameValueTable(var NameValueBuffer: Record "Name/Value Buffer"; Name: Text; Value: Text)
    var
        KeyIndex: Integer;
    begin
        if Value = '' then
            exit;
        Clear(NameValueBuffer);
        if NameValueBuffer.FindLast() then
            KeyIndex := NameValueBuffer.ID + 1;
        NameValueBuffer.Init();
        NameValueBuffer.ID := KeyIndex;
        NameValueBuffer.Name := CopyStr(Name, 1, MaxStrLen(NameValueBuffer.Name));
        NameValueBuffer.Value := CopyStr(Value, 1, MaxStrLen(NameValueBuffer.Value));
        NameValueBuffer.Insert();
    end;
}
