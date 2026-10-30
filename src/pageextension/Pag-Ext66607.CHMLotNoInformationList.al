pageextension 66607 "CHM Lot No. Information List" extends "Lot No. Information List"
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
