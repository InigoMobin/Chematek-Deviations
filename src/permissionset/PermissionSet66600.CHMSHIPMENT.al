permissionset 66600 "CHM SHIPMENT"
{
    Assignable = true;
    Caption = 'Chematek Shipment';
    Permissions =
        table "CHM Goods Appearance" = X,
        tabledata "CHM Goods Appearance" = RIMD,
        page "CHM Goods Appearances" = X,
        codeunit "CHM Event Management" = X;
}
