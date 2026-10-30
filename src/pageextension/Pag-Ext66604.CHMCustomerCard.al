pageextension 66604 "CHM Customer Card" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("CHM Michelin Customer"; Rec."CHM Michelin Customer")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether the customer is a Michelin customer. Only posted shipments of Michelin customers can be loaded on the Michelin labels page.';
            }
            field("CHM Michelin Supplier Code"; Rec."CHM Michelin Supplier Code")
            {
                ApplicationArea = All;
                Editable = Rec."CHM Michelin Customer";
                ToolTip = 'Specifies the supplier code assigned to Chematek by Michelin. It is printed as Supplier Code (V) on the Michelin label.';
            }
        }
    }
}
