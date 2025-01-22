page 80444 "Sales Wksh. Arch. Card nH"
{
    Caption = 'Sales Worksheet Archive';
    Editable = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Sales Wksh. Arch. Header nH";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                group(RecordAuditGroup)
                {
                    Caption = 'Record Audit';

                    field("Created By"; Rec."Created By")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Created Date Time"; Rec."Created Date Time")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Modified By"; Rec."Modified By")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                    field("Modified Date Time"; Rec."Modified Date Time")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Importance = Additional;
                    }
                }
            }
            part(LinesPart; "Sales Wksh. Arch. Card Lns nH")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Sales Worksheet Archive No."=field("No.");
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
