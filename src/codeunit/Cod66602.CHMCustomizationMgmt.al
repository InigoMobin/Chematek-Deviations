codeunit 66602 "CHM Customization Mgmt."
{
    var
        VATExemptionTableTok: Label 'VAT Exemption', Locked = true;
        VATExemptTypeFieldTok: Label 'Type', Locked = true;
        VATExemptAccountNoFieldTok: Label 'No.', Locked = true;
        VATExemptStartingDateFieldTok: Label 'VAT Exempt. Starting Date', Locked = true;
        VATExemptEndingDateFieldTok: Label 'VAT Exempt. Ending Date', Locked = true;
        VATExemptNoFieldTok: Label 'VAT Exempt. No.', Locked = true;
        VATExemptDateFieldTok: Label 'VAT Exempt. Date', Locked = true;
        VATExemptRegistryNoFieldTok: Label 'VAT Exempt. Int. Registry No.', Locked = true;
        DeclarationOfIntentTxt: Label 'Declaration of intent no. %1 of %2', Comment = '%1 = VAT Exempt. No., %2 = VAT Exempt. Date';
        DeclarationOfIntentNoDateTxt: Label 'Declaration of intent no. %1', Comment = '%1 = VAT Exempt. No.';
        ShippingAgentCodeFieldTok: Label 'Shipping Agent Code', Locked = true;
        TransportStartTimeFormatTok: Label '<Hours24,2>:<Minutes,2>', Locked = true;
        DateTimeTok: Label '%1 %2', Locked = true;
        BankAccountIBANTok: Label '%1 - %2', Locked = true;
        Code39CharsTok: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-. $/+%', Locked = true;
        ExchangeRateTxt: Label 'Exchange rate: %1/%2', Comment = '%1 and %2 are both amounts.';
        FullyAppliedLbl: Label 'The credit memo has been fully applied.';
        ProductionDateMismatchErr: Label 'Lot %1 of item %2 already has Production Date %3. To change it, update the Lot No. Information Card.', Comment = '%1 = Lot No., %2 = Item No., %3 = Production Date';
        PartiallyAppliedLbl: Label 'The credit memo has been partially applied. The remaining amount is %1', Comment = '%1 = an amount';

    /// <summary>
    /// Returns the Fiscal Code of the customer (Italian localization field), or blank when the customer does not exist.
    /// </summary>
    procedure GetCustomerFiscalCode(CustomerNo: Code[20]): Text
    var
        Customer: Record Customer;
    begin
        if CustomerNo = '' then
            exit('');
        Customer.SetLoadFields("Fiscal Code");
        if not Customer.Get(CustomerNo) then
            exit('');
        exit(Customer."Fiscal Code");
    end;

    /// <summary>
    /// Returns the Fiscal Code of the vendor (Italian localization field), or blank when the vendor does not exist.
    /// </summary>
    procedure GetVendorFiscalCode(VendorNo: Code[20]): Text
    var
        Vendor: Record Vendor;
    begin
        if VendorNo = '' then
            exit('');
        Vendor.SetLoadFields("Fiscal Code");
        if not Vendor.Get(VendorNo) then
            exit('');
        exit(Vendor."Fiscal Code");
    end;

    /// <summary>
    /// Finds the declaration of intent received from the customer that is valid on the given date.
    /// </summary>
    procedure FindCustomerVATExemption(CustomerNo: Code[20]; OnDate: Date; var DeclarationText: Text; var StartingDate: Date; var EndingDate: Date; var RegistryNo: Text): Boolean
    begin
        exit(FindVATExemption(0, CustomerNo, OnDate, DeclarationText, StartingDate, EndingDate, RegistryNo));
    end;

    /// <summary>
    /// Finds the declaration of intent issued to the vendor that is valid on the given date.
    /// </summary>
    procedure FindVendorVATExemption(VendorNo: Code[20]; OnDate: Date; var DeclarationText: Text; var StartingDate: Date; var EndingDate: Date; var RegistryNo: Text): Boolean
    begin
        exit(FindVATExemption(1, VendorNo, OnDate, DeclarationText, StartingDate, EndingDate, RegistryNo));
    end;

    /// <summary>
    /// Reads the Italian "VAT Exemption" table by field name and returns the most recent declaration of intent valid on the given date.
    /// </summary>
    local procedure FindVATExemption(TypeOption: Integer; AccountNo: Code[20]; OnDate: Date; var DeclarationText: Text; var StartingDate: Date; var EndingDate: Date; var RegistryNo: Text): Boolean
    var
        AllObj: Record AllObj;
        RecRef: RecordRef;
        FldRef: FieldRef;
        TypeFldNo: Integer;
        AccountNoFldNo: Integer;
        StartingDateFldNo: Integer;
        EndingDateFldNo: Integer;
        ExemptNoFldNo: Integer;
        ExemptDateFldNo: Integer;
        RegistryNoFldNo: Integer;
        RecStartingDate: Date;
        ExemptNo: Text;
        ExemptDate: Date;
        Found: Boolean;
    begin
        DeclarationText := '';
        StartingDate := 0D;
        EndingDate := 0D;
        RegistryNo := '';
        if (AccountNo = '') or (OnDate = 0D) then
            exit(false);

        if not AllObj.Get(AllObj."Object Type"::Table, VATExemptionTableNo()) then
            exit(false);
        if AllObj."Object Name" <> VATExemptionTableTok then
            exit(false);

        TypeFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptTypeFieldTok);
        AccountNoFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptAccountNoFieldTok);
        StartingDateFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptStartingDateFieldTok);
        EndingDateFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptEndingDateFieldTok);
        ExemptNoFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptNoFieldTok);
        ExemptDateFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptDateFieldTok);
        RegistryNoFldNo := FindFieldNo(VATExemptionTableNo(), VATExemptRegistryNoFieldTok);
        if (TypeFldNo = 0) or (AccountNoFldNo = 0) or (StartingDateFldNo = 0) or (EndingDateFldNo = 0) or
           (ExemptNoFldNo = 0) or (ExemptDateFldNo = 0) or (RegistryNoFldNo = 0)
        then
            exit(false);

        RecRef.Open(VATExemptionTableNo());
        FldRef := RecRef.Field(TypeFldNo);
        FldRef.SetRange(TypeOption);
        FldRef := RecRef.Field(AccountNoFldNo);
        FldRef.SetRange(AccountNo);
        FldRef := RecRef.Field(StartingDateFldNo);
        FldRef.SetFilter('..%1', OnDate);
        FldRef := RecRef.Field(EndingDateFldNo);
        FldRef.SetFilter('%1|>=%2', 0D, OnDate);
        if RecRef.FindSet() then
            repeat
                RecStartingDate := RecRef.Field(StartingDateFldNo).Value();
                if (not Found) or (RecStartingDate > StartingDate) then begin
                    Found := true;
                    StartingDate := RecStartingDate;
                    EndingDate := RecRef.Field(EndingDateFldNo).Value();
                    ExemptNo := DelChr(Format(RecRef.Field(ExemptNoFldNo).Value()), '<>', ' ');
                    ExemptDate := RecRef.Field(ExemptDateFldNo).Value();
                    RegistryNo := DelChr(Format(RecRef.Field(RegistryNoFldNo).Value()), '<>', ' ');
                end;
            until RecRef.Next() = 0;
        RecRef.Close();

        if not Found then
            exit(false);

        if ExemptNo = '' then
            ExemptNo := RegistryNo;
        if ExemptNo = '' then
            exit(false);
        if ExemptDate <> 0D then
            DeclarationText := StrSubstNo(DeclarationOfIntentTxt, ExemptNo, Format(ExemptDate))
        else
            DeclarationText := StrSubstNo(DeclarationOfIntentNoDateTxt, ExemptNo);
        exit(true);
    end;

    /// <summary>
    /// Returns the ID of the Italian "VAT Exemption" table.
    /// </summary>
    local procedure VATExemptionTableNo(): Integer
    begin
        exit(12186);
    end;

    /// <summary>
    /// Returns the value of a field found by its name as text, or blank when the table has no such field.
    /// </summary>
    procedure GetFieldValueByName(RecVariant: Variant; TableNo: Integer; FieldName: Text): Text
    var
        RecRef: RecordRef;
        FieldNo: Integer;
    begin
        FieldNo := FindFieldNo(TableNo, FieldName);
        if FieldNo = 0 then
            exit('');

        RecRef.GetTable(RecVariant);
        exit(DelChr(Format(RecRef.Field(FieldNo).Value()), '<>', ' '));
    end;

    /// <summary>
    /// Returns the number of the field with the given name, or 0 when the table has no such field.
    /// </summary>
    procedure FindFieldNo(TableNo: Integer; FieldName: Text): Integer
    var
        FieldRec: Record Field;
    begin
        FieldRec.SetRange(TableNo, TableNo);
        FieldRec.SetRange(FieldName, FieldName);
        FieldRec.SetRange(Class, FieldRec.Class::Normal);
        FieldRec.SetFilter(ObsoleteState, '<>%1', FieldRec.ObsoleteState::Removed);
        if not FieldRec.FindFirst() then
            exit(0);
        exit(FieldRec."No.");
    end;

    /// <summary>
    /// Returns true when the report runs in preview or to build an e-mail body.
    /// </summary>
    procedure IsDocumentPreview(IsReportPreview: Boolean): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        exit(IsReportPreview or MailManagement.IsHandlingGetEmailBody());
    end;

    /// <summary>
    /// Returns true when an interaction template is set up for the document type, so the interaction can be logged.
    /// </summary>
    procedure InteractionTemplateExists(DocumentType: Enum "Interaction Log Entry Document Type"): Boolean
    var
        SegManagement: Codeunit SegManagement;
    begin
        exit(SegManagement.FindInteractionTemplateCode(DocumentType) <> '');
    end;

    /// <summary>
    /// Reads the Chematek Customizations Setup, including the logos printed on the document reports.
    /// </summary>
    procedure GetDocumentSetup(var CHMSetup: Record "CHM Customizations Setup")
    begin
        CHMSetup.SetAutoCalcFields("Right Header Logo", "Footer Logo", "ISO 9001 Logo", "ASSICC Logo");
        if not CHMSetup.Get() then
            CHMSetup.Init();
    end;

    /// <summary>
    /// Returns the currency code printed on the document and the exchange rate text.
    /// </summary>
    procedure GetCurrencyInfo(CurrencyCode: Code[10]; PostingDate: Date; CurrencyFactor: Decimal; var CurrCode: Text[10]; var ExchangeRateText: Text; var CalculatedExchRate: Decimal)
    var
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        ExchangeRateText := '';
        if CurrencyCode <> '' then begin
            CurrencyExchangeRate.FindCurrency(PostingDate, CurrencyCode, 1);
            CalculatedExchRate :=
              Round(1 / CurrencyFactor * CurrencyExchangeRate."Exchange Rate Amount", 0.000001);
            ExchangeRateText := StrSubstNo(ExchangeRateTxt, CalculatedExchRate, CurrencyExchangeRate."Exchange Rate Amount");
            CurrCode := CurrencyCode;
        end else begin
            GLSetup.Get();
            CurrCode := GLSetup."LCY Code";
        end;
    end;

    /// <summary>
    /// Returns the full name of the user, or the user name when the full name is blank.
    /// </summary>
    procedure GetUserFullName(UserName: Code[50]): Text
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

    /// <summary>
    /// Returns the operator printed on the document: the assigned user, otherwise the user who prints it.
    /// </summary>
    procedure GetOperatorName(AssignedUserID: Code[50]): Text
    begin
        if AssignedUserID <> '' then
            exit(GetUserFullName(AssignedUserID));
        exit(GetUserFullName(CopyStr(UserId(), 1, 50)));
    end;

    /// <summary>
    /// Returns the name, address and city (post code, city and county) of the location.
    /// </summary>
    procedure GetLocationAddress(LocationCode: Code[10]; var LocationName: Text; var LocationAddress: Text; var LocationCity: Text)
    var
        Location: Record Location;
    begin
        LocationName := '';
        LocationAddress := '';
        LocationCity := '';
        if LocationCode = '' then
            exit;
        if not Location.Get(LocationCode) then
            exit;
        LocationName := Location.Name;
        LocationAddress := Location.Address;
        if Location."Address 2" <> '' then
            LocationAddress += ' ' + Location."Address 2";
        LocationCity := DelChr(Location."Post Code" + ' ' + Location.City, '<>', ' ');
        if Location.County <> '' then
            LocationCity += ' (' + Location.County + ')';
    end;

    /// <summary>
    /// Returns the full address of the location on a single line.
    /// </summary>
    procedure GetLocationAddressLine(LocationCode: Code[10]) Result: Text
    var
        Location: Record Location;
        CityText: Text;
    begin
        if LocationCode = '' then
            exit('');
        if not Location.Get(LocationCode) then
            exit('');
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

    /// <summary>
    /// Returns the description of the reason code, or the code when the description is blank.
    /// </summary>
    procedure GetReasonCodeText(ReasonCode: Code[10]): Text
    var
        ReasonCodeRec: Record "Reason Code";
    begin
        if ReasonCode = '' then
            exit('');
        if ReasonCodeRec.Get(ReasonCode) then
            if ReasonCodeRec.Description <> '' then
                exit(ReasonCodeRec.Description);
        exit(ReasonCode);
    end;

    /// <summary>
    /// Returns the name of the shipping agent, or the code when the name is blank.
    /// </summary>
    procedure GetShippingAgentName(ShippingAgentCode: Code[10]): Text
    var
        ShippingAgent: Record "Shipping Agent";
    begin
        if ShippingAgentCode = '' then
            exit('');
        if ShippingAgent.Get(ShippingAgentCode) then
            if ShippingAgent.Name <> '' then
                exit(ShippingAgent.Name);
        exit(ShippingAgentCode);
    end;

    /// <summary>
    /// Returns the shipping agent name of a document where "Shipping Agent Code" exists only in the Italian localization (read by field name).
    /// </summary>
    procedure GetShippingAgentNameByField(RecVariant: Variant; TableNo: Integer): Text
    var
        ShippingAgentCode: Code[10];
    begin
        ShippingAgentCode := CopyStr(GetFieldValueByName(RecVariant, TableNo, ShippingAgentCodeFieldTok), 1, MaxStrLen(ShippingAgentCode));
        exit(GetShippingAgentName(ShippingAgentCode));
    end;

    /// <summary>
    /// Returns the IBAN of the preferred bank account of the customer.
    /// </summary>
    procedure GetCustomerBankAccountIBAN(CustomerNo: Code[20]): Text
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        if not Customer.Get(CustomerNo) then
            exit('');
        if Customer."Preferred Bank Account Code" = '' then
            exit('');
        if not CustomerBankAccount.Get(Customer."No.", Customer."Preferred Bank Account Code") then
            exit('');
        exit(CustomerBankAccount.IBAN);
    end;

    /// <summary>
    /// Returns the bank name followed by the IBAN, printed under "Our Bank".
    /// </summary>
    procedure GetBankAccountText(BankAccount: Record "Bank Account"): Text
    begin
        if BankAccount.IBAN = '' then
            exit(BankAccount.Name);
        if BankAccount.Name = '' then
            exit(BankAccount.IBAN);
        exit(StrSubstNo(BankAccountIBANTok, BankAccount.Name, BankAccount.IBAN));
    end;

    /// <summary>
    /// Returns the remaining amount of the posted credit memo and the "fully / partially applied" text.
    /// </summary>
    procedure GetCrMemoRemainingAmount(CrMemoNo: Code[20]; CustomerNo: Code[20]; var RemainingAmount: Decimal; var RemainingAmountTxt: Text)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        RemainingAmount := 0;
        RemainingAmountTxt := '';

        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::"Credit Memo");
        CustLedgerEntry.SetRange("Document No.", CrMemoNo);
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
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

    /// <summary>
    /// Loads the additional fee notes of the posted document in the customer language, or in the user language when none exist.
    /// </summary>
    procedure GetLineFeeNotes(DocumentType: Enum "Gen. Journal Document Type"; DocumentNo: Code[20]; var TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary)
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        LanguageMgt: Codeunit Language;
    begin
        TempLineFeeNoteOnReportHist.DeleteAll();
        CustLedgerEntry.SetRange("Document Type", DocumentType);
        CustLedgerEntry.SetRange("Document No.", DocumentNo);
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

    /// <summary>
    /// Adds a name / value row to the buffer used by the header blocks of the layout. Blank values are skipped.
    /// </summary>
    procedure FillNameValueTable(var NameValueBuffer: Record "Name/Value Buffer"; Name: Text; Value: Text)
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

    /// <summary>
    /// Returns true when the two formatted addresses are identical.
    /// </summary>
    procedure AddressesAreEqual(FirstAddr: array[8] of Text[100]; SecondAddr: array[8] of Text[100]): Boolean
    var
        i: Integer;
    begin
        for i := 1 to ArrayLen(FirstAddr) do
            if FirstAddr[i] <> SecondAddr[i] then
                exit(false);
        exit(true);
    end;

    /// <summary>
    /// Returns the VAT Posting Setup description of the VAT identifier, or the identifier when the description is blank.
    /// </summary>
    procedure GetVATDescription(VATBusPostingGroup: Code[20]; VATIdentifier: Code[20]): Text
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.SetRange("VAT Bus. Posting Group", VATBusPostingGroup);
        VATPostingSetup.SetRange("VAT Identifier", VATIdentifier);
        if VATPostingSetup.FindFirst() then
            if VATPostingSetup.Description <> '' then
                exit(VATPostingSetup.Description);
        exit(VATIdentifier);
    end;

    /// <summary>
    /// Fills the 4 fixed VAT summary slots of the layout from the VAT amount lines.
    /// </summary>
    procedure FillVATSlots(var TempVATAmountLine: Record "VAT Amount Line" temporary; VATBusPostingGroup: Code[20]; var VATSlotCode: array[4] of Code[20]; var VATSlotDescription: array[4] of Text; var VATSlotPct: array[4] of Decimal; var VATSlotBase: array[4] of Decimal; var VATSlotAmount: array[4] of Decimal)
    var
        VATSlotDiscount: array[4] of Decimal;
    begin
        FillVATSlots(TempVATAmountLine, VATBusPostingGroup, VATSlotCode, VATSlotDescription, VATSlotPct, VATSlotBase, VATSlotAmount, VATSlotDiscount);
    end;

    /// <summary>
    /// Fills the 4 fixed VAT summary slots of the layout from the VAT amount lines, including the invoice discount per VAT rate.
    /// </summary>
    procedure FillVATSlots(var TempVATAmountLine: Record "VAT Amount Line" temporary; VATBusPostingGroup: Code[20]; var VATSlotCode: array[4] of Code[20]; var VATSlotDescription: array[4] of Text; var VATSlotPct: array[4] of Decimal; var VATSlotBase: array[4] of Decimal; var VATSlotAmount: array[4] of Decimal; var VATSlotDiscount: array[4] of Decimal)
    var
        TempVATAmountLineCalc: Record "VAT Amount Line" temporary;
        SlotNo: Integer;
    begin
        Clear(VATSlotCode);
        Clear(VATSlotDescription);
        Clear(VATSlotPct);
        Clear(VATSlotBase);
        Clear(VATSlotAmount);
        Clear(VATSlotDiscount);

        TempVATAmountLineCalc.Copy(TempVATAmountLine, true);
        TempVATAmountLineCalc.Reset();
        if TempVATAmountLineCalc.FindSet() then
            repeat
                SlotNo += 1;
                if SlotNo <= ArrayLen(VATSlotCode) then begin
                    VATSlotCode[SlotNo] := TempVATAmountLineCalc."VAT Identifier";
                    VATSlotDescription[SlotNo] := GetVATDescription(VATBusPostingGroup, TempVATAmountLineCalc."VAT Identifier");
                    VATSlotPct[SlotNo] := TempVATAmountLineCalc."VAT %";
                    VATSlotBase[SlotNo] := TempVATAmountLineCalc."VAT Base";
                    VATSlotAmount[SlotNo] := TempVATAmountLineCalc."VAT Amount";
                    VATSlotDiscount[SlotNo] := TempVATAmountLineCalc."Invoice Discount Amount";
                end;
            until TempVATAmountLineCalc.Next() = 0;
    end;

    /// <summary>
    /// Fills the 4 fixed VAT clause slots of the layout. Returns true when at least one VAT clause is printed.
    /// </summary>
    procedure FillVATClauseSlots(var TempVATAmountLine: Record "VAT Amount Line" temporary; DocumentHeader: Variant; var VATClauseSlotCode: array[4] of Code[20]; var VATClauseSlotDescription: array[4] of Text): Boolean
    var
        TempVATAmountLineCalc: Record "VAT Amount Line" temporary;
        VATClause: Record "VAT Clause";
        SlotNo: Integer;
        i: Integer;
        AlreadyAdded: Boolean;
    begin
        Clear(VATClauseSlotCode);
        Clear(VATClauseSlotDescription);

        TempVATAmountLineCalc.Copy(TempVATAmountLine, true);
        TempVATAmountLineCalc.Reset();
        TempVATAmountLineCalc.SetFilter("VAT Clause Code", '<>%1', '');
        if TempVATAmountLineCalc.FindSet() then
            repeat
                AlreadyAdded := false;
                for i := 1 to SlotNo do
                    if VATClauseSlotCode[i] = TempVATAmountLineCalc."VAT Clause Code" then
                        AlreadyAdded := true;
                if not AlreadyAdded and (SlotNo < ArrayLen(VATClauseSlotCode)) then
                    if VATClause.Get(TempVATAmountLineCalc."VAT Clause Code") then begin
                        SlotNo += 1;
                        VATClauseSlotCode[SlotNo] := VATClause.Code;
                        VATClauseSlotDescription[SlotNo] := VATClause.GetDescriptionText(DocumentHeader);
                    end;
            until TempVATAmountLineCalc.Next() = 0;

        exit(SlotNo > 0);
    end;

    /// <summary>
    /// Fills the due date / amount slots of the layout. Standard BC has one due date per document, so only the first slot is used.
    /// </summary>
    procedure FillPaymentSchedule(DueDate: Date; AmountInclVAT: Decimal; var DueDateSlot: array[4] of Text; var DueAmountSlot: array[4] of Decimal)
    begin
        Clear(DueDateSlot);
        Clear(DueAmountSlot);
        if AmountInclVAT = 0 then
            exit;
        DueDateSlot[1] := Format(DueDate);
        DueAmountSlot[1] := AmountInclVAT;
    end;

    /// <summary>
    /// Returns the date used to find the declaration of intent: the posting date, else the document date, else the work date.
    /// </summary>
    procedure GetVATExemptionDate(PostingDate: Date; DocumentDate: Date): Date
    begin
        if PostingDate <> 0D then
            exit(PostingDate);
        if DocumentDate <> 0D then
            exit(DocumentDate);
        exit(WorkDate());
    end;

    /// <summary>
    /// Returns the declaration of intent of the customer printed under a document line without VAT.
    /// </summary>
    procedure GetCustomerLineVATExemption(IsVATExemptLine: Boolean; CustomerNo: Code[20]; OnDate: Date; var VATExemptNo: Text; var VATExemptSource: Text; var StartingDateText: Text; var EndingDateText: Text): Boolean
    begin
        exit(GetLineVATExemption(0, IsVATExemptLine, CustomerNo, OnDate, VATExemptNo, VATExemptSource, StartingDateText, EndingDateText));
    end;

    /// <summary>
    /// Returns the declaration of intent issued to the vendor printed under a document line without VAT.
    /// </summary>
    procedure GetVendorLineVATExemption(IsVATExemptLine: Boolean; VendorNo: Code[20]; OnDate: Date; var VATExemptNo: Text; var VATExemptSource: Text; var StartingDateText: Text; var EndingDateText: Text): Boolean
    begin
        exit(GetLineVATExemption(1, IsVATExemptLine, VendorNo, OnDate, VATExemptNo, VATExemptSource, StartingDateText, EndingDateText));
    end;

    /// <summary>
    /// Clears the declaration of intent fields and fills them for a document line without VAT.
    /// </summary>
    local procedure GetLineVATExemption(TypeOption: Integer; IsVATExemptLine: Boolean; AccountNo: Code[20]; OnDate: Date; var VATExemptNo: Text; var VATExemptSource: Text; var StartingDateText: Text; var EndingDateText: Text): Boolean
    var
        StartingDate: Date;
        EndingDate: Date;
    begin
        VATExemptNo := '';
        VATExemptSource := '';
        StartingDateText := '';
        EndingDateText := '';
        if not IsVATExemptLine then
            exit(false);
        if not FindVATExemption(TypeOption, AccountNo, OnDate, VATExemptNo, StartingDate, EndingDate, VATExemptSource) then
            exit(false);

        StartingDateText := Format(StartingDate);
        if EndingDate <> 0D then
            EndingDateText := Format(EndingDate);
        exit(true);
    end;

    /// <summary>
    /// Returns the tariff no. and the country of origin name of the item.
    /// </summary>
    procedure GetItemCustomsInfo(Item: Record Item; var TariffNo: Text; var CountryOfOrigin: Text)
    var
        CountryRegion: Record "Country/Region";
    begin
        TariffNo := Item."Tariff No.";
        CountryOfOrigin := '';
        if Item."Country/Region of Origin Code" = '' then
            exit;
        CountryOfOrigin := Item."Country/Region of Origin Code";
        if CountryRegion.Get(Item."Country/Region of Origin Code") then
            if CountryRegion.Name <> '' then
                CountryOfOrigin := CountryRegion.Name;
    end;

    /// <summary>
    /// Returns the ADR class and the UN no. of the item (posted sales invoice and credit memo).
    /// </summary>
    procedure GetItemDangerousGoodsInfo(Item: Record Item; var ADRClassCode: Text; var UNNo: Text)
    var
        IsHazardous: Boolean;
        HazardousDescription: Text;
    begin
        GetItemDangerousGoodsInfo(Item, IsHazardous, HazardousDescription, ADRClassCode, UNNo);
    end;

    /// <summary>
    /// Returns the hazardous flag, hazardous description, ADR class and UN no. of the item (sales documents).
    /// </summary>
    procedure GetItemDangerousGoodsInfo(Item: Record Item; var IsHazardous: Boolean; var HazardousDescription: Text; var ADRClassCode: Text; var UNNo: Text)
    var
        ADRDescription: Text;
        ADRLabel: Text;
        ADRPackingGroup: Text;
        GalleryCode: Text;
    begin
        GetItemDangerousGoodsInfo(Item, IsHazardous, HazardousDescription, ADRClassCode, UNNo, ADRDescription, ADRLabel, ADRPackingGroup, GalleryCode);
    end;

    /// <summary>
    /// Returns all the dangerous goods (ADR) data of the item printed by the Chematek reports.
    /// </summary>
    procedure GetItemDangerousGoodsInfo(Item: Record Item; var IsHazardous: Boolean; var HazardousDescription: Text; var ADRClassCode: Text; var UNNo: Text; var ADRDescription: Text; var ADRLabel: Text; var ADRPackingGroup: Text; var GalleryCode: Text)
    begin
        // TODO (pending decision): standard BC has no dangerous goods fields on the item.
        // Fill Hazardous, ItemHazardousDescr, ADRClass, ItemUN, ItemADRDescr, ItemADRLabel,
        // ItemADRPackingGroup and ItemGalleryCode from the agreed source (new Item table extension fields,
        // item attributes or an existing extension). Until then the hazardous / ADR / UN rows are not printed.
        IsHazardous := false;
        HazardousDescription := '';
        ADRClassCode := '';
        UNNo := '';
        ADRDescription := '';
        ADRLabel := '';
        ADRPackingGroup := '';
        GalleryCode := '';
    end;

    /// <summary>
    /// Returns the description of the item reference used on the sales line.
    /// </summary>
    procedure GetItemReferenceDescription(SalesLine: Record "Sales Line"): Text
    var
        ItemReference: Record "Item Reference";
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."Item Reference No." = '') then
            exit('');
        ItemReference.SetRange("Item No.", SalesLine."No.");
        ItemReference.SetRange("Variant Code", SalesLine."Variant Code");
        ItemReference.SetRange("Unit of Measure", SalesLine."Item Reference Unit of Measure");
        ItemReference.SetRange("Reference Type", SalesLine."Item Reference Type");
        ItemReference.SetRange("Reference Type No.", SalesLine."Item Reference Type No.");
        ItemReference.SetRange("Reference No.", SalesLine."Item Reference No.");
        if not ItemReference.FindFirst() then begin
            ItemReference.SetRange("Unit of Measure");
            if not ItemReference.FindFirst() then
                exit('');
        end;
        exit(ItemReference.Description);
    end;

    /// <summary>
    /// Returns the description of the project task.
    /// </summary>
    procedure GetJobTaskDescription(JobNo: Code[20]; JobTaskNo: Code[20]): Text[100]
    var
        JobTask: Record "Job Task";
    begin
        JobTask.SetRange("Job No.", JobNo);
        JobTask.SetRange("Job Task No.", JobTaskNo);
        if JobTask.FindFirst() then
            exit(JobTask.Description);
        exit('');
    end;

    /// <summary>
    /// Returns the description of the unit of measure, or the code when it is not found.
    /// </summary>
    procedure GetUOMText(UOMCode: Code[10]): Text[50]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;

    /// <summary>
    /// Converts a quantity in the base unit of measure to the unit of measure of the line.
    /// </summary>
    procedure CalcLineQty(QtyBase: Decimal; QtyPerUoM: Decimal): Decimal
    begin
        if QtyPerUoM = 0 then
            exit(QtyBase);
        exit(Round(QtyBase / QtyPerUoM, 0.00001));
    end;

    /// <summary>
    /// Fills the lot buffer with the lots assigned (item tracking) to the item lines of the sales document.
    /// </summary>
    procedure FillSalesLineLotBuffer(var TempSalesLine: Record "Sales Line" temporary; var TempLotBuffer: Record "Tracking Specification" temporary)
    var
        TempShippedLotBuffer: Record "Tracking Specification" temporary;
    begin
        FillSalesLineLotBuffersInternal(TempSalesLine, TempLotBuffer, TempShippedLotBuffer, false);
    end;

    /// <summary>
    /// Fills the lot buffers of the sales document: lots assigned to the item lines and lots already shipped.
    /// </summary>
    procedure FillSalesLineLotBuffers(var TempSalesLine: Record "Sales Line" temporary; var TempLotBuffer: Record "Tracking Specification" temporary; var TempShippedLotBuffer: Record "Tracking Specification" temporary)
    begin
        FillSalesLineLotBuffersInternal(TempSalesLine, TempLotBuffer, TempShippedLotBuffer, true);
    end;

    /// <summary>
    /// Reads the reservation entries and tracking specifications of the item lines and adds their lots to the lot buffers.
    /// </summary>
    local procedure FillSalesLineLotBuffersInternal(var TempSalesLine: Record "Sales Line" temporary; var TempLotBuffer: Record "Tracking Specification" temporary; var TempShippedLotBuffer: Record "Tracking Specification" temporary; IncludeShippedLots: Boolean)
    var
        TempSalesLineCalc: Record "Sales Line" temporary;
        ReservEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        EntryNo: Integer;
    begin
        TempLotBuffer.Reset();
        TempLotBuffer.DeleteAll();
        TempShippedLotBuffer.Reset();
        TempShippedLotBuffer.DeleteAll();

        TempSalesLineCalc.Copy(TempSalesLine, true);
        TempSalesLineCalc.Reset();
        TempSalesLineCalc.SetRange(Type, TempSalesLineCalc.Type::Item);
        TempSalesLineCalc.SetFilter("No.", '<>%1', '');
        if not TempSalesLineCalc.FindSet() then
            exit;
        repeat
            ReservEntry.Reset();
            ReservEntry.SetSourceFilter(
              Database::"Sales Line", TempSalesLineCalc."Document Type".AsInteger(), TempSalesLineCalc."Document No.", TempSalesLineCalc."Line No.", false);
            ReservEntry.SetSourceFilter('', 0);
            ReservEntry.SetFilter("Lot No.", '<>%1', '');
            if ReservEntry.FindSet() then
                repeat
                    AddLotToBuffer(
                      TempLotBuffer, EntryNo, Database::"Sales Line", TempSalesLineCalc."Document Type".AsInteger(),
                      TempSalesLineCalc."Document No.", TempSalesLineCalc."Line No.", TempSalesLineCalc."No.", TempSalesLineCalc."Variant Code",
                      TempSalesLineCalc.Description, TempSalesLineCalc."Qty. per Unit of Measure", ReservEntry."Lot No.", '', Abs(ReservEntry."Quantity (Base)"));
                until ReservEntry.Next() = 0;

            if IncludeShippedLots then begin
                TrackingSpecification.Reset();
                TrackingSpecification.SetSourceFilter(
                  Database::"Sales Line", TempSalesLineCalc."Document Type".AsInteger(), TempSalesLineCalc."Document No.", TempSalesLineCalc."Line No.", false);
                TrackingSpecification.SetSourceFilter('', 0);
                TrackingSpecification.SetFilter("Lot No.", '<>%1', '');
                if TrackingSpecification.FindSet() then
                    repeat
                        AddLotToBuffer(
                          TempShippedLotBuffer, EntryNo, Database::"Sales Line", TempSalesLineCalc."Document Type".AsInteger(),
                          TempSalesLineCalc."Document No.", TempSalesLineCalc."Line No.", TempSalesLineCalc."No.", TempSalesLineCalc."Variant Code",
                          TempSalesLineCalc.Description, TempSalesLineCalc."Qty. per Unit of Measure", TrackingSpecification."Lot No.", '', Abs(TrackingSpecification."Quantity (Base)"));
                    until TrackingSpecification.Next() = 0;
            end;
        until TempSalesLineCalc.Next() = 0;
    end;

    /// <summary>
    /// Fills the lot buffer with the lots invoiced on the posted sales invoice, taken from the item ledger entries.
    /// </summary>
    procedure FillSalesInvoiceLotBuffer(InvoiceNo: Code[20]; var TempLotBuffer: Record "Tracking Specification" temporary)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        EntryNo: Integer;
    begin
        TempLotBuffer.Reset();
        TempLotBuffer.DeleteAll();

        SalesInvoiceLine.SetRange("Document No.", InvoiceNo);
        SalesInvoiceLine.SetRange(Type, SalesInvoiceLine.Type::Item);
        SalesInvoiceLine.SetFilter("No.", '<>%1', '');
        if not SalesInvoiceLine.FindSet() then
            exit;
        repeat
            SalesInvoiceLine.GetItemLedgEntries(TempItemLedgerEntry, true);
            TempItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
            if TempItemLedgerEntry.FindSet() then
                repeat
                    AddLotToBuffer(
                      TempLotBuffer, EntryNo, Database::"Sales Invoice Line", 0,
                      SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.", SalesInvoiceLine."No.", SalesInvoiceLine."Variant Code",
                      SalesInvoiceLine.Description, SalesInvoiceLine."Qty. per Unit of Measure", TempItemLedgerEntry."Lot No.", '', Abs(TempItemLedgerEntry.Quantity));
                until TempItemLedgerEntry.Next() = 0;
        until SalesInvoiceLine.Next() = 0;
    end;

    /// <summary>
    /// Fills the lot buffer with the lots credited on the posted sales credit memo, taken from the item ledger entries.
    /// </summary>
    procedure FillSalesCrMemoLotBuffer(CrMemoNo: Code[20]; var TempLotBuffer: Record "Tracking Specification" temporary)
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        EntryNo: Integer;
    begin
        TempLotBuffer.Reset();
        TempLotBuffer.DeleteAll();

        SalesCrMemoLine.SetRange("Document No.", CrMemoNo);
        SalesCrMemoLine.SetRange(Type, SalesCrMemoLine.Type::Item);
        SalesCrMemoLine.SetFilter("No.", '<>%1', '');
        if not SalesCrMemoLine.FindSet() then
            exit;
        repeat
            SalesCrMemoLine.GetItemLedgEntries(TempItemLedgerEntry, true);
            TempItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
            if TempItemLedgerEntry.FindSet() then
                repeat
                    AddLotToBuffer(
                      TempLotBuffer, EntryNo, Database::"Sales Cr.Memo Line", 0,
                      SalesCrMemoLine."Document No.", SalesCrMemoLine."Line No.", SalesCrMemoLine."No.", SalesCrMemoLine."Variant Code",
                      SalesCrMemoLine.Description, SalesCrMemoLine."Qty. per Unit of Measure", TempItemLedgerEntry."Lot No.", '', Abs(TempItemLedgerEntry.Quantity));
                until TempItemLedgerEntry.Next() = 0;
        until SalesCrMemoLine.Next() = 0;
    end;

    /// <summary>
    /// Fills the lot buffer with the lots and packages shipped on the posted sales shipment, taken from the item ledger entries.
    /// </summary>
    procedure FillSalesShipmentLotBuffer(ShipmentNo: Code[20]; var TempLotBuffer: Record "Tracking Specification" temporary)
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        EntryNo: Integer;
    begin
        TempLotBuffer.Reset();
        TempLotBuffer.DeleteAll();

        SalesShipmentLine.SetRange("Document No.", ShipmentNo);
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
                        AddLotToBuffer(
                          TempLotBuffer, EntryNo, Database::"Sales Shipment Line", 0,
                          SalesShipmentLine."Document No.", SalesShipmentLine."Line No.", SalesShipmentLine."No.", SalesShipmentLine."Variant Code",
                          SalesShipmentLine.Description, SalesShipmentLine."Qty. per Unit of Measure", ItemLedgerEntry."Lot No.", ItemLedgerEntry."Package No.", Abs(ItemLedgerEntry.Quantity));
                until ItemLedgerEntry.Next() = 0;
        until SalesShipmentLine.Next() = 0;
    end;

    /// <summary>
    /// Fills the lot buffer with the lots returned on the posted return shipment, taken from the item ledger entries.
    /// </summary>
    procedure FillReturnShipmentLotBuffer(ReturnShipmentNo: Code[20]; var TempLotBuffer: Record "Tracking Specification" temporary)
    var
        ReturnShipmentLine: Record "Return Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        EntryNo: Integer;
    begin
        TempLotBuffer.Reset();
        TempLotBuffer.DeleteAll();

        ReturnShipmentLine.SetRange("Document No.", ReturnShipmentNo);
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
                    AddLotToBuffer(
                      TempLotBuffer, EntryNo, Database::"Return Shipment Line", 0,
                      ReturnShipmentLine."Document No.", ReturnShipmentLine."Line No.", ReturnShipmentLine."No.", ReturnShipmentLine."Variant Code",
                      ReturnShipmentLine.Description, ReturnShipmentLine."Qty. per Unit of Measure", ItemLedgerEntry."Lot No.", '', Abs(ItemLedgerEntry.Quantity));
                until ItemLedgerEntry.Next() = 0;
        until ReturnShipmentLine.Next() = 0;
    end;

    /// <summary>
    /// Adds a lot (and package) of a document line to the lot buffer, or adds the quantity when the row already exists.
    /// </summary>
    local procedure AddLotToBuffer(var TempLotBuffer: Record "Tracking Specification" temporary; var EntryNo: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer; ItemNo: Code[20]; VariantCode: Code[10]; Description: Text[100]; QtyPerUoM: Decimal; LotNo: Code[50]; PackageNo: Code[50]; QtyBase: Decimal)
    begin
        if QtyBase = 0 then
            exit;

        TempLotBuffer.Reset();
        TempLotBuffer.SetRange("Source Ref. No.", SourceRefNo);
        TempLotBuffer.SetRange("Lot No.", LotNo);
        TempLotBuffer.SetRange("Package No.", PackageNo);
        if TempLotBuffer.FindFirst() then begin
            TempLotBuffer."Quantity (Base)" += QtyBase;
            TempLotBuffer."Qty. to Handle" := CalcLineQty(TempLotBuffer."Quantity (Base)", QtyPerUoM);
            TempLotBuffer.Modify();
        end else begin
            EntryNo += 1;
            TempLotBuffer.Init();
            TempLotBuffer."Entry No." := EntryNo;
            TempLotBuffer."Source Type" := SourceType;
            TempLotBuffer."Source Subtype" := SourceSubtype;
            TempLotBuffer."Source ID" := SourceID;
            TempLotBuffer."Source Ref. No." := SourceRefNo;
            TempLotBuffer."Item No." := ItemNo;
            TempLotBuffer."Variant Code" := VariantCode;
            TempLotBuffer.Description := Description;
            TempLotBuffer."Lot No." := LotNo;
            TempLotBuffer."Package No." := PackageNo;
            TempLotBuffer."Qty. per Unit of Measure" := QtyPerUoM;
            TempLotBuffer."Quantity (Base)" := QtyBase;
            TempLotBuffer."Qty. to Handle" := CalcLineQty(QtyBase, QtyPerUoM);
            TempLotBuffer.Insert();
        end;
        TempLotBuffer.Reset();
    end;

    /// <summary>
    /// Sums parcels, pallets, weights and non-reusable packaging of all posted sales shipments invoiced by the posted sales invoice.
    /// </summary>
    procedure CalcSalesInvoiceShipmentTotals(InvoiceNo: Code[20]; var TotalParcels: Integer; var TotalPallets: Integer; var TotalNetWeight: Decimal; var TotalGrossWeight: Decimal; var TotalNonReusablePackaging: Decimal)
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        TempSalesShipmentLine: Record "Sales Shipment Line" temporary;
        ShipmentNos: List of [Code[20]];
        ShipmentNo: Code[20];
    begin
        TotalParcels := 0;
        TotalPallets := 0;
        TotalNetWeight := 0;
        TotalGrossWeight := 0;
        TotalNonReusablePackaging := 0;

        SalesInvoiceLine.SetRange("Document No.", InvoiceNo);
        SalesInvoiceLine.SetFilter(Type, '<>%1', SalesInvoiceLine.Type::" ");
        if SalesInvoiceLine.FindSet() then
            repeat
                if SalesInvoiceLine."Shipment No." <> '' then
                    AddShipmentNo(ShipmentNos, SalesInvoiceLine."Shipment No.")
                else
                    if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
                        SalesInvoiceLine.GetSalesShptLines(TempSalesShipmentLine);
                        if TempSalesShipmentLine.FindSet() then
                            repeat
                                AddShipmentNo(ShipmentNos, TempSalesShipmentLine."Document No.");
                            until TempSalesShipmentLine.Next() = 0;
                    end;
            until SalesInvoiceLine.Next() = 0;

        foreach ShipmentNo in ShipmentNos do
            if SalesShipmentHeader.Get(ShipmentNo) then begin
                TotalParcels += SalesShipmentHeader."CHM Total Parcel";
                TotalPallets += SalesShipmentHeader."CHM Total Pallet";
                TotalNetWeight += SalesShipmentHeader."CHM Total Net Weight";
                TotalGrossWeight += SalesShipmentHeader."CHM Total Gross Weight";
                TotalNonReusablePackaging += SalesShipmentHeader."CHM Non-reusable Packaging";
            end;
    end;

    /// <summary>
    /// Returns the parcels, pallets and weights printed on the posted sales credit memo.
    /// </summary>
    procedure CalcSalesCrMemoShipmentTotals(var TotalParcels: Integer; var TotalPallets: Integer; var TotalNetWeight: Decimal; var TotalGrossWeight: Decimal)
    begin
        // TODO (pending decision): parcels, pallets and weights are entered on the posted sales shipment
        // (DEV-002). A credit memo is linked to return receipts, which have no Chematek shipment fields,
        // so nothing is printed (the layout hides these values when they are 0).
        TotalParcels := 0;
        TotalPallets := 0;
        TotalNetWeight := 0;
        TotalGrossWeight := 0;
    end;

    /// <summary>
    /// Adds the shipment no. to the list when it is not already there.
    /// </summary>
    local procedure AddShipmentNo(var ShipmentNos: List of [Code[20]]; ShipmentNo: Code[20])
    begin
        if ShipmentNo = '' then
            exit;
        if not ShipmentNos.Contains(ShipmentNo) then
            ShipmentNos.Add(ShipmentNo);
    end;

    /// <summary>
    /// Calculates the weights, volume and parcels of the posted return shipment from its lines.
    /// </summary>
    procedure CalcReturnShipmentTotals(ReturnShipmentNo: Code[20]; var TotalGrossWeight: Decimal; var TotalNetWeight: Decimal; var TotalVolume: Decimal; var NoOfParcels: Integer)
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

        ReturnShipmentLine.SetRange("Document No.", ReturnShipmentNo);
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
    end;

    /// <summary>
    /// Returns the description of the goods appearance, or the code when the description is blank.
    /// </summary>
    procedure GetGoodsAppearanceText(GoodsAppearanceCode: Code[10]): Text
    var
        GoodsAppearance: Record "CHM Goods Appearance";
    begin
        if GoodsAppearanceCode = '' then
            exit('');
        if GoodsAppearance.Get(GoodsAppearanceCode) then
            if GoodsAppearance.Description <> '' then
                exit(GoodsAppearance.Description);
        exit(GoodsAppearanceCode);
    end;

    /// <summary>
    /// Returns the transport start date and time printed on the sales shipment DDT:
    /// the Shipment Date of the shipment (Posting Date when blank) and the time the shipment was posted.
    /// </summary>
    procedure GetTransportStartDateTime(SalesShipmentHeader: Record "Sales Shipment Header"): Text
    var
        StartingDate: Date;
    begin
        StartingDate := SalesShipmentHeader."Shipment Date";
        if StartingDate = 0D then
            StartingDate := SalesShipmentHeader."Posting Date";
        exit(FormatTransportStartDateTime(StartingDate, SalesShipmentHeader.SystemCreatedAt));
    end;

    /// <summary>
    /// Returns the transport start date and time printed on the return shipment DDT:
    /// the Posting Date of the return shipment and the time it was posted.
    /// </summary>
    procedure GetTransportStartDateTime(ReturnShipmentHeader: Record "Return Shipment Header"): Text
    begin
        exit(FormatTransportStartDateTime(ReturnShipmentHeader."Posting Date", ReturnShipmentHeader.SystemCreatedAt));
    end;

    local procedure FormatTransportStartDateTime(StartingDate: Date; PostedAt: DateTime): Text
    begin
        if StartingDate = 0D then
            exit('');
        if PostedAt = 0DT then
            exit(Format(StartingDate));
        exit(StrSubstNo(DateTimeTok, Format(StartingDate), Format(DT2Time(PostedAt), 0, TransportStartTimeFormatTok)));
    end;

    /// <summary>
    /// Reads the work description of the posted sales shipment. Returns true when it has a value.
    /// </summary>
    procedure GetSalesShipmentWorkDescription(var SalesShipmentHeader: Record "Sales Shipment Header"; var WorkDescriptionText: Text): Boolean
    var
        TypeHelper: Codeunit "Type Helper";
        WorkDescriptionInStream: InStream;
    begin
        WorkDescriptionText := '';
        SalesShipmentHeader.CalcFields("Work Description");
        if not SalesShipmentHeader."Work Description".HasValue() then
            exit(false);
        SalesShipmentHeader."Work Description".CreateInStream(WorkDescriptionInStream, TextEncoding::UTF8);
        WorkDescriptionText := TypeHelper.ReadAsTextWithSeparator(WorkDescriptionInStream, TypeHelper.LFSeparator());
        exit(true);
    end;

    /// <summary>
    /// Returns the header comments of the posted sales shipment, one comment per line.
    /// </summary>
    procedure GetSalesShipmentComments(ShipmentNo: Code[20]) Result: Text
    var
        SalesCommentLine: Record "Sales Comment Line";
        TypeHelper: Codeunit "Type Helper";
    begin
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Shipment);
        SalesCommentLine.SetRange("No.", ShipmentNo);
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

    /// <summary>
    /// Returns the header comments of the posted return shipment, one comment per line.
    /// </summary>
    procedure GetReturnShipmentComments(ReturnShipmentNo: Code[20]) Result: Text
    var
        PurchCommentLine: Record "Purch. Comment Line";
        TypeHelper: Codeunit "Type Helper";
    begin
        PurchCommentLine.SetRange("Document Type", PurchCommentLine."Document Type"::"Posted Return Shipment");
        PurchCommentLine.SetRange("No.", ReturnShipmentNo);
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

    /// <summary>
    /// Returns the signature image (PNG, base64) printed in the footer of the DDT.
    /// </summary>
    procedure GetSignPicture(): Text
    begin
        // TODO (pending decision): the layout prints a signature image (PNG, base64) in the footer. Standard BC
        // has no signature image; fill this from the agreed source. Until then nothing is printed.
        exit('');
    end;

    /// <summary>
    /// Returns the note printed in the page footer of the purchase order.
    /// </summary>
    procedure GetPurchaseDocumentNote(PurchHeader: Record "Purchase Header"): Text
    begin
        // TODO (pending decision): note printed in the page footer (DescrLav). The sales reports print the
        // Work Description, which the Purchase Header does not have. Return the agreed text here.
        exit('');
    end;

    /// <summary>
    /// Returns the value font-encoded as a Code 39 barcode. Characters not supported by Code 39 are removed.
    /// </summary>
    procedure EncodeCode39(Value: Text): Text
    var
        BarcodeFontProvider: Interface "Barcode Font Provider";
        BarcodeSymbology: Enum "Barcode Symbology";
    begin
        Value := UpperCase(Value);
        Value := DelChr(Value, '=', DelChr(Value, '=', Code39CharsTok));
        if Value = '' then
            exit('');

        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        exit(BarcodeFontProvider.EncodeFont(Value, BarcodeSymbology));
    end;

    /// <summary>
    /// Returns the value font-encoded as a QR code.
    /// </summary>
    procedure EncodeQRCode(Value: Text): Text
    var
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
    begin
        if Value = '' then
            exit('');

        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        exit(BarcodeFontProvider2D.EncodeFont(Value, BarcodeSymbology2D));
    end;

    /// <summary>
    /// Returns the Michelin supplier code of the sell-to customer of the posted sales shipment.
    /// </summary>
    procedure GetMichelinSupplierCode(ShipmentNo: Code[20]): Code[20]
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        Customer: Record Customer;
    begin
        if not SalesShipmentHeader.Get(ShipmentNo) then
            exit('');
        if not Customer.Get(SalesShipmentHeader."Sell-to Customer No.") then
            exit('');
        exit(Customer."CHM Michelin Supplier Code");
    end;

    /// <summary>
    /// Returns the next Michelin label serial no. from the number series.
    /// </summary>
    procedure GetNextMichelinLabelSN(NoSeriesCode: Code[20]): Code[20]
    var
        NoSeries: Codeunit "No. Series";
    begin
        exit(NoSeries.GetNextNo(NoSeriesCode));
    end;

    /// <summary>
    /// Returns the production date stored on the Lot No. Information of the lot.
    /// </summary>
    procedure GetLotProductionDate(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]): Date
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNo = '' then
            exit(0D);
        if LotNoInformation.Get(ItemNo, VariantCode, LotNo) then
            exit(LotNoInformation."CHM Production Date");
        exit(0D);
    end;

    /// <summary>
    /// Raises an error when the production date differs from the one already stored on the lot.
    /// </summary>
    procedure CheckProductionDateAgainstLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; ProductionDate: Date)
    var
        LotProductionDate: Date;
    begin
        if (LotNo = '') or (ProductionDate = 0D) then
            exit;
        LotProductionDate := GetLotProductionDate(ItemNo, VariantCode, LotNo);
        if (LotProductionDate <> 0D) and (LotProductionDate <> ProductionDate) then
            Error(ProductionDateMismatchErr, LotNo, ItemNo, LotProductionDate);
    end;

    /// <summary>
    /// Stores the production date of the item ledger entry on the Lot No. Information, creating the card when it does not exist.
    /// </summary>
    local procedure UpdateLotNoInformation(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            if LotNoInformation."CHM Production Date" <> 0D then
                exit;
            LotNoInformation."CHM Production Date" := ItemLedgerEntry."CHM Production Date";
            LotNoInformation.Modify(true);
        end else begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := ItemLedgerEntry."Item No.";
            LotNoInformation."Variant Code" := ItemLedgerEntry."Variant Code";
            LotNoInformation."Lot No." := ItemLedgerEntry."Lot No.";
            LotNoInformation."CHM Production Date" := ItemLedgerEntry."CHM Production Date";
            LotNoInformation.Insert(true);
        end;
    end;

    /// <summary>
    /// Copies the production date from the item tracking line to the new reservation entry.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure SetProductionDateOnNewReservEntry(var ReservEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        if ReservEntry."Entry No." = 0 then
            exit;
        if ReservEntry."CHM Production Date" = TrackingSpecification."CHM Production Date" then
            exit;
        if not ReservEntry.Find() then
            exit;
        ReservEntry."CHM Production Date" := TrackingSpecification."CHM Production Date";
        ReservEntry.Modify();
    end;

    /// <summary>
    /// Treats tracking lines with a different production date as changed, so a change of production date alone is registered.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure CompareProductionDate(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[2] := IdenticalArray[2] and (ReservEntry1."CHM Production Date" = ReservEntry2."CHM Production Date");
    end;

    /// <summary>
    /// Copies the production date when the Item Tracking Lines page copies a tracking specification.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure CopyProductionDateBetweenTrackingSpecs(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        DestTrkgSpec."CHM Production Date" := SourceTrackingSpec."CHM Production Date";
    end;

    /// <summary>
    /// Moves the production date from the tracking specification to the reservation entry.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure MoveProductionDateToReservEntry(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry."CHM Production Date" := TrkgSpec."CHM Production Date";
    end;

    /// <summary>
    /// Copies the production date from the tracking specification to the item journal line during posting.
    /// </summary>
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure CopyProductionDateToItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemJournalLine."CHM Production Date" := TrackingSpecification."CHM Production Date";
    end;

    /// <summary>
    /// Copies the production date to the item ledger entry; takes the date stored on the lot when the line has none.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CopyProductionDateToItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."CHM Production Date" := ItemJournalLine."CHM Production Date";
        if NewItemLedgEntry."CHM Production Date" = 0D then
            NewItemLedgEntry."CHM Production Date" :=
              GetLotProductionDate(NewItemLedgEntry."Item No.", NewItemLedgEntry."Variant Code", NewItemLedgEntry."Lot No.");
    end;

    /// <summary>
    /// Updates the Lot No. Information after an inbound item ledger entry with a lot and a production date is posted.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure UpdateLotNoInfoFromItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        if not ItemLedgerEntry.Positive then
            exit;
        if (ItemLedgerEntry."Lot No." = '') or (ItemLedgerEntry."CHM Production Date" = 0D) then
            exit;
        UpdateLotNoInformation(ItemLedgerEntry);
    end;
}
