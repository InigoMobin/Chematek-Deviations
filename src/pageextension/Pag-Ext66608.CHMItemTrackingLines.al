pageextension 66608 "CHM Item Tracking Lines" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Expiration Date")
        {
            field("CHM Production Date"; Rec."CHM Production Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the production date of the lot. The date is carried to the item ledger entry and the Lot No. Information card when the transaction is posted.';
            }
        }
    }
}
