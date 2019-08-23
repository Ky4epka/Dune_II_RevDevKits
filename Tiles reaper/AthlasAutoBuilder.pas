unit AthlasAutoBuilder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.ExtCtrls, Reaper,
  Vcl.Samples.Gauges;

type
  TFindFileCallback = procedure (const AFileName: String) of Object;

  TdlgAthlasAutobuilder = class(TForm)
    GroupBox1: TGroupBox;
    DriveComboBox: TDriveComboBox;
    DirectoryListBox: TDirectoryListBox;
    Panel1: TPanel;
    memBuildingLog: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    btGotcha: TButton;
    Panel3: TPanel;
    gCurrentMapProgress: TGauge;
    gTotalProgress: TGauge;
    procedure btGotchaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fAthlas: TMap;
    fCurrent: TMap;
    fFiles: TStringList;

    procedure CollectFromFile(const AFileName: String);
    procedure Event_OnProgress(ASender: TMap; AProgress: Real);
    procedure Event_OnFindFile(const AFileName: String);

    procedure SetAthlas(AAthlas: TMap);
    procedure Log(const AMessage: String; const AParams: Array of const);

  public
    procedure EnumDirectory(const ADirectory: String; ACallback: TFindFileCallback);

    procedure Gotcha;

    property Athlas: TMap read fAthlas write SetAthlas;
    { Public declarations }
  end;

var
  dlgAthlasAutobuilder: TdlgAthlasAutobuilder;


implementation

{$R *.dfm}

procedure TdlgAthlasAutobuilder.CollectFromFile(const AFileName: string);
begin
  fCurrent := TMap.Create;

  try
    fCurrent.LoadGraphicAnalogFromFile(AFileName);
    fAthlas.CollectSpritesFrom(fCurrent);
  finally
    fCurrent.Free;
  end;
end;

procedure TdlgAthlasAutobuilder.Event_OnProgress(ASender: TMap; AProgress: Real);
begin
  gCurrentMapProgress.Progress := Round(AProgress * 100);
  Application.ProcessMessages;
end;

procedure TdlgAthlasAutobuilder.Event_OnFindFile(const AFileName: string);
begin
  fFiles.Add(AFileName);
end;

procedure TdlgAthlasAutobuilder.SetAthlas(AAthlas: TMap);
begin
  fAthlas := AAthlas;
  fAthlas.OnProcessCallback := Event_OnProgress;
end;

procedure TdlgAthlasAutobuilder.Log(const AMessage: String; const AParams: Array of const);
begin
  memBuildingLog.Lines.Add(Format(AMessage, AParams));
end;

procedure TdlgAthlasAutobuilder.EnumDirectory(const ADirectory: String; ACallback: TFindFileCallback);
var
  SRec: TSearchRec;
begin
  if FindFirst(IncludeTrailingPathDelimiter(ADirectory) + '*.*', faAnyFile, SRec) = 0
  then begin
    repeat
      if (SRec.Name = '.') or
         (SRec.Name = '..')
      then Continue;

      if ((SRec.Attr and faDirectory) = faDirectory)
      then begin
        EnumDirectory(IncludeTrailingPathDelimiter(ADirectory) + SRec.Name, ACallback);
        Continue;
      end;

      if (UpperCase(ExtractFileExt(SRec.Name)) = '.BMP')
      then begin
        ACallback(IncludeTrailingPathDelimiter(ADirectory) + SRec.Name);
      end;
    until FindNext(SRec) <> 0;

    FindClose(SRec);
  end;
end;

procedure TdlgAthlasAutobuilder.FormCreate(Sender: TObject);
begin
  fAthlas := nil;
  fCurrent := nil;
  fFiles := TStringList.Create;
end;

procedure TdlgAthlasAutobuilder.Gotcha;
var
  I: Integer;
begin
  fFiles.Clear();
  memBuildingLog.Clear;
  gCurrentMapProgress.Progress := 0;
  gTotalProgress.Progress := 0;
  Log('Collecting files...', []);
  EnumDirectory(DirectoryListBox.Directory, Event_OnFindFile);
  Log('Collected files count: %d', [fFiles.Count]);

  for I := 0 to fFiles.Count - 1
  do begin
    try
      Log('  Trying collect sprites from: %s', [fFiles[I]]);
      CollectFromFile(fFiles[I]);
      Log('  Sprite collecting from "%s" has been success!', [fFiles[I]]);
    except
      On E: Exception do
        Log('[ERROR] Error message body "%s"', [E.Message]);
    end;

    gTotalProgress.Progress := Round((I / fFiles.Count) * 100);
    Application.ProcessMessages;
  end;

  gCurrentMapProgress.Progress := 100;
  gTotalProgress.Progress := 100;

  fAthlas.SaveGraphicAnalogToFile(IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + 'SpriteAthlas.bmp');
  Log('Collecting sprites finished!', []);
end;

procedure TdlgAthlasAutobuilder.btGotchaClick(Sender: TObject);
begin
  Gotcha;
end;

end.
