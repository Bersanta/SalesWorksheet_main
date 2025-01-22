codeunit 80445 "Sales Purch.Wksh. Module nH"
{
    var GeneralModuleFunctions: Codeunit "General Module Functions nH";
    LicenseManagement: Codeunit "License Management nH";
    ModuleManagement: Codeunit "Module Management nH";
    TxtModuleName: Label 'nHanced Sales and Purchase Worksheets';
    SalesPurchWkshIcons: Codeunit "Sales Purch.Wksh. Icons nH";
    Icon: Codeunit "Temp Blob";
    procedure GetModuleCode(): Code[50];
    begin
        exit('NHANCED SALES AND PURCHASE WORKSHEETS');
    end;
    procedure GetModuleName(): Text begin
        exit(TxtModuleName);
    end;
    procedure GetModuleSequence(): Integer begin
        exit(20201);
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Module Management nH", 'OnRegisterModule', '', true, true)]
    local procedure ModuleManagement_OnRegisterModule(var Module: Record "Module nH"; var ModuleFunction: Record "Module Function nH")
    begin
        SalesPurchWkshIcons.GetNhancedSalesPurchWkshIcon(Icon);
        Module.AddAdv(GetModuleCode(), TxtModuleName, Icon);
        ModuleFunction.AddFunction(GetModuleCode(), GeneralModuleFunctions.UseFunctionCode(), GeneralModuleFunctions.UseFunctionName());
        ModuleFunction.AddFunction(GetModuleCode(), GeneralModuleFunctions.CreateFunctionCode(), GeneralModuleFunctions.CreateFunctionName());
    end;
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', true, true)] //BC23Upgrade Deprecated
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', true, true)] //BC23Upgrade
    local procedure AggregatedAssistedSetup_OnRegisterAssistedSetup()
    var
        TxtSetup: Label 'Setup %1';
        SalesPurchWkshSetup: Record "Sales/Purch. Wksh. Setup nH";
        ModInfo: ModuleInfo;
        GroupName: Enum "Assisted Setup Group";
    begin
        NavApp.GetCurrentModuleInfo(ModInfo);
        ModuleManagement.AddToAssistedSetup(ModInfo.Id, Page::"Sales/Purch. Wksh. Setup nH", StrSubstNo(TxtSetup, TxtModuleName), '', GroupName::Extensions, SalesPurchWkshSetup.IsCompleted());
    end;
    procedure CanUseSalesPurchWksh(WithError: Boolean): Boolean var
        InstanceFilter: Text;
    begin
        exit(LicenseManagement.CheckLicense(GetModuleCode(), GeneralModuleFunctions.UseFunctionCode(), '', InstanceFilter, WithError));
    end;
    procedure CanCreateSalesPurchWksh(WithError: Boolean): Boolean var
        InstanceFilter: Text;
    begin
        exit(LicenseManagement.CheckLicense(GetModuleCode(), GeneralModuleFunctions.CreateFunctionCode(), '', InstanceFilter, WithError));
    end;
}
