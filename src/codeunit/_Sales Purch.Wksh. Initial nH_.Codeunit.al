// codeunit 80444 "Sales Purch.Wksh. Initial nH"
// {
//     Subtype = Install;

//     var SalesPurchWkshModule: Codeunit "Sales Purch.Wksh. Module nH";
//     ModuleInitialisation: Codeunit "Module Initialisation nH";
//     trigger OnInstallAppPerDatabase();
//     begin
//        // ModuleInitialisation.LoadInitialisationData(SalesPurchWkshModule.GetModuleCode(), false);
//     end;
//     trigger OnInstallAppPerCompany();
//     var
//         SalesPurchWkshSetup: record "Sales/Purch. Wksh. Setup nH";
//         MigrationPackageMgt: Codeunit "Migration Package Mgt. nH";
//     begin
//         SalesPurchWkshSetup.VerifyAndGet(); // Just to Initialize (Sales Worksheet Nos." and "Purchase Worksheet Nos.").
//         ModuleInitialisation.LoadInitialisationData(SalesPurchWkshModule.GetModuleCode(), false);
//         MigrationPackageMgt.UpdateMigrationPackagesForModule(SalesPurchWkshModule.GetModuleCode(), SalesPurchWkshModule.GetModuleName(), SalesPurchWkshModule.GetModuleSequence());
//     end;
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Module Initialisation nH", 'OnGetInitialisationTable', '', true, true)]
//     local procedure ModuleInitialisation_OnGetInitialisationTable(ModuleCode: Code[50]; var TableId: Integer; var FieldId: Integer; var Handled: Boolean)
//     var
//         SalesPurchWkshInitialisation: Record "Sales Purch.Wksh. Initial. nH";
//     begin
//         if((Handled) or (ModuleCode <> SalesPurchWkshModule.GetModuleCode()))then exit;
//         TableId:=Database::"Sales Purch.Wksh. Initial. nH";
//         FieldId:=SalesPurchWkshInitialisation.FieldNo("Package Data");
//         Handled:=true;
//     end;
//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', true, true)]
//     local procedure CompanyInitialize_OnCompanyInitialize();
//     begin
//     end;
// }
