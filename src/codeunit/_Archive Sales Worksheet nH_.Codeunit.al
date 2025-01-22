codeunit 80440 "Archive Sales Worksheet nH"
{
    TableNo = "Sales Worksheet Header nH";

    var SalesWorksheetHeader: Record "Sales Worksheet Header nH";
    SalesWorksheetLine: Record "Sales Worksheet Line nH";
    SalesWkshArchHeader: Record "Sales Wksh. Arch. Header nH";
    SalesWkshArchLine: Record "Sales Wksh. Arch. Line nH";
    Interaction: Boolean;
    TxtConfirmation: Label 'Do you want to archive sales worksheet ''%1''?';
    TxtUnprocessedConfirmation: Label 'Sales worksheet ''%1'' consists some unprocessed lines. Do you still want to archive it?';
    trigger OnRun();
    begin
        Archive(Rec, true);
    end;
    procedure Archive(var pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; pInteraction: Boolean): Boolean;
    var
        ConfirmationText: Text;
        Handled: Boolean;
    begin
        SalesWorksheetHeader:=pSalesWorksheetHeader;
        Interaction:=((pInteraction) and (GUIALLOWED()));
        if(Interaction)then begin
            SalesWorksheetHeader.CALCFIELDS("Unprocessed Lines Exist");
            if(SalesWorksheetHeader."Unprocessed Lines Exist")then ConfirmationText:=TxtUnprocessedConfirmation
            else
                ConfirmationText:=TxtConfirmation;
            if(not(CONFIRM(ConfirmationText, true, SalesWorksheetHeader."No.")))then exit(false);
        end;
        Handled:=false;
        OnBeforeArchive(SalesWorksheetHeader, Handled);
        if(not(Handled))then begin
            ArchiveHeader();
            ArchiveLines();
            SalesWorksheetHeader.DELETE(true);
            OnAfterArchive(SalesWorksheetHeader, SalesWkshArchHeader);
        end;
        exit(true);
    end;
    [BusinessEvent(false)]
    local procedure OnBeforeArchive(pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; var pHandled: Boolean);
    begin
    end;
    [BusinessEvent(false)]
    local procedure OnAfterArchive(pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; var pSalesWkshArchHeader: Record "Sales Wksh. Arch. Header nH");
    begin
    end;
    local procedure ArchiveHeader();
    begin
        CLEAR(SalesWkshArchHeader);
        SalesWkshArchHeader.TRANSFERFIELDS(SalesWorksheetHeader);
        SalesWkshArchHeader.INSERT(true);
        OnArchiveHeader(SalesWorksheetHeader, SalesWkshArchHeader);
    end;
    [BusinessEvent(false)]
    local procedure OnArchiveHeader(pSalesWorksheetHeader: Record "Sales Worksheet Header nH"; var pSalesWkshArchHeader: Record "Sales Wksh. Arch. Header nH");
    begin
    end;
    local procedure ArchiveLines();
    begin
        SalesWorksheetLine.RESET();
        SalesWorksheetLine.SETRANGE("Sales Worksheet No.", SalesWorksheetHeader."No.");
        if(SalesWorksheetLine.FINDSET(true))then repeat CLEAR(SalesWkshArchLine);
                SalesWkshArchLine.TRANSFERFIELDS(SalesWorksheetLine);
                SalesWkshArchLine.INSERT(true);
                OnArchiveLine(SalesWorksheetLine, SalesWkshArchLine);
            until(SalesWorksheetLine.NEXT() = 0);
    end;
    [BusinessEvent(false)]
    local procedure OnArchiveLine(pSalesWorksheetLine: Record "Sales Worksheet Line nH"; var pSalesWkshArchLine: Record "Sales Wksh. Arch. Line nH");
    begin
    end;
}
