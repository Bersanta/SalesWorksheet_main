page 80447 "Sales Worksheet Card nH"
{
    Caption = 'Sales Worksheet';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Sales Worksheet Header nH";

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
            part(LinesPart; "Sales Worksheet Card Lines nH")
            {
                ApplicationArea = All;
                Caption = 'Lines';
                SubPageLink = "Sales Worksheet No."=field("No.");
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
    trigger OnAfterGetCurrRecord();
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
