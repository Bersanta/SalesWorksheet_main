page 80448 "Sales Worksheet List nH"
{
    Caption = 'Sales Worksheets';
    CardPageID = "Sales Worksheet Card nH";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Navigate';
    SourceTable = "Sales Worksheet Header nH";
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
                field("Error Detected"; Rec."Error Detected")
                {
                    ApplicationArea = All;
                    StyleExpr = ErrorStyle;
                    Visible = false;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    StyleExpr = ErrorStyle;
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
        area(processing)
        {
            action(ImportAction)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.Import();
                end;
            }
            action(CreateDocumentsAction)
            {
                ApplicationArea = All;
                Caption = 'Create Documents';
                Image = CreateDocuments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    CLEAR(CreateSalesWkshDocuments);
                    CreateSalesWkshDocuments.CreateDocuments(Rec, true);
                end;
            }
            action(ArchiveAction)
            {
                ApplicationArea = All;
                Caption = 'Archive';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    CLEAR(ArchiveSalesWorksheet);
                    ArchiveSalesWorksheet.Archive(Rec, true);
                end;
            }
        }
        area(navigation)
        {
            action(ArchivesAction)
            {
                ApplicationArea = All;
                Caption = 'Archives';
                Image = Archive;
                RunObject = Page "Sales Wksh. Arch. List nH";
            }
        }
    }
    var SalesPurchWkshModule: Codeunit "Sales Purch.Wksh. Module nH";
    trigger OnOpenPage();
    begin
        SalesPurchWkshModule.CanUseSalesPurchWksh(true);
    end;
    trigger OnAfterGetRecord();
    begin
        UpdatePage();
    end;
    var ArchiveSalesWorksheet: Codeunit "Archive Sales Worksheet nH";
    CreateSalesWkshDocuments: Codeunit "Create Sales Wksh. Docs nH";
    ErrorStyle: Text;
    local procedure UpdatePage();
    begin
        ErrorStyle:=Rec.GetErrorStyle();
    end;
}
