table 66602 "CHM Customizations Setup"
{
    Caption = 'Chematek Customizations Setup';
    DataClassification = CustomerContent;
    DrillDownPageId = "CHM Customizations Setup";
    LookupPageId = "CHM Customizations Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Right Header Logo"; Blob)
        {
            Caption = 'Right Header Logo';
            Subtype = Bitmap;
        }
        field(11; "Footer Logo"; Blob)
        {
            Caption = 'Footer Logo';
            Subtype = Bitmap;
        }
        field(12; "ISO 9001 Logo"; Blob)
        {
            Caption = 'ISO 9001 Logo';
            Subtype = Bitmap;
        }
        field(13; "ASSICC Logo"; Blob)
        {
            Caption = 'ASSICC Logo';
            Subtype = Bitmap;
        }
        field(14; "Show ISO"; Boolean)
        {
            Caption = 'Show ISO';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
