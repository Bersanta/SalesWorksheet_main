table 80438 "Purch. Wksh. Arch. Line nH"
{
    Caption = 'Purchase Worksheet Archive Line';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Purchase Worksheet Archive No."; Code[20])
        {
            Caption = 'Purchase Worksheet Archive No.';
            DataClassification = SystemMetadata;
            TableRelation = "Purch. Wksh. Arch. Header nH";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,Order,Invoice,Credit Memo,,Return Order';
            OptionMembers = " ", "Order", Invoice, "Credit Memo", , "Return Order";
        }
        field(20; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
            ValidateTableRelation = false;
        }
        field(21; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(40; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = SystemMetadata;
        }
        field(41; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(42; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = SystemMetadata;
        }
        field(43; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
            DataClassification = SystemMetadata;
        }
        field(50; "Vendor Document No."; Text[35])
        {
            Caption = 'Vendor Document No.';
            DataClassification = SystemMetadata;
        }
        field(60; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
            TableRelation = Currency;
            ValidateTableRelation = false;
        }
        field(70; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
            DataClassification = SystemMetadata;
        }
        field(80; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            DataClassification = SystemMetadata;
            TableRelation = "Shipment Method";
            ValidateTableRelation = false;
        }
        field(100; Type; Option)
        {
            Caption = 'Type';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ", "G/L Account", Item, , "Fixed Asset", "Charge (Item)";
        }
        field(110; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
            TableRelation = IF(Type=CONST(" "))"Standard Text"
            ELSE IF(Type=CONST("G/L Account"))"G/L Account"
            ELSE IF(Type=CONST(Item))Item
            ELSE IF(Type=CONST("Fixed Asset"))"Fixed Asset"
            ELSE IF(Type=CONST("Charge (Item)"))"Item Charge";
            ValidateTableRelation = false;
        }
        field(111; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
            TableRelation = "Item Variant".Code WHERE("Item No."=FIELD("No."));
            ValidateTableRelation = false;
        }
        field(120; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(130; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(140; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            DataClassification = SystemMetadata;
        }
        field(150; "Split By"; Code[50])
        {
            Caption = 'Split By';
            DataClassification = SystemMetadata;
        }
        field(160; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = SystemMetadata;
            TableRelation = Location;
            ValidateTableRelation = false;
        }
        field(170; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = SystemMetadata;
            TableRelation = "VAT Business Posting Group";
            ValidateTableRelation = false;
        }
        field(171; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = SystemMetadata;
            TableRelation = "VAT Product Posting Group";
            ValidateTableRelation = false;
        }
        field(180; "Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Dimension 1 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1));
            ValidateTableRelation = false;
        }
        field(181; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Dimension 2 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(2));
            ValidateTableRelation = false;
        }
        field(182; "Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Dimension 3 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(3));
            ValidateTableRelation = false;
        }
        field(183; "Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Dimension 4 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(4));
            ValidateTableRelation = false;
        }
        field(184; "Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Dimension 5 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(5));
            ValidateTableRelation = false;
        }
        field(185; "Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Dimension 6 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(6));
            ValidateTableRelation = false;
        }
        field(186; "Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Dimension 7 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(7));
            ValidateTableRelation = false;
        }
        field(187; "Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Dimension 8 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(8));
            ValidateTableRelation = false;
        }
        field(200; "Document Created"; Boolean)
        {
            Caption = 'Document Created';
            DataClassification = SystemMetadata;
        }
        field(201; "Document Creation Date"; Date)
        {
            Caption = 'Document Creation Date';
            DataClassification = SystemMetadata;
        }
        field(202; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = SystemMetadata;
        }
        field(203; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            DataClassification = SystemMetadata;
        }
        field(300; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = SystemMetadata;
        }
        field(310; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = SystemMetadata;
        }
        field(320; "Total Amount Incl. VAT"; Decimal)
        {
            Caption = 'Total Amount Incl. VAT';
            DataClassification = SystemMetadata;
        }
        field(1000; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnLookup();
            begin
                RecordAuditManagement.UserLookup(Rec."Created By", false);
            end;
        }
        field(1001; "Created Date Time"; DateTime)
        {
            Caption = 'Created Date Time';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(1002; "Modified By"; Code[50])
        {
            Caption = 'Modified By';
            DataClassification = EndUserIdentifiableInformation;

            trigger OnLookup();
            begin
                RecordAuditManagement.UserLookup(Rec."Modified By", false);
            end;
        }
        field(1003; "Modified Date Time"; DateTime)
        {
            Caption = 'Modified Date Time';
            DataClassification = EndUserIdentifiableInformation;
        }
    }
    keys
    {
        key(Key1; "Purchase Worksheet Archive No.", "Line No.")
        {
        }
        key(Key2; "Purchase Worksheet Archive No.", "Document Created")
        {
        }
        key(Key3; "Purchase Worksheet Archive No.", "Document Created", "Split By")
        {
        }
    }
    fieldgroups
    {
    }
    var RecordAuditManagement: Codeunit "Record Audit Management nH";
    procedure NavigateToDocument();
    begin
        Rec.TESTFIELD("Document Created", true);
        Rec.TESTFIELD("Document No.");
        case(Rec."Document Type")of Rec."Document Type"::Order: NavigateToNotPostedDocument(PAGE::"Purchase Order");
        Rec."Document Type"::Invoice: NavigateToNotPostedDocument(PAGE::"Purchase Invoice");
        Rec."Document Type"::"Return Order": NavigateToNotPostedDocument(PAGE::"Purchase Return Order");
        Rec."Document Type"::"Credit Memo": NavigateToNotPostedDocument(PAGE::"Purchase Credit Memo");
        end;
    end;
    procedure NavigateToVendor();
    var
        Vendor: Record Vendor;
    begin
        Rec.TESTFIELD("Vendor No.");
        Vendor.GET(Rec."Vendor No.");
        PAGE.RUN(PAGE::"Vendor Card", Vendor);
    end;
    procedure NavigateToNo();
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";
    begin
        Rec.TESTFIELD(Type);
        Rec.TESTFIELD("No.");
        case(Rec.Type)of Rec.Type::"G/L Account": begin
            GLAccount.GET(Rec."No.");
            PAGE.RUN(PAGE::"G/L Account Card", GLAccount);
        end;
        Rec.Type::Item: begin
            Item.GET(Rec."No.");
            PAGE.RUN(PAGE::"Item Card", Item);
        end;
        Rec.Type::"Fixed Asset": begin
            FixedAsset.GET(Rec."No.");
            PAGE.RUN(PAGE::"Fixed Asset Card", FixedAsset);
        end;
        Rec.Type::"Charge (Item)": begin
            ItemCharge.GET(Rec."No.");
            PAGE.RUN(0, ItemCharge);
        end;
        end;
    end;
    procedure NavigateToItemVariant();
    var
        ItemVariant: Record "Item Variant";
    begin
        Rec.TESTFIELD(Type, Rec.Type::Item);
        Rec.TESTFIELD("No.");
        Rec.TESTFIELD("Variant Code");
        ItemVariant.GET(Rec."No.", Rec."Variant Code");
        PAGE.RUN(0, ItemVariant);
    end;
    local procedure NavigateToNotPostedDocument(pPageId: Integer);
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.GET(Rec."Document Type", Rec."Document No.");
        PAGE.RUN(pPageId, PurchaseHeader);
    end;
}
