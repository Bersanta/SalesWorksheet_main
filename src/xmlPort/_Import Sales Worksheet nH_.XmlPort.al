xmlport 80438 "Import Sales Worksheet nH"
{
    Caption = 'Import Sales Worksheet';
    Direction = Import;
    FileName = 'Sales Worksheet Lines.xml';
    Format = VariableText;

    schema
    {
        textelement(dsalesworksheetlines)
        {
            XmlName = 'SalesWorksheetLines';

            tableelement(dsalesworksheetline;
            "Sales Worksheet Line nH")
            {
                AutoUpdate = true;
                RequestFilterFields = "Sales Worksheet No.", "Line No.";
                XmlName = 'SalesWorksheetLine';

                fieldattribute(DocumentType;
                dSalesWorksheetLine."Document Type")
                {
                    FieldValidate = yes;
                }
                fieldattribute(CustomerNo;
                dSalesWorksheetLine."Customer No.")
                {
                    FieldValidate = yes;
                }
                fieldattribute(OrderType; dsalesworksheetline."Order Type")
                {
                    FieldValidate = yes;
                }
                fieldattribute(CustomerName;
                dSalesWorksheetLine."Customer Name")
                {
                    FieldValidate = yes;
                }
                fieldattribute(OrderDate;
                dSalesWorksheetLine."Order Date")
                {
                    FieldValidate = yes;
                }

                fieldattribute(PostingDate;
                dSalesWorksheetLine."Posting Date")
                {
                    FieldValidate = yes;
                }
                fieldattribute(DocumentDate;
                dSalesWorksheetLine."Document Date")
                {
                    FieldValidate = yes;
                }
                fieldattribute(RequestedDeliveryDate;
                dSalesWorksheetLine."Requested Delivery Date")
                {
                    FieldValidate = yes;
                }
                fieldattribute(PromisedDeliveryDate;
                dsalesworksheetline."Promised Delivery Date")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ExternalDocumentNo;
                dSalesWorksheetLine."External Document No.")
                {
                    FieldValidate = yes;
                }
                fieldattribute(OrderSeasonType;
                dsalesworksheetline."Order Season Type")
                {
                    FieldValidate = yes;
                }
                fieldattribute(OrderSeasonCode;
                dsalesworksheetline."Order Season Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(DeliveryInformation;
                dsalesworksheetline."Delivery Information")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShippingAgent;
                dsalesworksheetline."Shipping Agent")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShippingAgentService;
                dsalesworksheetline."Shipping Agent Service")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToContact;
                dsalesworksheetline."Ship-to Contact")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToName;
                dsalesworksheetline."Ship-to Name")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToAddress;
                dsalesworksheetline."Ship-to Address")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToAddress2;
                dsalesworksheetline."Ship-to Address 2")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToCity; dsalesworksheetline."Ship-to City")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToPostCode; dsalesworksheetline."Ship-to PostCode")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShiptoCountry; dsalesworksheetline."Ship-to Country")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShiptoCounty; dsalesworksheetline."Ship-to County")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToPhoneNo; dsalesworksheetline."Ship-to Phone No.")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipToEmail; dsalesworksheetline."Ship-to E-mail")
                {
                    FieldValidate = yes;
                }
                fieldattribute(SalespersonCode; dsalesworksheetline."Salesperson Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(CurrencyCode;
                dSalesWorksheetLine."Currency Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(PostingDescription;
                dSalesWorksheetLine."Posting Description")
                {
                    FieldValidate = yes;
                }
                fieldattribute(ShipmentMethodCode;
                dSalesWorksheetLine."Shipment Method Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Type;
                dSalesWorksheetLine.Type)
                {
                    FieldValidate = yes;
                }
                fieldattribute(No;
                dSalesWorksheetLine."No.")
                {
                    FieldValidate = yes;
                }
                fieldattribute(VariantCode;
                dSalesWorksheetLine."Variant Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Quantity;
                dSalesWorksheetLine.Quantity)
                {
                    FieldValidate = yes;
                }
                fieldattribute(Description;
                dSalesWorksheetLine.Description)
                {
                    FieldValidate = yes;
                }
                fieldattribute(LocationCode;
                dSalesWorksheetLine."Location Code")
                {
                }
                fieldattribute(UnitPrice;
                dSalesWorksheetLine."Unit Price")
                {
                    FieldValidate = yes;
                }
                fieldattribute(LineDiscount; dsalesworksheetline."Line Discount")
                {
                    FieldValidate = yes;
                }
                fieldattribute(SplitBy;
                dSalesWorksheetLine."Split By")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension1Code;
                dSalesWorksheetLine."Dimension 1 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension2Code;
                dSalesWorksheetLine."Dimension 2 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension3Code;
                dSalesWorksheetLine."Dimension 3 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension4Code;
                dSalesWorksheetLine."Dimension 4 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension5Code;
                dSalesWorksheetLine."Dimension 5 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension6Code;
                dSalesWorksheetLine."Dimension 6 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension7Code;
                dSalesWorksheetLine."Dimension 7 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(Dimension8Code;
                dSalesWorksheetLine."Dimension 8 Code")
                {
                    FieldValidate = yes;
                }
                fieldattribute(YourReference;
                dSalesWorksheetLine."Your Reference")
                {
                    FieldValidate = yes;
                }
                fieldattribute(TotalAmount;
                dSalesWorksheetLine."Total Amount")
                {
                    FieldValidate = yes;
                }
                fieldattribute(TotalAmountInclVAT;
                dSalesWorksheetLine."Total Amount Incl. VAT")
                {
                    FieldValidate = yes;
                }
                trigger OnBeforeInsertRecord();
                begin
                    SalesWorksheetLineNo += 10000;
                    dSalesWorksheetLine.VALIDATE("Sales Worksheet No.", SalesWorksheetHeader."No.");
                    dSalesWorksheetLine.VALIDATE("Line No.", SalesWorksheetLineNo);
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

    var
        SalesWorksheetNo: Code[20];
        SalesWorksheetHeader: Record "Sales Worksheet Header nH";
        SalesWorksheetLine: Record "Sales Worksheet Line nH";
        SalesWorksheetLineNo: Integer;

    local procedure DetectFilters();
    var
        FilterGroupIndex: Integer;
    begin
        for FilterGroupIndex := 5 downto 0 do begin
            dSalesWorksheetLine.FILTERGROUP(FilterGroupIndex);
            if (dSalesWorksheetLine.GETFILTER("Sales Worksheet No.") <> '') then begin
                SalesWorksheetNo := dSalesWorksheetLine.GETRANGEMIN("Sales Worksheet No.");
                FilterGroupIndex := 0;
            end;
        end;
        dSalesWorksheetLine.FILTERGROUP(0);
    end;

    local procedure FindOrCreateHeader();
    begin
        if (SalesWorksheetNo <> '') then
            SalesWorksheetHeader.GET(SalesWorksheetNo)
        else begin
            CLEAR(SalesWorksheetHeader);
            SalesWorksheetHeader.INIT();
            SalesWorksheetHeader.INSERT(true);
        end;
        SalesWorksheetLine.RESET();
        SalesWorksheetLine.SETRANGE("Sales Worksheet No.", SalesWorksheetHeader."No.");
        if (SalesWorksheetLine.FINDLAST()) then
            SalesWorksheetLineNo := SalesWorksheetLine."Line No."
        else
            SalesWorksheetLineNo := 0;
    end;
}
