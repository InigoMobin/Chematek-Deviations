pageextension 66606 "CHM Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addafter("Lot No.")
        {
            field("CHM Production Date"; Rec."CHM Production Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the production date of the lot.';
            }
        }
    }
}
