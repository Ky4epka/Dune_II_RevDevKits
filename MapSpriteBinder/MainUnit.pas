unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MapRenderer, Reaper,
  Vcl.StdCtrls, INIFiles, Vcl.Samples.Spin, MapCellBindList, Vcl.ComCtrls,
  Vcl.Menus, System.Actions, Vcl.ActnList;

const
  AppName = 'MapSpriteBinder';
  AppNameFormat = '%s - %s%s';
  ChangedChar = '*';
  ConfigFileName = 'config.cfg';
  MapBindFileExt = '.mb';
  MapBindFileFilter = 'Map bind (*.mb)|*.mb';
  AssociatedFileExt = '.bmp';
  AssociatedFileFilter = 'Windows bitmap (*.bmp)|*.bmp';

type
  TfmMain = class(TForm)
    pTools: TPanel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    pRightBox: TPanel;
    btAddCell: TButton;
    pCellNotBinded: TPanel;
    pBindedCellInfo: TPanel;
    pCellInfo: TPanel;
    PageControl1: TPageControl;
    tsMap: TTabSheet;
    tsCell: TTabSheet;
    Label1: TLabel;
    edAssociatedAthlasFileNameValue: TEdit;
    btAssociatedAthlasSelect: TButton;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Exit1: TMenuItem;
    asd1: TMenuItem;
    ActionList: TActionList;
    aNewMapBind: TAction;
    aOpen: TAction;
    aSave: TAction;
    aSaveTo: TAction;
    aExit: TAction;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveto1: TMenuItem;
    Label2: TLabel;
    edCellNameValue: TEdit;
    Label3: TLabel;
    edPathCostValue: TEdit;
    Label4: TLabel;
    edCellAirSpeedScaleValue: TEdit;
    Label5: TLabel;
    edCellGroundSpeedScaleValue: TEdit;
    Label6: TLabel;
    pCellPosition: TPanel;
    cbCellCanHasSpiceValue: TCheckBox;
    edCellPositionXValue: TEdit;
    Label7: TLabel;
    edCellPositionYValue: TEdit;
    Label8: TLabel;
    Label11: TLabel;
    Label9: TLabel;
    cbCellCanBuildingsPlacesValue: TCheckBox;
    Label10: TLabel;
    edCellSpiceValue: TEdit;
    cbCellCanGroundUnitsPlacesValue: TCheckBox;
    Label12: TLabel;
    pCellMinimapColorValue: TPanel;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btAddCellClick(Sender: TObject);
    procedure btAssociatedAthlasSelectClick(Sender: TObject);
    procedure aSaveToExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aOpenExecute(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aNewMapBindExecute(Sender: TObject);
    procedure edPathCostValueChange(Sender: TObject);
  protected
    fMapRenderer: TfrMapRenderer;
    fLastOpen: String;
    fMapCellBindList: TMapCellBindList;
    fHasChanges: Boolean;
    fHandled: Boolean;
    fCurrentCell: TMapCell;
    { Private declarations }

    procedure UpdateUI;

    procedure Event_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
    procedure Event_OnMouseMove(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
    procedure Event_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
    procedure DoChanged(AValue: Boolean);

    function GetEditNumberValue(ABox: TEdit; APrevValue: Extended;  var AResult: Extended): Boolean;

    procedure ApplyCellInfo(AInfo: TMapCell);
    procedure DisplayCellInfo(AInfo: TMapCell);
  public
    procedure LoadAthlasFromFile(const AFileName: String);

    procedure NewFile();
    procedure LoadFromFile(const AFileName: String);
    procedure SaveToFile(const AFileName: String);
    procedure CloseFile();

    procedure LoadConfig;
    procedure SaveConfig;

    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.UpdateUI;
var
  iCell: TCell;
  iChangedChar: String;
begin
  fHandled := true;

  try
    if fHasChanges
    then iChangedChar := ChangedChar
    else iChangedChar := '';

    Caption := Format(AppNameFormat, [AppName, fLastOpen, iChangedChar]);
    edAssociatedAthlasFileNameValue.Text := ExtractFileName(fMapCellBindList.AssociatedAthlas);
    edAssociatedAthlasFileNameValue.Color := clBtnFace;
    edAssociatedAthlasFileNameValue.ReadOnly := true;

    iCell := fMapRenderer.PressedCell;

    if Assigned(iCell) then
    begin
      pCellInfo.Visible := true;

      if Assigned(fCurrentCell) then
      begin
        pCellNotBinded.Visible := false;
        pBindedCellInfo.Visible := true;
        DisplayCellInfo(fCurrentCell);
      end
      else
      begin
        pBindedCellInfo.Visible := false;
        pCellNotBinded.Visible := true;
      end;
    end
    else
    begin
      pCellInfo.Visible := false;
    end;
  finally
    fHandled := false;
  end;
end;

procedure TfmMain.Event_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  if (Assigned(fMapRenderer.PressedCell))
  then fCurrentCell := fMapCellBindList.CellAt(fMapRenderer.PressedCell.Position)
  else fCurrentCell := nil;

  UpdateUI;
end;

procedure TfmMain.Event_OnMouseMove(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
begin
  UpdateUI;
end;

procedure TfmMain.Event_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  UpdateUI;
end;

procedure TfmMain.DoChanged;
begin
  fHasChanges := AValue;
end;

procedure TfmMain.edPathCostValueChange(Sender: TObject);
var
  iValue: Extended;
begin
  if (fHandled)
  then Exit;

  if (GetEditNumberValue(TEdit(Sender), 0, iValue))
  then begin
    ApplyCellInfo(fCurrentCell);
    UpdateUI;
  end;
end;

function TfmMain.GetEditNumberValue(ABox: TEdit; APrevValue: Extended; var AResult: Extended): Boolean;
var
  iVal: Extended;
begin
  if (TryStrToFloat(ABox.Text, iVal))
  then begin
    AResult := iVal;
  end
  else
  begin
    AResult := APrevValue;
    fHandled := true;

    try
      ABox.Text := FloatToStr(AResult);
    finally
      fHandled := false;
    end;
  end;
end;

procedure TfmMain.ApplyCellInfo(AInfo: TMapCell);
begin
  if not Assigned(AInfo)
  then Exit;

  AInfo.Data^.CellName := edCellNameValue.Text;
  AInfo.Data^.Position.X := StrToInt(edCellPositionXValue.Text);
  AInfo.Data^.Position.Y := StrToInt(edCellPositionYValue.Text);
  AInfo.Data^.PathCost := StrToInt(edPathCostValue.Text);
  AInfo.Data^.GroundSpeedScale := StrToFloat(edCellGroundSpeedScaleValue.Text);
  AInfo.Data^.AirSpeedScale := StrToFloat(edCellAirSpeedScaleValue.Text);
  AInfo.Data^.CanHasSpice := cbCellCanHasSpiceValue.Checked;
  AInfo.Data^.SpiceValue := StrToFloat(edCellSpiceValue.Text);
  AInfo.Data^.CellColor := pCellMinimapColorValue.Color;
  AInfo.Data^.CanBuildingsPlaces := cbCellCanBuildingsPlacesValue.Checked;
  AInfo.Data^.CanGroundUnitsPlaces := cbCellCanGroundUnitsPlacesValue.Checked;
end;

procedure TfmMain.DisplayCellInfo(AInfo: TMapCell);
begin
  if not Assigned(AInfo)
  then Exit;

  edCellNameValue.Text := AInfo.Data^.CellName;
  edCellPositionXValue.Text := IntToStr(AInfo.Data^.Position.X);
  edCellPositionYValue.Text := IntToStr(AInfo.Data^.Position.Y);
  edPathCostValue.Text := IntToStr(AInfo.Data^.PathCost);
  edCellGroundSpeedScaleValue.Text := FloatToStr(AInfo.Data^.GroundSpeedScale);
  edCellAirSpeedScaleValue.Text := FloatToStr(AInfo.Data^.AirSpeedScale);
  cbCellCanHasSpiceValue.Checked := AInfo.Data^.CanHasSpice;
  edCellSpiceValue.Text := FloatToStr(AInfo.Data^.SpiceValue);
  pCellMinimapColorValue.Color := AInfo.Data^.CellColor;
  cbCellCanBuildingsPlacesValue.Checked := AInfo.Data^.CanBuildingsPlaces;
  cbCellCanGroundUnitsPlacesValue.Checked := AInfo.Data^.CanGroundUnitsPlaces;
end;

procedure TfmMain.aExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmMain.aNewMapBindExecute(Sender: TObject);
begin
  NewFile;
end;

procedure TfmMain.aOpenExecute(Sender: TObject);
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

procedure TfmMain.aSaveExecute(Sender: TObject);
begin
  if FileExists(fLastOpen)
  then SaveToFile(fLastOpen)
  else aSaveToExecute(Sender);
end;

procedure TfmMain.aSaveToExecute(Sender: TObject);
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

procedure TfmMain.btAddCellClick(Sender: TObject);
var
  iMapCell: TMapCell;
  iCellData: TMapCellData;
begin
  if Assigned(fMapRenderer.PressedCell)
  then begin
    iMapCell := fMapCellBindList.AddCell;
    iCellData.SetDefault;
    iCellData.Position := fMapRenderer.PressedCell.Position;
    iMapCell.AssignData(@iCellData);
  end;

  UpdateUI;
end;

procedure TfmMain.btAssociatedAthlasSelectClick(Sender: TObject);
begin
  OpenDialog.Filter := AssociatedFileFilter;

  if FileExists(fMapCellBindList.AssociatedAthlas)
  then begin
    OpenDialog.InitialDir := ExtractFileDir(fMapCellBindList.AssociatedAthlas);
    OpenDialog.FileName := ExtractFileName(fMapCellBindList.AssociatedAthlas);
  end
  else begin
    OpenDialog.InitialDir := ExtractFileDir(ParamStr(0));
    OpenDialog.FileName := '';
  end;

  if (OpenDialog.Execute)
  then begin
    LoadAthlasFromFile(OpenDialog.FileName);
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fMapRenderer := TfrMapRenderer.Create(Self);
  fMapRenderer.Parent := Self;
  fMapRenderer.Align := alClient;
  fMapRenderer.OnMouseDown := Event_OnMouseDown;
  fMapRenderer.OnMouseMove := Event_OnMouseMove;
  fMapRenderer.OnMouseUp := Event_OnMouseUp;
  fMapCellBindList := TMapCellBindList.Create;
  LoadConfig;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  SaveConfig;
end;

procedure TfmMain.LoadAthlasFromFile(const AFileName: string);
begin
  if not FileExists(AFileName)
  then Exit;

  fMapRenderer.LoadMapImageFromFile(AFileName);
  fMapCellBindList.AssociatedAthlas := AFileName;
  UpdateUI;
end;

procedure TfmMain.NewFile;
begin
  CloseFile;
  fLastOpen := 'new file';
  UpdateUI;
end;

procedure TfmMain.LoadFromFile(const AFileName: string);
begin
  fLastOpen := AFileName;
  fMapCellBindList.LoadFromFile(AFileName);
  LoadAthlasFromFile(fMapCellBindList.AssociatedAthlas);
  UpdateUI;
  SaveConfig;
end;

procedure TfmMain.SaveToFile(const AFileName: string);
begin
  fLastOpen := AFileName;
  fMapCellBindList.SaveToFile(AFilename);
  UpdateUI;
  SaveConfig;
end;

procedure TfmMain.CloseFile;
begin
  fLastOpen := '';
  fMapCellBindList.AssociatedAthlas := '';
  fMapCellBindList.Clear;
  fMapRenderer.Map.Clear;
  fCurrentCell := nil;
  UpdateUI;
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
    then LoadFromFile(iStr)
    else NewFile;

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
