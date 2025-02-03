codeunit 80441 "Create Sales Wksh. Docs nH"
{
    TableNo = "Sales Worksheet Header nH";

    trigger OnRun();
    var
    begin
        if DoCreateSingleDocSplitBy then
            CreateSingleDocSplitBy(fromSalesWkShLine)
        else
            CreateDocuments(Rec, true);
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        SalesPurchWkshSetup: Record "Sales/Purch. Wksh. Setup nH";
        SalesWorksheetHeader: Record "Sales Worksheet Header nH";
        SalesWorksheetLine: Record "Sales Worksheet Line nH";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        DimensionManagement: Codeunit DimensionManagement;
        MessageLogManagement: Codeunit "Log Management nH";
        String: Codeunit "String Management nH";
        ValidationToolkit: Codeunit "Validation Toolkit nH";
        SalesLineNo: Integer;
        Interaction: Boolean;
        TxtDialogTitle: Label 'Creating documents...';
        TxtDialogProgress: Label 'Progress';
        TxtDialogDocumentsCreated: Label 'Documents created';
        DialogManagement: Codeunit "Dialog Management nH";
        DialogIndex: Option " ",Progress,DocumentsCreated;
        TxtDialogFinalMessage: Label 'Document creation has been completed';
        TxtNoLinesToProcess: Label 'There are no lines to process';
        TxtNoDimensionDefined: Label 'Dimension %1 hasn''t been defined and can''t be used.';
        TxtDimensionValueCantBeFound: Label 'Dimension ''%1'' value ''%2'' can''t be found.';
        TxtTotalAmountInconsist: Label 'Total Amount is Inconsistant. Sales worksheet line value ''%1''. Calculated value ''%2''.';
        TxtTotalAmountInclVATInconsist: Label 'Total Amount Incl. VAT is Inconsistant. Sales worksheet line value ''%1''. Calculated value ''%2''.';
        DoCreateSingleDocSplitBy: Boolean;
        ErrorMessage: array[2] of Text;
        fromSalesWkShLine: Record "Sales Worksheet Line nH";
        IgnoreLoggedErrors: Boolean;

    procedure CreateDocuments(var pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; pInteraction: Boolean);
    var
        SalesWorksheetLineToModify: Record "Sales Worksheet Line nH";
        CreateSalesWkshDocuments: Codeunit "Create Sales Wksh. Docs nH";
        LastSplitBy: Text;
        Result: Boolean;
        Handled: Boolean;
    begin
        SalesWorksheetHeader := pSalesWorksheetHeader;
        InitialiseDialog(pInteraction);
        Result := CheckWorksheet();
        if (Result) then begin
            Handled := false;
            OnBeforeCreateDocuments(SalesWorksheetHeader, Interaction, Handled);
            if (not (Handled)) then begin
                UpdateSplitBy();
                LastSplitBy := '';
                SalesWorksheetLine.RESET();
                SalesWorksheetLine.SETCURRENTKEY("Sales Worksheet No.", "Document Created", "Split By");
                SalesWorksheetLine.SETRANGE("Sales Worksheet No.", SalesWorksheetHeader."No.");
                SalesWorksheetLine.SETRANGE("Document Created", false);
                OnBeforeCreateDocumentsFindset(SalesWorksheetLine);
                if (SalesWorksheetLine.FINDSET()) then begin
                    DialogManagement.SetCount(DialogIndex::Progress, SalesWorksheetLine.COUNT());
                    repeat
                        DialogManagement.Step(DialogIndex::Progress);
                        if SalesPurchWkshSetup."Sales Wksh. Check Tollerance" then begin
                            if (SalesWorksheetLine."Split By" <> LastSplitBy) then begin
                                LastSplitBy := SalesWorksheetLine."Split By";
                                CreateSalesWkshDocuments.SetCreateSingleDocSplitBy(SalesWorksheetLine);
                                if CreateSalesWkshDocuments.run(SalesWorksheetHeader) then
                                    DialogManagement.Step(DialogIndex::DocumentsCreated)
                                else begin
                                    CreateSalesWkshDocuments.GetErrorMessages(ErrorMessage);
                                    if (ErrorMessage[1] <> '') OR (ErrorMessage[2] <> '') then begin
                                        CLEAR(ValidationToolkit);
                                        ValidationToolkit.SetCurrentRecord(SalesWorksheetLine."Record ID");
                                        if ErrorMessage[1] <> '' then ValidationToolkit.AddError(ErrorMessage[1]);
                                        if ErrorMessage[2] <> '' then ValidationToolkit.AddError(ErrorMessage[2]);
                                        ValidationToolkit.Save();
                                        MessageLogManagement.CloneForRecord(SalesWorksheetLine."Record ID", pSalesWorksheetHeader."Record ID");
                                    END;
                                END;
                                COMMIT(); // Commit (each "Split By" Document).
                            END;
                        end
                        else begin
                            if (SalesWorksheetLine."Split By" <> LastSplitBy) then begin
                                CreateCustomer();
                                CreateSalesHeader();
                                LastSplitBy := SalesWorksheetLine."Split By";
                                DialogManagement.Step(DialogIndex::DocumentsCreated);
                            end;
                            CreateSalesLine();
                            SalesWorksheetLineToModify := SalesWorksheetLine;
                            SalesWorksheetLineToModify.SetDocumentCreated(SalesHeader."No.", SalesLine."Line No.");
                            SalesWorksheetLineToModify.MODIFY(true);
                        end;
                    until (SalesWorksheetLine.NEXT() = 0);
                end;
                ArchiveWorksheet();
                OnAfterCreateDocuments(SalesWorksheetHeader, Interaction);
            end;
        end
        else begin
            Handled := false;
            OnBeforeShowWorksheetErrors(SalesWorksheetHeader, pInteraction, Handled);
            if not Handled and Interaction then MessageLogManagement.ShowForRecord(SalesWorksheetHeader."Record ID", false);
        end;
        FinaliseDialog(Result);
        pSalesWorksheetHeader := SalesWorksheetHeader;
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCreateDocuments(var pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; pInteraction: Boolean; var pHandled: Boolean);
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnAfterCreateDocuments(var pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; pInteraction: Boolean);
    begin
    end;

    local procedure CheckWorksheet(): Boolean;
    begin
        MessageLogManagement.DeleteForRecord(SalesWorksheetHeader."Record ID");
        GeneralLedgerSetup.GET();
        SalesPurchWkshSetup.VerifyAndGet();
        CLEAR(ValidationToolkit);
        ValidationToolkit.SetCurrentRecord(SalesWorksheetHeader);
        SalesWorksheetLine.RESET();
        SalesWorksheetLine.SETCURRENTKEY("Sales Worksheet No.", "Document Created");
        SalesWorksheetLine.SETRANGE("Sales Worksheet No.", SalesWorksheetHeader."No.");
        SalesWorksheetLine.SETRANGE("Document Created", false);
        OnBeforeCheckWorksheetFindset(SalesWorksheetLine);
        if (SalesWorksheetLine.FINDSET()) then
            repeat
                MessageLogManagement.DeleteForRecord(SalesWorksheetLine."Record ID");
                CLEAR(ValidationToolkit);
                ValidationToolkit.SetCurrentRecord(SalesWorksheetLine."Record ID");
                ValidationToolkit.TestIfFieldNotEmpty(SalesWorksheetLine.FIELDNO("Document Type"));
                ValidationToolkit.TestIfFieldNotEmpty(SalesWorksheetLine.FIELDNO("Customer No."));
                ValidationToolkit.TestIfFieldNotEmpty(SalesWorksheetLine.FIELDNO("Document Date"));
                ValidationToolkit.TestIfFieldNotEmpty(SalesWorksheetLine.FIELDNO("External Document No."));
                ValidationToolkit.TestIfFieldNotEmpty(SalesWorksheetLine.FIELDNO(Type));
                CheckWorksheetLineNo();
                CheckWorksheetLineRelations();
                CheckWorksheetLineDimensions();
                ValidationToolkit.Save();
                OnCheckWorksheetLine(SalesWorksheetLine);
                MessageLogManagement.CloneForRecord(SalesWorksheetLine."Record ID", SalesWorksheetHeader."Record ID");
            until (SalesWorksheetLine.NEXT() = 0)
        else
            MessageLogManagement.AddErrorForRecord(TxtNoLinesToProcess, SalesWorksheetHeader."Record ID");
        IgnoreLoggedErrors := false;
        OnCheckWorksheet(SalesWorksheetHeader, IgnoreLoggedErrors);
        If IgnoreLoggedErrors then
            exit(true)
        else
            exit(not (MessageLogManagement.ErrorsExistForRecord(SalesWorksheetHeader."Record ID")));
    end;

    [BusinessEvent(false)]
    local procedure OnCheckWorksheet(pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; var pIgnoreLoggedErrors: Boolean);
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnCheckWorksheetLine(pSalesWorksheetLine: Record "Sales Worksheet Line nH");
    begin
    end;

    local procedure CheckWorksheetLineNo();
    var
        Handled: Boolean;
    begin
        OnBeforeCheckWorksheetLineNo(SalesWorksheetLine, ValidationToolkit, Handled);
        if not Handled then
            if (SalesWorksheetLine.Type <> SalesWorksheetLine.Type::" ") then begin
                ValidationToolkit.TestIfFieldNotEmpty(SalesWorksheetLine.FIELDNO("No."));
                if (SalesWorksheetLine."No." <> '') then
                    case (SalesWorksheetLine.Type) of
                        SalesWorksheetLine.Type::"G/L Account":
                            ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("No."), DATABASE::"G/L Account");
                        SalesWorksheetLine.Type::Item:
                            begin
                                ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("No."), DATABASE::Item);
                                ValidationToolkit.Test2FieldsRelation(SalesWorksheetLine.FIELDNO("No."), SalesWorksheetLine.FIELDNO("Variant Code"), DATABASE::"Item Variant");
                            end;
                        SalesWorksheetLine.Type::"Fixed Asset":
                            ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("No."), DATABASE::"Fixed Asset");
                        SalesWorksheetLine.Type::"Charge (Item)":
                            ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("No."), DATABASE::"Item Charge");
                    end;
            end;
        OnAfterCheckWorksheetLineNo(SalesWorksheetLine, ValidationToolkit);
    end;

    local procedure CheckWorksheetLineRelations();
    begin
        if (not (SalesPurchWkshSetup."Sales Wksh. Can Create Cust.")) then ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("Customer No."), DATABASE::Customer);
        ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("Location Code"), DATABASE::Location);
        ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("Currency Code"), DATABASE::Currency);
        ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("Shipment Method Code"), DATABASE::"Shipment Method");
        ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("VAT Bus. Posting Group"), DATABASE::"VAT Business Posting Group");
        ValidationToolkit.TestFieldRelation(SalesWorksheetLine.FIELDNO("VAT Prod. Posting Group"), DATABASE::"VAT Product Posting Group");
    end;

    local procedure CheckWorksheetLineDimensions();
    var
        DimensionValue: Record "Dimension Value";
        DimensionCodes: array[8] of Code[20];
        DimensionValueCodes: array[8] of Code[20];
        DimensionNo: Integer;
    begin
        DimensionCodes[1] := GeneralLedgerSetup."Global Dimension 1 Code";
        DimensionCodes[2] := GeneralLedgerSetup."Global Dimension 2 Code";
        DimensionCodes[3] := GeneralLedgerSetup."Shortcut Dimension 3 Code";
        DimensionCodes[4] := GeneralLedgerSetup."Shortcut Dimension 4 Code";
        DimensionCodes[5] := GeneralLedgerSetup."Shortcut Dimension 5 Code";
        DimensionCodes[6] := GeneralLedgerSetup."Shortcut Dimension 6 Code";
        DimensionCodes[7] := GeneralLedgerSetup."Shortcut Dimension 7 Code";
        DimensionCodes[8] := GeneralLedgerSetup."Shortcut Dimension 8 Code";
        DimensionValueCodes[1] := SalesWorksheetLine."Dimension 1 Code";
        DimensionValueCodes[2] := SalesWorksheetLine."Dimension 2 Code";
        DimensionValueCodes[3] := SalesWorksheetLine."Dimension 3 Code";
        DimensionValueCodes[4] := SalesWorksheetLine."Dimension 4 Code";
        DimensionValueCodes[5] := SalesWorksheetLine."Dimension 5 Code";
        DimensionValueCodes[6] := SalesWorksheetLine."Dimension 6 Code";
        DimensionValueCodes[7] := SalesWorksheetLine."Dimension 7 Code";
        DimensionValueCodes[8] := SalesWorksheetLine."Dimension 8 Code";
        for DimensionNo := 1 to 8 do if (DimensionCodes[DimensionNo] <> '') then begin
                if (DimensionValueCodes[DimensionNo] <> '') then if (not (DimensionValue.GET(DimensionCodes[DimensionNo], DimensionValueCodes[DimensionNo]))) then ValidationToolkit.AddError(STRSUBSTNO(TxtDimensionValueCantBeFound, DimensionCodes[DimensionNo], DimensionValueCodes[DimensionNo]));
            end
            else if (DimensionValueCodes[DimensionNo] <> '') then ValidationToolkit.AddError(STRSUBSTNO(TxtNoDimensionDefined, DimensionNo));
    end;

    local procedure UpdateSplitBy();
    begin
        SalesWorksheetLine.RESET();
        SalesWorksheetLine.SETCURRENTKEY("Sales Worksheet No.", "Document Created");
        SalesWorksheetLine.SETRANGE("Sales Worksheet No.", SalesWorksheetHeader."No.");
        SalesWorksheetLine.SETRANGE("Document Created", false);
        OnBeforeUpdateSplitByFindset(SalesWorksheetLine);
        if (SalesWorksheetLine.FINDSET(true)) then begin
            repeat
                if (SalesWorksheetLine."Split By" = '') then begin
                    SalesWorksheetLine.VALIDATE("Split By", STRSUBSTNO('%1-%2-%3', SalesWorksheetLine."Customer No.", SalesWorksheetLine."Document Type", SalesWorksheetLine."External Document No."));
                    SalesWorksheetLine.MODIFY(true);
                    OnUpdateSplitBy(SalesWorksheetLine);
                end;
            until (SalesWorksheetLine.NEXT() = 0);
            COMMIT(); // Apply Immediately before going ahead with document creation.
        end;
    end;

    [BusinessEvent(false)]
    local procedure OnUpdateSplitBy(var pSalesWorksheetLine: Record "Sales Worksheet Line nH");
    begin
    end;

    procedure SetCreateSingleDocSplitBy(SalesWkShLine: Record "Sales Worksheet Line nH")
    begin
        DoCreateSingleDocSplitBy := true;
        fromSalesWkShLine := SalesWkShLine
    end;

    procedure GetErrorMessages(var ErrorMessages: array[2] of Text)
    begin
        CopyArray(ErrorMessages, ErrorMessage, 1, 2);
    end;

    procedure CreateSingleDocSplitBy(SalesWkShLine: Record "Sales Worksheet Line nH")
    var
        SalesWorksheetLineToModify: Record "Sales Worksheet Line nH";
        LastSplitBy: Text;
    begin
        GeneralLedgerSetup.GET();
        SalesPurchWkshSetup.VerifyAndGet();
        CLEAR(ErrorMessage);
        SalesWorksheetLine.RESET();
        SalesWorksheetLine.SETCURRENTKEY("Sales Worksheet No.", "Document Created", "Split By");
        SalesWorksheetLine.SETRANGE("Sales Worksheet No.", SalesWkShLine."Sales Worksheet No.");
        SalesWorksheetLine.SETRANGE("Document Created", false);
        SalesWorksheetLine.SETRANGE("Split By", SalesWkShLine."Split By");
        OnBeforeCreateSingleDocSplitByFindset(SalesWorksheetLine);
        if (SalesWorksheetLine.FINDSET()) then begin
            repeat
                if (SalesWorksheetLine."Split By" <> LastSplitBy) then begin
                    CreateCustomer();
                    CreateSalesHeader();
                    LastSplitBy := SalesWorksheetLine."Split By";
                    DialogManagement.Step(DialogIndex::DocumentsCreated);
                end;
                CreateSalesLine();
                SalesWorksheetLineToModify := SalesWorksheetLine;
                SalesWorksheetLineToModify.SetDocumentCreated(SalesHeader."No.", SalesLine."Line No.");
                SalesWorksheetLineToModify.MODIFY(true);
                OnCreateSingleDocSplitByLine(SalesWorksheetLine);
            until (SalesWorksheetLine.NEXT() = 0);
            SalesHeader.CalcFields(Amount, "Amount Including VAT");
            if (ABS(SalesHeader.Amount - SalesWkShLine."Total Amount") > SalesPurchWkshSetup."Sales Tot.Amt. Tollerance") then ErrorMessage[1] := STRSUBSTNO(TxtTotalAmountInconsist, SalesWkShLine."Total Amount", SalesHeader.Amount);
            if (ABS(SalesHeader."Amount Including VAT" - SalesWkShLine."Total Amount Incl. VAT") > SalesPurchWkshSetup."Sales T.Amt.InclVAT Tolleranc") then ErrorMessage[2] := STRSUBSTNO(TxtTotalAmountInclVATInconsist, SalesWkShLine."Total Amount Incl. VAT", SalesHeader."Amount Including VAT");
            if (ErrorMessage[1] <> '') OR (ErrorMessage[2] <> '') then Error(''); // "Silent" Rollback.
            OnCreateSingleDocSplitBy(SalesWorksheetHeader);
        end;
    end;

    [BusinessEvent(false)]
    local procedure OnCreateSingleDocSplitBy(var pSalesWorksheetHeader: record "Sales Worksheet Header nH");
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnCreateSingleDocSplitByLine(var pSalesWorksheetLine: record "Sales Worksheet Line nH");
    begin
    end;

    local procedure CreateCustomer();
    var
        Customer: Record Customer;
    begin
        if (SalesPurchWkshSetup."Sales Wksh. Can Create Cust.") then begin
            if (Customer.GET(SalesWorksheetLine."Customer No.")) then exit;
            CLEAR(Customer);
            Customer.INIT();
            Customer.VALIDATE("No.", SalesWorksheetLine."Customer No.");
            Customer.VALIDATE(Name, SalesWorksheetLine."Customer Name");
            Customer.INSERT(true);
            OnAfterCreateCustomer(Customer, SalesWorksheetLine);
        end
        else
            Customer.GET(SalesWorksheetLine."Customer No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateCustomer(var Customer: Record Customer; var SalesWorksheetLine: Record "Sales Worksheet Line nH")
    begin
    end;

    local procedure CreateSalesHeader();
    var
        DimensionNo: Integer;
        DimensionCode: Code[20];
        Handled: Boolean;
        Currency: Record Currency;
        GeneralLedgerSetup: record "General Ledger Setup";

    begin
        Handled := false;
        OnBeforeCreateSalesHeader(SalesWorksheetLine, SalesHeader, Handled);
        if (not (Handled)) then begin
            CLEAR(SalesHeader);
            SalesHeader.SetHideValidationDialog(true);
            SalesHeader.INIT();
            SalesHeader.VALIDATE("Document Type", SalesWorksheetLine."Document Type");
            OnBeforeInsertSalesHeader(SalesHeader, SalesWorksheetLine);
            SalesHeader.INSERT(true);
            SalesHeader.Validate("Order Type_rph", SalesWorksheetLine."Order Type".AsInteger());
            SalesHeader.VALIDATE("Sell-to Customer No.", SalesWorksheetLine."Customer No.");
            SalesHeader.VALIDATE("Order Date", SalesWorksheetLine."Order Date");
            SalesHeader.VALIDATE("Posting Date", SalesWorksheetLine."Posting Date");
            SalesHeader.VALIDATE("Document Date", SalesWorksheetLine."Document Date");
            SalesHeader.Validate("Promised Delivery Date", SalesWorksheetLine."Promised Delivery Date");
            SalesHeader.VALIDATE("External Document No.", SalesWorksheetLine."External Document No.");
            SalesHeader.Validate("Order Season Type_rph", SalesWorksheetLine."Order Season Type".AsInteger());
            SalesHeader.Validate("Order Season Code_rph", SalesWorksheetLine."Order Season Code");
            SalesHeader.Validate("Shipping Comments", SalesWorksheetLine."Delivery Information");
            SalesHeader.Validate("Shipping Agent Code", SalesWorksheetLine."Shipping Agent");
            SalesHeader.Validate("Shipping Agent Service Code", SalesWorksheetLine."Shipping Agent Service");
            SalesHeader.Validate("Ship-to Contact", SalesWorksheetLine."Ship-to Contact");
            SalesHeader.Validate("Ship-to Name", SalesWorksheetLine."Ship-to Name");
            SalesHeader.Validate("Ship-to Address", SalesWorksheetLine."Ship-to Address");
            SalesHeader.Validate("Ship-to Address 2", SalesWorksheetLine."Ship-to Address 2");
            SalesHeader.Validate("Ship-to City", SalesWorksheetLine."Ship-to City");
            SalesHeader.Validate("Ship-to Post Code", SalesWorksheetLine."Ship-to PostCode");
            SalesHeader.Validate("Ship-to Country/Region Code", SalesWorksheetLine."Ship-to Country");
            SalesHeader.Validate("Ship-to County", SalesWorksheetLine."Ship-to County");
            SalesHeader.Validate("Ship-to Phone No.", SalesWorksheetLine."Ship-to Phone No.");
            SalesHeader.Validate("Ship-to E-Mail TNP", SalesWorksheetLine."Ship-to E-mail");
            SalesHeader.Validate("Salesperson Code", SalesWorksheetLine."Salesperson Code");

            if GeneralLedgerSetup.Get then
                if SalesWorksheetLine."Currency Code" = GeneralLedgerSetup."LCY Code" then
                    SalesHeader.Validate("Currency Code", '')
                else
                    SalesHeader.Validate("Currency Code", SalesWorksheetLine."Currency Code");

            if (SalesWorksheetLine."Posting Description" <> '') then SalesHeader.VALIDATE("Posting Description", SalesWorksheetLine."Posting Description");
            SalesHeader.VALIDATE("Shipment Method Code", SalesWorksheetLine."Shipment Method Code");
            SalesHeader.VALIDATE("Shortcut Dimension 1 Code", SalesWorksheetLine."Dimension 1 Code");
            SalesHeader.VALIDATE("Shortcut Dimension 2 Code", SalesWorksheetLine."Dimension 2 Code");
            for DimensionNo := 1 to 8 do begin
                DimensionCode := SalesWorksheetLine.GetDimensionCode(DimensionNo);
                DimensionManagement.ValidateShortcutDimValues(DimensionNo, DimensionCode, SalesHeader."Dimension Set ID");
            end;
            DimensionManagement.UpdateGlobalDimFromDimSetID(SalesHeader."Dimension Set ID", SalesHeader."Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 2 Code");
            SalesHeader.MODIFY(true);
            OnAfterCreateSalesHeader(SalesHeader, SalesWorksheetLine);
            CLEAR(SalesLineNo);
        end
        else
            UpdateSalesLineNo();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesHeader(var SalesWorksheetLine: Record "Sales Worksheet Line nH"; var SalesHeader: Record "Sales Header"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertSalesHeader(var SalesHeader: Record "Sales Header"; var SalesWorksheetLine: Record "Sales Worksheet Line nH")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesHeader(var SalesHeader: Record "Sales Header"; var SalesWorksheetLine: Record "Sales Worksheet Line nH")
    begin
    end;

    local procedure CreateSalesLine();
    var
        Descriptions: array[2] of Text;
        DimensionNo: Integer;
        DimensionCode: Code[20];
        Handled: Boolean;
    begin
        Handled := false;
        OnBeforeCreateSalesLine(SalesWorksheetLine, SalesHeader, SalesLine, Handled);
        if (not (Handled)) then begin
            SalesLineNo += 10000;
            WorkOutSalesLineDescriptions(Descriptions);
            CLEAR(SalesLine);
            SalesLine.SuspendStatusCheck(true);
            SalesLine.INIT();
            SalesLine.VALIDATE("Document Type", SalesHeader."Document Type");
            SalesLine.VALIDATE("Document No.", SalesHeader."No.");
            SalesLine.VALIDATE("Line No.", SalesLineNo);
            SalesLine.INSERT(true);
            SalesLine.VALIDATE(Type, SalesWorksheetLine.Type);
            SalesLine.VALIDATE("No.", SalesWorksheetLine."No.");
            If (SalesWorksheetLine."Variant Code" <> '') then SalesLine.Validate("Variant Code", SalesWorksheetLine."Variant Code");
            if ((Descriptions[1] <> '') or (Descriptions[2] <> '')) then begin
                SalesLine.VALIDATE(Description, Descriptions[1]);
                SalesLine.VALIDATE("Description 2", Descriptions[2]);
            end;
            if (SalesWorksheetLine."Location Code" <> '') then SalesLine.VALIDATE("Location Code", SalesWorksheetLine."Location Code");
            SalesLine.VALIDATE(Quantity, SalesWorksheetLine.Quantity);
            if (SalesWorksheetLine."Unit Price" <> 0) then SalesLine.VALIDATE("Unit Price", SalesWorksheetLine."Unit Price");
            if (SalesWorksheetLine."Line Discount" <> 0) then SalesLine.Validate("Line Discount %", SalesWorksheetLine."Line Discount");
            if (SalesWorksheetLine."VAT Bus. Posting Group" <> '') then SalesLine.VALIDATE("VAT Bus. Posting Group", SalesWorksheetLine."VAT Bus. Posting Group");
            if (SalesWorksheetLine."VAT Prod. Posting Group" <> '') then SalesLine.VALIDATE("VAT Prod. Posting Group", SalesWorksheetLine."VAT Prod. Posting Group");
            SalesLine.VALIDATE("Shortcut Dimension 1 Code", SalesWorksheetLine."Dimension 1 Code");
            SalesLine.VALIDATE("Shortcut Dimension 2 Code", SalesWorksheetLine."Dimension 2 Code");
            for DimensionNo := 1 to 8 do begin
                DimensionCode := SalesWorksheetLine.GetDimensionCode(DimensionNo);
                DimensionManagement.ValidateShortcutDimValues(DimensionNo, DimensionCode, SalesLine."Dimension Set ID");
            end;
            DimensionManagement.UpdateGlobalDimFromDimSetID(SalesLine."Dimension Set ID", SalesLine."Shortcut Dimension 1 Code", SalesLine."Shortcut Dimension 2 Code");
            SalesLine.MODIFY(true);
            OnAfterCreateSalesLine(SalesLine, SalesWorksheetLine);
        end
        else
            UpdateSalesLineNo();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesLine(var SalesWorksheetLine: Record "Sales Worksheet Line nH"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var Handled: Boolean);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesLine(var SalesLine: Record "Sales Line"; var SalesWorksheetLine: Record "Sales Worksheet Line nH")
    begin
    end;

    local procedure UpdateSalesLineNo();
    var
        SalesLineLoc: Record "Sales Line";
    begin
        SalesLineLoc.Reset();
        SalesLineLoc.SetRange("Document Type", SalesHeader."Document Type");
        SalesLineLoc.SetRange("Document No.", SalesHeader."No.");
        if (SalesLineLoc.FindLast()) then
            SalesLineNo := SalesLineLoc."Line No."
        else
            SalesLineNo := 0;
    end;

    local procedure WorkOutSalesLineDescriptions(var pDescriptions: array[2] of Text);
    var
        DescriptionsBufferTmp: Record "Name Value Buffer nH" temporary;
    begin
        CLEAR(pDescriptions);
        String.SplitPreservingWords(SalesWorksheetLine.Description, MAXSTRLEN(SalesLine.Description), DescriptionsBufferTmp);
        if (DescriptionsBufferTmp.FindSet()) then pDescriptions[1] := DescriptionsBufferTmp.Value;
        if (DescriptionsBufferTmp.Next() <> 0) then pDescriptions[2] := DescriptionsBufferTmp.Value;
        OnWorkOutSalesLineDescriptions(SalesWorksheetLine, pDescriptions);
    end;

    [BusinessEvent(false)]
    local procedure OnWorkOutSalesLineDescriptions(pSalesWorksheetLine: Record "Sales Worksheet Line nH"; var pDescriptions: array[2] of Text);
    begin
    end;

    local procedure ArchiveWorksheet();
    var
        ArchiveSalesWorksheet: Codeunit "Archive Sales Worksheet nH";
    begin
        if (not (SalesPurchWkshSetup."Auto-Archive Sales Wkshts.")) then exit;
        SalesWorksheetHeader.CALCFIELDS("Unprocessed Lines Exist");
        if (SalesWorksheetHeader."Unprocessed Lines Exist") then exit;
        ArchiveSalesWorksheet.Archive(SalesWorksheetHeader, false);
    end;

    local procedure InitialiseDialog(pInteraction: Boolean);
    begin
        Interaction := ((pInteraction) and (GUIALLOWED()));
        if (not (Interaction)) then exit;
        CLEAR(DialogManagement);
        DialogManagement.AddProgressControl(DialogIndex::Progress, TxtDialogProgress);
        DialogManagement.AddIntegerControl(DialogIndex::DocumentsCreated, TxtDialogDocumentsCreated);
        DialogManagement.Open(TxtDialogTitle);
    end;

    local procedure FinaliseDialog(pShowFinalMessage: Boolean);
    begin
        if (not (Interaction)) then exit;
        DialogManagement.ClearValue(DialogIndex::Progress);
        DialogManagement.Close();
        if (pShowFinalMessage) then DialogManagement.ShowFinalMessage(TxtDialogFinalMessage);
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCheckWorksheetLineNo(var SalesWorksheetLine: Record "Sales Worksheet Line nH"; var ValidationToolkit: Codeunit "Validation Toolkit nH"; var Handled: Boolean);
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnAfterCheckWorksheetLineNo(var SalesWorksheetLine: Record "Sales Worksheet Line nH"; var ValidationToolkit: Codeunit "Validation Toolkit nH");
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeShowWorksheetErrors(var SalesWorksheetHeader: Record "Sales Worksheet Header nH"; Interaction: Boolean; var Handled: Boolean);
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCreateDocumentsFindset(var SalesWorksheetLine: Record "Sales Worksheet Line nH");
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCreateSingleDocSplitByFindset(var SalesWorksheetLine: Record "Sales Worksheet Line nH");
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeCheckWorksheetFindset(var SalesWorksheetLine: Record "Sales Worksheet Line nH");
    begin
    end;

    [BusinessEvent(false)]
    local procedure OnBeforeUpdateSplitByFindset(var SalesWorksheetLine: Record "Sales Worksheet Line nH");
    begin
    end;
}
