codeunit 66600 "CHM Event Management"
{
    var
        GrossLessThanNetErr: Label 'Total Gross Weight (%1) cannot be less than Total Net Weight (%2).', Comment = '%1 = Total Gross Weight, %2 = Total Net Weight';

    procedure CheckWeights(NetWeight: Decimal; GrossWeight: Decimal)
    begin
        if (GrossWeight <> 0) and (GrossWeight < NetWeight) then
            Error(GrossLessThanNetErr, GrossWeight, NetWeight);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforePostedWhseShptHeaderInsert', '', false, false)]
    local procedure CopyToPostedWhseShptHeader(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PostedWhseShipmentHeader."CHM Total Net Weight" := WarehouseShipmentHeader."CHM Total Net Weight";
        PostedWhseShipmentHeader."CHM Total Gross Weight" := WarehouseShipmentHeader."CHM Total Gross Weight";
        PostedWhseShipmentHeader."CHM Total Parcel" := WarehouseShipmentHeader."CHM Total Parcel";
        PostedWhseShipmentHeader."CHM Total Pallet" := WarehouseShipmentHeader."CHM Total Pallet";
        PostedWhseShipmentHeader."CHM Total Volume" := WarehouseShipmentHeader."CHM Total Volume";
        PostedWhseShipmentHeader."CHM Goods Appearance" := WarehouseShipmentHeader."CHM Goods Appearance";
        PostedWhseShipmentHeader."CHM Non-reusable Packaging" := WarehouseShipmentHeader."CHM Non-reusable Packaging";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesShptHeaderInsert', '', false, false)]
    local procedure CopyToSalesShptHeader(var SalesShptHeader: Record "Sales Shipment Header"; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; WhseShip: Boolean)
    var
        WarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if not WhseShip then
            exit;
        if not WarehouseShipmentHeader.Get(TempWhseShptHeader."No.") then
            exit;

        SalesShptHeader."CHM Total Net Weight" := WarehouseShipmentHeader."CHM Total Net Weight";
        SalesShptHeader."CHM Total Gross Weight" := WarehouseShipmentHeader."CHM Total Gross Weight";
        SalesShptHeader."CHM Total Parcel" := WarehouseShipmentHeader."CHM Total Parcel";
        SalesShptHeader."CHM Total Pallet" := WarehouseShipmentHeader."CHM Total Pallet";
        SalesShptHeader."CHM Total Volume" := WarehouseShipmentHeader."CHM Total Volume";
        SalesShptHeader."CHM Goods Appearance" := WarehouseShipmentHeader."CHM Goods Appearance";
        SalesShptHeader."CHM Non-reusable Packaging" := WarehouseShipmentHeader."CHM Non-reusable Packaging";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Shipment - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure MarkChangedOnShptUpdate(var SalesShipmentHeader: Record "Sales Shipment Header"; xSalesShipmentHeader: Record "Sales Shipment Header"; var IsChanged: Boolean)
    begin
        if IsChanged then
            exit;

        IsChanged :=
          (SalesShipmentHeader."CHM Total Net Weight" <> xSalesShipmentHeader."CHM Total Net Weight") or
          (SalesShipmentHeader."CHM Total Gross Weight" <> xSalesShipmentHeader."CHM Total Gross Weight") or
          (SalesShipmentHeader."CHM Total Parcel" <> xSalesShipmentHeader."CHM Total Parcel") or
          (SalesShipmentHeader."CHM Total Pallet" <> xSalesShipmentHeader."CHM Total Pallet") or
          (SalesShipmentHeader."CHM Total Volume" <> xSalesShipmentHeader."CHM Total Volume") or
          (SalesShipmentHeader."CHM Goods Appearance" <> xSalesShipmentHeader."CHM Goods Appearance") or
          (SalesShipmentHeader."CHM Non-reusable Packaging" <> xSalesShipmentHeader."CHM Non-reusable Packaging");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Shipment Header - Edit", 'OnBeforeSalesShptHeaderModify', '', false, false)]
    local procedure CopyShipmentFieldsOnEdit(var SalesShptHeader: Record "Sales Shipment Header"; FromSalesShptHeader: Record "Sales Shipment Header")
    begin
        SalesShptHeader."CHM Total Net Weight" := FromSalesShptHeader."CHM Total Net Weight";
        SalesShptHeader."CHM Total Gross Weight" := FromSalesShptHeader."CHM Total Gross Weight";
        SalesShptHeader."CHM Total Parcel" := FromSalesShptHeader."CHM Total Parcel";
        SalesShptHeader."CHM Total Pallet" := FromSalesShptHeader."CHM Total Pallet";
        SalesShptHeader."CHM Total Volume" := FromSalesShptHeader."CHM Total Volume";
        SalesShptHeader."CHM Goods Appearance" := FromSalesShptHeader."CHM Goods Appearance";
        SalesShptHeader."CHM Non-reusable Packaging" := FromSalesShptHeader."CHM Non-reusable Packaging";
    end;
}
