pageextension 66610 "CHM Posted Sales Shipments" extends "Posted Sales Shipments"
{
    /// <summary>
    /// DEV-003: returns the shipments the user selected on the list,
    /// so the Michelin labels page can load all of them, not only the current row.
    /// </summary>
    procedure GetSelectedShipments(var SalesShptHeader: Record "Sales Shipment Header")
    begin
        CurrPage.SetSelectionFilter(SalesShptHeader);
    end;
}