pageextension 66605 "CHM Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("CHM Michelin Label Nos."; Rec."CHM Michelin Label Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number series used for the label serial number (S) printed on Michelin labels.';
            }
        }
    }
}
