namespace SalesWorksheet.SalesWorksheet;

using Microsoft.Sales.Document;

tableextension 80437 "Sales Header Ext_rph." extends "Sales Header"
{
    fields
    {
        field(80437; "Order Season Type_rph"; Enum "Season Types")
        {
            Caption = 'Order Season Type';
            DataClassification = ToBeClassified;
        }
        field(80438; "Order Season Code_rph"; Code[10])
        {
            Caption = 'Order Season Code';
            DataClassification = ToBeClassified;
        }
        field(80439; "Shipping Comments"; Text[100])
        {
            Caption = 'Shipping Comments';
            DataClassification = ToBeClassified;
        }
    }
}
