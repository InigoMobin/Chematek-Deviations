tableextension 66606 "CHM Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        field(66600; "CHM Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CHMMgmt: Codeunit "CHM Customization Mgmt.";
            begin
                CHMMgmt.CheckProductionDateAgainstLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."CHM Production Date");
            end;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                CHMMgmt: Codeunit "CHM Customization Mgmt.";
                LotProductionDate: Date;
            begin
                if Rec."Lot No." = xRec."Lot No." then
                    exit;

                LotProductionDate := CHMMgmt.GetLotProductionDate(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");
                if (LotProductionDate <> 0D) or (xRec."Lot No." <> '') then
                    Rec."CHM Production Date" := LotProductionDate;
            end;
        }
    }
}
