codeunit 66602 "CHM Management"
{
    // Common Chematek procedures shared by the reports, pages and other objects of this extension.

    var
        FiscalCodeFieldTok: Label 'Fiscal Code', Locked = true;

    // ---------- Fiscal Code (Codice Fiscale) ----------
    // The W1 Customer and Vendor tables have no Fiscal Code; the Italian localization adds a "Fiscal Code" field.
    // The field is read by name, so the extension compiles without a dependency on the IT base app and prints
    // the value automatically where the field exists. Where it does not exist, the value is blank.

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

    // ---------- Generic helpers ----------

    /// <summary>
    /// Returns the value of a field found by its name, as text. Returns blank when the table has no such field
    /// (for example a localization field that does not exist in this base app version).
    /// </summary>
    procedure GetFieldValueByName(RecVariant: Variant; TableNo: Integer; FieldName: Text): Text
    var
        FieldRec: Record Field;
        RecRef: RecordRef;
    begin
        FieldRec.SetRange(TableNo, TableNo);
        FieldRec.SetRange(FieldName, FieldName);
        FieldRec.SetRange(Class, FieldRec.Class::Normal);
        FieldRec.SetFilter(ObsoleteState, '<>%1', FieldRec.ObsoleteState::Removed);
        if not FieldRec.FindFirst() then
            exit('');

        RecRef.GetTable(RecVariant);
        exit(DelChr(Format(RecRef.Field(FieldRec."No.").Value()), '<>', ' '));
    end;
}
