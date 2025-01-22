table 80441 "Sales Wksh. Arch. Header nH"
{
    Caption = 'Sales Worksheet Archive Header';
    DataClassification = SystemMetadata;
    DrillDownPageID = "Sales Wksh. Arch. List nH";
    LookupPageID = "Sales Wksh. Arch. List nH";

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
        field(60; "Unprocessed Lines Exist"; Boolean)
        {
            CalcFormula = Exist("Sales Worksheet Line nH" WHERE("Sales Worksheet No."=FIELD("No."), "Document Created"=CONST(false)));
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
    var RecordAuditManagement: codeunit "Record Audit Management nH";
}
