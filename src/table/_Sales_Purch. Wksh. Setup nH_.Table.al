table 80446 "Sales/Purch. Wksh. Setup nH"
{
    Caption = 'Sales/Purchase Worksheet Setup';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(10; "Purchase Worksheet Nos."; Code[10])
        {
            Caption = 'Purchase Worksheet Nos.';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
        field(11; "Sales Worksheet Nos."; Code[10])
        {
            Caption = 'Sales Worksheet Nos.';
            DataClassification = SystemMetadata;
            TableRelation = "No. Series";
        }
        field(20; "Purch. Wksh. Can Create Vendor"; Boolean)
        {
            Caption = 'Purch. Wksh. Can Create Vendor';
            DataClassification = SystemMetadata;
        }
        field(21; "Sales Wksh. Can Create Cust."; Boolean)
        {
            Caption = 'Sales Wksh. Can Create Customer';
            DataClassification = SystemMetadata;
        }
        field(30; "Auto-Archive Purchase Wkshts."; Boolean)
        {
            Caption = 'Auto-Archive Purchase Worksheets';
            DataClassification = SystemMetadata;
        }
        field(31; "Auto-Archive Sales Wkshts."; Boolean)
        {
            Caption = 'Auto-Archive Sales Worksheets';
            DataClassification = SystemMetadata;
        }
        field(40; "Purchase XMLport ID"; Integer)
        {
            Caption = 'Purchase XMLport ID';
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type"=CONST(XMLport));
        }
        field(41; "Purchase XMLport Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type"=CONST(XMLport), "Object ID"=FIELD("Purchase XMLport ID")));
            Caption = 'Purchase XMLport Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Sales XMLport ID"; Integer)
        {
            Caption = 'Sales XMLport ID';
            DataClassification = SystemMetadata;
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type"=CONST(XMLport));
        }
        field(51; "Sales XMLport Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type"=CONST(XMLport), "Object ID"=FIELD("Sales XMLport ID")));
            Caption = 'Sales XMLport Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Purch. Wksh. Check Tollerance"; Boolean)
        {
            Caption = 'Purch. Wksh. Check Tollerance';
            DataClassification = SystemMetadata;
        }
        field(61; "Sales Wksh. Check Tollerance"; Boolean)
        {
            Caption = 'Sales Wksh. Check Tollerance';
            DataClassification = SystemMetadata;
        }
        field(70; "Purch. Tot.Amt. Tollerance"; Decimal)
        {
            Caption = 'Purch. Total Amount Tollerance';
            DataClassification = SystemMetadata;
        }
        field(71; "Sales Tot.Amt. Tollerance"; Decimal)
        {
            Caption = 'Sales Total Amount Tollerance';
            DataClassification = SystemMetadata;
        }
        field(80; "Purch. T.Amt.InclVAT Tolleranc"; Decimal)
        {
            Caption = 'Purch. Total Amount Incl. VAT Tollerance';
            DataClassification = SystemMetadata;
        }
        field(81; "Sales T.Amt.InclVAT Tolleranc"; Decimal)
        {
            Caption = 'Sales Total Amount Incl. VAT Tollerance';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }
    fieldgroups
    {
    }
    var NoSeriesToolkit: Codeunit "No. Series Toolkit nH";
    TxtPurchaseWorksheetNosCode: Label 'PURCH WKSH';
    TxtPurchaseWorksheetNosDescription: Label 'Purchase Worksheet';
    TxtPurchaseWorksheetNosStartingNo: Label 'PW000001';
    TxtSalesWorksheetNosCode: Label 'SALES WKSH';
    TxtSalesWorksheetNosDescription: Label 'Sales Worksheet';
    TxtSalesWorksheetNosStartingNo: Label 'SW000001';
    procedure VerifyAndGet();
    begin
        if(not(Rec.GET()))then begin
            Rec.INIT();
            Rec.INSERT(true);
        end;
        GetPurchaseWorksheetNos();
        GetSalesWorksheetNos();
    end;
    procedure GetPurchaseWorksheetNos(): Code[10];
    begin
        exit(GetNos(Rec.FIELDNO("Purchase Worksheet Nos."), TxtPurchaseWorksheetNosCode, TxtPurchaseWorksheetNosDescription, TxtPurchaseWorksheetNosStartingNo));
    end;
    procedure GetSalesWorksheetNos(): Code[10];
    begin
        exit(GetNos(Rec.FIELDNO("Sales Worksheet Nos."), TxtSalesWorksheetNosCode, TxtSalesWorksheetNosDescription, TxtSalesWorksheetNosStartingNo));
    end;
    local procedure GetNos(pFieldId: Integer; pCode: Code[10]; pDescription: Text; pStartingNo: Code[20]): Code[10];
    var
        RecVariant: Variant;
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        Modified: Boolean;
    begin
        Rec.GET();
        RecVariant:=Rec;
        Modified:=NoSeriesToolkit.GetNoSeriesAdv(RecVariant, pFieldId, pCode, pDescription, true, false, pStartingNo);
        Rec:=RecVariant;
        if(Modified)then Rec.MODIFY(true);
        RecordRef.GETTABLE(Rec);
        FieldRef:=RecordRef.FIELD(pFieldId);
        exit(FieldRef.VALUE());
    end;
    procedure IsCompleted(): Boolean var
        Result: Boolean;
    begin
        Result:=false;
        if(Rec.Get())then Result:=((Rec."Sales Worksheet Nos." <> '') AND (Rec."Purchase Worksheet Nos." <> ''));
        exit(Result);
    end;
}
