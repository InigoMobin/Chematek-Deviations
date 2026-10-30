pageextension 66609 "CHM Item Ledger Entries" extends "Item Ledger Entries"
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
