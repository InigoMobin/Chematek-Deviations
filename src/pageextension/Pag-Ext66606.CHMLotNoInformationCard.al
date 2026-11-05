pageextension 66606 "CHM Lot No. Information Card" extends "Lot No. Information Card"
{
    layout
    {
        addlast(Content)
        {
            group(CHMAdditionalData)
            {
                Caption = 'CHEMATEK - Dati aggiuntivi';

                field("CHM Production Date"; Rec."CHM Production Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the production date of the lot.';
                }
            }
        }
    }
}
