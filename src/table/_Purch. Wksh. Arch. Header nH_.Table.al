table 80437 "Purch. Wksh. Arch. Header nH"
{
    Caption = 'Purchase Worksheet Archive Header';
    DataClassification = SystemMetadata;
    DrillDownPageID = "Purch. Wksh. Arch. List nH";
    LookupPageID = "Purch. Wksh. Arch. List nH";

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
    var RecordAuditManagement: Codeunit "Record Audit Management nH";
}
