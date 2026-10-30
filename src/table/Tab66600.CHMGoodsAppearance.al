table 66600 "CHM Goods Appearance"
{
    Caption = 'Goods Appearance';
    DataClassification = CustomerContent;
    LookupPageId = "CHM Goods Appearances";
    DrillDownPageId = "CHM Goods Appearances";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description) { }
    }
}
