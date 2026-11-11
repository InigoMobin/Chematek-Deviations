report 66602 "CHM Sales Order Confirmation"
{
    Caption = 'CHM Sales Order Confirmation';
    UsageCategory = None;
    DefaultRenderingLayout = SalesOrderConfRDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Header; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Bill-to Customer No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';

            column(BillToAddress_Lbl; BillToAddressCaptionLbl)
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
            column(DocumentTypeLabel; OrderConfirmationCaptionLbl)
            {
            }
            column(DocumentNoLbl; DocumentNoCaptionLbl)
            {
            }
            column(DateLbl; DateCaptionLbl)
            {
            }
            column(ReasonLbl; ReasonCaptionLbl)
            {
            }
            column(CustomerVendorNoLbl; CustomerNoCaptionLbl)
            {
            }
            column(VatRegNoLbl; VATRegNoCaptionLbl)
            {
            }
            column(FiscalCodeLbl; FiscalCodeCaptionLbl)
            {
            }
            column(PaymentTermsDescLbl; PaymentTermsCaptionLbl)
            {
            }
            column(PaymentMethodDescLbl; PaymentMethodCaptionLbl)
            {
            }
            column(SalespersonLbl; SalespersonCaptionLbl)
            {
            }
            column(OperatorNameLbl; OperatorCaptionLbl)
            {
            }
            column(ShptTermsLbl; DeliveryTermsCaptionLbl)
            {
            }
            column(OurBankAccountLbl; OurBankCaptionLbl)
            {
            }
            column(ShptByLbl; ShippingAgentCaptionLbl)
            {
            }
            column(YourReferenceLbl; YourReferenceCaptionLbl)
            {
            }
            column(ExpShptReqDate; RequestedDeliveryDateCaptionLbl)
            {
            }
            column(ShptMethodLbl; ShipmentMethodCaptionLbl)
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
            column(ShipmentFrom_Caption; ShipmentFromCaptionLbl)
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
            column(AssignedUserID; Header."Assigned User ID")
            {
            }
            column(OperatorName; OperatorName)
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
            column(ViewLocation; ViewLocation)
            {
            }
            column(ReasonCode; ReasonCodeText)
            {
            }
            column(CompanyPicture; DummyCompanyInfo.Picture)
            {
            }
            column(OrderDate; Format(Header."Order Date"))
            {
            }
            column(CompanyIBAN; CompanyBankAccount.IBAN)
            {
            }
            column(CompanyIBAN_Lbl; CompanyBankAccount.FieldCaption(IBAN))
            {
            }
            column(CompanyLogoPosition; CompanyLogoPosition)
            {
            }
            column(CompanyLegalStatement; LegalStatementLbl)
            {
            }
            column(ShptBy; ShippingAgentName)
            {
            }
            column(ShptMethod; Header."Shipment Method Code")
            {
            }
            column(RequestedDeliveryDate; Format(Header."Requested Delivery Date"))
            {
            }
            column(FiscalCodeNo; FiscalCodeNo)
            {
            }
            column(SellToContactPhoneNoLbl; SellToContactPhoneNoLbl)
            {
            }
            column(SellToContactMobilePhoneNoLbl; SellToContactMobilePhoneNoLbl)
            {
            }
            column(SellToContactEmailLbl; SellToContactEmailLbl)
            {
            }
            column(BillToContactPhoneNoLbl; BillToContactPhoneNoLbl)
            {
            }
            column(BillToContactMobilePhoneNoLbl; BillToContactMobilePhoneNoLbl)
            {
            }
            column(BillToContactEmailLbl; BillToContactEmailLbl)
            {
            }
            column(SellToContactPhoneNo; SellToContact."Phone No.")
            {
            }
            column(SellToContactMobilePhoneNo; SellToContact."Mobile Phone No.")
            {
            }
            column(SellToContactEmail; SellToContactEmail)
            {
            }
            column(SellToContactName; Header."Sell-to Contact")
            {
            }
            column(BillToContactPhoneNo; BillToContact."Phone No.")
            {
            }
            column(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.")
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
            column(ShipmentMethodDescription_Lbl; ShipmentMethodCaptionLbl)
            {
            }
            column(Shipment_Lbl; ShipmentLbl)
            {
            }
            column(ShipmentDate; Format(Header."Shipment Date"))
            {
            }
            column(ShipmentDate_Lbl; Header.FieldCaption("Shipment Date"))
            {
            }
            column(ShowShippingAddress; ShowShippingAddr)
            {
            }
            column(BillAndShipSame; not ShowShippingAddr)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentTermsDescription_Lbl; PaymentTermsCaptionLbl)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(PaymentMethodDescription_Lbl; PaymentMethodCaptionLbl)
            {
            }
            column(DocumentCopyText; OrderConfirmationCaptionLbl)
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
            column(DocumentNo; Header."No.")
            {
            }
            column(DocumentNo_Lbl; DocumentNoCaptionLbl)
            {
            }
            column(QuoteNo; Header."Quote No.")
            {
            }
            column(QuoteNo_Lbl; QuoteNoCaptionLbl)
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
            column(SalesPerson_Lbl; SalespersonCaptionLbl)
            {
            }
            column(SalesPersonText_Lbl; SalesPersonText)
            {
            }
            column(SalesPersonName; SalespersonPurchaser.Name)
            {
            }
            column(SelltoCustomerNo; Header."Sell-to Customer No.")
            {
            }
            column(SelltoCustomerNo_Lbl; Header.FieldCaption("Sell-to Customer No."))
            {
            }
            column(VATRegistrationNo; Header.GetCustomerVATRegistrationNumber())
            {
            }
            column(VATRegistrationNo_Lbl; Header.GetCustomerVATRegistrationNumberLbl())
            {
            }
            column(SellToFaxNo; SellToCust."Fax No.")
            {
            }
            column(SellToPhoneNo; Header."Sell-to Phone No.")
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
            column(SalesInvoiceLineDiscount_Lbl; SalesInvLineDiscLbl)
            {
            }
            column(Invoice_Lbl; OrderCaptionLbl)
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
            column(VATIdentifier_Lbl; VATIdentifierLbl)
            {
            }
            column(VATPercentage_Lbl; VATPercentageLbl)
            {
            }
            column(VATClause_Lbl; VATClause.TableCaption())
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
            column(Line_NoLbl; LineNoCaptionLbl)
            {
            }
            column(Line_DesciptionLbl; LineDescriptionCaptionLbl)
            {
            }
            column(Line_QuantityLbl; LineQuantityCaptionLbl)
            {
            }
            column(Line_UMLbl; LineUoMCaptionLbl)
            {
            }
            column(Line_PriceLbl; LinePriceCaptionLbl)
            {
            }
            column(Line_DiscPercLbl; LineDiscPctCaptionLbl)
            {
            }
            column(Line_AmountLbl; LineAmountCaptionLbl)
            {
            }
            column(Line_VATLbl; LineVATCaptionLbl)
            {
            }
            column(Line_ShptReqDate; LineShipmentDateCaptionLbl)
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
            column(TotalNetAmount; TotalAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalVATBaseLCY; TotalVATBaseLCY)
            {
            }
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
            column(TotalVATAmountLCY; TotalVATAmountLCY)
            {
            }
            column(TotalInvoiceDiscountAmount; TotalInvDiscAmount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalPaymentDiscountOnVAT; TotalPaymentDiscOnVAT)
            {
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
            column(TotalLineDiscount; TotalLineDiscount)
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(TotalText; TotalText)
            {
            }
            column(VAT_ClauseCode1; VATClauseSlotCode[1])
            {
            }
            column(VAT_ClauseDescription1; VATClauseSlotDescription[1])
            {
            }
            column(VAT_ClauseCode2; VATClauseSlotCode[2])
            {
            }
            column(VAT_ClauseDescription2; VATClauseSlotDescription[2])
            {
            }
            column(VAT_ClauseCode3; VATClauseSlotCode[3])
            {
            }
            column(VAT_ClauseDescription3; VATClauseSlotDescription[3])
            {
            }
            column(VAT_ClauseCode4; VATClauseSlotCode[4])
            {
            }
            column(VAT_ClauseDescription4; VATClauseSlotDescription[4])
            {
            }
            column(ShowVATClauseTab; ShowVATClauseTab)
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
            column(DiscountAmount1; VATSlotDiscount[1])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(DiscountAmount2; VATSlotDiscount[2])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(DiscountAmount3; VATSlotDiscount[3])
            {
                AutoFormatExpression = Header."Currency Code";
                AutoFormatType = 1;
            }
            column(DiscountAmount4; VATSlotDiscount[4])
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
            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                UseTemporary = true;

                column(Line_LineNo; "Line No.")
                {
                }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountExcludingVAT_Line_Lbl; FieldCaption(Amount))
                {
                }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountIncludingVAT_Line_Lbl; FieldCaption("Amount Including VAT"))
                {
                }
                column(Line_RequestedDeliveryDate; Format("Requested Delivery Date"))
                {
                }
                column(Line_Description; Description)
                {
                }
                column(Description_Line_Lbl; FieldCaption(Description))
                {
                }
                column(Line_LineDiscountPerc; "Line Discount %")
                {
                    DecimalPlaces = 0 : 5;
                }
                column(LineDiscountPercentText_Line; LineDiscountPctText)
                {
                }
                column(Line_Amount; "Line Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(LineAmount_Line_Lbl; FieldCaption("Line Amount"))
                {
                }
                column(Line_ItemNo; "No.")
                {
                }
                column(Line_Type; Format(Type))
                {
                }
                column(ItemNo_Line_Lbl; FieldCaption("No."))
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
                column(Line_Quantity; Quantity)
                {
                    DecimalPlaces = 0 : 5;
                }
                column(Quantity_Line_Lbl; FieldCaption(Quantity))
                {
                }
                column(Type_Line; Format(Type))
                {
                }
                column(Line_UnitPrice; "Unit Price")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(UnitPrice_Lbl; FieldCaption("Unit Price"))
                {
                }
                column(UnitOfMeasure; "Unit of Measure")
                {
                }
                column(Line_UoMCode; "Unit of Measure Code")
                {
                }
                column(UnitOfMeasure_Lbl; FieldCaption("Unit of Measure"))
                {
                }
                column(Line_VATIdentifier; "VAT Identifier")
                {
                }
                column(VATIdentifier_Line_Lbl; FieldCaption("VAT Identifier"))
                {
                }
                column(VATPct_Line; FormattedVATPct)
                {
                }
                column(VATPct_Line_Lbl; FieldCaption("VAT %"))
                {
                }
                column(TransHeaderAmount; TransHeaderAmount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(ItemReferenceNo; "Item Reference No.")
                {
                }
                column(ItemReferenceNo_Lbl; FieldCaption("Item Reference No."))
                {
                }
                column(ItemReferenceDescription; ItemReferenceDescription)
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
                column(ItemUNValue; ItemUNValue)
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
                dataitem(AssemblyLine; "Assembly Line")
                {
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");

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
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        if not AsmInfoExistsForLine then
                            CurrReport.Break();
                        AssemblyLine.SetRange("Document Type", AsmHeader."Document Type");
                        AssemblyLine.SetRange("Document No.", AsmHeader."No.");
                    end;
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
                dataitem(TrackingSpecBuffer2; "Tracking Specification")
                {
                    DataItemTableView = sorting("Entry No.");
                    UseTemporary = true;

                    column(TrackingSpecBufferItemNo2; "Item No.")
                    {
                    }
                    column(TrackingSpecBufferLotNo2; "Lot No.")
                    {
                    }
                    column(TrackingSpecBufferDesc2; Description)
                    {
                    }
                    column(TrackingSpecBufferQty2; "Qty. to Handle")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(QuantityCaption2; LineQuantityCaptionLbl)
                    {
                    }
                    column(LotNoCaption2; ShippedLotNoCaptionLbl)
                    {
                    }
                    column(DescriptionCaption2; LineDescriptionCaptionLbl)
                    {
                    }
                    column(NoCaption2; LineNoCaptionLbl)
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        TrackingSpecBuffer2.SetRange("Source Ref. No.", Line."Line No.");
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
                    ItemReferenceDescription := CHMMgmt.GetItemReferenceDescription(Line);
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
                column(VATAmountLCY_VATAmountLine; VATAmountLCY)
                {
                }
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
                column(VATBaseLCY_VATAmountLine; VATBaseLCY)
                {
                }
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
            dataitem(LetterText; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                column(GreetingText; GreetingLbl)
                {
                }
                column(BodyText; BodyLbl)
                {
                }
                column(ClosingText; ClosingLbl)
                {
                }
                column(PmtDiscText; PmtDiscText)
                {
                }

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

                if not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) then
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

                CHMMgmt.GetCurrencyInfo(Header."Currency Code", Header."Posting Date", Header."Currency Factor", CurrCode, ExchangeRateText, CalculatedExchRate);
                FormatDocumentFields(Header);

                Clear(SellToContact);
                Clear(BillToContact);
                if SellToContact.Get(Header."Sell-to Contact No.") then;
                if BillToContact.Get(Header."Bill-to Contact No.") then;
                SellToContactEmail := SellToContact."E-Mail";
                if SellToContactEmail = '' then
                    SellToContactEmail := Header."Sell-to E-Mail";

                SetChematekHeaderFields(Header);
                CHMMgmt.FillSalesLineLotBuffers(Line, TrackingSpecBuffer, TrackingSpecBuffer2);
                CalcDocumentTotals();
                CHMMgmt.FillVATSlots(VATAmountLine, Header."VAT Bus. Posting Group", VATSlotCode, VATSlotDescription, VATSlotPct, VATSlotBase, VATSlotAmount, VATSlotDiscount);
                ShowVATClauseTab := CHMMgmt.FillVATClauseSlots(VATAmountLine, Header, VATClauseSlotCode, VATClauseSlotDescription);
                CHMMgmt.FillPaymentSchedule(Header."Due Date", TotalAmountInclVAT, DueDateSlot, DueAmountSlot);

                if not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) and
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
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Sales Ord. Cnfrmn.");
            LogInteractionEnable := LogInteraction;
        end;
    }

    rendering
    {
        layout(SalesOrderConfRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMSalesOrderConfirmation.rdl';
            Caption = 'Chematek Sales Order Confirmation';
            Summary = 'Chematek sales order confirmation with VAT summary, VAT clauses, lot numbers and dangerous goods information per line.';
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
        OrderConf_Title = 'Order Confirmation';
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

        if not CurrReport.UseRequestPage then
            LogInteraction := CHMMgmt.InteractionTemplateExists(Enum::"Interaction Log Entry Document Type"::"Sales Ord. Cnfrmn.");

        CompanyLogoPosition := SalesSetup."Logo Position on Documents";
        CHMMgmt.GetDocumentSetup(CHMSetup);
        ShowIso := CHMSetup."Show ISO";
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not CHMMgmt.IsDocumentPreview(CurrReport.Preview()) then
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
        CHMMgmt: Codeunit "CHM Customization Mgmt.";
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
        ItemReferenceDescription: Text;
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
        OperatorName: Text;
        LocationName: Text;
        LocationAddress: Text;
        LocationCity: Text;
        ViewLocation: Boolean;
        ReasonCodeText: Text;
        ShippingAgentName: Text;
        FiscalCodeNo: Text;
        ShowIso: Boolean;
        ItemHazardousDescr: Text;
        Hazardous: Boolean;
        TariffNo: Text;
        ADRClass: Text;
        ItemUN: Text;
        ItemUNValue: Text;
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
        VATSlotDiscount: array[4] of Decimal;
        VATClauseSlotCode: array[4] of Code[20];
        VATClauseSlotDescription: array[4] of Text;
        ShowVATClauseTab: Boolean;
        DueDateSlot: array[4] of Text;
        DueAmountSlot: array[4] of Decimal;
        OrderConfirmationCaptionLbl: Label 'Order Confirmation';
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
        ShippedLotNoCaptionLbl: Label 'Shipped Lot No.';
        CountryOfOriginCaptionLbl: Label 'Country of Origin:';
        TariffNoCaptionLbl: Label 'Tariff No.:';
        UNNoCaptionLbl: Label 'UN No.:';
        ADRClassCaptionLbl: Label 'ADR Class:';
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
        BodyLbl: Label 'Thank you for your business. Your order confirmation is attached to this message.';
        PmtDiscTxt: Label 'If we receive the payment before %1, you are eligible for a %2% payment discount.', Comment = '%1 = Discount Due Date %2 = value of Payment Discount % ';
        LCYTxt: Label ' (LCY)';
        LineDiscountPctTok: Label '%1%', Locked = true;
        NoFilterSetErr: Label 'You must specify one or more filters to avoid accidentally printing all documents.';

    /// <summary>
    /// Sets the request options when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; NewDisplayAssemblyInformation: Boolean)
    begin
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := NewDisplayAssemblyInformation;
    end;

    /// <summary>
    /// Sets the request options, including archiving, when the report is run from code.
    /// </summary>
    procedure InitializeRequest(NewLogInteraction: Boolean; NewDisplayAssemblyInformation: Boolean; NewArchiveDocument: Boolean)
    begin
        InitializeRequest(NewLogInteraction, NewDisplayAssemblyInformation);
        ArchiveDocument := NewArchiveDocument;
    end;

    /// <summary>
    /// Sets the total labels, salesperson / purchaser, payment terms, payment method and shipment method texts printed on the document.
    /// </summary>
    local procedure FormatDocumentFields(SalesHeader: Record "Sales Header")
    begin
        FormatDocument.SetTotalLabels(SalesHeader.GetCurrencySymbol(), TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetSalesPerson(SalespersonPurchaser, SalesHeader."Salesperson Code", SalesPersonText);
        FormatDocument.SetPaymentTerms(PaymentTerms, SalesHeader."Payment Terms Code", SalesHeader."Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod, SalesHeader."Payment Method Code", SalesHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, SalesHeader."Shipment Method Code", SalesHeader."Language Code");
    end;

    /// <summary>
    /// Fills the Chematek header fields: operator, shipment from location, reason code, shipping agent and fiscal code.
    /// </summary>
    local procedure SetChematekHeaderFields(SalesHeader: Record "Sales Header")
    begin
        OperatorName := CHMMgmt.GetOperatorName(SalesHeader."Assigned User ID");
        CHMMgmt.GetLocationAddress(SalesHeader."Location Code", LocationName, LocationAddress, LocationCity);
        ViewLocation := LocationAddress <> '';
        ReasonCodeText := CHMMgmt.GetReasonCodeText(SalesHeader."Reason Code");
        ShippingAgentName := CHMMgmt.GetShippingAgentName(SalesHeader."Shipping Agent Code");
        FiscalCodeNo := CHMMgmt.GetCustomerFiscalCode(SalesHeader."Bill-to Customer No.");
    end;

    /// <summary>
    /// Calculates the document totals and the VAT amounts in LCY printed in the footer of the document.
    /// </summary>
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

    /// <summary>
    /// Fills the item data printed under the line: tariff no., country of origin and dangerous goods data.
    /// </summary>
    local procedure GetLineItemInfo(SalesLine: Record "Sales Line")
    var
        Item: Record Item;
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

        CHMMgmt.GetItemCustomsInfo(Item, TariffNo, CountryOrigin);
        CHMMgmt.GetItemDangerousGoodsInfo(Item, Hazardous, ItemHazardousDescr, ADRClass, ItemUN);
        ItemUNValue := ItemUN;
    end;

    /// <summary>
    /// Fills the declaration of intent printed under a document line without VAT.
    /// </summary>
    local procedure GetLineVATExemption(SalesLine: Record "Sales Line")
    begin
        VATExemptDocumentNo := SalesLine."Document No.";
        VATExemptLineNo := SalesLine."Line No.";
        VATExemptionType := '';
        NoVATExemption := not CHMMgmt.GetCustomerLineVATExemption(
            (SalesLine.Type <> SalesLine.Type::" ") and (SalesLine."VAT %" = 0), Header."Bill-to Customer No.",
            CHMMgmt.GetVATExemptionDate(Header."Posting Date", Header."Document Date"),
            VATExemptNo, VATExemptSource, VATExemptStartingDate, VATExemptEndingDate);
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
                ReportTotalsLine.Add(TotalExclVATText, TotalAmount, true, false, false, Header."Currency Code");
        end;
        if TotalAmountVAT <> 0 then begin
            ReportTotalsLine.Add(VATAmountLine.VATAmountText(), TotalAmountVAT, false, true, false, Header."Currency Code");
            if TotalVATAmountLCY <> TotalAmountVAT then
                ReportTotalsLine.Add(VATAmountLine.VATAmountText() + LCYTxt, TotalVATAmountLCY, false, true, false);
        end;
    end;
}
