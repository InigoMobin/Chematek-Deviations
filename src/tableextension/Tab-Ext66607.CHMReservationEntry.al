tableextension 66607 "CHM Reservation Entry" extends "Reservation Entry"
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
