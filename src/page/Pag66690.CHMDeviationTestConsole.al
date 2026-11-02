page 66690 "CHM Deviation Test Console"
{
    // TEST ONLY - DEV-002 shipment fields and DEV-004 Production Date on lot numbers.
    // Creates real test documents, posts them and checks the flow to the posted records.
    Caption = 'CHM Deviation Test Console (DEV-002, DEV-004)';
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
            group(Templates)
            {
                Caption = 'Templates (DEV-002 and DEV-004)';

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
                    ToolTip = 'Specifies the customer whose posting groups are copied to the test customers. Leave blank to pick one automatically.';
                }
                field(TemplateVendorNo; TemplateVendorNo)
                {
                    Caption = 'Template Vendor No.';
                    TableRelation = Vendor;
                    ToolTip = 'Specifies the vendor whose posting groups are copied to the DEV-004 test vendor. Leave blank to pick one automatically.';
                }
            }
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
            }
            group(Dev004Setup)
            {
                Caption = 'DEV-004 Setup';

                field(Dev004Location; Dev004LocationCode)
                {
                    Caption = 'Test Location';
                    Editable = false;
                    ToolTip = 'Specifies the location used for the DEV-004 tests. It has no warehouse handling, so documents post directly.';
                }
                field(Dev004Item; Dev004ItemNo)
                {
                    Caption = 'Test Item';
                    Editable = false;
                    ToolTip = 'Specifies the lot-tracked item used for the DEV-004 tests.';
                }
                field(Dev004Run; Dev004RunText)
                {
                    Caption = 'Current Run';
                    Editable = false;
                    ToolTip = 'Specifies the latest DEV-004 test run and its lot numbers. Steps 2 to 5 work on this run.';
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
                    ToolTip = 'Specifies PASS, FAIL, WARN, INFO, or OPEN for a line that shows a record you can open.';
                }
                field(OpenPage; OpenPageText)
                {
                    Caption = 'Page';
                    ToolTip = 'Specifies the page that shows the record of this line. Click it to open the page with the actual data.';

                    trigger OnDrillDown()
                    begin
                        TestMgt.OpenResultRecord(Rec.ID);
                    end;
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
            action(OpenResultPage)
            {
                Caption = 'Open Page';
                Image = View;
                Scope = Repeater;
                ToolTip = 'Open the page with the actual data of the selected result line, for example the Item Tracking Lines, the item ledger entries or the Lot No. Information Card.';

                trigger OnAction()
                begin
                    TestMgt.OpenResultRecord(Rec.ID);
                end;
            }
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
                        TestMgt.SetTemplates(TemplateItemNo, TemplateCustomerNo, TemplateVendorNo);
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
            group(DEV004Actions)
            {
                Caption = 'DEV-004 Lot Production Date';

                action(Dev004CreateData)
                {
                    Caption = '1. Create Test Data';
                    Image = CreateDocument;
                    ToolTip = 'Create the lot-tracked test item, location, vendor and customer, an item journal with lots L1, L2 and L4 and a purchase order with lot L3, all with Production Dates on the item tracking lines.';

                    trigger OnAction()
                    begin
                        TestMgt.SetTemplates(TemplateItemNo, TemplateCustomerNo, TemplateVendorNo);
                        TestMgt.CreateDev004TestData(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004PostInbound)
                {
                    Caption = '2. Post Inbound';
                    Image = PostOrder;
                    ToolTip = 'Post the test item journal and receive the test purchase order of the current run.';

                    trigger OnAction()
                    begin
                        TestMgt.PostDev004Inbound(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004CreateOutbound)
                {
                    Caption = '3. Create Outbound';
                    Image = NewDocument;
                    ToolTip = 'Change the Production Date of lot L2 on its card, create item journal lines for lots L1 (blank date) and L2, and a sales order for lot L1.';

                    trigger OnAction()
                    begin
                        TestMgt.SetTemplates(TemplateItemNo, TemplateCustomerNo, TemplateVendorNo);
                        TestMgt.CreateDev004Outbound(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004PostOutbound)
                {
                    Caption = '4. Post Outbound';
                    Image = PostOrder;
                    ToolTip = 'Post the test item journal and ship the test sales order of the current run.';

                    trigger OnAction()
                    begin
                        TestMgt.PostDev004Outbound(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004RunTests)
                {
                    Caption = '5. Run Tests';
                    Image = TestReport;
                    ToolTip = 'Check the Production Date on the open item tracking lines, the item ledger entries and the Lot No. Information cards, and the Item Tracking Lines rules.';

                    trigger OnAction()
                    begin
                        TestMgt.RunDev004Tests(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004ShowFlow)
                {
                    Caption = 'Show Process Flow';
                    Image = Navigate;
                    ToolTip = 'List every record of the current run in process order, from the item journal and purchase order with their Item Tracking Lines to the item ledger entries and Lot No. Information cards. Click the Page column to open each one.';

                    trigger OnAction()
                    begin
                        TestMgt.ShowDev004ProcessFlow(Rec);
                        RefreshPage();
                    end;
                }
                action(Dev004OpenItemJournal)
                {
                    Caption = 'Open Item Journal';
                    Image = Journal;
                    ToolTip = 'Open the test item journal batch. Use Item Tracking Lines on a line to see the Production Date.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev004ItemJournal();
                    end;
                }
                action(Dev004OpenPurchaseOrders)
                {
                    Caption = 'Open Purchase Orders';
                    Image = Document;
                    ToolTip = 'Open the DEV-004 test purchase orders.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev004PurchaseOrders();
                    end;
                }
                action(Dev004OpenSalesOrders)
                {
                    Caption = 'Open Sales Orders';
                    Image = Document;
                    ToolTip = 'Open the DEV-004 test sales orders.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev004SalesOrders();
                    end;
                }
                action(Dev004OpenItemLedgerEntries)
                {
                    Caption = 'Open Item Ledger Entries';
                    Image = ItemLedger;
                    ToolTip = 'Open the item ledger entries of the test item with the Production Date column.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev004ItemLedgerEntries();
                    end;
                }
                action(Dev004OpenLotNoInformation)
                {
                    Caption = 'Open Lot No. Information';
                    Image = Lot;
                    ToolTip = 'Open the Lot No. Information list of the test item with the Production Date column.';

                    trigger OnAction()
                    begin
                        TestMgt.OpenDev004LotNoInformation();
                    end;
                }
                action(Dev004DeleteData)
                {
                    Caption = 'Delete Open Test Data';
                    Image = Delete;
                    ToolTip = 'Delete the open lines of the test item journal and the test purchase and sales orders that were not received or shipped. Posted entries, lots and master data are kept.';

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
                    TestMgt.ClearResultLinks();
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
            group(DEV004Promoted)
            {
                Caption = 'DEV-004';

                actionref(Dev004CreateData_Promoted; Dev004CreateData) { }
                actionref(Dev004PostInbound_Promoted; Dev004PostInbound) { }
                actionref(Dev004CreateOutbound_Promoted; Dev004CreateOutbound) { }
                actionref(Dev004PostOutbound_Promoted; Dev004PostOutbound) { }
                actionref(Dev004RunTests_Promoted; Dev004RunTests) { }
                actionref(Dev004ShowFlow_Promoted; Dev004ShowFlow) { }
                actionref(Dev004OpenItemJournal_Promoted; Dev004OpenItemJournal) { }
                actionref(Dev004OpenPurchaseOrders_Promoted; Dev004OpenPurchaseOrders) { }
                actionref(Dev004OpenSalesOrders_Promoted; Dev004OpenSalesOrders) { }
                actionref(Dev004OpenItemLedgerEntries_Promoted; Dev004OpenItemLedgerEntries) { }
                actionref(Dev004OpenLotNoInformation_Promoted; Dev004OpenLotNoInformation) { }
                actionref(Dev004DeleteData_Promoted; Dev004DeleteData) { }
            }
            actionref(OpenResultPage_Promoted; OpenResultPage) { }
            actionref(ClearResults_Promoted; ClearResults) { }
        }
    }

    var
        TestMgt: Codeunit "CHM Deviation Test Mgt.";
        TestLocationCode: Code[10];
        NoOfShipments: Integer;
        TemplateItemNo: Code[20];
        TemplateCustomerNo: Code[20];
        TemplateVendorNo: Code[20];
        Dev004LocationCode: Code[10];
        Dev004ItemNo: Code[20];
        Dev004RunText: Text;
        OpenPageText: Text;
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
        Dev004LocationCode := TestMgt.GetDev004LocationCode();
        Dev004ItemNo := TestMgt.GetDev004ItemNo();
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
            'OPEN':
                ResultStyle := 'StrongAccent';
            else
                ResultStyle := 'Standard';
        end;
        OpenPageText := TestMgt.GetResultLinkCaption(Rec.ID);
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
        Dev004RunText := TestMgt.GetDev004RunText();
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
