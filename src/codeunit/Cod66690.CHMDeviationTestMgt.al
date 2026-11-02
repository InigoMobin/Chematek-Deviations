codeunit 66690 "CHM Deviation Test Mgt."
{
    // TEST ONLY - DEV-002 and DEV-004 test harness. Use in a sandbox; do not ship to production.
    //
    // DEV-002:
    // Creates REAL, postable warehouse shipments WITH LINES:
    //   test location CHMT2-WH (Require Shipment, no pick, no bins) + warehouse employee for the current user
    //   2 test items + 1 test customer (posting groups copied from a template item / customer)
    //   stock posted with an item journal (positive adjustment)
    //   released sales orders CHMT2-Rxx-nnn (2 lines each) -> warehouse shipments created by the standard
    //   "Create Whse. Shipment" logic, Qty. to Ship filled, and the 7 DEV-002 fields filled.
    // After posting, the tests check Warehouse Shipment -> Posted Whse. Shipment -> Posted Sales Shipment
    // for the header fields and the lines.
    //
    // DEV-004 (Production Date on lot numbers):
    //   tracking code CHMT4-LOT, location CHMT4-LOC (no warehouse handling), lot-tracked item CHMT4-ITEM1,
    //   vendor CHMT4-VEND, customer CHMT4-CUST, item journal batch CHMT4. Each run uses lots CHMT4-Rnn-L1..L4.
    //   Inbound: item journal (L1 15-10-2026, L2 20-10-2026, L4 28-10-2026 on an existing blank lot card)
    //            + purchase order (L3 25-10-2026). Production Dates are stored on the item tracking lines.
    //   Outbound: lot card L2 changed to 21-10-2026, item journal (L1 with blank date, L2 with the new date)
    //            + sales order for L1 with blank date.
    //   The tests check Item Tracking Lines -> Item Ledger Entry -> Lot No. Information and the field rules.

    trigger OnRun()
    begin
        // Each step runs in its own transaction through a second instance, so one failing order
        // does not stop the others and the error text is shown in the results.
        case RunMode of
            RunModeSetup():
                RunSetup();
            RunModeCreateShipment():
                CreateOneShipment(RunIndex);
            RunModePostShipment():
                PostOneShipment(RunDocNo);
            RunModeDeleteShipment():
                DeleteOneShipment(RunDocNo);
            RunModeDeleteOrder():
                DeleteOneOrder(RunDocNo);
            RunModeDev4Setup():
                RunDev4Setup();
            RunModeDev4CreateInbound():
                CreateDev4InboundJournal();
            RunModeDev4CreatePurchOrder():
                CreateDev4PurchOrder();
            RunModeDev4PostJournal():
                PostDev4Journal();
            RunModeDev4PostPurchOrder():
                PostDev4PurchOrder(RunDocNo);
            RunModeDev4CreateOutboundJnl():
                CreateDev4OutboundJournal();
            RunModeDev4CreateSalesOrder():
                CreateDev4SalesOrder();
            RunModeDev4PostSalesOrder():
                PostDev4SalesOrder(RunDocNo);
            RunModeDev4DeleteJournal():
                DeleteDev4Journal();
            RunModeDev4DeletePurchOrder():
                DeleteDev4PurchOrder(RunDocNo);

            RunModeDev3Setup():
                RunDev3Setup();
            RunModeDev3PostStock():
                PostDev3Stock();
            RunModeDev3CreateOrder():
                CreateDev3SalesOrder(RunIndex);
            RunModeDev3AddSecondLine():
                AddDev3SecondShipmentLine(RunDocNo);
            RunModeDev3DeleteJournal():
                DeleteDev3Journal();
        end;
    end;

    var
        Dev3CreateStepTok: Label 'DEV-003 CREATE', Locked = true;
        Dev3CheckStepTok: Label 'DEV-003 CHECK', Locked = true;
        Dev3DeleteStepTok: Label 'DEV-003 DELETE', Locked = true;
        Dev3PrefixTok: Label 'CHMT3-R', Locked = true;
        Dev3LocationTok: Label 'CHMT3-LOC', Locked = true;
        Dev3Item1Tok: Label 'CHMT3-ITEM1', Locked = true;
        Dev3Item2Tok: Label 'CHMT3-ITEM2', Locked = true;
        Dev3Item3Tok: Label 'CHMT3-ITEM3', Locked = true;
        Dev3Item4Tok: Label 'CHMT3-ITEM4', Locked = true;
        Dev3Mich1Tok: Label 'CHMT3-MICH1', Locked = true;
        Dev3Mich2Tok: Label 'CHMT3-MICH2', Locked = true;
        Dev3OtherCustTok: Label 'CHMT3-OTHER', Locked = true;
        Dev3BatchTok: Label 'CHMT3', Locked = true;
        Dev3LabelSeriesTok: Label 'CHMT3-MLBL', Locked = true;
        Dev3CreateQst: Label 'This creates in company %1:\- location %2 with a ship-from address, 3 lot-tracked items and 1 item without tracking\- 2 Michelin customers and 1 non-Michelin customer\- stock in lots with Production Dates (item journal batch %3, posted)\- %4 sales orders, shipped straight away (one order is shipped twice)\\These are real posted documents. Continue?', Comment = '%1 = Company, %2 = Location, %3 = Batch, %4 = No. of orders';
        Dev3DeleteQst: Label 'Delete the open lines of item journal batch CHMT3 and the DEV-003 sales orders that were not shipped?\\Posted shipments, lots and master data are kept.';
        Dev3NoRunErr: Label 'No DEV-003 demo data found. Run "1. Create Demo Shipments" first.';
        Dev3TooManyRunsErr: Label 'All 99 DEV-003 run numbers are used.';
        Dev3BatchNotEmptyErr: Label 'Item journal batch %1 / %2 still has open lines from an earlier run. Use "Delete Open Test Data" first.', Comment = '%1 = Template, %2 = Batch';
        Dev3ItemTrackingErr: Label 'Item %1 already exists with Item Tracking Code %2, but this test needs it without item tracking.', Comment = '%1 = Item No., %2 = Item Tracking Code';
        RunMode: Integer;
        RunIndex: Integer;
        RunDocNo: Code[20];
        RunNo: Integer;
        RunNoOfShipments: Integer;
        TemplateItemNo: Code[20];
        TemplateCustomerNo: Code[20];
        StepResultText: Text;
        DevTestCounter: Integer;
        CreateStepTok: Label 'DEV-002 CREATE', Locked = true;
        PostStepTok: Label 'DEV-002 POST', Locked = true;
        TestStepTok: Label 'DEV-002 TEST', Locked = true;
        DeleteStepTok: Label 'DEV-002 DELETE', Locked = true;
        OrderPrefixTok: Label 'CHMT2-R', Locked = true;
        TestLocationTok: Label 'CHMT2-WH', Locked = true;
        TestCustomerTok: Label 'CHMT2-CUST', Locked = true;
        TestItem1Tok: Label 'CHMT2-ITEM1', Locked = true;
        TestItem2Tok: Label 'CHMT2-ITEM2', Locked = true;
        GoodsAppPrefixTok: Label 'CHMT-GA', Locked = true;
        PassTok: Label 'PASS', Locked = true;
        FailTok: Label 'FAIL', Locked = true;
        WarnTok: Label 'WARN', Locked = true;
        InfoTok: Label 'INFO', Locked = true;
        CreateQst: Label 'This creates in company %1:\- test location %2 with you as warehouse employee\- 2 test items and 1 test customer\- stock for the items (item journal posting)\- %3 released sales orders with warehouse shipments (2 lines each)\\These are real documents. Continue?', Comment = '%1 = Company, %2 = Location, %3 = No. of shipments';
        PostQst: Label 'Post (Ship only) %1 open test warehouse shipment(s) on location %2?', Comment = '%1 = Count, %2 = Location';
        DeleteQst: Label 'Delete the open test warehouse shipments on location %1 and the test sales orders that were not shipped?\\Posted documents, items, customer and location are kept.', Comment = '%1 = Location';
        ProductionErr: Label 'Test data can only be created in a sandbox environment.';
        NoOfShipmentsErr: Label 'No. of Shipments must be between 1 and 50.';
        NoTestDataErr: Label 'No DEV-002 test shipments found on location %1. Run "1. Create Test Data" first.', Comment = '%1 = Location';
        TooManyRunsErr: Label 'All 99 test run numbers are used. Delete old CHMT2 sales orders first.';
        NoWhseShipmentErr: Label 'No warehouse shipment was created for sales order %1. Check that location %2 has Require Shipment and the order is released.', Comment = '%1 = Order No., %2 = Location';
        NoShipmentLinesErr: Label 'Warehouse shipment %1 has no lines.', Comment = '%1 = Shipment No.';
        LocationSetupErr: Label 'Location %1 already exists but is not set up for this test. It needs Require Shipment = Yes, and Require Pick, Bin Mandatory and Directed Put-away and Pick = No.', Comment = '%1 = Location';
        NoTemplateItemErr: Label 'No template item found. It must be an Inventory item without Item Tracking Code, not blocked, with Base Unit of Measure, Gen. Prod. and Inventory Posting Group. Enter one in Template Item No.';
        TrackedTemplateItemErr: Label 'Template item %1 has Item Tracking Code %2. Choose an item without item tracking, otherwise the shipment needs item tracking lines before posting.', Comment = '%1 = Item No., %2 = Item Tracking Code';
        NoTemplateCustomerErr: Label 'No template customer found. It must be not blocked, in local currency, with Customer Posting Group and Gen. Bus. Posting Group. Enter one in Template Customer No.';
        NoInvtPostingSetupErr: Label 'No Inventory Posting Setup with an Inventory Account found for posting group %1 to copy to location %2.', Comment = '%1 = Inventory Posting Group, %2 = Location';
        ErrorAsExpectedTxt: Label 'Error raised as expected: %1', Comment = '%1 = Error text';
        NoErrorRaisedTxt: Label 'No error was raised, but one was expected.';
        AcceptedTxt: Label 'Value accepted.';
        TemplateVendorNo: Code[20];
        ResultLinks: Dictionary of [Integer, Text];
        PendingLink: Text;
        ViewTok: Label 'OPEN', Locked = true;
        Dev4FlowStepTok: Label 'DEV-004 FLOW', Locked = true;
        NoLinkMsg: Label 'This result line has no page to open.';
        RecordGoneMsg: Label 'The %1 record no longer exists. It was posted or deleted. Use "Show Process Flow" to see the current data.', Comment = '%1 = Table caption';
        // DEV-004 Production Date on lot numbers
        Dev4CreateStepTok: Label 'DEV-004 CREATE-IN', Locked = true;
        Dev4PostInStepTok: Label 'DEV-004 POST-IN', Locked = true;
        Dev4CreateOutStepTok: Label 'DEV-004 CREATE-OUT', Locked = true;
        Dev4PostOutStepTok: Label 'DEV-004 POST-OUT', Locked = true;
        Dev4TestStepTok: Label 'DEV-004 TEST', Locked = true;
        Dev4DeleteStepTok: Label 'DEV-004 DELETE', Locked = true;
        Dev4PrefixTok: Label 'CHMT4-R', Locked = true;
        Dev4LocationTok: Label 'CHMT4-LOC', Locked = true;
        Dev4ItemTok: Label 'CHMT4-ITEM1', Locked = true;
        Dev4TrackingCodeTok: Label 'CHMT4-LOT', Locked = true;
        Dev4CustomerTok: Label 'CHMT4-CUST', Locked = true;
        Dev4VendorTok: Label 'CHMT4-VEND', Locked = true;
        Dev4BatchTok: Label 'CHMT4', Locked = true;
        Dev4CreateQst: Label 'This creates in company %1:\- item tracking code %2 (lot), location %3 without warehouse handling, lot-tracked item %4, a test vendor and customer\- item journal batch %5 with lines for lots L1, L2 and L4 and their Production Dates on the item tracking lines\- a purchase order for lot L3\\These are real documents. Continue?', Comment = '%1 = Company, %2 = Item Tracking Code, %3 = Location, %4 = Item, %5 = Batch';
        Dev4PostInQst: Label 'Post the test item journal and receive the test purchase order of run %1?', Comment = '%1 = Run No.';
        Dev4CreateOutQst: Label 'Run %1: change the Production Date of lot %2 on the Lot No. Information card to %3, create 2 item journal lines (lots %4 and %2) and a sales order for lot %4. Continue?', Comment = '%1 = Run No., %2 = Lot 2, %3 = Date, %4 = Lot 1';
        Dev4PostOutQst: Label 'Post the test item journal and ship the test sales order of run %1?', Comment = '%1 = Run No.';
        Dev4DeleteQst: Label 'Delete the open lines of the test item journal and the DEV-004 test purchase and sales orders that were not received or shipped?\\Posted entries, lots and master data are kept.';
        Dev4NoRunErr: Label 'No DEV-004 test run found. Run "1. Create Test Data" first.';
        Dev4TooManyRunsErr: Label 'All 99 DEV-004 test run numbers are used.';
        Dev4BatchNotEmptyErr: Label 'Item journal batch %1 / %2 still has open lines. Post them ("2. Post Inbound" or "4. Post Outbound") or delete them ("Delete Open Test Data") first.', Comment = '%1 = Template, %2 = Batch';
        Dev4InboundNotPostedErr: Label 'Lot %1 has not been received yet. Post the inbound documents first ("2. Post Inbound").', Comment = '%1 = Lot No.';
        Dev4OutboundExistsErr: Label 'The outbound documents of run %1 already exist. Use "4. Post Outbound", or start a new run with "1. Create Test Data".', Comment = '%1 = Run No.';
        Dev4LocationSetupErr: Label 'Location %1 already exists but uses warehouse handling. Require Receive, Require Shipment, Require Put-away, Require Pick, Bin Mandatory and Directed Put-away and Pick must all be No.', Comment = '%1 = Location';
        Dev4TrackingCodeErr: Label 'Item Tracking Code %1 already exists but Lot Specific Tracking is off.', Comment = '%1 = Item Tracking Code';
        Dev4ItemTrackingErr: Label 'Item %1 already exists with Item Tracking Code %2. It needs %3.', Comment = '%1 = Item, %2 = Current code, %3 = Expected code';
        NoItemJnlTemplateErr: Label 'No Item Journal Template of type Item (not recurring) found.';
        NoTemplateVendorErr: Label 'No template vendor found. It must be not blocked, in local currency, with Vendor Posting Group and Gen. Bus. Posting Group, and General Posting Setup must exist for it with Gen. Prod. Posting Group %1. Enter one in Template Vendor No.', Comment = '%1 = Gen. Prod. Posting Group';
        Dev4NoReservEntryErr: Label 'The item tracking line for lot %1 on %2 was not created.', Comment = '%1 = Lot No., %2 = Source';

    // =====================================================================
    // Public procedures used by page 66690
    // =====================================================================

    procedure SetTemplates(NewTemplateItemNo: Code[20]; NewTemplateCustomerNo: Code[20]; NewTemplateVendorNo: Code[20])
    begin
        TemplateItemNo := NewTemplateItemNo;
        TemplateCustomerNo := NewTemplateCustomerNo;
        TemplateVendorNo := NewTemplateVendorNo;
    end;

    procedure GetTestLocationCode(): Code[10]
    begin
        exit(TestLocationTok);
    end;

    procedure CreateDev002TestData(var TempResult: Record "Name/Value Buffer" temporary; NoOfShipments: Integer)
    var
        EnvironmentInformation: Codeunit "Environment Information";
        ResultTxt: Text;
        Created: Integer;
        i: Integer;
    begin
        if (NoOfShipments < 1) or (NoOfShipments > 50) then
            Error(NoOfShipmentsErr);
        if EnvironmentInformation.IsSaaS() and EnvironmentInformation.IsProduction() then
            Error(ProductionErr);
        if GuiAllowed() then
            if not Confirm(CreateQst, true, CompanyName(), TestLocationTok, NoOfShipments) then
                exit;

        ClearStepResults(TempResult, CreateStepTok);
        RunNo := GetNextRunNo();
        RunNoOfShipments := NoOfShipments;

        // Step 1: master data, setup and stock.
        if not RunStep(RunModeSetup(), 0, '', ResultTxt) then begin
            AddResult(TempResult, CreateStepTok, 'Setup: location, items, customer, stock', FailTok, ResultTxt);
            exit;
        end;
        AddResult(TempResult, CreateStepTok, 'Setup: location, items, customer, stock', PassTok, ResultTxt);

        // Step 2: one released sales order + warehouse shipment with lines per record.
        for i := 1 to NoOfShipments do
            if RunStep(RunModeCreateShipment(), i, '', ResultTxt) then begin
                Created += 1;
                AddResult(TempResult, CreateStepTok, StrSubstNo('Sales order %1 -> warehouse shipment', OrderNo(RunNo, i)), PassTok, ResultTxt);
            end else
                AddResult(TempResult, CreateStepTok, StrSubstNo('Sales order %1 -> warehouse shipment', OrderNo(RunNo, i)), FailTok, ResultTxt);

        AddResult(TempResult, CreateStepTok, 'Next step', InfoTok,
          StrSubstNo('%1 of %2 warehouse shipments created on location %3 (run %4). Open one with "2. Open Warehouse Shipments" and post it (Post Shipment), or use "3. Post Test Shipments". Then "4. Run Tests".',
            Created, NoOfShipments, TestLocationTok, RunNo));
    end;

    procedure PostDev002TestShipments(var TempResult: Record "Name/Value Buffer" temporary)
    var
        ShipmentNos: List of [Code[20]];
        ShipmentNo: Code[20];
        ResultTxt: Text;
        Posted: Integer;
    begin
        GetOpenTestShipments(ShipmentNos, true);
        ClearStepResults(TempResult, PostStepTok);
        if ShipmentNos.Count() = 0 then begin
            AddResult(TempResult, PostStepTok, 'Post test shipments', InfoTok,
              StrSubstNo('No open warehouse shipment with Qty. to Ship on location %1. Run "1. Create Test Data" first.', TestLocationTok));
            exit;
        end;
        if GuiAllowed() then
            if not Confirm(PostQst, true, ShipmentNos.Count(), TestLocationTok) then
                exit;

        foreach ShipmentNo in ShipmentNos do
            if RunStep(RunModePostShipment(), 0, ShipmentNo, ResultTxt) then begin
                Posted += 1;
                AddResult(TempResult, PostStepTok, StrSubstNo('Post warehouse shipment %1', ShipmentNo), PassTok, ResultTxt);
            end else
                AddResult(TempResult, PostStepTok, StrSubstNo('Post warehouse shipment %1', ShipmentNo), FailTok, ResultTxt);

        AddResult(TempResult, PostStepTok, 'Next step', InfoTok,
          StrSubstNo('%1 of %2 shipments posted. Click "4. Run Tests" to check the flow to the posted documents.', Posted, ShipmentNos.Count()));
    end;

    procedure RunDev002Tests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        RecRef: RecordRef;
        FirstOpenNo: Code[20];
        OpenCount: Integer;
        PostedCount: Integer;
    begin
        WhseShptHeader.SetRange("Location Code", TestLocationTok);
        PostedWhseShptHeader.SetRange("Location Code", TestLocationTok);
        if WhseShptHeader.IsEmpty() and PostedWhseShptHeader.IsEmpty() then
            Error(NoTestDataErr, TestLocationTok);

        ClearStepResults(TempResult, TestStepTok);

        // A. Open warehouse shipments: lines present and ready to post, 7 fields filled.
        if WhseShptHeader.FindSet() then
            repeat
                OpenCount += 1;
                if FirstOpenNo = '' then
                    FirstOpenNo := WhseShptHeader."No.";
                TestOpenShipment(TempResult, WhseShptHeader);
            until WhseShptHeader.Next() = 0;

        // B. Field validation on the Warehouse Shipment (in memory only, nothing is saved).
        if FirstOpenNo <> '' then begin
            WhseShptHeader.Get(FirstOpenNo);
            RecRef.GetTable(WhseShptHeader);
            RunShipmentValidationTests(TempResult, RecRef);
            RecRef.GetTable(WhseShptHeader);
            RunNegativeValueTests(TempResult, RecRef);
        end else
            AddResult(TempResult, TestStepTok, 'Field validation', InfoTok, 'Skipped: no open test warehouse shipment left. Create test data to run the validation tests.');

        // C. The 3 tables must carry identical fields, otherwise the copy on posting breaks.
        CheckSameFieldDefinition(TempResult, TestStepTok, Database::"Warehouse Shipment Header", Database::"Posted Whse. Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());
        CheckSameFieldDefinition(TempResult, TestStepTok, Database::"Warehouse Shipment Header", Database::"Sales Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());

        // D. Posted shipments: header fields and lines flowed to Posted Whse. Shipment and Posted Sales Shipment.
        PostedCount := CheckPostedTestShipments(TempResult);

        AddResult(TempResult, TestStepTok, 'Summary', InfoTok,
          StrSubstNo('%1 open and %2 posted test warehouse shipment(s) checked on location %3.', OpenCount, PostedCount, TestLocationTok));
        if PostedCount = 0 then
            AddResult(TempResult, TestStepTok, 'Posting flow', InfoTok,
              'Nothing posted yet. Post a test warehouse shipment (manually or with "3. Post Test Shipments") and run the tests again.');
    end;

    procedure OpenDev002WhseShipments()
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        WhseShptHeader.SetRange("Location Code", TestLocationTok);
        Page.Run(Page::"Warehouse Shipment List", WhseShptHeader);
    end;

    procedure OpenDev002PostedWhseShipments()
    var
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
    begin
        PostedWhseShptHeader.SetRange("Location Code", TestLocationTok);
        Page.Run(Page::"Posted Whse. Shipment List", PostedWhseShptHeader);
    end;

    procedure OpenDev002PostedSalesShipments()
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader.SetFilter("Order No.", OrderPrefixTok + '*');
        Page.Run(Page::"Posted Sales Shipments", SalesShptHeader);
    end;

    procedure DeleteDev002TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ShipmentNos: List of [Code[20]];
        OrderNos: List of [Code[20]];
        DocNo: Code[20];
        ResultTxt: Text;
        KeptOrders: Integer;
    begin
        if GuiAllowed() then
            if not Confirm(DeleteQst, true, TestLocationTok) then
                exit;
        ClearStepResults(TempResult, DeleteStepTok);

        // 1. Open warehouse shipments first, otherwise the sales orders cannot be deleted.
        GetOpenTestShipments(ShipmentNos, false);
        foreach DocNo in ShipmentNos do
            if RunStep(RunModeDeleteShipment(), 0, DocNo, ResultTxt) then
                AddResult(TempResult, DeleteStepTok, StrSubstNo('Delete warehouse shipment %1', DocNo), PassTok, ResultTxt)
            else
                AddResult(TempResult, DeleteStepTok, StrSubstNo('Delete warehouse shipment %1', DocNo), FailTok, ResultTxt);

        // 2. Test sales orders that were never shipped. Shipped orders stay (they have posted entries).
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", OrderPrefixTok + '*');
        if SalesHeader.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetFilter("Quantity Shipped", '<>%1', 0);
                if SalesLine.IsEmpty() then
                    OrderNos.Add(SalesHeader."No.")
                else
                    KeptOrders += 1;
            until SalesHeader.Next() = 0;

        foreach DocNo in OrderNos do
            if RunStep(RunModeDeleteOrder(), 0, DocNo, ResultTxt) then
                AddResult(TempResult, DeleteStepTok, StrSubstNo('Delete sales order %1', DocNo), PassTok, ResultTxt)
            else
                AddResult(TempResult, DeleteStepTok, StrSubstNo('Delete sales order %1', DocNo), FailTok, ResultTxt);

        AddResult(TempResult, DeleteStepTok, 'Summary', InfoTok,
          StrSubstNo('%1 warehouse shipment(s) and %2 sales order(s) processed. %3 shipped order(s) kept. Posted documents, items, customer and location are kept so the posting checks still work.',
            ShipmentNos.Count(), OrderNos.Count(), KeptOrders));
    end;

    // =====================================================================
    // DEV-004 Production Date on lot numbers - public procedures used by page 66690
    // =====================================================================

    procedure GetDev004LocationCode(): Code[10]
    begin
        exit(Dev4LocationTok);
    end;

    procedure GetDev004ItemNo(): Code[20]
    begin
        exit(Dev4ItemTok);
    end;

    procedure GetDev004RunText(): Text
    var
        LastRunNo: Integer;
    begin
        LastRunNo := GetDev004LastRunNo();
        if LastRunNo = 0 then
            exit('No test run yet');
        exit(StrSubstNo('Run %1: lots %2 to %3', LastRunNo, Dev4LotNo(LastRunNo, 1), Dev4LotNo(LastRunNo, 4)));
    end;

    procedure CreateDev004TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        if EnvironmentInformation.IsSaaS() and EnvironmentInformation.IsProduction() then
            Error(ProductionErr);
        if GuiAllowed() then
            if not Confirm(Dev4CreateQst, true, CompanyName(), Dev4TrackingCodeTok, Dev4LocationTok, Dev4ItemTok, Dev4BatchTok) then
                exit;

        ClearStepResults(TempResult, Dev4CreateStepTok);
        RunNo := GetDev004LastRunNo() + 1;
        if RunNo > 99 then
            Error(Dev4TooManyRunsErr);

        if not RunDev4Step(TempResult, Dev4CreateStepTok, 'Setup: tracking code, location, item, vendor, customer, journal batch', RunModeDev4Setup(), '') then
            exit;
        if not RunDev4Step(TempResult, Dev4CreateStepTok,
             StrSubstNo('Item journal %1: lots %2, %3 and %4 with Production Dates', Dev4DocNo('IN'), Dev4LotNo(RunNo, 1), Dev4LotNo(RunNo, 2), Dev4LotNo(RunNo, 4)),
             RunModeDev4CreateInbound(), '')
        then
            exit;
        RunDev4Step(TempResult, Dev4CreateStepTok, StrSubstNo('Purchase order %1: lot %2 with Production Date', Dev4DocNo('PO'), Dev4LotNo(RunNo, 3)),
          RunModeDev4CreatePurchOrder(), '');

        AddDev4SetupViews(TempResult, Dev4CreateStepTok);
        AddDev4CreateViews(TempResult, Dev4CreateStepTok);
        AddResult(TempResult, Dev4CreateStepTok, 'Next step', InfoTok,
          StrSubstNo('Run %1 created. Click the Page column on the OPEN lines to see each record and its Item Tracking Lines with the Production Date. Post the documents yourself or use "2. Post Inbound".', RunNo));
    end;

    procedure PostDev004Inbound(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        RunNo := GetDev004LastRunNo();
        if RunNo = 0 then
            Error(Dev4NoRunErr);
        if GuiAllowed() then
            if not Confirm(Dev4PostInQst, true, RunNo) then
                exit;
        ClearStepResults(TempResult, Dev4PostInStepTok);

        if Dev4JournalHasLines() then
            RunDev4Step(TempResult, Dev4PostInStepTok, StrSubstNo('Post item journal batch %1', Dev4BatchTok), RunModeDev4PostJournal(), '')
        else
            AddResult(TempResult, Dev4PostInStepTok, 'Post item journal', InfoTok, 'No open lines in the test journal (already posted?).');

        if Dev4PurchOrderOutstanding(Dev4DocNo('PO')) then
            RunDev4Step(TempResult, Dev4PostInStepTok, StrSubstNo('Receive purchase order %1', Dev4DocNo('PO')), RunModeDev4PostPurchOrder(), Dev4DocNo('PO'))
        else
            AddResult(TempResult, Dev4PostInStepTok, 'Receive purchase order', InfoTok, StrSubstNo('Purchase order %1 has nothing left to receive.', Dev4DocNo('PO')));

        AddDev4InboundViews(TempResult, Dev4PostInStepTok);
        AddResult(TempResult, Dev4PostInStepTok, 'Next step', InfoTok,
          'Click the Page column on the OPEN lines to see the posted receipt, item ledger entries and lot cards with the Production Date. Then "3. Create Outbound" or "5. Run Tests".');
    end;

    procedure CreateDev004Outbound(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        RunNo := GetDev004LastRunNo();
        if RunNo = 0 then
            Error(Dev4NoRunErr);
        if not Dev4IleExists(Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('IN')) then
            Error(Dev4InboundNotPostedErr, Dev4LotNo(RunNo, 1));
        if Dev4OutboundCreated() then
            Error(Dev4OutboundExistsErr, RunNo);
        if GuiAllowed() then
            if not Confirm(Dev4CreateOutQst, true, RunNo, Dev4LotNo(RunNo, 2), Dev4ChangedLot2Date(), Dev4LotNo(RunNo, 1)) then
                exit;
        ClearStepResults(TempResult, Dev4CreateOutStepTok);

        if not RunDev4Step(TempResult, Dev4CreateOutStepTok,
             StrSubstNo('Lot card %1 changed to %2 + item journal %3 (lot %4 x20 with blank date, lot %1 x5)', Dev4LotNo(RunNo, 2), Dev4ChangedLot2Date(), Dev4DocNo('ADJ2'), Dev4LotNo(RunNo, 1)),
             RunModeDev4CreateOutboundJnl(), '')
        then
            exit;
        RunDev4Step(TempResult, Dev4CreateOutStepTok, StrSubstNo('Sales order %1: lot %2 x10, Production Date left blank', Dev4DocNo('SO'), Dev4LotNo(RunNo, 1)),
          RunModeDev4CreateSalesOrder(), '');

        AddDev4OutboundCreateViews(TempResult, Dev4CreateOutStepTok);
        AddResult(TempResult, Dev4CreateOutStepTok, 'Next step', InfoTok,
          'Click the Page column on the OPEN lines to see the changed lot card, the journal and the sales order with their Item Tracking Lines. Post them yourself or use "4. Post Outbound".');
    end;

    procedure PostDev004Outbound(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        RunNo := GetDev004LastRunNo();
        if RunNo = 0 then
            Error(Dev4NoRunErr);
        if GuiAllowed() then
            if not Confirm(Dev4PostOutQst, true, RunNo) then
                exit;
        ClearStepResults(TempResult, Dev4PostOutStepTok);

        if Dev4JournalHasLines() then
            RunDev4Step(TempResult, Dev4PostOutStepTok, StrSubstNo('Post item journal batch %1', Dev4BatchTok), RunModeDev4PostJournal(), '')
        else
            AddResult(TempResult, Dev4PostOutStepTok, 'Post item journal', InfoTok, 'No open lines in the test journal (already posted, or "3. Create Outbound" not run yet).');

        if Dev4SalesOrderOutstanding(Dev4DocNo('SO')) then
            RunDev4Step(TempResult, Dev4PostOutStepTok, StrSubstNo('Ship sales order %1', Dev4DocNo('SO')), RunModeDev4PostSalesOrder(), Dev4DocNo('SO'))
        else
            AddResult(TempResult, Dev4PostOutStepTok, 'Ship sales order', InfoTok, StrSubstNo('Sales order %1 has nothing left to ship (or does not exist yet).', Dev4DocNo('SO')));

        AddDev4OutboundPostedViews(TempResult, Dev4PostOutStepTok);
        AddResult(TempResult, Dev4PostOutStepTok, 'Next step', InfoTok,
          'Click the Page column on the OPEN lines to see the posted shipment, item ledger entries and lot cards. Then "5. Run Tests".');
    end;

    procedure RunDev004Tests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        InboundPosted: Boolean;
        PurchPosted: Boolean;
        OutboundJnlPosted: Boolean;
        SalePosted: Boolean;
        Lot2ExpectedDate: Date;
    begin
        RunNo := GetDev004LastRunNo();
        if RunNo = 0 then
            Error(Dev4NoRunErr);
        ClearStepResults(TempResult, Dev4TestStepTok);

        // A. Production Date field (66600) must be identical on all tables: Reservation Entry and
        //    Tracking Specification are copied with TransferFields during posting.
        CheckSameFieldDefinition(TempResult, Dev4TestStepTok, Database::"Reservation Entry", Database::"Tracking Specification", 66600, 66600);
        CheckSameFieldDefinition(TempResult, Dev4TestStepTok, Database::"Reservation Entry", Database::"Item Journal Line", 66600, 66600);
        CheckSameFieldDefinition(TempResult, Dev4TestStepTok, Database::"Reservation Entry", Database::"Item Ledger Entry", 66600, 66600);
        CheckSameFieldDefinition(TempResult, Dev4TestStepTok, Database::"Reservation Entry", Database::"Lot No. Information", 66600, 66600);

        InboundPosted := Dev4IleExists(Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('IN'));
        PurchPosted := Dev4IleExists(Dev4LotNo(RunNo, 3), "Item Ledger Entry Type"::Purchase, '');
        OutboundJnlPosted := Dev4IleExists(Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('ADJ2'));
        SalePosted := Dev4IleExists(Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::Sale, '');

        // B. Open documents: what the Item Tracking Lines show (Reservation Entry).
        CheckDev4OpenTracking(TempResult, InboundPosted);

        // C. Inbound posting: Item Tracking Lines -> Item Ledger Entry -> Lot No. Information.
        if InboundPosted then begin
            CheckDev4Ile(TempResult, 'Item journal lot L1 -> item ledger entry', Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('IN'), 100, Dev4ProdDate(1));
            CheckDev4Ile(TempResult, 'Item journal lot L2 -> item ledger entry', Dev4LotNo(RunNo, 2), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('IN'), 50, Dev4ProdDate(2));
            CheckDev4Ile(TempResult, 'Item journal lot L4 -> item ledger entry', Dev4LotNo(RunNo, 4), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('IN'), 40, Dev4ProdDate(4));
            CheckDev4LotInfo(TempResult, 'Lot No. Information created on posting (L1)', Dev4LotNo(RunNo, 1), Dev4ProdDate(1));
            Lot2ExpectedDate := Dev4ProdDate(2);
            if Dev4OutboundCreated() then
                Lot2ExpectedDate := Dev4ChangedLot2Date();
            CheckDev4LotInfo(TempResult, 'Lot No. Information created on posting (L2)', Dev4LotNo(RunNo, 2), Lot2ExpectedDate);
            CheckDev4LotInfo(TempResult, 'Lot card that existed with a blank date is filled on posting (L4)', Dev4LotNo(RunNo, 4), Dev4ProdDate(4));
        end else
            AddResult(TempResult, Dev4TestStepTok, 'Inbound item journal', InfoTok, 'Not posted yet. Post the test item journal (manually or "2. Post Inbound") and run the tests again.');

        if PurchPosted then begin
            CheckDev4Ile(TempResult, 'Purchase receipt lot L3 -> item ledger entry', Dev4LotNo(RunNo, 3), "Item Ledger Entry Type"::Purchase, '', 30, Dev4ProdDate(3));
            CheckDev4LotInfo(TempResult, 'Lot No. Information created on posting (L3)', Dev4LotNo(RunNo, 3), Dev4ProdDate(3));
        end else
            AddResult(TempResult, Dev4TestStepTok, 'Purchase receipt', InfoTok, StrSubstNo('Purchase order %1 not received yet.', Dev4DocNo('PO')));

        // D. Item Tracking Lines rules (in memory only, nothing is saved).
        if InboundPosted then
            RunDev4ValidationTests(TempResult)
        else
            AddResult(TempResult, Dev4TestStepTok, 'Item Tracking Lines rules', InfoTok, 'Skipped: lot L1 must be posted first.');

        // E. Outbound and follow-up receipt: date taken from the lot / from the changed lot card.
        if OutboundJnlPosted then begin
            CheckDev4Ile(TempResult, 'Receipt of existing lot L1 with blank date -> date taken from the lot', Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('ADJ2'), 20, Dev4ProdDate(1));
            CheckDev4Ile(TempResult, 'Receipt of lot L2 after the card was changed -> new date', Dev4LotNo(RunNo, 2), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('ADJ2'), 5, Dev4ChangedLot2Date());
            CheckDev4LotInfo(TempResult, 'Lot card L1 is not overwritten by a later receipt', Dev4LotNo(RunNo, 1), Dev4ProdDate(1));
        end else
            AddResult(TempResult, Dev4TestStepTok, 'Follow-up item journal', InfoTok, 'Not posted yet ("3. Create Outbound" and "4. Post Outbound").');

        if SalePosted then
            CheckDev4Ile(TempResult, 'Sales shipment lot L1 (blank date on the line) -> date taken from the lot', Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::Sale, '', -10, Dev4ProdDate(1))
        else
            AddResult(TempResult, Dev4TestStepTok, 'Sales shipment', InfoTok, StrSubstNo('Sales order %1 not shipped yet.', Dev4DocNo('SO')));

        // F. Remaining inventory per lot once everything is posted.
        if InboundPosted and PurchPosted and OutboundJnlPosted and SalePosted then begin
            CheckDev4LotInventory(TempResult, 1, 110);
            CheckDev4LotInventory(TempResult, 2, 55);
            CheckDev4LotInventory(TempResult, 3, 30);
            CheckDev4LotInventory(TempResult, 4, 40);
        end;

        AddResult(TempResult, Dev4TestStepTok, 'Summary', InfoTok,
          StrSubstNo('Run %1 checked: inbound journal %2, purchase receipt %3, follow-up journal %4, sales shipment %5.',
            RunNo, PostedText(InboundPosted), PostedText(PurchPosted), PostedText(OutboundJnlPosted), PostedText(SalePosted)));
    end;

    procedure OpenDev004ItemJournal()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlManagement: Codeunit ItemJnlManagement;
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        if not ItemJnlBatch.Get(ItemJnlTemplate.Name, Dev4BatchTok) then
            Error(Dev4NoRunErr);
        ItemJnlManagement.TemplateSelectionFromBatch(ItemJnlBatch);
    end;

    procedure OpenDev004PurchaseOrders()
    var
        PurchHeader: Record "Purchase Header";
    begin
        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SetFilter("No.", Dev4PrefixTok + '*');
        Page.Run(Page::"Purchase Order List", PurchHeader);
    end;

    procedure OpenDev004SalesOrders()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", Dev4PrefixTok + '*');
        Page.Run(Page::"Sales Order List", SalesHeader);
    end;

    procedure OpenDev004ItemLedgerEntries()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", Dev4ItemTok);
        Page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
    end;

    procedure OpenDev004LotNoInformation()
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        LotNoInformation.SetRange("Item No.", Dev4ItemTok);
        Page.Run(Page::"Lot No. Information List", LotNoInformation);
    end;

    procedure DeleteDev004TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchOrderNos: List of [Code[20]];
        SalesOrderNos: List of [Code[20]];
        DocNo: Code[20];
        Kept: Integer;
    begin
        if GuiAllowed() then
            if not Confirm(Dev4DeleteQst, true) then
                exit;
        ClearStepResults(TempResult, Dev4DeleteStepTok);

        if Dev4JournalHasLines() then
            RunDev4Step(TempResult, Dev4DeleteStepTok, StrSubstNo('Delete open lines of item journal batch %1', Dev4BatchTok), RunModeDev4DeleteJournal(), '');

        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader.SetFilter("No.", Dev4PrefixTok + '*');
        if PurchHeader.FindSet() then
            repeat
                PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                PurchLine.SetRange("Document No.", PurchHeader."No.");
                PurchLine.SetFilter("Quantity Received", '<>%1', 0);
                if PurchLine.IsEmpty() then
                    PurchOrderNos.Add(PurchHeader."No.")
                else
                    Kept += 1;
            until PurchHeader.Next() = 0;

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", Dev4PrefixTok + '*');
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

        foreach DocNo in PurchOrderNos do
            RunDev4Step(TempResult, Dev4DeleteStepTok, StrSubstNo('Delete purchase order %1', DocNo), RunModeDev4DeletePurchOrder(), DocNo);
        foreach DocNo in SalesOrderNos do
            RunDev4Step(TempResult, Dev4DeleteStepTok, StrSubstNo('Delete sales order %1', DocNo), RunModeDeleteOrder(), DocNo);

        AddResult(TempResult, Dev4DeleteStepTok, 'Summary', InfoTok,
          StrSubstNo('%1 purchase order(s) and %2 sales order(s) processed, %3 received/shipped order(s) kept. Posted entries, lots and master data are kept.',
            PurchOrderNos.Count(), SalesOrderNos.Count(), Kept));
    end;

    // Used by the second instance that runs each step in its own transaction.
    procedure SetContext(NewRunMode: Integer; NewIndex: Integer; NewDocNo: Code[20]; NewRunNo: Integer; NewNoOfShipments: Integer; NewTemplateItemNo: Code[20]; NewTemplateCustomerNo: Code[20]; NewTemplateVendorNo: Code[20])
    begin
        RunMode := NewRunMode;
        RunIndex := NewIndex;
        RunDocNo := NewDocNo;
        RunNo := NewRunNo;
        RunNoOfShipments := NewNoOfShipments;
        TemplateItemNo := NewTemplateItemNo;
        TemplateCustomerNo := NewTemplateCustomerNo;
        TemplateVendorNo := NewTemplateVendorNo;
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
        TemplateItem: Record Item;
        TemplateCustomer: Record Customer;
        Item: Record Item;
        Qty1: Decimal;
        Qty2: Decimal;
    begin
        CheckNoSeriesSetup();
        CreateGoodsAppearances();
        EnsureTestLocation();
        EnsureWarehouseEmployee();

        FindTemplateItem(TemplateItem);
        EnsureTestItem(TestItem1Tok, 'CHM TEST Item 1 - DEV-002', TemplateItem);
        EnsureTestItem(TestItem2Tok, 'CHM TEST Item 2 - DEV-002', TemplateItem);
        Item.Get(TestItem1Tok);
        EnsureInventoryPostingSetup(TestLocationTok, Item."Inventory Posting Group");
        Item.Get(TestItem2Tok);
        EnsureInventoryPostingSetup(TestLocationTok, Item."Inventory Posting Group");

        FindTemplateCustomer(TemplateCustomer);
        EnsureTestCustomer(TestCustomerTok, 'CHM TEST Customer DEV-002', TemplateCustomer);

        Qty1 := EnsureStock(TestItem1Tok, TotalLineQty(1));
        Qty2 := EnsureStock(TestItem2Tok, TotalLineQty(2));

        StepResultText := StrSubstNo('Location %1 ready (Require Shipment, no pick, no bins). Items %2 / %3 (template %4), customer %5 (template %6). Stock posted: %7 / %8.',
            TestLocationTok, TestItem1Tok, TestItem2Tok, TemplateItem."No.", TestCustomerTok, TemplateCustomer."No.", Qty1, Qty2);
    end;

    local procedure CreateOneShipment(i: Integer)
    var
        SalesHeader: Record "Sales Header";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        TempExpected: Record "Warehouse Shipment Header" temporary;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
        LineCount: Integer;
        TotalQtyToShip: Decimal;
    begin
        // Sales order with 2 item lines on the test location.
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader."No." := OrderNo(RunNo, i);
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", TestCustomerTok);
        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Shipment Date", WorkDate());
        SalesHeader.Validate("Location Code", TestLocationTok);
        SalesHeader."External Document No." := CopyStr(StrSubstNo('CHMT2-PO-%1', SalesHeader."No."), 1, MaxStrLen(SalesHeader."External Document No."));
        SalesHeader.Modify(true);

        CreateSalesLine(SalesHeader, 10000, TestItem1Tok, LineQty(1, i));
        CreateSalesLine(SalesHeader, 20000, TestItem2Tok, LineQty(2, i));

        // Release + standard "Create Warehouse Shipment" (same as the action on the Sales Order).
        ReleaseSalesDoc.Run(SalesHeader);
        if not GetSourceDocOutbound.CreateFromSalesOrderHideDialog(SalesHeader) then
            Error(NoWhseShipmentErr, SalesHeader."No.", TestLocationTok);

        WhseShptLine.SetRange("Source Type", Database::"Sales Line");
        WhseShptLine.SetRange("Source Subtype", SalesHeader."Document Type".AsInteger());
        WhseShptLine.SetRange("Source No.", SalesHeader."No.");
        if not WhseShptLine.FindFirst() then
            Error(NoWhseShipmentErr, SalesHeader."No.", TestLocationTok);
        WhseShptHeader.Get(WhseShptLine."No.");

        // Fill Qty. to Ship on every line so the shipment can be posted straight away.
        WhseShptLine.Reset();
        WhseShptLine.SetRange("No.", WhseShptHeader."No.");
        if WhseShptLine.FindSet() then
            repeat
                if WhseShptLine."Qty. to Ship" <> WhseShptLine."Qty. Outstanding" then begin
                    WhseShptLine.Validate("Qty. to Ship", WhseShptLine."Qty. Outstanding");
                    WhseShptLine.Modify(true);
                end;
                LineCount += 1;
                TotalQtyToShip += WhseShptLine."Qty. to Ship";
            until WhseShptLine.Next() = 0;

        // The 7 DEV-002 fields, entered through Validate like a user on the page.
        WhseShptHeader.Get(WhseShptHeader."No.");
        GetExpectedRecord(i, TempExpected);
        ApplyWhseShipmentValues(WhseShptHeader, TempExpected);
        WhseShptHeader.Modify(true);

        StepResultText := StrSubstNo('Order released. Warehouse Shipment %1 created with %2 lines (Qty. to Ship %3) and the 7 shipment fields filled.',
            WhseShptHeader."No.", LineCount, TotalQtyToShip);
    end;

    local procedure CreateSalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; ItemNo: Code[20]; Qty: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := LineNo;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate("Location Code", TestLocationTok);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Modify(true);
    end;

    local procedure PostOneShipment(ShipmentNo: Code[20])
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        WhsePostShipment: Codeunit "Whse.-Post Shipment";
    begin
        WhseShptLine.SetRange("No.", ShipmentNo);
        if not WhseShptLine.FindFirst() then
            Error(NoShipmentLinesErr, ShipmentNo);

        // Same as "Post Shipment" > Ship on the Warehouse Shipment page, without the dialog.
        WhsePostShipment.SetPostingSettings(false);
        WhsePostShipment.SetPrint(false);
        WhsePostShipment.Run(WhseShptLine);

        StepResultText := 'Posted (Ship).';
        PostedWhseShptHeader.SetRange("Whse. Shipment No.", ShipmentNo);
        if PostedWhseShptHeader.FindLast() then begin
            PostedWhseShptLine.SetRange("No.", PostedWhseShptHeader."No.");
            if PostedWhseShptLine.FindFirst() then
                StepResultText := StrSubstNo('Posted (Ship): Posted Whse. Shipment %1, Posted Sales Shipment %2.', PostedWhseShptHeader."No.", PostedWhseShptLine."Posted Source No.");
        end;
    end;

    local procedure DeleteOneShipment(ShipmentNo: Code[20])
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        WhseShptHeader.Get(ShipmentNo);
        WhseShptHeader.Delete(true);
        StepResultText := 'Deleted.';
    end;

    local procedure DeleteOneOrder(SalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo);
        if SalesHeader.Status <> SalesHeader.Status::Open then
            ReleaseSalesDoc.Reopen(SalesHeader);
        SalesHeader.Delete(true);
        StepResultText := 'Reopened and deleted.';
    end;

    local procedure RunStep(StepMode: Integer; Index: Integer; DocNo: Code[20]; var ResultTxt: Text): Boolean
    var
        Runner: Codeunit "CHM Deviation Test Mgt.";
    begin
        Runner.SetContext(StepMode, Index, DocNo, RunNo, RunNoOfShipments, TemplateItemNo, TemplateCustomerNo, TemplateVendorNo);
        Commit();
        ClearLastError();
        if Runner.Run() then begin
            ResultTxt := Runner.GetStepResult();
            exit(true);
        end;
        ResultTxt := GetLastErrorText();
        exit(false);
    end;

    // =====================================================================
    // Setup helpers
    // =====================================================================

    local procedure CheckNoSeriesSetup()
    var
        WarehouseSetup: Record "Warehouse Setup";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        WarehouseSetup.Get();
        WarehouseSetup.TestField("Whse. Ship Nos.");
        WarehouseSetup.TestField("Posted Whse. Shipment Nos.");
        SalesSetup.Get();
        SalesSetup.TestField("Posted Shipment Nos.");
    end;

    local procedure EnsureTestLocation()
    var
        Location: Record Location;
    begin
        if Location.Get(TestLocationTok) then begin
            if (not Location."Require Shipment") or Location."Require Pick" or Location."Bin Mandatory" or Location."Directed Put-away and Pick" then
                Error(LocationSetupErr, TestLocationTok);
            exit;
        end;

        Location.Init();
        Location.Code := TestLocationTok;
        Location.Name := 'CHM TEST Warehouse DEV-002';
        Location.Insert(true);
        Location.Validate("Require Shipment", true);
        Location.Modify(true);
    end;

    local procedure EnsureWarehouseEmployee()
    var
        WarehouseEmployee: Record "Warehouse Employee";
    begin
        WarehouseEmployee.SetRange("User ID", UserId());
        WarehouseEmployee.SetRange("Location Code", TestLocationTok);
        if not WarehouseEmployee.IsEmpty() then
            exit;

        WarehouseEmployee.Init();
        WarehouseEmployee."User ID" := CopyStr(UserId(), 1, MaxStrLen(WarehouseEmployee."User ID"));
        WarehouseEmployee."Location Code" := TestLocationTok;
        WarehouseEmployee.Insert(true);
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
        TemplateItem.SetFilter("No.", '<>%1&<>%2&<>%3', TestItem1Tok, TestItem2Tok, Dev4ItemTok);
        if not TemplateItem.FindFirst() then
            Error(NoTemplateItemErr);
    end;

    local procedure EnsureTestItem(ItemNo: Code[20]; ItemDescription: Text[100]; TemplateItem: Record Item)
    var
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            exit;

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
        Item."Net Weight" := 10;
        Item."Gross Weight" := 11;
        Item.Modify(true);
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
        TemplateCustomer.SetFilter("No.", '<>%1&<>%2', TestCustomerTok, Dev4CustomerTok);
        if not TemplateCustomer.FindFirst() then
            Error(NoTemplateCustomerErr);
    end;

    local procedure EnsureTestCustomer(CustomerNo: Code[20]; CustomerName: Text[100]; TemplateCustomer: Record Customer)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(CustomerNo) then
            exit;

        Customer.Init();
        Customer."No." := CustomerNo;
        Customer.Insert(true);
        Customer.Validate(Name, CustomerName);
        Customer.Address := TemplateCustomer.Address;
        Customer.City := TemplateCustomer.City;
        Customer."Post Code" := TemplateCustomer."Post Code";
        Customer.County := TemplateCustomer.County;
        Customer."Country/Region Code" := TemplateCustomer."Country/Region Code";
        Customer.Validate("Customer Posting Group", TemplateCustomer."Customer Posting Group");
        Customer.Validate("Gen. Bus. Posting Group", TemplateCustomer."Gen. Bus. Posting Group");
        Customer.Validate("VAT Bus. Posting Group", TemplateCustomer."VAT Bus. Posting Group");
        Customer."Tax Area Code" := TemplateCustomer."Tax Area Code";
        Customer."Tax Liable" := TemplateCustomer."Tax Liable";
        Customer."Payment Terms Code" := TemplateCustomer."Payment Terms Code";
        Customer."Payment Method Code" := TemplateCustomer."Payment Method Code";
        Customer."Prices Including VAT" := TemplateCustomer."Prices Including VAT";
        Customer.Modify(true);
    end;

    local procedure EnsureStock(ItemNo: Code[20]; NeededQty: Decimal): Decimal
    var
        Item: Record Item;
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        RequiredQty: Decimal;
        QtyToPost: Decimal;
    begin
        // Enough stock for the open orders already on the location plus the new ones.
        Item.Get(ItemNo);
        Item.SetRange("Location Filter", TestLocationTok);
        Item.CalcFields(Inventory, "Qty. on Sales Order");
        RequiredQty := Item."Qty. on Sales Order" + NeededQty;
        if Item.Inventory >= RequiredQty then
            exit(0);
        QtyToPost := RequiredQty - Item.Inventory + 100;

        ItemJnlLine.Init();
        ItemJnlLine."Posting Date" := WorkDate();
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Document No." := CopyStr(StrSubstNo('CHMT2-STOCK-%1', RunNo), 1, MaxStrLen(ItemJnlLine."Document No."));
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Location Code", TestLocationTok);
        ItemJnlLine.Validate(Quantity, QtyToPost);
        ItemJnlLine.Validate("Unit Amount", 50);
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
        exit(QtyToPost);
    end;

    local procedure GetOpenTestShipments(var ShipmentNos: List of [Code[20]]; OnlyReadyToPost: Boolean)
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
    begin
        WhseShptHeader.SetRange("Location Code", TestLocationTok);
        if WhseShptHeader.FindSet() then
            repeat
                if OnlyReadyToPost then begin
                    WhseShptLine.SetRange("No.", WhseShptHeader."No.");
                    WhseShptLine.SetFilter("Qty. to Ship", '>%1', 0);
                    if not WhseShptLine.IsEmpty() then
                        ShipmentNos.Add(WhseShptHeader."No.");
                end else
                    ShipmentNos.Add(WhseShptHeader."No.");
            until WhseShptHeader.Next() = 0;
    end;

    local procedure GetNextRunNo(): Integer
    var
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        MaxRunNo: Integer;
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", OrderPrefixTok + '*');
        if SalesHeader.FindSet() then
            repeat
                MaxRunNo := MaxInt(MaxRunNo, ParseRunNo(SalesHeader."No."));
            until SalesHeader.Next() = 0;

        SalesShptHeader.SetFilter("Order No.", OrderPrefixTok + '*');
        if SalesShptHeader.FindSet() then
            repeat
                MaxRunNo := MaxInt(MaxRunNo, ParseRunNo(SalesShptHeader."Order No."));
            until SalesShptHeader.Next() = 0;

        if MaxRunNo >= 99 then
            Error(TooManyRunsErr);
        exit(MaxRunNo + 1);
    end;

    local procedure ParseRunNo(SalesOrderNo: Code[20]): Integer
    var
        Value: Integer;
    begin
        if Evaluate(Value, CopyStr(SalesOrderNo, StrLen(OrderPrefixTok) + 1, 2)) then
            exit(Value);
        exit(0);
    end;

    local procedure TryGetIndex(SalesOrderNo: Code[20]; var Index: Integer): Boolean
    begin
        if CopyStr(SalesOrderNo, 1, StrLen(OrderPrefixTok)) <> OrderPrefixTok then
            exit(false);
        exit(Evaluate(Index, CopyStr(SalesOrderNo, StrLen(SalesOrderNo) - 2, 3)));
    end;

    local procedure MaxInt(A: Integer; B: Integer): Integer
    begin
        if A > B then
            exit(A);
        exit(B);
    end;

    // =====================================================================
    // Test helpers
    // =====================================================================

    local procedure TestOpenShipment(var TempResult: Record "Name/Value Buffer" temporary; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        WhseShptLine: Record "Warehouse Shipment Line";
        TempExpected: Record "Warehouse Shipment Header" temporary;
        ExpectedRecRef: RecordRef;
        ActualRecRef: RecordRef;
        SourceNo: Code[20];
        LineCount: Integer;
        LinesWithoutQty: Integer;
        TotalQtyToShip: Decimal;
        Index: Integer;
        Mismatch: Text;
    begin
        WhseShptLine.SetRange("No.", WhseShptHeader."No.");
        if WhseShptLine.FindSet() then
            repeat
                LineCount += 1;
                TotalQtyToShip += WhseShptLine."Qty. to Ship";
                if WhseShptLine."Qty. to Ship" = 0 then
                    LinesWithoutQty += 1;
                if SourceNo = '' then
                    SourceNo := WhseShptLine."Source No.";
            until WhseShptLine.Next() = 0;

        AddCheck(TempResult, TestStepTok, StrSubstNo('Shipment %1 has lines ready to post', WhseShptHeader."No."),
          (LineCount > 0) and (LinesWithoutQty = 0),
          StrSubstNo('%1 lines from order %2, Qty. to Ship %3.', LineCount, SourceNo, TotalQtyToShip),
          StrSubstNo('%1 lines, %2 with Qty. to Ship = 0 (source %3).', LineCount, LinesWithoutQty, SourceNo));

        ActualRecRef.GetTable(WhseShptHeader);
        if not HasShipmentData(ActualRecRef) then begin
            AddResult(TempResult, TestStepTok, StrSubstNo('Shipment %1 fields filled', WhseShptHeader."No."), FailTok, 'All 7 shipment fields are empty.');
            exit;
        end;
        if not TryGetIndex(SourceNo, Index) then
            exit;
        GetExpectedRecord(Index, TempExpected);
        ExpectedRecRef.GetTable(TempExpected);
        Mismatch := CompareShipmentFields(ExpectedRecRef, ActualRecRef);
        if Mismatch = '' then
            AddResult(TempResult, TestStepTok, StrSubstNo('Shipment %1 fields filled', WhseShptHeader."No."), PassTok, 'All 7 fields hold the generated values.')
        else
            AddResult(TempResult, TestStepTok, StrSubstNo('Shipment %1 fields filled', WhseShptHeader."No."), WarnTok, 'Changed after creation (edited on the page?): ' + Mismatch);
    end;

    local procedure CheckPostedTestShipments(var TempResult: Record "Name/Value Buffer" temporary) Checked: Integer
    var
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        SalesShptHeader: Record "Sales Shipment Header";
        TempExpected: Record "Warehouse Shipment Header" temporary;
        PostedRecRef: RecordRef;
        SalesRecRef: RecordRef;
        ExpectedRecRef: RecordRef;
        Index: Integer;
        Mismatch: Text;
        Description: Text;
    begin
        PostedWhseShptHeader.SetRange("Location Code", TestLocationTok);
        PostedWhseShptHeader.Ascending(false);
        if not PostedWhseShptHeader.FindSet() then
            exit(0);

        repeat
            Checked += 1;
            PostedWhseShptLine.SetRange("No.", PostedWhseShptHeader."No.");
            PostedWhseShptLine.SetRange("Posted Source Document", PostedWhseShptLine."Posted Source Document"::"Posted Shipment");
            if not PostedWhseShptLine.FindFirst() then
                AddResult(TempResult, TestStepTok, StrSubstNo('Posted Whse. Shipment %1', PostedWhseShptHeader."No."), FailTok, 'No line points to a posted sales shipment.')
            else
                if not SalesShptHeader.Get(PostedWhseShptLine."Posted Source No.") then
                    AddResult(TempResult, TestStepTok, StrSubstNo('Posted Whse. Shipment %1', PostedWhseShptHeader."No."), FailTok,
                      StrSubstNo('Posted Sales Shipment %1 not found.', PostedWhseShptLine."Posted Source No."))
                else begin
                    PostedRecRef.GetTable(PostedWhseShptHeader);
                    SalesRecRef.GetTable(SalesShptHeader);
                    Description := StrSubstNo('Header flow: Whse. Shpt. %1 -> Posted Whse. Shpt. %2 -> Posted Sales Shpt. %3',
                        PostedWhseShptHeader."Whse. Shipment No.", PostedWhseShptHeader."No.", SalesShptHeader."No.");

                    // 1. Posted Whse. Shipment must carry the values (codeunit 5763 subscriber).
                    // 2. Posted Sales Shipment must hold the same values (codeunit 80 subscriber).
                    if not HasShipmentData(PostedRecRef) then
                        AddResult(TempResult, TestStepTok, Description, FailTok, 'Posted Whse. Shipment has no shipment data: the values were not copied on posting.')
                    else begin
                        Mismatch := CompareShipmentFields(PostedRecRef, SalesRecRef);
                        AddCheck(TempResult, TestStepTok, Description, Mismatch = '',
                          StrSubstNo('Both posted documents hold the 7 values (Net %1, Gross %2, Parcel %3, Pallet %4, Volume %5, Appearance %6, Packaging %7).',
                            SalesShptHeader."CHM Total Net Weight", SalesShptHeader."CHM Total Gross Weight", SalesShptHeader."CHM Total Parcel",
                            SalesShptHeader."CHM Total Pallet", SalesShptHeader."CHM Total Volume", SalesShptHeader."CHM Goods Appearance",
                            SalesShptHeader."CHM Non-reusable Packaging"),
                          'Posted Sales Shipment differs from Posted Whse. Shipment: ' + Mismatch);
                    end;

                    // 3. Compare with the generated values (WARN only: the user may have edited them before posting).
                    if TryGetIndex(SalesShptHeader."Order No.", Index) then begin
                        GetExpectedRecord(Index, TempExpected);
                        ExpectedRecRef.GetTable(TempExpected);
                        Mismatch := CompareShipmentFields(ExpectedRecRef, SalesRecRef);
                        if Mismatch = '' then
                            AddResult(TempResult, TestStepTok, StrSubstNo('Posted Sales Shpt. %1 = values entered on the shipment', SalesShptHeader."No."), PassTok, 'Matches the values filled on the warehouse shipment.')
                        else
                            AddResult(TempResult, TestStepTok, StrSubstNo('Posted Sales Shpt. %1 = values entered on the shipment', SalesShptHeader."No."), WarnTok,
                              'Differs from the generated values (were they edited before posting?): ' + Mismatch);
                    end;

                    // 4. Lines: every posted warehouse line must match its posted sales shipment line.
                    CheckPostedLines(TempResult, PostedWhseShptHeader."No.");
                end;
        until (PostedWhseShptHeader.Next() = 0) or (Checked >= 50);
    end;

    local procedure CheckPostedLines(var TempResult: Record "Name/Value Buffer" temporary; PostedWhseShptNo: Code[20])
    var
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        SalesShptLine: Record "Sales Shipment Line";
        LineCount: Integer;
        TotalQty: Decimal;
        Mismatch: Text;
    begin
        PostedWhseShptLine.SetRange("No.", PostedWhseShptNo);
        if PostedWhseShptLine.FindSet() then
            repeat
                LineCount += 1;
                TotalQty += PostedWhseShptLine.Quantity;
                SalesShptLine.SetRange("Document No.", PostedWhseShptLine."Posted Source No.");
                SalesShptLine.SetRange("Order Line No.", PostedWhseShptLine."Source Line No.");
                if not SalesShptLine.FindFirst() then
                    Mismatch += StrSubstNo('line %1: no posted sales shipment line; ', PostedWhseShptLine."Line No.")
                else
                    if (SalesShptLine."No." <> PostedWhseShptLine."Item No.") or (SalesShptLine.Quantity <> PostedWhseShptLine.Quantity) then
                        Mismatch += StrSubstNo('line %1: whse %2 x %3, sales %4 x %5; ', PostedWhseShptLine."Line No.",
                          PostedWhseShptLine."Item No.", PostedWhseShptLine.Quantity, SalesShptLine."No.", SalesShptLine.Quantity);
            until PostedWhseShptLine.Next() = 0;

        AddCheck(TempResult, TestStepTok, StrSubstNo('Line flow: Posted Whse. Shpt. %1', PostedWhseShptNo),
          (LineCount > 0) and (Mismatch = ''),
          StrSubstNo('%1 lines, total quantity %2: item and quantity match the Posted Sales Shipment lines.', LineCount, TotalQty),
          StrSubstNo('%1 lines. %2', LineCount, Mismatch));
    end;

    local procedure RunShipmentValidationTests(var TempResult: Record "Name/Value Buffer" temporary; var RecRef: RecordRef)
    var
        Weight: Decimal;
        InvalidCode: Code[10];
        ValidCode: Code[10];
    begin
        // RecRef is an in-memory copy of a test shipment; nothing is written to the database.
        SetNetGross(RecRef, 100, 0);
        Weight := 50;
        CheckValidate(TempResult, 'Gross Weight lower than Net Weight is rejected', RecRef, 66601, Weight, true);

        SetNetGross(RecRef, 100, 0);
        Weight := 100;
        CheckValidate(TempResult, 'Gross Weight equal to Net Weight is accepted', RecRef, 66601, Weight, false);

        SetNetGross(RecRef, 0, 0);
        Weight := 250;
        CheckValidate(TempResult, 'Net Weight with Gross Weight still 0 is accepted', RecRef, 66600, Weight, false);

        SetNetGross(RecRef, 0, 0);
        Weight := -1;
        CheckValidate(TempResult, 'Negative Net Weight is rejected', RecRef, 66600, Weight, true);

        InvalidCode := 'XX-NOTEXST';
        CheckValidate(TempResult, 'Unknown Goods Appearance code is rejected', RecRef, 66605, InvalidCode, true);

        ValidCode := GoodsAppearanceCode(1);
        CheckValidate(TempResult, 'Existing Goods Appearance code is accepted', RecRef, 66605, ValidCode, false);
    end;

    local procedure RunNegativeValueTests(var TempResult: Record "Name/Value Buffer" temporary; var RecRef: RecordRef)
    var
        NegativeDecimal: Decimal;
        NegativeInteger: Integer;
    begin
        NegativeDecimal := -1;
        NegativeInteger := -1;
        CheckValidate(TempResult, 'Negative Total Parcel is rejected', RecRef, 66602, NegativeInteger, true);
        CheckValidate(TempResult, 'Negative Total Pallet is rejected', RecRef, 66603, NegativeInteger, true);
        CheckValidate(TempResult, 'Negative Total Volume is rejected', RecRef, 66604, NegativeDecimal, true);
        CheckValidate(TempResult, 'Negative Non-reusable Packaging is rejected', RecRef, 66606, NegativeDecimal, true);
    end;

    local procedure SetNetGross(var RecRef: RecordRef; NetWeight: Decimal; GrossWeight: Decimal)
    var
        FldRef: FieldRef;
    begin
        FldRef := RecRef.Field(66600);
        FldRef.Value := NetWeight;
        FldRef := RecRef.Field(66601);
        FldRef.Value := GrossWeight;
    end;

    local procedure CheckValidate(var TempResult: Record "Name/Value Buffer" temporary; Description: Text; var RecRef: RecordRef; FieldNo: Integer; NewValue: Variant; ExpectError: Boolean)
    var
        Succeeded: Boolean;
    begin
        ClearLastError();
        Succeeded := TryValidateField(RecRef, FieldNo, NewValue);
        if ExpectError then
            AddCheck(TempResult, TestStepTok, Description, not Succeeded, StrSubstNo(ErrorAsExpectedTxt, GetLastErrorText()), NoErrorRaisedTxt)
        else
            AddCheck(TempResult, TestStepTok, Description, Succeeded, AcceptedTxt, GetLastErrorText());
    end;

    [TryFunction]
    local procedure TryValidateField(var RecRef: RecordRef; FieldNo: Integer; NewValue: Variant)
    var
        FldRef: FieldRef;
    begin
        FldRef := RecRef.Field(FieldNo);
        FldRef.Validate(NewValue);
    end;

    local procedure CheckSameFieldDefinition(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; RefTableNo: Integer; TableNo: Integer; FromFieldNo: Integer; ToFieldNo: Integer)
    var
        RefRecRef: RecordRef;
        RecRef: RecordRef;
        RefFldRef: FieldRef;
        FldRef: FieldRef;
        FieldNo: Integer;
        Mismatch: Text;
    begin
        RefRecRef.Open(RefTableNo);
        RecRef.Open(TableNo);
        for FieldNo := FromFieldNo to ToFieldNo do
            if not RecRef.FieldExist(FieldNo) then
                Mismatch += StrSubstNo('field %1 is missing; ', FieldNo)
            else
                if RefRecRef.FieldExist(FieldNo) then begin
                    RefFldRef := RefRecRef.Field(FieldNo);
                    FldRef := RecRef.Field(FieldNo);
                    if (RefFldRef.Name <> FldRef.Name) or (RefFldRef.Type <> FldRef.Type) or (RefFldRef.Length <> FldRef.Length) then
                        Mismatch += StrSubstNo('field %1 differs (%2 %3 vs %4 %5); ', FieldNo, RefFldRef.Name, Format(RefFldRef.Type), FldRef.Name, Format(FldRef.Type));
                end;

        AddCheck(TempResult, StepCode, StrSubstNo('Field %1..%2 definition on %3 matches %4', FromFieldNo, ToFieldNo, RecRef.Caption, RefRecRef.Caption),
          Mismatch = '', 'Same field IDs, names, types and lengths.', Mismatch);
        RecRef.Close();
        RefRecRef.Close();
    end;

    local procedure GetExpectedRecord(i: Integer; var TempExpected: Record "Warehouse Shipment Header" temporary)
    begin
        // Deterministic values per order no. (gross always >= net).
        TempExpected.Init();
        TempExpected."CHM Total Net Weight" := 100 + i * 12.5;
        TempExpected."CHM Total Gross Weight" := TempExpected."CHM Total Net Weight" + 10 + i;
        TempExpected."CHM Total Parcel" := i;
        TempExpected."CHM Total Pallet" := (i + 1) div 2;
        TempExpected."CHM Total Volume" := 1.5 * i;
        TempExpected."CHM Goods Appearance" := GoodsAppearanceCode(((i - 1) mod 5) + 1);
        TempExpected."CHM Non-reusable Packaging" := 0.25 * i;
    end;

    local procedure ApplyWhseShipmentValues(var WhseShptHeader: Record "Warehouse Shipment Header"; TempExpected: Record "Warehouse Shipment Header" temporary)
    begin
        WhseShptHeader.Validate("CHM Total Net Weight", TempExpected."CHM Total Net Weight");
        WhseShptHeader.Validate("CHM Total Gross Weight", TempExpected."CHM Total Gross Weight");
        WhseShptHeader.Validate("CHM Total Parcel", TempExpected."CHM Total Parcel");
        WhseShptHeader.Validate("CHM Total Pallet", TempExpected."CHM Total Pallet");
        WhseShptHeader.Validate("CHM Total Volume", TempExpected."CHM Total Volume");
        WhseShptHeader.Validate("CHM Goods Appearance", TempExpected."CHM Goods Appearance");
        WhseShptHeader.Validate("CHM Non-reusable Packaging", TempExpected."CHM Non-reusable Packaging");
    end;

    local procedure CompareShipmentFields(var ExpectedRecRef: RecordRef; var ActualRecRef: RecordRef) Mismatch: Text
    var
        ExpectedFldRef: FieldRef;
        ActualFldRef: FieldRef;
        FieldNo: Integer;
    begin
        for FieldNo := FirstShipmentFieldNo() to LastShipmentFieldNo() do begin
            ExpectedFldRef := ExpectedRecRef.Field(FieldNo);
            ActualFldRef := ActualRecRef.Field(FieldNo);
            if Format(ExpectedFldRef.Value, 0, 9) <> Format(ActualFldRef.Value, 0, 9) then
                Mismatch += StrSubstNo('%1: expected %2, found %3; ', ActualFldRef.Caption, Format(ExpectedFldRef.Value), Format(ActualFldRef.Value));
        end;
    end;

    local procedure HasShipmentData(var RecRef: RecordRef): Boolean
    var
        FldRef: FieldRef;
        FieldNo: Integer;
        ValueText: Text;
    begin
        for FieldNo := FirstShipmentFieldNo() to LastShipmentFieldNo() do begin
            FldRef := RecRef.Field(FieldNo);
            ValueText := Format(FldRef.Value, 0, 9);
            if (ValueText <> '') and (ValueText <> '0') then
                exit(true);
        end;
        exit(false);
    end;

    local procedure CreateGoodsAppearances()
    var
        GoodsAppearance: Record "CHM Goods Appearance";
        k: Integer;
    begin
        for k := 1 to 5 do
            if not GoodsAppearance.Get(GoodsAppearanceCode(k)) then begin
                GoodsAppearance.Init();
                GoodsAppearance.Code := GoodsAppearanceCode(k);
                case k of
                    1:
                        GoodsAppearance.Description := 'IRON DRUMS (TEST)';
                    2:
                        GoodsAppearance.Description := 'CISTERN (TEST)';
                    3:
                        GoodsAppearance.Description := 'PLASTIC DRUMS (TEST)';
                    4:
                        GoodsAppearance.Description := 'IBC TANK (TEST)';
                    5:
                        GoodsAppearance.Description := 'BAGS ON PALLET (TEST)';
                end;
                GoodsAppearance.Insert();
            end;
    end;

    local procedure GoodsAppearanceCode(Index: Integer): Code[10]
    begin
        exit(CopyStr(GoodsAppPrefixTok + Format(Index, 0, '<Integer,2><Filler Character,0>'), 1, 10));
    end;

    // =====================================================================
    // Open Page links: every result line can point to a record, which opens in its real page
    // =====================================================================

    procedure HasResultLink(ResultId: Integer): Boolean
    begin
        exit(ResultLinks.ContainsKey(ResultId));
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

    procedure ClearResultLinks()
    begin
        Clear(ResultLinks);
        PendingLink := '';
    end;

    procedure OpenResultRecord(ResultId: Integer)
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        Location: Record Location;
        Vendor: Record Vendor;
        Customer: Record Customer;
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        SalesShptHeader: Record "Sales Shipment Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        ReservEntry: Record "Reservation Entry";
        ItemJnlManagement: Codeunit ItemJnlManagement;
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
            Database::"Item Tracking Code":
                begin
                    RecRef.SetTable(ItemTrackingCode);
                    Page.Run(Page::"Item Tracking Code Card", ItemTrackingCode);
                end;
            Database::Location:
                begin
                    RecRef.SetTable(Location);
                    Page.Run(Page::"Location Card", Location);
                end;
            Database::Vendor:
                begin
                    RecRef.SetTable(Vendor);
                    Page.Run(Page::"Vendor Card", Vendor);
                end;
            Database::Customer:
                begin
                    RecRef.SetTable(Customer);
                    Page.Run(Page::"Customer Card", Customer);
                end;
            Database::"Item Journal Batch":
                begin
                    RecRef.SetTable(ItemJnlBatch);
                    ItemJnlManagement.TemplateSelectionFromBatch(ItemJnlBatch);
                end;
            Database::"Item Journal Line":
                begin
                    RecRef.SetTable(ItemJnlLine);
                    ItemJnlLine.OpenItemTrackingLines(false);
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchHeader);
                    Page.Run(Page::"Purchase Order", PurchHeader);
                end;
            Database::"Purchase Line":
                begin
                    RecRef.SetTable(PurchLine);
                    PurchLine.OpenItemTrackingLines();
                end;
            Database::"Sales Header":
                begin
                    RecRef.SetTable(SalesHeader);
                    Page.Run(Page::"Sales Order", SalesHeader);
                end;
            Database::"Sales Line":
                begin
                    RecRef.SetTable(SalesLine);
                    SalesLine.OpenItemTrackingLines();
                end;
            Database::"Purch. Rcpt. Header":
                begin
                    RecRef.SetTable(PurchRcptHeader);
                    Page.Run(Page::"Posted Purchase Receipt", PurchRcptHeader);
                end;
            Database::"Sales Shipment Header":
                begin
                    RecRef.SetTable(SalesShptHeader);
                    Page.Run(Page::"Posted Sales Shipment", SalesShptHeader);
                end;
            Database::"Item Ledger Entry":
                begin
                    // All entries of the same lot, positioned on this one.
                    RecRef.SetTable(ItemLedgerEntry);
                    ItemLedgerEntry.SetRange("Item No.", ItemLedgerEntry."Item No.");
                    if ItemLedgerEntry."Lot No." <> '' then
                        ItemLedgerEntry.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                    Page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
                end;
            Database::"Lot No. Information":
                begin
                    RecRef.SetTable(LotNoInformation);
                    Page.Run(Page::"Lot No. Information Card", LotNoInformation);
                end;
            Database::"Reservation Entry":
                begin
                    // An open item tracking line: open the Item Tracking Lines of its document line.
                    RecRef.SetTable(ReservEntry);
                    case ReservEntry."Source Type" of
                        Database::"Item Journal Line":
                            if ItemJnlLine.Get(ReservEntry."Source ID", ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.") then
                                ItemJnlLine.OpenItemTrackingLines(false);
                        Database::"Purchase Line":
                            if PurchLine.Get("Purchase Document Type".FromInteger(ReservEntry."Source Subtype"), ReservEntry."Source ID", ReservEntry."Source Ref. No.") then
                                PurchLine.OpenItemTrackingLines();
                        Database::"Sales Line":
                            if SalesLine.Get("Sales Document Type".FromInteger(ReservEntry."Source Subtype"), ReservEntry."Source ID", ReservEntry."Source Ref. No.") then
                                SalesLine.OpenItemTrackingLines();
                    end;
                end;
            else
                Message(NoLinkMsg);
        end;
    end;

    procedure ShowDev004ProcessFlow(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        RunNo := GetDev004LastRunNo();
        if RunNo = 0 then
            Error(Dev4NoRunErr);
        ClearStepResults(TempResult, Dev4FlowStepTok);

        AddResult(TempResult, Dev4FlowStepTok, StrSubstNo('Run %1 - Step 1: setup and inbound documents', RunNo), InfoTok,
          'Master data, the item journal with its Item Tracking Lines and the purchase order. Journal lines disappear once posted.');
        AddDev4SetupViews(TempResult, Dev4FlowStepTok);
        AddDev4CreateViews(TempResult, Dev4FlowStepTok);

        AddResult(TempResult, Dev4FlowStepTok, StrSubstNo('Run %1 - Step 2: inbound posted', RunNo), InfoTok,
          'Posted purchase receipt, item ledger entries and Lot No. Information cards of lots L1 to L4.');
        AddDev4InboundViews(TempResult, Dev4FlowStepTok);

        AddResult(TempResult, Dev4FlowStepTok, StrSubstNo('Run %1 - Step 3: outbound documents', RunNo), InfoTok,
          'Lot card L2 with the changed date, the follow-up item journal and the sales order with their Item Tracking Lines.');
        AddDev4OutboundCreateViews(TempResult, Dev4FlowStepTok);

        AddResult(TempResult, Dev4FlowStepTok, StrSubstNo('Run %1 - Step 4: outbound posted', RunNo), InfoTok,
          'Posted sales shipment and the final item ledger entries and lot cards of lots L1 and L2.');
        AddDev4OutboundPostedViews(TempResult, Dev4FlowStepTok);
    end;

    local procedure AddDev4SetupViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        Location: Record Location;
        Vendor: Record Vendor;
        Customer: Record Customer;
    begin
        if Item.Get(Dev4ItemTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Item %1', Item."No."),
              StrSubstNo('Item Tracking Code %1, Base Unit of Measure %2.', Item."Item Tracking Code", Item."Base Unit of Measure"), Item);
        if ItemTrackingCode.Get(Dev4TrackingCodeTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Item tracking code %1', ItemTrackingCode.Code),
              StrSubstNo('Lot Specific Tracking = %1.', ItemTrackingCode."Lot Specific Tracking"), ItemTrackingCode);
        if Location.Get(Dev4LocationTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Location %1', Location.Code), 'No warehouse handling: documents post directly.', Location);
        if Vendor.Get(Dev4VendorTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Vendor %1', Vendor."No."), Vendor.Name, Vendor);
        if Customer.Get(Dev4CustomerTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Customer %1', Customer."No."), Customer.Name, Customer);
    end;

    local procedure AddDev4CreateViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        AddDev4JournalViews(TempResult, StepCode);
        if LotNoInformation.Get(Dev4ItemTok, '', Dev4LotNo(RunNo, 4)) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Lot No. Information Card %1 (created before the receipt)', LotNoInformation."Lot No."),
              StrSubstNo('Production Date now: %1. Expected after posting the journal: %2.', DateText(LotNoInformation."CHM Production Date"), DateText(Dev4ProdDate(4))),
              LotNoInformation);
        AddDev4PurchOrderViews(TempResult, StepCode);
    end;

    local procedure AddDev4InboundViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        LotIndex: Integer;
    begin
        PurchRcptHeader.SetRange("Order No.", Dev4DocNo('PO'));
        if PurchRcptHeader.FindLast() then
            AddViewRow(TempResult, StepCode, StrSubstNo('Posted purchase receipt %1', PurchRcptHeader."No."),
              StrSubstNo('Receipt of purchase order %1 (lot %2).', Dev4DocNo('PO'), Dev4LotNo(RunNo, 3)), PurchRcptHeader)
        else
            AddResult(TempResult, StepCode, 'Posted purchase receipt', InfoTok, StrSubstNo('Purchase order %1 not received yet.', Dev4DocNo('PO')));

        for LotIndex := 1 to 4 do
            AddDev4LotViews(TempResult, StepCode, LotIndex);
    end;

    local procedure AddDev4OutboundCreateViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        LotNoInformation: Record "Lot No. Information";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if LotNoInformation.Get(Dev4ItemTok, '', Dev4LotNo(RunNo, 2)) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Lot No. Information Card %1 (date changed on the card)', LotNoInformation."Lot No."),
              StrSubstNo('Production Date %1 (was %2). New receipts of this lot default to this date.', DateText(LotNoInformation."CHM Production Date"), DateText(Dev4ProdDate(2))),
              LotNoInformation);

        AddDev4JournalViews(TempResult, StepCode);

        if not SalesHeader.Get(SalesHeader."Document Type"::Order, Dev4DocNo('SO')) then begin
            AddResult(TempResult, StepCode, 'Sales order', InfoTok, StrSubstNo('Sales order %1 not created yet ("3. Create Outbound").', Dev4DocNo('SO')));
            exit;
        end;
        AddViewRow(TempResult, StepCode, StrSubstNo('Sales order %1', SalesHeader."No."),
          StrSubstNo('Customer %1, location %2.', SalesHeader."Sell-to Customer No.", SalesHeader."Location Code"), SalesHeader);
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                AddViewRow(TempResult, StepCode, StrSubstNo('Item Tracking Lines on sales order %1 line %2 (%3 pcs)', SalesLine."Document No.", SalesLine."Line No.", SalesLine.Quantity),
                  Dev4TrackingSummary(Database::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", '', SalesLine."Line No.") +
                  ' The date is left blank on purpose: posting takes it from the lot.', SalesLine);
            until SalesLine.Next() = 0;
    end;

    local procedure AddDev4OutboundPostedViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader.SetRange("Order No.", Dev4DocNo('SO'));
        if SalesShptHeader.FindLast() then
            AddViewRow(TempResult, StepCode, StrSubstNo('Posted sales shipment %1', SalesShptHeader."No."),
              StrSubstNo('Shipment of sales order %1 (lot %2).', Dev4DocNo('SO'), Dev4LotNo(RunNo, 1)), SalesShptHeader)
        else
            AddResult(TempResult, StepCode, 'Posted sales shipment', InfoTok, StrSubstNo('Sales order %1 not shipped yet.', Dev4DocNo('SO')));

        AddDev4LotViews(TempResult, StepCode, 1);
        AddDev4LotViews(TempResult, StepCode, 2);
    end;

    local procedure AddDev4JournalViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        if not ItemJnlBatch.Get(ItemJnlTemplate.Name, Dev4BatchTok) then
            exit;
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev4BatchTok);
        if ItemJnlLine.IsEmpty() then begin
            AddResult(TempResult, StepCode, StrSubstNo('Item journal %1 / %2', ItemJnlTemplate.Name, Dev4BatchTok), InfoTok,
              'No open lines: the journal is posted. See the item ledger entries.');
            exit;
        end;

        AddViewRow(TempResult, StepCode, StrSubstNo('Item journal %1 / %2', ItemJnlTemplate.Name, Dev4BatchTok),
          StrSubstNo('%1 open line(s). On a line use Item Tracking Lines to see the Production Date column.', ItemJnlLine.Count()), ItemJnlBatch);
        ItemJnlLine.FindSet();
        repeat
            AddViewRow(TempResult, StepCode, StrSubstNo('Item Tracking Lines on journal line %1 (%2, %3 pcs)', ItemJnlLine."Line No.", ItemJnlLine."Document No.", ItemJnlLine.Quantity),
              Dev4TrackingSummary(Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name", ItemJnlLine."Line No."),
              ItemJnlLine);
        until ItemJnlLine.Next() = 0;
    end;

    local procedure AddDev4PurchOrderViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
    begin
        if not PurchHeader.Get(PurchHeader."Document Type"::Order, Dev4DocNo('PO')) then begin
            AddResult(TempResult, StepCode, 'Purchase order', InfoTok, StrSubstNo('Purchase order %1 not found.', Dev4DocNo('PO')));
            exit;
        end;
        AddViewRow(TempResult, StepCode, StrSubstNo('Purchase order %1', PurchHeader."No."),
          StrSubstNo('Vendor %1, location %2.', PurchHeader."Buy-from Vendor No.", PurchHeader."Location Code"), PurchHeader);
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        if PurchLine.FindSet() then
            repeat
                AddViewRow(TempResult, StepCode, StrSubstNo('Item Tracking Lines on purchase order %1 line %2 (%3 pcs)', PurchLine."Document No.", PurchLine."Line No.", PurchLine.Quantity),
                  Dev4TrackingSummary(Database::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", '', PurchLine."Line No."), PurchLine);
            until PurchLine.Next() = 0;
    end;

    local procedure AddDev4LotViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; LotIndex: Integer)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        LotNo: Code[50];
        Summary: Text;
    begin
        LotNo := Dev4LotNo(RunNo, LotIndex);
        ItemLedgerEntry.SetRange("Item No.", Dev4ItemTok);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        if ItemLedgerEntry.FindSet() then begin
            repeat
                Summary += StrSubstNo('%1 %2: %3 pcs, Production Date %4. ', ItemLedgerEntry."Entry Type", ItemLedgerEntry."Document No.",
                  ItemLedgerEntry.Quantity, DateText(ItemLedgerEntry."CHM Production Date"));
            until ItemLedgerEntry.Next() = 0;
            ItemLedgerEntry.FindFirst();
            AddViewRow(TempResult, StepCode, StrSubstNo('Item ledger entries of lot %1', LotNo), Summary, ItemLedgerEntry);
        end else
            AddResult(TempResult, StepCode, StrSubstNo('Item ledger entries of lot %1', LotNo), InfoTok, 'Not posted yet.');

        if LotNoInformation.Get(Dev4ItemTok, '', LotNo) then begin
            LotNoInformation.CalcFields(Inventory);
            AddViewRow(TempResult, StepCode, StrSubstNo('Lot No. Information Card %1', LotNo),
              StrSubstNo('Production Date %1, inventory %2 pcs.', DateText(LotNoInformation."CHM Production Date"), LotNoInformation.Inventory), LotNoInformation);
        end else
            AddResult(TempResult, StepCode, StrSubstNo('Lot No. Information Card %1', LotNo), InfoTok, 'Not created yet (created when the lot is posted).');
    end;

    local procedure Dev4TrackingSummary(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer) Summary: Text
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.SetRange("Source Type", SourceType);
        ReservEntry.SetRange("Source Subtype", SourceSubtype);
        ReservEntry.SetRange("Source ID", SourceID);
        ReservEntry.SetRange("Source Batch Name", SourceBatchName);
        ReservEntry.SetRange("Source Ref. No.", SourceRefNo);
        ReservEntry.SetFilter("Lot No.", '<>%1', '');
        if ReservEntry.FindSet() then
            repeat
                Summary += StrSubstNo('Lot %1: %2 pcs, Production Date %3. ', ReservEntry."Lot No.", Abs(ReservEntry."Quantity (Base)"), DateText(ReservEntry."CHM Production Date"));
            until ReservEntry.Next() = 0;
        if Summary = '' then
            Summary := 'No open item tracking lines (already posted).';
    end;

    local procedure AddViewRow(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; Details: Text; RecVariant: Variant)
    begin
        SetResultLink(RecVariant);
        AddResult(TempResult, StepCode, Description, ViewTok, Details);
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
            Database::"Item Tracking Code":
                exit('Item Tracking Code Card');
            Database::Location:
                exit('Location Card');
            Database::Vendor:
                exit('Vendor Card');
            Database::Customer:
                exit('Customer Card');
            Database::"Item Journal Batch":
                exit('Item Journal');
            Database::"Item Journal Line", Database::"Purchase Line", Database::"Sales Line", Database::"Reservation Entry":
                exit('Item Tracking Lines');
            Database::"Purchase Header":
                exit('Purchase Order');
            Database::"Sales Header":
                exit('Sales Order');
            Database::"Purch. Rcpt. Header":
                exit('Posted Purchase Receipt');
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
    // DEV-004 steps (run inside OnRun)
    // =====================================================================

    local procedure RunDev4Setup()
    var
        TemplateItem: Record Item;
        TemplateVendor: Record Vendor;
        TemplateCustomer: Record Customer;
        Item: Record Item;
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        CheckDev4NoSeriesSetup();
        EnsureDev4TrackingCode();
        EnsureDev4Location();

        FindTemplateItem(TemplateItem);
        EnsureTestItem(Dev4ItemTok, 'CHM TEST Lot Item - DEV-004', TemplateItem);
        EnsureDev4ItemTrackingCode();
        Item.Get(Dev4ItemTok);
        EnsureInventoryPostingSetup(Dev4LocationTok, Item."Inventory Posting Group");

        FindTemplateVendor(TemplateVendor, Item."Gen. Prod. Posting Group");
        EnsureTestVendor(TemplateVendor);
        FindTemplateCustomer(TemplateCustomer);
        EnsureTestCustomer(Dev4CustomerTok, 'CHM TEST Customer DEV-004', TemplateCustomer);

        EnsureDev4JournalBatch();
        CheckDev4JournalEmpty();
        FindDev4JnlTemplate(ItemJnlTemplate);

        StepResultText := StrSubstNo('Tracking code %1 (lot), location %2, item %3 (template %4), vendor %5 (template %6), customer %7 (template %8), item journal %9.',
            Dev4TrackingCodeTok, Dev4LocationTok, Dev4ItemTok, TemplateItem."No.", Dev4VendorTok, TemplateVendor."No.",
            Dev4CustomerTok, TemplateCustomer."No.", ItemJnlTemplate.Name + ' / ' + Dev4BatchTok);
    end;

    local procedure CreateDev4InboundJournal()
    var
        LotNoInformation: Record "Lot No. Information";
        ItemJnlLine: Record "Item Journal Line";
    begin
        CheckDev4JournalEmpty();

        // Lot L4 exists on the Lot No. Information Card without a Production Date: posting must fill it.
        if not LotNoInformation.Get(Dev4ItemTok, '', Dev4LotNo(RunNo, 4)) then begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := Dev4ItemTok;
            LotNoInformation."Variant Code" := '';
            LotNoInformation."Lot No." := Dev4LotNo(RunNo, 4);
            LotNoInformation.Description := 'CHM TEST DEV-004 lot created before receipt';
            LotNoInformation.Insert(true);
        end;

        // Line 1: 150 pcs split over 2 lots with different Production Dates.
        CreateDev4JnlLine(ItemJnlLine, Dev4DocNo('IN'), 150);
        AddDev4JnlLineLot(ItemJnlLine, Dev4LotNo(RunNo, 1), 100, Dev4ProdDate(1));
        AddDev4JnlLineLot(ItemJnlLine, Dev4LotNo(RunNo, 2), 50, Dev4ProdDate(2));

        // Line 2: 40 pcs of the lot that already has a (blank) Lot No. Information card.
        CreateDev4JnlLine(ItemJnlLine, Dev4DocNo('IN'), 40);
        AddDev4JnlLineLot(ItemJnlLine, Dev4LotNo(RunNo, 4), 40, Dev4ProdDate(4));

        StepResultText := StrSubstNo('Line 1: 150 pcs = lot %1 x100 (%2) + lot %3 x50 (%4). Line 2: lot %5 x40 (%6). Lot %5 created on the Lot No. Information card with a blank Production Date.',
            Dev4LotNo(RunNo, 1), Dev4ProdDate(1), Dev4LotNo(RunNo, 2), Dev4ProdDate(2), Dev4LotNo(RunNo, 4), Dev4ProdDate(4));
    end;

    local procedure CreateDev4PurchOrder()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
    begin
        PurchHeader.Init();
        PurchHeader.Validate("Document Type", PurchHeader."Document Type"::Order);
        PurchHeader."No." := Dev4DocNo('PO');
        PurchHeader.Insert(true);
        PurchHeader.Validate("Buy-from Vendor No.", Dev4VendorTok);
        PurchHeader.Validate("Posting Date", WorkDate());
        PurchHeader.Validate("Location Code", Dev4LocationTok);
        PurchHeader."Vendor Invoice No." := PurchHeader."No.";
        PurchHeader."Vendor Shipment No." := PurchHeader."No.";
        PurchHeader.Modify(true);

        PurchLine.Init();
        PurchLine.Validate("Document Type", PurchHeader."Document Type");
        PurchLine.Validate("Document No.", PurchHeader."No.");
        PurchLine."Line No." := 10000;
        PurchLine.Insert(true);
        PurchLine.Validate(Type, PurchLine.Type::Item);
        PurchLine.Validate("No.", Dev4ItemTok);
        PurchLine.Validate("Location Code", Dev4LocationTok);
        PurchLine.Validate(Quantity, 30);
        PurchLine.Validate("Direct Unit Cost", 10);
        PurchLine.Modify(true);

        AddDev4Lot(Database::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", '', PurchLine."Line No.",
          PurchLine."Qty. per Unit of Measure", Dev4LotNo(RunNo, 3), 30, Dev4ProdDate(3), PurchLine."Expected Receipt Date", 0D, "Reservation Status"::Surplus);

        StepResultText := StrSubstNo('Purchase order %1 for vendor %2: 30 pcs, lot %3 with Production Date %4.', PurchHeader."No.", Dev4VendorTok, Dev4LotNo(RunNo, 3), Dev4ProdDate(3));
    end;

    local procedure CreateDev4OutboundJournal()
    var
        LotNoInformation: Record "Lot No. Information";
        ItemJnlLine: Record "Item Journal Line";
    begin
        CheckDev4JournalEmpty();

        // Same as changing the Production Date on the Lot No. Information Card.
        LotNoInformation.Get(Dev4ItemTok, '', Dev4LotNo(RunNo, 2));
        LotNoInformation."CHM Production Date" := Dev4ChangedLot2Date();
        LotNoInformation.Modify(true);

        // Existing lot L1, Production Date left blank: posting must take it from the lot.
        CreateDev4JnlLine(ItemJnlLine, Dev4DocNo('ADJ2'), 20);
        AddDev4JnlLineLot(ItemJnlLine, Dev4LotNo(RunNo, 1), 20, 0D);

        // Lot L2 with the new date from the card (what Item Tracking Lines default to).
        CreateDev4JnlLine(ItemJnlLine, Dev4DocNo('ADJ2'), 5);
        AddDev4JnlLineLot(ItemJnlLine, Dev4LotNo(RunNo, 2), 5, Dev4ChangedLot2Date());

        StepResultText := StrSubstNo('Lot %1 card: Production Date %2 -> %3. Item journal %4: lot %5 x20 (Production Date blank), lot %1 x5 (%3).',
            Dev4LotNo(RunNo, 2), Dev4ProdDate(2), Dev4ChangedLot2Date(), Dev4DocNo('ADJ2'), Dev4LotNo(RunNo, 1));
    end;

    local procedure CreateDev4SalesOrder()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader."No." := Dev4DocNo('SO');
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", Dev4CustomerTok);
        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Shipment Date", WorkDate());
        SalesHeader.Validate("Location Code", Dev4LocationTok);
        SalesHeader."External Document No." := SalesHeader."No.";
        SalesHeader.Modify(true);

        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := 10000;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", Dev4ItemTok);
        SalesLine.Validate("Location Code", Dev4LocationTok);
        SalesLine.Validate(Quantity, 10);
        SalesLine.Validate("Unit Price", 100);
        SalesLine.Modify(true);

        AddDev4Lot(Database::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", '', SalesLine."Line No.",
          SalesLine."Qty. per Unit of Measure", Dev4LotNo(RunNo, 1), 10, 0D, 0D, SalesLine."Shipment Date", "Reservation Status"::Surplus);

        StepResultText := StrSubstNo('Sales order %1 for customer %2: 10 pcs from lot %3, Production Date left blank on the tracking line.', SalesHeader."No.", Dev4CustomerTok, Dev4LotNo(RunNo, 1));
    end;

    local procedure PostDev4Journal()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        LineCount: Integer;
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev4BatchTok);
        LineCount := ItemJnlLine.Count();
        ItemJnlLine.FindFirst();
        ItemJnlPostBatch.Run(ItemJnlLine);
        StepResultText := StrSubstNo('%1 journal line(s) posted.', LineCount);
    end;

    local procedure PostDev4PurchOrder(PurchOrderNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        PurchHeader.Get(PurchHeader."Document Type"::Order, PurchOrderNo);
        PurchHeader.Receive := true;
        PurchHeader.Invoice := false;
        PurchPost.Run(PurchHeader);
        PurchHeader.Get(PurchHeader."Document Type"::Order, PurchOrderNo);
        StepResultText := StrSubstNo('Received: Posted Purchase Receipt %1.', PurchHeader."Last Receiving No.");
    end;

    local procedure PostDev4SalesOrder(SalesOrderNo: Code[20])
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

    local procedure DeleteDev4Journal()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        LineCount: Integer;
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev4BatchTok);
        LineCount := ItemJnlLine.Count();
        ItemJnlLine.DeleteAll(true);
        StepResultText := StrSubstNo('%1 line(s) and their item tracking deleted.', LineCount);
    end;

    local procedure DeleteDev4PurchOrder(PurchOrderNo: Code[20])
    var
        PurchHeader: Record "Purchase Header";
        ReleasePurchDoc: Codeunit "Release Purchase Document";
    begin
        PurchHeader.Get(PurchHeader."Document Type"::Order, PurchOrderNo);
        if PurchHeader.Status <> PurchHeader.Status::Open then
            ReleasePurchDoc.Reopen(PurchHeader);
        PurchHeader.Delete(true);
        StepResultText := 'Deleted.';
    end;

    local procedure RunDev4Step(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; StepMode: Integer; DocNo: Code[20]): Boolean
    var
        ResultTxt: Text;
    begin
        if RunStep(StepMode, 0, DocNo, ResultTxt) then begin
            AddResult(TempResult, StepCode, Description, PassTok, ResultTxt);
            exit(true);
        end;
        AddResult(TempResult, StepCode, Description, FailTok, ResultTxt);
        exit(false);
    end;

    // =====================================================================
    // DEV-004 setup helpers
    // =====================================================================

    local procedure CheckDev4NoSeriesSetup()
    var
        PurchSetup: Record "Purchases & Payables Setup";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        PurchSetup.Get();
        PurchSetup.TestField("Posted Receipt Nos.");
        SalesSetup.Get();
        SalesSetup.TestField("Posted Shipment Nos.");
    end;

    local procedure EnsureDev4TrackingCode()
    var
        ItemTrackingCode: Record "Item Tracking Code";
    begin
        if ItemTrackingCode.Get(Dev4TrackingCodeTok) then begin
            if not ItemTrackingCode."Lot Specific Tracking" then
                Error(Dev4TrackingCodeErr, Dev4TrackingCodeTok);
            exit;
        end;

        ItemTrackingCode.Init();
        ItemTrackingCode.Code := Dev4TrackingCodeTok;
        ItemTrackingCode.Description := 'CHM TEST Lot tracking DEV-004';
        ItemTrackingCode.Insert(true);
        ItemTrackingCode.Validate("Lot Specific Tracking", true);
        ItemTrackingCode.Modify(true);
    end;

    local procedure EnsureDev4Location()
    var
        Location: Record Location;
    begin
        if Location.Get(Dev4LocationTok) then begin
            if Location."Require Receive" or Location."Require Shipment" or Location."Require Put-away" or Location."Require Pick" or
               Location."Bin Mandatory" or Location."Directed Put-away and Pick"
            then
                Error(Dev4LocationSetupErr, Dev4LocationTok);
            exit;
        end;

        Location.Init();
        Location.Code := Dev4LocationTok;
        Location.Name := 'CHM TEST Location DEV-004';
        Location.Insert(true);
    end;

    local procedure EnsureDev4ItemTrackingCode()
    var
        Item: Record Item;
    begin
        Item.Get(Dev4ItemTok);
        if Item."Item Tracking Code" = Dev4TrackingCodeTok then
            exit;
        if Item."Item Tracking Code" <> '' then
            Error(Dev4ItemTrackingErr, Dev4ItemTok, Item."Item Tracking Code", Dev4TrackingCodeTok);
        Item.Validate("Item Tracking Code", Dev4TrackingCodeTok);
        Item.Modify(true);
    end;

    local procedure FindTemplateVendor(var TemplateVendor: Record Vendor; GenProdPostingGroup: Code[20])
    var
        GeneralPostingSetup: Record "General Posting Setup";
    begin
        if TemplateVendorNo <> '' then begin
            TemplateVendor.Get(TemplateVendorNo);
            TemplateVendor.TestField(Blocked, TemplateVendor.Blocked::" ");
            TemplateVendor.TestField("Vendor Posting Group");
            TemplateVendor.TestField("Gen. Bus. Posting Group");
            exit;
        end;

        TemplateVendor.SetRange(Blocked, TemplateVendor.Blocked::" ");
        TemplateVendor.SetRange("Currency Code", '');
        TemplateVendor.SetFilter("Vendor Posting Group", '<>%1', '');
        TemplateVendor.SetFilter("Gen. Bus. Posting Group", '<>%1', '');
        TemplateVendor.SetFilter("No.", '<>%1', Dev4VendorTok);
        if TemplateVendor.FindSet() then
            repeat
                if GeneralPostingSetup.Get(TemplateVendor."Gen. Bus. Posting Group", GenProdPostingGroup) then
                    exit;
            until TemplateVendor.Next() = 0;
        Error(NoTemplateVendorErr, GenProdPostingGroup);
    end;

    local procedure EnsureTestVendor(TemplateVendor: Record Vendor)
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Dev4VendorTok) then
            exit;

        Vendor.Init();
        Vendor."No." := Dev4VendorTok;
        Vendor.Insert(true);
        Vendor.Validate(Name, 'CHM TEST Vendor DEV-004');
        Vendor.Address := TemplateVendor.Address;
        Vendor.City := TemplateVendor.City;
        Vendor."Post Code" := TemplateVendor."Post Code";
        Vendor.County := TemplateVendor.County;
        Vendor."Country/Region Code" := TemplateVendor."Country/Region Code";
        Vendor.Validate("Vendor Posting Group", TemplateVendor."Vendor Posting Group");
        Vendor.Validate("Gen. Bus. Posting Group", TemplateVendor."Gen. Bus. Posting Group");
        Vendor.Validate("VAT Bus. Posting Group", TemplateVendor."VAT Bus. Posting Group");
        Vendor."Tax Area Code" := TemplateVendor."Tax Area Code";
        Vendor."Tax Liable" := TemplateVendor."Tax Liable";
        Vendor."Payment Terms Code" := TemplateVendor."Payment Terms Code";
        Vendor."Payment Method Code" := TemplateVendor."Payment Method Code";
        Vendor."Prices Including VAT" := TemplateVendor."Prices Including VAT";
        Vendor.Modify(true);
    end;

    local procedure FindDev4JnlTemplate(var ItemJnlTemplate: Record "Item Journal Template")
    begin
        ItemJnlTemplate.SetRange(Type, ItemJnlTemplate.Type::Item);
        ItemJnlTemplate.SetRange(Recurring, false);
        if not ItemJnlTemplate.FindFirst() then
            Error(NoItemJnlTemplateErr);
    end;

    local procedure EnsureDev4JournalBatch()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        if not ItemJnlBatch.Get(ItemJnlTemplate.Name, Dev4BatchTok) then begin
            ItemJnlBatch.Init();
            ItemJnlBatch."Journal Template Name" := ItemJnlTemplate.Name;
            ItemJnlBatch.Name := Dev4BatchTok;
            ItemJnlBatch.Description := 'CHM TEST DEV-004';
            ItemJnlBatch.Insert(true);
        end;

        // Manual document numbers are used, so the batch must not have number series.
        if (ItemJnlBatch."No. Series" <> '') or (ItemJnlBatch."Posting No. Series" <> '') then begin
            ItemJnlBatch."No. Series" := '';
            ItemJnlBatch."Posting No. Series" := '';
            ItemJnlBatch.Modify(true);
        end;
    end;

    local procedure CheckDev4JournalEmpty()
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        if Dev4JournalHasLines() then
            Error(Dev4BatchNotEmptyErr, ItemJnlTemplate.Name, Dev4BatchTok);
    end;

    local procedure CreateDev4JnlLine(var ItemJnlLine: Record "Item Journal Line"; DocNo: Code[20]; Qty: Decimal)
    var
        ItemJnlTemplate: Record "Item Journal Template";
        LastItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        LastItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        LastItemJnlLine.SetRange("Journal Batch Name", Dev4BatchTok);
        if LastItemJnlLine.FindLast() then
            LineNo := LastItemJnlLine."Line No.";
        LineNo += 10000;

        Clear(ItemJnlLine);
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := ItemJnlTemplate.Name;
        ItemJnlLine."Journal Batch Name" := Dev4BatchTok;
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine.Insert(true);
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Document No." := DocNo;
        ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
        ItemJnlLine.Validate("Item No.", Dev4ItemTok);
        ItemJnlLine.Validate("Location Code", Dev4LocationTok);
        ItemJnlLine.Validate(Quantity, Qty);
        ItemJnlLine.Validate("Unit Amount", 10);
        ItemJnlLine.Modify(true);
    end;

    local procedure AddDev4JnlLineLot(ItemJnlLine: Record "Item Journal Line"; LotNo: Code[50]; QtyBase: Decimal; ProductionDate: Date)
    begin
        AddDev4Lot(Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name",
          ItemJnlLine."Line No.", ItemJnlLine."Qty. per Unit of Measure", LotNo, QtyBase, ProductionDate, ItemJnlLine."Posting Date", 0D, "Reservation Status"::Prospect);
    end;

    local procedure AddDev4Lot(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer; QtyPerUoM: Decimal; LotNo: Code[50]; QtyBase: Decimal; ProductionDate: Date; ExpectedReceiptDate: Date; ShipmentDate: Date; Status: Enum "Reservation Status")
    var
        ForReservEntry: Record "Reservation Entry";
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        // Same records the Item Tracking Lines page creates for a lot line.
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;
        ForReservEntry.Init();
        ForReservEntry."Lot No." := LotNo;
        CreateReservEntry.CreateReservEntryFor(SourceType, SourceSubtype, SourceID, SourceBatchName, 0, SourceRefNo, QtyPerUoM, QtyBase / QtyPerUoM, QtyBase, ForReservEntry);
        CreateReservEntry.CreateEntry(Dev4ItemTok, '', Dev4LocationTok, '', ExpectedReceiptDate, ShipmentDate, 0, Status);

        // Production Date column of the Item Tracking Lines is stored in field 66600 of the Reservation Entry.
        ReservEntry.SetRange("Source Type", SourceType);
        ReservEntry.SetRange("Source Subtype", SourceSubtype);
        ReservEntry.SetRange("Source ID", SourceID);
        ReservEntry.SetRange("Source Batch Name", SourceBatchName);
        ReservEntry.SetRange("Source Ref. No.", SourceRefNo);
        ReservEntry.SetRange("Lot No.", LotNo);
        if ReservEntry.IsEmpty() then
            Error(Dev4NoReservEntryErr, LotNo, SourceID);
        ReservEntry.ModifyAll("CHM Production Date", ProductionDate);
    end;

    local procedure Dev4JournalHasLines(): Boolean
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev4BatchTok);
        exit(not ItemJnlLine.IsEmpty());
    end;

    local procedure Dev4PurchOrderOutstanding(PurchOrderNo: Code[20]): Boolean
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
        PurchLine.SetRange("Document No.", PurchOrderNo);
        PurchLine.SetFilter("Outstanding Quantity", '>%1', 0);
        exit(not PurchLine.IsEmpty());
    end;

    local procedure Dev4SalesOrderOutstanding(SalesOrderNo: Code[20]): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", SalesOrderNo);
        SalesLine.SetFilter("Outstanding Quantity", '>%1', 0);
        exit(not SalesLine.IsEmpty());
    end;

    local procedure Dev4OutboundCreated(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Order, Dev4DocNo('SO')) then
            exit(true);
        if Dev4IleExists(Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::Sale, '') then
            exit(true);
        exit(Dev4IleExists(Dev4LotNo(RunNo, 1), "Item Ledger Entry Type"::"Positive Adjmt.", Dev4DocNo('ADJ2')));
    end;

    local procedure GetDev004LastRunNo() LastRunNo: Integer
    var
        LotNoInformation: Record "Lot No. Information";
        Value: Integer;
    begin
        // Every run creates lot L4 on the Lot No. Information card, so the cards give the run numbers.
        LotNoInformation.SetRange("Item No.", Dev4ItemTok);
        LotNoInformation.SetFilter("Lot No.", Dev4PrefixTok + '*');
        if LotNoInformation.FindSet() then
            repeat
                if Evaluate(Value, CopyStr(LotNoInformation."Lot No.", StrLen(Dev4PrefixTok) + 1, 2)) then
                    LastRunNo := MaxInt(LastRunNo, Value);
            until LotNoInformation.Next() = 0;
    end;

    // =====================================================================
    // DEV-004 test helpers
    // =====================================================================

    local procedure CheckDev4OpenTracking(var TempResult: Record "Name/Value Buffer" temporary; InboundPosted: Boolean)
    var
        ReservEntry: Record "Reservation Entry";
        ExpectedDate: Date;
        SourceText: Text;
    begin
        ReservEntry.SetRange("Item No.", Dev4ItemTok);
        ReservEntry.SetFilter("Lot No.", Dev4LotPrefix(RunNo) + '*');
        if not ReservEntry.FindSet() then begin
            AddResult(TempResult, Dev4TestStepTok, 'Open item tracking lines', InfoTok, 'None open: all test documents of this run are posted or not created yet.');
            exit;
        end;

        repeat
            ExpectedDate := Dev4ExpectedOpenDate(ReservEntry, InboundPosted);
            case ReservEntry."Source Type" of
                Database::"Item Journal Line":
                    SourceText := StrSubstNo('item journal %1 line %2', ReservEntry."Source Batch Name", ReservEntry."Source Ref. No.");
                Database::"Purchase Line":
                    SourceText := StrSubstNo('purchase order %1', ReservEntry."Source ID");
                Database::"Sales Line":
                    SourceText := StrSubstNo('sales order %1', ReservEntry."Source ID");
                else
                    SourceText := StrSubstNo('source %1 %2', ReservEntry."Source Type", ReservEntry."Source ID");
            end;
            SetResultLink(ReservEntry);
            AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines on %1, lot %2', SourceText, ReservEntry."Lot No."),
              ReservEntry."CHM Production Date" = ExpectedDate,
              StrSubstNo('Qty (base) %1, Production Date %2.', Abs(ReservEntry."Quantity (Base)"), DateText(ReservEntry."CHM Production Date")),
              StrSubstNo('Production Date %1, expected %2.', DateText(ReservEntry."CHM Production Date"), DateText(ExpectedDate)));
        until ReservEntry.Next() = 0;
    end;

    local procedure Dev4ExpectedOpenDate(ReservEntry: Record "Reservation Entry"; InboundPosted: Boolean): Date
    var
        LotIndex: Integer;
    begin
        if ReservEntry."Source Type" = Database::"Sales Line" then
            exit(0D);
        if not Evaluate(LotIndex, CopyStr(ReservEntry."Lot No.", StrLen(ReservEntry."Lot No."), 1)) then
            exit(0D);
        if (ReservEntry."Source Type" = Database::"Item Journal Line") and InboundPosted then
            case LotIndex of
                1:
                    exit(0D);
                2:
                    exit(Dev4ChangedLot2Date());
            end;
        exit(Dev4ProdDate(LotIndex));
    end;

    local procedure Dev4IleExists(LotNo: Code[50]; EntryType: Enum "Item Ledger Entry Type"; DocNo: Code[20]): Boolean
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", Dev4ItemTok);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetRange("Entry Type", EntryType);
        if DocNo <> '' then
            ItemLedgerEntry.SetRange("Document No.", DocNo);
        exit(not ItemLedgerEntry.IsEmpty());
    end;

    local procedure CheckDev4Ile(var TempResult: Record "Name/Value Buffer" temporary; Description: Text; LotNo: Code[50]; EntryType: Enum "Item Ledger Entry Type"; DocNo: Code[20]; ExpectedQty: Decimal; ExpectedDate: Date)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", Dev4ItemTok);
        ItemLedgerEntry.SetRange("Lot No.", LotNo);
        ItemLedgerEntry.SetRange("Entry Type", EntryType);
        if DocNo <> '' then
            ItemLedgerEntry.SetRange("Document No.", DocNo);
        if not ItemLedgerEntry.FindFirst() then begin
            AddResult(TempResult, Dev4TestStepTok, Description, FailTok, StrSubstNo('No %1 item ledger entry found for lot %2.', EntryType, LotNo));
            exit;
        end;

        SetResultLink(ItemLedgerEntry);
        AddCheck(TempResult, Dev4TestStepTok, Description,
          (ItemLedgerEntry.Quantity = ExpectedQty) and (ItemLedgerEntry."CHM Production Date" = ExpectedDate),
          StrSubstNo('Entry %1 (%2 %3): lot %4, Qty %5, Production Date %6.', ItemLedgerEntry."Entry No.", ItemLedgerEntry."Document Type", ItemLedgerEntry."Document No.",
            LotNo, ItemLedgerEntry.Quantity, DateText(ItemLedgerEntry."CHM Production Date")),
          StrSubstNo('Entry %1 (%2): Qty %3 (expected %4), Production Date %5 (expected %6).', ItemLedgerEntry."Entry No.", ItemLedgerEntry."Document No.",
            ItemLedgerEntry.Quantity, ExpectedQty, DateText(ItemLedgerEntry."CHM Production Date"), DateText(ExpectedDate)));
    end;

    local procedure CheckDev4LotInfo(var TempResult: Record "Name/Value Buffer" temporary; Description: Text; LotNo: Code[50]; ExpectedDate: Date)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if not LotNoInformation.Get(Dev4ItemTok, '', LotNo) then begin
            AddResult(TempResult, Dev4TestStepTok, Description, FailTok, StrSubstNo('No Lot No. Information card for lot %1.', LotNo));
            exit;
        end;
        SetResultLink(LotNoInformation);
        AddCheck(TempResult, Dev4TestStepTok, Description, LotNoInformation."CHM Production Date" = ExpectedDate,
          StrSubstNo('Lot %1: Production Date %2 on the Lot No. Information card.', LotNo, DateText(LotNoInformation."CHM Production Date")),
          StrSubstNo('Lot %1: Production Date %2, expected %3.', LotNo, DateText(LotNoInformation."CHM Production Date"), DateText(ExpectedDate)));
    end;

    local procedure CheckDev4LotInventory(var TempResult: Record "Name/Value Buffer" temporary; LotIndex: Integer; ExpectedQty: Decimal)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if not LotNoInformation.Get(Dev4ItemTok, '', Dev4LotNo(RunNo, LotIndex)) then
            exit;
        LotNoInformation.CalcFields(Inventory);
        SetResultLink(LotNoInformation);
        AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Inventory of lot %1', LotNoInformation."Lot No."), LotNoInformation.Inventory = ExpectedQty,
          StrSubstNo('%1 pcs, Production Date %2.', LotNoInformation.Inventory, DateText(LotNoInformation."CHM Production Date")),
          StrSubstNo('%1 pcs, expected %2.', LotNoInformation.Inventory, ExpectedQty));
    end;

    local procedure RunDev4ValidationTests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        TempTrackingSpec: Record "Tracking Specification" temporary;
        LotProductionDateMgt: Codeunit "CHM Lot Production Date Mgt.";
        Lot1: Code[50];
        Lot2: Code[50];
        NewLot: Code[50];
        Lot1Date: Date;
        Lot2Date: Date;
        Succeeded: Boolean;
    begin
        // Same field logic the Item Tracking Lines page runs (table extension 66606), on a temporary record.
        Lot1 := Dev4LotNo(RunNo, 1);
        Lot2 := Dev4LotNo(RunNo, 2);
        NewLot := Dev4LotNo(RunNo, 9);
        Lot1Date := LotProductionDateMgt.GetLotProductionDate(Dev4ItemTok, '', Lot1);
        Lot2Date := LotProductionDateMgt.GetLotProductionDate(Dev4ItemTok, '', Lot2);
        if Lot1Date = 0D then begin
            AddResult(TempResult, Dev4TestStepTok, 'Item Tracking Lines rules', InfoTok, StrSubstNo('Skipped: lot %1 has no Production Date on its card.', Lot1));
            exit;
        end;

        TempTrackingSpec.Init();
        TempTrackingSpec."Entry No." := 1;
        TempTrackingSpec."Item No." := Dev4ItemTok;
        TempTrackingSpec."Location Code" := Dev4LocationTok;
        TempTrackingSpec."Qty. per Unit of Measure" := 1;
        TempTrackingSpec.Insert();

        ClearLastError();
        Succeeded := TryValidateTrackingLotNo(TempTrackingSpec, Lot1);
        AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines: entering existing lot %1 fills the Production Date', Lot1),
          Succeeded and (TempTrackingSpec."CHM Production Date" = Lot1Date),
          StrSubstNo('Production Date filled with %1 from the Lot No. Information card.', DateText(Lot1Date)),
          StrSubstNo('Production Date %1, expected %2. %3', DateText(TempTrackingSpec."CHM Production Date"), DateText(Lot1Date), GetLastErrorText()));

        ClearLastError();
        Succeeded := TryValidateTrackingProdDate(TempTrackingSpec, Lot1Date + 1);
        AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines: a different Production Date for lot %1 is blocked', Lot1),
          (not Succeeded) and (StrPos(GetLastErrorText(), Lot1) > 0),
          StrSubstNo(ErrorAsExpectedTxt, GetLastErrorText()),
          StrSubstNo('%1 %2', NoErrorRaisedTxt, GetLastErrorText()));

        ClearLastError();
        Succeeded := TryValidateTrackingProdDate(TempTrackingSpec, Lot1Date);
        AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines: the same Production Date for lot %1 is accepted', Lot1),
          Succeeded, AcceptedTxt, GetLastErrorText());

        if Lot2Date <> 0D then begin
            ClearLastError();
            Succeeded := TryValidateTrackingLotNo(TempTrackingSpec, Lot2);
            AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines: switching to lot %1 takes that lot''s date', Lot2),
              Succeeded and (TempTrackingSpec."CHM Production Date" = Lot2Date),
              StrSubstNo('Production Date changed to %1.', DateText(Lot2Date)),
              StrSubstNo('Production Date %1, expected %2. %3', DateText(TempTrackingSpec."CHM Production Date"), DateText(Lot2Date), GetLastErrorText()));
        end;

        ClearLastError();
        Succeeded := TryValidateTrackingLotNo(TempTrackingSpec, NewLot);
        AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines: switching to new lot %1 clears the date', NewLot),
          Succeeded and (TempTrackingSpec."CHM Production Date" = 0D),
          'Production Date cleared, ready to be entered for the new lot.',
          StrSubstNo('Production Date %1, expected blank. %2', DateText(TempTrackingSpec."CHM Production Date"), GetLastErrorText()));

        ClearLastError();
        Succeeded := TryValidateTrackingProdDate(TempTrackingSpec, Dev4ProdDate(1) - 30);
        AddCheck(TempResult, Dev4TestStepTok, StrSubstNo('Item Tracking Lines: any Production Date is accepted for new lot %1', NewLot),
          Succeeded, AcceptedTxt, GetLastErrorText());
    end;

    [TryFunction]
    local procedure TryValidateTrackingLotNo(var TrackingSpecification: Record "Tracking Specification"; LotNo: Code[50])
    begin
        TrackingSpecification.Validate("Lot No.", LotNo);
    end;

    [TryFunction]
    local procedure TryValidateTrackingProdDate(var TrackingSpecification: Record "Tracking Specification"; ProductionDate: Date)
    begin
        TrackingSpecification.Validate("CHM Production Date", ProductionDate);
    end;

    // =====================================================================
    // DEV-004 test data definition
    // =====================================================================

    local procedure Dev4LotPrefix(TestRunNo: Integer): Text
    begin
        // e.g. CHMT4-R01-
        exit(Dev4PrefixTok + Format(TestRunNo, 0, '<Integer,2><Filler Character,0>') + '-');
    end;

    local procedure Dev4LotNo(TestRunNo: Integer; LotIndex: Integer): Code[50]
    begin
        // e.g. CHMT4-R01-L1
        exit(CopyStr(Dev4LotPrefix(TestRunNo) + 'L' + Format(LotIndex), 1, 50));
    end;

    local procedure Dev4DocNo(Suffix: Text): Code[20]
    begin
        // e.g. CHMT4-R01-IN, CHMT4-R01-ADJ2, CHMT4-R01-PO, CHMT4-R01-SO
        exit(CopyStr(Dev4LotPrefix(RunNo) + Suffix, 1, 20));
    end;

    local procedure Dev4ProdDate(LotIndex: Integer): Date
    begin
        case LotIndex of
            1:
                exit(DMY2Date(15, 10, 2026));
            2:
                exit(DMY2Date(20, 10, 2026));
            3:
                exit(DMY2Date(25, 10, 2026));
            4:
                exit(DMY2Date(28, 10, 2026));
        end;
        exit(0D);
    end;

    local procedure Dev4ChangedLot2Date(): Date
    begin
        exit(DMY2Date(21, 10, 2026));
    end;

    local procedure DateText(Value: Date): Text
    begin
        if Value = 0D then
            exit('blank');
        exit(Format(Value));
    end;

    local procedure PostedText(Posted: Boolean): Text
    begin
        if Posted then
            exit('posted');
        exit('not posted');
    end;

    // =====================================================================
    // Result helpers and constants
    // =====================================================================

    local procedure ClearStepResults(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    begin
        TempResult.Reset();
        TempResult.SetFilter(Name, StepCode + '*');
        TempResult.DeleteAll();
        TempResult.Reset();
        DevTestCounter := 0;
    end;

    local procedure AddCheck(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; Passed: Boolean; PassDetails: Text; FailDetails: Text)
    begin
        if Passed then
            AddResult(TempResult, StepCode, Description, PassTok, PassDetails)
        else
            AddResult(TempResult, StepCode, Description, FailTok, FailDetails);
    end;

    local procedure AddResult(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text; Description: Text; Status: Text; Details: Text)
    var
        NextId: Integer;
    begin
        DevTestCounter += 1;
        TempResult.Reset();
        if TempResult.FindLast() then
            NextId := TempResult.ID + 1
        else
            NextId := 1;

        TempResult.Init();
        TempResult.ID := NextId;
        TempResult.Name := CopyStr(StrSubstNo('%1 T%2 %3', StepCode, Format(DevTestCounter, 0, '<Integer,2><Filler Character,0>'), Description), 1, MaxStrLen(TempResult.Name));
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

    local procedure OrderNo(TestRunNo: Integer; i: Integer): Code[20]
    begin
        // e.g. CHMT2-R01-001
        exit(CopyStr(OrderPrefixTok + Format(TestRunNo, 0, '<Integer,2><Filler Character,0>') + '-' + Format(i, 0, '<Integer,3><Filler Character,0>'), 1, 20));
    end;

    local procedure LineQty(LineIndex: Integer; i: Integer): Decimal
    begin
        if LineIndex = 1 then
            exit(10 + i);
        exit(5 + i);
    end;

    local procedure TotalLineQty(LineIndex: Integer) Total: Decimal
    var
        i: Integer;
    begin
        for i := 1 to RunNoOfShipments do
            Total += LineQty(LineIndex, i);
    end;



    procedure GetDev003LocationCode(): Code[10]
    begin
        exit(Dev3LocationTok);
    end;

    procedure GetDev003RunText(): Text
    var
        LastRunNo: Integer;
    begin
        LastRunNo := GetDev003LastRunNo();
        if LastRunNo = 0 then
            exit('No demo data yet');
        exit(StrSubstNo('Run %1: sales orders %2 to %3', LastRunNo, Dev3RunPrefix(LastRunNo) + 'SO1', Dev3RunPrefix(LastRunNo) + 'SO' + Format(Dev3NoOfOrders())));
    end;

    procedure CreateDev003TestData(var TempResult: Record "Name/Value Buffer" temporary)
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
            if not Confirm(Dev3CreateQst, true, CompanyName(), Dev3LocationTok, Dev3BatchTok, Dev3NoOfOrders()) then
                exit;

        ClearStepResults(TempResult, Dev3CreateStepTok);
        RunNo := GetDev003LastRunNo() + 1;
        if RunNo > 99 then
            Error(Dev3TooManyRunsErr);

        if not RunDev4Step(TempResult, Dev3CreateStepTok, 'Setup: location, items, Michelin customers, label no. series, journal batch', RunModeDev3Setup(), '') then
            exit;
        if not RunDev4Step(TempResult, Dev3CreateStepTok, StrSubstNo('Stock: item journal %1 with lots and Production Dates, posted', Dev3DocNo('IN')), RunModeDev3PostStock(), '') then
            exit;

        // One sales order per step, shipped straight away. A failing order does not stop the others.
        for i := 1 to Dev3NoOfOrders() do begin
            SalesOrderNo := Dev3OrderNo(i);
            if RunStep(RunModeDev3CreateOrder(), i, '', ResultTxt) then begin
                AddResult(TempResult, Dev3CreateStepTok, StrSubstNo('Create sales order %1', SalesOrderNo), PassTok, ResultTxt);
                // RunModeDev4PostSalesOrder ships any sales order (Ship only).
                if RunDev4Step(TempResult, Dev3CreateStepTok, StrSubstNo('Ship sales order %1', SalesOrderNo), RunModeDev4PostSalesOrder(), SalesOrderNo) then begin
                    Shipped += 1;
                    if i = Dev3TwoShipmentsOrderIndex() then
                        if RunDev4Step(TempResult, Dev3CreateStepTok, StrSubstNo('Add a second line to sales order %1', SalesOrderNo), RunModeDev3AddSecondLine(), SalesOrderNo) then
                            if RunDev4Step(TempResult, Dev3CreateStepTok, StrSubstNo('Ship sales order %1 again (second shipment)', SalesOrderNo), RunModeDev4PostSalesOrder(), SalesOrderNo) then
                                Shipped += 1;
                end;
            end else
                AddResult(TempResult, Dev3CreateStepTok, StrSubstNo('Create sales order %1', SalesOrderNo), FailTok, ResultTxt);
        end;

        AddDev3DataViews(TempResult, Dev3CreateStepTok);
        AddResult(TempResult, Dev3CreateStepTok, 'Next step', InfoTok,
          StrSubstNo('Run %1: %2 posted sales shipment(s). Click "2. Open Michelin Labels" > Load Shipment Lines and pick the shipments of %3 and %4. The shipment of %5 must not be offered. "3. Check Demo Data" lists the label lines to expect per shipment.',
            RunNo, Shipped, Dev3Mich1Tok, Dev3Mich2Tok, Dev3OtherCustTok));
    end;

    procedure RunDev003Checks(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesShptHeader: Record "Sales Shipment Header";
        ShipmentCount: Integer;
        TotalLabelLines: Integer;
        i: Integer;
    begin
        RunNo := GetDev003LastRunNo();
        if RunNo = 0 then
            Error(Dev3NoRunErr);
        ClearStepResults(TempResult, Dev3CheckStepTok);

        // A. Setup the Michelin labels page and report depend on.
        CheckDev3Customer(TempResult, Dev3Mich1Tok, true, Dev3SupplierCode(1));
        CheckDev3Customer(TempResult, Dev3Mich2Tok, true, Dev3SupplierCode(2));
        CheckDev3Customer(TempResult, Dev3OtherCustTok, false, '');

        SalesSetup.Get();
        AddCheck(TempResult, Dev3CheckStepTok, 'Sales & Receivables Setup: Michelin Label Nos.', SalesSetup."CHM Michelin Label Nos." <> '',
          StrSubstNo('No. series %1 gives the label serial no. (S) when printing.', SalesSetup."CHM Michelin Label Nos."),
          'Blank: Print labels stops with an error. Fill it in or run "1. Create Demo Shipments".');

        // B. Every posted shipment of the run and the lines the page will load for it.
        for i := 1 to Dev3NoOfOrders() do begin
            SalesShptHeader.Reset();
            SalesShptHeader.SetRange("Order No.", Dev3OrderNo(i));
            if SalesShptHeader.FindSet() then
                repeat
                    ShipmentCount += 1;
                    TotalLabelLines += CheckDev3Shipment(TempResult, SalesShptHeader, i <> Dev3NonMichelinOrderIndex());
                until SalesShptHeader.Next() = 0
            else
                AddResult(TempResult, Dev3CheckStepTok, StrSubstNo('Sales order %1', Dev3OrderNo(i)), FailTok,
                  'No posted sales shipment found. See the DEV-003 CREATE lines for the error.');
        end;

        AddResult(TempResult, Dev3CheckStepTok, 'Summary', InfoTok,
          StrSubstNo('Run %1: %2 posted shipment(s), %3 label line(s) in total. Load each Michelin shipment on the Michelin labels page and compare the "line(s) loaded" message with the lines above.',
            RunNo, ShipmentCount, TotalLabelLines));
    end;

    procedure OpenDev003MichelinLabels()
    begin
        Page.Run(Page::"CHM Michelin Labels");
    end;

    procedure OpenDev003PostedShipments()
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader.SetFilter("Order No.", Dev3PrefixTok + '*');
        Page.Run(Page::"Posted Sales Shipments", SalesShptHeader);
    end;

    procedure OpenDev003SalesOrders()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", Dev3PrefixTok + '*');
        Page.Run(Page::"Sales Order List", SalesHeader);
    end;

    procedure DeleteDev003TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesOrderNos: List of [Code[20]];
        DocNo: Code[20];
        Kept: Integer;
    begin
        if GuiAllowed() then
            if not Confirm(Dev3DeleteQst, false) then
                exit;
        ClearStepResults(TempResult, Dev3DeleteStepTok);

        if Dev3JournalHasLines() then
            RunDev4Step(TempResult, Dev3DeleteStepTok, StrSubstNo('Delete open lines of item journal batch %1', Dev3BatchTok), RunModeDev3DeleteJournal(), '');

        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", Dev3PrefixTok + '*');
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

        foreach DocNo in SalesOrderNos do
            RunDev4Step(TempResult, Dev3DeleteStepTok, StrSubstNo('Delete sales order %1', DocNo), RunModeDeleteOrder(), DocNo);

        AddResult(TempResult, Dev3DeleteStepTok, 'Summary', InfoTok,
          StrSubstNo('%1 unshipped sales order(s) processed, %2 shipped order(s) kept. Posted shipments, lots and master data are kept.', SalesOrderNos.Count(), Kept));
    end;

    // =====================================================================
    // DEV-003 steps (run inside OnRun)
    // =====================================================================

    local procedure RunDev3Setup()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        TemplateItem: Record Item;
        TemplateCustomer: Record Customer;
        LabelNos: Code[20];
    begin
        SalesSetup.Get();
        SalesSetup.TestField("Posted Shipment Nos.");
        LabelNos := EnsureDev3LabelNoSeries();

        EnsureDev4TrackingCode(); // lot-only tracking code CHMT4-LOT, shared with DEV-004
        EnsureDev3Location();

        FindTemplateItem(TemplateItem);
        EnsureDev3Item(Dev3Item1Tok, 'CHM TEST EM GREASE LC2 HMC 180 KG DRUM', TemplateItem, true);
        EnsureDev3Item(Dev3Item2Tok, 'CHM TEST SYNHYDRO ISODIO 6S 12 KG', TemplateItem, true);
        EnsureDev3Item(Dev3Item3Tok, 'CHM TEST HYDROXYLAMMONIUM CHLORIDE 25 KG', TemplateItem, true);
        EnsureDev3Item(Dev3Item4Tok, 'CHM TEST CROSSLAMINA CLORIDRATO (no lot)', TemplateItem, false);

        FindTemplateCustomer(TemplateCustomer);
        EnsureDev3Customer(Dev3Mich1Tok, 'CHM TEST MICHELIN ITALIANA SPA', true, Dev3SupplierCode(1),
          'Corso Romania 546', 'Torino', '10156', 'TO', TemplateCustomer);
        EnsureDev3Customer(Dev3Mich2Tok, 'CHM TEST HARRISON - AUSTRALIA', true, Dev3SupplierCode(2),
          '270 Berkshire Road', 'Forrestfield WA', '6058', 'WA', TemplateCustomer);
        EnsureDev3Customer(Dev3OtherCustTok, 'CHM TEST Non-Michelin Customer', false, '',
          'Via Roma 1', 'Milano', '20121', 'MI', TemplateCustomer);

        EnsureDev3JournalBatch();
        CheckDev3JournalEmpty();

        StepResultText := StrSubstNo('Location %1, items %2..%3 (template %4), Michelin customers %5 / %6, non-Michelin customer %7 (template %8), label no. series %9.',
            Dev3LocationTok, Dev3Item1Tok, Dev3Item4Tok, TemplateItem."No.", Dev3Mich1Tok, Dev3Mich2Tok, Dev3OtherCustTok, TemplateCustomer."No.", LabelNos);
    end;

    local procedure PostDev3Stock()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
    begin
        CheckDev3JournalEmpty();

        // Item 1: 2 lots
        CreateDev3JnlLine(ItemJnlLine, Dev3Item1Tok, 160);
        AddDev3JnlLot(ItemJnlLine, Dev3LotNo('A1'), 100, Dev3ProdDate('A1'));
        AddDev3JnlLot(ItemJnlLine, Dev3LotNo('A2'), 60, Dev3ProdDate('A2'));
        // Item 2: 2 lots, B2 without Production Date (label prints 00.00.00)
        CreateDev3JnlLine(ItemJnlLine, Dev3Item2Tok, 120);
        AddDev3JnlLot(ItemJnlLine, Dev3LotNo('B1'), 80, Dev3ProdDate('B1'));
        AddDev3JnlLot(ItemJnlLine, Dev3LotNo('B2'), 40, Dev3ProdDate('B2'));
        // Item 3: 1 lot
        CreateDev3JnlLine(ItemJnlLine, Dev3Item3Tok, 200);
        AddDev3JnlLot(ItemJnlLine, Dev3LotNo('C1'), 200, Dev3ProdDate('C1'));
        // Item 4: no item tracking
        CreateDev3JnlLine(ItemJnlLine, Dev3Item4Tok, 50);

        FindDev4JnlTemplate(ItemJnlTemplate);
        ItemJnlLine.Reset();
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev3BatchTok);
        ItemJnlLine.FindFirst();
        ItemJnlPostBatch.Run(ItemJnlLine);

        StepResultText :=
          StrSubstNo('Posted on %1: %2 lots A1 x100 (%3) + A2 x60 (%4); ', Dev3LocationTok, Dev3Item1Tok, DateText(Dev3ProdDate('A1')), DateText(Dev3ProdDate('A2'))) +
          StrSubstNo('%1 lots B1 x80 (%2) + B2 x40 (blank); ', Dev3Item2Tok, DateText(Dev3ProdDate('B1'))) +
          StrSubstNo('%1 lot C1 x200 (%2); %3 x50 without lot. Lot prefix %4.', Dev3Item3Tok, DateText(Dev3ProdDate('C1')), Dev3Item4Tok, Dev3RunPrefix(RunNo));
    end;

    local procedure CreateDev3SalesOrder(i: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        CreateDev3SalesHeader(SalesHeader, i);
        case i of
            1:
                begin
                    // 2 lots on one line, a second item, a comment line and an untracked item.
                    AddDev3SalesLine(SalesHeader, 10000, Dev3Item1Tok, 40, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('A1'), 25);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('A2'), 15);
                    AddDev3SalesLine(SalesHeader, 20000, Dev3Item2Tok, 10, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('B1'), 10);
                    AddDev3CommentLine(SalesHeader, 30000, 'Comment line: must not be loaded on the Michelin labels page');
                    AddDev3SalesLine(SalesHeader, 40000, Dev3Item4Tok, 4, SalesLine);
                    StepResultText := StrSubstNo('%1 / PO %2: %3 x40 (lots A1 x25 + A2 x15), %4 x10 (lot B1), comment line, %5 x4 without lot. Expected label lines: 4.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", Dev3Item1Tok, Dev3Item2Tok, Dev3Item4Tok);
                end;
            2:
                begin
                    // Different ship-to address than the customer card.
                    AddDev3SalesLine(SalesHeader, 10000, Dev3Item3Tok, 100, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('C1'), 100);
                    AddDev3SalesLine(SalesHeader, 20000, Dev3Item1Tok, 5, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('A1'), 5);
                    StepResultText := StrSubstNo('%1 / PO %2, ship-to %3: %4 x100 (lot C1), %5 x5 (lot A1). Expected label lines: 2.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", SalesHeader."Ship-to Name", Dev3Item3Tok, Dev3Item1Tok);
                end;
            3:
                begin
                    // Second Michelin customer, lot without Production Date.
                    AddDev3SalesLine(SalesHeader, 10000, Dev3Item1Tok, 8, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('A2'), 8);
                    AddDev3SalesLine(SalesHeader, 20000, Dev3Item2Tok, 15, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('B2'), 12);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('B1'), 3);
                    AddDev3SalesLine(SalesHeader, 30000, Dev3Item3Tok, 20, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('C1'), 20);
                    StepResultText := StrSubstNo('%1 / PO %2: %3 x8 (lot A2), %4 x15 (lots B2 x12 without date + B1 x3), %5 x20 (lot C1). Expected label lines: 4.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", Dev3Item1Tok, Dev3Item2Tok, Dev3Item3Tok);
                end;
            4:
                begin
                    // First shipment only; AddDev3SecondShipmentLine adds the line for the second shipment.
                    AddDev3SalesLine(SalesHeader, 10000, Dev3Item1Tok, 6, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('A1'), 6);
                    StepResultText := StrSubstNo('%1 / PO %2: %3 x6 (lot A1) for the first shipment. Expected label lines: 1 per shipment.',
                        SalesHeader."Sell-to Customer No.", SalesHeader."External Document No.", Dev3Item1Tok);
                end;
            5:
                begin
                    // Non-Michelin customer: the shipment must not be offered on the Michelin labels page.
                    AddDev3SalesLine(SalesHeader, 10000, Dev3Item2Tok, 5, SalesLine);
                    AddDev3SalesLot(SalesLine, Dev3LotNo('B1'), 5);
                    StepResultText := StrSubstNo('%1 (not a Michelin customer): %2 x5 (lot B1). Must not appear in Load Shipment Lines.',
                        SalesHeader."Sell-to Customer No.", Dev3Item2Tok);
                end;
        end;
    end;

    local procedure AddDev3SecondShipmentLine(SalesOrderNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        // Sales-Post leaves the order released; a new line needs it open.
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesOrderNo);
        if SalesHeader.Status <> SalesHeader.Status::Open then
            ReleaseSalesDoc.Reopen(SalesHeader);

        AddDev3SalesLine(SalesHeader, 20000, Dev3Item3Tok, 30, SalesLine);
        AddDev3SalesLot(SalesLine, Dev3LotNo('C1'), 30);
        StepResultText := StrSubstNo('Line 20000: %1 x30 (lot %2) added for the second shipment of the same order.', Dev3Item3Tok, Dev3LotNo('C1'));
    end;

    local procedure DeleteDev3Journal()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        LineCount: Integer;
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev3BatchTok);
        LineCount := ItemJnlLine.Count();
        ItemJnlLine.DeleteAll(true);
        StepResultText := StrSubstNo('%1 line(s) and their item tracking deleted.', LineCount);
    end;

    // =====================================================================
    // DEV-003 setup helpers
    // =====================================================================

    local procedure EnsureDev3LabelNoSeries(): Code[20]
    var
        SalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        // Keep an existing setup; only fill a blank field so Print labels works in the sandbox.
        SalesSetup.Get();
        if SalesSetup."CHM Michelin Label Nos." <> '' then
            exit(SalesSetup."CHM Michelin Label Nos.");

        if not NoSeries.Get(Dev3LabelSeriesTok) then begin
            NoSeries.Init();
            NoSeries.Code := Dev3LabelSeriesTok;
            NoSeries.Description := 'CHM TEST Michelin label serial no.';
            NoSeries."Default Nos." := true;
            NoSeries.Insert(true);

            NoSeriesLine.Init();
            NoSeriesLine."Series Code" := Dev3LabelSeriesTok;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := '000000001';
            NoSeriesLine."Increment-by No." := 1;
            NoSeriesLine.Insert(true);
        end;

        SalesSetup."CHM Michelin Label Nos." := Dev3LabelSeriesTok;
        SalesSetup.Modify(true);
        exit(Dev3LabelSeriesTok);
    end;

    local procedure EnsureDev3Location()
    var
        Location: Record Location;
        CompanyInformation: Record "Company Information";
    begin
        if Location.Get(Dev3LocationTok) then begin
            if Location."Require Receive" or Location."Require Shipment" or Location."Require Put-away" or Location."Require Pick" or
               Location."Bin Mandatory" or Location."Directed Put-away and Pick"
            then
                Error(Dev4LocationSetupErr, Dev3LocationTok);
        end else begin
            Location.Init();
            Location.Code := Dev3LocationTok;
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

    local procedure EnsureDev3Item(ItemNo: Code[20]; ItemDescription: Text[100]; TemplateItem: Record Item; LotTracked: Boolean)
    var
        Item: Record Item;
    begin
        EnsureTestItem(ItemNo, ItemDescription, TemplateItem);
        Item.Get(ItemNo);
        if LotTracked then begin
            if Item."Item Tracking Code" <> Dev4TrackingCodeTok then begin
                if Item."Item Tracking Code" <> '' then
                    Error(Dev4ItemTrackingErr, ItemNo, Item."Item Tracking Code", Dev4TrackingCodeTok);
                Item.Validate("Item Tracking Code", Dev4TrackingCodeTok);
                Item.Modify(true);
            end;
        end else
            if Item."Item Tracking Code" <> '' then
                Error(Dev3ItemTrackingErr, ItemNo, Item."Item Tracking Code");

        EnsureInventoryPostingSetup(Dev3LocationTok, Item."Inventory Posting Group");
    end;

    local procedure EnsureDev3Customer(CustomerNo: Code[20]; CustomerName: Text[100]; IsMichelin: Boolean; SupplierCode: Code[20]; NewAddress: Text[100]; NewCity: Text[30]; NewPostCode: Code[20]; NewCounty: Text[30]; TemplateCustomer: Record Customer)
    var
        Customer: Record Customer;
    begin
        // Posting setup copied from the template; country stays the template's so posting setup still matches.
        EnsureTestCustomer(CustomerNo, CustomerName, TemplateCustomer);
        Customer.Get(CustomerNo);
        Customer.Address := NewAddress;
        Customer.City := NewCity;
        Customer."Post Code" := NewPostCode;
        Customer.County := NewCounty;
        Customer."CHM Michelin Customer" := IsMichelin;
        Customer."CHM Michelin Supplier Code" := SupplierCode;
        Customer.Modify(true);
    end;

    local procedure EnsureDev3JournalBatch()
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        if not ItemJnlBatch.Get(ItemJnlTemplate.Name, Dev3BatchTok) then begin
            ItemJnlBatch.Init();
            ItemJnlBatch."Journal Template Name" := ItemJnlTemplate.Name;
            ItemJnlBatch.Name := Dev3BatchTok;
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

    local procedure Dev3JournalHasLines(): Boolean
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        ItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        ItemJnlLine.SetRange("Journal Batch Name", Dev3BatchTok);
        exit(not ItemJnlLine.IsEmpty());
    end;

    local procedure CheckDev3JournalEmpty()
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        if Dev3JournalHasLines() then
            Error(Dev3BatchNotEmptyErr, ItemJnlTemplate.Name, Dev3BatchTok);
    end;

    local procedure CreateDev3JnlLine(var ItemJnlLine: Record "Item Journal Line"; ItemNo: Code[20]; Qty: Decimal)
    var
        ItemJnlTemplate: Record "Item Journal Template";
        LastItemJnlLine: Record "Item Journal Line";
        LineNo: Integer;
    begin
        FindDev4JnlTemplate(ItemJnlTemplate);
        LastItemJnlLine.SetRange("Journal Template Name", ItemJnlTemplate.Name);
        LastItemJnlLine.SetRange("Journal Batch Name", Dev3BatchTok);
        if LastItemJnlLine.FindLast() then
            LineNo := LastItemJnlLine."Line No.";
        LineNo += 10000;

        Clear(ItemJnlLine);
        ItemJnlLine.Init();
        ItemJnlLine."Journal Template Name" := ItemJnlTemplate.Name;
        ItemJnlLine."Journal Batch Name" := Dev3BatchTok;
        ItemJnlLine."Line No." := LineNo;
        ItemJnlLine.Insert(true);
        ItemJnlLine.Validate("Posting Date", WorkDate());
        ItemJnlLine."Document Date" := WorkDate();
        ItemJnlLine."Document No." := Dev3DocNo('IN');
        ItemJnlLine."Source Code" := ItemJnlTemplate."Source Code";
        ItemJnlLine.Validate("Entry Type", ItemJnlLine."Entry Type"::"Positive Adjmt.");
        ItemJnlLine.Validate("Item No.", ItemNo);
        ItemJnlLine.Validate("Location Code", Dev3LocationTok);
        ItemJnlLine.Validate(Quantity, Qty);
        ItemJnlLine.Validate("Unit Amount", 10);
        ItemJnlLine.Modify(true);
    end;

    local procedure AddDev3JnlLot(ItemJnlLine: Record "Item Journal Line"; LotNo: Code[50]; QtyBase: Decimal; ProductionDate: Date)
    begin
        AddDev3Lot(Database::"Item Journal Line", ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name", ItemJnlLine."Journal Batch Name",
          ItemJnlLine."Line No.", ItemJnlLine."Qty. per Unit of Measure", ItemJnlLine."Item No.", ItemJnlLine."Location Code",
          LotNo, QtyBase, ProductionDate, ItemJnlLine."Posting Date", 0D, "Reservation Status"::Prospect);
    end;

    local procedure CreateDev3SalesHeader(var SalesHeader: Record "Sales Header"; i: Integer)
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader."No." := Dev3OrderNo(i);
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", Dev3OrderCustomer(i));
        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Shipment Date", WorkDate());
        SalesHeader.Validate("Location Code", Dev3LocationTok);
        // The Michelin labels page shows External Document No. as Michelin Purch. Order.
        SalesHeader."External Document No." := Dev3MichelinPO(i);
        if i = 2 then begin
            SalesHeader."Ship-to Name" := 'MICHELIN - CUNEO PLANT';
            SalesHeader."Ship-to Address" := 'Via Ravina 2';
            SalesHeader."Ship-to City" := 'Cuneo';
            SalesHeader."Ship-to Post Code" := '12100';
            SalesHeader."Ship-to County" := 'CN';
        end;
        SalesHeader.Modify(true);
    end;

    local procedure AddDev3SalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; ItemNo: Code[20]; Qty: Decimal; var SalesLine: Record "Sales Line")
    begin
        Clear(SalesLine);
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := LineNo;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::Item);
        SalesLine.Validate("No.", ItemNo);
        SalesLine.Validate("Location Code", Dev3LocationTok);
        SalesLine.Validate(Quantity, Qty);
        SalesLine.Validate("Unit Price", 100);
        SalesLine.Modify(true);
    end;

    local procedure AddDev3CommentLine(SalesHeader: Record "Sales Header"; LineNo: Integer; CommentText: Text[100])
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

    local procedure AddDev3SalesLot(SalesLine: Record "Sales Line"; LotNo: Code[50]; QtyBase: Decimal)
    begin
        // Production Date left blank: posting takes it from the lot (DEV-004).
        AddDev3Lot(Database::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.", '', SalesLine."Line No.",
          SalesLine."Qty. per Unit of Measure", SalesLine."No.", SalesLine."Location Code", LotNo, QtyBase, 0D, 0D, SalesLine."Shipment Date", "Reservation Status"::Surplus);
    end;

    local procedure AddDev3Lot(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceRefNo: Integer; QtyPerUoM: Decimal; ItemNo: Code[20]; LocationCode: Code[10]; LotNo: Code[50]; QtyBase: Decimal; ProductionDate: Date; ExpectedReceiptDate: Date; ShipmentDate: Date; Status: Enum "Reservation Status")
    var
        ForReservEntry: Record "Reservation Entry";
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
    begin
        // Same as AddDev4Lot, for any item and location.
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;
        ForReservEntry.Init();
        ForReservEntry."Lot No." := LotNo;
        CreateReservEntry.CreateReservEntryFor(SourceType, SourceSubtype, SourceID, SourceBatchName, 0, SourceRefNo, QtyPerUoM, QtyBase / QtyPerUoM, QtyBase, ForReservEntry);
        CreateReservEntry.CreateEntry(ItemNo, '', LocationCode, '', ExpectedReceiptDate, ShipmentDate, 0, Status);

        ReservEntry.SetRange("Source Type", SourceType);
        ReservEntry.SetRange("Source Subtype", SourceSubtype);
        ReservEntry.SetRange("Source ID", SourceID);
        ReservEntry.SetRange("Source Batch Name", SourceBatchName);
        ReservEntry.SetRange("Source Ref. No.", SourceRefNo);
        ReservEntry.SetRange("Lot No.", LotNo);
        if ReservEntry.IsEmpty() then
            Error(Dev4NoReservEntryErr, LotNo, SourceID);
        ReservEntry.ModifyAll("CHM Production Date", ProductionDate);
    end;

    // =====================================================================
    // DEV-003 checks and views
    // =====================================================================

    local procedure CheckDev3Customer(var TempResult: Record "Name/Value Buffer" temporary; CustomerNo: Code[20]; ExpectMichelin: Boolean; ExpectedSupplierCode: Code[20])
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(CustomerNo) then begin
            AddResult(TempResult, Dev3CheckStepTok, StrSubstNo('Customer %1', CustomerNo), FailTok, 'Customer not found.');
            exit;
        end;
        SetResultLink(Customer);
        AddCheck(TempResult, Dev3CheckStepTok, StrSubstNo('Customer %1: Michelin Customer = %2', CustomerNo, ExpectMichelin),
          (Customer."CHM Michelin Customer" = ExpectMichelin) and (Customer."CHM Michelin Supplier Code" = ExpectedSupplierCode),
          StrSubstNo('%1, Michelin Supplier Code "%2".', Customer.Name, Customer."CHM Michelin Supplier Code"),
          StrSubstNo('Michelin Customer = %1 (expected %2), Supplier Code "%3" (expected "%4").',
            Customer."CHM Michelin Customer", ExpectMichelin, Customer."CHM Michelin Supplier Code", ExpectedSupplierCode));
    end;

    local procedure CheckDev3Shipment(var TempResult: Record "Name/Value Buffer" temporary; SalesShptHeader: Record "Sales Shipment Header"; ExpectMichelin: Boolean) LabelLines: Integer
    var
        SalesShptLine: Record "Sales Shipment Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
        Details: Text;
        LotQty: Decimal;
        QtyMismatch: Boolean;
    begin
        SalesShptHeader.CalcFields("CHM Michelin Customer");
        SetResultLink(SalesShptHeader);
        if ExpectMichelin then
            AddCheck(TempResult, Dev3CheckStepTok, StrSubstNo('Shipment %1 (order %2): offered on Load Shipment Lines', SalesShptHeader."No.", SalesShptHeader."Order No."),
              SalesShptHeader."CHM Michelin Customer",
              StrSubstNo('Customer %1, Michelin PO %2, ship-to %3, %4.', SalesShptHeader."Sell-to Customer No.", SalesShptHeader."External Document No.",
                SalesShptHeader."Ship-to Name", SalesShptHeader."Ship-to City"),
              StrSubstNo('Michelin Customer is No for customer %1.', SalesShptHeader."Sell-to Customer No."))
        else begin
            AddCheck(TempResult, Dev3CheckStepTok, StrSubstNo('Shipment %1 (order %2): NOT offered on Load Shipment Lines', SalesShptHeader."No.", SalesShptHeader."Order No."),
              not SalesShptHeader."CHM Michelin Customer",
              StrSubstNo('Customer %1 is not a Michelin customer, so the shipment is filtered out.', SalesShptHeader."Sell-to Customer No."),
              StrSubstNo('Michelin Customer is Yes for customer %1.', SalesShptHeader."Sell-to Customer No."));
            exit(0);
        end;

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
        AddCheck(TempResult, Dev3CheckStepTok, StrSubstNo('Shipment %1: label lines to expect', SalesShptHeader."No."),
          (LabelLines > 0) and (not QtyMismatch),
          StrSubstNo('%1 line(s): %2', LabelLines, Details),
          StrSubstNo('Lot quantities do not add up to the shipment lines (or no lines). %1', Details));
    end;

    local procedure AddDev3DataViews(var TempResult: Record "Name/Value Buffer" temporary; StepCode: Text)
    var
        Customer: Record Customer;
        Location: Record Location;
        SalesShptHeader: Record "Sales Shipment Header";
        i: Integer;
    begin
        if Location.Get(Dev3LocationTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Location %1 (Ship-from)', Location.Code),
              StrSubstNo('%1, %2, %3 %4.', Location.Name, Location.Address, Location."Post Code", Location.City), Location);
        if Customer.Get(Dev3Mich1Tok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Michelin customer %1', Customer."No."),
              StrSubstNo('%1, supplier code %2.', Customer.Name, Customer."CHM Michelin Supplier Code"), Customer);
        if Customer.Get(Dev3Mich2Tok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Michelin customer %1', Customer."No."),
              StrSubstNo('%1, supplier code %2.', Customer.Name, Customer."CHM Michelin Supplier Code"), Customer);
        if Customer.Get(Dev3OtherCustTok) then
            AddViewRow(TempResult, StepCode, StrSubstNo('Non-Michelin customer %1', Customer."No."), Customer.Name, Customer);

        for i := 1 to Dev3NoOfOrders() do begin
            SalesShptHeader.Reset();
            SalesShptHeader.SetRange("Order No.", Dev3OrderNo(i));
            if SalesShptHeader.FindSet() then
                repeat
                    AddViewRow(TempResult, StepCode, StrSubstNo('Posted sales shipment %1 (order %2)', SalesShptHeader."No.", SalesShptHeader."Order No."),
                      StrSubstNo('Customer %1, Michelin PO %2, ship-to %3.', SalesShptHeader."Sell-to Customer No.", SalesShptHeader."External Document No.", SalesShptHeader."Ship-to Name"),
                      SalesShptHeader);
                until SalesShptHeader.Next() = 0;
        end;
    end;

    local procedure GetDev003LastRunNo() LastRunNo: Integer
    var
        SalesHeader: Record "Sales Header";
        SalesShptHeader: Record "Sales Shipment Header";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Run numbers come from the test orders, their shipments and the posted lots.
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("No.", Dev3PrefixTok + '*');
        if SalesHeader.FindSet() then
            repeat
                KeepHigherDev3RunNo(LastRunNo, SalesHeader."No.");
            until SalesHeader.Next() = 0;

        SalesShptHeader.SetFilter("Order No.", Dev3PrefixTok + '*');
        if SalesShptHeader.FindSet() then
            repeat
                KeepHigherDev3RunNo(LastRunNo, SalesShptHeader."Order No.");
            until SalesShptHeader.Next() = 0;

        ItemLedgerEntry.SetRange("Item No.", Dev3Item1Tok);
        ItemLedgerEntry.SetFilter("Lot No.", Dev3PrefixTok + '*');
        if ItemLedgerEntry.FindSet() then
            repeat
                KeepHigherDev3RunNo(LastRunNo, ItemLedgerEntry."Lot No.");
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure KeepHigherDev3RunNo(var LastRunNo: Integer; Value: Text)
    var
        Number: Integer;
    begin
        if Evaluate(Number, CopyStr(Value, StrLen(Dev3PrefixTok) + 1, 2)) then
            if Number > LastRunNo then
                LastRunNo := Number;
    end;

    // =====================================================================
    // DEV-003 demo data definition
    // =====================================================================

    local procedure Dev3RunPrefix(TestRunNo: Integer): Text
    begin
        // e.g. CHMT3-R01-
        exit(Dev3PrefixTok + Format(TestRunNo, 0, '<Integer,2><Filler Character,0>') + '-');
    end;

    local procedure Dev3DocNo(Suffix: Text): Code[20]
    begin
        // e.g. CHMT3-R01-IN, CHMT3-R01-SO1
        exit(CopyStr(Dev3RunPrefix(RunNo) + Suffix, 1, 20));
    end;

    local procedure Dev3OrderNo(i: Integer): Code[20]
    begin
        exit(Dev3DocNo('SO' + Format(i)));
    end;

    local procedure Dev3LotNo(Suffix: Text): Code[50]
    begin
        // e.g. CHMT3-R01-A1
        exit(CopyStr(Dev3RunPrefix(RunNo) + Suffix, 1, 50));
    end;

    local procedure Dev3ProdDate(LotSuffix: Text): Date
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

    local procedure Dev3MichelinPO(i: Integer): Code[35]
    begin
        // e.g. MPO-450001-0003 (run 1, order 3)
        exit(CopyStr('MPO-45' + Format(RunNo, 0, '<Integer,4><Filler Character,0>') + '-' + Format(i, 0, '<Integer,4><Filler Character,0>'), 1, 35));
    end;

    local procedure Dev3OrderCustomer(i: Integer): Code[20]
    begin
        case i of
            1, 2:
                exit(Dev3Mich1Tok);
            3, 4:
                exit(Dev3Mich2Tok);
        end;
        exit(Dev3OtherCustTok);
    end;

    local procedure Dev3SupplierCode(CustomerIndex: Integer): Code[20]
    begin
        if CustomerIndex = 1 then
            exit('020061');
        exit('020062');
    end;

    local procedure Dev3NoOfOrders(): Integer
    begin
        exit(5);
    end;

    local procedure Dev3TwoShipmentsOrderIndex(): Integer
    begin
        exit(4);
    end;

    local procedure Dev3NonMichelinOrderIndex(): Integer
    begin
        exit(5);
    end;


    // -------------------------------------------------------------------------------------
    // BLOCK 5 - run modes: add at the end of the codeunit, after RunModeDev4DeletePurchOrder()
    // -------------------------------------------------------------------------------------

    local procedure RunModeDev3Setup(): Integer
    begin
        exit(20);
    end;

    local procedure RunModeDev3PostStock(): Integer
    begin
        exit(21);
    end;

    local procedure RunModeDev3CreateOrder(): Integer
    begin
        exit(22);
    end;

    local procedure RunModeDev3AddSecondLine(): Integer
    begin
        exit(23);
    end;

    local procedure RunModeDev3DeleteJournal(): Integer
    begin
        exit(24);
    end;


    local procedure FirstShipmentFieldNo(): Integer
    begin
        exit(66600); // CHM Total Net Weight
    end;

    local procedure LastShipmentFieldNo(): Integer
    begin
        exit(66606); // CHM Non-reusable Packaging
    end;

    local procedure RunModeSetup(): Integer
    begin
        exit(1);
    end;

    local procedure RunModeCreateShipment(): Integer
    begin
        exit(2);
    end;

    local procedure RunModePostShipment(): Integer
    begin
        exit(3);
    end;

    local procedure RunModeDeleteShipment(): Integer
    begin
        exit(4);
    end;

    local procedure RunModeDeleteOrder(): Integer
    begin
        exit(5);
    end;

    local procedure RunModeDev4Setup(): Integer
    begin
        exit(10);
    end;

    local procedure RunModeDev4CreateInbound(): Integer
    begin
        exit(11);
    end;

    local procedure RunModeDev4CreatePurchOrder(): Integer
    begin
        exit(12);
    end;

    local procedure RunModeDev4PostJournal(): Integer
    begin
        exit(13);
    end;

    local procedure RunModeDev4PostPurchOrder(): Integer
    begin
        exit(14);
    end;

    local procedure RunModeDev4CreateOutboundJnl(): Integer
    begin
        exit(15);
    end;

    local procedure RunModeDev4CreateSalesOrder(): Integer
    begin
        exit(16);
    end;

    local procedure RunModeDev4PostSalesOrder(): Integer
    begin
        exit(17);
    end;

    local procedure RunModeDev4DeleteJournal(): Integer
    begin
        exit(18);
    end;

    local procedure RunModeDev4DeletePurchOrder(): Integer
    begin
        exit(19);
    end;
}
