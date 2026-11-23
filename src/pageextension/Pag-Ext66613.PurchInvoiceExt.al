pageextension 66613 "Purch. Invoice Ext" extends "Purchase Invoice"
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