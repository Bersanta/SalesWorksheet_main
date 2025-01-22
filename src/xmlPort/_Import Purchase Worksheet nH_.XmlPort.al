xmlport 80437 "Import Purchase Worksheet nH"
{
    Caption = 'Import Purchase Worksheet';
    Direction = Import;
    FileName = 'Purchase Worksheet Lines.xml';
    Format = VariableText;

    schema
    {
    textelement(dpurchaseworksheetlines)
    {
    XmlName = 'PurchaseWorksheetLines';

    tableelement(dpurchaseworksheetline;
    "Purch. Worksheet Line nH")
    {
    AutoUpdate = true;
    RequestFilterFields = "Purchase Worksheet No.", "Line No.";
    XmlName = 'PurchaseWorksheetLine';

    fieldattribute(DocumentType;
    dPurchaseWorksheetLine."Document Type")
    {
    FieldValidate = yes;
    }
    fieldattribute(VendorNo;
    dPurchaseWorksheetLine."Vendor No.")
    {
    FieldValidate = yes;
    }
    fieldattribute(VendorName;
    dPurchaseWorksheetLine."Vendor Name")
    {
    FieldValidate = yes;
    }
    fieldattribute(OrderDate;
    dPurchaseWorksheetLine."Order Date")
    {
    FieldValidate = yes;
    }
    fieldattribute(PostingDate;
    dPurchaseWorksheetLine."Posting Date")
    {
    FieldValidate = yes;
    }
    fieldattribute(DocumentDate;
    dPurchaseWorksheetLine."Document Date")
    {
    FieldValidate = yes;
    }
    fieldattribute(ExpectedReceiptDate;
    dPurchaseWorksheetLine."Expected Receipt Date")
    {
    FieldValidate = yes;
    }
    fieldattribute(VendorDocumentNo;
    dPurchaseWorksheetLine."Vendor Document No.")
    {
    FieldValidate = yes;
    }
    fieldattribute(CurrencyCode;
    dPurchaseWorksheetLine."Currency Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(PostingDescription;
    dPurchaseWorksheetLine."Posting Description")
    {
    FieldValidate = yes;
    }
    fieldattribute(ShipmentMethodCode;
    dPurchaseWorksheetLine."Shipment Method Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Type;
    dPurchaseWorksheetLine.Type)
    {
    FieldValidate = yes;
    }
    fieldattribute(No;
    dPurchaseWorksheetLine."No.")
    {
    FieldValidate = yes;
    }
    fieldattribute(VariantCode;
    dPurchaseWorksheetLine."Variant Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Quantity;
    dPurchaseWorksheetLine.Quantity)
    {
    FieldValidate = yes;
    }
    fieldattribute(Description;
    dPurchaseWorksheetLine.Description)
    {
    FieldValidate = yes;
    }
    fieldattribute(LocationCode;
    dPurchaseWorksheetLine."Location Code")
    {
    }
    fieldattribute(UnitCost;
    dPurchaseWorksheetLine."Unit Cost")
    {
    FieldValidate = yes;
    }
    fieldattribute(SplitBy;
    dPurchaseWorksheetLine."Split By")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension1Code;
    dPurchaseWorksheetLine."Dimension 1 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension2Code;
    dPurchaseWorksheetLine."Dimension 2 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension3Code;
    dPurchaseWorksheetLine."Dimension 3 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension4Code;
    dPurchaseWorksheetLine."Dimension 4 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension5Code;
    dPurchaseWorksheetLine."Dimension 5 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension6Code;
    dPurchaseWorksheetLine."Dimension 6 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension7Code;
    dPurchaseWorksheetLine."Dimension 7 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(Dimension8Code;
    dPurchaseWorksheetLine."Dimension 8 Code")
    {
    FieldValidate = yes;
    }
    fieldattribute(YourReference;
    dPurchaseWorksheetLine."Your Reference")
    {
    FieldValidate = yes;
    }
    fieldattribute(TotalAmount;
    dPurchaseWorksheetLine."Total Amount")
    {
    FieldValidate = yes;
    }
    fieldattribute(TotalAmountInclVAT;
    dPurchaseWorksheetLine."Total Amount Incl. VAT")
    {
    FieldValidate = yes;
    }
    trigger OnBeforeInsertRecord();
    begin
        PurchaseWorksheetLineNo+=10000;
        dPurchaseWorksheetLine.VALIDATE("Purchase Worksheet No.", PurchaseWorksheetHeader."No.");
        dPurchaseWorksheetLine.VALIDATE("Line No.", PurchaseWorksheetLineNo);
    end;
    }
    }
    }
    requestpage
    {
        layout
        {
        }
        actions
        {
        }
    }
    trigger OnPreXmlPort();
    begin
        DetectFilters();
        FindOrCreateHeader();
    end;
    var PurchaseWorksheetNo: Code[20];
    PurchaseWorksheetHeader: Record "Purch. Worksheet Header nH";
    PurchaseWorksheetLine: Record "Purch. Worksheet Line nH";
    PurchaseWorksheetLineNo: Integer;
    local procedure DetectFilters();
    var
        FilterGroupIndex: Integer;
    begin
        for FilterGroupIndex:=5 downto 0 do begin
            dPurchaseWorksheetLine.FILTERGROUP(FilterGroupIndex);
            if(dPurchaseWorksheetLine.GETFILTER("Purchase Worksheet No.") <> '')then begin
                PurchaseWorksheetNo:=dPurchaseWorksheetLine.GETRANGEMIN("Purchase Worksheet No.");
                FilterGroupIndex:=0;
            end;
        end;
        dPurchaseWorksheetLine.FILTERGROUP(0);
    end;
    local procedure FindOrCreateHeader();
    begin
        if(PurchaseWorksheetNo <> '')then PurchaseWorksheetHeader.GET(PurchaseWorksheetNo)
        else
        begin
            CLEAR(PurchaseWorksheetHeader);
            PurchaseWorksheetHeader.INIT();
            PurchaseWorksheetHeader.INSERT(true);
        end;
        PurchaseWorksheetLine.RESET();
        PurchaseWorksheetLine.SETRANGE("Purchase Worksheet No.", PurchaseWorksheetHeader."No.");
        if(PurchaseWorksheetLine.FINDLAST())then PurchaseWorksheetLineNo:=PurchaseWorksheetLine."Line No."
        else
            PurchaseWorksheetLineNo:=0;
    end;
}
