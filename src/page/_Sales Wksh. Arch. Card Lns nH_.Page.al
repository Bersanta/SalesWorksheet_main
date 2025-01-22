page 80443 "Sales Wksh. Arch. Card Lns nH"
{
    Caption = 'Sales Worksheet Archive Card Lines';
    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Sales Wksh. Arch. Line nH";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Customer Name"; Rec."Customer Name")
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
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
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
                field("Unit Price"; Rec."Unit Price")
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
            action(CustomerAction)
            {
                ApplicationArea = All;
                Caption = 'Customer';
                Enabled = CustomerEnabled;
                Image = Customer;

                ;
                trigger OnAction();
                begin
                    Rec.NavigateToCustomer();
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
    trigger OnAfterGetRecord();
    begin
        UpdatePage();
    end;
    var DocumentEnabled: Boolean;
    CustomerEnabled: Boolean;
    GLAccountItemFixedAssetItemChargeEnabled: Boolean;
    ItemVariantEnabled: Boolean;
    local procedure UpdatePage();
    begin
        DocumentEnabled:=((Rec."Document Created") and (Rec."Document No." <> ''));
        CustomerEnabled:=(Rec."Customer No." <> '');
        GLAccountItemFixedAssetItemChargeEnabled:=((Rec.Type <> Rec.Type::" ") and (Rec."No." <> ''));
        ItemVariantEnabled:=((Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec."Variant Code" <> ''));
    end;
}
