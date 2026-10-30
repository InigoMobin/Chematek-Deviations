pageextension 66602 "CHM Posted Sales Shipment" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(Shipping)
        {
            field("CHM Total Net Weight"; Rec."CHM Total Net Weight")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total net weight of the shipment.';
            }
            field("CHM Total Gross Weight"; Rec."CHM Total Gross Weight")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total gross weight of the shipment.';
            }
            field("CHM Total Parcel"; Rec."CHM Total Parcel")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total number of parcels.';
            }
            field("CHM Total Pallet"; Rec."CHM Total Pallet")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total number of pallets.';
            }
            field("CHM Total Volume"; Rec."CHM Total Volume")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total volume of the shipment.';
            }
            field("CHM Goods Appearance"; Rec."CHM Goods Appearance")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the appearance of the goods.';
            }
            field("CHM Non-reusable Packaging"; Rec."CHM Non-reusable Packaging")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the non-reusable packaging quantity.';
            }
        }
    }
}
