codeunit 80442 "Sales Worksheet Events nH"
{
    var
        SalesWorksheetLine: Record "Sales Worksheet Line nH";

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterDeleteEvent', '', true, true)]
    local procedure SalesHeader_OnAfterDeleteEvent(var Rec: Record "Sales Header"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        if RunTrigger then ClearSalesWorksheetLines(Rec."Document Type".AsInteger(), Rec."No.", 0);
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterRenameEvent', '', true, true)]
    local procedure SalesHeader_OnAfterRenameEvent(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        AmendSalesWorksheetLines(xRec."Document Type".AsInteger(), xRec."No.", 0, Rec."Document Type".AsInteger(), Rec."No.", 0);
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterDeleteEvent', '', true, true)]
    local procedure SalesLine_OnAfterDeleteEvent(var Rec: Record "Sales Line"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        if RunTrigger then ClearSalesWorksheetLines(Rec."Document Type".AsInteger(), Rec."Document No.", Rec."Line No.");
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterRenameEvent', '', true, true)]
    local procedure SalesLine_OnAfterRenameEvent(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; RunTrigger: Boolean);
    begin
        if (Rec.ISTEMPORARY()) then exit;
        AmendSalesWorksheetLines(xRec."Document Type".AsInteger(), xRec."Document No.", xRec."Line No.", Rec."Document Type".AsInteger(), Rec."Document No.", Rec."Line No.");
    end;

    local procedure ClearSalesWorksheetLines(pDocumentType: Option; pDocumentNo: Code[20]; pDocumentLineNo: Integer);
    begin
        SalesWorksheetLine.RESET();
        SalesWorksheetLine.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
        SalesWorksheetLine.SETRANGE("Document Type", pDocumentType);
        SalesWorksheetLine.SETRANGE("Document No.", pDocumentNo);
        if (pDocumentLineNo <> 0) then SalesWorksheetLine.SETRANGE("Document Line No.", pDocumentLineNo);
        if (SalesWorksheetLine.FINDSET()) then
            repeat
                SalesWorksheetLine.VALIDATE("Document Created", false);
                SalesWorksheetLine.VALIDATE("Document Creation Date", 0D);
                SalesWorksheetLine.VALIDATE("Document No.", '');
                SalesWorksheetLine.VALIDATE("Document Line No.", 0);
                SalesWorksheetLine.MODIFY(true);
            until (SalesWorksheetLine.NEXT() = 0);
    end;

    local procedure AmendSalesWorksheetLines(pFromDocumentType: Option; pFromDocumentNo: Code[20]; pFromDocumentLineNo: Integer; pToDocumentType: Option; pToDocumentNo: Code[20]; pToDocumentLineNo: Integer);
    begin
        if (pFromDocumentType <> pToDocumentType) then
            ClearSalesWorksheetLines(pFromDocumentType, pFromDocumentNo, pFromDocumentLineNo)
        else begin
            SalesWorksheetLine.RESET();
            SalesWorksheetLine.SETCURRENTKEY("Document Type", "Document No.", "Document Line No.");
            SalesWorksheetLine.SETRANGE("Document Type", pFromDocumentType);
            SalesWorksheetLine.SETRANGE("Document No.", pFromDocumentNo);
            if (pFromDocumentLineNo <> 0) then SalesWorksheetLine.SETRANGE("Document Line No.", pFromDocumentLineNo);
            if (SalesWorksheetLine.FINDSET()) then
                repeat
                    SalesWorksheetLine.VALIDATE("Document No.", pToDocumentNo);
                    SalesWorksheetLine.VALIDATE("Document Line No.", pToDocumentLineNo);
                    SalesWorksheetLine.MODIFY(true);
                until (SalesWorksheetLine.NEXT() = 0);
        end;
    end;
}
