codeunit 80437 "Archive Purch. Worksheet nH"
{
    TableNo = "Purch. Worksheet Header nH";

    var PurchaseWorksheetHeader: Record "Purch. Worksheet Header nH";
    PurchaseWorksheetLine: Record "Purch. Worksheet Line nH";
    PurchaseWkshArchHeader: Record "Purch. Wksh. Arch. Header nH";
    PurchaseWkshArchLine: Record "Purch. Wksh. Arch. Line nH";
    Interaction: Boolean;
    TxtConfirmation: Label 'Do you want to archive purchase worksheet ''%1''?';
    TxtUnprocessedConfirmation: Label 'Purchase worksheet ''%1'' consists some unprocessed lines. Do you still want to archive it?';
    trigger OnRun();
    begin
        Archive(Rec, true);
    end;
    procedure Archive(pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; pInteraction: Boolean): Boolean;
    var
        ConfirmationText: Text;
        Handled: Boolean;
    begin
        PurchaseWorksheetHeader:=pPurchaseWorksheetHeader;
        Interaction:=((pInteraction) and (GUIALLOWED()));
        if(Interaction)then begin
            PurchaseWorksheetHeader.CALCFIELDS("Unprocessed Lines Exist");
            if(PurchaseWorksheetHeader."Unprocessed Lines Exist")then ConfirmationText:=TxtUnprocessedConfirmation
            else
                ConfirmationText:=TxtConfirmation;
            if(not(CONFIRM(ConfirmationText, true, PurchaseWorksheetHeader."No.")))then exit(false);
        end;
        Handled:=false;
        OnBeforeArchive(PurchaseWorksheetHeader, Handled);
        if(not(Handled))then begin
            ArchiveHeader();
            ArchiveLines();
            PurchaseWorksheetHeader.DELETE(true);
            OnAfterArchive(PurchaseWorksheetHeader, PurchaseWkshArchHeader);
        end;
        exit(true);
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeArchive(pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; var pHandled: Boolean);
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnAfterArchive(pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; var pPurchaseWkshArchHeader: Record "Purch. Wksh. Arch. Header nH");
    begin
    end;
    local procedure ArchiveHeader();
    begin
        CLEAR(PurchaseWkshArchHeader);
        PurchaseWkshArchHeader.TRANSFERFIELDS(PurchaseWorksheetHeader);
        PurchaseWkshArchHeader.INSERT(true);
        OnArchiveHeader(PurchaseWorksheetHeader, PurchaseWkshArchHeader);
    end;
    [BusinessEvent(false)]
    local procedure OnArchiveHeader(pPurchaseWorksheetHeader: Record "Purch. Worksheet Header nH"; var pPurchaseWkshArchHeader: Record "Purch. Wksh. Arch. Header nH");
    begin
    end;
    local procedure ArchiveLines();
    begin
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", PurchaseWorksheetHeader."No.");
        if(PurchaseWorksheetLine.FINDSET(true))then repeat CLEAR(PurchaseWkshArchLine);
                PurchaseWkshArchLine.TRANSFERFIELDS(PurchaseWorksheetLine);
                PurchaseWkshArchLine.INSERT(true);
                OnArchiveLine(PurchaseWorksheetLine, PurchaseWkshArchLine);
            until(PurchaseWorksheetLine.NEXT() = 0);
    end;
    [BusinessEvent(false)]
    local procedure OnArchiveLine(pPurchaseWorksheetLine: Record "Purch. Worksheet Line nH"; var pPurchaseWkshArchLine: Record "Purch. Wksh. Arch. Line nH");
    begin
    end;
}
