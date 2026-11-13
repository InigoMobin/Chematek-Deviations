/* report 66604 "CHM Posted Credit Memo"
{
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
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber())
            {
            }
            column(CompanyVATRegistrationNo_Lbl; CompanyInfo.GetVATRegistrationNumberLbl())
            {
            }
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
            column(VatPerc1; VATSlotPct[1])
            {
                DecimalPlaces = 0 : 5;
            }
            column(VatPerc2; VATSlotPct[2])
            {
                DecimalPlaces = 0 : 5;
            }
            column(VatPerc3; VATSlotPct[3])
            {
                DecimalPlaces = 0 : 5;
            }
            column(VatPerc4; VATSlotPct[4])
            {
                DecimalPlaces = 0 : 5;
            }
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
            column(VatBase1; VATSlotBase[1])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatBase2; VATSlotBase[2])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatBase3; VATSlotBase[3])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatBase4; VATSlotBase[4])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatAmount1; VATSlotAmount[1])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatAmount2; VATSlotAmount[2])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatAmount3; VATSlotAmount[3])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(VatAmount4; VATSlotAmount[4])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
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
            column(DueAmount1; DueAmountSlot[1])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(DueAmount2; DueAmountSlot[2])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(DueAmount3; DueAmountSlot[3])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(DueAmount4; DueAmountSlot[4])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalNetAmount; TotalAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATBaseLCY; TotalVATBaseLCY) { AutoFormatType = 1; }
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
            column(TotalVATAmountLCY; TotalVATAmountLCY) { AutoFormatType = 1; }
            column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATAmountText; TotalVATAmountText)
            {
            }
            column(TotalExcludingVATText; TotalExclVATText)
            {
            }
            column(TotalIncludingVATText; TotalInclVATText)
            {
            }
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
            column(TotalText; TotalText)
            {
            }
            column(TotalAmountExclInclVAT; TotalAmountExclInclVATValue)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
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
                column(LineDiscountPercent_Line; "Line Discount %")
                {
                    DecimalPlaces = 0 : 5;
                }
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
                dataitem(ItemTrackingLine; "Tracking Specification")
                {
                    DataItemTableView = sorting("Entry No.");
                    UseTemporary = true;

                    column(ItemTrackingLineLotNo; "Lot No.")
                    {
                    }
                    column(ItemTrackingLineQty; "Qty. to Handle")
                    {
                        DecimalPlaces = 0 : 5;
                    }

                    trigger OnPreDataItem()
                    begin
                        ItemTrackingLine.SetRange("Source Ref. No.", Line."Line No.");
                    end;
                }
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
                    column(Quantity_ShipmentLine; Quantity)
                    {
                        DecimalPlaces = 0 : 5;
                    }
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
                column(VATPct_VatAmountLine; "VAT %")
                {
                    DecimalPlaces = 0 : 5;
                }
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
                ReportLanguageCode := LanguageMgt.GetUserLanguageCode();
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(ReportLanguageCode);
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                FormatAddr.SetLanguageCode(ReportLanguageCode);

                if not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) then
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
                OurBankAccountText := CHMMgmt.GetBankAccountText(CompanyBankAccount);

                if not Cust.Get(Header."Bill-to Customer No.") then
                    Clear(Cust);

                CHMMgmt.GetCurrencyInfo(Header."Currency Code", Header."Posting Date", Header."Currency Factor", CurrCode, ExchangeRateText, CalculatedExchRate);

                FillLeftHeader();
                FillRightHeader();
                CHMMgmt.GetLineFeeNotes(Enum::"Gen. Journal Document Type"::"Credit Memo", Header."No.", TempLineFeeNoteOnReportHist);
                CHMMgmt.GetCrMemoRemainingAmount(Header."No.", Header."Bill-to Customer No.", RemainingAmount, RemainingAmountTxt);

                SetChematekHeaderFields();
                CHMMgmt.FillSalesCrMemoLotBuffer(Header."No.", ItemTrackingLine);
                CalcDocumentTotals();
                CHMMgmt.FillVATSlots(VATAmountLine, Header."VAT Bus. Posting Group", VATSlotCode, VATSlotDescription, VATSlotPct, VATSlotBase, VATSlotAmount);
                CHMMgmt.FillPaymentSchedule(Header."Due Date", TotalAmountInclVAT, DueDateSlot, DueAmountSlot);
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
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo");
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

    labels
    {
        BillToAddress_Caption = 'Bill-to Address';
        CustomerVendorContact_Caption = 'Contact';
        CustomerVendorMail_Caption = 'E-Mail';
        CustomerVendorNo_Caption = 'Customer No.';
        DocumentNo_Caption = 'Document No.';
        FiscalCode_Caption = 'Fiscal Code';
        Line_Amount_Caption = 'Amount';
        Line_Description_Caption = 'Description';
        Line_ItemNo_Caption = 'Item No.';
        Line_LineDiscountPerc_Caption = 'Disc. %';
        Line_Quantity_Caption = 'Quantity';
        Line_UnitPrice_Caption = 'Unit Price';
        Line_UoM_Caption = 'UoM';
        Line_VATIdentifier_Caption = 'VAT';
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
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Sales Cr. Memo");

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
        CHMMgmt: Codeunit "CHM Customization Mgmt.";
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
        OperatorName: Text;
        LocationAddress: Text;
        ReasonCodeText: Text;
        FiscalCodeNo: Text;
        ShowIso: Boolean;
        JobNo: Code[20];
        JobTaskNo: Code[20];
        JobNoLbl: Text;
        JobTaskNoLbl: Text;
        JobTaskDescription: Text[100];
        TariffNo: Text;
        ADRClass: Text;
        ItemUN: Text;
        CountryOrigin: Text;
        VATExemptDocumentNo: Code[20];
        VATExemptLineNo: Integer;
        NoVATExemption: Boolean;
        VATExemptSource: Text;
        VATExemptStartingDate: Text;
        VATExemptEndingDate: Text;
        VATExemptNo: Text;
        VATExemptionType: Text;
        VATSlotCode: array[4] of Code[20];
        VATSlotDescription: array[4] of Text;
        VATSlotPct: array[4] of Decimal;
        VATSlotBase: array[4] of Decimal;
        VATSlotAmount: array[4] of Decimal;
        DueDateSlot: array[4] of Text;
        DueAmountSlot: array[4] of Decimal;
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
        LCYTxt: Label ' (LCY)';
        LineDiscountPctTok: Label '%1%', Locked = true;
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidentally printing all documents.';

    /// <summary>
    /// Sets the request options when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    /// <summary>
    /// Sets all the request options, including the shipment information and the additional fee note, when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; DisplayAsmInfo: Boolean; DisplayShipmentInfo: Boolean; DisplayAddFeeNote: Boolean)
    begin
        InitializeRequest(NewLogInteraction, DisplayAsmInfo);
        DisplayShipmentInformation := DisplayShipmentInfo;
        DisplayAdditionalFeeNote := DisplayAddFeeNote;
    end;

    /// <summary>
    /// Sets the total labels, salesperson / purchaser, payment terms, payment method and shipment method texts printed on the document.
    /// </summary>
    local procedure FormatDocumentFields(SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
        FormatDocument.SetTotalLabels(SalesCrMemoHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesCrMemoHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesCrMemoHeader."Payment Terms Code", ReportLanguageCode);
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesCrMemoHeader."Payment Method Code", ReportLanguageCode);
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesCrMemoHeader."Shipment Method Code", ReportLanguageCode);
    end;

    /// <summary>
    /// Fills the Chematek header fields: operator, shipment from location, reason code and fiscal code.
    /// </summary>
    local procedure SetChematekHeaderFields()
    begin
        OperatorName := CHMMgmt.GetUserFullName(Header."User ID");
        LocationAddress := CHMMgmt.GetLocationAddressLine(Header."Location Code");
        ReasonCodeText := CHMMgmt.GetReasonCodeText(Header."Reason Code");
        FiscalCodeNo := CHMMgmt.GetCustomerFiscalCode(Header."Bill-to Customer No.");
    end;

    /// <summary>
    /// Calculates the document totals and the VAT amounts in LCY printed in the footer of the document.
    /// </summary>
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

    /// <summary>
    /// Adds the posted document line to the VAT amount lines.
    /// </summary>
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

    /// <summary>
    /// Returns true when the VAT clause of the current VAT amount line must be printed.
    /// </summary>
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

    /// <summary>
    /// Fills the report totals buffer (subtotal, invoice discount, VAT) printed in the footer.
    /// </summary>
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

    /// <summary>
    /// Fills the return receipts printed under the line when "Show Shipments" is selected.
    /// </summary>
    local procedure InitializeShipmentLine()
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
    begin
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

    /// <summary>
    /// Sets the project and project task printed under the line.
    /// </summary>
    local procedure SetLineJobInfo(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        JobNo := SalesCrMemoLine."Job No.";
        JobTaskNo := SalesCrMemoLine."Job Task No.";

        if JobTaskNo <> '' then begin
            JobTaskNoLbl := JobTaskNoCaptionLbl;
            JobTaskDescription := CHMMgmt.GetJobTaskDescription(JobNo, JobTaskNo);
        end else begin
            JobTaskDescription := '';
            JobTaskNoLbl := '';
        end;

        if JobNo <> '' then
            JobNoLbl := JobNoCaptionLbl
        else
            JobNoLbl := '';
    end;

    /// <summary>
    /// Fills the item data printed under the line: tariff no., country of origin and dangerous goods data.
    /// </summary>
    local procedure GetLineItemInfo(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    var
        Item: Record Item;
    begin
        ADRClass := '';
        ItemUN := '';
        TariffNo := '';
        CountryOrigin := '';

        if SalesCrMemoLine.Type <> SalesCrMemoLine.Type::Item then
            exit;
        if not Item.Get(SalesCrMemoLine."No.") then
            exit;

        CHMMgmt.GetItemCustomsInfo(Item, TariffNo, CountryOrigin);
        CHMMgmt.GetItemDangerousGoodsInfo(Item, ADRClass, ItemUN);
    end;

    /// <summary>
    /// Fills the declaration of intent printed under a document line without VAT.
    /// </summary>
    local procedure GetLineVATExemption(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        VATExemptDocumentNo := SalesCrMemoLine."Document No.";
        VATExemptLineNo := SalesCrMemoLine."Line No.";
        VATExemptionType := '';
        NoVATExemption := not CHMMgmt.GetCustomerLineVATExemption(
            (SalesCrMemoLine.Type <> SalesCrMemoLine.Type::" ") and (SalesCrMemoLine."VAT %" = 0), Header."Bill-to Customer No.", Header."Posting Date",
            VATExemptNo, VATExemptSource, VATExemptStartingDate, VATExemptEndingDate);
    end;

    /// <summary>
    /// Fills the left header block of the layout with the document data.
    /// </summary>
    local procedure FillLeftHeader()
    begin
        LeftHeader.DeleteAll();
        CHMMgmt.FillNameValueTable(LeftHeader, Header.FieldCaption("External Document No."), Header."External Document No.");
        CHMMgmt.FillNameValueTable(LeftHeader, Header.FieldCaption("Bill-to Customer No."), Header."Bill-to Customer No.");
        CHMMgmt.FillNameValueTable(LeftHeader, Header.GetCustomerVATRegistrationNumberLbl(), Header.GetCustomerVATRegistrationNumber());
        CHMMgmt.FillNameValueTable(LeftHeader, CrMemoNoLbl, Header."No.");
        CHMMgmt.FillNameValueTable(LeftHeader, Header.FieldCaption("Return Order No."), Header."Return Order No.");
        CHMMgmt.FillNameValueTable(LeftHeader, Header.FieldCaption("Document Date"), Format(Header."Document Date", 0, 4));
        CHMMgmt.FillNameValueTable(LeftHeader, Header.FieldCaption("Due Date"), Format(Header."Due Date", 0, 4));
        CHMMgmt.FillNameValueTable(LeftHeader, PaymentTermsCaptionLbl, PaymentTerms.Description);
        CHMMgmt.FillNameValueTable(LeftHeader, PaymentMethodCaptionLbl, PaymentMethod.Description);
        CHMMgmt.FillNameValueTable(LeftHeader, Cust.GetLegalEntityTypeLbl(), Cust.GetLegalEntityType());
        CHMMgmt.FillNameValueTable(LeftHeader, ShipmentMethodCaptionLbl, ShipmentMethod.Description);
    end;

    /// <summary>
    /// Fills the right header block of the layout with the company data.
    /// </summary>
    local procedure FillRightHeader()
    begin
        RightHeader.DeleteAll();
        CHMMgmt.FillNameValueTable(RightHeader, CompanyInfo.FieldCaption("E-Mail"), CompanyInfo."E-Mail");
        CHMMgmt.FillNameValueTable(RightHeader, CompanyInfo.FieldCaption("Home Page"), CompanyInfo."Home Page");
        CHMMgmt.FillNameValueTable(RightHeader, CompanyInfo.FieldCaption("Phone No."), CompanyInfo."Phone No.");
        CHMMgmt.FillNameValueTable(RightHeader, CompanyInfo.GetRegistrationNumberLbl(), CompanyInfo.GetRegistrationNumber());
        CHMMgmt.FillNameValueTable(RightHeader, CompanyInfo.GetVATRegistrationNumberLbl(), CompanyInfo.GetVATRegistrationNumber());
        CHMMgmt.FillNameValueTable(RightHeader, OurBankCaptionLbl, CompanyBankAccount.Name);
        CHMMgmt.FillNameValueTable(RightHeader, CompanyBankAccount.FieldCaption(IBAN), CompanyBankAccount.IBAN);
        CHMMgmt.FillNameValueTable(RightHeader, CompanyBankAccount.FieldCaption("SWIFT Code"), CompanyBankAccount."SWIFT Code");
    end;
}
 */