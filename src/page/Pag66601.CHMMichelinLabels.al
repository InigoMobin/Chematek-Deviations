page 66601 "CHM Michelin Labels"
{
    Caption = 'List of Michelin printed labels';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CHM Michelin Labels";
    SourceTableTemporary = true;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Filters)
            {
                Caption = 'Filters';

                field(SalesOrderNoFilter; SalesOrderNoFilter)
                {
                    Caption = 'Sales Order No.';
                    ToolTip = 'Specifies a filter on the sales order number of the loaded lines.';

                    trigger OnValidate()
                    begin
                        ApplyPageFilters();
                    end;
                }
                field(SalesShptCodeFilter; SalesShptCodeFilter)
                {
                    Caption = 'Sales Shipment Code';
                    ToolTip = 'Specifies a filter on the posted sales shipment number of the loaded lines.';

                    trigger OnValidate()
                    begin
                        ApplyPageFilters();
                    end;
                }
            }
            group(Copies)
            {
                ShowCaption = false;

                field(NoOfCopies; NoOfCopies)
                {
                    Caption = 'No. of copies';
                    MinValue = 0;
                    ToolTip = 'Specifies how many copies of each label are printed.';
                }
            }
            repeater(Lines)
            {
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the sales order number.';
                }
                field("Sales Shpt. Code"; Rec."Sales Shpt. Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the posted sales shipment number.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the item number.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the item description.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the lot number shipped.';
                }
                field("Production Date"; Rec."Production Date")
                {
                    ToolTip = 'Specifies the production date of the lot (DD.MM.YY).';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the quantity printed on the label.';
                }
                field("Michelin Purch. Order"; Rec."Michelin Purch. Order")
                {
                    ToolTip = 'Specifies the Michelin purchase order number.';
                }
                field("Ship-from Name"; Rec."Ship-from Name")
                {
                    ToolTip = 'Specifies the ship-from name.';
                }
                field("Ship-from Address"; Rec."Ship-from Address")
                {
                    ToolTip = 'Specifies the ship-from address.';
                }
                field("Ship-from City"; Rec."Ship-from City")
                {
                    ToolTip = 'Specifies the ship-from city.';
                }
                field("Ship-from Post Code"; Rec."Ship-from Post Code")
                {
                    ToolTip = 'Specifies the ship-from post code.';
                }
                field("Ship-from County"; Rec."Ship-from County")
                {
                    ToolTip = 'Specifies the ship-from county.';
                }
                field("Ship-from Country"; Rec."Ship-from Country")
                {
                    ToolTip = 'Specifies the ship-from country.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ToolTip = 'Specifies the ship-to name.';
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    ToolTip = 'Specifies the ship-to address.';
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the ship-to city.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ToolTip = 'Specifies the ship-to post code.';
                }
                field("Ship-to County"; Rec."Ship-to County")
                {
                    ToolTip = 'Specifies the ship-to county.';
                }
                field("Ship-to Country"; Rec."Ship-to Country")
                {
                    ToolTip = 'Specifies the ship-to country.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadShipment)
            {
                Caption = 'Load Shipment Lines';
                Image = GetLines;
                ToolTip = 'Select a posted sales shipment of a Michelin customer and load its lines with lot details.';

                trigger OnAction()
                begin
                    LoadShipmentLines();
                end;
            }
            action(ApplyFilters)
            {
                Caption = 'Apply Filters';
                Image = UseFilters;
                ToolTip = 'Apply the Sales Order No. and Sales Shipment Code filters to the lines.';

                trigger OnAction()
                begin
                    ApplyPageFilters();
                end;
            }
            action(PrintLabels)
            {
                Caption = 'Print labels';
                Image = Print;
                ToolTip = 'Print Michelin labels for the selected lines, using the No. of copies entered above.';

                trigger OnAction()
                begin
                    PrintSelectedLabels();
                end;
            }
            action(ClearLines)
            {
                Caption = 'Clear Lines';
                Image = ClearLog;
                ToolTip = 'Remove all loaded lines from the page.';

                trigger OnAction()
                begin
                    Rec.Reset();
                    Rec.DeleteAll();
                    ApplyPageFilters();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(LoadShipment_Promoted; LoadShipment) { }
                actionref(ApplyFilters_Promoted; ApplyFilters) { }
                actionref(PrintLabels_Promoted; PrintLabels) { }
                actionref(ClearLines_Promoted; ClearLines) { }
            }
        }
    }

    var
        SalesOrderNoFilter: Text;
        SalesShptCodeFilter: Text;
        NoOfCopies: Integer;
        NextIndex: BigInteger;
        NoLinesErr: Label 'Posted sales shipment %1 has no item lines to load.', Comment = '%1 = Shipment No.';
        AlreadyLoadedQst: Label 'Lines for shipment %1 are already loaded. Do you want to reload them?', Comment = '%1 = Shipment No.';
        NothingSelectedErr: Label 'Select at least one line to print.';
        NoOfCopiesErr: Label 'No. of copies must be at least 1.';
        LinesLoadedMsg: Label '%1 line(s) loaded from shipment %2.', Comment = '%1 = No. of lines, %2 = Shipment No.';

    trigger OnOpenPage()
    begin
        // The page always opens empty; lines are loaded only through the Load Shipment Lines action
        Rec.Reset();
        Rec.DeleteAll();
        NoOfCopies := 1;
    end;

    local procedure LoadShipmentLines()
    var
        SalesShptHeader: Record "Sales Shipment Header";
        SalesShptLine: Record "Sales Shipment Line";
        LinesInserted: Integer;
    begin
        SalesShptHeader.SetRange("CHM Michelin Customer", true);
        if Page.RunModal(Page::"Posted Sales Shipments", SalesShptHeader) <> Action::LookupOK then
            exit;

        SalesShptLine.SetRange("Document No.", SalesShptHeader."No.");
        SalesShptLine.SetRange(Type, SalesShptLine.Type::Item);
        SalesShptLine.SetRange(Correction, false);
        SalesShptLine.SetFilter(Quantity, '<>0');
        if SalesShptLine.IsEmpty() then
            Error(NoLinesErr, SalesShptHeader."No.");

        // Avoid loading the same shipment twice
        Rec.Reset();
        Rec.SetRange("Sales Shpt. Code", SalesShptHeader."No.");
        if not Rec.IsEmpty() then begin
            if not Confirm(AlreadyLoadedQst, false, SalesShptHeader."No.") then begin
                ApplyPageFilters();
                exit;
            end;
            Rec.DeleteAll();
        end;
        Rec.Reset();

        SalesShptLine.FindSet();
        repeat
            LinesInserted += InsertLinesForShipmentLine(SalesShptHeader, SalesShptLine);
        until SalesShptLine.Next() = 0;

        ApplyPageFilters();
        Message(LinesLoadedMsg, LinesInserted, SalesShptHeader."No.");
    end;

    local procedure InsertLinesForShipmentLine(SalesShptHeader: Record "Sales Shipment Header"; SalesShptLine: Record "Sales Shipment Line") LinesInserted: Integer
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        QtyPerUoM: Decimal;
    begin
        QtyPerUoM := SalesShptLine."Qty. per Unit of Measure";
        if QtyPerUoM = 0 then
            QtyPerUoM := 1;

        // One label line per lot shipped on this shipment line
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetRange("Document No.", SalesShptLine."Document No.");
        ItemLedgerEntry.SetRange("Document Line No.", SalesShptLine."Line No.");
        ItemLedgerEntry.SetRange("Item No.", SalesShptLine."No.");
        if ItemLedgerEntry.FindSet() then
            repeat
                InsertLabelLine(SalesShptHeader, SalesShptLine, ItemLedgerEntry."Lot No.", Abs(ItemLedgerEntry.Quantity) / QtyPerUoM);
                LinesInserted += 1;
            until ItemLedgerEntry.Next() = 0
        else begin
            InsertLabelLine(SalesShptHeader, SalesShptLine, '', SalesShptLine.Quantity);
            LinesInserted += 1;
        end;
    end;

    local procedure InsertLabelLine(SalesShptHeader: Record "Sales Shipment Header"; SalesShptLine: Record "Sales Shipment Line"; LotNo: Code[50]; Qty: Decimal)
    begin
        NextIndex += 1;
        Rec.Init();
        Rec.Index := NextIndex;
        Rec."Sales Order No." := SalesShptLine."Order No.";
        if Rec."Sales Order No." = '' then
            Rec."Sales Order No." := SalesShptHeader."Order No.";
        Rec."Sales Shpt. Code" := SalesShptHeader."No.";
        Rec."Item No." := SalesShptLine."No.";
        Rec.Description := SalesShptLine.Description;
        Rec."Lot No." := LotNo;
        Rec."Production Date" := GetProductionDate(SalesShptLine."No.", SalesShptLine."Variant Code", LotNo);
        Rec.Quantity := Round(Qty, 1);
        Rec."Michelin Purch. Order" := CopyStr(SalesShptHeader."External Document No.", 1, MaxStrLen(Rec."Michelin Purch. Order"));
        SetShipFromAddress(SalesShptLine."Location Code");
        SetShipToAddress(SalesShptHeader);
        Rec.Insert();
    end;

    local procedure SetShipFromAddress(LocationCode: Code[10])
    var
        Location: Record Location;
        CompanyInformation: Record "Company Information";
    begin
        // Ship-from = shipping location address; falls back to Company Information
        if Location.Get(LocationCode) and (Location.Address <> '') then begin
            Rec."Ship-from Name" := Location.Name;
            Rec."Ship-from Address" := Location.Address;
            Rec."Ship-from City" := Location.City;
            Rec."Ship-from Post Code" := Location."Post Code";
            Rec."Ship-from County" := Location.County;
            Rec."Ship-from Country" := GetCountryName(Location."Country/Region Code");
            exit;
        end;

        CompanyInformation.Get();
        Rec."Ship-from Name" := CopyStr(CompanyInformation.Name, 1, MaxStrLen(Rec."Ship-from Name"));
        Rec."Ship-from Address" := CompanyInformation.Address;
        Rec."Ship-from City" := CompanyInformation.City;
        Rec."Ship-from Post Code" := CompanyInformation."Post Code";
        Rec."Ship-from County" := CompanyInformation.County;
        Rec."Ship-from Country" := GetCountryName(CompanyInformation."Country/Region Code");
    end;

    local procedure SetShipToAddress(SalesShptHeader: Record "Sales Shipment Header")
    begin
        Rec."Ship-to Name" := SalesShptHeader."Ship-to Name";
        Rec."Ship-to Address" := SalesShptHeader."Ship-to Address";
        Rec."Ship-to City" := SalesShptHeader."Ship-to City";
        Rec."Ship-to Post Code" := SalesShptHeader."Ship-to Post Code";
        Rec."Ship-to County" := SalesShptHeader."Ship-to County";
        Rec."Ship-to Country" := GetCountryName(SalesShptHeader."Ship-to Country/Region Code");
    end;

    local procedure GetCountryName(CountryCode: Code[10]): Text[50]
    var
        CountryRegion: Record "Country/Region";
    begin
        if CountryRegion.Get(CountryCode) then
            exit(CopyStr(CountryRegion.Name, 1, 50));
        exit(CountryCode);
    end;

    local procedure GetProductionDate(ItemNo: Code[20]; VariantCode: Code[10]; LotNo: Code[50]): Code[8]
    begin
        // TODO DEV-004: read the Production Date field from Lot No. Information once DEV-004 is deployed, e.g.
        // if LotNoInformation.Get(ItemNo, VariantCode, LotNo) then
        //     exit(Format(LotNoInformation."CHM Production Date", 0, '<Day,2>.<Month,2>.<Year,2>'));
        exit('');
    end;

    local procedure PrintSelectedLabels()
    var
        TempSelectedLabels: Record "CHM Michelin Labels" temporary;
        MichelinLabels: Report "CHM Michelin Labels";
    begin
        if NoOfCopies < 1 then
            Error(NoOfCopiesErr);

        TempSelectedLabels.Copy(Rec, true);
        CurrPage.SetSelectionFilter(TempSelectedLabels);
        if TempSelectedLabels.IsEmpty() then
            Error(NothingSelectedErr);

        MichelinLabels.SetData(TempSelectedLabels, NoOfCopies);
        MichelinLabels.RunModal();
    end;

    local procedure ApplyPageFilters()
    begin
        Rec.Reset();
        if SalesOrderNoFilter <> '' then
            Rec.SetFilter("Sales Order No.", SalesOrderNoFilter);
        if SalesShptCodeFilter <> '' then
            Rec.SetFilter("Sales Shpt. Code", SalesShptCodeFilter);
        CurrPage.Update(false);
    end;
}
