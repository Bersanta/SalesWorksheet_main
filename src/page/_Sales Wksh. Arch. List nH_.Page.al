page 80445 "Sales Wksh. Arch. List nH"
{
    Caption = 'Sales Worksheet Archives';
    CardPageID = "Sales Wksh. Arch. Card nH";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Navigate';
    SourceTable = "Sales Wksh. Arch. Header nH";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date Time"; Rec."Created Date Time")
                {
                    ApplicationArea = All;
                }
                field("Modified By"; Rec."Modified By")
                {
                    ApplicationArea = All;
                }
                field("Modified Date Time"; Rec."Modified Date Time")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
        }
    }
    actions
    {
    }
    var SalesPurchWkshModule: Codeunit "Sales Purch.Wksh. Module nH";
    trigger OnOpenPage();
    begin
        SalesPurchWkshModule.CanUseSalesPurchWksh(true);
    end;
}
