codeunit 66600 "CHM Event Management"
{
    var
        GrossLessThanNetErr: Label 'Total Gross Weight (%1) cannot be less than Total Net Weight (%2).', Comment = '%1 = Total Gross Weight, %2 = Total Net Weight';

    /// <summary>
    /// Raises an error when the total gross weight is lower than the total net weight.
    /// </summary>
    procedure CheckWeights(NetWeight: Decimal; GrossWeight: Decimal)
    begin
        if (GrossWeight <> 0) and (GrossWeight < NetWeight) then
            Error(GrossLessThanNetErr, GrossWeight, NetWeight);
    end;

    /// <summary>
    /// Copies the Chematek shipment fields from the warehouse shipment to the posted warehouse shipment.
    /// </summary>
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

    /// <summary>
    /// Copies the Chematek shipment fields from the warehouse shipment to the posted sales shipment.
    /// </summary>
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

    /// <summary>
    /// Marks the Posted Sales Shipment - Update page as changed when a Chematek shipment field is changed.
    /// </summary>
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

    /// <summary>
    /// Saves the Chematek shipment fields changed on the Posted Sales Shipment - Update page.
    /// </summary>
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

    /// <summary>
    /// Copies the Chematek shipment fields from the warehouse shipment to the posted return shipment.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptHeaderInsert', '', false, false)]
    local procedure CopyToReturnShptHeader(var ReturnShptHeader: Record "Return Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WhseShip: Boolean)
    var
        FromWarehouseShipmentHeader: Record "Warehouse Shipment Header";
    begin
        if not WhseShip then
            exit;
        if not FromWarehouseShipmentHeader.Get(WarehouseShipmentHeader."No.") then
            exit;

        ReturnShptHeader."CHM Total Net Weight" := FromWarehouseShipmentHeader."CHM Total Net Weight";
        ReturnShptHeader."CHM Total Gross Weight" := FromWarehouseShipmentHeader."CHM Total Gross Weight";
        ReturnShptHeader."CHM Total Parcel" := FromWarehouseShipmentHeader."CHM Total Parcel";
        ReturnShptHeader."CHM Total Pallet" := FromWarehouseShipmentHeader."CHM Total Pallet";
        ReturnShptHeader."CHM Total Volume" := FromWarehouseShipmentHeader."CHM Total Volume";
        ReturnShptHeader."CHM Goods Appearance" := FromWarehouseShipmentHeader."CHM Goods Appearance";
        ReturnShptHeader."CHM Non-reusable Packaging" := FromWarehouseShipmentHeader."CHM Non-reusable Packaging";
    end;

    /// <summary>
    /// Marks the Posted Return Shpt. - Update page as changed when a Chematek shipment field is changed.
    /// The values are compared with xReturnShipmentHeaderGlobal, the record saved when the page was opened.
    /// </summary>
    [EventSubscriber(ObjectType::Page, Page::"Posted Return Shpt. - Update", 'OnAfterRecordChanged', '', false, false)]
    local procedure MarkChangedOnReturnShptUpdate(var ReturnShipmentHeader: Record "Return Shipment Header"; var IsChanged: Boolean; xReturnShipmentHeaderGlobal: Record "Return Shipment Header")
    begin
        if IsChanged then
            exit;

        IsChanged :=
          (ReturnShipmentHeader."CHM Total Net Weight" <> xReturnShipmentHeaderGlobal."CHM Total Net Weight") or
          (ReturnShipmentHeader."CHM Total Gross Weight" <> xReturnShipmentHeaderGlobal."CHM Total Gross Weight") or
          (ReturnShipmentHeader."CHM Total Parcel" <> xReturnShipmentHeaderGlobal."CHM Total Parcel") or
          (ReturnShipmentHeader."CHM Total Pallet" <> xReturnShipmentHeaderGlobal."CHM Total Pallet") or
          (ReturnShipmentHeader."CHM Total Volume" <> xReturnShipmentHeaderGlobal."CHM Total Volume") or
          (ReturnShipmentHeader."CHM Goods Appearance" <> xReturnShipmentHeaderGlobal."CHM Goods Appearance") or
          (ReturnShipmentHeader."CHM Non-reusable Packaging" <> xReturnShipmentHeaderGlobal."CHM Non-reusable Packaging");
    end;

    /// <summary>
    /// Saves the Chematek shipment fields changed on the Posted Return Shpt. - Update page.
    /// </summary>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Return Shipment Header - Edit", 'OnBeforeReturnShipmentHeaderModify', '', false, false)]
    local procedure CopyReturnShipmentFieldsOnEdit(var ReturnShipmentHeader: Record "Return Shipment Header"; ReturnShipmentHeaderRec: Record "Return Shipment Header")
    begin
        ReturnShipmentHeader."CHM Total Net Weight" := ReturnShipmentHeaderRec."CHM Total Net Weight";
        ReturnShipmentHeader."CHM Total Gross Weight" := ReturnShipmentHeaderRec."CHM Total Gross Weight";
        ReturnShipmentHeader."CHM Total Parcel" := ReturnShipmentHeaderRec."CHM Total Parcel";
        ReturnShipmentHeader."CHM Total Pallet" := ReturnShipmentHeaderRec."CHM Total Pallet";
        ReturnShipmentHeader."CHM Total Volume" := ReturnShipmentHeaderRec."CHM Total Volume";
        ReturnShipmentHeader."CHM Goods Appearance" := ReturnShipmentHeaderRec."CHM Goods Appearance";
        ReturnShipmentHeader."CHM Non-reusable Packaging" := ReturnShipmentHeaderRec."CHM Non-reusable Packaging";
    end;
}
