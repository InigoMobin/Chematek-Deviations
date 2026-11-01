codeunit 66690 "CHM Deviation Test Mgt."
{
    // TEST ONLY - DEV-001 to DEV-004 test harness. Use in a sandbox; do not ship to production.
    // All dummy records use the prefixes CHMT1- / CHMT2- / CHMT3- / CHMT4- / CHMT-GA / CHMT-LBL.
    Permissions =
        tabledata "Sales Shipment Header" = rimd,
        tabledata "Sales Shipment Line" = rimd,
        tabledata "Posted Whse. Shipment Header" = r,
        tabledata "Posted Whse. Shipment Line" = r,
        tabledata "Item Ledger Entry" = r;

    trigger OnRun()
    begin
        // Used only to run the Michelin report in its own transaction (see RunDev003Tests).
        if RunMode = RunModeRenderReport() then
            RenderMichelinReport();
    end;

    var
        RunMode: Integer;
        ReportCopies: Integer;
        ReportOutputSize: Integer;
        ReportLabelCount: Integer;
        ReportLastNoBefore: Code[20];
        ReportLastNoAfter: Code[20];
        DevTestCounter: Integer;
        Dev001Tok: Label 'DEV-001', Locked = true;
        Dev002Tok: Label 'DEV-002', Locked = true;
        Dev003Tok: Label 'DEV-003', Locked = true;
        Dev004Tok: Label 'DEV-004', Locked = true;
        Dev001PrefixTok: Label 'CHMT1-', Locked = true;
        Dev002PrefixTok: Label 'CHMT2-', Locked = true;
        Dev003PrefixTok: Label 'CHMT3-', Locked = true;
        Dev004ItemNoTok: Label 'CHMT4-ITEM', Locked = true;
        Dev004LotPrefixTok: Label 'CHMT4-LOT', Locked = true;
        Dev004NoInfoLotTok: Label 'CHMT4-NOINFO', Locked = true;
        GoodsAppPrefixTok: Label 'CHMT-GA', Locked = true;
        TestLabelNosTok: Label 'CHMT-LBL', Locked = true;
        TestLabelStartNoTok: Label 'CHMTLBL000001', Locked = true;
        PassTok: Label 'PASS', Locked = true;
        FailTok: Label 'FAIL', Locked = true;
        WarnTok: Label 'WARN', Locked = true;
        InfoTok: Label 'INFO', Locked = true;
        CreateQst: Label 'This creates %1 dummy records with the prefix %2 in company %3. Continue?', Comment = '%1 = Deviation, %2 = Prefix, %3 = Company';
        DeleteQst: Label 'Delete all %1 dummy records (prefix %2)?', Comment = '%1 = Deviation, %2 = Prefix';
        ProductionErr: Label 'Test data can only be created in a sandbox environment.';
        NoTestDataErr: Label 'No %1 test data found. Run "1. Create Test Data" first.', Comment = '%1 = Deviation';
        ErrorAsExpectedTxt: Label 'Error raised as expected: %1', Comment = '%1 = Error text';
        NoErrorRaisedTxt: Label 'No error was raised, but one was expected.';
        AcceptedTxt: Label 'Value accepted.';

    // =====================================================================
    // DEV-001: Update shipment data on Posted Sales Shipment (page 1350)
    // =====================================================================

    procedure CreateDev001TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        i: Integer;
    begin
        if not ConfirmCreate(Dev001Tok, Dev001PrefixTok) then
            exit;

        DeleteDev001Records();
        CreateGoodsAppearances();
        for i := 1 to NoOfTestRecords() do begin
            SalesShptHeader.Init();
            SalesShptHeader."No." := TestDocNo(Dev001PrefixTok, i);
            SalesShptHeader."Sell-to Customer Name" := 'CHM TEST Customer DEV-001';
            SalesShptHeader."Bill-to Name" := 'CHM TEST Customer DEV-001';
            SalesShptHeader."Ship-to Name" := 'CHM TEST Customer DEV-001';
            SalesShptHeader."Order No." := TestDocNo(Dev001PrefixTok + 'SO', i);
            SalesShptHeader."Posting Date" := WorkDate();
            SalesShptHeader."Document Date" := WorkDate();
            SalesShptHeader."Shipment Date" := WorkDate();
            SalesShptHeader.Insert(false);
        end;

        ClearDevResults(TempResult, Dev001Tok);
        AddResult(TempResult, Dev001Tok, 'Create test data', InfoTok,
          StrSubstNo('%1 posted sales shipments %2 to %3 created with empty shipment fields, plus 5 Goods Appearance codes.',
            NoOfTestRecords(), TestDocNo(Dev001PrefixTok, 1), TestDocNo(Dev001PrefixTok, NoOfTestRecords())));
    end;

    procedure RunDev001Tests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        RecRef: RecordRef;
        i: Integer;
    begin
        ClearDevResults(TempResult, Dev001Tok);
        SalesShptHeader.SetFilter("No.", Dev001PrefixTok + '*');
        if SalesShptHeader.Count() < NoOfTestRecords() then
            Error(NoTestDataErr, Dev001Tok);

        // Reset the fields first so the update really has to change something.
        SalesShptHeader.ModifyAll("CHM Total Net Weight", 0);
        SalesShptHeader.ModifyAll("CHM Total Gross Weight", 0);
        SalesShptHeader.ModifyAll("CHM Total Parcel", 0);
        SalesShptHeader.ModifyAll("CHM Total Pallet", 0);
        SalesShptHeader.ModifyAll("CHM Total Volume", 0);
        SalesShptHeader.ModifyAll("CHM Goods Appearance", '');
        SalesShptHeader.ModifyAll("CHM Non-reusable Packaging", 0);
        Commit();

        // T01-T20: same save path as the OK button on page 1350 (codeunit 391 "Shipment Header - Edit").
        for i := 1 to NoOfTestRecords() do
            TestDev001UpdateRecord(TempResult, i);

        // Field validations available on page 1350.
        SalesShptHeader.Get(TestDocNo(Dev001PrefixTok, 1));
        RecRef.GetTable(SalesShptHeader);
        RunShipmentValidationTests(TempResult, Dev001Tok, RecRef);

        // Field definitions must match the Warehouse Shipment Header (same IDs = clean copy).
        CheckSameFieldDefinition(TempResult, Dev001Tok, Database::"Warehouse Shipment Header", Database::"Sales Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());

        AddResult(TempResult, Dev001Tok, 'Manual check', InfoTok,
          'Open a CHMT1 shipment > Update Document, change a field, click OK and reopen: the value must be kept. Use "3. Open Test Records".');
    end;

    local procedure TestDev001UpdateRecord(var TempResult: Record "Name/Value Buffer" temporary; i: Integer)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        TempExpected: Record "Warehouse Shipment Header" temporary;
        ExpectedRecRef: RecordRef;
        ActualRecRef: RecordRef;
        Description: Text;
        Mismatch: Text;
    begin
        Description := StrSubstNo('Update via page 1350 save logic - %1', TestDocNo(Dev001PrefixTok, i));
        GetExpectedRecord(i, TempExpected);
        ExpectedRecRef.GetTable(TempExpected);

        SalesShptHeader.Get(TestDocNo(Dev001PrefixTok, i));
        ActualRecRef.GetTable(SalesShptHeader);
        CopyShipmentFieldValues(ExpectedRecRef, ActualRecRef);
        ActualRecRef.SetTable(SalesShptHeader);

        ClearLastError();
        if not Codeunit.Run(Codeunit::"Shipment Header - Edit", SalesShptHeader) then begin
            AddResult(TempResult, Dev001Tok, Description, FailTok, GetLastErrorText());
            exit;
        end;

        SalesShptHeader.Get(TestDocNo(Dev001PrefixTok, i));
        ActualRecRef.GetTable(SalesShptHeader);
        Mismatch := CompareShipmentFields(ExpectedRecRef, ActualRecRef);
        AddCheck(TempResult, Dev001Tok, Description, Mismatch = '', 'All 7 fields saved on the posted shipment.', Mismatch);
    end;

    procedure OpenDev001TestRecords()
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader.SetFilter("No.", Dev001PrefixTok + '*');
        Page.Run(Page::"Posted Sales Shipments", SalesShptHeader);
    end;

    procedure DeleteDev001TestData(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        if not ConfirmDelete(Dev001Tok, Dev001PrefixTok) then
            exit;
        DeleteDev001Records();
        DeleteGoodsAppearancesIfUnused();
        ClearDevResults(TempResult, Dev001Tok);
        AddResult(TempResult, Dev001Tok, 'Delete test data', InfoTok, 'All CHMT1 records deleted.');
    end;

    local procedure DeleteDev001Records()
    var
        SalesShptHeader: Record "Sales Shipment Header";
    begin
        SalesShptHeader.SetFilter("No.", Dev001PrefixTok + '*');
        SalesShptHeader.DeleteAll(false);
    end;

    // =====================================================================
    // DEV-002: Shipment fields on Whse. Shipment -> Posted Whse. Shpt. -> Posted Sales Shpt.
    // =====================================================================

    procedure CreateDev002TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        TempExpected: Record "Warehouse Shipment Header" temporary;
        LocationCode: Code[10];
        i: Integer;
    begin
        if not ConfirmCreate(Dev002Tok, Dev002PrefixTok) then
            exit;

        DeleteDev002Records();
        CreateGoodsAppearances();
        LocationCode := GetTestWhseLocation();
        for i := 1 to NoOfTestRecords() do begin
            WhseShptHeader.Init();
            WhseShptHeader."No." := TestDocNo(Dev002PrefixTok, i);
            WhseShptHeader."Location Code" := LocationCode;
            WhseShptHeader."Posting Date" := WorkDate();
            WhseShptHeader."Shipment Date" := WorkDate();
            WhseShptHeader.Insert(false);

            GetExpectedRecord(i, TempExpected);
            ApplyWhseShipmentValues(WhseShptHeader, TempExpected);
            WhseShptHeader.Modify();
        end;

        ClearDevResults(TempResult, Dev002Tok);
        AddResult(TempResult, Dev002Tok, 'Create test data', InfoTok,
          StrSubstNo('%1 warehouse shipments %2 to %3 created and filled through Validate. Location: %4.',
            NoOfTestRecords(), TestDocNo(Dev002PrefixTok, 1), TestDocNo(Dev002PrefixTok, NoOfTestRecords()), LocationCode));
        if LocationCode = '' then
            AddResult(TempResult, Dev002Tok, 'Warehouse employee', WarnTok,
              'You are not a warehouse employee for any location, so the test shipments may not show on the Warehouse Shipment list.');
    end;

    procedure RunDev002Tests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        RecRef: RecordRef;
        i: Integer;
    begin
        ClearDevResults(TempResult, Dev002Tok);
        WhseShptHeader.SetFilter("No.", Dev002PrefixTok + '*');
        if WhseShptHeader.Count() < NoOfTestRecords() then
            Error(NoTestDataErr, Dev002Tok);

        // T01-T20: enter values on the Warehouse Shipment (with validation) and read them back.
        for i := 1 to NoOfTestRecords() do
            TestDev002Record(TempResult, i);

        // Validation tests on the editable Warehouse Shipment fields.
        WhseShptHeader.Get(TestDocNo(Dev002PrefixTok, 1));
        RecRef.GetTable(WhseShptHeader);
        RunShipmentValidationTests(TempResult, Dev002Tok, RecRef);
        RunNegativeValueTests(TempResult, WhseShptHeader);

        // The 3 tables must carry identical fields, otherwise the copy on posting breaks.
        CheckSameFieldDefinition(TempResult, Dev002Tok, Database::"Warehouse Shipment Header", Database::"Posted Whse. Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());
        CheckSameFieldDefinition(TempResult, Dev002Tok, Database::"Warehouse Shipment Header", Database::"Sales Shipment Header", FirstShipmentFieldNo(), LastShipmentFieldNo());

        // Flow check on real postings: Posted Whse. Shipment = Posted Sales Shipment.
        CheckRealPostedWhseShipments(TempResult);
    end;

    local procedure TestDev002Record(var TempResult: Record "Name/Value Buffer" temporary; i: Integer)
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        TempExpected: Record "Warehouse Shipment Header" temporary;
        ExpectedRecRef: RecordRef;
        ActualRecRef: RecordRef;
        Description: Text;
        Mismatch: Text;
    begin
        Description := StrSubstNo('Enter and save shipment fields - %1', TestDocNo(Dev002PrefixTok, i));
        GetExpectedRecord(i, TempExpected);
        ExpectedRecRef.GetTable(TempExpected);

        WhseShptHeader.Get(TestDocNo(Dev002PrefixTok, i));
        WhseShptHeader."CHM Total Net Weight" := 0;
        WhseShptHeader."CHM Total Gross Weight" := 0;
        ClearLastError();
        if not TryApplyWhseShipmentValues(WhseShptHeader, TempExpected) then begin
            AddResult(TempResult, Dev002Tok, Description, FailTok, GetLastErrorText());
            exit;
        end;
        WhseShptHeader.Modify();

        WhseShptHeader.Get(TestDocNo(Dev002PrefixTok, i));
        ActualRecRef.GetTable(WhseShptHeader);
        Mismatch := CompareShipmentFields(ExpectedRecRef, ActualRecRef);
        AddCheck(TempResult, Dev002Tok, Description, Mismatch = '', 'All 7 fields validated and saved.', Mismatch);
    end;

    local procedure RunNegativeValueTests(var TempResult: Record "Name/Value Buffer" temporary; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        RecRef: RecordRef;
        NegativeDecimal: Decimal;
        NegativeInteger: Integer;
    begin
        NegativeDecimal := -1;
        NegativeInteger := -1;

        RecRef.GetTable(WhseShptHeader);
        CheckValidate(TempResult, Dev002Tok, 'Negative Total Parcel is rejected', RecRef, WhseShptHeader.FieldNo("CHM Total Parcel"), NegativeInteger, true);
        RecRef.GetTable(WhseShptHeader);
        CheckValidate(TempResult, Dev002Tok, 'Negative Total Pallet is rejected', RecRef, WhseShptHeader.FieldNo("CHM Total Pallet"), NegativeInteger, true);
        RecRef.GetTable(WhseShptHeader);
        CheckValidate(TempResult, Dev002Tok, 'Negative Total Volume is rejected', RecRef, WhseShptHeader.FieldNo("CHM Total Volume"), NegativeDecimal, true);
        RecRef.GetTable(WhseShptHeader);
        CheckValidate(TempResult, Dev002Tok, 'Negative Non-reusable Packaging is rejected', RecRef, WhseShptHeader.FieldNo("CHM Non-reusable Packaging"), NegativeDecimal, true);
    end;

    local procedure CheckRealPostedWhseShipments(var TempResult: Record "Name/Value Buffer" temporary)
    var
        PostedWhseShptHeader: Record "Posted Whse. Shipment Header";
        PostedWhseShptLine: Record "Posted Whse. Shipment Line";
        SalesShptHeader: Record "Sales Shipment Header";
        PostedRecRef: RecordRef;
        SalesRecRef: RecordRef;
        Checked: Integer;
        Mismatch: Text;
    begin
        PostedWhseShptHeader.Ascending(false);
        if PostedWhseShptHeader.FindSet() then
            repeat
                PostedWhseShptLine.SetRange("No.", PostedWhseShptHeader."No.");
                PostedWhseShptLine.SetRange("Posted Source Document", PostedWhseShptLine."Posted Source Document"::"Posted Shipment");
                if PostedWhseShptLine.FindFirst() then
                    if SalesShptHeader.Get(PostedWhseShptLine."Posted Source No.") then begin
                        PostedRecRef.GetTable(PostedWhseShptHeader);
                        SalesRecRef.GetTable(SalesShptHeader);
                        if HasShipmentData(PostedRecRef) or HasShipmentData(SalesRecRef) then begin
                            Checked += 1;
                            Mismatch := CompareShipmentFields(PostedRecRef, SalesRecRef);
                            AddCheck(TempResult, Dev002Tok,
                              StrSubstNo('Real posting flow %1 -> %2', PostedWhseShptHeader."No.", SalesShptHeader."No."),
                              Mismatch = '', 'Posted Whse. Shipment and Posted Sales Shipment hold the same values.', Mismatch);
                        end;
                    end;
            until (PostedWhseShptHeader.Next() = 0) or (Checked >= NoOfTestRecords());

        if Checked = 0 then
            AddResult(TempResult, Dev002Tok, 'Real posting flow', InfoTok,
              'No posted warehouse shipment with shipment data found yet. Post one sales order through a warehouse shipment (fill the 7 fields first) and run the tests again.');
    end;

    procedure OpenDev002TestRecords()
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        WhseShptHeader.SetFilter("No.", Dev002PrefixTok + '*');
        Page.Run(Page::"Warehouse Shipment List", WhseShptHeader);
    end;

    procedure DeleteDev002TestData(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        if not ConfirmDelete(Dev002Tok, Dev002PrefixTok) then
            exit;
        DeleteDev002Records();
        DeleteGoodsAppearancesIfUnused();
        ClearDevResults(TempResult, Dev002Tok);
        AddResult(TempResult, Dev002Tok, 'Delete test data', InfoTok, 'All CHMT2 records deleted.');
    end;

    local procedure DeleteDev002Records()
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        WhseShptHeader.SetFilter("No.", Dev002PrefixTok + '*');
        WhseShptHeader.DeleteAll(false);
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

    [TryFunction]
    local procedure TryApplyWhseShipmentValues(var WhseShptHeader: Record "Warehouse Shipment Header"; TempExpected: Record "Warehouse Shipment Header" temporary)
    begin
        ApplyWhseShipmentValues(WhseShptHeader, TempExpected);
    end;

    // =====================================================================
    // DEV-003: Michelin printed labels page + barcode report
    // =====================================================================

    procedure CreateDev003TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        CustomerNo: Code[20];
        i: Integer;
    begin
        if not ConfirmCreate(Dev003Tok, Dev003PrefixTok) then
            exit;

        DeleteDev003Records();
        CreateTestCustomer(Dev003CustomerNo(1), 'CHM TEST Michelin Italia', true, '020561');
        CreateTestCustomer(Dev003CustomerNo(2), 'CHM TEST Michelin Australia', true, '020562');
        CreateTestCustomer(Dev003CustomerNo(3), 'CHM TEST Non-Michelin Customer', false, '');
        CreateTestLabelNoSeries();

        for i := 1 to NoOfTestRecords() do begin
            CustomerNo := GetDev003CustomerForShipment(i);

            SalesShptHeader.Init();
            SalesShptHeader."No." := TestDocNo(Dev003PrefixTok, i);
            SalesShptHeader."Sell-to Customer No." := CustomerNo;
            SalesShptHeader."Bill-to Customer No." := CustomerNo;
            SalesShptHeader."Sell-to Customer Name" := 'CHM TEST Customer DEV-003';
            SalesShptHeader."Order No." := TestDocNo(Dev003PrefixTok + 'SO', i);
            SalesShptHeader."External Document No." := TestDocNo('PO-CHMT-', i);
            SalesShptHeader."Ship-to Name" := 'San Vittore Olona Plant';
            SalesShptHeader."Ship-to Address" := 'Via Puccini, 18';
            SalesShptHeader."Ship-to City" := 'San Vittore Olona';
            SalesShptHeader."Ship-to Post Code" := '20028';
            SalesShptHeader."Ship-to County" := 'MI';
            SalesShptHeader."Ship-to Country/Region Code" := 'IT';
            SalesShptHeader."Posting Date" := WorkDate();
            SalesShptHeader."Document Date" := WorkDate();
            SalesShptHeader.Insert(false);

            SalesShptLine.Init();
            SalesShptLine."Document No." := SalesShptHeader."No.";
            SalesShptLine."Line No." := 10000;
            SalesShptLine.Type := SalesShptLine.Type::Item;
            SalesShptLine."No." := TestDocNo(Dev003PrefixTok + 'ITM', ((i - 1) mod 5) + 1);
            SalesShptLine.Description := 'EM GREASE LC2 HMC 180 KG DRUM (TEST)';
            SalesShptLine.Quantity := 10 * i;
            SalesShptLine."Quantity (Base)" := 10 * i;
            SalesShptLine."Qty. per Unit of Measure" := 1;
            SalesShptLine."Order No." := SalesShptHeader."Order No.";
            SalesShptLine."Order Line No." := 10000;
            SalesShptLine."Sell-to Customer No." := CustomerNo;
            SalesShptLine."Posting Date" := WorkDate();
            SalesShptLine.Insert(false);
        end;

        ClearDevResults(TempResult, Dev003Tok);
        AddResult(TempResult, Dev003Tok, 'Create test data', InfoTok,
          StrSubstNo('3 customers, %1 posted shipments (%2 Michelin, %3 non-Michelin) with 1 item line each, and test label No. Series %4 created.',
            NoOfTestRecords(), ExpectedMichelinShipments(), NoOfTestRecords() - ExpectedMichelinShipments(), TestLabelNosTok));
    end;

    procedure RunDev003Tests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        Customer: Record Customer;
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ReportRunner: Codeunit "CHM Deviation Test Mgt.";
        ExpectedLastNo: Code[20];
        ExpectedFlag: Boolean;
        k: Integer;
        i: Integer;
    begin
        ClearDevResults(TempResult, Dev003Tok);
        SalesShptHeader.SetFilter("No.", Dev003PrefixTok + '*');
        if SalesShptHeader.Count() < NoOfTestRecords() then
            Error(NoTestDataErr, Dev003Tok);

        // Customer setup fields.
        for i := 1 to 3 do begin
            Customer.Get(Dev003CustomerNo(i));
            AddCheck(TempResult, Dev003Tok, StrSubstNo('Customer %1 Michelin fields', Customer."No."),
              (Customer."CHM Michelin Customer" = (i < 3)) and ((Customer."CHM Michelin Supplier Code" <> '') = (i < 3)),
              StrSubstNo('Michelin Customer = %1, Supplier Code = %2', Customer."CHM Michelin Customer", Customer."CHM Michelin Supplier Code"),
              StrSubstNo('Unexpected values: Michelin Customer = %1, Supplier Code = %2', Customer."CHM Michelin Customer", Customer."CHM Michelin Supplier Code"));
        end;

        // T04-T23: FlowField "Michelin Customer" on every posted shipment.
        for i := 1 to NoOfTestRecords() do begin
            SalesShptHeader.Get(TestDocNo(Dev003PrefixTok, i));
            SalesShptHeader.CalcFields("CHM Michelin Customer");
            ExpectedFlag := GetDev003CustomerForShipment(i) <> Dev003CustomerNo(3);
            AddCheck(TempResult, Dev003Tok, StrSubstNo('Michelin Customer FlowField - %1', SalesShptHeader."No."),
              SalesShptHeader."CHM Michelin Customer" = ExpectedFlag,
              StrSubstNo('Shows %1 for customer %2.', SalesShptHeader."CHM Michelin Customer", SalesShptHeader."Sell-to Customer No."),
              StrSubstNo('Expected %1, found %2.', ExpectedFlag, SalesShptHeader."CHM Michelin Customer"));
        end;

        // Filter used by "Load Shipment Lines" on the Michelin labels page.
        SalesShptHeader.Reset();
        SalesShptHeader.SetFilter("No.", Dev003PrefixTok + '*');
        SalesShptHeader.SetRange("CHM Michelin Customer", true);
        AddCheck(TempResult, Dev003Tok, 'Load Shipment Lines shows only Michelin shipments',
          SalesShptHeader.Count() = ExpectedMichelinShipments(),
          StrSubstNo('%1 of %2 shipments offered, as expected.', SalesShptHeader.Count(), NoOfTestRecords()),
          StrSubstNo('Expected %1 shipments, found %2.', ExpectedMichelinShipments(), SalesShptHeader.Count()));

        SalesShptLine.SetFilter("Document No.", Dev003PrefixTok + '*');
        SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
        AddCheck(TempResult, Dev003Tok, 'Item lines available to load',
          SalesShptLine.Count() = NoOfTestRecords(),
          StrSubstNo('%1 item lines found.', SalesShptLine.Count()),
          StrSubstNo('Expected %1 item lines, found %2.', NoOfTestRecords(), SalesShptLine.Count()));

        // Real setup: without this, Print labels on the page fails.
        SalesSetup.Get();
        if SalesSetup."CHM Michelin Label Nos." <> '' then
            AddResult(TempResult, Dev003Tok, 'Sales & Receivables Setup - Michelin Label Nos.', PassTok, StrSubstNo('Set to %1.', SalesSetup."CHM Michelin Label Nos."))
        else
            AddResult(TempResult, Dev003Tok, 'Sales & Receivables Setup - Michelin Label Nos.', WarnTok, 'Not set. Print labels on the page will fail until a No. Series is entered.');

        // Report: rendered in its own transaction, using the test label series so no real label numbers are used.
        Commit();
        ReportRunner.SetRunMode(RunModeRenderReport(), 2);
        ClearLastError();
        if not ReportRunner.Run() then begin
            AddResult(TempResult, Dev003Tok, 'Barcode report renders to PDF', FailTok, GetLastErrorText());
            exit;
        end;
        ReportRunner.GetReportResults(ReportOutputSize, ReportLabelCount, ReportCopies, ReportLastNoBefore, ReportLastNoAfter);

        AddCheck(TempResult, Dev003Tok, 'Barcode report renders to PDF',
          (ReportOutputSize > 0) and (ReportLabelCount = ExpectedMichelinShipments()),
          StrSubstNo('%1 label lines x %2 copies printed, PDF size %3 bytes.', ReportLabelCount, ReportCopies, ReportOutputSize),
          StrSubstNo('PDF size %1 bytes, %2 label lines (expected %3).', ReportOutputSize, ReportLabelCount, ExpectedMichelinShipments()));

        ExpectedLastNo := ReportLastNoBefore;
        for k := 1 to ReportLabelCount * ReportCopies do
            if ExpectedLastNo = '' then
                ExpectedLastNo := TestLabelStartNoTok
            else
                ExpectedLastNo := CopyStr(IncStr(ExpectedLastNo), 1, MaxStrLen(ExpectedLastNo));
        AddCheck(TempResult, Dev003Tok, 'One label serial no. per printed label (No. of copies)',
          ReportLastNoAfter = ExpectedLastNo,
          StrSubstNo('%1 serial numbers used: last no. moved from %2 to %3.', ReportLabelCount * ReportCopies, ReportLastNoBefore, ReportLastNoAfter),
          StrSubstNo('Expected last no. %1, found %2.', ExpectedLastNo, ReportLastNoAfter));

        Customer.Reset();
        Customer.SetRange("CHM Michelin Customer", true);
        Customer.SetFilter("No.", '<>%1&<>%2', Dev003CustomerNo(1), Dev003CustomerNo(2));
        AddResult(TempResult, Dev003Tok, 'Real Michelin customers', InfoTok,
          StrSubstNo('%1 real customer(s) are flagged as Michelin Customer.', Customer.Count()));
        AddResult(TempResult, Dev003Tok, 'Manual check', InfoTok,
          'Use "3. Open Test Records" > Load Shipment Lines, pick a CHMT3 shipment, set No. of copies and Print labels.');
    end;

    procedure OpenDev003TestRecords()
    begin
        Page.Run(Page::"CHM Michelin Labels");
    end;

    procedure DeleteDev003TestData(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        if not ConfirmDelete(Dev003Tok, Dev003PrefixTok) then
            exit;
        DeleteDev003Records();
        ClearDevResults(TempResult, Dev003Tok);
        AddResult(TempResult, Dev003Tok, 'Delete test data', InfoTok, 'All CHMT3 records and the CHMT-LBL No. Series deleted.');
    end;

    local procedure DeleteDev003Records()
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        Customer: Record Customer;
        NoSeries: Record "No. Series";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesShptLine.SetFilter("Document No.", Dev003PrefixTok + '*');
        SalesShptLine.DeleteAll(false);
        SalesShptHeader.SetFilter("No.", Dev003PrefixTok + '*');
        SalesShptHeader.DeleteAll(false);
        Customer.SetFilter("No.", Dev003PrefixTok + 'C*');
        Customer.DeleteAll(false);

        SalesSetup.Get();
        if SalesSetup."CHM Michelin Label Nos." <> TestLabelNosTok then
            if NoSeries.Get(TestLabelNosTok) then
                NoSeries.Delete(true);
    end;

    procedure SetRunMode(NewRunMode: Integer; NewCopies: Integer)
    begin
        RunMode := NewRunMode;
        ReportCopies := NewCopies;
    end;

    procedure GetReportResults(var OutputSize: Integer; var LabelCount: Integer; var Copies: Integer; var LastNoBefore: Code[20]; var LastNoAfter: Code[20])
    begin
        OutputSize := ReportOutputSize;
        LabelCount := ReportLabelCount;
        Copies := ReportCopies;
        LastNoBefore := ReportLastNoBefore;
        LastNoAfter := ReportLastNoAfter;
    end;

    local procedure RenderMichelinReport()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        TempLabels: Record "CHM Michelin Labels" temporary;
        MichelinLabels: Report "CHM Michelin Labels";
        TempBlob: Codeunit "Temp Blob";
        NoSeries: Codeunit "No. Series";
        OutStr: OutStream;
        OriginalLabelNos: Code[20];
    begin
        BuildMichelinLabelBuffer(TempLabels);
        ReportLabelCount := TempLabels.Count();

        // Point the setup to the test series for this run only; restored below (or rolled back on error).
        SalesSetup.Get();
        OriginalLabelNos := SalesSetup."CHM Michelin Label Nos.";
        SalesSetup."CHM Michelin Label Nos." := TestLabelNosTok;
        SalesSetup.Modify();

        ReportLastNoBefore := NoSeries.GetLastNoUsed(TestLabelNosTok);
        MichelinLabels.SetData(TempLabels, ReportCopies);
        TempBlob.CreateOutStream(OutStr);
        MichelinLabels.SaveAs('', ReportFormat::Pdf, OutStr);
        ReportOutputSize := TempBlob.Length();
        ReportLastNoAfter := NoSeries.GetLastNoUsed(TestLabelNosTok);

        SalesSetup.Get();
        SalesSetup."CHM Michelin Label Nos." := OriginalLabelNos;
        SalesSetup.Modify();
    end;

    local procedure BuildMichelinLabelBuffer(var TempLabels: Record "CHM Michelin Labels" temporary)
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        NextIndex: BigInteger;
    begin
        SalesShptHeader.SetFilter("No.", Dev003PrefixTok + '*');
        SalesShptHeader.SetRange("CHM Michelin Customer", true);
        if SalesShptHeader.FindSet() then
            repeat
                SalesShptLine.SetRange("Document No.", SalesShptHeader."No.");
                SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
                if SalesShptLine.FindSet() then
                    repeat
                        NextIndex += 1;
                        TempLabels.Init();
                        TempLabels.Index := NextIndex;
                        TempLabels."Sales Order No." := SalesShptHeader."Order No.";
                        TempLabels."Sales Shpt. Code" := SalesShptHeader."No.";
                        TempLabels."Item No." := SalesShptLine."No.";
                        TempLabels.Description := SalesShptLine.Description;
                        TempLabels."Lot No." := CopyStr(StrSubstNo('LOT%1', NextIndex), 1, MaxStrLen(TempLabels."Lot No."));
                        TempLabels."Production Date" := CopyStr(Format(WorkDate(), 0, '<Day,2>.<Month,2>.<Year,2>'), 1, MaxStrLen(TempLabels."Production Date"));
                        TempLabels.Quantity := Round(SalesShptLine.Quantity, 1);
                        TempLabels."Michelin Purch. Order" := SalesShptHeader."External Document No.";
                        TempLabels."Ship-from Name" := 'CHEMATEK S.P.A. (TEST)';
                        TempLabels."Ship-to Name" := SalesShptHeader."Ship-to Name";
                        TempLabels."Ship-to Address" := SalesShptHeader."Ship-to Address";
                        TempLabels."Ship-to City" := SalesShptHeader."Ship-to City";
                        TempLabels."Ship-to Post Code" := SalesShptHeader."Ship-to Post Code";
                        TempLabels."Ship-to County" := SalesShptHeader."Ship-to County";
                        TempLabels."Ship-to Country" := SalesShptHeader."Ship-to Country/Region Code";
                        TempLabels.Insert();
                    until SalesShptLine.Next() = 0;
            until SalesShptHeader.Next() = 0;
    end;

    local procedure CreateTestCustomer(CustomerNo: Code[20]; CustomerName: Text[100]; IsMichelin: Boolean; SupplierCode: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.Init();
        Customer."No." := CustomerNo;
        Customer.Name := CustomerName;
        Customer.Address := 'Via Puccini, 18';
        Customer.City := 'San Vittore Olona';
        Customer."Post Code" := '20028';
        Customer."CHM Michelin Customer" := IsMichelin;
        Customer."CHM Michelin Supplier Code" := SupplierCode;
        Customer.Insert(false); // no contact / template logic for dummy data
    end;

    local procedure CreateTestLabelNoSeries()
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(TestLabelNosTok) then
            exit;
        NoSeries.Init();
        NoSeries.Code := TestLabelNosTok;
        NoSeries.Description := 'CHM TEST - Michelin label serials';
        NoSeries."Default Nos." := true;
        NoSeries.Insert(true);

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := TestLabelNosTok;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine.Validate("Starting No.", TestLabelStartNoTok);
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert(true);
    end;

    local procedure Dev003CustomerNo(Index: Integer): Code[20]
    begin
        exit(TestDocNo(Dev003PrefixTok + 'C', Index));
    end;

    local procedure GetDev003CustomerForShipment(i: Integer): Code[20]
    begin
        if i > ExpectedMichelinShipments() then
            exit(Dev003CustomerNo(3));
        if i mod 2 = 1 then
            exit(Dev003CustomerNo(1));
        exit(Dev003CustomerNo(2));
    end;

    local procedure ExpectedMichelinShipments(): Integer
    begin
        exit(14); // shipments 1-14 Michelin, 15-20 non-Michelin
    end;

    // =====================================================================
    // DEV-004: Production Date on Lot No. Information / Item Tracking Lines
    // =====================================================================

    procedure CreateDev004TestData(var TempResult: Record "Name/Value Buffer" temporary)
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
        i: Integer;
    begin
        if not ConfirmCreate(Dev004Tok, 'CHMT4-') then
            exit;

        DeleteDev004Records();
        Item.Init();
        Item."No." := Dev004ItemNoTok;
        Item.Description := 'CHM TEST item - DEV-004 production date';
        Item.Insert(false);

        for i := 1 to NoOfTestRecords() do begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := Dev004ItemNoTok;
            LotNoInformation."Variant Code" := '';
            LotNoInformation."Lot No." := Dev004LotNo(i);
            LotNoInformation.Description := 'CHM TEST lot';
            LotNoInformation."CHM Production Date" := Dev004LotDate(i);
            LotNoInformation.Insert(false);
        end;

        ClearDevResults(TempResult, Dev004Tok);
        AddResult(TempResult, Dev004Tok, 'Create test data', InfoTok,
          StrSubstNo('Item %1 and %2 lots (%3 to %4) with production dates created. Lot %5 has no Lot No. Information on purpose.',
            Dev004ItemNoTok, NoOfTestRecords(), Dev004LotNo(1), Dev004LotNo(NoOfTestRecords()), Dev004NoInfoLotTok));
    end;

    procedure RunDev004Tests(var TempResult: Record "Name/Value Buffer" temporary)
    var
        LotNoInformation: Record "Lot No. Information";
        TempTrackingSpec: Record "Tracking Specification" temporary;
        TempItemJnlLine: Record "Item Journal Line" temporary;
        LotProductionDateMgt: Codeunit "CHM Lot Production Date Mgt.";
        ActualDate: Date;
        ManualDate: Date;
        Succeeded: Boolean;
        i: Integer;
    begin
        ClearDevResults(TempResult, Dev004Tok);
        LotNoInformation.SetRange("Item No.", Dev004ItemNoTok);
        if LotNoInformation.Count() < NoOfTestRecords() then
            Error(NoTestDataErr, Dev004Tok);

        // T01-T20: Lot No. Information Card value is stored and returned.
        for i := 1 to NoOfTestRecords() do begin
            ActualDate := LotProductionDateMgt.GetLotProductionDate(Dev004ItemNoTok, '', Dev004LotNo(i));
            AddCheck(TempResult, Dev004Tok, StrSubstNo('Lot No. Information production date - %1', Dev004LotNo(i)),
              ActualDate = Dev004LotDate(i), StrSubstNo('Production Date %1.', ActualDate),
              StrSubstNo('Expected %1, found %2.', Dev004LotDate(i), ActualDate));
        end;

        // T21-T40: Item Tracking Lines - choosing an existing lot fills its production date.
        for i := 1 to NoOfTestRecords() do begin
            InitTrackingSpec(TempTrackingSpec, '', 0D);
            ClearLastError();
            if not TryValidateTrackingLotNo(TempTrackingSpec, Dev004LotNo(i)) then
                AddResult(TempResult, Dev004Tok, StrSubstNo('Item Tracking Lines default date - %1', Dev004LotNo(i)), FailTok, GetLastErrorText())
            else
                AddCheck(TempResult, Dev004Tok, StrSubstNo('Item Tracking Lines default date - %1', Dev004LotNo(i)),
                  TempTrackingSpec."CHM Production Date" = Dev004LotDate(i),
                  StrSubstNo('Defaulted to %1.', TempTrackingSpec."CHM Production Date"),
                  StrSubstNo('Expected %1, found %2.', Dev004LotDate(i), TempTrackingSpec."CHM Production Date"));
        end;

        // Switching from an existing lot to a lot without information clears the date.
        InitTrackingSpec(TempTrackingSpec, Dev004LotNo(1), Dev004LotDate(1));
        if TryValidateTrackingLotNo(TempTrackingSpec, Dev004NoInfoLotTok) then
            AddCheck(TempResult, Dev004Tok, 'Switch to a lot without info clears the date',
              TempTrackingSpec."CHM Production Date" = 0D, 'Date cleared.',
              StrSubstNo('Expected blank, found %1.', TempTrackingSpec."CHM Production Date"))
        else
            AddResult(TempResult, Dev004Tok, 'Switch to a lot without info clears the date', FailTok, GetLastErrorText());

        // A brand-new lot keeps the date the user typed.
        ManualDate := WorkDate() - 5;
        InitTrackingSpec(TempTrackingSpec, '', ManualDate);
        if TryValidateTrackingLotNo(TempTrackingSpec, Dev004NoInfoLotTok) then
            AddCheck(TempResult, Dev004Tok, 'New lot keeps the entered date',
              TempTrackingSpec."CHM Production Date" = ManualDate, StrSubstNo('Kept %1.', ManualDate),
              StrSubstNo('Expected %1, found %2.', ManualDate, TempTrackingSpec."CHM Production Date"))
        else
            AddResult(TempResult, Dev004Tok, 'New lot keeps the entered date', FailTok, GetLastErrorText());

        // Production Date validation on Item Tracking Lines.
        InitTrackingSpec(TempTrackingSpec, Dev004LotNo(1), Dev004LotDate(1));
        ClearLastError();
        Succeeded := TryValidateTrackingProdDate(TempTrackingSpec, Dev004LotDate(1) + 1);
        AddCheck(TempResult, Dev004Tok, 'Different date on an existing lot is rejected',
          not Succeeded, StrSubstNo(ErrorAsExpectedTxt, GetLastErrorText()), NoErrorRaisedTxt);

        InitTrackingSpec(TempTrackingSpec, Dev004LotNo(1), 0D);
        ClearLastError();
        Succeeded := TryValidateTrackingProdDate(TempTrackingSpec, Dev004LotDate(1));
        AddCheck(TempResult, Dev004Tok, 'Same date on an existing lot is accepted', Succeeded, AcceptedTxt, GetLastErrorText());

        InitTrackingSpec(TempTrackingSpec, Dev004NoInfoLotTok, 0D);
        ClearLastError();
        Succeeded := TryValidateTrackingProdDate(TempTrackingSpec, ManualDate);
        AddCheck(TempResult, Dev004Tok, 'Any date on a new lot is accepted', Succeeded, AcceptedTxt, GetLastErrorText());

        ActualDate := LotProductionDateMgt.GetLotProductionDate(Dev004ItemNoTok, '', '');
        AddCheck(TempResult, Dev004Tok, 'Blank lot returns no production date', ActualDate = 0D, 'Blank.', StrSubstNo('Found %1.', ActualDate));

        // T47-T66: posting step Tracking Specification -> Item Journal Line.
        for i := 1 to NoOfTestRecords() do begin
            InitTrackingSpec(TempTrackingSpec, Dev004LotNo(i), Dev004LotDate(i));
            TempItemJnlLine.Init();
            TempItemJnlLine.CopyTrackingFromSpec(TempTrackingSpec);
            AddCheck(TempResult, Dev004Tok, StrSubstNo('Posting copies date to Item Journal Line - %1', Dev004LotNo(i)),
              (TempItemJnlLine."CHM Production Date" = Dev004LotDate(i)) and (TempItemJnlLine."Lot No." = Dev004LotNo(i)),
              StrSubstNo('Item Journal Line got %1.', TempItemJnlLine."CHM Production Date"),
              StrSubstNo('Expected %1, found %2.', Dev004LotDate(i), TempItemJnlLine."CHM Production Date"));
        end;

        // Field 66600 must be identical on Tracking Specification and Reservation Entry (TransferFields).
        CheckSameFieldDefinition(TempResult, Dev004Tok, Database::"Tracking Specification", Database::"Reservation Entry", 66600, 66600);
        CheckSameFieldDefinition(TempResult, Dev004Tok, Database::"Tracking Specification", Database::"Item Journal Line", 66600, 66600);
        CheckSameFieldDefinition(TempResult, Dev004Tok, Database::"Tracking Specification", Database::"Item Ledger Entry", 66600, 66600);
        CheckSameFieldDefinition(TempResult, Dev004Tok, Database::"Tracking Specification", Database::"Lot No. Information", 66600, 66600);

        // Flow check on real postings: Item Ledger Entry -> Lot No. Information.
        CheckRealLotPostings(TempResult);
    end;

    local procedure CheckRealLotPostings(var TempResult: Record "Name/Value Buffer" temporary)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        Checked: Integer;
        Description: Text;
    begin
        ItemLedgerEntry.SetFilter("Lot No.", '<>%1', '');
        ItemLedgerEntry.SetFilter("CHM Production Date", '<>%1', 0D);
        ItemLedgerEntry.Ascending(false);
        if ItemLedgerEntry.FindSet() then
            repeat
                Checked += 1;
                Description := StrSubstNo('Real entry %1 (%2 lot %3) -> Lot No. Information', ItemLedgerEntry."Entry No.", ItemLedgerEntry."Item No.", ItemLedgerEntry."Lot No.");
                if not LotNoInformation.Get(ItemLedgerEntry."Item No.", ItemLedgerEntry."Variant Code", ItemLedgerEntry."Lot No.") then
                    AddResult(TempResult, Dev004Tok, Description, FailTok, 'Lot No. Information record was not created on posting.')
                else
                    if LotNoInformation."CHM Production Date" = ItemLedgerEntry."CHM Production Date" then
                        AddResult(TempResult, Dev004Tok, Description, PassTok, StrSubstNo('Both show %1.', ItemLedgerEntry."CHM Production Date"))
                    else
                        AddResult(TempResult, Dev004Tok, Description, WarnTok,
                          StrSubstNo('Entry has %1, lot card has %2 (the card may have been edited afterwards).', ItemLedgerEntry."CHM Production Date", LotNoInformation."CHM Production Date"));
            until (ItemLedgerEntry.Next() = 0) or (Checked >= NoOfTestRecords());

        if Checked = 0 then
            AddResult(TempResult, Dev004Tok, 'Real posting flow', InfoTok,
              'No posted item ledger entry with a production date found yet. Post a purchase receipt or positive adjustment with a lot and a Production Date on Item Tracking Lines, then run the tests again.');
    end;

    procedure OpenDev004TestRecords()
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        LotNoInformation.SetRange("Item No.", Dev004ItemNoTok);
        Page.Run(Page::"Lot No. Information List", LotNoInformation);
    end;

    procedure DeleteDev004TestData(var TempResult: Record "Name/Value Buffer" temporary)
    begin
        if not ConfirmDelete(Dev004Tok, 'CHMT4-') then
            exit;
        DeleteDev004Records();
        ClearDevResults(TempResult, Dev004Tok);
        AddResult(TempResult, Dev004Tok, 'Delete test data', InfoTok, 'Test item and its lots deleted.');
    end;

    local procedure DeleteDev004Records()
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        LotNoInformation.SetRange("Item No.", Dev004ItemNoTok);
        LotNoInformation.DeleteAll(false);
        if Item.Get(Dev004ItemNoTok) then
            Item.Delete(false);
    end;

    local procedure InitTrackingSpec(var TempTrackingSpec: Record "Tracking Specification" temporary; LotNo: Code[50]; ProductionDate: Date)
    begin
        TempTrackingSpec.Init();
        TempTrackingSpec."Entry No." := 1;
        TempTrackingSpec."Item No." := Dev004ItemNoTok;
        TempTrackingSpec."Variant Code" := '';
        TempTrackingSpec."Lot No." := LotNo;
        TempTrackingSpec."CHM Production Date" := ProductionDate;
    end;

    [TryFunction]
    local procedure TryValidateTrackingLotNo(var TempTrackingSpec: Record "Tracking Specification" temporary; LotNo: Code[50])
    begin
        TempTrackingSpec.Validate("Lot No.", LotNo);
    end;

    [TryFunction]
    local procedure TryValidateTrackingProdDate(var TempTrackingSpec: Record "Tracking Specification" temporary; NewDate: Date)
    begin
        TempTrackingSpec.Validate("CHM Production Date", NewDate);
    end;

    local procedure Dev004LotNo(i: Integer): Code[50]
    begin
        exit(CopyStr(Dev004LotPrefixTok + Format(i, 0, '<Integer,2><Filler Character,0>'), 1, 50));
    end;

    local procedure Dev004LotDate(i: Integer): Date
    begin
        exit(WorkDate() - (40 - i));
    end;

    // =====================================================================
    // Shared helpers
    // =====================================================================

    local procedure RunShipmentValidationTests(var TempResult: Record "Name/Value Buffer" temporary; DevCode: Text; var RecRef: RecordRef)
    var
        Weight: Decimal;
        InvalidCode: Code[10];
        ValidCode: Code[10];
    begin
        // RecRef is an in-memory copy of a test record; nothing is written to the database.

        // Gross lower than net -> error (CheckWeights).
        SetNetGross(RecRef, 100, 0);
        Weight := 50;
        CheckValidate(TempResult, DevCode, 'Gross Weight lower than Net Weight is rejected', RecRef, 66601, Weight, true);

        // Gross equal to net -> accepted.
        SetNetGross(RecRef, 100, 0);
        Weight := 100;
        CheckValidate(TempResult, DevCode, 'Gross Weight equal to Net Weight is accepted', RecRef, 66601, Weight, false);

        // Net entered while gross is still 0 -> accepted.
        SetNetGross(RecRef, 0, 0);
        Weight := 250;
        CheckValidate(TempResult, DevCode, 'Net Weight with Gross Weight still 0 is accepted', RecRef, 66600, Weight, false);

        // Negative weight -> MinValue error.
        SetNetGross(RecRef, 0, 0);
        Weight := -1;
        CheckValidate(TempResult, DevCode, 'Negative Net Weight is rejected', RecRef, 66600, Weight, true);

        // Goods Appearance must exist in CHM Goods Appearance.
        InvalidCode := 'XX-NOTEXST';
        CheckValidate(TempResult, DevCode, 'Unknown Goods Appearance code is rejected', RecRef, 66605, InvalidCode, true);

        ValidCode := GoodsAppearanceCode(1);
        CheckValidate(TempResult, DevCode, 'Existing Goods Appearance code is accepted', RecRef, 66605, ValidCode, false);
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

    local procedure CheckValidate(var TempResult: Record "Name/Value Buffer" temporary; DevCode: Text; Description: Text; var RecRef: RecordRef; FieldNo: Integer; NewValue: Variant; ExpectError: Boolean)
    var
        Succeeded: Boolean;
    begin
        ClearLastError();
        Succeeded := TryValidateField(RecRef, FieldNo, NewValue);
        if ExpectError then
            AddCheck(TempResult, DevCode, Description, not Succeeded, StrSubstNo(ErrorAsExpectedTxt, GetLastErrorText()), NoErrorRaisedTxt)
        else
            AddCheck(TempResult, DevCode, Description, Succeeded, AcceptedTxt, GetLastErrorText());
    end;

    [TryFunction]
    local procedure TryValidateField(var RecRef: RecordRef; FieldNo: Integer; NewValue: Variant)
    var
        FldRef: FieldRef;
    begin
        FldRef := RecRef.Field(FieldNo);
        FldRef.Validate(NewValue);
    end;

    local procedure GetExpectedRecord(i: Integer; var TempExpected: Record "Warehouse Shipment Header" temporary)
    begin
        // Deterministic values per record no. (gross always >= net).
        TempExpected.Init();
        TempExpected."CHM Total Net Weight" := 100 + i * 12.5;
        TempExpected."CHM Total Gross Weight" := TempExpected."CHM Total Net Weight" + 10 + i;
        TempExpected."CHM Total Parcel" := i;
        TempExpected."CHM Total Pallet" := (i + 1) div 2;
        TempExpected."CHM Total Volume" := 1.5 * i;
        TempExpected."CHM Goods Appearance" := GoodsAppearanceCode(((i - 1) mod 5) + 1);
        TempExpected."CHM Non-reusable Packaging" := 0.25 * i;
    end;

    local procedure CopyShipmentFieldValues(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromFldRef: FieldRef;
        ToFldRef: FieldRef;
        FieldNo: Integer;
    begin
        for FieldNo := FirstShipmentFieldNo() to LastShipmentFieldNo() do begin
            FromFldRef := FromRecRef.Field(FieldNo);
            ToFldRef := ToRecRef.Field(FieldNo);
            ToFldRef.Value := FromFldRef.Value;
        end;
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

    local procedure CheckSameFieldDefinition(var TempResult: Record "Name/Value Buffer" temporary; DevCode: Text; RefTableNo: Integer; TableNo: Integer; FromFieldNo: Integer; ToFieldNo: Integer)
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

        AddCheck(TempResult, DevCode, StrSubstNo('Field %1..%2 definition on %3 matches %4', FromFieldNo, ToFieldNo, RecRef.Caption, RefRecRef.Caption),
          Mismatch = '', 'Same field IDs, names, types and lengths.', Mismatch);
        RecRef.Close();
        RefRecRef.Close();
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

    local procedure DeleteGoodsAppearancesIfUnused()
    var
        GoodsAppearance: Record "CHM Goods Appearance";
        SalesShptHeader: Record "Sales Shipment Header";
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        SalesShptHeader.SetFilter("No.", Dev001PrefixTok + '*');
        WhseShptHeader.SetFilter("No.", Dev002PrefixTok + '*');
        if SalesShptHeader.IsEmpty() and WhseShptHeader.IsEmpty() then begin
            GoodsAppearance.SetFilter(Code, GoodsAppPrefixTok + '*');
            GoodsAppearance.DeleteAll();
        end;
    end;

    local procedure GoodsAppearanceCode(Index: Integer): Code[10]
    begin
        exit(CopyStr(GoodsAppPrefixTok + Format(Index, 0, '<Integer,2><Filler Character,0>'), 1, 10));
    end;

    local procedure GetTestWhseLocation(): Code[10]
    var
        WarehouseEmployee: Record "Warehouse Employee";
    begin
        WarehouseEmployee.SetRange("User ID", UserId());
        WarehouseEmployee.SetRange(Default, true);
        if WarehouseEmployee.FindFirst() then
            exit(WarehouseEmployee."Location Code");
        WarehouseEmployee.SetRange(Default);
        if WarehouseEmployee.FindFirst() then
            exit(WarehouseEmployee."Location Code");
        exit('');
    end;

    local procedure ConfirmCreate(DevCode: Text; Prefix: Text): Boolean
    var
        EnvironmentInformation: Codeunit "Environment Information";
    begin
        if EnvironmentInformation.IsSaaS() and EnvironmentInformation.IsProduction() then
            Error(ProductionErr);
        if not GuiAllowed() then
            exit(true);
        exit(Confirm(CreateQst, true, DevCode, Prefix, CompanyName()));
    end;

    local procedure ConfirmDelete(DevCode: Text; Prefix: Text): Boolean
    begin
        if not GuiAllowed() then
            exit(true);
        exit(Confirm(DeleteQst, true, DevCode, Prefix));
    end;

    local procedure ClearDevResults(var TempResult: Record "Name/Value Buffer" temporary; DevCode: Text)
    begin
        TempResult.Reset();
        TempResult.SetFilter(Name, DevCode + '*');
        TempResult.DeleteAll();
        TempResult.Reset();
        DevTestCounter := 0;
    end;

    local procedure AddCheck(var TempResult: Record "Name/Value Buffer" temporary; DevCode: Text; Description: Text; Passed: Boolean; PassDetails: Text; FailDetails: Text)
    begin
        if Passed then
            AddResult(TempResult, DevCode, Description, PassTok, PassDetails)
        else
            AddResult(TempResult, DevCode, Description, FailTok, FailDetails);
    end;

    local procedure AddResult(var TempResult: Record "Name/Value Buffer" temporary; DevCode: Text; Description: Text; Status: Text; Details: Text)
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
        TempResult.Name := CopyStr(StrSubstNo('%1 T%2 %3', DevCode, Format(DevTestCounter, 0, '<Integer,2><Filler Character,0>'), Description), 1, MaxStrLen(TempResult.Name));
        TempResult.Value := CopyStr(Status, 1, MaxStrLen(TempResult.Value));
        TempResult."Value Long" := CopyStr(Details, 1, MaxStrLen(TempResult."Value Long"));
        TempResult.Insert();
    end;

    local procedure TestDocNo(Prefix: Text; i: Integer): Code[20]
    begin
        exit(CopyStr(Prefix + Format(i, 0, '<Integer,3><Filler Character,0>'), 1, 20));
    end;

    local procedure NoOfTestRecords(): Integer
    begin
        exit(20);
    end;

    local procedure FirstShipmentFieldNo(): Integer
    begin
        exit(66600); // CHM Total Net Weight
    end;

    local procedure LastShipmentFieldNo(): Integer
    begin
        exit(66606); // CHM Non-reusable Packaging
    end;

    local procedure RunModeRenderReport(): Integer
    begin
        exit(1);
    end;
}
