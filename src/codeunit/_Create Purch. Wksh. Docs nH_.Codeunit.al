codeunit 80438 "Create Purch. Wksh. Docs nH"
{
    TableNo = "Purch. Worksheet Header nH";

    var GeneralLedgerSetup: Record "General Ledger Setup";
    SalesPurchWkshSetup: Record "Sales/Purch. Wksh. Setup nH";
    PurchaseWorksheetHeader: Record "Purch. Worksheet Header nH";
    PurchaseWorksheetLine: Record "Purch. Worksheet Line nH";
    PurchaseHeader: Record "Purchase Header";
    PurchaseLine: Record "Purchase Line";
    DimensionManagement: Codeunit DimensionManagement;
    MessageLogManagement: Codeunit "Log Management nH";
    String: Codeunit "String Management nH";
    ValidationToolkit: Codeunit "Validation Toolkit nH";
    PurchaseLineNo: Integer;
    Interaction: Boolean;
    TxtDialogTitle: Label 'Creating documents...';
    TxtDialogProgress: Label 'Progress';
    TxtDialogDocumentsCreated: Label 'Documents created';
    DialogManagement: Codeunit "Dialog Management nH";
    DialogIndex: Option " ", Progress, DocumentsCreated;
    TxtDialogFinalMessage: Label 'Document creation has been completed';
    TxtNoLinesToProcess: Label 'There are no lines to process';
    TxtNoDimensionDefined: Label 'Dimension %1 hasn''t been defined and can''t be used.';
    TxtDimensionValueCantBeFound: Label 'Dimension ''%1'' value ''%2'' can''t be found.';
    TxtTotalAmountInconsist: Label 'Total Amount is Inconsistant. Purchase worksheet line value ''%1''. Calculated value ''%2''.';
    TxtTotalAmountInclVATInconsist: Label 'Total Amount Incl. VAT is Inconsistant. Purchase worksheet line value ''%1''. Calculated value ''%2''.';
    DoCreateSingleDocSplitBy: Boolean;
    ErrorMessage: array[2]of Text;
    fromPurchWkShLine: Record "Purch. Worksheet Line nH";
    IgnoreLoggedErrors: Boolean;
    trigger OnRun();
    begin
        if DoCreateSingleDocSplitBy then CreateSingleDocSplitBy(fromPurchWkShLine)
        else
            CreateDocuments(Rec, true);
    end;
    procedure CreateDocuments(var pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; pInteraction: Boolean);
    var
        PurchaseWorksheetLineToModify: Record "Purch. Worksheet Line nH";
        CreatePurchWkshDocuments: Codeunit "Create Purch. Wksh. Docs nH";
        LastSplitBy: Text;
        Result: Boolean;
        Handled: Boolean;
    begin
        PurchaseWorksheetHeader:=pPurchaseWorksheetHeader;
        InitialiseDialog(pInteraction);
        Result:=CheckWorksheet();
        if(Result)then begin
            Handled:=false;
            OnBeforeCreateDocuments(PurchaseWorksheetHeader, Interaction, Handled);
            if(not(Handled))then begin
                UpdateSplitBy();
                LastSplitBy:='';
                PurchaseWorksheetLine.RESET();
                PurchaseWorksheetLine.SETCURRENTKEY("Purchase Worksheet No.", "Document Created", "Split By");
                PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", PurchaseWorksheetHeader."No.");
                PurchaseWorksheetLine.SETRANGE("Document Created", false);
                OnBeforeCreateDocumentsFindset(PurchaseWorksheetLine);
                if(PurchaseWorksheetLine.FINDSET())then begin
                    DialogManagement.SetCount(DialogIndex::Progress, PurchaseWorksheetLine.COUNT());
                    repeat DialogManagement.Step(DialogIndex::Progress);
                        if SalesPurchWkshSetup."Purch. Wksh. Check Tollerance" then begin
                            if(PurchaseWorksheetLine."Split By" <> LastSplitBy)then begin
                                LastSplitBy:=PurchaseWorksheetLine."Split By";
                                CreatePurchWkshDocuments.SetCreateSingleDocSplitBy(PurchaseWorksheetLine);
                                if CreatePurchWkshDocuments.run(PurchaseWorksheetHeader)then DialogManagement.Step(DialogIndex::DocumentsCreated)
                                else
                                begin
                                    CreatePurchWkshDocuments.GetErrorMessages(ErrorMessage);
                                    if(ErrorMessage[1] <> '') OR (ErrorMessage[2] <> '')then begin
                                        CLEAR(ValidationToolkit);
                                        ValidationToolkit.SetCurrentRecord(PurchaseWorksheetLine);
                                        if ErrorMessage[1] <> '' then ValidationToolkit.AddError(ErrorMessage[1]);
                                        if ErrorMessage[2] <> '' then ValidationToolkit.AddError(ErrorMessage[2]);
                                        ValidationToolkit.Save();
                                        MessageLogManagement.CloneForRecord(PurchaseWorksheetLine."Record ID", PurchaseWorksheetHeader."Record ID");
                                    END;
                                END;
                                COMMIT(); // Commit (each "Split By" Document).
                            END;
                        end
                        else
                        begin
                            if(PurchaseWorksheetLine."Split By" <> LastSplitBy)then begin
                                CreateVendor();
                                CreatePurchaseHeader();
                                LastSplitBy:=PurchaseWorksheetLine."Split By";
                                DialogManagement.Step(DialogIndex::DocumentsCreated);
                            end;
                            CreatePurchaseLine();
                            PurchaseWorksheetLineToModify:=PurchaseWorksheetLine;
                            PurchaseWorksheetLineToModify.SetDocumentCreated(PurchaseHeader."No.", PurchaseLine."Line No.");
                            PurchaseWorksheetLineToModify.MODIFY(true);
                        end;
                    until(PurchaseWorksheetLine.NEXT() = 0);
                end;
                ArchiveWorksheet();
                OnAfterCreateDocuments(PurchaseWorksheetHeader, Interaction);
            end;
        end
        else
        begin
            Handled:=false;
            OnBeforeShowWorksheetErrors(PurchaseWorksheetHeader, pInteraction, Handled);
            if not Handled and Interaction then MessageLogManagement.ShowForRecord(PurchaseWorksheetHeader."Record ID", false);
        end;
        FinaliseDialog(Result);
        pPurchaseWorksheetHeader:=PurchaseWorksheetHeader;
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeCreateDocuments(var pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; pInteraction: Boolean; var pHandled: Boolean);
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnAfterCreateDocuments(var pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; pInteraction: Boolean);
    begin
    end;
    local procedure CheckWorksheet(): Boolean;
    begin
        MessageLogManagement.DeleteForRecord(PurchaseWorksheetHeader."Record ID");
        GeneralLedgerSetup.GET();
        SalesPurchWkshSetup.VerifyAndGet();
        CLEAR(ValidationToolkit);
        ValidationToolkit.SetCurrentRecord(PurchaseWorksheetHeader);
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETCURRENTKEY("Purchase Worksheet No.", "Document Created");
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", PurchaseWorksheetHeader."No.");
        PurchaseWorksheetLine.SETRANGE("Document Created", false);
        OnBeforeCheckWorksheetFindset(PurchaseWorksheetLine);
        if(PurchaseWorksheetLine.FINDSET())then repeat MessageLogManagement.DeleteForRecord(PurchaseWorksheetLine."Record ID");
                CLEAR(ValidationToolkit);
                ValidationToolkit.SetCurrentRecord(PurchaseWorksheetLine."Record ID");
                ValidationToolkit.TestIfFieldNotEmpty(PurchaseWorksheetLine.FIELDNO("Document Type"));
                ValidationToolkit.TestIfFieldNotEmpty(PurchaseWorksheetLine.FIELDNO("Document Date"));
                ValidationToolkit.TestIfFieldNotEmpty(PurchaseWorksheetLine.FIELDNO("Vendor No."));
                ValidationToolkit.TestIfFieldNotEmpty(PurchaseWorksheetLine.FIELDNO("Vendor Document No."));
                ValidationToolkit.TestIfFieldNotEmpty(PurchaseWorksheetLine.FIELDNO(Type));
                CheckWorksheetLineNo();
                CheckWorksheetLineRelations();
                CheckWorksheetLineDimensions();
                ValidationToolkit.Save();
                OnCheckWorksheetLine(PurchaseWorksheetLine);
                MessageLogManagement.CloneForRecord(PurchaseWorksheetLine."Record ID", PurchaseWorksheetHeader."Record ID");
            until(PurchaseWorksheetLine.NEXT() = 0)
        else
            MessageLogManagement.AddErrorForRecord(TxtNoLinesToProcess, PurchaseWorksheetHeader."Record ID");
        IgnoreLoggedErrors:=false;
        OnCheckWorksheet(PurchaseWorksheetHeader, IgnoreLoggedErrors);
        If IgnoreLoggedErrors then exit(true)
        else
            exit(not(MessageLogManagement.ErrorsExistForRecord(PurchaseWorksheetHeader."Record ID")))end;
    [BusinessEvent(false)]
    local procedure OnCheckWorksheet(pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; var pIgnoreLoggedErrors: Boolean);
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnCheckWorksheetLine(pPurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    local procedure CheckWorksheetLineNo();
    var
        Handled: Boolean;
    begin
        OnBeforeCheckWorksheetLineNo(PurchaseWorksheetLine, ValidationToolkit, Handled);
        if not Handled then if(PurchaseWorksheetLine.Type <> PurchaseWorksheetLine.Type::" ")then begin
                ValidationToolkit.TestIfFieldNotEmpty(PurchaseWorksheetLine.FIELDNO("No."));
                if(PurchaseWorksheetLine."No." <> '')then case(PurchaseWorksheetLine.Type)of PurchaseWorksheetLine.Type::"G/L Account": ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("No."), DATABASE::"G/L Account");
                    PurchaseWorksheetLine.Type::Item: begin
                        ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("No."), DATABASE::Item);
                        ValidationToolkit.Test2FieldsRelation(PurchaseWorksheetLine.FIELDNO("No."), PurchaseWorksheetLine.FIELDNO("Variant Code"), DATABASE::"Item Variant");
                    end;
                    PurchaseWorksheetLine.Type::"Fixed Asset": ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("No."), DATABASE::"Fixed Asset");
                    PurchaseWorksheetLine.Type::"Charge (Item)": ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("No."), DATABASE::"Item Charge");
                    end;
            end;
        OnAfterCheckWorksheetLineNo(PurchaseWorksheetLine, ValidationToolkit);
    end;
    local procedure CheckWorksheetLineRelations();
    begin
        if(not(SalesPurchWkshSetup."Purch. Wksh. Can Create Vendor"))then ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("Vendor No."), DATABASE::Vendor);
        ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("Location Code"), DATABASE::Location);
        ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("Currency Code"), DATABASE::Currency);
        ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("Shipment Method Code"), DATABASE::"Shipment Method");
        ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("VAT Bus. Posting Group"), DATABASE::"VAT Business Posting Group");
        ValidationToolkit.TestFieldRelation(PurchaseWorksheetLine.FIELDNO("VAT Prod. Posting Group"), DATABASE::"VAT Product Posting Group");
    end;
    local procedure CheckWorksheetLineDimensions();
    var
        DimensionValue: Record "Dimension Value";
        DimensionCodes: array[8]of Code[20];
        DimensionValueCodes: array[8]of Code[20];
        DimensionNo: Integer;
    begin
        DimensionCodes[1]:=GeneralLedgerSetup."Global Dimension 1 Code";
        DimensionCodes[2]:=GeneralLedgerSetup."Global Dimension 2 Code";
        DimensionCodes[3]:=GeneralLedgerSetup."Shortcut Dimension 3 Code";
        DimensionCodes[4]:=GeneralLedgerSetup."Shortcut Dimension 4 Code";
        DimensionCodes[5]:=GeneralLedgerSetup."Shortcut Dimension 5 Code";
        DimensionCodes[6]:=GeneralLedgerSetup."Shortcut Dimension 6 Code";
        DimensionCodes[7]:=GeneralLedgerSetup."Shortcut Dimension 7 Code";
        DimensionCodes[8]:=GeneralLedgerSetup."Shortcut Dimension 8 Code";
        DimensionValueCodes[1]:=PurchaseWorksheetLine."Dimension 1 Code";
        DimensionValueCodes[2]:=PurchaseWorksheetLine."Dimension 2 Code";
        DimensionValueCodes[3]:=PurchaseWorksheetLine."Dimension 3 Code";
        DimensionValueCodes[4]:=PurchaseWorksheetLine."Dimension 4 Code";
        DimensionValueCodes[5]:=PurchaseWorksheetLine."Dimension 5 Code";
        DimensionValueCodes[6]:=PurchaseWorksheetLine."Dimension 6 Code";
        DimensionValueCodes[7]:=PurchaseWorksheetLine."Dimension 7 Code";
        DimensionValueCodes[8]:=PurchaseWorksheetLine."Dimension 8 Code";
        for DimensionNo:=1 to 8 do if(DimensionCodes[DimensionNo] <> '')then begin
                if(DimensionValueCodes[DimensionNo] <> '')then if(not(DimensionValue.GET(DimensionCodes[DimensionNo], DimensionValueCodes[DimensionNo])))then ValidationToolkit.AddError(STRSUBSTNO(TxtDimensionValueCantBeFound, DimensionCodes[DimensionNo], DimensionValueCodes[DimensionNo]));
            end
            else if(DimensionValueCodes[DimensionNo] <> '')then ValidationToolkit.AddError(STRSUBSTNO(TxtNoDimensionDefined, DimensionNo));
    end;
    local procedure UpdateSplitBy();
    begin
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETCURRENTKEY("Purchase Worksheet No.", "Document Created");
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", PurchaseWorksheetHeader."No.");
        PurchaseWorksheetLine.SETRANGE("Document Created", false);
        OnBeforeUpdateSplitByFindset(PurchaseWorksheetLine);
        if(PurchaseWorksheetLine.FINDSET(true))then begin
            repeat if(PurchaseWorksheetLine."Split By" = '')then begin
                    PurchaseWorksheetLine.VALIDATE("Split By", STRSUBSTNO('%1-%2-%3', PurchaseWorksheetLine."Vendor No.", PurchaseWorksheetLine."Document Type", PurchaseWorksheetLine."Vendor Document No."));
                    PurchaseWorksheetLine.MODIFY(true);
                    OnUpdateSplitBy(PurchaseWorksheetLine);
                end;
            until(PurchaseWorksheetLine.NEXT() = 0);
            COMMIT(); // Apply Immediately before going ahead with document creation.
        end;
    end;
    [BusinessEvent(false)]
    local procedure OnUpdateSplitBy(var pPurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    procedure SetCreateSingleDocSplitBy(PurchaseWkShLine: Record "Purch. Worksheet Line nH")
    begin
        DoCreateSingleDocSplitBy:=true;
        fromPurchWkShLine:=PurchaseWkShLine end;
    procedure GetErrorMessages(var ErrorMessages: array[2]of Text)
    begin
        CopyArray(ErrorMessages, ErrorMessage, 1, 2);
    end;
    procedure CreateSingleDocSplitBy(PurchaseWkShLine: Record "Purch. Worksheet Line nH")
    var
        PurchaseWorksheetLineToModify: Record "Purch. Worksheet Line nH";
        LastSplitBy: Text;
    begin
        GeneralLedgerSetup.GET();
        SalesPurchWkshSetup.VerifyAndGet();
        CLEAR(ErrorMessage);
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETCURRENTKEY("Purchase Worksheet No.", "Document Created", "Split By");
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", PurchaseWkShLine."Purchase Worksheet No.");
        PurchaseWorksheetLine.SETRANGE("Document Created", false);
        PurchaseWorksheetLine.SETRANGE("Split By", PurchaseWkShLine."Split By");
        OnBeforeCreateSingleDocSplitByFindset(PurchaseWorksheetLine);
        if(PurchaseWorksheetLine.FINDSET())then begin
            repeat if(PurchaseWorksheetLine."Split By" <> LastSplitBy)then begin
                    CreateVendor();
                    CreatePurchaseHeader();
                    LastSplitBy:=PurchaseWorksheetLine."Split By";
                    DialogManagement.Step(DialogIndex::DocumentsCreated);
                end;
                CreatePurchaseLine();
                PurchaseWorksheetLineToModify:=PurchaseWorksheetLine;
                PurchaseWorksheetLineToModify.SetDocumentCreated(PurchaseHeader."No.", PurchaseLine."Line No.");
                PurchaseWorksheetLineToModify.MODIFY(true);
                OnCreateSingleDocSplitByLine(PurchaseWorksheetLine);
            until(PurchaseWorksheetLine.NEXT() = 0);
            PurchaseHeader.CalcFields(Amount, "Amount Including VAT");
            if(ABS(PurchaseHeader.Amount - PurchaseWkShLine."Total Amount") > SalesPurchWkshSetup."Purch. Tot.Amt. Tollerance")then ErrorMessage[1]:=STRSUBSTNO(TxtTotalAmountInconsist, PurchaseWkShLine."Total Amount", PurchaseHeader.Amount);
            if(ABS(PurchaseHeader."Amount Including VAT" - PurchaseWkShLine."Total Amount Incl. VAT") > SalesPurchWkshSetup."Purch. T.Amt.InclVAT Tolleranc")then ErrorMessage[2]:=STRSUBSTNO(TxtTotalAmountInclVATInconsist, PurchaseWkShLine."Total Amount Incl. VAT", PurchaseHeader."Amount Including VAT");
            if(ErrorMessage[1] <> '') OR (ErrorMessage[2] <> '')then Error(''); // "Silent" Rollback.
            OnCreateSingleDocSplitBy(PurchaseWorksheetHeader);
        end;
    end;
    [BusinessEvent(false)]
    local procedure OnCreateSingleDocSplitBy(var pPurchaseWorksheetHeader: record "Purch. Worksheet Header nH");
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnCreateSingleDocSplitByLine(var pPurchaseWorksheetLine: record "Purch. Worksheet Line nH");
    begin
    end;
    local procedure CreateVendor();
    var
        Vendor: Record Vendor;
    begin
        if(SalesPurchWkshSetup."Purch. Wksh. Can Create Vendor")then begin
            if(Vendor.GET(PurchaseWorksheetLine."Vendor No."))then exit;
            CLEAR(Vendor);
            Vendor.INIT();
            Vendor.VALIDATE("No.", PurchaseWorksheetLine."Vendor No.");
            Vendor.VALIDATE(Name, PurchaseWorksheetLine."Vendor Name");
            Vendor.INSERT(true);
            OnAfterCreateVendor(Vendor, PurchaseWorksheetLine);
        end
        else
            Vendor.GET(PurchaseWorksheetLine."Vendor No.");
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateVendor(var Vendor: Record Vendor; var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH")
    begin
    end;
    local procedure CreatePurchaseHeader();
    var
        DimensionNo: Integer;
        DimensionCode: Code[20];
        Handled: Boolean;
    begin
        Handled:=false;
        OnBeforeCreatePurchaseHeader(PurchaseWorksheetLine, PurchaseHeader, Handled);
        if(not(Handled))then begin
            CLEAR(PurchaseHeader);
            PurchaseHeader.SetHideValidationDialog(true);
            PurchaseHeader.INIT();
            PurchaseHeader.VALIDATE("Document Type", PurchaseWorksheetLine."Document Type");
            OnBeforeInsertPurchaseHeader(PurchaseHeader, PurchaseWorksheetLine);
            PurchaseHeader.INSERT(true);
            PurchaseHeader.VALIDATE("Buy-from Vendor No.", PurchaseWorksheetLine."Vendor No.");
            PurchaseHeader.VALIDATE("Order Date", PurchaseWorksheetLine."Order Date");
            PurchaseHeader.VALIDATE("Posting Date", PurchaseWorksheetLine."Posting Date");
            PurchaseHeader.VALIDATE("Expected Receipt Date", PurchaseWorksheetLine."Expected Receipt Date");
            PurchaseHeader.VALIDATE("Document Date", PurchaseWorksheetLine."Document Date");
            PurchaseHeader.VALIDATE("Vendor Order No.", PurchaseWorksheetLine."Vendor Document No.");
            if(PurchaseWorksheetLine."Currency Code" <> '')then if(PurchaseWorksheetLine."Currency Code" <> GeneralLedgerSetup."LCY Code")then PurchaseHeader.VALIDATE("Currency Code", PurchaseWorksheetLine."Currency Code");
            if(PurchaseWorksheetLine."Your Reference" <> '')then PurchaseHeader.VALIDATE("Your Reference", PurchaseWorksheetLine."Your Reference");
            if(PurchaseWorksheetLine."Posting Description" <> '')then PurchaseHeader.VALIDATE("Posting Description", PurchaseWorksheetLine."Posting Description");
            PurchaseHeader.VALIDATE("Shipment Method Code", PurchaseWorksheetLine."Shipment Method Code");
            case(PurchaseWorksheetLine."Document Type")of PurchaseWorksheetLine."Document Type"::Order: PurchaseHeader.VALIDATE("Vendor Order No.", PurchaseWorksheetLine."Vendor Document No.");
            PurchaseWorksheetLine."Document Type"::Invoice: PurchaseHeader.VALIDATE("Vendor Invoice No.", PurchaseWorksheetLine."Vendor Document No.");
            PurchaseWorksheetLine."Document Type"::"Credit Memo": PurchaseHeader.VALIDATE("Vendor Cr. Memo No.", PurchaseWorksheetLine."Vendor Document No.");
            end;
            PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", PurchaseWorksheetLine."Dimension 1 Code");
            PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code", PurchaseWorksheetLine."Dimension 2 Code");
            for DimensionNo:=1 to 8 do begin
                DimensionCode:=PurchaseWorksheetLine.GetDimensionCode(DimensionNo);
                DimensionManagement.ValidateShortcutDimValues(DimensionNo, DimensionCode, PurchaseHeader."Dimension Set ID");
            end;
            DimensionManagement.UpdateGlobalDimFromDimSetID(PurchaseHeader."Dimension Set ID", PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
            PurchaseHeader.MODIFY(true);
            OnAfterCreatePurchaseHeader(PurchaseHeader, PurchaseWorksheetLine);
            CLEAR(PurchaseLineNo);
        end
        else
            UpdatePurchaseLineNo();
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseHeader(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH"; var PurchaseHeader: Record "Purchase Header"; var Handled: Boolean);
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPurchaseHeader(var PurchaseHeader: Record "Purchase Header"; var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseHeader(var PurchaseHeader: Record "Purchase Header"; var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    local procedure CreatePurchaseLine();
    var
        Descriptions: array[2]of Text;
        DimensionNo: Integer;
        DimensionCode: Code[20];
        Handled: Boolean;
    begin
        Handled:=false;
        OnBeforeCreatePurchaseLine(PurchaseWorksheetLine, PurchaseHeader, PurchaseLine, Handled);
        if(not(Handled))then begin
            PurchaseLineNo+=10000;
            WorkOutPurchaseLineDescriptions(Descriptions);
            CLEAR(PurchaseLine);
            PurchaseLine.SuspendStatusCheck(true);
            PurchaseLine.INIT();
            PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.VALIDATE("Document No.", PurchaseHeader."No.");
            PurchaseLine.VALIDATE("Line No.", PurchaseLineNo);
            PurchaseLine.INSERT(true);
            PurchaseLine.VALIDATE(Type, PurchaseWorksheetLine.Type);
            PurchaseLine.VALIDATE("No.", PurchaseWorksheetLine."No.");
            If(PurchaseWorksheetLine."Variant Code" <> '')then PurchaseLine.Validate("Variant Code", PurchaseWorksheetLine."Variant Code");
            if((Descriptions[1] <> '') or (Descriptions[2] <> ''))then begin
                PurchaseLine.VALIDATE(Description, Descriptions[1]);
                PurchaseLine.VALIDATE("Description 2", Descriptions[2]);
            end;
            if(PurchaseWorksheetLine."Location Code" <> '')then PurchaseLine.VALIDATE("Location Code", PurchaseWorksheetLine."Location Code");
            PurchaseLine.VALIDATE(Quantity, PurchaseWorksheetLine.Quantity);
            if(PurchaseWorksheetLine."Unit Cost" <> 0)then PurchaseLine.VALIDATE("Direct Unit Cost", PurchaseWorksheetLine."Unit Cost");
            if(PurchaseWorksheetLine."VAT Bus. Posting Group" <> '')then PurchaseLine.VALIDATE("VAT Bus. Posting Group", PurchaseWorksheetLine."VAT Bus. Posting Group");
            if(PurchaseWorksheetLine."VAT Prod. Posting Group" <> '')then PurchaseLine.VALIDATE("VAT Prod. Posting Group", PurchaseWorksheetLine."VAT Prod. Posting Group");
            PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", PurchaseWorksheetLine."Dimension 1 Code");
            PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", PurchaseWorksheetLine."Dimension 2 Code");
            for DimensionNo:=1 to 8 do begin
                DimensionCode:=PurchaseWorksheetLine.GetDimensionCode(DimensionNo);
                DimensionManagement.ValidateShortcutDimValues(DimensionNo, DimensionCode, PurchaseLine."Dimension Set ID");
            end;
            DimensionManagement.UpdateGlobalDimFromDimSetID(PurchaseLine."Dimension Set ID", PurchaseLine."Shortcut Dimension 1 Code", PurchaseLine."Shortcut Dimension 2 Code");
            PurchaseLine.MODIFY(true);
            OnAfterCreatePurchaseLine(PurchaseLine, PurchaseWorksheetLine);
        end
        else
            UpdatePurchaseLineNo();
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseLine(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH"; var PurchaseHeader: Record "Purchase Header"; var PurchaseLine: Record "Purchase Line"; var Handled: Boolean);
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseLine(var PurchaseLine: Record "Purchase Line"; var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    local procedure UpdatePurchaseLineNo();
    var
        PurchaseLineLoc: Record "Purchase Line";
    begin
        PurchaseLineLoc.Reset();
        PurchaseLineLoc.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLineLoc.SetRange("Document No.", PurchaseHeader."No.");
        if(PurchaseLineLoc.FindLast())then PurchaseLineNo:=PurchaseLineLoc."Line No."
        else
            PurchaseLineNo:=0;
    end;
    local procedure WorkOutPurchaseLineDescriptions(var pDescriptions: array[2]of Text);
    var
        DescriptionsBufferTmp: Record "Name Value Buffer nH" temporary;
    begin
        CLEAR(pDescriptions);
        String.SplitPreservingWords(PurchaseWorksheetLine.Description, MAXSTRLEN(PurchaseLine.Description), DescriptionsBufferTmp);
        if(DescriptionsBufferTmp.FindSet())then pDescriptions[1]:=DescriptionsBufferTmp.Value;
        if(DescriptionsBufferTmp.Next() <> 0)then pDescriptions[2]:=DescriptionsBufferTmp.Value;
        OnWorkOutPurchaseLineDescriptions(PurchaseWorksheetLine, pDescriptions);
    end;
    [BusinessEvent(false)]
    local procedure OnWorkOutPurchaseLineDescriptions(pPurchaseWorksheetLine: Record "Purch. Worksheet Line nH"; var pDescriptions: array[2]of Text);
    begin
    end;
    local procedure ArchiveWorksheet();
    var
        ArchivePurchaseWorksheet: Codeunit "Archive Purch. Worksheet nH";
    begin
        if(not(SalesPurchWkshSetup."Auto-Archive Purchase Wkshts."))then exit;
        PurchaseWorksheetHeader.CALCFIELDS("Unprocessed Lines Exist");
        if(PurchaseWorksheetHeader."Unprocessed Lines Exist")then exit;
        ArchivePurchaseWorksheet.Archive(PurchaseWorksheetHeader, false);
    end;
    local procedure InitialiseDialog(pInteraction: Boolean);
    begin
        Interaction:=((pInteraction) and (GUIALLOWED()));
        if(not(Interaction))then exit;
        CLEAR(DialogManagement);
        DialogManagement.AddProgressControl(DialogIndex::Progress, TxtDialogProgress);
        DialogManagement.AddIntegerControl(DialogIndex::DocumentsCreated, TxtDialogDocumentsCreated);
        DialogManagement.Open(TxtDialogTitle);
    end;
    local procedure FinaliseDialog(pShowFinalMessage: Boolean);
    begin
        if(not(Interaction))then exit;
        DialogManagement.ClearValue(DialogIndex::Progress);
        DialogManagement.Close();
        if(pShowFinalMessage)then DialogManagement.ShowFinalMessage(TxtDialogFinalMessage);
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeCheckWorksheetLineNo(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH"; var ValidationToolkit: Codeunit "Validation Toolkit nH"; var Handled: Boolean);
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnAfterCheckWorksheetLineNo(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH"; var ValidationToolkit: Codeunit "Validation Toolkit nH");
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeShowWorksheetErrors(var PurchWorksheetHeader: Record "Purch. Worksheet Header nH"; Interaction: Boolean; var Handled: Boolean);
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeCreateDocumentsFindset(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeCreateSingleDocSplitByFindset(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeCheckWorksheetFindset(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeUpdateSplitByFindset(var PurchaseWorksheetLine: Record "Purch. Worksheet Line nH");
    begin
    end;
}
