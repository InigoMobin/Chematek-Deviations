table 66601 "CHM Michelin Labels"
{
    Caption = 'CHM Michelin Labels';
    DataClassification = CustomerContent;
    TableType = Temporary; // Buffer only: lines are loaded on demand from the page, nothing is stored in the database

    fields
    {
        field(1; Index; BigInteger)
        {
            Caption = 'Index';
        }
        field(2; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
        }
        field(3; "Sales Shpt. Code"; Code[20])
        {
            Caption = 'Sales Shipment Code';
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; "Lot No."; Code[50])
        {
            Caption = 'Lot No.';
        }
        field(7; "Production Date"; Code[8])
        {
            Caption = 'Production Date';
        }
        field(8; Quantity; Integer)
        {
            Caption = 'Quantity';
            MinValue = 0;
        }
        field(9; "Michelin Purch. Order"; Text[35])
        {
            Caption = 'Michelin Purch. Order';
        }
        field(10; "Ship-from Name"; Text[100])
        {
            Caption = 'Ship-from Name';
        }
        field(11; "Ship-from Address"; Text[100])
        {
            Caption = 'Ship-from Address';
        }
        field(12; "Ship-from City"; Text[30])
        {
            Caption = 'Ship-from City';
        }
        field(13; "Ship-from Post Code"; Code[20])
        {
            Caption = 'Ship-from Post Code';
        }
        field(14; "Ship-from County"; Text[30])
        {
            Caption = 'Ship-from County';
        }
        field(15; "Ship-from Country"; Text[50])
        {
            Caption = 'Ship-from Country';
        }
        field(16; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(17; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(18; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(19; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
        }
        field(20; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(21; "Ship-to Country"; Text[50])
        {
            Caption = 'Ship-to Country';
        }
    }

    keys
    {
        key(PK; Index)
        {
            Clustered = true;
        }
        key(Key2; "Sales Shpt. Code", "Item No.", "Lot No.")
        {
        }
    }
}
