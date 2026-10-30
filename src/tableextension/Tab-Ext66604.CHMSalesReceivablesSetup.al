tableextension 66604 "CHM Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(66600; "CHM Michelin Label Nos."; Code[20])
        {
            Caption = 'Michelin Label Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}
