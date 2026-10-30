pageextension 66603 "CHM Posted Sales Shpt. Update" extends "Posted Sales Shipment - Update"
{
    layout
    {
        addlast(Content)
        {
            group(CHMShipmentDetails)
            {
                Caption = 'Shipment Details';

                field("CHM Total Net Weight"; Rec."CHM Total Net Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total net weight of the shipment.';
                }
                field("CHM Total Gross Weight"; Rec."CHM Total Gross Weight")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total gross weight of the shipment.';
                }
                field("CHM Total Parcel"; Rec."CHM Total Parcel")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of parcels.';
                }
                field("CHM Total Pallet"; Rec."CHM Total Pallet")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of pallets.';
                }
                field("CHM Total Volume"; Rec."CHM Total Volume")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total volume of the shipment.';
                }
                field("CHM Goods Appearance"; Rec."CHM Goods Appearance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the appearance of the goods.';
                }
                field("CHM Non-reusable Packaging"; Rec."CHM Non-reusable Packaging")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the non-reusable packaging quantity.';
                }
            }
        }
    }
}
