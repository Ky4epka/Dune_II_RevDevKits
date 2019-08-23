unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MainWindowMapRenderer, Reaper,
  Vcl.StdCtrls, INIFiles, Vcl.Samples.Spin;

const
  ConfigFileName = 'config.cfg';

type
  TfmMain = class(TForm)
    pTools: TPanel;
    edFileNameValue: TEdit;
    lFileName: TLabel;
    btFileNameSelect: TButton;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    btSaveTo: TButton;
    btPackMap: TButton;
    seSimilarPercent: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure btFileNameSelectClick(Sender: TObject);
    procedure btSaveToClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btPackMapClick(Sender: TObject);
    procedure seSimilarPercentChange(Sender: TObject);
  private
    fMapRenderer: TfrMainWindowMapRenderer;
    fLastOpen: String;
    { Private declarations }

    procedure UpdateUI;
  public

    procedure LoadFromFile(const AFileName: String);
    procedure SaveToFile(const AFileName: String);

    procedure LoadConfig;
    procedure SaveConfig;

    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.UpdateUI;
begin
  edFileNameValue.Text := fLastOpen;
  edFileNameValue.Color := clBtnFace;
  edFileNameValue.ReadOnly := true;
  btSaveTo.Enabled := FileExists(fLastOpen);
end;

procedure TfmMain.btFileNameSelectClick(Sender: TObject);
begin
  if FileExists(fLastOpen)
  then begin
    OpenDialog.InitialDir := ExtractFileDir(fLastOpen);
    OpenDialog.FileName := ExtractFileName(fLastOpen);
  end
  else begin
    OpenDialog.InitialDir := ExtractFileDir(ParamStr(0));
    OpenDialog.FileName := '';
  end;

  if (OpenDialog.Execute) then
  begin
    LoadFromFile(OpenDialog.FileName);
  end;
end;

procedure TfmMain.btPackMapClick(Sender: TObject);
var
  iMap: TMap;
begin
  iMap := TMap.Create;

  try
    iMap.CollectSpritesFrom(fMapRenderer.Map, true);
    iMap.GraphicAnalog.SaveToFile('test.bmp');
    fMapRenderer.Map.GraphicAnalog := iMap.GraphicAnalog;
  finally
    iMap.Free;
  end;
end;

procedure TfmMain.btSaveToClick(Sender: TObject);
begin
  if FileExists(fLastOpen)
  then begin
    SaveDialog.InitialDir := ExtractFileDir(fLastOpen);
    SaveDialog.FileName := ExtractFileName(fLastOpen);
  end
  else begin
    SaveDialog.InitialDir := ExtractFileDir(ParamStr(0));
    SaveDialog.FileName := 'new_sprite_map.bmp';
  end;

  if (SaveDialog.Execute)
  then begin
    SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fMapRenderer := TfrMainWindowMapRenderer.Create(Self);
  fMapRenderer.Parent := Self;
  fMapRenderer.Align := alClient;
  LoadConfig;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfmMain.LoadFromFile(const AFileName: string);
begin
  fLastOpen := AFileName;
  fMapRenderer.LoadMapImageFromFile(AFileName);
  UpdateUI;
  SaveConfig;
end;

procedure TfmMain.SaveToFile(const AFileName: string);
begin
  fLastOpen := AFileName;
  fMapRenderer.Map.SaveGraphicAnalogToFile(AFileName);
  UpdateUI;
  SaveConfig;
end;

procedure TfmMain.seSimilarPercentChange(Sender: TObject);
begin
  fMapRenderer.SimilarPercent := seSimilarPercent.Value;
end;

procedure TfmMain.LoadConfig;
var
  iIni: TMemIniFile;
  iStr: String;
begin
  iIni := TMemIniFile.Create(ConfigFileName);
  try
    iStr := iIni.ReadString('MAIN', 'FileName', '');

    if (FileExists(iStr))
    then LoadFromFile(iStr);

    UpdateUI;
  finally
    iIni.Free;
  end;
end;

procedure TfmMain.SaveConfig;
var
  iIni: TMemIniFile;
begin
  iIni := TMemIniFile.Create(ConfigFileName);
  try
    if not (FileExists(fLastOpen)) then
      fLastOpen := '';

    iIni.WriteString('MAIN', 'FileName', fLastOpen);
    iIni.UpdateFile;
    UpdateUI;
  finally
    iIni.Free;
  end;
end;

end.
