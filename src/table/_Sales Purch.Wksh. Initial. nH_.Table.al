table 80445 "Sales Purch.Wksh. Initial. nH"
{
    Caption = 'Sales and Purchase Worksheet Initialization';
    DataPerCompany = false;
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; "Package Data"; BLOB)
        {
            Caption = 'Package Data';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(PrimaryKey; "Entry No.")
        {
            Clustered = true;
        }
    }
}
