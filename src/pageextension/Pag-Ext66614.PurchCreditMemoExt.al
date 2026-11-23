pageextension 66614 "Purch. Credit Memo Ext" extends "Purchase Credit Memo"
{
    layout
    {
        addafter(Status)
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
    }
}