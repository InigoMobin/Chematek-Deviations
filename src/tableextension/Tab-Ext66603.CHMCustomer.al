tableextension 66603 "CHM Customer" extends Customer
{
    fields
    {
        field(66600; "CHM Michelin Customer"; Boolean)
        {
            Caption = 'Michelin Customer';
            DataClassification = CustomerContent;
        }
        field(66601; "CHM Michelin Supplier Code"; Code[20])
        {
            Caption = 'Michelin Supplier Code';
            DataClassification = CustomerContent;
        }
    }
}
