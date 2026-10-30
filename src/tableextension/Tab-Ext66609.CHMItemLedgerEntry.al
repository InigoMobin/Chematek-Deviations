tableextension 66609 "CHM Item Ledger Entry" extends "Item Ledger Entry"
{
    fields
    {
        field(66600; "CHM Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
