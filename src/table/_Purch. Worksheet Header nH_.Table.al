table 80439 "Purch. Worksheet Header nH"
{
    Caption = 'Purchase Worksheet Header';
    DataClassification = SystemMetadata;
    DrillDownPageID = "Purch. Worksheet List nH";
    LookupPageID = "Purch. Worksheet List nH";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = SystemMetadata;
        }
        field(10; Description; Text[30])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(20; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = SystemMetadata;
        }
        field(40; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
            DataClassification = SystemMetadata;
        }
        field(50; "Error Detected"; Boolean)
        {
            CalcFormula = Exist("Log nH" WHERE("Entry Type" = CONST(Error), "Record ID" = FIELD("Record ID")));
            Caption = 'Error Detected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Error Message"; Text[250])
        {
            CalcFormula = Lookup("Log nH".Message WHERE("Entry Type" = CONST(Error), "Record ID" = FIELD("Record ID")));
            Caption = 'Error Message';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Unprocessed Lines Exist"; Boolean)
        {
            CalcFormula = Exist("Purch. Worksheet Line nH" WHERE("Purchase Worksheet No." = FIELD("No."), "Document Created" = CONST(false)));
            Caption = 'Unprocessed Lines Exist';
            Editable = false;
            FieldClass = FlowField;
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
        key(Key1; "No.")
        {
        }
    }
    fieldgroups
    {
    }
    var
        SalesPurchWkshSetup: Record "Sales/Purch. Wksh. Setup nH";
        PurchaseWorksheetLine: Record "Purch. Worksheet Line nH";
        MessageLogManagement: Codeunit "Log Management nH";
        NoSeriesManagement: Codeunit "No. Series";
        RecordAuditManagement: Codeunit "Record Audit Management nH";
        SalesPurchWkshModule: Codeunit "Sales Purch.Wksh. Module nH";

    trigger OnDelete();
    begin
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", Rec."No.");
        PurchaseWorksheetLine.DELETEALL(true);
        MessageLogManagement.DeleteForRecord(Rec."Record ID");
    end;

    trigger OnInsert();
    begin
        SalesPurchWkshModule.CanCreateSalesPurchWksh(true);
        if (Rec."No." = '') then begin
            SalesPurchWkshSetup.VerifyAndGet();
            NoSeriesManagement.AreRelated(SalesPurchWkshSetup."Purchase Worksheet Nos.", xRec."No. Series");// to check
        end;
        Rec.VALIDATE("Record ID", Rec.RECORDID());
        RecordAuditManagement.SetCreated(Rec."Created By", Rec."Created Date Time");
    end;

    trigger OnModify();
    begin
        RecordAuditManagement.SetModified(Rec."Modified By", Rec."Modified Date Time");
    end;

    trigger OnRename();
    begin
        Rec.TESTFIELD("No.");
        Rec.VALIDATE("Record ID", Rec.RECORDID());
        RecordAuditManagement.SetModified(Rec."Modified By", Rec."Modified Date Time");
    end;

    procedure NoAssistEdit(): Boolean;
    var
        Result: Boolean;
    begin
        Result := false;
        SalesPurchWkshSetup.VerifyAndGet();
        if (NoSeriesManagement.LookupRelatedNoSeries(SalesPurchWkshSetup."Purchase Worksheet Nos.", xRec."No. Series", Rec."No. Series")) then begin
            NoSeriesManagement.GetNextNo(Rec."No.");
            Result := true;
        end;
        exit(Result);
    end;

    procedure Import();
    begin
        SalesPurchWkshSetup.VerifyAndGet();
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", Rec."No.");
        if SalesPurchWkshSetup."Purchase XMLport ID" > 0 then
            XMLPORT.RUN(SalesPurchWkshSetup."Purchase XMLport ID", false, true, PurchaseWorksheetLine)
        else
            XMLPORT.RUN(XMLPORT::"Import Purchase Worksheet nH", false, true, PurchaseWorksheetLine);
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
