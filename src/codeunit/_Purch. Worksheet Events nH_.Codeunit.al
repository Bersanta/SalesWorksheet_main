codeunit 80439 "Purch. Worksheet Events nH"
{
    var
        PurchaseWorksheetLine: Record "Purch. Worksheet Line nH";

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterDeleteEvent', '', true, true)]
    local procedure PurchaseHeader_OnAfterDeleteEvent(var Rec: Record "Purchase Header"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        if RunTrigger then ClearPurchaseWorksheetLines(Rec."Document Type".AsInteger(), Rec."No.", 0);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterRenameEvent', '', true, true)]
    local procedure PurchaseHeader_OnAfterRenameEvent(var Rec: Record "Purchase Header"; var xRec: Record "Purchase Header"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        AmendPurchaseWorksheetLines(xRec."Document Type".AsInteger(), xRec."No.", 0, Rec."Document Type".AsInteger(), Rec."No.", 0);
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterDeleteEvent', '', true, true)]
    local procedure PurchaseLine_OnAfterDeleteEvent(var Rec: Record "Purchase Line"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        ClearPurchaseWorksheetLines(Rec."Document Type".AsInteger(), Rec."Document No.", Rec."Line No.");
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterRenameEvent', '', true, true)]
    local procedure PurchaseLine_OnAfterRenameEvent(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        AmendPurchaseWorksheetLines(xRec."Document Type".AsInteger(), xRec."Document No.", xRec."Line No.", Rec."Document Type".AsInteger(), Rec."Document No.", Rec."Line No.");
    end;

    local procedure ClearPurchaseWorksheetLines(pDocumentType: Option; pDocumentNo: Code[20]; pDocumentLineNo: Integer);
    begin
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
        PurchaseWorksheetLine.SETRANGE("Document Type", pDocumentType);
        PurchaseWorksheetLine.SETRANGE("Document No.", pDocumentNo);
        if (pDocumentLineNo <> 0) then PurchaseWorksheetLine.SETRANGE("Document Line No.", pDocumentLineNo);
        if (PurchaseWorksheetLine.FINDSET()) then
            repeat
                PurchaseWorksheetLine.VALIDATE("Document Created", false);
                PurchaseWorksheetLine.VALIDATE("Document Creation Date", 0D);
                PurchaseWorksheetLine.VALIDATE("Document No.", '');
                PurchaseWorksheetLine.VALIDATE("Document Line No.", 0);
                PurchaseWorksheetLine.MODIFY(true);
            until (PurchaseWorksheetLine.NEXT() = 0);
    end;

    local procedure AmendPurchaseWorksheetLines(pFromDocumentType: Option; pFromDocumentNo: Code[20]; pFromDocumentLineNo: Integer; pToDocumentType: Option; pToDocumentNo: Code[20]; pToDocumentLineNo: Integer);
    begin
        if (pFromDocumentType <> pToDocumentType) then
            ClearPurchaseWorksheetLines(pFromDocumentType, pFromDocumentNo, pFromDocumentLineNo)
        else begin
            PurchaseWorksheetLine.RESET();
            PurchaseWorksheetLine.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
            PurchaseWorksheetLine.SETRANGE("Document Type", pFromDocumentType);
            PurchaseWorksheetLine.SETRANGE("Document No.", pFromDocumentNo);
            if (pFromDocumentLineNo <> 0) then PurchaseWorksheetLine.SETRANGE("Document Line No.", pFromDocumentLineNo);
            if (PurchaseWorksheetLine.FINDSET()) then
                repeat
                    PurchaseWorksheetLine.VALIDATE("Document No.", pToDocumentNo);
                    PurchaseWorksheetLine.VALIDATE("Document Line No.", pToDocumentLineNo);
                    PurchaseWorksheetLine.MODIFY(true);
                until (PurchaseWorksheetLine.NEXT() = 0);
        end;
    end;
}
