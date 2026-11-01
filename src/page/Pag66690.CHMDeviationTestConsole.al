page 66690 "CHM Deviation Test Console"
{
    // TEST ONLY - runs the DEV-001 to DEV-004 checks in "CHM Deviation Test Mgt." and shows the results.
    Caption = 'CHM Deviation Test Console (DEV-001 to DEV-004)';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Summary)
            {
                Caption = 'Summary';

                field(TotalCount; TotalCount)
                {
                    Caption = 'Result Lines';
                    ToolTip = 'Specifies the number of result lines currently shown.';
                }
                field(PassCount; PassCount)
                {
                    Caption = 'Passed';
                    StyleExpr = PassStyle;
                    ToolTip = 'Specifies the number of tests that passed.';
                }
                field(FailCount; FailCount)
                {
                    Caption = 'Failed';
                    StyleExpr = FailStyle;
                    ToolTip = 'Specifies the number of tests that failed.';
                }
                field(WarnCount; WarnCount)
                {
                    Caption = 'Warnings';
                    StyleExpr = WarnStyle;
                    ToolTip = 'Specifies the number of warnings, for example missing setup.';
                }
            }
            repeater(Results)
            {
                field(LineNo; Rec.ID)
                {
                    Caption = 'Line No.';
                    ToolTip = 'Specifies the result line number.';
                }
                field(TestName; Rec.Name)
                {
                    Caption = 'Test';
                    ToolTip = 'Specifies the deviation, test number and what was tested.';
                }
                field(Result; Rec.Value)
                {
                    Caption = 'Result';
                    StyleExpr = ResultStyle;
                    ToolTip = 'Specifies PASS, FAIL, WARN or INFO.';
                }
                field(Details; Rec."Value Long")
                {
                    Caption = 'Details';
                    ToolTip = 'Specifies the details of the result, including the error text for failed tests.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(DEV001Actions)
            {
                Caption = 'DEV-001 Update Posted Shipment';

                action(Dev001CreateData)
                {
                    Caption = '1. Create Test Data';
                    Image = CreateDocument;
                    ToolTip = 'Create 20 dummy posted sales shipments (CHMT1-001 to CHMT1-020) with empty shipment fields.';

                    trigger OnAction()
                    begin
                        TestMgt.CreateDev001TestData(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev001RunTests)
                {
                    Caption = '2. Run Tests';
                    Image = TestReport;
                    ToolTip = 'Update the 7 shipment fields on the 20 posted shipments through the page 1350 save logic and check the results.';

                    trigger OnAction()
                    begin
                        TestMgt.RunDev001Tests(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev001OpenRecords)
                {
                    Caption = '3. Open Test Records';
                    Image = Navigate;
                    ToolTip = 'Open the dummy posted sales shipments to check the fields and Update Document manually.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev001TestRecords();
                    end;
                }
                action(Dev001DeleteData)
                {
                    Caption = '4. Delete Test Data';
                    Image = Delete;
                    ToolTip = 'Delete all CHMT1 dummy records.';

                    trigger OnAction()
                    begin
                        TestMgt.DeleteDev001TestData(Rec);
                        RefreshPage();
                    end;
                }
            }
            group(DEV002Actions)
            {
                Caption = 'DEV-002 Shipment Fields';

                action(Dev002CreateData)
                {
                    Caption = '1. Create Test Data';
                    Image = CreateDocument;
                    ToolTip = 'Create 20 dummy warehouse shipments (CHMT2-001 to CHMT2-020) and fill the 7 shipment fields.';

                    trigger OnAction()
                    begin
                        TestMgt.CreateDev002TestData(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev002RunTests)
                {
                    Caption = '2. Run Tests';
                    Image = TestReport;
                    ToolTip = 'Check field entry and validation on the warehouse shipments, the field definitions on the posted tables, and the flow on real postings.';

                    trigger OnAction()
                    begin
                        TestMgt.RunDev002Tests(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev002OpenRecords)
                {
                    Caption = '3. Open Test Records';
                    Image = Navigate;
                    ToolTip = 'Open the dummy warehouse shipments.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev002TestRecords();
                    end;
                }
                action(Dev002DeleteData)
                {
                    Caption = '4. Delete Test Data';
                    Image = Delete;
                    ToolTip = 'Delete all CHMT2 dummy records.';

                    trigger OnAction()
                    begin
                        TestMgt.DeleteDev002TestData(Rec);
                        RefreshPage();
                    end;
                }
            }
            group(DEV003Actions)
            {
                Caption = 'DEV-003 Michelin Labels';

                action(Dev003CreateData)
                {
                    Caption = '1. Create Test Data';
                    Image = CreateDocument;
                    ToolTip = 'Create 3 dummy customers, 20 dummy posted shipments with item lines (14 Michelin, 6 non-Michelin) and a test label No. Series.';

                    trigger OnAction()
                    begin
                        TestMgt.CreateDev003TestData(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev003RunTests)
                {
                    Caption = '2. Run Tests';
                    Image = TestReport;
                    ToolTip = 'Check the Michelin customer fields and filter, and render the barcode report to PDF using the test label No. Series.';

                    trigger OnAction()
                    begin
                        TestMgt.RunDev003Tests(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev003OpenRecords)
                {
                    Caption = '3. Open Test Records';
                    Image = Navigate;
                    ToolTip = 'Open the Michelin printed labels page to load a CHMT3 shipment and print labels manually.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev003TestRecords();
                    end;
                }
                action(Dev003DeleteData)
                {
                    Caption = '4. Delete Test Data';
                    Image = Delete;
                    ToolTip = 'Delete all CHMT3 dummy records and the test label No. Series.';

                    trigger OnAction()
                    begin
                        TestMgt.DeleteDev003TestData(Rec);
                        RefreshPage();
                    end;
                }
            }
            group(DEV004Actions)
            {
                Caption = 'DEV-004 Lot Production Date';

                action(Dev004CreateData)
                {
                    Caption = '1. Create Test Data';
                    Image = CreateDocument;
                    ToolTip = 'Create a dummy item and 20 lots (CHMT4-LOT01 to CHMT4-LOT20) with production dates.';

                    trigger OnAction()
                    begin
                        TestMgt.CreateDev004TestData(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004RunTests)
                {
                    Caption = '2. Run Tests';
                    Image = TestReport;
                    ToolTip = 'Check the production date on the lots, on Item Tracking Lines and in the posting step, and the flow on real postings.';

                    trigger OnAction()
                    begin
                        TestMgt.RunDev004Tests(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004OpenRecords)
                {
                    Caption = '3. Open Test Records';
                    Image = Navigate;
                    ToolTip = 'Open the dummy lots on the Lot No. Information list.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev004TestRecords();
                    end;
                }
                action(Dev004DeleteData)
                {
                    Caption = '4. Delete Test Data';
                    Image = Delete;
                    ToolTip = 'Delete the dummy item and its lots.';

                    trigger OnAction()
                    begin
                        TestMgt.DeleteDev004TestData(Rec);
                        RefreshPage();
                    end;
                }
            }
            action(ClearResults)
            {
                Caption = 'Clear Results';
                Image = ClearLog;
                ToolTip = 'Clear all result lines. Test data is not deleted.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                    RefreshPage();
                end;
            }
        }
        area(Promoted)
        {
            group(DEV001Promoted)
            {
                Caption = 'DEV-001';

                actionref(Dev001CreateData_Promoted; Dev001CreateData) { }
                actionref(Dev001RunTests_Promoted; Dev001RunTests) { }
                actionref(Dev001OpenRecords_Promoted; Dev001OpenRecords) { }
                actionref(Dev001DeleteData_Promoted; Dev001DeleteData) { }
            }
            group(DEV002Promoted)
            {
                Caption = 'DEV-002';

                actionref(Dev002CreateData_Promoted; Dev002CreateData) { }
                actionref(Dev002RunTests_Promoted; Dev002RunTests) { }
                actionref(Dev002OpenRecords_Promoted; Dev002OpenRecords) { }
                actionref(Dev002DeleteData_Promoted; Dev002DeleteData) { }
            }
            group(DEV003Promoted)
            {
                Caption = 'DEV-003';

                actionref(Dev003CreateData_Promoted; Dev003CreateData) { }
                actionref(Dev003RunTests_Promoted; Dev003RunTests) { }
                actionref(Dev003OpenRecords_Promoted; Dev003OpenRecords) { }
                actionref(Dev003DeleteData_Promoted; Dev003DeleteData) { }
            }
            group(DEV004Promoted)
            {
                Caption = 'DEV-004';

                actionref(Dev004CreateData_Promoted; Dev004CreateData) { }
                actionref(Dev004RunTests_Promoted; Dev004RunTests) { }
                actionref(Dev004OpenRecords_Promoted; Dev004OpenRecords) { }
                actionref(Dev004DeleteData_Promoted; Dev004DeleteData) { }
            }
            actionref(ClearResults_Promoted; ClearResults) { }
        }
    }

    var
        TestMgt: Codeunit "CHM Deviation Test Mgt.";
        TotalCount: Integer;
        PassCount: Integer;
        FailCount: Integer;
        WarnCount: Integer;
        ResultStyle: Text;
        PassStyle: Text;
        FailStyle: Text;
        WarnStyle: Text;

    trigger OnOpenPage()
    begin
        UpdateSummary();
    end;

    trigger OnAfterGetRecord()
    begin
        case Rec.Value of
            'PASS':
                ResultStyle := 'Favorable';
            'FAIL':
                ResultStyle := 'Unfavorable';
            'WARN':
                ResultStyle := 'Ambiguous';
            else
                ResultStyle := 'Standard';
        end;
    end;

    local procedure RefreshPage()
    begin
        UpdateSummary();
        Rec.Reset();
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure UpdateSummary()
    var
        TempResultCopy: Record "Name/Value Buffer" temporary;
    begin
        TempResultCopy.Copy(Rec, true);
        TempResultCopy.Reset();
        TotalCount := TempResultCopy.Count();
        TempResultCopy.SetRange(Value, 'PASS');
        PassCount := TempResultCopy.Count();
        TempResultCopy.SetRange(Value, 'FAIL');
        FailCount := TempResultCopy.Count();
        TempResultCopy.SetRange(Value, 'WARN');
        WarnCount := TempResultCopy.Count();

        PassStyle := 'Favorable';
        FailStyle := 'Standard';
        if FailCount > 0 then
            FailStyle := 'Unfavorable';
        WarnStyle := 'Standard';
        if WarnCount > 0 then
            WarnStyle := 'Ambiguous';
    end;
}
