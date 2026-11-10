codeunit 66602 "CHM Management"
{
    // Common Chematek procedures shared by the reports, pages and other objects of this extension.
    // Italian localization data (Fiscal Code, VAT Exemption) is read by table and field name, so the extension
    // compiles without a dependency on the IT base app. Where the table or field does not exist, nothing is returned.

    var
        FiscalCodeFieldTok: Label 'Fiscal Code', Locked = true;
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

    // ---------- Fiscal Code (Codice Fiscale) ----------
    // The W1 Customer and Vendor tables have no Fiscal Code; the Italian localization adds a "Fiscal Code" field.

    procedure GetCustomerFiscalCode(CustomerNo: Code[20]): Text
    var
        Customer: Record Customer;
    begin
        if CustomerNo = '' then
            exit('');
        if not Customer.Get(CustomerNo) then
            exit('');
        exit(GetFieldValueByName(Customer, Database::Customer, FiscalCodeFieldTok));
    end;

    procedure GetVendorFiscalCode(VendorNo: Code[20]): Text
    var
        Vendor: Record Vendor;
    begin
        if VendorNo = '' then
            exit('');
        if not Vendor.Get(VendorNo) then
            exit('');
        exit(GetFieldValueByName(Vendor, Database::Vendor, FiscalCodeFieldTok));
    end;

    // ---------- VAT Exemption (declaration of intent / dichiarazione d'intento) ----------
    // Standard Italian table 12186 "VAT Exemption" (page 12100 "VAT Exemptions"): one record per customer or vendor
    // and validity period. Type Customer = declaration received from a customer (sales documents),
    // Type Vendor = declaration issued by Chematek to a vendor (purchase documents).

    /// <summary>
    /// Finds the declaration of intent of the customer that is valid on OnDate.
    /// DeclarationText is the text printed under the exempt lines, e.g. "Declaration of intent no. 12 of 15/01/2026".
    /// </summary>
    procedure FindCustomerVATExemption(CustomerNo: Code[20]; OnDate: Date; var DeclarationText: Text; var StartingDate: Date; var EndingDate: Date; var RegistryNo: Text): Boolean
    begin
        exit(FindVATExemption(0, CustomerNo, OnDate, DeclarationText, StartingDate, EndingDate, RegistryNo));
    end;

    /// <summary>
    /// Finds the declaration of intent issued to the vendor that is valid on OnDate.
    /// </summary>
    procedure FindVendorVATExemption(VendorNo: Code[20]; OnDate: Date; var DeclarationText: Text; var StartingDate: Date; var EndingDate: Date; var RegistryNo: Text): Boolean
    begin
        exit(FindVATExemption(1, VendorNo, OnDate, DeclarationText, StartingDate, EndingDate, RegistryNo));
    end;

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

        // The table only exists in the Italian localization.
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

        // Declarations of this customer / vendor that are valid on OnDate (a blank ending date means open-ended).
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
                // When periods overlap, the declaration that started most recently wins.
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

        // Number of the declaration; the internal registry number is used when it is blank.
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

    local procedure VATExemptionTableNo(): Integer
    begin
        exit(12186);
    end;

    // ---------- Generic helpers ----------

    /// <summary>
    /// Returns the value of a field found by its name, as text. Returns blank when the table has no such field
    /// (for example a localization field that does not exist in this base app version).
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
    /// Returns the number of the field with this name in the table, or 0 when the table has no such field.
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
}
