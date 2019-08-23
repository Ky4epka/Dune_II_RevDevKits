unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Reaper, Vcl.StdCtrls,
  Vcl.Samples.Gauges, MapRenderer, SpriteAthlasDialog, MainWindowMapRenderer, AthlasAutobuilder;

const
  SPRITE_COLLECTION_FILE_NAME = 'SpriteAtlas.bmp';

type
  TGUICell = class

  private
    fHovered: Boolean;

  public
    constructor Create;

    property Hovered: Boolean read fHovered write fHovered;
  end;

  TMainForm = class(TForm)
    pTools: TPanel;
    pRenderer: TPanel;
    edSelectedFile: TEdit;
    Label1: TLabel;
    btSelectFile: TButton;
    btCollect: TButton;
    OpenDialog: TOpenDialog;
    pFooter: TPanel;
    gProgress: TGauge;
    btAutobuilderDlg: TButton;
    procedure btSelectFileClick(Sender: TObject);
    procedure btCollectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btAutobuilderDlgClick(Sender: TObject);
  private
    fRenderer: TfrMainWindowMapRenderer;
    fSpriteAthlasDialog: TdlgSpriteAthlas;
    { Private declarations }
  public
    { Public declarations }

    procedure UpdateSpriteAthlasDialog;
    procedure Event_OnProgress(ASender: TMap; AProgress: Real);
  end;

var
  MainForm: TMainForm;
  CollectionMap: TMap;

implementation

{$R *.dfm}

constructor TGUICell.Create;
begin
  Inherited Create;
  fHovered := false;
end;

procedure TMainForm.btAutobuilderDlgClick(Sender: TObject);
begin
  dlgAthlasAutobuilder.Athlas := CollectionMap;
  dlgAthlasAutobuilder.Show;
end;

procedure TMainForm.btCollectClick(Sender: TObject);
begin
  CollectionMap.CollectSpritesFrom(fRenderer.Map);
  CollectionMap.SaveGraphicAnalogToFile(SPRITE_COLLECTION_FILE_NAME);
  UpdateSpriteAthlasDialog;
end;

procedure TMainForm.btSelectFileClick(Sender: TObject);
var
  iFileName: String;
begin
  if OpenDialog.Execute then
  begin
    iFileName := OpenDialog.FileName;
    edSelectedFile.Text := iFileName;
    fRenderer.LoadMapImageFromFile(iFileName);
  end;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  CollectionMap := TMap.Create;
  CollectionMap.OnProcessCallback := Event_OnProgress;

  if FileExists(SPRITE_COLLECTION_FILE_NAME)
  then CollectionMap.LoadGraphicAnalogFromFile(SPRITE_COLLECTION_FILE_NAME);

  fRenderer := TfrMainWindowMapRenderer.Create(Self);
  fRenderer.UseGrid := true;
  fRenderer.Parent := pRenderer;
end;


procedure TMainForm.FormShow(Sender: TObject);
begin
  fRenderer.Align := alClient;

  fSpriteAthlasDialog := dlgSpriteAthlas;
  fSpriteAthlasDialog.Left := BoundsRect.Right;
  fSpriteAthlasDialog.Top := BoundsRect.Top;

  UpdateSpriteAthlasDialog;
end;

procedure TMainForm.UpdateSpriteAthlasDialog;
begin
  fSpriteAthlasDialog.SetAthlasImage(CollectionMap.GraphicAnalog);
end;

procedure TMainForm.Event_OnProgress(ASender: TMap; AProgress: Real);
begin
  gProgress.Progress := Round(AProgress * 100);
end;

end.
