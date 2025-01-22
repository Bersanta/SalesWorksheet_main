table 80444 "Sales Worksheet Line nH"
{
    Caption = 'Sales Worksheet Line';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Sales Worksheet No."; Code[20])
        {
            Caption = 'Sales Worksheet No.';
            DataClassification = SystemMetadata;
            TableRelation = "Sales Worksheet Header nH";
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
            OptionMembers = " ","Order",Invoice,"Credit Memo",,"Return Order";

            trigger OnValidate();
            begin
                if (Rec."Document Type" <> xRec."Document Type") then begin
                    Rec.TESTFIELD("Document Created", false);
                    Rec.VALIDATE("Document No.", '');
                end;
            end;
        }
        field(20; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Customer: Record Customer;
            begin
                if (Rec."Customer No." <> '') then if (Customer.GET(Rec."Customer No.")) then Rec.VALIDATE("Customer Name", Customer.Name);
            end;
        }
        field(21; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(22; "Order Type"; enum "Order Types")
        {
            Caption = 'Order Type';
            DataClassification = ToBeClassified;
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
        field(43; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
            DataClassification = SystemMetadata;
        }

        field(44; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
            DataClassification = ToBeClassified;
        }
        field(45; "External Document No."; Text[35])
        {
            Caption = 'External Document No.';
            DataClassification = SystemMetadata;
        }

        field(46; "Order Season Type"; enum "Season Types")
        {
            Caption = 'Order Season Type';
            DataClassification = ToBeClassified;
        }
        field(47; "Order Season Code"; Code[10])
        {
            Caption = 'Order Season Code';
            DataClassification = ToBeClassified;
        }
        field(48; "Delivery Information"; Blob)
        {
            DataClassification = ToBeClassified;
        }

        field(49; "Shipping Agent"; Code[10])
        {
            Caption = 'Shipping Agent';
            DataClassification = ToBeClassified;
        }

        field(50; "Shipping Agent Service"; Code[10])
        {
            Caption = 'Shipping Agent Service';
            DataClassification = ToBeClassified;
        }

        field(51; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
            DataClassification = ToBeClassified;
        }
        field(52; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
            DataClassification = ToBeClassified;
        }
        field(53; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
            DataClassification = ToBeClassified;
        }
        field(54; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
            DataClassification = ToBeClassified;
        }
        field(55; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            DataClassification = ToBeClassified;
        }
        field(56; "Ship-to PostCode"; Code[20])
        {
            Caption = 'Ship-to PostCode';
            DataClassification = ToBeClassified;
        }
        field(57; "Ship-to Country"; Code[10])
        {
            Caption = 'Ship-to Country';
            DataClassification = ToBeClassified;
        }

        field(58; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
            DataClassification = ToBeClassified;
        }

        field(59; "Ship-to Phone No."; Text[30])
        {
            Caption = 'Ship-to Phone No.';
            DataClassification = ToBeClassified;
        }

        field(60; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
            TableRelation = Currency;
            ValidateTableRelation = false;
        }
        field(61; "Ship-to E-mail"; Text[80])
        {
            Caption = 'Ship-to E-mail';
            DataClassification = ToBeClassified;
        }

        field(62; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
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
        field(90; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = SystemMetadata;
        }
        field(100; Type; Option)
        {
            Caption = 'Type';
            DataClassification = SystemMetadata;
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";

            trigger OnValidate();
            begin
                if (Rec.Type <> xRec.Type) then Rec.VALIDATE("No.", '');
            end;
        }
        field(110; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST(Resource)) Resource
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = CONST("Charge (Item)")) "Item Charge";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                GLAccount: Record "G/L Account";
                Item: Record Item;
                Resource: Record Resource;
                FixedAsset: Record "Fixed Asset";
                ItemCharge: Record "Item Charge";
            begin
                if (Rec."No." <> xRec."No.") then begin
                    if (Rec."No." <> '') then
                        case (Rec.Type) of
                            Rec.Type::"G/L Account":
                                if (GLAccount.GET(Rec."No.")) then
                                    Rec.VALIDATE(Description, GLAccount.Name);
                            Rec.Type::Item:
                                if (Item.GET(Rec."No.")) then
                                    Rec.VALIDATE(Description, String.Concatenate(Item.Description, Item."Description 2", ' '));
                            Rec.Type::Resource:
                                if (Resource.GET(Rec."No.")) then
                                    Rec.VALIDATE(Description, String.Concatenate(Resource.Name, Resource."Name 2", ' '));
                            Rec.Type::"Fixed Asset":
                                if (FixedAsset.GET(Rec."No.")) then
                                    Rec.VALIDATE(Description, String.Concatenate(FixedAsset.Description, FixedAsset."Description 2", ' '));
                            Rec.Type::"Charge (Item)":
                                if (ItemCharge.GET(Rec."No.")) then
                                    Rec.VALIDATE(Description, ItemCharge.Description);
                        end;
                    Rec.VALIDATE("Variant Code", '');
                end;
            end;
        }
        field(111; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = SystemMetadata;
            TableRelation = "Item Variant".Code WHERE("Item No." = FIELD("No."));
            ValidateTableRelation = false;
        }
        field(120; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(130; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        field(140; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = SystemMetadata;
        }
        field(141; "Line Discount"; Decimal)
        {
            Caption = 'Line Discount';
            DataClassification = ToBeClassified;
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            ValidateTableRelation = false;
        }
        field(181; "Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Dimension 2 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            ValidateTableRelation = false;
        }
        field(182; "Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Dimension 3 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            ValidateTableRelation = false;
        }
        field(183; "Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Dimension 4 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
            ValidateTableRelation = false;
        }
        field(184; "Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Dimension 5 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
            ValidateTableRelation = false;
        }
        field(185; "Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Dimension 6 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
            ValidateTableRelation = false;
        }
        field(186; "Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Dimension 7 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
            ValidateTableRelation = false;
        }
        field(187; "Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Dimension 8 Code';
            DataClassification = SystemMetadata;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
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
        field(220; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
            DataClassification = SystemMetadata;
        }
        field(230; "Error Detected"; Boolean)
        {
            CalcFormula = Exist("Log nH" WHERE("Entry Type" = CONST(Error), "Record ID" = FIELD("Record ID")));
            Caption = 'Error Detected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(231; "Error Message"; Text[250])
        {
            CalcFormula = Lookup("Log nH".Message WHERE("Entry Type" = CONST(Error), "Record ID" = FIELD("Record ID")));
            Caption = 'Error Message';
            Editable = false;
            FieldClass = FlowField;
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
        key(Key1; "Sales Worksheet No.", "Line No.")
        {
        }
        key(Key2; "Sales Worksheet No.", "Document Created")
        {
        }
        key(Key3; "Sales Worksheet No.", "Document Created", "Split By")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert();
    begin
        Rec.TESTFIELD("Sales Worksheet No.");
        Rec.VALIDATE("Record ID", Rec.RECORDID());
        RecordAuditManagement.SetCreated(Rec."Created By", Rec."Created Date Time");
    end;

    trigger OnModify();
    begin
        MessageLogManagement.DeleteForRecord(Rec."Record ID");
        RecordAuditManagement.SetModified(Rec."Modified By", Rec."Modified Date Time");
    end;

    trigger OnRename();
    begin
        Rec.TESTFIELD("Sales Worksheet No.");
        Rec.VALIDATE("Record ID", Rec.RECORDID());
        RecordAuditManagement.SetModified(Rec."Modified By", Rec."Modified Date Time");
    end;

    var
        MessageLogManagement: Codeunit "Log Management nH";
        RecordAuditManagement: Codeunit "Record Audit Management nH";
        String: Codeunit "String Management nH";
        TxtDimensionNoNotSupported: Label 'Dimension no. %1 is not supported.';

    procedure GetDimensionCode(pDimensionNo: Integer): Code[20];
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
    begin
        if ((pDimensionNo < 1) or (pDimensionNo > 8)) then ERROR(TxtDimensionNoNotSupported);
        RecordRef.GETTABLE(Rec);
        FieldRef := RecordRef.FIELD(Rec.FIELDNO("Dimension 1 Code") + pDimensionNo - 1);
        exit(FieldRef.VALUE());
    end;

    procedure SetDocumentCreated(pDocumentNo: Code[20]; pDocumentLineNo: Integer);
    begin
        Rec.VALIDATE("Document Created", true);
        Rec.VALIDATE("Document Creation Date", WORKDATE());
        Rec.VALIDATE("Document No.", pDocumentNo);
        Rec.VALIDATE("Document Line No.", pDocumentLineNo);
    end;

    procedure NavigateToDocument();
    begin
        Rec.TESTFIELD("Document Created", true);
        Rec.TESTFIELD("Document No.");
        case (Rec."Document Type") of
            Rec."Document Type"::Order:
                NavigateToNotPostedDocument(PAGE::"Sales Order");
            Rec."Document Type"::Invoice:
                NavigateToNotPostedDocument(PAGE::"Sales Invoice");
            Rec."Document Type"::"Return Order":
                NavigateToNotPostedDocument(PAGE::"Sales Return Order");
            Rec."Document Type"::"Credit Memo":
                NavigateToNotPostedDocument(PAGE::"Sales Credit Memo");
        end;
    end;

    procedure NavigateToCustomer();
    var
        Customer: Record Customer;
    begin
        Rec.TESTFIELD("Customer No.");
        Customer.GET(Rec."Customer No.");
        PAGE.RUN(PAGE::"Customer Card", Customer);
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
        case (Rec.Type) of
            Rec.Type::"G/L Account":
                begin
                    GLAccount.GET(Rec."No.");
                    PAGE.RUN(PAGE::"G/L Account Card", GLAccount);
                end;
            Rec.Type::Item:
                begin
                    Item.GET(Rec."No.");
                    PAGE.RUN(PAGE::"Item Card", Item);
                end;
            Rec.Type::"Fixed Asset":
                begin
                    FixedAsset.GET(Rec."No.");
                    PAGE.RUN(PAGE::"Fixed Asset Card", FixedAsset);
                end;
            Rec.Type::"Charge (Item)":
                begin
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
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        PAGE.RUN(pPageId, SalesHeader);
    end;

    procedure GetErrorStyle(): Text;
    begin
        Rec.CALCFIELDS("Error Detected");
        if (Rec."Error Detected") then
            exit('Unfavorable')
        else
            exit('Standard');
    end;
}
