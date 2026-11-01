codeunit 66690 "CHM Deviation Test Mgt."
{
    // TEST ONLY - DEV-002 test harness. Use in a sandbox; do not ship to production.
    // Creates REAL, postable warehouse shipments WITH LINES:
    //   test location CHMT2-WH (Require Shipment, no pick, no bins) + warehouse employee for the current user
    //   2 test items + 1 test customer (posting groups copied from a template item / customer)
    //   stock posted with an item journal (positive adjustment)
    //   released sales orders CHMT2-Rxx-nnn (2 lines each) -> warehouse shipments created by the standard
    //   "Create Whse. Shipment" logic, Qty. to Ship filled, and the 7 DEV-002 fields filled.
    // After posting, the tests check Warehouse Shipment -> Posted Whse. Shipment -> Posted Sales Shipment
    // for the header fields and the lines.

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
        end;
    end;

    var
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

    // =====================================================================
    // Public procedures used by page 66690
    // =====================================================================

    procedure SetTemplates(NewTemplateItemNo: Code[20]; NewTemplateCustomerNo: Code[20])
    begin
        TemplateItemNo := NewTemplateItemNo;
        TemplateCustomerNo := NewTemplateCustomerNo;
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
        CheckSameFieldDefinition(TempResult, Database::"Warehouse Shipment Header", Database::"Posted Whse. Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());
        CheckSameFieldDefinition(TempResult, Database::"Warehouse Shipment Header", Database::"Sales Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());

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

    // Used by the second instance that runs each step in its own transaction.
    procedure SetContext(NewRunMode: Integer; NewIndex: Integer; NewDocNo: Code[20]; NewRunNo: Integer; NewNoOfShipments: Integer; NewTemplateItemNo: Code[20]; NewTemplateCustomerNo: Code[20])
    begin
        RunMode := NewRunMode;
        RunIndex := NewIndex;
        RunDocNo := NewDocNo;
        RunNo := NewRunNo;
        RunNoOfShipments := NewNoOfShipments;
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
        EnsureInventoryPostingSetup(Item."Inventory Posting Group");
        Item.Get(TestItem2Tok);
        EnsureInventoryPostingSetup(Item."Inventory Posting Group");

        FindTemplateCustomer(TemplateCustomer);
        EnsureTestCustomer(TemplateCustomer);

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
        Runner.SetContext(StepMode, Index, DocNo, RunNo, RunNoOfShipments, TemplateItemNo, TemplateCustomerNo);
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
        TemplateItem.SetFilter("No.", '<>%1&<>%2', TestItem1Tok, TestItem2Tok);
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

    local procedure EnsureInventoryPostingSetup(InvtPostingGroupCode: Code[20])
    var
        InvtPostingSetup: Record "Inventory Posting Setup";
        TemplateSetup: Record "Inventory Posting Setup";
    begin
        if InvtPostingSetup.Get(TestLocationTok, InvtPostingGroupCode) then
            exit;

        TemplateSetup.SetRange("Invt. Posting Group Code", InvtPostingGroupCode);
        TemplateSetup.SetFilter("Inventory Account", '<>%1', '');
        TemplateSetup.SetRange("Location Code", '');
        if not TemplateSetup.FindFirst() then begin
            TemplateSetup.SetRange("Location Code");
            if not TemplateSetup.FindFirst() then
                Error(NoInvtPostingSetupErr, InvtPostingGroupCode, TestLocationTok);
        end;

        InvtPostingSetup := TemplateSetup;
        InvtPostingSetup."Location Code" := TestLocationTok;
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
        TemplateCustomer.SetFilter("No.", '<>%1', TestCustomerTok);
        if not TemplateCustomer.FindFirst() then
            Error(NoTemplateCustomerErr);
    end;

    local procedure EnsureTestCustomer(TemplateCustomer: Record Customer)
    var
        Customer: Record Customer;
    begin
        if Customer.Get(TestCustomerTok) then
            exit;

        Customer.Init();
        Customer."No." := TestCustomerTok;
        Customer.Insert(true);
        Customer.Validate(Name, 'CHM TEST Customer DEV-002');
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

    local procedure CheckSameFieldDefinition(var TempResult: Record "Name/Value Buffer" temporary; RefTableNo: Integer; TableNo: Integer; FromFieldNo: Integer; ToFieldNo: Integer)
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

        AddCheck(TempResult, TestStepTok, StrSubstNo('Field %1..%2 definition on %3 matches %4', FromFieldNo, ToFieldNo, RecRef.Caption, RefRecRef.Caption),
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
}
