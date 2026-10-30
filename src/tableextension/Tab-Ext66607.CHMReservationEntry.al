tableextension 66607 "CHM Reservation Entry" extends "Reservation Entry"
{
    fields
    {
        // Field ID must stay identical to Tracking Specification field 66600 (TransferFields).
        field(66600; "CHM Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
}
