page 80440 "Purch. Worksheet Card Lines nH"
{
    Caption = 'Purchase Worksheet Card Lines';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Purch. Worksheet Line nH";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

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
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Document No."; Rec."Vendor Document No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Split By"; Rec."Split By")
                {
                    ApplicationArea = All;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Dimension 1 Code"; Rec."Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 2 Code"; Rec."Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 3 Code"; Rec."Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension 4 Code"; Rec."Dimension 4 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension 5 Code"; Rec."Dimension 5 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension 6 Code"; Rec."Dimension 6 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension 7 Code"; Rec."Dimension 7 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Dimension 8 Code"; Rec."Dimension 8 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Amount Incl. VAT"; Rec."Total Amount Incl. VAT")
                {
                    ApplicationArea = All;
                }
                field("Document Created"; Rec."Document Created")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Creation Date"; Rec."Document Creation Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document Line No."; Rec."Document Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(DocumentAction)
            {
                ApplicationArea = All;
                Caption = 'Document';
                Enabled = DocumentEnabled;
                Image = Document;

                trigger OnAction();
                begin
                    Rec.NavigateToDocument();
                end;
            }
            action(VendorAction)
            {
                ApplicationArea = All;
                Caption = 'Vendor';
                Enabled = VendorEnabled;
                Image = Vendor;

                trigger OnAction();
                begin
                    Rec.NavigateToVendor();
                end;
            }
            action(GLAccountItemFixedAssetItemChargeAction)
            {
                ApplicationArea = All;
                Caption = 'G/L Account / Item / Fixed Asset / Item Charge';
                Enabled = GLAccountItemFixedAssetItemChargeEnabled;
                Image = GL;

                trigger OnAction();
                begin
                    Rec.NavigateToNo();
                end;
            }
            action(ItemVariantAction)
            {
                ApplicationArea = All;
                Caption = 'Item Variant';
                Enabled = ItemVariantEnabled;
                Image = ItemVariant;

                trigger OnAction();
                begin
                    Rec.NavigateToItemVariant();
                end;
            }
        }
    }
    var DocumentEnabled: Boolean;
    VendorEnabled: Boolean;
    GLAccountItemFixedAssetItemChargeEnabled: Boolean;
    ItemVariantEnabled: Boolean;
    ErrorStyle: Text;
    trigger OnAfterGetRecord();
    begin
        UpdatePage();
    end;
    local procedure UpdatePage();
    begin
        DocumentEnabled:=((Rec."Document Created") and (Rec."Document No." <> ''));
        VendorEnabled:=(Rec."Vendor No." <> '');
        GLAccountItemFixedAssetItemChargeEnabled:=((Rec.Type <> Rec.Type::" ") and (Rec."No." <> ''));
        ItemVariantEnabled:=((Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Variant Code" <> ''));
        ErrorStyle:=Rec.GetErrorStyle();
    end;
}
