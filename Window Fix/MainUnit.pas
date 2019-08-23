unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, System.Math;

type
  TfmMain = class(TForm)
    pMain: TPanel;
    Panel2: TPanel;
    pSecond: TPanel;
    pTools: TPanel;
    gbSecondTools: TGroupBox;
    cbSecond_ToolsUse: TCheckBox;
    seSecond_AreaSize: TSpinEdit;
    lbSecond_AreaSize: TLabel;
    imMainLayer: TImage;
    imSecondLayer: TImage;
    spZoomArea: TShape;
    tWindowController: TTimer;
    tRenderer: TTimer;
    edMain_FocusControl: TEdit;
    spMain_FocusIndicator: TShape;
    tAreaFind: TTimer;
    btAreaFind_Activate: TButton;
    btAreaFind_Deactivate: TButton;
    btAreaFind_Forget: TButton;
    btAreaFind_Remember: TButton;
    cbAreaFind_Use: TCheckBox;
    lbAreaFind_Desc: TLabel;
    procedure spZoomAreaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spZoomAreaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure spZoomAreaMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edMain_FocusControlEnter(Sender: TObject);
    procedure edMain_FocusControlExit(Sender: TObject);
    procedure edMain_FocusControlMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imMainLayerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spMain_FocusIndicatorMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure edMain_FocusControlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbSecond_ToolsUseClick(Sender: TObject);
    procedure seSecond_AreaSizeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure tRendererTimer(Sender: TObject);
    procedure tWindowControllerTimer(Sender: TObject);
    procedure tAreaFindTimer(Sender: TObject);
    procedure cbAreaFind_UseClick(Sender: TObject);
    procedure btAreaFind_ForgetClick(Sender: TObject);
    procedure btAreaFind_RememberClick(Sender: TObject);
    procedure btAreaFind_DeactivateClick(Sender: TObject);
    procedure btAreaFind_ActivateClick(Sender: TObject);
  private
    fMainLayer: TBitmap;
    fSecondLayer: TBitmap;

    fWnd: HWND;
    fDC: HDC;

    fZoomPressed: Boolean;
    fZoomPressPos: TPoint;

    fAreaFind_Layer: TBitmap;
    fAreaFind_Active: Boolean;
    fAreaFind_Fixed: Boolean;

    procedure SetZoomPos(AX, AY: Integer);

    procedure SetEnableEdit(AEdit: TEdit; AValue: Boolean);

    { Private declarations }
  public

    function GetZoomRect(): TRect;

    procedure UpdateZoomInfo;
    procedure UpdateAreaFind;
    procedure UpdateImages;
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.SetZoomPos(AX: Integer; AY: Integer);
begin
  AX := EnsureRange(AX, imMainLayer.Left, imMainLayer.Left + imMainLayer.Width - spZoomArea.Width);
  AY := EnsureRange(AY, imMainLayer.Top, imMainLayer.Top + imMainLayer.Height - spZoomArea.Height);
  spZoomArea.Left := AX;
  spZoomArea.Top := AY;
end;

procedure TfmMain.SetEnableEdit(AEdit: TEdit; AValue: Boolean);
begin
  if AValue
  then AEdit.Color := clWindow
  else AEdit.Color := clBtnFace;

  AEdit.Enabled := AValue;
end;

function TfmMain.GetZoomRect;
var
  W: Integer;
begin
  W := spZoomArea.Pen.Width;
  Result := spZoomArea.BoundsRect;
  Result.Inflate(-W, -W);
end;

procedure TfmMain.UpdateZoomInfo;
begin
  lbSecond_AreaSize.Enabled := cbSecond_ToolsUse.Checked;
  spZoomArea.Visible := cbSecond_ToolsUse.Checked;
  SetEnableEdit(TEdit(seSecond_AreaSize), cbSecond_ToolsUse.Checked);

  if cbSecond_ToolsUse.Checked
  then begin
    spZoomArea.Left := spZoomArea.Left + spZoomArea.Width div 2;
    spZoomArea.Top := spZoomArea.Top + spZoomArea.Height div 2;
    spZoomArea.Width := spZoomArea.Pen.Width * 2 + seSecond_AreaSize.Value;
    spZoomArea.Height := spZoomArea.Width;
    spZoomArea.Left := spZoomArea.Left - spZoomArea.Width div 2;
    spZoomArea.Top := spZoomArea.Top - spZoomArea.Height div 2;
    SetZoomPos(spZoomArea.Left, spZoomArea.Top);
  end;

  UpdateAreaFind;
end;

procedure TfmMain.UpdateAreaFind;
begin
  cbAreaFind_Use.Enabled := cbSecond_ToolsUse.Checked;
  lbAreaFind_Desc.Enabled := cbSecond_ToolsUse.Checked;
  btAreaFind_Remember.Enabled := cbSecond_ToolsUse.Checked and cbAreaFind_Use.Checked and FAreaFind_Active;
  btAreaFind_Forget.Enabled := cbSecond_ToolsUse.Checked and cbAreaFind_Use.Checked and FAreaFind_Active;
  btAreaFind_Activate.Enabled := cbSecond_ToolsUse.Checked and cbAreaFind_Use.Checked;
  btAreaFind_Deactivate.Enabled := cbSecond_ToolsUse.Checked and cbAreaFind_Use.Checked;

  if (FAreaFind_Active and not cbAreaFind_Use.Checked)
    or not cbSecond_ToolsUse.Checked
  then begin
    fAreaFind_Active := false;
    fAreaFind_Fixed := false;
  end;

  btAreaFind_Activate.Visible := not FAreaFind_Active;
  btAreaFind_Deactivate.Visible := FAreaFind_Active;
  btAreaFind_Remember.Visible := not FAreaFind_Fixed;
  btAreaFind_Forget.Visible := FAreaFind_Fixed;
  SetEnableEdit(TEdit(seSecond_AreaSize), cbSecond_ToolsUse.Checked and not FAreaFind_Active);
  tAreaFind.Enabled := FAreaFind_Active and FAreaFind_Fixed;

  if FAreaFind_Active
  then begin
    fAreaFind_Layer.SetSize(spZoomArea.Width - spZoomArea.Pen.Width * 2, spZoomArea.Height - spZoomArea.Pen.Width * 2);
    fAreaFind_Layer.Canvas.CopyRect(Rect(0, 0, fAreaFind_Layer.Width, fAreaFind_Layer.Height),
                                    fMainLayer.Canvas,
                                    GetZoomRect());
  end;
end;

procedure TfmMain.btAreaFind_ActivateClick(Sender: TObject);
begin
  FAreaFind_Active := true;
  UpdateAreaFind;
end;

procedure TfmMain.btAreaFind_DeactivateClick(Sender: TObject);
begin
  FAreaFind_Active := false;
  UpdateAreaFind;
end;

procedure TfmMain.btAreaFind_ForgetClick(Sender: TObject);
begin
  fAreaFind_Fixed := false;
  UpdateAreaFind;
end;

procedure TfmMain.btAreaFind_RememberClick(Sender: TObject);
begin
  FAreaFind_Fixed := true;
  UpdateAreaFind;
end;

procedure TfmMain.cbAreaFind_UseClick(Sender: TObject);
begin
  UpdateAreaFind;
end;

procedure TfmMain.cbSecond_ToolsUseClick(Sender: TObject);
begin
  UpdateZoomInfo;
end;

procedure TfmMain.edMain_FocusControlEnter(Sender: TObject);
begin
  spMain_FocusIndicator.Visible := true;
end;

procedure TfmMain.edMain_FocusControlExit(Sender: TObject);
begin
  spMain_FocusIndicator.Visible := false;
end;

procedure TfmMain.edMain_FocusControlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  DX, DY, Scale: Integer;
begin
  Scale := 1;

  if (ssCtrl in Shift)
  then Scale := 10;

  DX := -Scale * Integer(Key = VK_LEFT) + Scale * Integer(Key = VK_RIGHT);
  DY := -Scale * Integer(Key = VK_UP) + Scale * Integer(Key = VK_DOWN);
  SetZoomPos(spZoomArea.Left + DX, spZoomArea.Top + DY);
end;

procedure TfmMain.edMain_FocusControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edMain_FocusControl.SetFocus;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FMainLayer := TBitmap.Create;
  FSecondLayer := TBitmap.Create;
  FSecondLayer.Width := imSecondLayer.Width;
  FSecondLayer.Height := imSecondLayer.Height;
  FAreaFind_Layer := TBitmap.Create;
  imSecondLayer.Picture.Bitmap := FSecondLayer;

  seSecond_AreaSize.Value := 8;
  UpdateZoomInfo;
  UpdateAreaFind;
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  FMainLayer.SetSize(imMainLayer.Width, imMainLayer.Height);
  imMainLayer.Picture.Bitmap := FMainLayer;
end;

procedure TfmMain.imMainLayerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  edMain_FocusControl.SetFocus;
end;

procedure TfmMain.seSecond_AreaSizeChange(Sender: TObject);
begin
  seSecond_AreaSize.Value := EnsureRange(seSecond_AreaSize.Value, 1,
                             Min(imMainLayer.Width, imMainLayer.Height));
  UpdateZoomInfo;
end;

procedure TfmMain.spMain_FocusIndicatorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edMain_FocusControl.SetFocus;
end;

procedure TfmMain.spZoomAreaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fZoomPressed := true;
  FZoomPressPos := Point(X, Y);
  edMain_FocusControl.SetFocus;
end;

procedure TfmMain.spZoomAreaMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if fZoomPressed
  then begin
    SetZoomPos(spZoomArea.Left + (X - fZoomPressPos.X),
               spZoomArea.Top + (Y - fZoomPressPos.Y));
  end;
end;

procedure TfmMain.spZoomAreaMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  fZoomPressed := false;
end;

procedure TfmMain.tAreaFindTimer(Sender: TObject);
begin
//
end;

procedure TfmMain.tRendererTimer(Sender: TObject);
begin
  UpdateImages;
end;

var
  FMatchWnd: HWND = 0;
  FClsName: Array [0..MAX_PATH - 1] of Char;

function EnumWindowsFunc(AWnd: HWND; lParam: LPARAM): Boolean; stdcall;
begin
  GetWindowTextW(AWnd, FClsName, MAX_PATH);
  Result := true;

  if (Pos('Gens -', FClsName) > 0) then
  begin
    FMatchWnd := AWnd;
    Result := false;
  end;
end;

procedure TfmMain.tWindowControllerTimer(Sender: TObject);
begin
  FMatchWnd := 0;
  EnumWindows(@EnumWindowsFunc, 0);
  fWnd := FMatchWnd;
  if IsWindow(FWnd) then
  begin
    DeleteDC(FDC);
    FDC := GetWindowDC(FWnd);
  end;
end;

procedure TfmMain.UpdateImages;
var
  WR, R: TRect;
begin
  if not IsWindow(FWnd)
  then Exit;

  Winapi.Windows.GetWindowRect(FWnd, WR);
  Winapi.Windows.GetClientRect(FWnd, R);
  BitBlt(FMainLayer.Canvas.Handle, 0, 0, FMainLayer.Width - 1, FMainLayer.Height - 1, FDC, 8, 50, SRCCOPY);
  imMainLayer.Canvas.Draw(0, 0, FMainLayer);

  if cbSecond_ToolsUse.Checked
  then begin
    imSecondLayer.Canvas.Pixels[0, 0] := clBlack;
    R := spZoomArea.BoundsRect;
    Winapi.Windows.StretchBlt(imSecondLayer.Canvas.Handle, 0, 0, imSecondLayer.Width - 1, imSecondLayer.Height - 1,
                              FMainLayer.Canvas.Handle, R.Left, R.Top, R.Width - spZoomArea.Pen.Width * 2, R.Height - spZoomArea.Pen.Width * 2, SRCCOPY)
  end;
end;

end.
