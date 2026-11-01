page 66690 "CHM Deviation Test Console"
{
    // TEST ONLY - DEV-002 shipment fields: creates postable warehouse shipments with lines,
    // posts them and checks the flow to Posted Whse. Shipment and Posted Sales Shipment.
    Caption = 'CHM Deviation Test Console (DEV-002)';
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                Caption = 'DEV-002 Setup';

                field(TestLocation; TestLocationCode)
                {
                    Caption = 'Test Location';
                    Editable = false;
                    ToolTip = 'Specifies the location used for the test shipments. It is created with Require Shipment, without pick and bins.';
                }
                field(NoOfShipments; NoOfShipments)
                {
                    Caption = 'No. of Shipments';
                    MinValue = 1;
                    MaxValue = 50;
                    ToolTip = 'Specifies how many sales orders with warehouse shipments are created per run.';
                }
                field(TemplateItemNo; TemplateItemNo)
                {
                    Caption = 'Template Item No.';
                    TableRelation = Item;
                    ToolTip = 'Specifies the item whose posting groups and unit of measure are copied to the test items. Leave blank to pick one automatically. It must not use item tracking.';
                }
                field(TemplateCustomerNo; TemplateCustomerNo)
                {
                    Caption = 'Template Customer No.';
                    TableRelation = Customer;
                    ToolTip = 'Specifies the customer whose posting groups are copied to the test customer. Leave blank to pick one automatically.';
                }
            }
            group(Summary)
            {
                Caption = 'Summary';

                field(TotalCount; TotalCount)
                {
                    Caption = 'Result Lines';
                    Editable = false;
                    ToolTip = 'Specifies the number of result lines currently shown.';
                }
                field(PassCount; PassCount)
                {
                    Caption = 'Passed';
                    Editable = false;
                    StyleExpr = PassStyle;
                    ToolTip = 'Specifies the number of checks that passed.';
                }
                field(FailCount; FailCount)
                {
                    Caption = 'Failed';
                    Editable = false;
                    StyleExpr = FailStyle;
                    ToolTip = 'Specifies the number of checks that failed.';
                }
                field(WarnCount; WarnCount)
                {
                    Caption = 'Warnings';
                    Editable = false;
                    StyleExpr = WarnStyle;
                    ToolTip = 'Specifies the number of warnings.';
                }
            }
            repeater(Results)
            {
                Editable = false;

                field(LineNo; Rec.ID)
                {
                    Caption = 'Line No.';
                    ToolTip = 'Specifies the result line number.';
                }
                field(TestName; Rec.Name)
                {
                    Caption = 'Step / Test';
                    ToolTip = 'Specifies the step, test number and what was done or checked.';
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
                    ToolTip = 'Specifies the details, including document numbers and the error text for failed steps.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(DEV002Actions)
            {
                Caption = 'DEV-002 Shipment Fields';

                action(Dev002CreateData)
                {
                    Caption = '1. Create Test Data';
                    Image = CreateDocument;
                    ToolTip = 'Create the test location, items, customer and stock, then released sales orders with warehouse shipments that have lines, Qty. to Ship and the 7 shipment fields filled.';

                    trigger OnAction()
                    begin
                        TestMgt.SetTemplates(TemplateItemNo, TemplateCustomerNo);
                        TestMgt.CreateDev002TestData(Rec, NoOfShipments);
                        RefreshPage();
                    end;
                }
                action(Dev002OpenWhseShipments)
                {
                    Caption = '2. Open Warehouse Shipments';
                    Image = Shipment;
                    ToolTip = 'Open the test warehouse shipments to check the lines and the 7 fields, change values and post them manually with Post Shipment.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev002WhseShipments();
                    end;
                }
                action(Dev002PostShipments)
                {
                    Caption = '3. Post Test Shipments';
                    Image = PostOrder;
                    ToolTip = 'Post (Ship only) all open test warehouse shipments that have Qty. to Ship.';

                    trigger OnAction()
                    begin
                        TestMgt.PostDev002TestShipments(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev002RunTests)
                {
                    Caption = '4. Run Tests';
                    Image = TestReport;
                    ToolTip = 'Check the open shipments, the field validation and definitions, and the header and line flow to Posted Whse. Shipment and Posted Sales Shipment.';

                    trigger OnAction()
                    begin
                        TestMgt.RunDev002Tests(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev002OpenPostedWhse)
                {
                    Caption = '5. Open Posted Whse. Shipments';
                    Image = PostedShipment;
                    ToolTip = 'Open the posted warehouse shipments of the test location.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev002PostedWhseShipments();
                    end;
                }
                action(Dev002OpenPostedSales)
                {
                    Caption = '6. Open Posted Sales Shipments';
                    Image = PostedShipment;
                    ToolTip = 'Open the posted sales shipments of the test sales orders.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev002PostedSalesShipments();
                    end;
                }
                action(Dev002DeleteData)
                {
                    Caption = '7. Delete Open Test Data';
                    Image = Delete;
                    ToolTip = 'Delete the open test warehouse shipments and the test sales orders that were not shipped. Posted documents and master data are kept.';

                    trigger OnAction()
                    begin
                        TestMgt.DeleteDev002TestData(Rec);
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
            group(DEV002Promoted)
            {
                Caption = 'DEV-002';

                actionref(Dev002CreateData_Promoted; Dev002CreateData) { }
                actionref(Dev002OpenWhseShipments_Promoted; Dev002OpenWhseShipments) { }
                actionref(Dev002PostShipments_Promoted; Dev002PostShipments) { }
                actionref(Dev002RunTests_Promoted; Dev002RunTests) { }
                actionref(Dev002OpenPostedWhse_Promoted; Dev002OpenPostedWhse) { }
                actionref(Dev002OpenPostedSales_Promoted; Dev002OpenPostedSales) { }
                actionref(Dev002DeleteData_Promoted; Dev002DeleteData) { }
            }
            actionref(ClearResults_Promoted; ClearResults) { }
        }
    }

    var
        TestMgt: Codeunit "CHM Deviation Test Mgt.";
        TestLocationCode: Code[10];
        NoOfShipments: Integer;
        TemplateItemNo: Code[20];
        TemplateCustomerNo: Code[20];
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
        TestLocationCode := TestMgt.GetTestLocationCode();
        NoOfShipments := 20;
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
