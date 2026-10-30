tableextension 66606 "CHM Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        // Field ID must stay identical to Reservation Entry field 66600:
        // the base app copies between the two tables with TransferFields.
        field(66600; "CHM Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                LotProductionDateMgt: Codeunit "CHM Lot Production Date Mgt.";
            begin
                LotProductionDateMgt.CheckProductionDateAgainstLot(Rec."Item No.", Rec."Variant Code", Rec."Lot No.", Rec."CHM Production Date");
            end;
        }
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                LotProductionDateMgt: Codeunit "CHM Lot Production Date Mgt.";
                LotProductionDate: Date;
            begin
                if Rec."Lot No." = xRec."Lot No." then
                    exit;

                // Default the date from an existing lot; clear it when switching away from another lot.
                LotProductionDate := LotProductionDateMgt.GetLotProductionDate(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");
                if (LotProductionDate <> 0D) or (xRec."Lot No." <> '') then
                    Rec."CHM Production Date" := LotProductionDate;
            end;
        }
    }
}
