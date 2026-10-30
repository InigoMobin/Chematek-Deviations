tableextension 66602 "CHM Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(66600; "CHM Total Net Weight"; Decimal)
        {
            Caption = 'Total Net Weight';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                ShipmentDataMgt: Codeunit "CHM Event Management";
            begin
                ShipmentDataMgt.CheckWeights(Rec."CHM Total Net Weight", Rec."CHM Total Gross Weight");
            end;
        }
        field(66601; "CHM Total Gross Weight"; Decimal)
        {
            Caption = 'Total Gross Weight';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                ShipmentDataMgt: Codeunit "CHM Event Management";
            begin
                ShipmentDataMgt.CheckWeights(Rec."CHM Total Net Weight", Rec."CHM Total Gross Weight");
            end;
        }
        field(66602; "CHM Total Parcel"; Integer)
        {
            Caption = 'Total Parcel';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(66603; "CHM Total Pallet"; Integer)
        {
            Caption = 'Total Pallet';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(66604; "CHM Total Volume"; Decimal)
        {
            Caption = 'Total Volume';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(66605; "CHM Goods Appearance"; Code[10])
        {
            Caption = 'Goods Appearance';
            DataClassification = CustomerContent;
            TableRelation = "CHM Goods Appearance";
        }
        field(66606; "CHM Non-reusable Packaging"; Decimal)
        {
            Caption = 'CHM Non-reusable Packaging';
            DataClassification = CustomerContent;
            DecimalPlaces = 2 : 5;
            MinValue = 0;
        }
    }
}
