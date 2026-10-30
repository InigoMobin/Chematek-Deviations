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
        }
    }
}
