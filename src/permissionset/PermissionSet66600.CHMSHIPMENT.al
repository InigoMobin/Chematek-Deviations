permissionset 66600 "CHM SHIPMENT"
{
    Assignable = true;
    Caption = 'Chematek Shipment';
    Permissions =
        table "CHM Goods Appearance" = X,
        tabledata "CHM Goods Appearance" = RIMD,
        page "CHM Goods Appearances" = X,
        codeunit "CHM Event Management" = X,
        codeunit "CHM Lot Production Date Mgt." = X,
        codeunit "CHM Management" = X,
        table "CHM Michelin Labels" = X,
        tabledata "CHM Michelin Labels" = RIMD,
        page "CHM Michelin Labels" = X,
        report "CHM Michelin Labels" = X,
        report "CHM Sales Quote" = X,
        report "CHM Sales Order Confirmation" = X,
        report "CHM Posted Sales Invoice" = X,
        report "CHM Posted Credit Memo" = X,
        report "CHM Purchase Order" = X,
        report "CHM Sales Shipment" = X,
        table "CHM Customizations Setup" = X,
        tabledata "CHM Customizations Setup" = RIMD,
        page "CHM Customizations Setup" = X;
}
