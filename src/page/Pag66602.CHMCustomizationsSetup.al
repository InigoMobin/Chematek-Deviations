page 66602 "CHM Customizations Setup"
{
    Caption = 'Chematek Customizations Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CHM Customizations Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(ReportLogos)
            {
                Caption = 'Report Logos';

                field("Right Header Logo"; Rec."Right Header Logo")
                {
                    ToolTip = 'Specifies the logo printed at the top right of the sales documents. The print area is about 47 x 17 mm; the picture is scaled to fit.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Footer Logo"; Rec."Footer Logo")
                {
                    ToolTip = 'Specifies the banner printed at the bottom of the sales documents. The print area is about 164 x 19 mm; the picture is scaled to fit.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("ISO 9001 Logo"; Rec."ISO 9001 Logo")
                {
                    ToolTip = 'Specifies the ISO 9001 certification logo printed in the footer of the sales documents. The print area is about 12 x 11 mm.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("ASSICC Logo"; Rec."ASSICC Logo")
                {
                    ToolTip = 'Specifies the ASSICC logo printed in the footer of the sales documents. The print area is about 12 x 11 mm.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Show ISO"; Rec."Show ISO")
                {
                    ToolTip = 'Specifies whether the ISO certification text (certificate number and revision) is printed in the footer of the sales documents.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
