page 80449 "Sales/Purch. Wksh. Setup nH"
{
    Caption = 'Sales/Purchase Worksheet Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Sales/Purch. Wksh. Setup nH";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(SalesWorksheetsGroup)
            {
                Caption = 'Sales Worksheets';

                field("Sales Worksheet Nos."; Rec."Sales Worksheet Nos.")
                {
                    ApplicationArea = All;
                }
                field("Sales Wksh. Can Create Cust."; Rec."Sales Wksh. Can Create Cust.")
                {
                    ApplicationArea = All;
                }
                field("Auto-Archive Sales Wkshts."; Rec."Auto-Archive Sales Wkshts.")
                {
                    ApplicationArea = All;
                }
                field("Sales XMLport ID"; Rec."Sales XMLport ID")
                {
                    ApplicationArea = All;
                }
                field("Sales Wksh. Check Tollerance"; Rec."Sales Wksh. Check Tollerance")
                {
                    ApplicationArea = All;
                }
                field("Sales Tot.Amt. Tollerance"; Rec."Sales Tot.Amt. Tollerance")
                {
                    ApplicationArea = All;
                }
                field("Sales T.Amt.InclVAT Tolleranc"; Rec."Sales T.Amt.InclVAT Tolleranc")
                {
                    ApplicationArea = All;
                }
                field("Sales XMLport Name"; Rec."Sales XMLport Name")
                {
                    ApplicationArea = All;
                }
            }
            group(PurchaseWorksheetsGroup)
            {
                Caption = 'Purchase Worksheets';

                field("Purchase Worksheet Nos."; Rec."Purchase Worksheet Nos.")
                {
                    ApplicationArea = All;
                }
                field("Purch. Wksh. Can Create Vendor"; Rec."Purch. Wksh. Can Create Vendor")
                {
                    ApplicationArea = All;
                }
                field("Auto-Archive Purchase Wkshts."; Rec."Auto-Archive Purchase Wkshts.")
                {
                    ApplicationArea = All;
                }
                field("Purchase XMLport ID"; Rec."Purchase XMLport ID")
                {
                    ApplicationArea = All;
                }
                field("Purch. Wksh. Check Tollerance"; Rec."Purch. Wksh. Check Tollerance")
                {
                    ApplicationArea = All;
                }
                field("Purch. Tot.Amt. Tollerance"; Rec."Purch. Tot.Amt. Tollerance")
                {
                    ApplicationArea = All;
                }
                field("Purch. T.Amt.InclVAT Tolleranc"; Rec."Purch. T.Amt.InclVAT Tolleranc")
                {
                    ApplicationArea = All;
                }
                field("Purchase XMLport Name"; Rec."Purchase XMLport Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    trigger OnOpenPage();
    begin
        Rec.VerifyAndGet();
    end;
}
