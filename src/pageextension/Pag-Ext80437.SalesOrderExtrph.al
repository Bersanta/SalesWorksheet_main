namespace SalesWorksheet.SalesWorksheet;

using Microsoft.Sales.Document;

pageextension 80437 "Sales Order Ext._rph" extends "Sales Order"
{
    layout
    {
        addafter("Create Transfer Error")
        {
            field("Order Season Code_rph"; Rec."Order Season Code_rph")
            {
                ApplicationArea = All;
            }
            field("Order Season Type_rph"; Rec."Order Season Type_rph")
            {
                ApplicationArea = All;
            }
        }
    }
}
