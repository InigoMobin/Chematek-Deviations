report 66606 "CHM Purchase Order"
{
    // Chematek Purchase Order.
    // Based on the standard "Standard Purchase - Order" (report 1322, BC 28 W1), extended with the
    // columns used by the Chematek RDLC layout "CHM Purchase Order - Text Embedded" (DataSet_Result).
    // The layout was derived from the Chematek sales layouts, so several column names still use
    // sales wording (CustomerAddress, BilltoCustumerNo, SellToContactName, ...). They are kept exactly
    // as they are because the RDLC layout binds to them by name; the comments show the purchase data
    // behind each of them.
    // Decimal columns automatically get a companion "<Name>Format" field in the RDLC dataset,
    // which is why no "...Format" columns are declared here.
    // To print it from the Purchase Order, set it up in Report Selections - Purchase, usage "Order".

    Caption = 'CHM Purchase Order';
    UsageCategory = None;
    DefaultRenderingLayout = PurchaseOrderRDLC;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(Header; "Purchase Header")
        {
            // Only orders are printed: the restriction is set in a hidden filter group in OnPreReport,
            // so "Document Type" can still be shown as a filter field on the request page.
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "Document Type", "No.", "Buy-from Vendor No.";
            RequestFilterHeading = 'Purchase Order';

            // Addresses. CustomerAddress = buy-from vendor address, ShipToAddress = delivery address.
            column(CustomerAddress1; VendAddr[1]) { }
            column(CustomerAddress2; VendAddr[2]) { }
            column(CustomerAddress3; VendAddr[3]) { }
            column(CustomerAddress4; VendAddr[4]) { }
            column(CustomerAddress5; VendAddr[5]) { }
            column(CustomerAddress6; VendAddr[6]) { }
            column(CustomerAddress7; VendAddr[7]) { }
            column(CustomerAddress8; VendAddr[8]) { }
            column(ShipToAddress_Lbl; ShipToAddressCaptionLbl) { }
            column(ShipToAddress1; ShipToAddr[1]) { }
            column(ShipToAddress2; ShipToAddr[2]) { }
            column(ShipToAddress3; ShipToAddr[3]) { }
            column(ShipToAddress4; ShipToAddr[4]) { }
            column(ShipToAddress5; ShipToAddr[5]) { }
            column(ShipToAddress6; ShipToAddr[6]) { }
            column(ShipToAddress7; ShipToAddr[7]) { }
            column(ShipToAddress8; ShipToAddr[8]) { }
            // True when there is a delivery address to print (always the case on a purchase order).
            column(ShowShippingAddress; ShowShippingAddr) { }

            // Document header captions
            column(SelltoCustomerNo_Lbl; VendorNoCaptionLbl) { }
            column(DocumentLbl; PurchaseOrderCaptionLbl) { }
            column(PaymentTermsDescription_Lbl; PaymentTermsCaptionLbl) { }
            column(PaymentMethodDescription_Lbl; PaymentMethodCaptionLbl) { }
            column(SalesPerson_Lbl; PurchaserCaptionLbl) { }
            column(OperatorName_Lbl; OperatorCaptionLbl) { }
            column(DateLbl; DateCaptionLbl) { }
            column(CustomerVendorNoLbl; VendorNoCaptionLbl) { }
            column(CustomerVendorContactLbl; ContactCaptionLbl) { }
            column(ShipmentMethodDescription_Lbl; ShipmentMethodCaptionLbl) { }
            column(VatRegNoLbl; VATRegNoCaptionLbl) { }
            column(FiscalCodeLbl; FiscalCodeCaptionLbl) { }
            column(SellToContactEmailLbl; ContactEmailCaptionLbl) { }
            column(ReasonLbl; ReasonCaptionLbl) { }
            column(YourReference_Lbl; YourReferenceCaptionLbl) { }
            column(ShptByLbl; ShippingAgentCaptionLbl) { }
            column(OrderDate_Caption; OrderDateCaptionLbl) { }
            column(PostingDate_Caption; PostingDateCaptionLbl) { }
            column(ShptMethodDescLbl; ShipmentMethodCaptionLbl) { }
            column(LocationLbl; LocationCaptionLbl) { }
            // Captions printed in the vendor's language. The layout takes every caption from the dataset,
            // not from the labels section, because report labels are fixed in the language of the user
            // running the report and do not follow CurrReport.Language (see OnAfterGetRecord).
            column(DocNo_Lbl; DocNoCaptionLbl) { }
            column(Vendor_Lbl; VendorCaptionLbl) { }
            column(EMail_Lbl; EMailCaptionLbl) { }
            column(VAT_Lbl; VATCaptionLbl) { }
            column(VATClausesCaption_Lbl; VATClausesCaptionLbl) { }

            // Document header values
            column(DocumentNo; Header."No.") { }
            // Printed under "Vendor No." in the layout: the buy-from vendor.
            column(BilltoCustumerNo; Header."Buy-from Vendor No.") { }
            column(SelltoCustomerNo; Header."Buy-from Vendor No.") { }
            column(ShptBy; ShippingAgentName) { }
            column(ShptMethod; Header."Shipment Method Code") { }
            column(OperatorName; OperatorName) { }
            column(AssignedUserID; Header."Assigned User ID") { }
            column(ReasonCode; ReasonCodeText) { }
            column(FiscalCodeNo; FiscalCodeNo) { }
            column(SellToContactName; Header."Buy-from Contact") { }
            column(SellToContactEmail; ContactEmail) { }
            column(BillToContactEmail; ContactEmail) { }
            column(BillToContactEmailLbl; ContactEmailCaptionLbl) { }
            column(YourReference; Header."Your Reference") { }
            column(ShipmentMethodDescription; ShipmentMethod.Description) { }
            column(PaymentTermsDescription; PaymentTerms.Description) { }
            column(PaymentMethodDescription; PaymentMethod.Description) { }
            column(SalesPersonText_Lbl; PurchaserText) { }
            column(SalesPersonName; SalespersonPurchaser.Name) { }
            column(OrderDate; Format(Header."Order Date")) { }
            column(PostingDate; Format(Header."Posting Date")) { }
            column(LocationName; LocationName) { }
            column(LocationAddress; LocationAddress) { }
            column(LocationCity; LocationCity) { }
            column(ViewLocation; ViewLocation) { }

            // Logos: Company Information > Picture (left) and Chematek Customizations Setup (others)
            column(LeftHeaderLogo; CompanyInfo.Picture) { }
            column(RightHeaderLogo; CHMSetup."Right Header Logo") { }
            column(Iso9001Logo; CHMSetup."ISO 9001 Logo") { }
            column(ASSICCLogo; CHMSetup."ASSICC Logo") { }
            column(FooterLogo; CHMSetup."Footer Logo") { }
            column(ShowIso; ShowIso) { }

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

            // Standard purchase order header fields
            column(Shipment_Lbl; ShipmentLbl) { }
            column(ShipmentDate_Lbl; Header.FieldCaption("Expected Receipt Date")) { }
            column(BilltoCustomerNo_Lbl; Header.FieldCaption("Buy-from Vendor No.")) { }
            column(DocumentDate; Format(Header."Document Date")) { }
            column(DocumentDate_Lbl; Header.FieldCaption("Document Date")) { }
            column(DueDate; Format(Header."Due Date")) { }
            column(DueDate_Lbl; Header.FieldCaption("Due Date")) { }
            column(DocumentNo_Lbl; DocumentNoCaptionLbl) { }
            column(QuoteNo; Header."Quote No.") { }
            column(QuoteNo_Lbl; QuoteNoCaptionLbl) { }
            column(PricesIncludingVAT; Header."Prices Including VAT") { }
            column(PricesIncludingVAT_Lbl; Header.FieldCaption("Prices Including VAT")) { }
            column(PricesIncludingVATYesNo; Format(Header."Prices Including VAT")) { }
            column(VATRegistrationNo; VATRegistrationNo) { }
            column(Copy_Lbl; CopyLbl) { }
            column(InvoiceDiscountBaseAmount_Lbl; InvDiscBaseAmtLbl) { }
            column(InvoiceDiscountAmount_Lbl; InvDiscountAmtLbl) { }
            column(LineAmountAfterInvoiceDiscount_Lbl; LineAmtAfterInvDiscLbl) { }
            column(LocalCurrency_Lbl; LocalCurrencyLbl) { }
            column(ExchangeRateAsText; ExchangeRateText) { }
            column(Page_Lbl; PageLbl) { }
            column(Subtotal_Lbl; SubtotalLbl) { }
            column(Total_Lbl; TotalLbl) { }
            column(VATAmount_Lbl; VATAmtLbl) { }
            column(VATBase_Lbl; VATBaseLbl) { }
            column(VATAmountSpecification_Lbl; VATAmtSpecificationLbl) { }
            column(VATClauses_Lbl; VATClausesLbl) { }
            column(VATIdentifier_Lbl; VATIdentifierLbl) { }
            column(VATPercentage_Lbl; VATPercentageLbl) { }
            column(VATClause_Lbl; VATClause.TableCaption()) { }
            // Note printed in the page footer of the layout (see GetDocumentNote).
            column(DescrLav; DocumentNoteText) { }
            column(CurrencyCode; CurrCode) { }

            // Purchase terms printed under the lines (layout Textbox58 / Textbox59), translated per vendor language.
            column(ShelfLifeClauseText; ShelfLifeClauseLbl) { }
            column(TermsAcceptanceText; TermsAcceptanceLbl) { }

            // Line table captions (header row of the lines table)
            column(ItemNo_Line_Lbl; LineNoCaptionLbl) { }
            column(Description_Line_Lbl; LineDescriptionCaptionLbl) { }
            column(Quantity_Line_Lbl; LineQuantityCaptionLbl) { }
            column(UnitOfMeasure_Lbl; LineUoMCaptionLbl) { }
            column(AmountExcludingVAT_Line_Lbl; LineAmountCaptionLbl) { }
            column(LineAmount_Line_Lbl; LineAmountCaptionLbl) { }
            column(VATIdentifier_Line_Lbl; VATIdentifierLbl) { }
            column(VATPct_Line_Lbl; VATPercentageLbl) { }
            column(AmountIncludingVAT_Line_Lbl; AmountInclVATCaptionLbl) { }
            column(Qty_Lbl; QtyLbl) { }
            column(Price_Lbl; PriceLbl) { }
            column(PricePer_Lbl; PricePerLbl) { }
            column(Unit_Lbl; UnitLbl) { }
            column(LineAmount_Lbl; LineAmountCaptionLbl) { }
            column(SalesInvoiceLineDiscount_Lbl; LineDiscPctCaptionLbl) { }
            column(LotNo_Caption; LotNoCaptionLbl) { }
            column(CountryOfOrigin_Caption; CountryOfOriginCaptionLbl) { }
            column(Tariff_No_Caption; TariffNoCaptionLbl) { }
            column(UN_Caption; UNNoCaptionLbl) { }
            column(ADR_Class_Caption; ADRClassCaptionLbl) { }
            column(TypeLbl; LineTypeCaptionLbl) { }

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

            // Payment schedule: 4 fixed slots (see FillPaymentSchedule)
            column(DueDate1; DueDateSlot[1]) { }
            column(DueDate2; DueDateSlot[2]) { }
            column(DueDate3; DueDateSlot[3]) { }
            column(DueDate4; DueDateSlot[4]) { }
            column(DueAmount1; DueAmountSlot[1]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount2; DueAmountSlot[2]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount3; DueAmountSlot[3]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }
            column(DueAmount4; DueAmountSlot[4]) { AutoFormatExpression = Header."Currency Code"; AutoFormatType = 1; }

            dataitem(Line; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = Header;
                DataItemTableView = sorting("Document No.", "Line No.");
                UseTemporary = true;

                // The layout groups the lines table on the line number, so this column must only be
                // filled on line rows.
                column(Line_LineNo; "Line No.") { }
                column(AmountExcludingVAT_Line; Amount)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(AmountIncludingVAT_Line; "Amount Including VAT")
                {
                    AutoFormatExpression = Header."Currency Code";
                    AutoFormatType = 1;
                }
                column(Line_RequestedDeliveryDate; Format("Requested Receipt Date")) { }
                column(Line_Description; Description) { }
                column(Line_LineDiscountPerc; "Line Discount %") { DecimalPlaces = 0 : 5; }
                column(LineDiscountPercentText_Line; LineDiscountPctText) { }
                column(Line_Amount; "Line Amount")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Line_ItemNo; "No.") { }
                column(Line_Type; Format(Type)) { }
                // Delivery date printed on the line: the expected receipt date of the line.
                column(Line_ShipmentDate; Format("Expected Receipt Date")) { }
                column(ShipmentDate_Line_Lbl; DeliveryDateCaptionLbl) { }
                column(Line_PlannedShipmentDate; Format("Planned Receipt Date")) { }
                column(PlannedShipmentDate_Line_Lbl; FieldCaption("Planned Receipt Date")) { }
                column(Line_Quantity; Quantity) { DecimalPlaces = 0 : 5; }
                column(Type_Line; Format(Type)) { }
                column(Line_UnitPrice; "Direct Unit Cost")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                }
                column(UnitPrice_Lbl; LinePriceCaptionLbl) { }
                column(UnitOfMeasure; "Unit of Measure") { }
                column(Line_UoMCode; "Unit of Measure Code") { }
                column(Line_VATIdentifier; "VAT Identifier") { }
                column(VATPct_Line; FormattedVATPct) { }
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
                // The layout shows the UN row only when ItemUnSingle is filled.
                column(ItemUnSingle; ItemUnSingle) { }
                column(ItemADRDescr; ItemADRDescr) { }
                column(ItemADRLabel; ItemADRLabel) { }
                column(ItemADRPackingGroup; ItemADRPackingGroup) { }
                column(ItemGalleryCode; ItemGalleryCode) { }
                column(CountryOrigin; CountryOrigin) { }
                column(gLocationDesc; LocationName) { }

                // VAT exemption (declaration of intent) printed under the line (see GetLineVATExemption).
                // The layout shows the row only when VATExemptNo_CHMDocVATExemptionLink is filled.
                column(DocumentNo_CHMDocVATExemptionLink; VATExemptDocumentNo) { }
                column(LineNo_CHMDocVATExemptionLink; VATExemptLineNo) { }
                column(NoVATExemption_CHMDocVATExemptionLink; NoVATExemption) { }
                column(Source_CHMDocVATExemptionLink; VATExemptSource) { }
                column(VATExemptEndingDate_CHMDocVATExemptionLink; VATExemptEndingDate) { }
                column(VATExemptNo_CHMDocVATExemptionLink; VATExemptNo) { }
                column(VATExemptStartingDate_CHMDocVATExemptionLink; VATExemptStartingDate) { }
                column(VATExemptionType_CHMDocVATExemptionLink; VATExemptionType) { }

                // "Show Assembly Components": purchase lines have no assemble-to-order link, so the
                // components printed are those of the item's assembly BOM, for the quantity ordered.
                dataitem(AssemblyLine; "BOM Component")
                {
                    DataItemTableView = sorting("Parent Item No.", "Line No.");

                    column(LineNo_AssemblyLine; "No.") { }
                    column(Description_AssemblyLine; Description) { }
                    column(Quantity_AssemblyLine; ComponentQuantity) { DecimalPlaces = 0 : 5; }
                    column(UnitOfMeasure_AssemblyLine; GetUOMText("Unit of Measure Code")) { }
                    column(VariantCode_AssemblyLine; "Variant Code") { }

                    trigger OnPreDataItem()
                    begin
                        if not DisplayAssemblyInformation then
                            CurrReport.Break();
                        if (Line.Type <> Line.Type::Item) or (Line."No." = '') then
                            CurrReport.Break();
                        AssemblyLine.SetRange("Parent Item No.", Line."No.");
                        AssemblyLine.SetFilter(Type, '<>%1', AssemblyLine.Type::" ");
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        ComponentQuantity := AssemblyLine."Quantity per" * Line."Quantity (Base)";
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

                    FormatDocument.SetPurchaseLine(Line, FormattedQuantity, FormattedUnitPrice, FormattedVATPct, FormattedLineAmount);

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

            trigger OnAfterGetRecord()
            var
                ArchiveManagement: Codeunit ArchiveManagement;
                PurchPost: Codeunit "Purch.-Post";
            begin
                Clear(Line);
                Clear(PurchPost);
                VATAmountLine.DeleteAll();
                Line.DeleteAll();
                PurchPost.GetPurchLines(Header, Line, 0);
                Line.CalcVATAmountLines(0, Header, Line, VATAmountLine);
                Line.UpdateVATOnLines(0, Header, Line, VATAmountLine);

                if not IsReportInPreviewMode() then
                    Codeunit.Run(Codeunit::"Purch.Header-Printed", Header);

                // The report prints in the language of the vendor (Language Code on the order).
                CurrReport.FormatRegion := LanguageMgt.GetFormatRegionOrDefault(Header."Format Region");
                CurrReport.Language := LanguageMgt.GetLanguageIdOrDefault(Header."Language Code");
                FormatAddr.SetLanguageCode(Header."Language Code");

                FormatAddr.PurchHeaderBuyFrom(VendAddr, Header);
                FormatAddr.PurchHeaderShipTo(ShipToAddr, Header);
                ShowShippingAddr := ShipToAddr[1] <> '';

                if not Vendor.Get(Header."Buy-from Vendor No.") then
                    Clear(Vendor);

                SetCurrencyInfo(Header);
                FormatDocumentFields(Header);
                SetChematekHeaderFields(Header);

                CalcDocumentTotals();
                FillVATSummary();
                FillVATClauseSummary();
                FillPaymentSchedule();

                if not IsReportInPreviewMode() and
                   (CurrReport.UseRequestPage and ArchiveDocument or
                    not CurrReport.UseRequestPage and PurchSetup."Archive Orders")
                then
                    ArchiveManagement.StorePurchDocument(Header, LogInteraction);
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
                        ToolTip = 'Specifies if you want the report to include the components of the assembly BOM of the items being purchased.';
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
            ArchiveDocument := PurchSetup."Archive Orders";
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
        layout(PurchaseOrderRDLC)
        {
            Type = RDLC;
            LayoutFile = './src/report/layout/CHMPurchaseOrder.rdl';
            Caption = 'CHM Purchase Order - Text Embedded';
            Summary = 'Chematek purchase order with VAT summary, VAT clauses, dangerous goods information per line and the purchase terms printed in the layout.';
        }
    }

    // Report parameters declared in the RDLC layout. The layout no longer uses them (labels are fixed in the
    // language of the user running the report); they are kept because the layout still declares them.
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
        Line_ShipmentDate_Caption = 'Delivery Date';
        Line_Type_Descr_Caption = 'Type';
        Line_UnitPrice_Caption = 'Unit Price';
        Line_UoM_Caption = 'UoM';
        Line_VATIdentifier_Caption = 'VAT';
        NetWeightCaption = 'Net Weight';
        NoOfParcels_Caption = 'No. of Parcels';
        OperatorName_Caption = 'Operator';
        OrderConf_Title = 'Purchase Order';
        Our_Bank = 'Our Bank';
        Page_Caption = 'Page';
        PaymentMethod_Caption = 'Payment Method';
        PaymentTerms_Caption = 'Payment Terms';
        Reason_Caption = 'Reason';
        ReturnAddr_Caption = 'Return Address';
        Salesperson_Caption = 'Purchaser';
        ShipmentDate_Caption = 'Delivery Date';
        ShipToAddress_Caption = 'Delivery Address';
        ShpAgent_Caption = 'Shipping Agent';
        ShptMethod_Caption = 'Shipment Method';
        ShptStart_Caption = 'Shipment Start';
        Total_DocumentTotalVatExclCaption = 'Total Excl. VAT';
        ValidTo_Caption = 'Valid To';
        VATClausesCaption = 'VAT Clauses';
        VATRegNo_Caption = 'VAT Reg. No.';
        Volume_Caption = 'Volume';
        YourReference_Caption = 'Your Reference';
        TariffNoLbl = 'Tariff No.';
        CountryOfOriginLbl = 'Country of Origin';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
        PurchSetup.Get();
    end;

    trigger OnPreReport()
    begin
        if Header.GetFilters() = '' then
            Error(NoFilterSetErr);

        // Only purchase orders are printed, whatever the visible filters are.
        Header.FilterGroup(10);
        Header.SetRange("Document Type", Header."Document Type"::Order);
        Header.FilterGroup(0);

        if not CurrReport.UseRequestPage then
            InitLogInteraction();

        LoadDocumentLogos();
    end;

    trigger OnPostReport()
    begin
        if LogInteraction and not IsReportInPreviewMode() then
            if Header.FindSet() then
                repeat
                    Header.CalcFields("No. of Archived Versions");
                    if Header."Buy-from Contact No." <> '' then
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Purch. Ord.".AsInteger(), Header."No.", Header."Doc. No. Occurrence",
                          Header."No. of Archived Versions", Database::Contact, Header."Buy-from Contact No.",
                          Header."Purchaser Code", '', Header."Posting Description", '')
                    else
                        SegManagement.LogDocument(
                          Enum::"Interaction Log Entry Document Type"::"Purch. Ord.".AsInteger(), Header."No.", Header."Doc. No. Occurrence",
                          Header."No. of Archived Versions", Database::Vendor, Header."Buy-from Vendor No.",
                          Header."Purchaser Code", '', Header."Posting Description", '');
                until Header.Next() = 0;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CompanyInfo: Record "Company Information";
        CHMSetup: Record "CHM Customizations Setup";
        Vendor: Record Vendor;
        VATClause: Record "VAT Clause";
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
        ShowShippingAddr: Boolean;
        MoreLines: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        CalculatedExchRate: Decimal;
        ComponentQuantity: Decimal;
        ExchangeRateText: Text;
        PmtDiscText: Text;
        CurrCode: Text[10];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        TotalVATAmountText: Text[30];
        PurchaserText: Text[50];
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
        VATRegistrationNo: Text;
        ContactEmail: Text;
        DocumentNoteText: Text;
        ShowIso: Boolean;

        // Line item / dangerous goods fields
        ItemHazardousDescr: Text;
        Hazardous: Boolean;
        TariffNo: Text;
        ADRClass: Text;
        ItemUN: Text;
        ItemUnSingle: Text;
        ItemADRDescr: Text;
        ItemADRLabel: Text;
        ItemADRPackingGroup: Text;
        ItemGalleryCode: Text;
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

        // Fixed slots used by the layout
        VATSlotCode: array[4] of Code[20];
        VATSlotDescription: array[4] of Text;
        VATSlotPct: array[4] of Decimal;
        VATSlotBase: array[4] of Decimal;
        VATSlotAmount: array[4] of Decimal;
        VATClauseSlotCode: array[4] of Code[20];
        VATClauseSlotDescription: array[4] of Text;
        ShowVATClauseTab: Boolean;
        DueDateSlot: array[4] of Text;
        DueAmountSlot: array[4] of Decimal;

        // Captions
        PurchaseOrderCaptionLbl: Label 'Purchase Order';
        QuoteNoCaptionLbl: Label 'Quote No.';
        ShipToAddressCaptionLbl: Label 'Delivery Address';
        DocumentNoCaptionLbl: Label 'No.';
        DateCaptionLbl: Label 'Date';
        OrderDateCaptionLbl: Label 'Order Date';
        PostingDateCaptionLbl: Label 'Posting Date';
        ReasonCaptionLbl: Label 'Reason';
        VendorNoCaptionLbl: Label 'Vendor No.';
        VendorCaptionLbl: Label 'Vendor';
        DocNoCaptionLbl: Label 'Document No.';
        EMailCaptionLbl: Label 'E-Mail';
        VATCaptionLbl: Label 'VAT';
        VATClausesCaptionLbl: Label 'VAT Clauses';
        ContactCaptionLbl: Label 'Contact';
        ContactEmailCaptionLbl: Label 'Contact E-Mail';
        VATRegNoCaptionLbl: Label 'VAT Reg. No.';
        FiscalCodeCaptionLbl: Label 'Fiscal Code';
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        PaymentMethodCaptionLbl: Label 'Payment Method';
        PurchaserCaptionLbl: Label 'Purchaser';
        OperatorCaptionLbl: Label 'Operator';
        ShippingAgentCaptionLbl: Label 'Shipping Agent';
        YourReferenceCaptionLbl: Label 'Your Reference';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        LocationCaptionLbl: Label 'Location';
        NetAmountToPayCaptionLbl: Label 'Net Amount to Pay';
        TotalVATCaptionLbl: Label 'Total VAT';
        TaxableAmountCaptionLbl: Label 'Taxable Amount';
        DocumentTotalCaptionLbl: Label 'Document Total';
        VATCodeCaptionLbl: Label 'VAT Code';
        VATDescriptionCaptionLbl: Label 'VAT Description';
        PaymentAmountCaptionLbl: Label 'Amount Due';
        DueDateCaptionLbl: Label 'Due Date';
        LineTypeCaptionLbl: Label 'Type';
        LineNoCaptionLbl: Label 'Item No.';
        LineDescriptionCaptionLbl: Label 'Description';
        LineQuantityCaptionLbl: Label 'Quantity';
        LineUoMCaptionLbl: Label 'UoM';
        LinePriceCaptionLbl: Label 'Unit Price';
        LineDiscPctCaptionLbl: Label 'Disc. %';
        LineAmountCaptionLbl: Label 'Amount';
        AmountInclVATCaptionLbl: Label 'Amount Including VAT';
        DeliveryDateCaptionLbl: Label 'Delivery Date';
        LotNoCaptionLbl: Label 'Lot No.';
        CountryOfOriginCaptionLbl: Label 'Country of Origin:';
        TariffNoCaptionLbl: Label 'Tariff No.:';
        UNNoCaptionLbl: Label 'UN No.:';
        ADRClassCaptionLbl: Label 'ADR Class:';
        QtyLbl: Label 'Qty';
        PriceLbl: Label 'Price';
        PricePerLbl: Label 'Price per';
        UnitLbl: Label 'Unit';

        // Purchase terms printed under the lines
        ShelfLifeClauseLbl: Label 'All supplied chemical products must have a minimum of two-thirds (2/3) of their original shelf life remaining at the time of delivery, unless otherwise agreed, and the Certificate of Analysis (CoA) must be approved by the buyer.';
        TermsAcceptanceLbl: Label 'Acceptance of this Purchase Order constitutes acceptance of the Terms and Conditions attached.';

        // Standard report texts
        CopyLbl: Label 'Copy';
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
        VATIdentifierLbl: Label 'VAT Identifier';
        VATPercentageLbl: Label 'VAT %';
        GreetingLbl: Label 'Hello';
        ClosingLbl: Label 'Sincerely';
        BodyLbl: Label 'Please find attached our purchase order.';
        PmtDiscTxt: Label 'If we pay before %1, we are eligible for a %2% payment discount.', Comment = '%1 = Discount Due Date %2 = value of Payment Discount % ';
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';
        LCYTxt: Label ' (LCY)';
        LineDiscountPctTok: Label '%1%', Locked = true;
        ShippingAgentCodeFieldTok: Label 'Shipping Agent Code', Locked = true;
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
        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Purch. Ord.") <> '';
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(CurrReport.Preview() or MailManagement.IsHandlingGetEmailBody());
    end;

    local procedure SetCurrencyInfo(PurchHeader: Record "Purchase Header")
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        ExchangeRateText := '';
        if PurchHeader."Currency Code" <> '' then begin
            CurrencyExchangeRate.FindCurrency(PurchHeader."Posting Date", PurchHeader."Currency Code", 1);
            CalculatedExchRate :=
              Round(1 / PurchHeader."Currency Factor" * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
            ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
            CurrCode := PurchHeader."Currency Code";
        end else
            CurrCode := GLSetup."LCY Code";
    end;

    local procedure FormatDocumentFields(PurchHeader: Record "Purchase Header")
    begin
        FormatDocument.SetTotalLabels(PurchHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetPurchaser(SalespersonPurchaser, PurchHeader."Purchaser Code", PurchaserText);
        FormatDocument.SetPaymentTerms(PaymentTerms, PurchHeader."Payment Terms Code", PurchHeader."Language Code");
        FormatDocument.SetPaymentMethod(PaymentMethod, PurchHeader."Payment Method Code", PurchHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, PurchHeader."Shipment Method Code", PurchHeader."Language Code");
    end;

    local procedure SetChematekHeaderFields(PurchHeader: Record "Purchase Header")
    var
        Location: Record Location;
        ReasonCode: Record "Reason Code";
        Contact: Record Contact;
    begin
        // Operator: the user assigned to the order, otherwise the user printing it.
        if PurchHeader."Assigned User ID" <> '' then
            OperatorName := GetUserFullName(PurchHeader."Assigned User ID")
        else
            OperatorName := GetUserFullName(CopyStr(UserId(), 1, 50));

        // Receiving location of the order.
        LocationName := '';
        LocationAddress := '';
        LocationCity := '';
        if PurchHeader."Location Code" <> '' then
            if Location.Get(PurchHeader."Location Code") then begin
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
        ReasonCodeText := PurchHeader."Reason Code";
        if PurchHeader."Reason Code" <> '' then
            if ReasonCode.Get(PurchHeader."Reason Code") then
                if ReasonCode.Description <> '' then
                    ReasonCodeText := ReasonCode.Description;

        // Vendor VAT registration no.: from the order, otherwise from the vendor card.
        VATRegistrationNo := PurchHeader."VAT Registration No.";
        if VATRegistrationNo = '' then
            VATRegistrationNo := Vendor."VAT Registration No.";

        // Contact e-mail: buy-from contact, otherwise the vendor e-mail.
        ContactEmail := '';
        if PurchHeader."Buy-from Contact No." <> '' then
            if Contact.Get(PurchHeader."Buy-from Contact No.") then
                ContactEmail := Contact."E-Mail";
        if ContactEmail = '' then
            ContactEmail := Vendor."E-Mail";

        ShippingAgentName := GetShippingAgentName(PurchHeader);
        FiscalCodeNo := GetVendorFiscalCode(PurchHeader."Buy-from Vendor No.");
        DocumentNoteText := GetDocumentNote(PurchHeader);
    end;

    local procedure GetShippingAgentName(PurchHeader: Record "Purchase Header"): Text
    var
        ShippingAgent: Record "Shipping Agent";
        FieldRec: Record Field;
        RecRef: RecordRef;
        ShippingAgentCode: Code[10];
    begin
        // The W1 Purchase Header has no Shipping Agent; the Italian localization adds "Shipping Agent Code".
        // The field is read by name, so the report compiles and runs on both versions and prints the
        // shipping agent automatically where the field exists. Prints the agent name, else the code.
        FieldRec.SetRange(TableNo, Database::"Purchase Header");
        FieldRec.SetRange(FieldName, ShippingAgentCodeFieldTok);
        FieldRec.SetRange(Class, FieldRec.Class::Normal);
        FieldRec.SetFilter(ObsoleteState, '<>%1', FieldRec.ObsoleteState::Removed);
        if not FieldRec.FindFirst() then
            exit('');

        RecRef.GetTable(PurchHeader);
        ShippingAgentCode := CopyStr(Format(RecRef.Field(FieldRec."No.").Value()), 1, MaxStrLen(ShippingAgentCode));
        if ShippingAgentCode = '' then
            exit('');
        if ShippingAgent.Get(ShippingAgentCode) then
            if ShippingAgent.Name <> '' then
                exit(ShippingAgent.Name);
        exit(ShippingAgentCode);
    end;

    local procedure GetVendorFiscalCode(VendorNo: Code[20]): Text
    begin
        // TODO (pending decision): standard BC has no Fiscal Code (Codice Fiscale) on the vendor.
        // Return it from the agreed source for VendorNo, e.g. a Vendor table extension field.
        exit('');
    end;

    local procedure GetDocumentNote(PurchHeader: Record "Purchase Header"): Text
    begin
        // TODO (pending decision): note printed in the page footer (DescrLav). The sales reports print the
        // Work Description, which the Purchase Header does not have. Return the agreed text here.
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

    local procedure CalcDocumentTotals()
    var
        TempPurchLineCalc: Record "Purchase Line" temporary;
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

        TempPurchLineCalc.Copy(Line, true);
        TempPurchLineCalc.Reset();
        if TempPurchLineCalc.FindSet() then
            repeat
                TotalSubTotal += TempPurchLineCalc."Line Amount";
                TotalInvDiscAmount -= TempPurchLineCalc."Inv. Discount Amount";
                TotalAmount += TempPurchLineCalc.Amount;
                TotalAmountVAT += TempPurchLineCalc."Amount Including VAT" - TempPurchLineCalc.Amount;
                TotalAmountInclVAT += TempPurchLineCalc."Amount Including VAT";
                TotalPaymentDiscOnVAT += -(TempPurchLineCalc."Line Amount" - TempPurchLineCalc."Inv. Discount Amount" - TempPurchLineCalc."Amount Including VAT");
            until TempPurchLineCalc.Next() = 0;

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

    local procedure GetLineItemInfo(PurchLine: Record "Purchase Line")
    var
        Item: Record Item;
        CountryRegion: Record "Country/Region";
    begin
        Hazardous := false;
        ItemHazardousDescr := '';
        ADRClass := '';
        ItemUN := '';
        ItemUnSingle := '';
        ItemADRDescr := '';
        ItemADRLabel := '';
        ItemADRPackingGroup := '';
        ItemGalleryCode := '';
        TariffNo := '';
        CountryOrigin := '';

        if PurchLine.Type <> PurchLine.Type::Item then
            exit;
        if not Item.Get(PurchLine."No.") then
            exit;

        TariffNo := Item."Tariff No.";
        if Item."Country/Region of Origin Code" <> '' then begin
            CountryOrigin := Item."Country/Region of Origin Code";
            if CountryRegion.Get(Item."Country/Region of Origin Code") then
                if CountryRegion.Name <> '' then
                    CountryOrigin := CountryRegion.Name;
        end;

        GetItemDangerousGoodsInfo(Item);
        // The layout shows the UN row when ItemUnSingle is filled and prints ItemUN.
        ItemUnSingle := ItemUN;
    end;

    local procedure GetItemDangerousGoodsInfo(Item: Record Item)
    begin
        // TODO (pending decision): standard BC has no dangerous goods fields on the item.
        // Fill Hazardous, ItemHazardousDescr, ADRClass, ItemUN, ItemADRDescr, ItemADRLabel,
        // ItemADRPackingGroup and ItemGalleryCode from the agreed source (same as the sales reports).
        // Until then the hazardous / ADR / UN rows are not printed.
    end;

    local procedure GetLineVATExemption(PurchLine: Record "Purchase Line")
    begin
        VATExemptDocumentNo := '';
        VATExemptLineNo := 0;
        NoVATExemption := false;
        VATExemptSource := '';
        VATExemptStartingDate := '';
        VATExemptEndingDate := '';
        VATExemptNo := '';
        VATExemptionType := '';

        // TODO (pending decision): fill these from the agreed source for PurchLine (e.g. the declaration
        // of intent issued to the vendor). Until then the VAT exemption row under the line is not printed.
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
