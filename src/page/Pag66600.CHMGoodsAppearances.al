page 66600 "CHM Goods Appearances"
{
    Caption = 'Goods Appearances';
    PageType = List;
    SourceTable = "CHM Goods Appearance";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the goods appearance code.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the goods appearance description.';
                }
            }
        }
    }
}
