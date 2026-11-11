pageextension 66610 "CHM Posted Sales Shipments" extends "Posted Sales Shipments"
{
    /// <summary>
    /// Returns the shipments selected on the list, so the Michelin labels page can load all of them.
    /// </summary>
    procedure GetSelectedShipments(var SalesShptHeader: Record "Sales Shipment Header")
    begin
        CurrPage.SetSelectionFilter(SalesShptHeader);
    end;
}