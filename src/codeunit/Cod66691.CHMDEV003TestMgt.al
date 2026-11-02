codeunit 66691 "CHM DEV-003 Test Mgt."
{
    // TEST ONLY - DEV-003 Michelin printed labels demo data. Use in a sandbox; do not ship to production.
    // Called from page 66690 "CHM Deviation Test Console" (group DEV-003).
    //
    // Page 66601 "CHM Michelin Labels" loads posted sales shipments of Michelin customers with their lots,
    // so the demo data are REAL posted shipments:
    //   location CHMT3-LOC (no warehouse handling, ship-from address), tracking code CHMT3-LOT (lot),
    //   lot-tracked items CHMT3-ITEM1..3, untracked item CHMT3-ITEM4,
    //   Michelin customers CHMT3-MICH1 / CHMT3-MICH2 (with supplier code), non-Michelin customer CHMT3-OTHER,
    //   item journal batch CHMT3, label no. series CHMT3-MLBL (only if Michelin Label Nos. is blank).
    // Each run nn posts stock in lots CHMT3-Rnn-A1/A2/B1/B2/C1 (B2 without Production Date) and ships
    // sales orders CHMT3-Rnn-SO1..SO5:
    //   SO1 MICH1: 1 line with 2 lots, 2nd item, comment line, untracked item  -> 4 label lines
    //   SO2 MICH1: different ship-to address                                   -> 2 label lines
    //   SO3 MICH2: lot without Production Date                                 -> 4 label lines
    //   SO4 MICH2: shipped twice (2 shipments, same order)                     -> 1 + 1 label lines
    //   SO5 OTHER: non-Michelin customer, must not be offered on the page
    // Each step runs in its own transaction through a second instance, so one failing order
    // does not stop the others and the error text is shown in the results.

    trigger OnRun()
    begin
        case RunMode of
            RunModeSetup():
                RunSetup();
            RunModePostStock():
                PostStock();
            RunModeCreateOrder():
                CreateSalesOrder(RunIndex);
            RunModeShipOrder():
                ShipSalesOrder(RunDocNo);
            RunModeAddSecondLine():
                AddSecondShipmentLine(RunDocNo);
            RunModeDeleteOrder():
                DeleteSalesOrder(RunDocNo);
            RunModeDeleteJournal():
                DeleteJournal();
        end;
    end;

    var
        RunMode: Integer;
        RunIndex: Integer;
        RunDocNo: Code[20];
        RunNo: Integer;
        TemplateItemNo: Code[20];
        TemplateCustomerNo: Code[20];
        StepResultText: Text;
        StepCounter: Integer;
        ResultLinks: Dictionary of [Integer, Text];
        PendingLink: Text;
        CreateStepTok: Label 'DEV-003 CREATE', Locked = true;
        CheckStepTok: Label 'DEV-003 CHECK', Locked = true;
        DeleteStepTok: Label 'DEV-003 DELETE', Locked = true;
        PrefixTok: Label 'CHMT3-R', Locked = true;
        TestObjectPrefixTok: Label 'CHMT', Locked = true;
        LocationTok: Label 'CHMT3-LOC', Locked = true;
        TrackingCodeTok: Label 'CHMT3-LOT', Locked = true;
        Item1Tok: Label 'CHMT3-ITEM1', Locked = true;
        Item2Tok: Label 'CHMT3-ITEM2', Locked = true;
        Item3Tok: Label 'CHMT3-ITEM3', Locked = true;
        Item4Tok: Label 'CHMT3-ITEM4', Locked = true;
        Mich1Tok: Label 'CHMT3-MICH1', Locked = true;
        Mich2Tok: Label 'CHMT3-MICH2', Locked = true;
        OtherCustTok: Label 'CHMT3-OTHER', Locked = true;
        BatchTok: Label 'CHMT3', Locked = true;
        LabelSeriesTok: Label 'CHMT3-MLBL', Locked = true;
        PassTok: Label 'PASS', Locked = true;
        FailTok: Label 'FAIL', Locked = true;
        InfoTok: Label 'INFO', Locked = true;
        ViewTok: Label 'OPEN', Locked = true;
        CreateQst: Label 'This creates in company %1:\- location %2 with a ship-from address, 3 lot-tracked items and 1 item without tracking\- 2 Michelin customers and 1 non-Michelin customer\- stock in lots with Production Dates (item journal batch %3, posted)\- %4 sales orders, shipped straight away (one order is shipped twice)\\These are real posted documents. Continue?', Comment = '%1 = Company, %2 = Location, %3 = Batch, %4 = No. of orders';
        DeleteQst: Label 'Delete the open lines of item journal batch CHMT3 and the DEV-003 sales orders that were not shipped?\\Posted shipments, lots and master data are kept.';
        ProductionErr: Label 'Test data can only be created in a sandbox environment.';
        NoRunErr: Label 'No DEV-003 demo data found. Run "1. Create Demo Shipments" first.';
        TooManyRunsErr: Label 'All 99 DEV-003 run numbers are used.';
        BatchNotEmptyErr: Label 'Item journal batch %1 / %2 still has open lines from an earlier run. Use "Delete Open Test Data" first.', Comment = '%1 = Template, %2 = Batch';
        LocationSetupErr: Label 'Location %1 already exists but uses warehouse handling. Require Receive, Require Shipment, Require Put-away, Require Pick, Bin Mandatory and Directed Put-away and Pick must all be No.', Comment = '%1 = Location';
        TrackingCodeErr: Label 'Item Tracking Code %1 already exists but Lot Specific Tracking is off.', Comment = '%1 = Item Tracking Code';
        ItemTrackingErr: Label 'Item %1 already exists with Item Tracking Code %2. It needs %3.', Comment = '%1 = Item No., %2 = Current code, %3 = Expected code';
        ItemNoTrackingErr: Label 'Item %1 already exists with Item Tracking Code %2, but this test needs it without item tracking.', Comment = '%1 = Item No., %2 = Item Tracking Code';
        NoTemplateItemErr: Label 'No template item found. It must be an Inventory item without Item Tracking Code, not blocked, with Base Unit of Measure, Gen. Prod. and Inventory Posting Group. Enter one in Template Item No.';
        TrackedTemplateItemErr: Label 'Template item %1 has Item Tracking Code %2. Choose an item without item tracking.', Comment = '%1 = Item No., %2 = Item Tracking Code';
        NoTemplateCustomerErr: Label 'No template customer found. It must be not blocked, in local currency, with Customer Posting Group and Gen. Bus. Posting Group. Enter one in Template Customer No.';
        NoInvtPostingSetupErr: Label 'No Inventory Posting Setup with an Inventory Account found for posting group %1 to copy to location %2.', Comment = '%1 = Inventory Posting Group, %2 = Location';
        NoItemJnlTemplateErr: Label 'No Item Journal Template of type Item (not recurring) found.';
        NoReservEntryErr: Label 'The item tracking line for lot %1 on %2 was not created.', Comment = '%1 = Lot No., %2 = Source';
        NoLinkMsg: Label 'This result line has no page to open.';
        RecordGoneMsg: Label 'The %1 record no longer exists.', Comment = '%1 = Table caption';

    // =====================================================================
    // Public procedures used by page 66690
    // =====================================================================

    procedure SetTemplates(NewTemplateItemNo: Code[20]; NewTemplateCustomerNo: Code[20])
    begin
        TemplateItemNo := NewTemplateItemNo;
        TemplateCustomerNo := NewTemplateCustomerNo;
    end;

    procedure GetLocationCode(): Code[10]
    begin
        exit(LocationTok);
    end;

    procedure GetRunText(): Text
    var
        LastRunNo: Integer;
    begin
        LastRunNo := GetLastRunNo();
        if LastRunNo = 0 then
            exit('No demo data yet');
        exit(StrSubstNo('Run %1: sales orders %2 to %3', LastRunNo, RunPrefix(LastRunNo) + 'SO1', RunPrefix(LastRunNo) + 'SO' + Format(NoOfOrders())));
    end;

    procedure CreateTestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        EnvironmentInformation: Codeunit "Environment Information";
        ResultTxt: Text;
        SalesOrderNo: Code[20];
        Shipped: Integer;
        i: Integer;
    begin
        if EnvironmentInformation.IsSaaS() and EnvironmentInformation.IsProduction() then
            Error(ProductionErr);
        if GuiAllowed() then
            if not Confirm(CreateQst, true, CompanyName(), LocationTok, BatchTok, NoOfOrders()) then
                exit;

        ClearStepResults(TempResult, CreateStepTok);
        RunNo := GetLastRunNo() + 1;
        if RunNo > 99 then
            Error(TooManyRunsErr);

        if not RunStepWithResult(TempResult, CreateStepTok, 'Setup: location, items, Michelin customers, label no. series, journal batch', RunModeSetup(), 0, '') then
            exit;
        if not RunStepWithResult(TempResult, CreateStepTok, StrSubstNo('Stock: item journal %1 with lots and Production Dates, posted', DocNo('IN')), RunModePostStock(), 0, '') then
            exit;

        for i := 1 to NoOfOrders() do begin
            SalesOrderNo := OrderNo(i);
            if RunStep(RunModeCreateOrder(), i, '', ResultTxt) then begin
                AddResult(TempResult, CreateStepTok, StrSubstNo('Create sales order %1', SalesOrderNo), PassTok, ResultTxt);
                if RunStepWithResult(TempResult, CreateStepTok, StrSubstNo('Ship sales order %1', SalesOrderNo), RunModeShipOrder(), 0, SalesOrderNo) then begin
                    Shipped += 1;
                    if i = TwoShipmentsOrderIndex() then
                        if RunStepWithResult(TempResult, CreateStepTok, StrSubstNo('Add a second line to sales order %1', SalesOrderNo), RunModeAddSecondLine(), 0, SalesOrderNo) then
                            if RunStepWithResult(TempResult, CreateStepTok, StrSubstNo('Ship sales order %1 again (second shipment)', SalesOrderNo), RunModeShipOrder(), 0, SalesOrderNo) then
                                Shipped += 1;
                end;
            end else
                AddResult(TempResult, CreateStepTok, StrSubstNo('Create sales order %1', SalesOrderNo), FailTok, ResultTxt);
        end;

        AddDataViews(TempResult, CreateStepTok);
        AddResult(TempResult, CreateStepTok, 'Next step', InfoTok,
          StrSubstNo('Run %1: %2 posted sales shipment(s). Click "2. Open Michelin Labels" > Load Shipment Lines and pick the shipments of %3 and %4. The shipment of %5 must not be offered. "3. Check Demo Data" lists the label lines to expect per shipment.',
            RunNo, Shipped, Mich1Tok, Mich2Tok, OtherCustTok));
    end;

    procedure RunChecks(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShptHeader: Record "Sales Shipment Header";
        ShipmentCount: Integer;
        TotalLabelLines: Integer;
        i: Integer;
    begin
        RunNo := GetLastRunNo();
        if RunNo = 0 then
            Error(NoRunErr);
        ClearStepResults(TempResult, CheckStepTok);

        // A. Setup the Michelin labels page and report depend on.
        CheckCustomer(TempResult, Mich1Tok, true, SupplierCode(1));
        CheckCustomer(TempResult, Mich2Tok, true, SupplierCode(2));
        CheckCustomer(TempResult, OtherCustTok, false, '');

        SalesSetup.Get();
        AddCheck(TempResult, CheckStepTok, 'Sales & Receivables Setup: Michelin Label Nos.', SalesSetup."CHM Michelin Label Nos." <> '',
          StrSubstNo('No. series %1 gives the label serial no. (S) when printing.', SalesSetup."CHM Michelin Label Nos."),
          'Blank: Print labels stops with an error. Fill it in or run "1. Create Demo Shipments".');

        // B. Every posted shipment of the run and the lines the page will load for it.
        for i := 1 to NoOfOrders() do begin
            SalesShptHeader.Reset();
            SalesShptHeader.SetRange("Order No.", OrderNo(i));
            if SalesShptHeader.FindSet() then
                repeat
                    ShipmentCount += 1;
                    TotalLabelLines += CheckShipment(TempResult, SalesShptHeader, i <> NonMichelinOrderIndex());
                until SalesShptHeader.Next() = 0
            else
                AddResult(TempResult, CheckStepTok, StrSubstNo('Sales order %1', OrderNo(i)), FailTok,
                  'No posted sales shipment found. See the DEV-003 CREATE lines for the error.');
        end;

        AddResult(TempResult, CheckStepTok, 'Summary', InfoTok,
          StrSubstNo('Run %1: %2 posted shipment(s), %3 label line(s) in total. Load each Michelin shipment on the Michelin labels page and compare the "line(s) loaded" message with the lines above.',
            RunNo, ShipmentCount, TotalLabelLines));
    end;

    procedure OpenMichelinLabels()
    begin
        Page.Run(Page::"CHM Michelin Labels");
    end;

    procedure OpenPostedShipments()
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader.SetFilter("Order No.", PrefixTok + '*');
        Page.Run(Page::"Posted Sales Shipments", SalesShptHeader);
    end;

    procedure OpenSalesOrders()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", PrefixTok + '*');
        Page.Run(Page::"Sales Order List", SalesHeader);
    end;

    procedure DeleteTestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesOrderNos: List of [Code[20]];
        SalesOrderNo: Code[20];
        Kept: Integer;
    begin
        if GuiAllowed() then
            if not Confirm(DeleteQst, false) then
                exit;
        ClearStepResults(TempResult, DeleteStepTok);

        if JournalHasLines() then
            RunStepWithResult(TempResult, DeleteStepTok, StrSubstNo('Delete open lines of item journal batch %1', BatchTok), RunModeDeleteJournal(), 0, '');

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", PrefixTok + '*');
        if SalesHeader.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Quantity Shipped", '<>%1', 0);
                if SalesLine.IsEmpty() then
                    SalesOrderNos.Add(SalesHeader."No.")
                else
                    Kept += 1;
            until SalesHeader.Next() = 0;

        foreach SalesOrderNo in SalesOrderNos do
            RunStepWithResult(TempResult, DeleteStepTok, StrSubstNo('Delete sales order %1', SalesOrderNo), RunModeDeleteOrder(), 0, SalesOrderNo);

        AddResult(TempResult, DeleteStepTok, 'Summary', InfoTok,
          StrSubstNo('%1 unshipped sales order(s) processed, %2 shipped order(s) kept. Posted shipments, lots and master data are kept.', SalesOrderNos.Count(), Kept));
    end;

    procedure GetResultLinkCaption(ResultId: Integer): Text
    var
        LinkText: Text;
        Position: Text;
        TableNo: Integer;
    begin
        if not ResultLinks.Get(ResultId, LinkText) then
            exit('');
        SplitLink(LinkText, TableNo, Position);
        exit(TargetPageCaption(TableNo));
    end;

    procedure OpenResultRecord(ResultId: Integer)
    var
        Item: Record Item;
        Location: Record Location;
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        RecRef: RecordRef;
        LinkText: Text;
        Position: Text;
        TableNo: Integer;
    begin
        if not ResultLinks.Get(ResultId, LinkText) then begin
            Message(NoLinkMsg);
            exit;
        end;
        SplitLink(LinkText, TableNo, Position);
        RecRef.Open(TableNo);
        RecRef.SetPosition(Position);
        if not RecRef.Find('=') then begin
            Message(RecordGoneMsg, RecRef.Caption);
            exit;
        end;

        case TableNo of
            Database::Item:
                begin
                    RecRef.SetTable(Item);
                    Page.Run(Page::"Item Card", Item);
                end;
            Database::Location:
                begin
                    RecRef.SetTable(Location);
                    Page.Run(Page::"Location Card", Location);
                end;
            Database::Customer:
                begin
                    RecRef.SetTable(Customer);
                    Page.Run(Page::"Customer Card", Customer);
                end;
            Database::"Sales Header":
                begin
                    RecRef.SetTable(SalesHeader);
                    Page.Run(Page::"Sales Order", SalesHeader);
                end;
            Database::"Sales Shipment Header":
                begin
                    RecRef.SetTable(SalesShptHeader);
                    Page.Run(Page::"Posted Sales Shipment", SalesShptHeader);
                end;
            Database::"Item Ledger Entry":
                begin
                    RecRef.SetTable(ItemLedgerEntry);
                    ItemLedgerEntry.SetRange("Document No.", ItemLedgerEntry."Document No.");
                    Page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
                end;
            Database::"Lot No. Information":
                begin
                    RecRef.SetTable(LotNoInformation);
                    Page.Run(Page::"Lot No. Information Card", LotNoInformation);
                end;
            else
                Message(NoLinkMsg);
        end;
    end;

    procedure ClearResultLinks()
    begin
        Clear(ResultLinks);
        PendingLink := '';
    end;

    // Used by the second instance that runs each step in its own transaction.
    procedure SetContext(NewRunMode: Integer; NewIndex: Integer; NewDocNo: Code[20]; NewRunNo: Integer; NewTemplateItemNo: Code[20]; NewTemplateCustomerNo: Code[20])
    begin
        RunMode := NewRunMode;
        RunIndex := NewIndex;
        RunDocNo := NewDocNo;
        RunNo := NewRunNo;
        TemplateItemNo := NewTemplateItemNo;
        TemplateCustomerNo := NewTemplateCustomerNo;
    end;

    procedure GetStepResult(): Text
    begin
        exit(StepResultText);
    end;

    // =====================================================================
    // Steps (run inside OnRun)
    // =====================================================================

    local procedure RunSetup()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        TemplateItem: Record Item;
        TemplateCustomer: Record Customer;
        LabelNos: Code[20];
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Posted Shipment Nos.");
        LabelNos := EnsureLabelNoSeries();

        EnsureTrackingCode();
        EnsureLocation();

        FindTemplateItem(TemplateItem);
        EnsureItem(Item1Tok, 'CHM TEST EM GREASE LC2 HMC 180 KG DRUM', TemplateItem, true);
        EnsureItem(Item2Tok, 'CHM TEST SYNHYDRO ISODIO 6S 12 KG', TemplateItem, true);
        EnsureItem(Item3Tok, 'CHM TEST HYDROXYLAMMONIUM CHLORIDE 25 KG', TemplateItem, true);
        EnsureItem(Item4Tok, 'CHM TEST CROSSLAMINA CLORIDRATO (no lot)', TemplateItem, false);

        FindTemplateCustomer(TemplateCustomer);
        EnsureCustomer(Mich1Tok, 'CHM TEST MICHELIN ITALIANA SPA', true, SupplierCode(1),
          'Corso Romania 546', 'Torino', '10156', 'TO', TemplateCustomer);
        EnsureCustomer(Mich2Tok, 'CHM TEST HARRISON - AUSTRALIA', true, SupplierCode(2),
          '270 Berkshire Road', 'Forrestfield WA', '6058', 'WA', TemplateCustomer);
        EnsureCustomer(OtherCustTok, 'CHM TEST Non-Michelin Customer', false, '',
          'Via Roma 1', 'Milano', '20121', 'MI', TemplateCustomer);

        EnsureJournalBatch();
        CheckJournalEmpty();

        StepResultText := StrSubstNo('Location %1, items %2..%3 (template %4), Michelin customers %5 / %6, non-Michelin customer %7 (template %8), label no. series %9.',
            LocationTok, Item1Tok, Item4Tok, TemplateItem."No.", Mich1Tok, Mich2Tok, OtherCustTok, TemplateCustomer."No.", LabelNos);
    end;

    local procedure PostStock()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        CheckJournalEmpty();

        // Item 1: 2 lots
        CreateJnlLine(ItemJnlLine, Item1Tok, 160);
        AddJnlLot(ItemJnlLine, LotNo('A1'), 100, ProdDate('A1'));
        AddJnlLot(ItemJnlLine, LotNo('A2'), 60, ProdDate('A2'));
        // Item 2: 2 lots, B2 without Production Date (label prints 00.00.00)
        CreateJnlLine(ItemJnlLine, Item2Tok, 120);
        AddJnlLot(ItemJnlLine, LotNo('B1'), 80, ProdDate('B1'));
        AddJnlLot(ItemJnlLine, LotNo('B2'), 40, ProdDate('B2'));
        // Item 3: 1 lot
        CreateJnlLine(ItemJnlLine, Item3Tok, 200);
        AddJnlLot(ItemJnlLine, LotNo('C1'), 200, ProdDate('C1'));
        // Item 4: no item tracking
        CreateJnlLine(ItemJnlLine, Item4Tok, 50);

        FindJnlTemplate(ItemJnlTemplate);
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", BatchTok);
        ItemJnlLine.FindFirst();
        ItemJnlPostBatch.Run(ItemJnlLine);

        StepResultText :=
          StrSubstNo('Posted on %1: %2 lots A1 x100 (%3) + A2 x60 (%4); ', LocationTok, Item1Tok, DateText(ProdDate('A1')), DateText(ProdDate('A2'))) +
          StrSubstNo('%1 lots B1 x80 (%2) + B2 x40 (blank); ', Item2Tok, DateText(ProdDate('B1'))) +
          StrSubstNo('%1 lot C1 x200 (%2); %3 x50 without lot. Lot prefix %4.', Item3Tok, DateText(ProdDate('C1')), Item4Tok, RunPrefix(RunNo));
    end;

    local procedure CreateSalesOrder(i: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        CreateSalesHeader(SalesHeader, i);
        case i of
            1:
                begin
                    // 2 lots on one line, a second item, a comment line and an untracked item.
                    AddSalesLine(SalesHeader, 10000, Item1Tok, 40, SalesLine);
                    AddSalesLot(SalesLine, LotNo('A1'), 25);
                    AddSalesLot(SalesLine, LotNo('A2'), 15);
                    AddSalesLine(SalesHeader, 20000, Item2Tok, 10, SalesLine);
                    AddSalesLot(SalesLine, LotNo('B1'), 10);
                    AddCommentLine(SalesHeader, 30000, 'Comment line: must not be loaded on the Michelin labels page');
                    AddSalesLine(SalesHeader, 40000, Item4Tok, 4, SalesLine);
                    StepResultText := StrSubstNo('%1 / PO %2: %3 x40 (lots A1 x25 + A2 x15), %4 x10 (lot B1), comment line, %5 x4 without lot. Expected label lines: 4.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", Item1Tok, Item2Tok, Item4Tok);
                end;
            2:
                begin
                    // Different ship-to address than the customer card.
                    AddSalesLine(SalesHeader, 10000, Item3Tok, 100, SalesLine);
                    AddSalesLot(SalesLine, LotNo('C1'), 100);
                    AddSalesLine(SalesHeader, 20000, Item1Tok, 5, SalesLine);
                    AddSalesLot(SalesLine, LotNo('A1'), 5);
                    StepResultText := StrSubstNo('%1 / PO %2, ship-to %3: %4 x100 (lot C1), %5 x5 (lot A1). Expected label lines: 2.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", SalesHeader."Ship-to Name", Item3Tok, Item1Tok);
                end;
            3:
                begin
                    // Second Michelin customer, lot without Production Date.
                    AddSalesLine(SalesHeader, 10000, Item1Tok, 8, SalesLine);
                    AddSalesLot(SalesLine, LotNo('A2'), 8);
                    AddSalesLine(SalesHeader, 20000, Item2Tok, 15, SalesLine);
                    AddSalesLot(SalesLine, LotNo('B2'), 12);
                    AddSalesLot(SalesLine, LotNo('B1'), 3);
                    AddSalesLine(SalesHeader, 30000, Item3Tok, 20, SalesLine);
                    AddSalesLot(SalesLine, LotNo('C1'), 20);
                    StepResultText := StrSubstNo('%1 / PO %2: %3 x8 (lot A2), %4 x15 (lots B2 x12 without date + B1 x3), %5 x20 (lot C1). Expected label lines: 4.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", Item1Tok, Item2Tok, Item3Tok);
                end;
            4:
                begin
                    // First shipment only; AddSecondShipmentLine adds the line for the second shipment.
                    AddSalesLine(SalesHeader, 10000, Item1Tok, 6, SalesLine);
                    AddSalesLot(SalesLine, LotNo('A1'), 6);
                    StepResultText := StrSubstNo('%1 / PO %2: %3 x6 (lot A1) for the first shipment. Expected label lines: 1 per shipment.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", Item1Tok);
                end;
            5:
                begin
                    // Non-Michelin customer: the shipment must not be offered on the Michelin labels page.
                    AddSalesLine(SalesHeader, 10000, Item2Tok, 5, SalesLine);
                    AddSalesLot(SalesLine, LotNo('B1'), 5);
                    StepResultText := StrSubstNo('%1 (not a Michelin customer): %2 x5 (lot B1). Must not appear in Load Shipment Lines.',
                        SalesHeader."Sell-to Customer No.", Item2Tok);
                end;
        end;
    end;

    local procedure ShipSalesOrder(SalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo);
        SalesHeader.Ship := true;
        SalesHeader.Invoice := false;
        SalesPost.Run(SalesHeader);
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo);
        StepResultText := StrSubstNo('Shipped: Posted Sales Shipment %1.', SalesHeader."Last Shipping No.");
    end;

    local procedure AddSecondShipmentLine(SalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        // Sales-Post leaves the order released; a new line needs it open.
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo);
        if SalesHeader.Status <> SalesHeader.Status::Open then
            ReleaseSalesDoc.Reopen(SalesHeader);

        AddSalesLine(SalesHeader, 20000, Item3Tok, 30, SalesLine);
        AddSalesLot(SalesLine, LotNo('C1'), 30);
        StepResultText := StrSubstNo('Line 20000: %1 x30 (lot %2) added for the second shipment of the same order.', Item3Tok, LotNo('C1'));
    end;

    local procedure DeleteSalesOrder(SalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo);
        if SalesHeader.Status <> SalesHeader.Status::Open then
            ReleaseSalesDoc.Reopen(SalesHeader);
        SalesHeader.Delete(true);
        StepResultText := 'Deleted.';
    end;

    local procedure DeleteJournal()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        LineCount: Integer;
    begin
        FindJnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", BatchTok);
        LineCount := ItemJnlLine.Count();
        ItemJnlLine.DeleteAll(true);
        StepResultText := StrSubstNo('%1 line(s) and their item tracking deleted.', LineCount);
    end;

    // =====================================================================
    // Setup helpers
    // =====================================================================

    local procedure EnsureLabelNoSeries(): Code[20]
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        // Keep an existing setup; only fill a blank field so Print labels works in the sandbox.
        SalesSetup.Get();
        if SalesSetup."CHM Michelin Label Nos." <> '' then
            exit(SalesSetup."CHM Michelin Label Nos.");

        if not NoSeries.Get(LabelSeriesTok) then begin
            NoSeries.Init();
            NoSeries.Code := LabelSeriesTok;
            NoSeries.Description := 'CHM TEST Michelin label serial no.';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := LabelSeriesTok;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := '000000001';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert(true);
        end;

        SalesSetup."CHM Michelin Label Nos." := LabelSeriesTok;
        SalesSetup.Modify(true);
        exit(LabelSeriesTok);
    end;

    local procedure EnsureTrackingCode()
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        if ItemTrackingCode.Get(TrackingCodeTok) then begin
            if not ItemTrackingCode."Lot Specific Tracking" then
                Error(TrackingCodeErr, TrackingCodeTok);
            exit;
        end;

        ItemTrackingCode.Init();
        ItemTrackingCode.Code := TrackingCodeTok;
        ItemTrackingCode.Description := 'CHM TEST Lot tracking DEV-003';
        ItemTrackingCode.Insert(true);
        ItemTrackingCode.Validate("Lot Specific Tracking", true);
        ItemTrackingCode.Modify(true);
    end;

    local procedure EnsureLocation()
    var
        Location: Record Location;
        CompanyInformation: Record "Company Information";
    begin
        if Location.Get(LocationTok) then begin
            if Location."Require Receive" or Location."Require Shipment" or Location."Require Put-away" or Location."Require Pick" or
               Location."Bin Mandatory" or Location."Directed Put-away and Pick"
            then
                Error(LocationSetupErr, LocationTok);
        end else begin
            Location.Init();
            Location.Code := LocationTok;
            Location.Insert(true);
        end;

        // The Michelin labels page uses the location address as Ship-from.
        CompanyInformation.Get();
        Location.Name := 'CHEMATEK S.P.A. (CHM TEST DEV-003)';
        Location.Address := 'Via Puccini 18';
        Location.City := 'San Vittore Olona';
        Location."Post Code" := '20028';
        Location.County := 'MI';
        Location."Country/Region Code" := CompanyInformation."Country/Region Code";
        Location.Modify(true);
    end;

    local procedure FindTemplateItem(var TemplateItem: Record Item)
    begin
        if TemplateItemNo <> '' then begin
            TemplateItem.Get(TemplateItemNo);
            if TemplateItem."Item Tracking Code" <> '' then
                Error(TrackedTemplateItemErr, TemplateItem."No.", TemplateItem."Item Tracking Code");
            TemplateItem.TestField(Type, TemplateItem.Type::Inventory);
            TemplateItem.TestField("Base Unit of Measure");
            TemplateItem.TestField("Gen. Prod. Posting Group");
            TemplateItem.TestField("Inventory Posting Group");
            exit;
        end;

        TemplateItem.SetRange(Type, TemplateItem.Type::Inventory);
        TemplateItem.SetRange("Item Tracking Code", '');
        TemplateItem.SetRange(Blocked, false);
        TemplateItem.SetRange("Sales Blocked", false);
        TemplateItem.SetFilter("Base Unit of Measure", '<>%1', '');
        TemplateItem.SetFilter("Gen. Prod. Posting Group", '<>%1', '');
        TemplateItem.SetFilter("Inventory Posting Group", '<>%1', '');
        if TemplateItem.FindSet() then
            repeat
                if not IsTestObject(TemplateItem."No.") then
                    exit;
            until TemplateItem.Next() = 0;
        Error(NoTemplateItemErr);
    end;

    local procedure FindTemplateCustomer(var TemplateCustomer: Record Customer)
    begin
        if TemplateCustomerNo <> '' then begin
            TemplateCustomer.Get(TemplateCustomerNo);
            TemplateCustomer.TestField(Blocked, TemplateCustomer.Blocked::" ");
            TemplateCustomer.TestField("Customer Posting Group");
            TemplateCustomer.TestField("Gen. Bus. Posting Group");
            exit;
        end;

        TemplateCustomer.SetRange(Blocked, TemplateCustomer.Blocked::" ");
        TemplateCustomer.SetRange("Currency Code", '');
        TemplateCustomer.SetFilter("Customer Posting Group", '<>%1', '');
        TemplateCustomer.SetFilter("Gen. Bus. Posting Group", '<>%1', '');
        if TemplateCustomer.FindSet() then
            repeat
                if not IsTestObject(TemplateCustomer."No.") then
                    exit;
            until TemplateCustomer.Next() = 0;
        Error(NoTemplateCustomerErr);
    end;

    local procedure IsTestObject(No: Code[20]): Boolean
    begin
        exit(CopyStr(No, 1, StrLen(TestObjectPrefixTok)) = TestObjectPrefixTok);
    end;

    local procedure EnsureItem(ItemNo: Code[20]; ItemDescription: Text[100]; TemplateItem: Record Item; LotTracked: Boolean)
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then begin
            Item.Init();
            Item."No." := ItemNo;
            Item.Insert(true);
            Item.Validate(Description, ItemDescription);
            Item.Validate(Type, Item.Type::Inventory);
            Item.Validate("Base Unit of Measure", TemplateItem."Base Unit of Measure");
            Item.Validate("Gen. Prod. Posting Group", TemplateItem."Gen. Prod. Posting Group");
            Item.Validate("VAT Prod. Posting Group", TemplateItem."VAT Prod. Posting Group");
            Item.Validate("Inventory Posting Group", TemplateItem."Inventory Posting Group");
            Item."Tax Group Code" := TemplateItem."Tax Group Code";
            Item.Validate("Costing Method", Item."Costing Method"::FIFO);
            Item.Validate("Unit Price", 100);
            Item."Unit Cost" := 50;
            Item.Modify(true);
        end;

        if LotTracked then begin
            if Item."Item Tracking Code" <> TrackingCodeTok then begin
                if Item."Item Tracking Code" <> '' then
                    Error(ItemTrackingErr, ItemNo, Item."Item Tracking Code", TrackingCodeTok);
                Item.Validate("Item Tracking Code", TrackingCodeTok);
                Item.Modify(true);
            end;
        end else
            if Item."Item Tracking Code" <> '' then
                Error(ItemNoTrackingErr, ItemNo, Item."Item Tracking Code");

        EnsureInventoryPostingSetup(LocationTok, Item."Inventory Posting Group");
    end;

    local procedure EnsureInventoryPostingSetup(LocationCode: Code[10]; InvtPostingGroupCode: Code[20])
    var
        InvtPostingSetup: Record "Inventory Posting Setup";
        TemplateSetup: Record "Inventory Posting Setup";
    begin
        if InvtPostingSetup.Get(LocationCode, InvtPostingGroupCode) then
            exit;

        TemplateSetup.SetRange("Invt. Posting Group Code", InvtPostingGroupCode);
        TemplateSetup.SetFilter("Inventory Account", '<>%1', '');
        TemplateSetup.SetRange("Location Code", '');
        if not TemplateSetup.FindFirst() then begin
            TemplateSetup.SetRange("Location Code");
            if not TemplateSetup.FindFirst() then
                Error(NoInvtPostingSetupErr, InvtPostingGroupCode, LocationCode);
        end;

        InvtPostingSetup := TemplateSetup;
        InvtPostingSetup."Location Code" := LocationCode;
        InvtPostingSetup.Insert(true);
    end;

    local procedure EnsureCustomer(CustomerNo: Code[20]; CustomerName: Text[100]; IsMichelin: Boolean; NewSupplierCode: Code[20]; NewAddress: Text[100]; NewCity: Text[30]; NewPostCode: Code[20]; NewCounty: Text[30]; TemplateCustomer: Record Customer)
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(CustomerNo) then begin
            Customer.Init();
            Customer."No." := CustomerNo;
            Customer.Insert(true);
            Customer.Validate(Name, CustomerName);
            // Country stays the template's so VAT and posting setup still match.
            Customer."Country/Region Code" := TemplateCustomer."Country/Region Code";
            Customer.Validate("Customer Posting Group", TemplateCustomer."Customer Posting Group");
            Customer.Validate("Gen. Bus. Posting Group", TemplateCustomer."Gen. Bus. Posting Group");
            Customer.Validate("VAT Bus. Posting Group", TemplateCustomer."VAT Bus. Posting Group");
            Customer."Tax Area Code" := TemplateCustomer."Tax Area Code";
            Customer."Tax Liable" := TemplateCustomer."Tax Liable";
            Customer."Payment Terms Code" := TemplateCustomer."Payment Terms Code";
            Customer."Payment Method Code" := TemplateCustomer."Payment Method Code";
            Customer."Prices Including VAT" := TemplateCustomer."Prices Including VAT";
        end;

        Customer.Address := NewAddress;
        Customer.City := NewCity;
        Customer."Post Code" := NewPostCode;
        Customer.County := NewCounty;
        Customer."CHM Michelin Customer" := IsMichelin;
        Customer."CHM Michelin Supplier Code" := NewSupplierCode;
        Customer.Modify(true);
    end;

    local procedure FindJnlTemplate(var ItemJnlTemplate: Record "Item Journal Template")
    begin
        ItemJnlTemplate.SetRange(Type, ItemJnlTemplate.Type::Item);
        ItemJnlTemplate.SetRange(Recurring, false);
        if not ItemJnlTemplate.FindFirst() then
            Error(NoItemJnlTemplateErr);
    end;

    local procedure EnsureJournalBatch()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        FindJnlTemplate(ItemJnlTemplate);
        if not ItemJnlBatch.Get(ItemJnlTemplate.Name, BatchTok) then begin
            ItemJnlBatch.Init();
            ItemJnlBatch."Journal Template Name" := ItemJnlTemplate.Name;
            ItemJnlBatch.Name := BatchTok;
            ItemJnlBatch.Description := 'CHM TEST DEV-003';
            ItemJnlBatch.Insert(true);
        end;

        // Manual document numbers are used, so the batch must not have number series.
        if (ItemJnlBatch."No. Series" <> '') or (ItemJnlBatch."Posting No. Series" <> '') then begin
            ItemJnlBatch."No. Series" := '';
            ItemJnlBatch."Posting No. Series" := '';
            ItemJnlBatch.Modify(true);
        end;
    end;

    local procedure JournalHasLines(): Boolean
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
    begin
        FindJnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", BatchTok);
        exit(not ItemJnlLine.IsEmpty());
    end;

    local procedure CheckJournalEmpty()
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        FindJnlTemplate(ItemJnlTemplate);
        if JournalHasLines() then
            Error(BatchNotEmptyErr, ItemJnlTemplate.Name, BatchTok);
    end;

    // =====================================================================
    // Document helpers
    // =====================================================================

    local procedure CreateJnlLine(var ItemJnlLine: Record "Item Journal Line"; ItemNo: Code[20]; Qty: Decimal)
    var
        ItemJnlTemplate: Record "Item Journal Template";
        LastItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
    begin
        FindJnlTemplate(ItemJnlTemplate);
        LastItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        LastItemJnlLine.SetRange("Journal Batch Name", BatchTok);
        if LastItemJnlLine.FindLast() then
            LineNo := LastItemJnlLine."Line No.";
        LineNo += 10000;

        Clear(ItemJnlLine);
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := ItemJnlTemplate.Name;
        ItemJnlLine."Journal Batch Name" := BatchTok;
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine.Insert(true);
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Document No." := DocNo('IN');
        ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Location Code", LocationTok);
        ItemJnlLine.Validate(Quantity, Qty);
        ItemJnlLine.Validate("Unit Amount", 10);
        ItemJnlLine.Modify(true);
    end;

    local procedure AddJnlLot(ItemJnlLine: Record "Item Journal Line"; NewLotNo: Code[50]; QtyBase: Decimal; ProductionDate: Date)
    begin
        AddLot(Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name",
          ItemJnlLine."Line No.", ItemJnlLine."Qty. per Unit of Measure", ItemJnlLine."Item No.", ItemJnlLine."Location Code",
          NewLotNo, QtyBase, ProductionDate, ItemJnlLine."Posting Date", 0D, "Reservation Status"::Prospect);
    end;

    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; i: Integer)
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader."No." := OrderNo(i);
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", OrderCustomer(i));
        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Shipment Date", WorkDate());
        SalesHeader.Validate("Location Code", LocationTok);
        // The Michelin labels page shows External Document No. as Michelin Purch. Order.
        SalesHeader."External Document No." := MichelinPO(i);
        if i = 2 then begin
            SalesHeader."Ship-to Name" := 'MICHELIN - CUNEO PLANT';
            SalesHeader."Ship-to Address" := 'Via Ravina 2';
            SalesHeader."Ship-to City" := 'Cuneo';
            SalesHeader."Ship-to Post Code" := '12100';
            SalesHeader."Ship-to County" := 'CN';
        end;
        SalesHeader.Modify(true);
    end;

    local procedure AddSalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; ItemNo: Code[20]; Qty: Decimal; var SalesLine: Record "Sales Line")
    begin
        Clear(SalesLine);
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := LineNo;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate("Location Code", LocationTok);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Validate("Unit Price", 100);
        SalesLine.Modify(true);
    end;

    local procedure AddCommentLine(SalesHeader: Record "Sales Header"; LineNo: Integer; CommentText: Text[100])
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := LineNo;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::" ");
        SalesLine.Description := CommentText;
        SalesLine.Modify(true);
    end;

    local procedure AddSalesLot(SalesLine: Record "Sales Line"; NewLotNo: Code[50]; QtyBase: Decimal)
    begin
        // Production Date left blank: posting takes it from the lot (DEV-004).
        AddLot(Database::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", '', SalesLine."Line No.",
          SalesLine."Qty. per Unit of Measure", SalesLine."No.", SalesLine."Location Code", NewLotNo, QtyBase, 0D, 0D, SalesLine."Shipment Date", "Reservation Status"::Surplus);
    end;

    local procedure AddLot(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer; QtyPerUoM: Decimal; ItemNo: Code[20]; LocationCode: Code[10]; NewLotNo: Code[50]; QtyBase: Decimal; ProductionDate: Date; ExpectedReceiptDate: Date; ShipmentDate: Date; Status: Enum "Reservation Status")
    var
        ForReservEntry: Record "Reservation Entry";
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        // Same records the Item Tracking Lines page creates for a lot line.
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;
        ForReservEntry.Init();
        ForReservEntry."Lot No." := NewLotNo;
        CreateReservEntry.CreateReservEntryFor(SourceType, SourceSubtype, SourceID, SourceBatchName, 0, SourceRefNo, QtyPerUoM, QtyBase / QtyPerUoM, QtyBase, ForReservEntry);
        CreateReservEntry.CreateEntry(ItemNo, '', LocationCode, '', ExpectedReceiptDate, ShipmentDate, 0, Status);

        // Production Date column of the Item Tracking Lines (DEV-004 field 66600 on Reservation Entry).
        ReservEntry.SetRange("Source Type", SourceType);
        ReservEntry.SetRange("Source Subtype", SourceSubtype);
        ReservEntry.SetRange("Source ID", SourceID);
        ReservEntry.SetRange("Source Batch Name", SourceBatchName);
        ReservEntry.SetRange("Source Ref. No.", SourceRefNo);
        ReservEntry.SetRange("Lot No.", NewLotNo);
        if ReservEntry.IsEmpty() then
            Error(NoReservEntryErr, NewLotNo, SourceID);
        ReservEntry.ModifyAll("CHM Production Date", ProductionDate);
    end;

    // =====================================================================
    // Checks and views
    // =====================================================================

    local procedure CheckCustomer(var TempResult: Record "Name/Value Buffer" temporary; CustomerNo: Code[20]; ExpectMichelin: Boolean; ExpectedSupplierCode: Code[20])
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(CustomerNo) then begin
            AddResult(TempResult, CheckStepTok, StrSubstNo('Customer %1', CustomerNo), FailTok, 'Customer not found.');
            exit;
        end;
        SetResultLink(Customer);
        AddCheck(TempResult, CheckStepTok, StrSubstNo('Customer %1: Michelin Customer = %2', CustomerNo, ExpectMichelin),
          (Customer."CHM Michelin Customer" = ExpectMichelin) and (Customer."CHM Michelin Supplier Code" = ExpectedSupplierCode),
          StrSubstNo('%1, Michelin Supplier Code "%2".', Customer.Name, Customer."CHM Michelin Supplier Code"),
          StrSubstNo('Michelin Customer = %1 (expected %2), Supplier Code "%3" (expected "%4").',
            Customer."CHM Michelin Customer", ExpectMichelin, Customer."CHM Michelin Supplier Code", ExpectedSupplierCode));
    end;

    local procedure CheckShipment(var TempResult: Record "Name/Value Buffer" temporary; SalesShptHeader: Record "Sales Shipment Header"; ExpectMichelin: Boolean) LabelLines: Integer
    var
        SalesShptLine: Record "Sales Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Details: Text;
        LotQty: Decimal;
        QtyMismatch: Boolean;
    begin
        SalesShptHeader.CalcFields("CHM Michelin Customer");
        SetResultLink(SalesShptHeader);
        if not ExpectMichelin then begin
            AddCheck(TempResult, CheckStepTok, StrSubstNo('Shipment %1 (order %2): NOT offered on Load Shipment Lines', SalesShptHeader."No.", SalesShptHeader."Order No."),
              not SalesShptHeader."CHM Michelin Customer",
              StrSubstNo('Customer %1 is not a Michelin customer, so the shipment is filtered out.', SalesShptHeader."Sell-to Customer No."),
              StrSubstNo('Michelin Customer is Yes for customer %1.', SalesShptHeader."Sell-to Customer No."));
            exit(0);
        end;

        AddCheck(TempResult, CheckStepTok, StrSubstNo('Shipment %1 (order %2): offered on Load Shipment Lines', SalesShptHeader."No.", SalesShptHeader."Order No."),
          SalesShptHeader."CHM Michelin Customer",
          StrSubstNo('Customer %1, Michelin PO %2, ship-to %3, %4.', SalesShptHeader."Sell-to Customer No.", SalesShptHeader."External Document No.",
            SalesShptHeader."Ship-to Name", SalesShptHeader."Ship-to City"),
          StrSubstNo('Michelin Customer is No for customer %1.', SalesShptHeader."Sell-to Customer No."));

        // Same lines the page loads: item lines, not corrections, quantity <> 0, one label line per lot.
        SalesShptLine.SetRange("Document No.", SalesShptHeader."No.");
        SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
        SalesShptLine.SetRange(Correction, false);
        SalesShptLine.SetFilter(Quantity, '<>0');
        if SalesShptLine.FindSet() then
            repeat
                LotQty := 0;
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
                ItemLedgerEntry.SetRange("Document No.", SalesShptLine."Document No.");
                ItemLedgerEntry.SetRange("Document Line No.", SalesShptLine."Line No.");
                ItemLedgerEntry.SetRange("Item No.", SalesShptLine."No.");
                if ItemLedgerEntry.FindSet() then
                    repeat
                        LabelLines += 1;
                        LotQty += Abs(ItemLedgerEntry.Quantity);
                        if ItemLedgerEntry."Lot No." <> '' then
                            Details += StrSubstNo('%1 lot %2 x%3 (prod. %4); ', SalesShptLine."No.", ItemLedgerEntry."Lot No.", Abs(ItemLedgerEntry.Quantity), DateText(ItemLedgerEntry."CHM Production Date"))
                        else
                            Details += StrSubstNo('%1 no lot x%2; ', SalesShptLine."No.", Abs(ItemLedgerEntry.Quantity));
                    until ItemLedgerEntry.Next() = 0
                else begin
                    LabelLines += 1;
                    LotQty := SalesShptLine."Quantity (Base)";
                    Details += StrSubstNo('%1 no lot x%2; ', SalesShptLine."No.", SalesShptLine.Quantity);
                end;
                if LotQty <> SalesShptLine."Quantity (Base)" then
                    QtyMismatch := true;
            until SalesShptLine.Next() = 0;

        SetResultLink(SalesShptHeader);
        AddCheck(TempResult, CheckStepTok, StrSubstNo('Shipment %1: label lines to expect', SalesShptHeader."No."),
          (LabelLines > 0) and (not QtyMismatch),
          StrSubstNo('%1 line(s): %2', LabelLines, Details),
          StrSubstNo('Lot quantities do not add up to the shipment lines (or no lines). %1', Details));
    end;

    local procedure AddDataViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        Customer: Record Customer;
        Location: Record Location;
        SalesShptHeader: Record "Sales Shipment Header";
        i: Integer;
    begin
        if Location.Get(LocationTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Location %1 (Ship-from)', Location.Code),
              StrSubstNo('%1, %2, %3 %4.', Location.Name, Location.Address, Location."Post Code", Location.City), Location);
        if Customer.Get(Mich1Tok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Michelin customer %1', Customer."No."),
              StrSubstNo('%1, supplier code %2.', Customer.Name, Customer."CHM Michelin Supplier Code"), Customer);
        if Customer.Get(Mich2Tok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Michelin customer %1', Customer."No."),
              StrSubstNo('%1, supplier code %2.', Customer.Name, Customer."CHM Michelin Supplier Code"), Customer);
        if Customer.Get(OtherCustTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Non-Michelin customer %1', Customer."No."), Customer.Name, Customer);

        for i := 1 to NoOfOrders() do begin
            SalesShptHeader.Reset();
            SalesShptHeader.SetRange("Order No.", OrderNo(i));
            if SalesShptHeader.FindSet() then
                repeat
                    AddViewRow(TempResult, StepCode, StrSubstNo('Posted sales shipment %1 (order %2)', SalesShptHeader."No.", SalesShptHeader."Order No."),
                      StrSubstNo('Customer %1, Michelin PO %2, ship-to %3.', SalesShptHeader."Sell-to Customer No.", SalesShptHeader."External Document No.", SalesShptHeader."Ship-to Name"),
                      SalesShptHeader);
                until SalesShptHeader.Next() = 0;
        end;
    end;

    local procedure GetLastRunNo() LastRunNo: Integer
    var
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Run numbers come from the test orders, their shipments and the posted lots.
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", PrefixTok + '*');
        if SalesHeader.FindSet() then
            repeat
                KeepHigherRunNo(LastRunNo, SalesHeader."No.");
            until SalesHeader.Next() = 0;

        SalesShptHeader.SetFilter("Order No.", PrefixTok + '*');
        if SalesShptHeader.FindSet() then
            repeat
                KeepHigherRunNo(LastRunNo, SalesShptHeader."Order No.");
            until SalesShptHeader.Next() = 0;

        ItemLedgerEntry.SetRange("Item No.", Item1Tok);
        ItemLedgerEntry.SetFilter("Lot No.", PrefixTok + '*');
        if ItemLedgerEntry.FindSet() then
            repeat
                KeepHigherRunNo(LastRunNo, ItemLedgerEntry."Lot No.");
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure KeepHigherRunNo(var LastRunNo: Integer; Value: Text)
    var
        Number: Integer;
    begin
        if Evaluate(Number, CopyStr(Value, StrLen(PrefixTok) + 1, 2)) then
            if Number > LastRunNo then
                LastRunNo := Number;
    end;

    // =====================================================================
    // Demo data definition
    // =====================================================================

    local procedure RunPrefix(TestRunNo: Integer): Text
    begin
        // e.g. CHMT3-R01-
        exit(PrefixTok + Format(TestRunNo, 0, '<Integer,2><Filler Character,0>') + '-');
    end;

    local procedure DocNo(Suffix: Text): Code[20]
    begin
        // e.g. CHMT3-R01-IN, CHMT3-R01-SO1
        exit(CopyStr(RunPrefix(RunNo) + Suffix, 1, 20));
    end;

    local procedure OrderNo(i: Integer): Code[20]
    begin
        exit(DocNo('SO' + Format(i)));
    end;

    local procedure LotNo(Suffix: Text): Code[50]
    begin
        // e.g. CHMT3-R01-A1
        exit(CopyStr(RunPrefix(RunNo) + Suffix, 1, 50));
    end;

    local procedure ProdDate(LotSuffix: Text): Date
    begin
        case LotSuffix of
            'A1':
                exit(CalcDate('<-40D>', WorkDate()));
            'A2':
                exit(CalcDate('<-25D>', WorkDate()));
            'B1':
                exit(CalcDate('<-60D>', WorkDate()));
            'C1':
                exit(CalcDate('<-15D>', WorkDate()));
        end;
        exit(0D); // B2: no Production Date
    end;

    local procedure MichelinPO(i: Integer): Code[35]
    begin
        // e.g. MPO-450001-0003 (run 1, order 3)
        exit(CopyStr('MPO-45' + Format(RunNo, 0, '<Integer,4><Filler Character,0>') + '-' + Format(i, 0, '<Integer,4><Filler Character,0>'), 1, 35));
    end;

    local procedure OrderCustomer(i: Integer): Code[20]
    begin
        case i of
            1, 2:
                exit(Mich1Tok);
            3, 4:
                exit(Mich2Tok);
        end;
        exit(OtherCustTok);
    end;

    local procedure SupplierCode(CustomerIndex: Integer): Code[20]
    begin
        if CustomerIndex = 1 then
            exit('020061');
        exit('020062');
    end;

    local procedure NoOfOrders(): Integer
    begin
        exit(5);
    end;

    local procedure TwoShipmentsOrderIndex(): Integer
    begin
        exit(4);
    end;

    local procedure NonMichelinOrderIndex(): Integer
    begin
        exit(5);
    end;

    local procedure DateText(Value: Date): Text
    begin
        if Value = 0D then
            exit('blank');
        exit(Format(Value));
    end;

    // =====================================================================
    // Step runner and result helpers
    // =====================================================================

    local procedure RunStep(StepMode: Integer; Index: Integer; StepDocNo: Code[20]; var ResultTxt: Text): Boolean
    var
        Runner: Codeunit "CHM DEV-003 Test Mgt.";
    begin
        Runner.SetContext(StepMode, Index, StepDocNo, RunNo, TemplateItemNo, TemplateCustomerNo);
        Commit();
        ClearLastError();
        if Runner.Run() then begin
            ResultTxt := Runner.GetStepResult();
            exit(true);
        end;
        ResultTxt := GetLastErrorText();
        exit(false);
    end;

    local procedure RunStepWithResult(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; StepMode: Integer; Index: Integer; StepDocNo: Code[20]): Boolean
    var
        ResultTxt: Text;
    begin
        if RunStep(StepMode, Index, StepDocNo, ResultTxt) then begin
            AddResult(TempResult, StepCode, Description, PassTok, ResultTxt);
            exit(true);
        end;
        AddResult(TempResult, StepCode, Description, FailTok, ResultTxt);
        exit(false);
    end;

    local procedure ClearStepResults(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    begin
        TempResult.Reset();
        TempResult.SetFilter(Name, StepCode + '*');
        TempResult.DeleteAll();
        TempResult.Reset();
        StepCounter := 0;
    end;

    local procedure AddCheck(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; Passed: Boolean; PassDetails: Text; FailDetails: Text)
    begin
        if Passed then
            AddResult(TempResult, StepCode, Description, PassTok, PassDetails)
        else
            AddResult(TempResult, StepCode, Description, FailTok, FailDetails);
    end;

    local procedure AddViewRow(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; Details: Text; RecVariant: Variant)
    begin
        SetResultLink(RecVariant);
        AddResult(TempResult, StepCode, Description, ViewTok, Details);
    end;

    local procedure AddResult(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; Status: Text; Details: Text)
    var
        NextId: Integer;
    begin
        StepCounter += 1;
        TempResult.Reset();
        if TempResult.FindLast() then
            NextId := TempResult.ID + 1
        else
            NextId := 1;

        TempResult.Init();
        TempResult.ID := NextId;
        TempResult.Name := CopyStr(StrSubstNo('%1 T%2 %3', StepCode, Format(StepCounter, 0, '<Integer,2><Filler Character,0>'), Description), 1, MaxStrLen(TempResult.Name));
        TempResult.Value := CopyStr(Status, 1, MaxStrLen(TempResult.Value));
        TempResult."Value Long" := CopyStr(Details, 1, MaxStrLen(TempResult."Value Long"));
        TempResult.Insert();

        // Result IDs can be reused after results are cleared, so always overwrite or remove the link.
        if PendingLink <> '' then
            ResultLinks.Set(NextId, PendingLink)
        else
            if ResultLinks.ContainsKey(NextId) then
                ResultLinks.Remove(NextId);
        PendingLink := '';
    end;

    local procedure SetResultLink(RecVariant: Variant)
    var
        RecRef: RecordRef;
    begin
        // The next AddResult stores this record against its result line.
        RecRef.GetTable(RecVariant);
        PendingLink := Format(RecRef.Number) + '|' + RecRef.GetPosition(false);
    end;

    local procedure SplitLink(LinkText: Text; var TableNo: Integer; var Position: Text)
    var
        SeparatorPos: Integer;
    begin
        SeparatorPos := StrPos(LinkText, '|');
        Evaluate(TableNo, CopyStr(LinkText, 1, SeparatorPos - 1));
        Position := CopyStr(LinkText, SeparatorPos + 1);
    end;

    local procedure TargetPageCaption(TableNo: Integer): Text
    begin
        case TableNo of
            Database::Item:
                exit('Item Card');
            Database::Location:
                exit('Location Card');
            Database::Customer:
                exit('Customer Card');
            Database::"Sales Header":
                exit('Sales Order');
            Database::"Sales Shipment Header":
                exit('Posted Sales Shipment');
            Database::"Item Ledger Entry":
                exit('Item Ledger Entries');
            Database::"Lot No. Information":
                exit('Lot No. Information Card');
        end;
        exit('Open');
    end;

    // =====================================================================
    // Run modes
    // =====================================================================

    local procedure RunModeSetup(): Integer
    begin
        exit(1);
    end;

    local procedure RunModePostStock(): Integer
    begin
        exit(2);
    end;

    local procedure RunModeCreateOrder(): Integer
    begin
        exit(3);
    end;

    local procedure RunModeShipOrder(): Integer
    begin
        exit(4);
    end;

    local procedure RunModeAddSecondLine(): Integer
    begin
        exit(5);
    end;

    local procedure RunModeDeleteOrder(): Integer
    begin
        exit(6);
    end;

    local procedure RunModeDeleteJournal(): Integer
    begin
        exit(7);
    end;
}
