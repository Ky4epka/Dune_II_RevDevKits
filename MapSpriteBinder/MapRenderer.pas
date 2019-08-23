unit MapRenderer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Reaper;

type
  TCustomDrawCellMethod = procedure (Sender: TObject; ACanvas: TCanvas; ACellRect: TRect; ACell: TCell) of Object;

  TGUICell = class

  private
    fHovered: Boolean;
    fMatchBase: Boolean;
    fMatched: Boolean;
    fData: Pointer;

  public
    constructor Create;

    property Hovered: Boolean read fHovered write fHovered;
    property MatchBase: Boolean read fMatchBase write fMatchBase;
    property Matched: Boolean read fMatched write fMatched;
    property Data: Pointer read fData write fData;
  end;

  TMouseButtons = set of TMouseButton;
  TMouseButtonPositions = Array [TMouseButton] of TPoint;

  TfrMapRenderer = class(TFrame)
    pRenderer: TPanel;
    imRenderLayer: TImage;
    sbRendererHorz: TScrollBar;
    sbRendererVert: TScrollBar;
    tRenderer: TTimer;
    tInitResize: TTimer;
    procedure FrameResize(Sender: TObject);
    procedure tRendererTimer(Sender: TObject);
    procedure imRenderLayerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imRenderLayerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imRenderLayerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbRendererHorzChange(Sender: TObject);
    procedure FrameMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure tInitResizeTimer(Sender: TObject);
  private
    fRenderLayer: TBitmap;
    fHoveredCell: TCell;
    fPressedCell: TCell;
    fMouseButtons: TMouseButtons;
    fPressedButtonsPos: TMouseButtonPositions;
    fPressedViewportPos: TPoint;
    fViewport: TRect;
    fCurrentMap: TMap;
    fUseGrid: Boolean;
    fOnMouseDown: TMouseEvent;
    fOnMouseMove: TMouseMoveEvent;
    fOnMouseUp: TMouseEvent;
    fOnCustomDrawCell: TCustomDrawCellMethod;
    { Private declarations }

  protected
    procedure Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); virtual;
    procedure Renderer_OnMouseMove(Sender: TObject;
                                   Shift: TShiftState; X, Y: Integer); virtual;
    procedure Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); virtual;

    procedure MapChanged();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);

    procedure SetMapImage(AImage: TBitmap);
    procedure LoadMapImageFromFile(const AFileName: String);
    function CellAtPx(const APosition: TPoint): TCell;
    function ViewportCellRect(ACell: TCell): TRect;
    function IsCellInViewport(ACell: TCell): Boolean;

    procedure UpdateViewport;
    procedure RenderMap;

    property HoveredCell: TCell read fHoveredCell;
    property PressedCell: TCell read fPressedCell;
    property Viewport: TRect read fViewport;
    property Map: TMap read fCurrentMap;
    property MouseButtons: TMouseButtons read fMouseButtons;
    property PressedButtonPos: TMouseButtonPositions read fPressedButtonsPos;
    property PressedViewportPos: TPoint read fPressedViewportPos;
    property UseGrid: Boolean read fUseGrid write fUseGrid;
    property OnMouseDown: TMouseEvent read fOnMouseDown write fOnMouseDown;
    property OnMouseMove: TMouseMoveEvent read fOnMouseMove write fOnMouseMove;
    property OnMouseUp: TMouseEvent read fOnMouseUp write fOnMouseUp;
    property OnCustomDrawCell: TCustomDrawCellMethod read fOnCustomDrawCell write fOnCustomDrawCell;
  end;

implementation

{$R *.dfm}

constructor TGUICell.Create;
begin
  Inherited Create;
  fHovered := false;
end;

constructor TfrMapRenderer.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  fCurrentMap := TMap.Create;
  fRenderLayer := TBItmap.Create;
  fRenderLayer.HandleType := bmDIB;
  fRenderLayer.PixelFormat := pf24bit;
  imRenderLayer.Picture.Bitmap := fRenderLayer;
end;

procedure TfrMapRenderer.MapChanged;
var
  I, J: Integer;
  iCell: TCell;
begin
  for I := 0 to fCurrentMap.Size.cy - 1
  do for J := 0 to fCurrentMap.Size.cx - 1
     do begin
       iCell := fCurrentMap.Cell[TPoint.Create(J, I)];

       if Assigned(iCell.Data)
       then TGUICell(iCell.Data).Free;

       iCell.FreeDataOnDestroy := true;
       iCell.Data := TGUICell.Create;
     end;

  UpdateViewport;
  fPressedCell := nil;
  fHoveredCell := nil;
end;

procedure TfrMapRenderer.SetMapImage(AImage: TBitmap);
var
  I, J: Integer;
  iCell: TCell;
begin
  fCurrentMap.GraphicAnalog := AImage;

  MapChanged();
end;

procedure TfrMapRenderer.LoadMapImageFromFile(const AFileName: string);
var
  iBitmap: TBitmap;
begin
  iBitmap := TBitmap.Create;

  try
    iBitmap.LoadFromFile(AFileName);
    SetMapImage(iBitmap);
  finally
    iBitmap.Free;
  end;
end;

function TfrMapRenderer.CellAtPx(const APosition: TPoint): TCell;
var
  iPos: TPoint;
  iCPos: TPoint;
begin
  iPos := APosition + fViewport.Location;
  iCPos := TPoint.Create(iPos.X div CELL_SIZE, iPos.Y div CELL_SIZE);

  if fCurrentMap.IsValidPoint(iCPos)
  then Result := fCurrentMap.Cell[iCPos]
  else Result := nil;
end;

function TfrMapRenderer.ViewportCellRect(ACell: TCell): TRect;
begin
  Result := ACell.Rect;
  Result.Location := Result.Location - fViewport.Location;
end;

function TfrMapRenderer.IsCellInViewport(ACell: TCell): Boolean;
var
  iCellRect: TRect;
begin
  iCellRect := ViewportCellRect(ACell);

  Result := fViewport.IntersectsWith(iCellRect);
end;

procedure TfrMapRenderer.UpdateViewport;
var
  iDW, iDH: Integer;
begin
  fViewport.Size := TSize.Create(imRenderLayer.Width, imRenderLayer.Height);
  iDW := fCurrentMap.GraphicAnalog.Width - fViewport.Size.cx;
  iDH := fCurrentMap.GraphicAnalog.Height - fViewport.Size.cy;

  if (iDW > 0)
  then begin
    sbRendererHorz.Enabled := true;
    sbRendererHorz.Min := 0;
    sbRendererHorz.Max := iDW;
  end
  else begin
    sbRendererHorz.Enabled := false;
    sbRendererHorz.Min := 0;
    sbRendererHorz.Max := 1;
  end;

  if (iDH > 0)
  then begin
    sbRendererVert.Enabled := true;
    sbRendererVert.Min := 0;
    sbRendererVert.Max := iDH;
  end
  else begin
    sbRendererVert.Enabled := false;
    sbRendererVert.Min := 0;
    sbRendererVert.Max := 1;
  end;

  fViewport.Location := TPoint.Create(sbRendererHorz.Position, sbRendererVert.Position);
end;

procedure TfrMapRenderer.RenderMap;
var
  I: Integer;
  J: Integer;
  iCell: TCell;
  iCellRect: TRect;
  iRect: TRect;
  iText: String;
  iData: TGUICell;
begin
  imRenderLayer.Canvas.CopyRect(TRect.Create(0, 0, fViewport.Width, fViewport.Height),
                                fCurrentMap.GraphicAnalog.Canvas, fViewport);
  if fCurrentMap.IsEmpty
  then begin
    With imRenderLayer.Canvas do
    begin
      Pen.Style := psSolid;
      Pen.Color := clBlack;
      iRect := imRenderLayer.ClientRect;
      iText := 'Empty map';
      TextRect(iRect,
               iText,
               [tfVerticalCenter, tfCenter, tfSingleLine]);
    end;
  end
  else begin
    if (fUseGrid) then
    begin
      With imRenderLayer.Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Color := clBlack;
        Pen.Width := 1;

        for J := 0 to (fViewport.Width div CELL_SIZE + 2)
        do begin
          MoveTo(J * CELL_SIZE - fViewport.Location.X mod CELL_SIZE - 1, 0);
          LineTo(J * CELL_SIZE - fViewport.Location.X mod CELL_SIZE - 1, fViewport.Height);
          MoveTo(J * CELL_SIZE - fViewport.Location.X mod CELL_SIZE, 0);
          LineTo(J * CELL_SIZE - fViewport.Location.X mod CELL_SIZE, fViewport.Height);
        end;

        for I := 0 to (fViewport.Height div CELL_SIZE + 2)
        do begin
          MoveTo(0, I * CELL_SIZE - fViewport.Location.Y mod CELL_SIZE - 1);
          LineTo(fViewport.Width, I * CELL_SIZE - fViewport.Location.Y mod CELL_SIZE - 1);
          MoveTo(0, I * CELL_SIZE - fViewport.Location.Y mod CELL_SIZE);
          LineTo(fViewport.Width, I * CELL_SIZE - fViewport.Location.Y mod CELL_SIZE);
        end;
      end;
    end;

    for I := 0 to fCurrentMap.Size.cy - 1
    do for J := 0 to fCurrentMap.Size.cx - 1
    do begin
      iCell := fCurrentMap.Cell[TPoint.Create(J, I)];
      iCellRect := ViewportCellRect(iCell);

      With imRenderLayer.Canvas do
      begin
        if iCell.Ignore
        then begin
          Pen.Style := psSolid;
          Pen.Color := clRed;
          Pen.Width := 1;
          Brush.Style := bsClear;
          Rectangle(iCellRect);
        end
        else if Assigned(iCell.Data) then
        begin
          iData := TGUICell(iCell.Data);

          if (iData.Hovered)
          then begin
            Pen.Style := psSolid;
            Pen.Color := clYellow;
            Pen.Width := 1;
            Brush.Style := bsClear;
            Rectangle(iCellRect);
          end
          else if Assigned(fOnCustomDrawCell)
          then fOnCustomDrawCell(Self, imRenderLayer.Canvas, iCellRect, iCell);
        end;
      end;
    end;
  end;

end;


procedure TfrMapRenderer.sbRendererHorzChange(Sender: TObject);
begin
  UpdateViewport;
end;

procedure TfrMapRenderer.tInitResizeTimer(Sender: TObject);
begin
  FrameResize(Self);
  TTimer(Sender).Enabled := false;
end;

procedure TfrMapRenderer.tRendererTimer(Sender: TObject);
begin
  RenderMap;
end;

procedure TfrMapRenderer.FrameMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if (Shift = [ssShift])
  then sbRendererHorz.Position := sbRendererHorz.Position + CELL_SIZE * (-Abs(WheelDelta) div WheelDelta)
  else if (Shift = [])
  then sbRendererVert.Position := sbRendererVert.Position + CELL_SIZE * (-Abs(WheelDelta) div WheelDelta);
end;

procedure TfrMapRenderer.FrameResize(Sender: TObject);
begin
  UpdateViewport();
  fRenderLayer.SetSize(fViewport.Size.cx, fViewport.Size.cy);
  imRenderLayer.Picture.Bitmap.SetSize(fViewport.Size.cx, fViewport.Size.cy);
end;

procedure TfrMapRenderer.Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin

end;

procedure TfrMapRenderer.Renderer_OnMouseMove(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
begin

end;

procedure TfrMapRenderer.Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin

end;

procedure TfrMapRenderer.imRenderLayerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not Focused then
    SetFocus;

  SetCaptureControl(imRenderLayer);
  fPressedButtonsPos[Button] := TPoint.Create(X, Y);
  fPressedViewportPos := fViewport.Location;
  Include(fMouseButtons, Button);
  fPressedCell := CellAtPx(TPoint.Create(X, Y));

  case Button of
    TMouseButton.mbMiddle:
    begin
      Screen.Cursor := crSizeAll;
    end;
  end;

  Renderer_OnMouseDown(Sender, Button, Shift, X, Y);

  if Assigned(fOnMouseDown)
  then fOnMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TfrMapRenderer.imRenderLayerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  iCell: TCell;
begin
  if (mbMiddle in fMouseButtons)
  then begin
    sbRendererHorz.Position := fPressedViewportPos.X - (X - fPressedButtonsPos[mbMiddle].X);
    sbRendererVert.Position := fPressedViewportPos.Y - (Y - fPressedButtonsPos[mbMiddle].Y);
    Exit;
  end;

  iCell := CellAtPx(TPoint.Create(X, Y));

  if (iCell <> nil)
  then begin
    if (fHoveredCell <> nil) and
        Assigned(fHoveredCell.Data)
    then TGUICell(fHoveredCell.Data).Hovered := false;

    fHoveredCell := iCell;

    if (Assigned(fHoveredCell.Data))
    then TGUICell(fHoveredCell.Data).Hovered := true;
  end;

  Renderer_OnMouseMove(Sender, Shift, X, Y);

  if Assigned(fOnMouseMove)
  then fOnMouseMove(Sender, Shift, X, Y);
end;

procedure TfrMapRenderer.imRenderLayerMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
  SetCaptureControl(nil);
  Exclude(fMouseButtons, Button);

  Renderer_OnMouseUp(Sender, Button, Shift, X, Y);

  if Assigned(fOnMouseUp)
  then fOnMouseUp(Sender, Button, Shift, X, Y);
end;

end.
