page 66602 "CHM Customizations Setup"
{
    Caption = 'Chematek Customizations Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "CHM Customizations Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(ReportLogos)
            {
                Caption = 'Report Logos';

                field("Right Header Logo"; Rec."Right Header Logo")
                {
                    ToolTip = 'Specifies the logo printed at the top right of the sales documents. The print area is about 47 x 17 mm; the picture is scaled to fit.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Footer Logo"; Rec."Footer Logo")
                {
                    ToolTip = 'Specifies the banner printed at the bottom of the sales documents. The print area is about 164 x 19 mm; the picture is scaled to fit.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("ISO 9001 Logo"; Rec."ISO 9001 Logo")
                {
                    ToolTip = 'Specifies the ISO 9001 certification logo printed in the footer of the sales documents. The print area is about 12 x 11 mm.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("ASSICC Logo"; Rec."ASSICC Logo")
                {
                    ToolTip = 'Specifies the ASSICC logo printed in the footer of the sales documents. The print area is about 12 x 11 mm.';

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord();
                    end;
                }
                field("Show ISO"; Rec."Show ISO")
                {
                    ToolTip = 'Specifies whether the ISO certification text (certificate number and revision) is printed in the footer of the sales documents.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportLogo)
            {
                Caption = 'Import Logo';
                Image = Import;
                ToolTip = 'Import a picture file into one of the report logos.';

                trigger OnAction()
                begin
                    ImportLogoFile();
                end;
            }
            action(ExportLogo)
            {
                Caption = 'Export Logo';
                Image = Export;
                ToolTip = 'Download one of the report logos as a picture file, for example to set it up in another environment.';

                trigger OnAction()
                begin
                    ExportLogoFile();
                end;
            }
            action(DeleteLogo)
            {
                Caption = 'Delete Logo';
                Image = Delete;
                ToolTip = 'Remove one of the report logos.';

                trigger OnAction()
                begin
                    DeleteLogoFile();
                end;
            }
            action(CopyLogosFromCoreModel)
            {
                Caption = 'Copy Logos from Chematek Core Model';
                Image = Copy;
                ToolTip = 'Copy the report logos and the Show ISO setting from the CHM Setup Chematek table (Chematek - Core Model app), if that app is installed in this environment.';

                trigger OnAction()
                begin
                    CopyLogosFromCoreModelSetup();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(ImportLogo_Promoted; ImportLogo) { }
                actionref(ExportLogo_Promoted; ExportLogo) { }
                actionref(DeleteLogo_Promoted; DeleteLogo) { }
                actionref(CopyLogosFromCoreModel_Promoted; CopyLogosFromCoreModel) { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    var
        SelectLogoTxt: Label 'Select the logo:';
        ImportLogoTxt: Label 'Import Logo';
        ExportLogoTxt: Label 'Export Logo';
        ImageFileFilterTxt: Label 'Image files (*.png;*.jpg;*.jpeg;*.bmp;*.gif)|*.png;*.jpg;*.jpeg;*.bmp;*.gif';
        NoLogoErr: Label 'No picture has been set up for %1.', Comment = '%1 = name of the logo field';
        DeleteLogoQst: Label 'Do you want to remove the %1?', Comment = '%1 = name of the logo field';
        CoreModelNotInstalledErr: Label 'The CHM Setup Chematek table (%1) of the Chematek - Core Model app was not found in this environment.', Comment = '%1 = table number';
        CoreModelSetupEmptyErr: Label 'There is no record in the CHM Setup Chematek table to copy from.';
        CopyLogosQst: Label 'The report logos and the Show ISO setting will be overwritten with the values from CHM Setup Chematek. Do you want to continue?';
        LogosCopiedMsg: Label '%1 logo(s) copied from CHM Setup Chematek.', Comment = '%1 = number of logos';

    local procedure SelectLogoField(Instruction: Text): Integer
    var
        Selection: Integer;
    begin
        Selection := StrMenu(
            StrSubstNo('%1,%2,%3,%4',
                Rec.FieldCaption("Right Header Logo"), Rec.FieldCaption("Footer Logo"),
                Rec.FieldCaption("ISO 9001 Logo"), Rec.FieldCaption("ASSICC Logo")),
            1, Instruction);
        case Selection of
            1:
                exit(Rec.FieldNo("Right Header Logo"));
            2:
                exit(Rec.FieldNo("Footer Logo"));
            3:
                exit(Rec.FieldNo("ISO 9001 Logo"));
            4:
                exit(Rec.FieldNo("ASSICC Logo"));
        end;
        exit(0);
    end;

    local procedure ImportLogoFile()
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        InStr: InStream;
        OutStr: OutStream;
        LogoFieldNo: Integer;
        FileName: Text;
    begin
        LogoFieldNo := SelectLogoField(SelectLogoTxt);
        if LogoFieldNo = 0 then
            exit;
        if not UploadIntoStream(ImportLogoTxt, '', ImageFileFilterTxt, FileName, InStr) then
            exit;

        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
        RecRef.GetTable(Rec);
        TempBlob.ToRecordRef(RecRef, LogoFieldNo);
        RecRef.Modify();
        RefreshPage();
    end;

    local procedure ExportLogoFile()
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        InStr: InStream;
        LogoFieldNo: Integer;
        FileName: Text;
    begin
        LogoFieldNo := SelectLogoField(SelectLogoTxt);
        if LogoFieldNo = 0 then
            exit;

        RecRef.GetTable(Rec);
        TempBlob.FromRecordRef(RecRef, LogoFieldNo);
        if not TempBlob.HasValue() then
            Error(NoLogoErr, RecRef.Field(LogoFieldNo).Caption());

        FileName := DelChr(RecRef.Field(LogoFieldNo).Caption(), '=', ' ') + '.' + GetImageFileExtension(TempBlob);
        TempBlob.CreateInStream(InStr);
        DownloadFromStream(InStr, ExportLogoTxt, '', ImageFileFilterTxt, FileName);
    end;

    local procedure DeleteLogoFile()
    var
        EmptyTempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        LogoFieldNo: Integer;
    begin
        LogoFieldNo := SelectLogoField(SelectLogoTxt);
        if LogoFieldNo = 0 then
            exit;

        RecRef.GetTable(Rec);
        if not Confirm(DeleteLogoQst, false, RecRef.Field(LogoFieldNo).Caption()) then
            exit;
        EmptyTempBlob.ToRecordRef(RecRef, LogoFieldNo);
        RecRef.Modify();
        RefreshPage();
    end;

    local procedure CopyLogosFromCoreModelSetup()
    var
        AllObj: Record AllObj;
        SourceRecRef: RecordRef;
        TargetRecRef: RecordRef;
        ShowISOFieldRef: FieldRef;
        CopiedCount: Integer;
    begin
        // CHM Setup Chematek (Chematek - Core Model) is read by number so that this app does not
        // depend on the Core Model app.
        if not AllObj.Get(AllObj."Object Type"::Table, CoreModelSetupTableNo()) then
            Error(CoreModelNotInstalledErr, CoreModelSetupTableNo());

        SourceRecRef.Open(CoreModelSetupTableNo());
        if not SourceRecRef.FindFirst() then
            Error(CoreModelSetupEmptyErr);

        if not Confirm(CopyLogosQst, true) then
            exit;

        TargetRecRef.GetTable(Rec);
        CopyLogo(SourceRecRef, 2, TargetRecRef, Rec.FieldNo("Right Header Logo"), CopiedCount);    // Right Header Logo
        CopyLogo(SourceRecRef, 3, TargetRecRef, Rec.FieldNo("ISO 9001 Logo"), CopiedCount);        // ISO9001 Logo
        CopyLogo(SourceRecRef, 4, TargetRecRef, Rec.FieldNo("ASSICC Logo"), CopiedCount);          // ASSICC Logo
        CopyLogo(SourceRecRef, 6, TargetRecRef, Rec.FieldNo("Footer Logo"), CopiedCount);          // Invoice Footer Logo

        if FindBooleanField(SourceRecRef, 'Show ISO', ShowISOFieldRef) then
            TargetRecRef.Field(Rec.FieldNo("Show ISO")).Value := ShowISOFieldRef.Value();

        TargetRecRef.Modify();
        RefreshPage();
        Message(LogosCopiedMsg, CopiedCount);
    end;

    local procedure CopyLogo(var SourceRecRef: RecordRef; SourceFieldNo: Integer; var TargetRecRef: RecordRef; TargetFieldNo: Integer; var CopiedCount: Integer)
    var
        TempBlob: Codeunit "Temp Blob";
    begin
        if not SourceRecRef.FieldExist(SourceFieldNo) then
            exit;
        if SourceRecRef.Field(SourceFieldNo).Type() <> FieldType::Blob then
            exit;
        TempBlob.FromRecordRef(SourceRecRef, SourceFieldNo);
        if not TempBlob.HasValue() then
            exit;
        TempBlob.ToRecordRef(TargetRecRef, TargetFieldNo);
        CopiedCount += 1;
    end;

    local procedure FindBooleanField(var SourceRecRef: RecordRef; FieldNameOrCaption: Text; var FoundFieldRef: FieldRef): Boolean
    var
        CandidateFieldRef: FieldRef;
        i: Integer;
    begin
        for i := 1 to SourceRecRef.FieldCount() do begin
            CandidateFieldRef := SourceRecRef.FieldIndex(i);
            if CandidateFieldRef.Type() = FieldType::Boolean then
                if (UpperCase(CandidateFieldRef.Name()) = UpperCase(FieldNameOrCaption)) or
                   (UpperCase(CandidateFieldRef.Caption()) = UpperCase(FieldNameOrCaption))
                then begin
                    FoundFieldRef := CandidateFieldRef;
                    exit(true);
                end;
        end;
        exit(false);
    end;

    local procedure CoreModelSetupTableNo(): Integer
    begin
        exit(51000); // CHM Setup Chematek (Chematek - Core Model)
    end;

    local procedure GetImageFileExtension(var TempBlob: Codeunit "Temp Blob"): Text
    var
        InStr: InStream;
        Byte1: Byte;
        Byte2: Byte;
    begin
        TempBlob.CreateInStream(InStr);
        InStr.Read(Byte1);
        InStr.Read(Byte2);
        case true of
            (Byte1 = 137) and (Byte2 = 80):
                exit('png');
            (Byte1 = 255) and (Byte2 = 216):
                exit('jpg');
            (Byte1 = 66) and (Byte2 = 77):
                exit('bmp');
            (Byte1 = 71) and (Byte2 = 73):
                exit('gif');
        end;
        exit('png');
    end;

    local procedure RefreshPage()
    begin
        Rec.Get(Rec."Primary Key");
        CurrPage.Update(false);
    end;
}
