codeunit 66601 "CHM Lot Production Date Mgt."
{
    // DEV-004: Production Date on lot numbers.
    // Flow: Item Tracking Lines -> Reservation Entry -> Tracking Specification (TransferFields)
    //       -> Item Journal Line -> Item Ledger Entry -> Lot No. Information.

    var
        ProductionDateMismatchErr: Label 'Lot %1 of item %2 already has Production Date %3. To change it, update the Lot No. Information Card.', Comment = '%1 = Lot No., %2 = Item No., %3 = Production Date';

    procedure GetLotProductionDate(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]): Date
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNo = '' then
            exit(0D);
        if LotNoInformation.Get(ItemNo, VariantCode, LotNo) then
            exit(LotNoInformation."CHM Production Date");
        exit(0D);
    end;

    procedure CheckProductionDateAgainstLot(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]; ProductionDate: Date)
    var
        LotProductionDate: Date;
    begin
        if (LotNo = '') or (ProductionDate = 0D) then
            exit;
        LotProductionDate := GetLotProductionDate(ItemNo, VariantCode, LotNo);
        if (LotProductionDate <> 0D) and (LotProductionDate <> ProductionDate) then
            Error(ProductionDateMismatchErr, LotNo, ItemNo, LotProductionDate);
    end;

    local procedure UpdateLotNoInformation(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then begin
            if LotNoInformation."CHM Production Date" <> 0D then
                exit;
            LotNoInformation."CHM Production Date" := ItemLedgerEntry."CHM Production Date";
            LotNoInformation.Modify(true);
        end else begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := ItemLedgerEntry."Item No.";
            LotNoInformation."Variant Code" := ItemLedgerEntry."Variant Code";
            LotNoInformation."Lot No." := ItemLedgerEntry."Lot No.";
            LotNoInformation."CHM Production Date" := ItemLedgerEntry."CHM Production Date";
            LotNoInformation.Insert(true);
        end;
    end;

    // ---------- Item Tracking Lines -> Reservation Entry ----------

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure SetProductionDateOnNewReservEntry(var ReservEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        if ReservEntry."Entry No." = 0 then
            exit;
        if ReservEntry."CHM Production Date" = TrackingSpecification."CHM Production Date" then
            exit;
        if not ReservEntry.Find() then
            exit;
        ReservEntry."CHM Production Date" := TrackingSpecification."CHM Production Date";
        ReservEntry.Modify();
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure CompareProductionDate(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        // A change of Production Date alone must be registered, same as Expiration Date.
        IdenticalArray[2] := IdenticalArray[2] and (ReservEntry1."CHM Production Date" = ReservEntry2."CHM Production Date");
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure CopyProductionDateBetweenTrackingSpecs(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        DestTrkgSpec."CHM Production Date" := SourceTrackingSpec."CHM Production Date";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure MoveProductionDateToReservEntry(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        // Keeps all reservation entries of the same lot on the same Production Date.
        ReservEntry."CHM Production Date" := TrkgSpec."CHM Production Date";
    end;

    // ---------- Posting: Tracking Specification -> Item Journal Line -> Item Ledger Entry ----------

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure CopyProductionDateToItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemJournalLine."CHM Production Date" := TrackingSpecification."CHM Production Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CopyProductionDateToItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line")
    begin
        NewItemLedgEntry."CHM Production Date" := ItemJournalLine."CHM Production Date";
        // Outbound or untracked-date lines: take the date already stored on the lot.
        if NewItemLedgEntry."CHM Production Date" = 0D then
            NewItemLedgEntry."CHM Production Date" :=
              GetLotProductionDate(NewItemLedgEntry."Item No.", NewItemLedgEntry."Variant Code", NewItemLedgEntry."Lot No.");
    end;

    // ---------- Posting: Item Ledger Entry -> Lot No. Information ----------

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertItemLedgEntry', '', false, false)]
    local procedure UpdateLotNoInfoFromItemLedgEntry(var ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        if not ItemLedgerEntry.Positive then
            exit;
        if (ItemLedgerEntry."Lot No." = '') or (ItemLedgerEntry."CHM Production Date" = 0D) then
            exit;
        UpdateLotNoInformation(ItemLedgerEntry);
    end;
}
