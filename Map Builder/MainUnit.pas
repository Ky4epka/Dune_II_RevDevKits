unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.Menus,
  Vcl.ExtCtrls, ToolsUnit, System.Math, StickyWindowsManager, System.IniFiles,
  Vcl.StdActns, Vcl.StdCtrls, Vcl.ExtDlgs, JPEG, PNGImage, CommDlg, dlgs,
  FileCtrl, System.Actions;


const
  TOOL_WND_WIDTH_THREESHOLD = 20;

  DEBUG_INFO = true;

  APP_NAME        = 'MapBuilder';
  APP_NAME_MASK   = APP_NAME + '%s%s%s';

  MAP_FILE_EXT    = '.mf';
  MAP_FILE_FILTER = 'Map file (*.mf)|*.mf';

  MAP_EXPORT_FILE_FILTER = 'Bitmaps (*.bmp)|*.bmp|Portable Network Graphics (*.png)|*.png|JPEG Image File (*.jpg; *.jpeg)|*.jpg; *.jpeg';
  MAP_EXPORT_FILE_EXT_LIST: Array [0..2] of String = ('.bmp', '.png', '.jpg');


  DEFAULT_SEGMENTS_MAP_DIR = 'E:\Delphi Projects\Dune II\Maps\Result';
  DEFAULT_MAP_DIR = 'E:\Delphi Projects\Dune II\Maps\Result\Map builder';

  //DEFAULT_SEGMENTS_MAP_DIR = 'D:\Dune II\Maps\Result';
  //DEFAULT_MAP_DIR = 'D:\Dune II\Maps\Result\Map builder';

  DEFAULT_MAP_FILE_MASK = 'Map%d' + MAP_FILE_EXT;

  DESTINY_SET : Array [0..2] of String = ('Atreides', 'Ordos', 'Harkonnen');

  CFG_FILE_NAME = 'settings.cfg';

  WM_CLOSE_CHANGED = 'Сохранить изменения в "%s"?';

  MAP_NAVIGATE_DELTA           = 10;
  MAP_NAVIGATE_SHIFT_DELTA     = 50;

  SEL_NAVIGATE_DELTA           = 1;
  SEL_NAVIGATE_SHIFT_DELTA     = 10;

  INI_SEC_CFG_COMMON     = 'COMMON';

  INI_IDENT_CFG_LAST_MAP = 'LastMap';

  INI_SEC_SEGMENT_FORMAT = 'Segment%d';

  INI_IDENT_SEGMENT_IMAGE_FILE = 'ImageFile';
  INI_IDENT_SEGMENT_AUTOSIZE   = 'Autosize';
  INI_IDENT_SEGMENT_LEFT       = 'Left';
  INI_IDENT_SEGMENT_TOP        = 'Top';
  INI_IDENT_SEGMENT_WIDTH      = 'Width';
  INI_IDENT_SEGMENT_HEIGHT     = 'Height';
  INI_IDENT_SEGMENT_FIXED      = 'Fixed';

  INI_SEC_MAP_COMMON = 'MAP_COMMON';

  INI_IDENT_MAP_SEGMENT_COUNT = 'SegmentCount';
  INI_IDENT_MAP_LAYER_WIDTH   = 'LayerWidth';
  INI_IDENT_MAP_LAYER_HEIGHT  = 'LayerHeight';

type
  TMagnitiziedPos = (mpNone, mpLeft, mpRight);

  TMapLayer = class;
  TMapSegment = class

  private
  protected
    FMap: TMapLayer;
    FImage: TBitmap;
    FImageFile: String;
    FAutosize: Boolean;
    FBoundsRect: TRect;
    FFocused: Boolean;
    FSelected: Boolean;
    FHighlighted: Boolean;
    FFixed: Boolean;
    FChanged: Boolean;
    FViewPortChanged: Boolean;

    function GetPosition: TPoint;
    function GetSize: TSize;
    procedure SetAutosize(AValue: Boolean);
    procedure SetImage(AImage: TBitmap);
    procedure SetImageFile(const AFileName: String);
    procedure SetFocused(AValue: Boolean);
    procedure SetSelected(AValue: Boolean);
    procedure SetHighlighted(AValue: Boolean);
    procedure SetFixed(AValue: Boolean);
    procedure SetBoundsRect(ARect: TRect);
    procedure SetPosition(APos: TPoint);
    procedure SetSize(ASize: TSize);

  public
    constructor Create(AMap: TMapLayer);
    destructor Destroy; override;

    function HasChanges: Boolean;
    function HasViewportChanges: Boolean;

    procedure DrawTo(Canvas: TCanvas);
    procedure DrawControls(ACanvas: TCanvas; AMap: TMapLayer; AShowInfo: Boolean = false; ASelectIndex: Integer = -1);

    procedure SaveToMem(AMem: TMemIniFile; AIndex: Integer);
    procedure LoadFromMem(AMem: TMemIniFile; AIndex: INteger);

    property Autosize: Boolean read FAutosize write SetAutosize;
    property Image: TBitmap read FImage write SetImage;
    property ImageFile: String read FImageFIle write SetImageFile;
    property Changed: Boolean read HasChanges write FChanged;
    property ViewportChanged: Boolean read HasViewPortChanges write FChanged;
    property Focused: Boolean read FFocused write SetFocused;
    property Selected: Boolean read FSelected write SetSelected;
    property Highlighted: Boolean read FHighlighted write SetHighlighted;
    property Fixed: Boolean read FFixed write SetFixed;
    property BoundsRect: TRect read FBoundsRect write SetBoundsRect;
    property Position: TPoint read GetPosition write SetPosition;
    property Size: TSize read GetSize write SetSize;
  end;

  TMapLayer = class

  private
  protected
    FViewPort: TBitmap;
    FViewRect: TRect;
    FLayer: TBitmap;
    FSegments: TList;
    FPrioList: TList;
    FSelectList: TList;
    FHighlightList: TList;
    FFocusedSegment: TMapSegment;
    FShowSegmentInfo: Boolean;

    FScale: Single;
    FChanged: Boolean;
    FViewportChanged: Boolean;

    procedure SetChanged(AValue: Boolean);
    procedure SetViewportChanged(AValue: Boolean);

    procedure SetViewRect(const ARect: TRect);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure ClearSelection;
    procedure ClearHighlighted;

    procedure SetLayerSize(AWidth, AHeight: Integer);
    procedure CalcLayerSize;
    procedure SetShowSegmentInfo(AValue: Boolean);

    procedure AddSegment(ASegment: TMapSegment);
    procedure RemoveSegment(AIndex: Integer); overload;
    procedure RemoveSegment(ASegment: TMapSegment); overload;

    function NormalToScaled(AX, AY: Integer): TPointFloat; overload;
    function NormalToScaled(APos: TPoint): TPointFloat; overload;
    function ScaledToNormal(AX, AY: Single): TPoint; overload;
    function ScaledToNormal(APos: TPointFloat): TPoint; overload;
    function ScaledToIPoint(AX, AY: Single): TPoint; overload;
    function ScaledToIPoint(APos: TPointFloat): TPoint; overload;
    function AbsoluteToViewport(AX, AY: Integer): TPoint; overload;
    function AbsoluteToViewport(APos: TPoint): TPoint; overload;
    function ViewportToAbsolute(AX, AY: Integer): TPoint; overload;
    function ViewportToAbsolute(APos: TPoint): TPoint; overload;

    function SegmentIndex(ASegment: TMapSegment): Integer;
    function SegmentByIndex(AIndex: Integer): TMapSegment;
    function SegmentAt(AX, AY: Integer; AScaled, AWithViewport: Boolean): TMapSegment; overload;
    function SegmentAt(const APos: TPoint; AScaled, AWithViewport: Boolean): TMapSegment; overload;
    function SegmentInViewport(ASegment: TMapSegment): Boolean;

    function GetSelectedSegment(AIndex: Integer): TMapSegment;
    function GetHighlightedSegment(AIndex: INteger): TMapSegment;
    function GetSegmentCount: Integer;
    function GetSelectedCount: Integer;
    function GetHighlightedCount: Integer;

    function HasChanges: Boolean;
    function HasViewportChanges: Boolean;

    procedure SendSegmentToFront(ASegment: TMapSegment);
    procedure SendSegmentToBack(ASegment: TMapSegment);
    procedure SendSegmentBefore(ASegment, ABeforeSegment: TMapSegment);
    procedure SendSegmentAfter(ASegment, AAfterSegment: TMapSegment);

    procedure FocusSegment(ASegment: TMapSegment);
    procedure SelectSegment(ASegment: TMapSegment; AValue, AAdd: Boolean);
    procedure HighlightSegment(ASegment: TMapSegment; AValue, AAdd: Boolean);

    procedure OffsetSelected(DX, DY: Integer); overload;
    procedure OffsetSelected(const ADelta: TPoint); overload;

    procedure CombineHorizontal(ALeftSegment, ARightSegment: TMapSegment);
    procedure CombineVertical(ATopSegment, ABottomSegment: TMapSegment);

    function GetFirstSelected: TMapSegment;
    function GetLastSelected: TMapSegment;

    procedure Redraw();
    procedure RedrawViewport;
    procedure DrawTo(ACanvas: TCanvas; const ADestRect: TRect; const ASourcePoint: TPoint);

    procedure SaveToMem(AMem: TMemIniFile);
    procedure LoadFromMem(AMem: TMemIniFile);

    procedure SaveToFile(const AFileName: String);
    procedure LoadFromFile(const AFileName: String);

    property Changed: Boolean read HasChanges write SetChanged;
    property FirstSelected: TMaPSegment read GetFirstSelected;
    property ViewportChanged: Boolean read HasViewportChanges write SetViewportChanged;
    property ViewPort: TBitmap read FViewport;
    property ViewRect: TRect read FViewRect write SetViewRect;
    property Layer: TBitmap read FLayer;
    property LastSelected: TMapSegment read GetLastSelected;
    property Segments[AIndex: Integer]: TMapSegment read SegmentByIndex;
    property SegmentCount: Integer read GetSegmentCount;
    property Scale: Single read FScale write FScale;
    property SelectedSegment[AIndex: Integer]: TMapSegment read GetSelectedSegment;
    property SelectedCount: Integer read GetSelectedCount;
    property ShowSegmentInfo: Boolean read FShowSegmentInfo write SetShowSegmentInfo;
    property HighlightedSegment[AIndex: Integer]: TMapSegment read GetHighlightedSegment;
    property HighlightedCount: Integer read GetHighlightedCount;
    property FocusedSegment: TMapSegment read FFocusedSegment write FocusSegment;
  end;

  TMouseDown = Array [TMouseButton] of Boolean;
  TMousePos = Array [TMouseButton] of TPoint;
  TMouseAction = (maNone, maDown, maMove, maUp);

  TfmMain = class(TForm)
    imLayer: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    ActionList1: TActionList;
    N8: TMenuItem;
    N9: TMenuItem;
    tRenderer: TTimer;
    tInitializer: TTimer;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    aMap_Open: TAction;
    aMap_Close: TAction;
    aMap_Save: TAction;
    aMap_SaveAs: TAction;
    FileExit1: TFileExit;
    edLayer_Focus: TEdit;
    tNav: TTimer;
    N10: TMenuItem;
    aMap_ExportLayer: TAction;
    N11: TMenuItem;
    SavePictureDialog: TSavePictureDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tRendererTimer(Sender: TObject);
    procedure imLayerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imLayerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imLayerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure tInitializerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure aMap_OpenExecute(Sender: TObject);
    procedure aMap_CloseExecute(Sender: TObject);
    procedure aMap_SaveExecute(Sender: TObject);
    procedure aMap_SaveAsExecute(Sender: TObject);
    procedure edLayer_FocusEnter(Sender: TObject);
    procedure edLayer_FocusExit(Sender: TObject);
    procedure edLayer_FocusKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edLayer_FocusKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tNavTimer(Sender: TObject);
    procedure aMap_ExportLayerExecute(Sender: TObject);
    procedure SavePictureDialogTypeChange(Sender: TObject);
  private
    FLastMap: String;
    FMapLoaded: Boolean;
    FChanged: Boolean;
    FToolWndInitialized: Boolean;
    FToolWndMagnitizied: Boolean;
    FToolMagnitiziedPos: TMagnitiziedPos;
    FPosChanging: Boolean;
    FMouseDown: TMouseDown;
    FMousePos: TMousePos;
    FMouseDownPos: TMousePos;
    FMousePosDelta: TMousePos;
    FZoomUpdate: Boolean;
    FZoomUse: Boolean;
    FZoomRect: TRect;
    FZoomStep: Integer;
    FZoomDown: Boolean;

    FMap: TMapLayer;

    FStickyManager: TStickyManager;
    { Private declarations }

    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WndProc(var Msg: TMessage); override;

    function GetMouseDown(AMouseButton: TMouseButton): Boolean;
    procedure SetMouseDown(AMouseButton: TMouseButton; AValue: Boolean);


    procedure Handler_ToolsCallback(Sender: TObject; ACategory: TToolCategory; AData: Pointer; var AHandled: Boolean);
    procedure Handler_AppOnShortcut(var Msg: TWMKey; var Handled: Boolean);
    procedure Handler_AppOnMessage(var Msg: TMsg; var Handled: Boolean);

    procedure SendSegmentData(ASegment: TMapSegment);
    procedure SendZoomData();
    procedure SendCommonData();

    procedure UpdateSegmentData(AData: PSegmentData);
    procedure UpdateZoomData(AData: PZoomData);
    procedure UpdateCommonData(AData: PCommonData);

    procedure DoFocusSegment(ASegment: TMapSegment);
    procedure DoSelectSegment(ASegment: TMapSegment; AValue: Boolean);

    procedure DoCombineHorizontal();
    procedure DoCombineVertical();

    function DoAddSegment: TMapSegment;
    procedure DoDeleteSegment(ASegment: TMapSegment);

    procedure SetZoomUse(AValue: Boolean);
    procedure SetZoomRect( ARect: TRect);
    procedure SetZoomStep(AValue: Integer);

    procedure SetViewport(ARect: TRect);


    procedure SaveConfig;
    procedure LoadConfig;

    function GetDefaultMapFileName(): String;

    procedure UpdateUI;

    procedure NewMap;
    procedure LoadMapFromFile(const AFileName: String);
    procedure SaveMapToFile(const AFileName: String);
    function CloseMap: Boolean;

    procedure MapNavigate_Up(AShift: Boolean);
    procedure MapNavigate_Down(AShift: Boolean);
    procedure MapNavigate_Left(AShift: Boolean);
    procedure MapNavigate_Right(AShift: Boolean);

    procedure SelNavigate_Up(AShift: Boolean);
    procedure SelNavigate_Down(AShift: Boolean);
    procedure SelNavigate_Left(AShift: Boolean);
    procedure SelNavigate_Right(AShift: Boolean);

    procedure ExportLayerTo(const AFileName: String);

    procedure SetMapSize(ANewWidth, ANewHeight: Integer);
    procedure LoadSegmentMap;
    procedure CalcMapSize;
  public
    { Public declarations }

    procedure DrawDebugInfo;
    procedure DoMouseAction(AAction: TMouseAction; AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer);

    procedure UpdateToolWindowPos;

    property LastMap: String read FLastMap write FLastMap;
    property PosChanging: Boolean read FPosChanging;
    property ToolMagnitizied: Boolean read FToolWndMagnitizied write FToolWndMagnitizied;
    property ToolMagnitiziedPos: TMagnitiziedPos read FToolMagnitiziedPos write FToolMagnitiziedPos;
    property ToolWndInitialized: Boolean read FToolWndInitialized write FToolWndInitialized;
    property MouseDown[AMouseButton: TMouseButton]: Boolean read GetMouseDown write SetMouseDown;
    property StickyManager: TStickyManager read FStickyManager;
  end;

var
  fmMain: TfmMain = nil;

implementation

{$R *.dfm}

function DestinyIndex(const AString: String): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := Low(DESTINY_SET) to High(DESTINY_SET)
  do if (Pos(LowerCase(DESTINY_SET[I]), LowerCase(AString)) > 0)
     then Exit(I);
end;

constructor TMapSegment.Create;
begin
  Inherited Create;
  FMap := AMap;
  FImage := TBitmap.Create;
end;

destructor TMapSegment.Destroy;
begin
  FImage.Free;
  Inherited Destroy;
end;

function TMapSegment.GetPosition;
begin
  Result := FBoundsRect.TopLeft;
end;

function TMapSegment.GetSize;
begin
  Result := FBoundsRect.Size;
end;

procedure TMapSegment.SetAutosize(AValue: Boolean);
begin
  FAutosize := AValue;
  FViewPortChanged := true;

  BoundsRect := FBoundsRect;
end;

procedure TMapSegment.SetImage(AImage: TBitmap);
begin
  FImage.Assign(AImage);
  BoundsRect := FBoundsRect;
  FChanged := true;
  FViewportChanged := true;
end;

procedure TMapSegment.SetImageFile(const AFileName: string);
begin
  FImageFile := AFileName;
  FImage.LoadFromFile(AFileName);
  BoundsRect := FBoundsRect;
  FChanged := true;
  FViewportChanged := true;
end;

procedure TMapSegment.SetFocused(AValue: Boolean);
begin
  FViewPortChanged := FFocused <> AValue;
  FFocused := AValue;
end;

procedure TMapSegment.SetSelected(AValue: Boolean);
begin
  FViewportChanged := FSelected <> AValue;
  FSelected := AValue;
end;

procedure TMapSegment.SetHighlighted(AValue: Boolean);
begin
  FViewportChanged := FHighlighted <> AValue;
  FHighlighted := AValue;
end;

procedure TMapSegment.SetFixed(AValue: Boolean);
begin
  FViewportChanged := FFixed <> AValue;
  FFixed := AValue;
end;

procedure TMapSegment.SetBoundsRect(ARect: TRect);
begin
  if FFixed
  then Exit;

  FChanged := ARect <> FBoundsRect;
  FViewportChanged := FChanged;
  FBoundsRect := ARect;

  if FAutosize
  then begin
    FBoundsRect.Size := TSize.Create(FImage.Width, FImage.Height);
    FViewportChanged := true;
  end;

  //FBoundsRect.Left := EnsureRange(FBoundsRect.Left + FBoundsRect.Width, 0, FMap.Layer.Width - 1);
  //FBoundsRect.Top := EnsureRange(FBoundsRect.Top + FBoundsRect.Height, 0, FMap.Layer.Height - 1);
end;

procedure TMapSegment.SetPosition(APos: TPoint);
var
  R: TRect;
begin
  R := FBoundsRect;
  R.SetLocation(APos);
  SetBoundsRect(R);
end;

procedure TMapSegment.SetSize(ASize: TSize);
var
  R: TRect;
begin
  R := FBoundsRect;
  R.Size := ASize;
  SetBoundsRect(R);
end;

function TMapSegment.HasChanges;
begin
  Result := FChanged;
end;

function TMapSegment.HasViewportChanges;
begin
  Result := FViewPortChanged;
  FViewPortChanged := false;
end;

procedure TMapSegment.DrawTo(Canvas: TCanvas);
begin
  Canvas.Draw(FBoundsRect.Left, FBoundsRect.Top, FImage);
end;

procedure TMapSegment.DrawControls(ACanvas: TCanvas; AMap: TMapLayer; AShowInfo: Boolean = false; ASelectIndex: Integer = -1);
var
  BCol: TColor;
  PWidth, DX, DY: Integer;
  SR: TRect;
  iText: String;
begin
  BCol := clNone;
  PWidth := 0;

  if FFocused
  then begin
    BCol := RGB(255, 255, 255);
    PWidth := 1;

    With ACanvas do
    begin
      Brush.Style := bsClear;
      Pen.Style := psDot;
      Pen.Width := PWidth;
      Pen.Color := BCol;
      SR.TopLeft := AMap.AbsoluteToViewport(FBoundsRect.TopLeft);
      SR.BottomRight := AMap.AbsoluteToViewport(FBoundsRect.BottomRight);
      SR.Inflate(-3, -3);
      Rectangle(SR);
    end;
  end;

  if FFixed
  then begin
    BCol := clSilver;
    PWidth := 3;

    With ACanvas do
    begin
      Brush.Style := bsClear;
      Pen.Style := psSolid;
      Pen.Width := PWidth;
      Pen.Color := BCol;
      SR.TopLeft := AMap.AbsoluteToViewport(FBoundsRect.TopLeft);
      SR.BottomRight := AMap.AbsoluteToViewport(FBoundsRect.BottomRight);
      Rectangle(SR);
    end;
  end;

  if FHighlighted
  then begin
    BCol := clYellow;
    PWidth := 2;

    With ACanvas do
    begin
      Brush.Style := bsClear;
      Pen.Style := psSolid;
      Pen.Width := PWidth;
      Pen.Color := BCol;
      SR.TopLeft := AMap.AbsoluteToViewport(FBoundsRect.TopLeft);
      SR.BottomRight := AMap.AbsoluteToViewport(FBoundsRect.BottomRight);
      Rectangle(SR);
    end;
  end;


  if FSelected
  then begin
    BCol := RGB(0, 255, 0);
    PWidth := 1;

    With ACanvas do
    begin
      Brush.Style := bsClear;
      Pen.Style := psSolid;
      Pen.Width := PWidth;
      Pen.Color := BCol;
      SR.TopLeft := AMap.AbsoluteToViewport(FBoundsRect.TopLeft);
      SR.BottomRight := AMap.AbsoluteToViewport(FBoundsRect.BottomRight);
      Rectangle(SR);
    end;
  end;

  if AShowInfo then
  begin
    With ACanvas do
    begin
      SR.TopLeft := AMap.AbsoluteToViewport(FBoundsRect.TopLeft);
      SR.BottomRight := AMap.AbsoluteToViewport(FBoundsRect.BottomRight);
      Font.Color := clWhite;
      Font.Size := 12;
      Brush.Style := bsClear;
      Pen.Style := psClear;
      DX := SR.Left + 10;
      DY := SR.Top + 10;
      iText := ImageFile;
      TextOut(DX, DY, iText);

      DY := DY + 15;
      iText := Format('Size(%dx%d)', [Size.cx, Size.cy]);

      TextOut(DX, DY, iText);

      DY := DY + 15;
      iText := 'no';

      if Autosize
      then iText := 'yes';

      TextOut(DX, DY, Format('Autosize:  %s', [iText]));

      DY := DY + 15;
      iText := 'no';

      if Selected
      then iText := 'yes';

      TextOut(DX, DY, Format('Selected: %s', [iText]));

      DY := DY + 15;
      iText := Format('Pos(X: %d; Y: %d)', [Position.X, Position.Y]);

      TextOut(DX, DY, iText);

      DY := DY + 15;
      iText := 'no';

      if Focused
      then iText := 'yes';

      TextOut(DX, DY, Format('Focused:  %s', [iText]));

      DY := DY + 15;
      iText := 'no';

      if Highlighted
      then iText := 'yes';

      TextOut(DX, DY, Format('Highlighted: %s', [iText]));

      DY := DY + 15;
      iText := 'no';

      if Fixed
      then iText := 'yes';

      TextOut(DX, DY, Format('Fixed: %s', [iText]));

      if (ASelectIndex <> -1) then
      begin
        DX := SR.Left + SR.Size.cx div 2 - 10;
        DY := SR.Top + SR.Size.cy div 2 - 10;
        Font.Size := 20;
        TextOut(DX, DY, Format('%d', [ASelectIndex]));
      end;
    end;
  end;
end;

procedure TMapSegment.SaveToMem(AMem: TMemIniFile; AIndex: Integer);
var
  iSec: String;
begin
  iSec := Format(INI_SEC_SEGMENT_FORMAT, [AIndex]);

  AMem.WriteString(iSec, INI_IDENT_SEGMENT_IMAGE_FILE, ImageFile);
  AMem.WriteBool(iSec, INI_IDENT_SEGMENT_AUTOSIZE, Autosize);
  AMem.WriteInteger(iSec, INI_IDENT_SEGMENT_LEFT, BoundsRect.Left);
  AMem.WriteInteger(iSec, INI_IDENT_SEGMENT_TOP, BoundsRect.Top);
  AMem.WriteInteger(iSec, INI_IDENT_SEGMENT_WIDTH, BoundsRect.Width);
  AMem.WriteInteger(iSec, INI_IDENT_SEGMENT_HEIGHT, BoundsRect.Height);
  AMem.WriteBool(iSec, INI_IDENT_SEGMENT_FIXED, Fixed);
end;

procedure TMapSegment.LoadFromMem(AMem: TMemIniFile; AIndex: Integer);
var
  iSec: String;
  R: TRect;
begin
  iSec := Format(INI_SEC_SEGMENT_FORMAT, [AIndex]);

  ImageFile := AMem.ReadString(iSec, INI_IDENT_SEGMENT_IMAGE_FILE, ImageFile);
  Autosize := AMem.ReadBool(iSec, INI_IDENT_SEGMENT_AUTOSIZE, Autosize);
  R.Left := AMem.ReadInteger(iSec, INI_IDENT_SEGMENT_LEFT, BoundsRect.Left);
  R.Top := AMem.ReadInteger(iSec, INI_IDENT_SEGMENT_TOP, BoundsRect.Top);
  R.Width := AMem.ReadInteger(iSec, INI_IDENT_SEGMENT_WIDTH, BoundsRect.Width);
  R.Height := AMem.ReadInteger(iSec, INI_IDENT_SEGMENT_HEIGHT, BoundsRect.Height);
  BoundsRect := R;
  Fixed := AMem.ReadBool(iSec, INI_IDENT_SEGMENT_FIXED, Fixed);
end;


constructor TMapLayer.Create;
begin
  Inherited Create;
  FViewport := TBitmap.Create;
  FLayer := TBitmap.Create;
  FSegments := TList.Create;
  FPrioList := TList.Create;
  FSelectList := TList.Create;
  FHighlightList := TList.Create;
  FScale := 1;
end;

destructor TMapLayer.Destroy;
begin
  Clear;

  FHighlightList.Free;
  FSelectList.Free;
  FPrioList.Free;
  FSegments.Free;
  FLayer.Free;
  FViewport.Free;
  Inherited Destroy;
end;

procedure TMapLayer.Clear;
var
  I: Integer;
begin
  FChanged := FSegments.Count > 0;

  for I := 0 to FSegments.Count - 1
  do TMapSegment(FSegments[I]).Free;

  FSegments.Clear;
  FPrioList.Clear;
  FSelectList.Clear;
  FHighlightList.Clear;
end;

procedure TMapLayer.ClearSelection;
var
  I: Integer;
begin
  FChanged := FSelectList.Count > 0;

  for I := 0 to FSelectList.Count - 1
  do TMapSegment(FSelectList[I]).Selected := false;

  FSelectList.Clear;
end;

procedure TMapLayer.ClearHighlighted;
var
  I: Integer;
begin
  FChanged := FHighlightList.Count > 0;

  for I := 0 to FHighlightList.Count - 1
  do TMapSegment(FHighlightList[I]).Highlighted := false;

  FHighlightList.Clear;
end;

procedure TMapLayer.SetLayerSize(AWidth: Integer; AHeight: Integer);
begin
  FChanged := (FLayer.Width <> AWidth)
               or (FLayer.Height <> AHeight);
  FLayer.SetSize(AWidth, AHeight);
end;

procedure TMapLayer.CalcLayerSize;
var
  iSeg: TMapSegment;
  I, iMaxW, iMaxH: Integer;
begin
  iMaxW := 0;
  iMaxH := 0;

  for I := 0 to FSegments.Count - 1
  do begin
    iSeg := Segments[I];

    if (iSeg.Position.X + iSeg.Size.cx > iMaxW)
    then iMaxW := iSeg.Position.X + iSeg.Size.cx;

    if (iSeg.Position.Y + iSeg.Size.cy > iMaxH)
    then iMaxH := iSeg.Position.Y + iSeg.Size.cy;
  end;

  SetLayerSize(iMaxW, iMaxH);
end;

procedure TMapLayer.SetShowSegmentInfo(AValue: Boolean);
begin
  FViewportChanged := true;
  FShowSegmentInfo := AValue;
end;

procedure TMapLayer.SetChanged(AValue: Boolean);
var
  I: Integer;
begin
  FChanged := AValue;

  for I := 0 to FSegments.Count - 1
  do TMapSegment(FSegments[I]).Changed := AValue;
end;

procedure TMapLayer.SetViewportChanged(AValue: Boolean);
var
  I: Integer;
begin
  FViewportChanged := AValue;

  for I := 0 to FSegments.Count - 1
  do TMapSegment(FSegments[I]).ViewportChanged := AValue;
end;

procedure TMapLayer.SetViewRect(const ARect: TRect);
var
  sz: TSize;
begin
  sz := ARect.Size;
  sz.cx := EnsureRange(sz.cx, 0, FLayer.Width);
  sz.cy := EnsureRange(sz.cy, 0, FLayer.Height);
  FViewRect := ARect;
  FViewRect.Left := EnsureRange(FViewRect.Left, 0, FLayer.Width - 1 - sz.cx);
  FViewRect.Top := EnsureRange(FViewRect.Top, 0, FLayer.Height - 1 - sz.cy);
  FViewRect.Right := FViewRect.Left + sz.cx;
  FViewRect.Bottom := FViewRect.Top + sz.cy;
  FViewPort.SetSize(FViewRect.Width, FViewRect.Height);
  FViewportChanged := true;
end;

procedure TMapLayer.AddSegment(ASegment: TMapSegment);
begin
  if (FSegments.IndexOf(ASegment) = -1) then
  begin
    FSegments.Add(ASegment);
    FPrioList.Insert(0, ASegment);
    FChanged := true;
  end;
end;

procedure TMapLayer.RemoveSegment(AIndex: Integer);
var
  I: Integer;
begin
  if (AIndex < 0)
    or (AIndex >= FSegments.Count)
  then Exit;

  if (FSegments[AIndex] = FFocusedSegment)
  then FocusedSegment := nil;

  FPrioList.Remove(FSegments[AIndex]);
  FSelectList.Remove(FSegments[AIndex]);
  FHighlightList.Remove(FSegments[AIndex]);
  FSegments.Delete(AIndex);
  FChanged := true;
end;

procedure TMapLayer.RemoveSegment(ASegment: TMapSegment);
begin
  RemoveSegment(SegmentIndex(ASegment));
end;

function TMapLayer.NormalToScaled(AX: Integer; AY: Integer): TPointFloat;
begin
  Result.x := AX * FScale;
  Result.y := AY * FScale;
end;

function TMapLayer.NormalToScaled(APos: TPoint): TPointFloat;
begin
  Result := NormalToScaled(APos.X, APos.Y);
end;

function TMapLayer.ScaledToNormal(AX: Single; AY: Single): TPoint;
begin
  Result.X := 0;
  Result.Y := 0;

  if not IsZero(FScale, 0)
  then Result.X := Round(AX / FScale);

  if not IsZero(FScale, 0)
  then Result.Y := Round(AY / FScale);
end;

function TMapLayer.ScaledToNormal(APos: _POINTFLOAT): TPoint;
begin
  Result := ScaledToNormal(APos.x, APos.y);
end;

function TMapLayer.ScaledToIPoint(AX: Single; AY: Single): TPoint;
begin
  Result.X := Round(AX);
  Result.Y := Round(AY);
end;

function TMapLayer.ScaledToIPoint(APos: _POINTFLOAT): TPoint;
begin
  Result := ScaledToIPoint(APos.x, APos.y);
end;

function TMapLayer.AbsoluteToViewport(AX: Integer; AY: Integer): TPoint;
var
  fPt: TPointFloat;
begin
  fPt := NormalToScaled(AX, AY);
  Result := Point(Round(fPt.x), Round(fPt.y)) - FViewRect.TopLeft;
end;

function TMapLayer.AbsoluteToViewport(APos: TPoint): TPoint;
begin
  Result := AbsoluteToViewport(APos.X, APos.Y);
end;

function TMapLayer.ViewportToAbsolute(AX: Integer; AY: Integer): TPoint;
begin
  Result := ScaledToNormal(AX, AY) + FViewRect.TopLeft;
end;

function TMapLayer.ViewportToAbsolute(APos: TPoint): TPoint;
begin
  ViewportToAbsolute(APos.X, APos.Y);
end;

function TMapLayer.SegmentIndex(ASegment: TMapSegment): Integer;
begin
  Result := FSegments.IndexOf(ASegment);
end;

function TMapLayer.SegmentByIndex(AIndex: Integer): TMapSegment;
begin
  Result := FSegments[AIndex];
end;

function TMapLayer.SegmentAt(AX: Integer; AY: Integer; AScaled, AWithViewport: Boolean): TMapSegment;
var
  I: Integer;
  Seg: TMapSegment;
  Pos: TPoint;
begin
  Result := nil;
  if AScaled
  then Pos := ScaledToNormal(AX, AY)
  else Pos := Point(AX, AY);

  if AWithViewport
  then begin
    Pos := Point(Pos.X + FViewRect.Left, Pos.Y + FViewRect.Top);
  end;

  for I := 0 to FPrioList.Count - 1 do
  begin
    Seg := FPrioList[I];
    if Seg.BoundsRect.Contains(Pos)
    then begin
      Result := Seg;
      Exit;
    end;
  end;
end;

function TMapLayer.SegmentAt(const APos: TPoint; AScaled, AWithViewport: Boolean): TMapSegment;
begin
  Result := SegmentAt(APos.X, APos.Y, AScaled, AWithViewport);
end;

function TMapLayer.SegmentInViewport(ASegment: TMapSegment): Boolean;
var
  SR: TRect;
begin
  SR.TopLeft := ScaledToIPoint(NormalToScaled(ASegment.BoundsRect.TopLeft));
  SR.BottomRight := ScaledToIPoint(NormalToScaled(ASegment.BoundsRect.BottomRight));
  {( a.y < b.y1 || a.y1 > b.y || a.x1 < b.x || a.x > b.x1 )}
  Result := (ASegment.BoundsRect.Top < SR.Bottom)
         or (ASegment.BoundsRect.Bottom > SR.Top)
         or (ASegment.BoundsRect.Right < SR.Left)
         or (ASegment.BoundsRect.Left > SR.Right);
end;

function TMapLayer.GetSelectedSegment(AIndex: Integer): TMapSegment;
begin
  Result := FSelectList[AIndex];
end;

function TMapLayer.GetHighlightedSegment(AIndex: Integer): TMapSegment;
begin
  Result := FHighlightList[AIndex];
end;

function TMapLayer.GetSegmentCount;
begin
  Result := FSegments.Count;
end;

function TMapLayer.GetSelectedCount;
begin
  Result := FSelectList.Count;
end;

function TMapLayer.GetHighlightedCount;
begin
  Result := FHighlightList.Count;
end;

function TMapLayer.HasChanges;
var
  I: Integer;
begin
  Result := FChanged;

  if Result
  then Exit;

  for I := 0 to FSegments.Count - 1 do
  begin
    if TMapSegment(FSegments[I]).HasChanges
    then Exit(true);
  end;
end;

function TMapLayer.HasViewportChanges;
var
  I: Integer;
begin
  Result := FViewportChanged;

  if Result
  then Exit;

  for I := 0 to FSegments.Count - 1 do
  begin
    if TMapSegment(FSegments[I]).HasViewportChanges
    then Exit(true);
  end;
end;

procedure TMapLayer.SendSegmentToFront(ASegment: TMapSegment);
var
  I: Integer;
begin
  I := FPrioList.IndexOf(ASegment);
  if (I <> -1) then
  begin
    FChanged := true;
    FPrioList.Move(I, 0);
  end;
end;

procedure TMapLayer.SendSegmentToBack(ASegment: TMapSegment);
var
  I: Integer;
begin
  I := FPrioList.IndexOf(ASegment);
  if (I <> -1) then
  begin
    FChanged := true;
    FPrioList.Move(I, FPrioList.Count - 1);
  end;
end;

procedure TMapLayer.SendSegmentBefore(ASegment: TMapSegment; ABeforeSegment: TMapSegment);
var
  I, I2: Integer;
begin
  if not Assigned(ABeforeSegment)
  then SendSegmentToFront(ASegment)
  else begin
    I := FPrioList.IndexOf(ASegment);
    I2 := FPrioList.IndexOf(ABeforeSegment);

    if (I <> -1)
      and (I2 <> -1)
    then begin
      FChanged := true;
      FPrioList.Move(I, I2);
    end;
  end;
end;

procedure TMapLayer.SendSegmentAfter(ASegment: TMapSegment; AAfterSegment: TMapSegment);
var
  I, I2: Integer;
begin
  if not Assigned(AAfterSegment)
  then SendSegmentToFront(ASegment)
  else begin
    I := FPrioList.IndexOf(ASegment);
    I2 := FPrioList.IndexOf(AAfterSegment);

    if (I <> -1)
      and (I2 <> -1)
    then begin
      if (I2 < FPrioList.Count - 1) 
      then I2 := I2 + 1;

      FChanged := true;
      FPrioList.Move(I, I2);
    end;
  end;
end;

procedure TMapLayer.FocusSegment(ASegment: TMapSegment);
begin
  if Assigned(FFocusedSegment)
  then FFocusedSegment.Focused := false;

  FFocusedSegment := ASegment;

  if Assigned(ASegment)
  then ASegment.Focused := true;
end;

procedure TMapLayer.SelectSegment(ASegment: TMapSegment; AValue, AAdd: Boolean);
var
  I: Integer;
begin
  if not Assigned(ASegment)
  then Exit;

  ASegment.Selected := AValue;
  I := FSelectList.IndexOf(ASegment);

  if AValue
    and (I = -1)
  then
  begin
    if not AAdd
    then begin
      ClearSelection;
    end;

    FSelectList.Add(ASegment);
    FViewportChanged := true;
  end
  else if not AValue
    and (I <> -1)
  then
  begin
    FViewportChanged := true;
    FSelectList.Delete(I);
  end;
end;

procedure TMapLayer.HighlightSegment(ASegment: TMapSegment; AValue, AAdd: Boolean);
var
  I: Integer;
begin
  ASegment.Highlighted := AValue;
  I := FHighlightList.IndexOf(ASegment);

  if AValue
    and (I = -1)
  then
  begin
    if not AAdd
    then begin
      ClearHighlighted;
    end;

    FHighlightList.Add(ASegment);
    FViewportChanged := true;
  end
  else if not AValue
    and (I <> -1)
  then
  begin
    FViewportChanged := true;
    FHighlightList.Delete(I);
  end;
end;

procedure TMapLayer.OffsetSelected(DX: Integer; DY: Integer);
var
  I: Integer;
begin
  for I := 0 to FSelectList.Count - 1
  do SelectedSegment[I].Position := SelectedSegment[I].Position + Point(DX, DY);
end;

procedure TMapLayer.OffsetSelected(const ADelta: TPoint);
begin
  OffsetSelected(ADelta.X, ADelta.Y);
end;

function CombineImagesHorz(ALeftBitmap, ARightBitmap: TBitmap; ADeltaX: Integer): Integer;

  function ComparePixels(APixel1, APixel2: PRGBTriple): Boolean;
  begin
    Result :=     (APixel1.rgbtBlue = APixel2.rgbtBlue)
              and (APixel1.rgbtGreen = APixel2.rgbtGreen)
              and (APixel1.rgbtRed = APixel2.rgbtRed);
  end;

  function CompareColumn(ALLines, ARLines: TList; ACol: Integer): Boolean;
  var
    iRow: Integer;
    iLPxl, iRPxl: PRGBTriple;
  begin
    Result := true;

    for iRow := 0 to ALLines.Count - 1
    do begin
      iLPxl := PRGBTriple(Integer(ALLines[iRow]) + ACol * 3);
      iRPxl := PRGBTriple(Integer(ARLines[iRow]));

      if not ComparePixels(iLPxl, iRPxl)
      then Exit(false);
    end;
  end;

var
  I: Integer;
  iLLines: TList;
  iRLines: TList;
begin
  Result := ALeftBitmap.Width - 1;
  iLLines := TList.Create;
  iRLines := TList.Create;

  try
    for I := 0 to ALeftBitmap.Height - 1
    do begin
      iLLines.Add(ALeftBitmap.ScanLine[I]);
      iRLines.Add(ARightBitmap.ScanLine[I]);
    end;

    for I := ALeftBitmap.Width - 1 - ADeltaX downto 0
    do if CompareColumn(iLLines, iRLines, I)
       then begin
         Result := I;
         Exit;
       end;
  finally
    iLLines.Free;
    iRLines.Free;
  end;
end;

function CombineImagesVert(ATopBitmap, ABottomBitmap: TBitmap; ADeltaX: Integer): Integer;

  function ComparePixels(APixel1, APixel2: PRGBTriple): Boolean;
  begin
    Result :=     (APixel1.rgbtBlue = APixel2.rgbtBlue)
              and (APixel1.rgbtGreen = APixel2.rgbtGreen)
              and (APixel1.rgbtRed = APixel2.rgbtRed);
  end;

  function CompareRow(ATLines, ABLines: TList; ARow, AColCount: Integer): Boolean;
  var
    iCol: Integer;
    iLPxl, iRPxl: PRGBTriple;
  begin
    Result := true;

    for iCol := 0 to AColCount - 1
    do begin
      iLPxl := PRGBTriple(Integer(ATLines[ARow]) + iCol * 3);
      iRPxl := PRGBTriple(Integer(ABLines[0]) + iCol * 3);

      if not ComparePixels(iLPxl, iRPxl)
      then Exit(false);
    end;
  end;

var
  I: Integer;
  iTLines: TList;
  iBLines: TList;
begin
  Result := ATopBitmap.Height - 1;
  iTLines := TList.Create;
  iBLines := TList.Create;

  try
    for I := 0 to ATopBitmap.Height - 1
    do begin
      iTLines.Add(ATopBitmap.ScanLine[I]);
      iBLines.Add(ABottomBitmap.ScanLine[I]);
    end;

    for I := ATopBitmap.Height - 1 downto 0
    do if CompareRow(iTLines, iBLines, I, ATopBitmap.Width)
       then begin
         Result := I;
         Exit;
       end;
  finally
    iTLines.Free;
    iBLines.Free;
  end;
end;

procedure TMapLayer.CombineHorizontal(ALeftSegment: TMapSegment; ARightSegment: TMapSegment);
var
  DX: Integer;
  Pt: TPoint;
begin
  if (ALeftSegment.Position.Y <> ARightSegment.Position.Y)
    or (ARightSegment.Position.X >= ALeftSegment.Position.X + ALeftSegment.Size.cx)
  then DX := 0
  else DX := ALeftSegment.Size.cx + ALeftSegment.Position.X - ARightSegment.Position.X;

  if (DX < 0)
    or (ALeftSegment.Image.Height <> ARightSegment.Image.Height)
  then Exit;

  Pt := ALeftSegment.Position;
  Pt.X := ALeftSegment.Position.X + CombineImagesHorz(ALeftSegment.Image, ARightSegment.Image, DX + 1);
  ARightSegment.Position := Pt;
end;

procedure TMapLayer.CombineVertical(ATopSegment: TMapSegment; ABottomSegment: TMapSegment);
var
  DY: Integer;
  Pt: TPoint;
begin
  if (ATopSegment.Position.X <> ABottomSegment.Position.X)
  then DY := 0
  else DY := ABottomSegment.Position.Y - ATopSegment.Position.Y;

  if (DY < 0)
    or (ATopSegment.Image.Width <> ABottomSegment.Image.Width)
  then Exit;

  Pt := ATopSegment.Position;
  Pt.Y := ATopSegment.Position.Y + CombineImagesVert(ATopSegment.Image, ABottomSegment.Image, DY + 1);
  ABottomSegment.Position := Pt;
end;

function TMapLayer.GetFirstSelected;
begin
  Result := nil;

  if (FSelectList.Count > 0)
  then Result := FSelectList[0];
end;

function TMapLayer.GetLastSelected;
begin
  Result := nil;

  if (FSelectList.Count > 0)
  then Result := FSelectList[FSelectList.Count - 1];
end;

procedure TMapLayer.Redraw();
var
  I: Integer;
begin
  if HasChanges
  then begin
    With FLayer.Canvas do
    begin
      Pen.Color := clWhite;
      Pen.Style := psSolid;
      Brush.Color := clWhite;
      Brush.Style := bsSolid;
      Rectangle(0, 0, FLayer.Width - 1, FLayer.Height - 1);
    end;

    for I := 0 to FPrioList.Count - 1
    do TMapSegment(FPrioList[I]).DrawTo(FLayer.Canvas);

    Changed := false;
    FViewportChanged := true;
  end;
end;

procedure TMapLayer.RedrawViewport;
var
  iSeg: Integer;
  iSegment: TMapSegment;
begin
  if HasViewportChanges then
  begin
    DrawTo(FViewPort.Canvas, Rect(0, 0, FViewRect.Width - 1, FViewRect.Height - 1), FViewRect.TopLeft);

    for iSeg := 0 to FPrioList.Count - 1 do
    begin
      iSegment := FPrioList[iSeg];
      if SegmentInViewport(iSegment)
      then begin
        iSegment.DrawControls(FViewPort.Canvas, Self, FShowSegmentInfo, FSelectList.IndexOf(iSegment));
      end;
    end;

    ViewportChanged := false;
  end;
end;

procedure TMapLayer.DrawTo(ACanvas: TCanvas; const ADestRect: TRect; const ASourcePoint: TPoint);
var
  LT, RB: TPointFloat;
  iLT, iRB: TPoint;
  SR: TRect;
begin
  LT := NormalToScaled(ADestRect.TopLeft);
  RB := NormalToScaled(ADestRect.BottomRight);
  iLT.X := Round(LT.x);
  iLT.Y := Round(LT.y);
  iRB.X := Round(RB.x);
  iRB.Y := Round(RB.y);
  iLT.X := EnsureRange(iLT.X, 0, FLayer.Width - 1);
  iLT.Y := EnsureRange(iLT.Y, 0, FLayer.Height - 1);
  iRB.X := EnsureRange(iRB.X, 0, FLayer.Width - 1);
  iRB.Y := EnsureRange(iRB.Y, 0, FLayer.Height - 1);
  SR := Rect(iLT + ASourcePoint, iRB + ASourcePoint);
  StretchBlt(ACanvas.Handle, ADestRect.Left, ADestRect.Top, ADestRect.Width, ADestRect.Height,
             FLayer.Canvas.Handle, SR.Left, SR.Top, SR.Width, SR.Height, SRCCOPY);
  //ACanvas.CopyRect(ADestRect, FLayer.Canvas, Rect(iLT + ASourcePoint, iRB + ASourcePoint));
end;

procedure TMapLayer.SaveToMem(AMem: TMemIniFile);
var
  I: Integer;
begin
  AMem.WriteInteger(INI_SEC_MAP_COMMON, INI_IDENT_MAP_SEGMENT_COUNT, FSegments.Count);
  AMem.WriteInteger(INI_SEC_MAP_COMMON, INI_IDENT_MAP_LAYER_WIDTH, FLayer.Width);
  AMem.WriteInteger(INI_SEC_MAP_COMMON, INI_IDENT_MAP_LAYER_HEIGHT, FLayer.Height);

  for I := FPrioList.Count - 1 downto 0
  do begin
    TMapSegment(FPrioList[I]).SaveToMem(AMem, I);
  end;
end;

procedure TMapLayer.LoadFromMem(AMem: TMemIniFile);
var
  I, C, PrI, W, H: Integer;
  iSeg: TMapSegment;
begin
  Clear;
  C := AMem.ReadInteger(INI_SEC_MAP_COMMON, INI_IDENT_MAP_SEGMENT_COUNT, 0);
  W := AMem.ReadInteger(INI_SEC_MAP_COMMON, INI_IDENT_MAP_LAYER_WIDTH, FLayer.Width);
  H := AMem.ReadInteger(INI_SEC_MAP_COMMON, INI_IDENT_MAP_LAYER_Height, FLayer.Height);

  FLayer.SetSize(W, H);

  for I := C - 1 downto 0
  do begin
    iSeg := TMapSegment.Create(Self);
    iSeg.LoadFromMem(AMem, I);
    AddSegment(iSeg);
  end;
end;

procedure TMapLayer.SaveToFile(const AFileName: string);
var
  AMem: TMemIniFile;
begin
  AMem := TMemIniFile.Create(AFileName);
  try
    SaveToMem(AMem);
    AMem.UpdateFile;
  finally
    AMem.Free;
  end;
end;

procedure TMapLayer.LoadFromFile(const AFileName: string);
var
  AMem: TMemIniFile;
begin
  AMem := TMemIniFile.Create(AFileName);
  try
    LoadFromMem(AMem);
  finally
    AMem.Free;
  end;
end;

procedure TfmMain.WMWindowPosChanging(var Message: TWMWindowPosMsg);
begin
  if (Message.Msg = WM_WINDOWPOSCHANGING) then
  begin
    UpdateToolWindowPos;
  end;

  Inherited;
end;

procedure TfmMain.WndProc(var Msg: TMessage);
begin
  Inherited WndProc(Msg);
end;

function TfmMain.GetMouseDown(AMouseButton: TMouseButton): Boolean;
begin
  Result := FMouseDown[AMouseButton];
end;

procedure TfmMain.imLayerMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetCaptureControl(Sender as TControl);
  edLayer_Focus.SetFocus;
  MouseDown[Button] := true;
  DoMouseAction(maDown, Button, Shift, X, Y);
end;

procedure TfmMain.imLayerMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  DoMouseAction(maMove, mbLeft, Shift, X, Y);
end;

procedure TfmMain.imLayerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture;
  MouseDown[Button] := false;
  DoMouseAction(maUp, Button, Shift, X, Y);
end;

procedure TfmMain.SetMouseDown(AMouseButton: TMouseButton; AValue: Boolean);
begin
  FMouseDown[AMouseButton] := AValue;
end;

procedure TfmMain.Handler_ToolsCallback(Sender: TObject; ACategory: TToolCategory; AData: Pointer; var AHandled: Boolean);
begin
  case ACategory of
    tcSegment: UpdateSegmentData(AData);
    tcZoom: UpdateZoomData(AData);
    tcCommon: UpdateCommonData(AData);
  end;
end;

procedure TfmMain.Handler_AppOnShortcut(var Msg: TWMKey; var Handled: Boolean);
begin
end;

procedure TfmMain.Handler_AppOnMessage(var Msg: tagMSG; var Handled: Boolean);
begin
  case Msg.message of
    WM_KEYDOWN, WM_SYSKEYDOWN:
    begin
      case Msg.wParam of
        VK_MENU:
        begin
          Handled := true;
          FMap.ShowSegmentInfo := true;
        end;
      end;
    end;

    WM_KEYUP, WM_SYSKEYUP:
    begin
      case Msg.wParam of
        VK_MENU:
        begin
          Handled := true;
          FMap.ShowSegmentInfo := false;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.SendSegmentData;
var
  Data: TSegmentData;
begin
  Data.Zero;

  if Assigned(ASegment)
  then begin
    Data.Use := true;
    Data.Multiselect := FMap.SelectedCount > 1;
    Data.ImageFile := ASegment.ImageFile;
    Data.Position := ASegment.Position;
    Data.Size := ASegment.BoundsRect.Size;
    Data.Autosize := ASegment.Autosize;
    Data.Fixed := ASegment.Fixed;
    Data.MapBounds := Rect(0, 0, FMap.Layer.Width - 1, FMap.Layer.Height - 1);
  end;

  fmTools.SetData(tcSegment, @Data);
end;

procedure TfmMain.SendZoomData;
var
  Data: TZoomData;
begin
  Data.Zero;
  Data.Use := FMap.SegmentCount > 0;
  Data.Enabled := FZoomUse;
  Data.Layer := FMap.Layer;
  Data.Position := FZoomRect.TopLeft;
  Data.ZoomStep := FZoomStep;
  Data.MapBounds := Rect(0, 0, FMap.Layer.Width - 1, FMap.Layer.Height);

  fmTools.SetData(tcZoom, @Data);
end;

procedure TfmMain.SendCommonData;
var
  Data: TCommonData;
begin
  Data.Zero;
  Data.Size := TSize.Create(FMap.Layer.Width, FMap.Layer.Height);

  fmTools.SetData(tcCommon, @Data);
end;

procedure TfmMain.UpdateSegmentData(AData: PSegmentData);
var
  Seg: TMapSegment;
begin
  Seg := FMap.FocusedSegment;

  if Assigned(Seg)
  then begin
    if (Seg.ImageFile <> AData^.ImageFile)
    then Seg.ImageFile := AData^.ImageFile;

    if (Seg.Autosize <> AData^.Autosize)
    then Seg.Autosize := AData^.Autosize;

    if (Seg.Position <> AData^.Position)
    then Seg.Position := AData^.Position;

    if (Seg.Size <> AData^.Size)
    then Seg.Size := AData^.Size;

    if (Seg.Fixed <> AData^.Fixed)
    then Seg.Fixed := AData^.Fixed;
  end;

  if AData^.btAdd_Push then
  begin
    DoAddSegment;
  end;

  if AData^.btRemove_Push then
  begin
    DoDeleteSegment(Seg);
  end;

  if AData^.btSendToFront_Push then
  begin
    FMap.SendSegmentToFront(Seg);
  end;

  if AData^.btSendToBack_Push then
  begin
    FMap.SendSegmentToBack(Seg);
  end;

  if AData^.Multiselect and AData^.btSendBefore_Push and (FMap.SelectedCount > 1) then
  begin
    FMap.SendSegmentBefore(Seg, FMap.SelectedSegment[0]);
  end;

  if AData^.Multiselect and AData^.btSendAfter_Push and (FMap.SelectedCount > 1) then
  begin
    FMap.SendSegmentAfter(Seg, FMap.SelectedSegment[FMap.SelectedCount - 1]);
  end;

  if AData^.Multiselect and AData^.btCombine_Horz_Push and (FMap.SelectedCount > 1)
  then begin
    DoCombineHorizontal;
  end;

  if AData^.Multiselect and AData^.btCombine_Vert_Push and (FMap.SelectedCount > 1)
  then begin
    DoCombineVertical;
  end;
end;

procedure TfmMain.UpdateZoomData(AData: PZoomData);
var
  R: TRect;
begin
  FZoomUpdate := true;

  try
    SetZoomUse(AData^.Enabled);

    if AData^.Enabled then
    begin
      R.TopLeft := AData^.Position;
      R.Size := AData^.ZoomLayerSize;
      SetZoomRect(R);
      SetZoomStep(AData^.ZoomStep);
    end;
  finally
    FZoomUpdate := false;
  end;
end;

procedure TfmMain.UpdateCommonData(AData: PCommonData);
begin
  if    ((AData^.Size.cx <> 0)
    and (AData^.Size.cy <> 0))
    or (AData^.Size.cx <> FMap.Layer.Width)
    or (AData^.Size.cy <> FMap.Layer.Height)
  then FMap.SetLayerSize(AData^.Size.cx, AData^.Size.cy);

  if AData^.btLoadSegmentMap_Down then
  begin
    LoadSegmentMap;
  end;

  if AData^.btCalcMapSize_Down then
  begin
    CalcMapSize;
  end;
end;

procedure TfmMain.DoFocusSegment(ASegment: TMapSegment);
begin
  if Assigned(ASegment)
  then begin
    FMap.FocusSegment(ASegment);
    SendSegmentData(ASegment);
  end;
end;

procedure TfmMain.DoSelectSegment(ASegment: TMapSegment; AValue: Boolean);
begin
  if Assigned(ASegment)
  then begin
    FMap.SelectSegment(ASegment, AValue, true);
  end;
end;

procedure TfmMain.DoCombineHorizontal;
var
  I: Integer;
begin
  for I := 0 to FMap.SelectedCount - 2 do
  begin
    FMap.CombineHorizontal(FMap.SelectedSegment[I], FMap.SelectedSegment[I + 1]);
    FMap.SendSegmentBefore(FMap.SelectedSegment[I + 1], FMap.SelectedSegment[I]);
  end;
end;

procedure TfmMain.DoCombineVertical;
var
  I: Integer;
  Pt: TPoint;
begin
  if (FMap.SelectedCount < 2)
  then Exit;

  FMap.CombineVertical(FMap.SelectedSegment[0], FMap.SelectedSegment[1]);
  FMap.SendSegmentBefore(FMap.SelectedSegment[1], FMap.SelectedSegment[0]);

  for I := 2 to FMap.SelectedCount - 1 do
  begin
    Pt := FMap.SelectedSegment[I].Position;
    Pt.Y := FMap.SelectedSegment[1].Position.Y;
    FMap.SelectedSegment[I].Position := Pt;
    FMap.SendSegmentBefore(FMap.SelectedSegment[I], FMap.SelectedSegment[I - 1]);
  end;
end;

function TfmMain.DoAddSegment;
var
  Seg: TMapSegment;
  LastSeg: TMapSegment;
  Pt: TPoint;
begin
  Seg := TMapSegment.Create(FMap);

  if (FMap.SegmentCount > 0)
  then begin
    if (FMap.SelectedCount > 0)
    then LastSeg := FMap.LastSelected
    else LastSeg := FMap.Segments[FMap.SegmentCount - 1];

    Pt := LastSeg.Position + Point(LastSeg.Size.cx, 0);
  end
  else begin
    Pt := Point(0, 0);
    LastSeg := nil;
  end;

  Seg.Position := Pt;
  FMap.AddSegment(Seg);
  DoFocusSegment(Seg);
end;

procedure TfmMain.DoDeleteSegment(ASegment: TMapSegment);
begin
  FMap.RemoveSegment(ASegment);

  SendSegmentData(nil);
end;

procedure TfmMain.SetZoomUse(AValue: Boolean);
begin

  FZoomUse := AValue;
  SetZoomRect(FZoomRect);

  if FZoomUpdate
  then Exit;

  SendZoomData;
end;

procedure TfmMain.SetZoomRect( ARect: TRect);
begin
  FZoomRect.Size := ARect.Size;
  FZoomRect.Location := Point(EnsureRange(ARect.Location.X, 0, FMap.Layer.Width - 1 - FZoomRect.Width),
                              EnsureRange(ARect.Location.Y, 0, FMap.Layer.Height- 1 - FZoomRect.Height));

  if FZoomUpdate
  then Exit;

  SendZoomData;
end;

procedure TfmMain.SetZoomStep(AValue: Integer);
var
  Data: TZoomData;
begin
  Data.Zero;
  fmTools.GetData(tcZoom, @Data);
  FZoomStep := EnsureRange(AValue, Data.ZoomStepRange.X, Data.ZoomStepRange.Y);

  if FZoomUpdate
  then Exit;

  SendZoomData;
end;

procedure TfmMain.SetViewport(ARect: TRect);
var
  R: TRect;
begin
  FMap.ViewRect := ARect;

  R := FZoomRect;
  R.Location := Point(EnsureRange(FZoomRect.Location.X, ARect.Left, ARect.Right - FZoomRect.Width),
                      EnsureRange(FZoomRect.Location.Y, ARect.Top, ARect.Bottom - FZoomRect.Height));
  SetZoomRect(R);
end;

procedure TfmMain.SaveConfig;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(CFG_FILE_NAME);
  try
    Ini.WriteString(INI_SEC_CFG_COMMON, INI_IDENT_CFG_LAST_MAP, FLastMap);
  finally
    Ini.UpdateFile;
    Ini.Free;
  end;
end;

procedure TfmMain.LoadConfig;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(CFG_FILE_NAME);
  try
    FLastMap := Ini.ReadString(INI_SEC_CFG_COMMON, INI_IDENT_CFG_LAST_MAP, '');
  finally
    Ini.Free;
  end;
end;

function TfmMain.GetDefaultMapFileName: String;
var
  Sr: TSearchRec;
  iCounter: Integer;
  iFile: String;
  iDestinyIndex: Integer;
begin
  iCounter := 0;
  Result := IncludeTrailingPathDelimiter(DEFAULT_MAP_DIR) + Format(DEFAULT_MAP_FILE_MASK, [iCounter]);

  FindFirst(IncludeTrailingPathDelimiter(DEFAULT_MAP_DIR) + '*.*', faAnyFile, Sr);
  repeat
    if (SR.Name = '')
      or (SR.Name = '.')
      or (SR.Name = '..')
      or (SR.Attr and faDirectory = faDirectory)
      or (ExtractFileExt(SR.Name) <> MAP_FILE_EXT)
    then Continue;

    iFile := IncludeTrailingPathDelimiter(DEFAULT_MAP_DIR) + Format(DEFAULT_MAP_FILE_MASK, [iCounter]);

    if FileExists(iFile)
    then Inc(iCounter)
    else begin
      Result := iFile;
      Exit;
    end;
  until (FindNext(Sr) <> 0);
end;

procedure TfmMain.UpdateUI;
var
  iDelim: String;
  iMapFile : String;
  iChanged: String;
  iAppName: STring;
begin
  iDelim := ' - ';
  iMapFile := ExtractFileName(FLastMap);
  iChanged := '';

  if (FChanged)
  then iChanged := '*';

  iAppName := Format(APP_NAME_MASK, [iDelim, iMapFile, iChanged]);

  if (iAppName <> Caption)
  then Caption := iAppName;
end;

procedure TfmMain.NewMap;
begin
  FMap.Clear;
  FLastMap := GetDefaultMapFileName;
  UpdateUI;
end;

procedure TfmMain.LoadMapFromFile(const AFileName: string);
var
  S: String;
begin
  S := AFileName;
  CloseMap;
  FLastMap := S;
  FMap.LoadFromFile(AFileName);
  FMapLoaded := true;
  UpdateUI;
end;

procedure TfmMain.SaveMapToFile(const AFileName: string);
begin
  FLastMap := AFileName;
  FMap.SaveToFile(AFileName);
  FChanged := false;
  SaveConfig;
  UpdateUI;
end;

procedure TfmMain.SavePictureDialogTypeChange(Sender: TObject);
var
  iFile: String;
  iExt: String;
begin
  iFile := SavePictureDialog.FileName;
  iExt := ExtractFileExt(iFile);

  case SavePictureDialog.FilterIndex of
    1: ;
    2: iExt := '.bmp';
    3: iExt := '.jpg';
    4: iExt := '.png';
  end;

  iFile := ChangeFileExt(iFile, iExt);
  //SavePictureDialog.FileName := iFile;
  iFile := 'halo';
  SendMessage(GetParent(SavePictureDialog.Handle), CDM_SETCONTROLTEXT, edt1{edt1}, LPARAM(PChar(iFile)));
end;

procedure TfmMain.aMap_CloseExecute(Sender: TObject);
begin
  CloseMap;
end;

procedure TfmMain.aMap_ExportLayerExecute(Sender: TObject);
var
  iFile, iExt: String;
begin
  iFile := FLastMap;
  iExt := ExtractFileExt(iFile);

  Delete(iFile, Length(iFile) - Length(iExt) + 1, MaxInt);

  SavePictureDialog.Filter := MAP_EXPORT_FILE_FILTER;
  SavePictureDialog.InitialDir := ExtractFileDir(iFile);
  SavePictureDialog.FileName := ExtractFileName(iFile);

  if SavePictureDialog.Execute
  then begin
    iFile := SavePictureDialog.FileName;
    if (ExtractFileExt(iFile) = '')
    then iFile := iFile + MAP_EXPORT_FILE_EXT_LIST[SavePictureDialog.FilterIndex - 1];

    ExportLayerTo(iFile);
  end;
end;

procedure TfmMain.aMap_OpenExecute(Sender: TObject);
begin
  OpenDialog.Filter := MAP_FILE_FILTER;
  OpenDialog.InitialDir := ExtractFileDir(FLastMap);
  OpenDialog.FileName := ExtractFileName(FLastMap);

  if OpenDialog.Execute then
  begin
    LoadMapFromFile(OpenDialog.FileName);
  end;
end;

procedure TfmMain.aMap_SaveAsExecute(Sender: TObject);
begin
  if not ForceDirectories(ExtractFileDir(FLastMap))
  then FLastMap := ChangeFilePath(FLastMap, GetCurrentDir);

  SaveDialog.Filter := MAP_FILE_FILTER;
  SaveDialog.InitialDir := ExtractFileDir(FLastMap);
  SaveDialog.FileName := ExtractFileName(FLastMap);

  if SaveDialog.Execute then
  begin
    SaveMapToFile(SaveDialog.FileName);
  end;
end;

procedure TfmMain.aMap_SaveExecute(Sender: TObject);
begin
  if not FileExists(FLastMap)
  then begin
    aMap_SaveAs.Execute;
    Exit;
  end;

  SaveMapToFile(FLastMap);
end;

function TfmMain.CloseMap;
var
  dRes : Integer;
begin
  dRes := mrNo;

  if FChanged
  then dRes := MessageBox(0, PWideChar(Format(WM_CLOSE_CHANGED, [FLastMap])), APP_NAME, MB_YESNOCANCEL or MB_ICONQUESTION);

  if (dRes = mrYes)
  then aMap_Save.Execute;

  Result := not FChanged or (dRes <> mrCancel);
  NewMap;
  UpdateUI;
end;

procedure TfmMain.MapNavigate_Up(AShift: Boolean);
var
  R: TRect;
  D: TPoint;
begin
  if AShift
  then D := Point(0, -MAP_NAVIGATE_SHIFT_DELTA)
  else D := Point(0, -MAP_NAVIGATE_DELTA);

  R := FMap.ViewRect;
  R.Location := R.Location + D;
  SetViewport(R);
end;

procedure TfmMain.MapNavigate_Down(AShift: Boolean);
var
  R: TRect;
  D: TPoint;
begin
  if AShift
  then D := Point(0, MAP_NAVIGATE_SHIFT_DELTA)
  else D := Point(0, MAP_NAVIGATE_DELTA);

  R := FMap.ViewRect;
  R.Location := R.Location + D;
  SetViewport(R);
end;

procedure TfmMain.MapNavigate_Left(AShift: Boolean);
var
  R: TRect;
  D: TPoint;
begin
  if AShift
  then D := Point(-MAP_NAVIGATE_SHIFT_DELTA, 0)
  else D := Point(-MAP_NAVIGATE_DELTA, 0);

  R := FMap.ViewRect;
  R.Location := R.Location + D;
  SetViewport(R);
end;

procedure TfmMain.MapNavigate_Right(AShift: Boolean);
var
  R: TRect;
  D: TPoint;
begin
  if AShift
  then D := Point(MAP_NAVIGATE_SHIFT_DELTA, 0)
  else D := Point(MAP_NAVIGATE_DELTA, 0);

  R := FMap.ViewRect;
  R.Location := R.Location + D;
  SetViewport(R);
end;

procedure TfMMain.SelNavigate_Up(AShift: Boolean);
var
  D: TPoint;
begin
  if AShift
  then D := Point(0, -SEL_NAVIGATE_SHIFT_DELTA)
  else D := Point(0, -SEL_NAVIGATE_DELTA);

  FMap.OffsetSelected(D);
end;

procedure TfMMain.SelNavigate_Down(AShift: Boolean);
var
  D: TPoint;
begin
  if AShift
  then D := Point(0, SEL_NAVIGATE_SHIFT_DELTA)
  else D := Point(0, SEL_NAVIGATE_DELTA);

  FMap.OffsetSelected(D);
end;

procedure TfMMain.SelNavigate_Left(AShift: Boolean);
var
  D: TPoint;
begin
  if AShift
  then D := Point(-SEL_NAVIGATE_SHIFT_DELTA, 0)
  else D := Point(-SEL_NAVIGATE_DELTA, 0);

  FMap.OffsetSelected(D);
end;

procedure TfMMain.SelNavigate_Right(AShift: Boolean);
var
  D: TPoint;
begin
  if AShift
  then D := Point(SEL_NAVIGATE_SHIFT_DELTA, 0)
  else D := Point(SEL_NAVIGATE_DELTA, 0);

  FMap.OffsetSelected(D);
end;

procedure TfmMain.ExportLayerTo(const AFileName: string);
var
  iExt: String;
  iBmp: TBitmap;
  iJpg: TJPEGImage;
  iPng: TPNGImage;
begin
  iExt := LowerCase(ExtractFileExt(AFileName));

  if (iExt = '.bmp')
  then begin
    iBmp := FMap.Layer;
    iBmp.SaveToFile(AFileName);
  end
  else if (iExt = '.jpg')
    or (iExt = '.jpeg')
  then begin
    iJpg := TJPEGImage.Create;
    try
      iJpg.Assign(FMap.Layer);
      iJpg.SaveToFile(AFileName);
    finally
      iJpg.Free;
    end;
  end
  else if (iExt = '.png')
  then begin
    iPng := TPNGImage.Create;
    try
      iPng.Assign(FMap.Layer);
      iPng.SaveToFile(AFileName);
    finally
      iPng.Free;
    end;
  end;
end;

procedure TfmMain.SetMapSize(ANewWidth: Integer; ANewHeight: Integer);
begin
  FMap.SetLayerSize(ANewWidth, ANewHeight);
  SendCommonData;
end;

procedure TfmMain.LoadSegmentMap;
var
  iDir: String;
  iDirs: TStringList;
  iLines: TList;
  I: Integer;
  SR: TSearchRec;

  procedure CollectLines(const StartDir: String);
  var
    J: Integer;
  begin
    FindFirst(IncludeTrailingPathDelimiter(StartDir) + '*.*', faAnyFile, SR);
    repeat
      if (SR.Name = '')
        or (SR.Name = '.')
        or (SR.Name = '..')
        or (SR.Attr and faDirectory <> faDirectory)
      then Continue;

      iDirs.Add(IncludeTrailingPathDelimiter(StartDir) + SR.Name);
      iLines.Add(TStringList.Create);
    until (FindNext(SR) <> 0);

    for J := 0 to iDirs.Count - 1 do
    begin
      FindFirst(IncludeTrailingPathDelimiter(iDirs[J]) + '*.*', faAnyFile, SR);
      repeat
        if (SR.Name = '')
          or (SR.Name = '.')
          or (SR.Name = '..')
          or (SR.Attr and faDirectory = faDirectory)
          or (LowerCase(ExtractFileExt(SR.Name)) <> '.bmp')
        then Continue;

        TStringList(iLines[J]).Add(IncludeTrailingPathDelimiter(iDirs[J]) + SR.Name);
      until (FindNext(SR) <> 0);
    end;
  end;

  procedure ProcessLines(ALines: TList);
  var
    J, K, DX, DY, iMaxHeight, iMaxWidth: Integer;
    iList: TStringList;
    iSeg: TMapSegment;
  begin
    DX := 0;
    DY := 0;
    iMaxWidth := 0;

    for J := 0 to ALines.Count - 1
    do begin
      iList := ALines[J];
      DX := 0;
      iMaxHeight := 0;
      FMap.ClearSelection;

      K := iList.Count - 1;
      while (K >= 0) do
      begin
        if (Pos('10', iList[K]) > 0)
          or (Pos('11', iList[K]) > 0)
        then iList.Move(K, iList.Count - 1);

        Dec(K);
      end;

      for K := 0 to iList.Count - 1
      do begin
        iSeg := TMapSegment.Create(FMap);
        FMap.AddSegment(iSeg);
        iSeg.ImageFile := iList[K];

        if (iSeg.Image.Height > iMaxHeight)
        then iMaxHeight := iSeg.Image.Height;

        iSeg.Position := Point(DX, DY);
        iSeg.Autosize := true;
        Inc(DX, iSeg.Image.Width + 1);

        if (DX > iMaxWidth)
        then iMaxWidth := DX;

        FMap.SelectSegment(iSeg, true, true);
      end;

      DoCombineHorizontal;
      Inc(DY, iMaxHeight + 1);
    end;

    SetMapSize(iMaxWidth + 100, DY + 100);
  end;
begin
  iDir := DEFAULT_SEGMENTS_MAP_DIR;

  if SelectDirectory(iDir, [], 0)
  then begin
    CloseMap;
    iDirs := TStringList.Create;
    iLines := TList.Create;

    try
      CollectLines(iDir);
      ProcessLines(iLines);
    finally
      for I := 0 to iLines.Count - 1
      do TStringList(iLines[I]).Free;

      iLines.Free;
      iDirs.Free;
    end;
  end;
end;

procedure TfmMain.CalcMapSize;
begin
  FMap.CalcLayerSize;
end;

procedure TfmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SaveConfig;
  CanClose := CloseMap;
end;

procedure TfmMain.FormCreate(Sender: TObject);
var
  iSeg: TMapSegment;
  iBmp: TBitmap;
begin
  Application.OnShortCut := Handler_AppOnShortCut;
  Application.OnMessage := Handler_AppOnMessage;
  FStickyManager := TStickyManager.Create;
  FStickyManager.MainElement := Self;

  FMap := TMapLayer.Create;
  FMap.Scale := 1;
  FMap.SetLayerSize(2000, 2000);
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FMap.Free;
end;

procedure TfmMain.FormResize(Sender: TObject);
var
  sz: TSize;
  r: TRect;
begin
  sz.cx := imLayer.Width;
  sz.cy := imLayer.Height;
  r := FMap.ViewRect;
  r.Size := sz;
  FMap.ViewRect := r;

  if Assigned(imLayer.Picture.Bitmap)
  then begin
    imLayer.Picture.Bitmap.Width := sz.cx;
    imLayer.Picture.Bitmap.Height := sz.cy;
  end;
end;

procedure TfmMain.tInitializerTimer(Sender: TObject);
var
  ZoomData: TZoomData;
begin
  tInitializer.Enabled := false;
  fmTools.ToolCallback := Handler_ToolsCallback;

  LoadConfig;
  FChanged := false;

  if FileExists(FLastMap)
  then LoadMapFromFile(FLastMap)
  else NewMap;

  fmTools.GetData(tcZoom, @ZoomData);
  ZoomData.Zero;
  UpdateZoomData(@ZoomData);
  SendSegmentData(nil);
  SendZoomData;
  SendCommonData;
end;

procedure TfmMain.tNavTimer(Sender: TObject);
var
  iShift: Boolean;
begin
  if (tNav.Interval = 1)
  then tNav.Interval := 500
  else if (tNav.Interval = 500)
  then tNav.Interval := 64;

  iShift := GetKeyState(VK_SHIFT) < 0;

  if (GetKeyState(VK_UP) < 0)
  then if (GetKeyState(VK_CONTROL) < 0)
       then SelNavigate_Up(iShift)
       else MapNavigate_Up(iShift);

  if (GetKeyState(VK_DOWN) < 0)
  then if (GetKeyState(VK_CONTROL) < 0)
       then SelNavigate_Down(iShift)
       else MapNavigate_Down(iShift);

  if (GetKeyState(VK_LEFT) < 0)
  then if (GetKeyState(VK_CONTROL) < 0)
       then SelNavigate_Left(iShift)
       else MapNavigate_Left(iShift);

  if (GetKeyState(VK_RIGHT) < 0)
  then if (GetKeyState(VK_CONTROL) < 0)
       then SelNavigate_Right(iShift)
       else MapNavigate_Right(iShift);
end;

procedure TfmMain.tRendererTimer(Sender: TObject);
var
  R: TRect;
begin
  if (FMap.Changed)
  then FChanged := true;

  if FMapLoaded
  then begin
    FChanged := false;
    FMapLoaded := false;
  end;

  FMap.Redraw;

  if FMap.ViewportChanged
  then begin
    SendZoomData;
  end;

  FMap.RedrawViewport;
  imLayer.Canvas.Draw(0, 0, FMap.ViewPort);

  if FZoomUse then
  begin
    with imLayer.Canvas do begin
      R := FZoomRect;
      R.Location := FMap.AbsoluteToViewport(R.TopLeft);
      Pen.Style := psSolid;
      Pen.Color := clRed;
      Pen.Mode := pmCopy;
      Pen.Width := 1;
      Brush.Style := bsClear;
      Rectangle(R);

      Pen.Style := psSolid;
      Pen.Color := clRed;
      Pen.Mode := pmNot;
      Pen.Width := 1;
      Brush.Style := bsClear;
      R.Inflate(1, 1);
      Rectangle(R);
    end;
  end;

  DrawDebugInfo;
  UpdateUI;
end;

procedure TfmMain.DrawDebugInfo;
var
  TX, TY: Integer;
begin
  if not DEBUG_INFO
  then Exit;

  with imLayer.Canvas do begin
    Font.Color := clWhite;
    Font.Size := 10;
    Pen.Style := psSolid;
    Pen.Color := clBlack;
    Brush.Style := bsClear;

    TX := 25;
    TY := 25;

    TextOut(TX, TY, Format('SegCount: %d', [FMap.SegmentCount]));
    Inc(TY, 20);
    TextOut(TX, TY, Format('SelectedCount: %d', [FMap.SelectedCount]));
    Inc(TY, 20);
    TextOut(TX, TY, Format('HighlightedCount: %d', [FMap.HighlightedCount]));
    Inc(TY, 20);
    TextOut(TX, TY, Format('Viewport: x: %d y: %d w: %d h: %d', [FMap.FViewRect.Left, FMap.FViewRect.Top, FMap.FViewRect.Width, FMap.FViewRect.Height]));
    Inc(TY, 20);
    TextOut(TX, TY, Format('MousePos: x: %d; y: %d', [FMousePos[mbLeft].X, FMousePos[mbLeft].Y]));
    Inc(TY, 20);
    TextOut(TX, TY, Format('MouseDeltaPos: x: %d; y: %d', [FMousePosDelta[mbLeft].X, FMousePosDelta[mbLeft].Y]));
  end;
end;

procedure TfmMain.edLayer_FocusEnter(Sender: TObject);
begin
//
end;

procedure TfmMain.edLayer_FocusExit(Sender: TObject);
begin
//
end;

procedure TfmMain.edLayer_FocusKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN]) and not tNav.Enabled
  then begin
    tNav.Interval := 1;
    tNav.Enabled := true;
  end;
end;

procedure TfmMain.edLayer_FocusKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key in [VK_LEFT, VK_RIGHT, VK_UP, VK_DOWN])
  then tNav.Enabled := false;
end;

procedure TfmMain.DoMouseAction(AAction: TMouseAction; AButton: TMouseButton; AShift: TShiftState; AX, AY: Integer);
var
  Seg: TMapSegment;
  R: TRect;
  sz: TSize;
begin
  if (AAction <> maMove)
  then FMouseDown[AButton] := AAction = maDown;

  if (AAction = maDown)
  then FMouseDownPos[AButton] := Point(AX, AY);

  if (FMousePos[mbLeft].X = 0) and (FMousePos[mbLeft].Y = 0)
  then begin
    FMousePosDelta[mbLeft] := Point(0, 0);
  end
  else FMousePosDelta[mbLeft] := Point(AX, AY) - FMousePos[mbLeft];

  FMousePosDelta[mbMiddle] := fMousePosDelta[mbLeft];
  FMousePosDelta[mbRight] := fMousePosDelta[mbLeft];

  FMousePos[mbLeft] := Point(AX, AY);
  FMousePos[mbMiddle] := FMousePos[mbLeft];
  FMousePos[mbRight] := FMousePos[mbLeft];

  case AAction of
    maNone: ;
    maDown:
    begin
      case AButton of
        TMouseButton.mbLeft:
        begin
          if ssCtrl in AShift then
          begin

          end
          else if FZoomUse and FZoomRect.Contains(FMap.ViewportToAbsolute(AX, AY))
          then begin
            FZoomDown := true;
          end
          else begin
            Seg := FMap.SegmentAt(AX, AY, true, true);

            if Assigned(Seg)
            then begin
              if (ssDouble in AShift)
              then DoSelectSegment(Seg, not Seg.Selected);

              DoFocusSegment(Seg);
            end;
          end;
        end;

        TMouseButton.mbRight:
        begin
          FMap.ClearSelection;
        end;

        TMouseButton.mbMiddle:
        begin
          Screen.Cursor := crSize;
        end;
      end;
    end;

    maMove:
    begin
      if FMouseDown[mbMiddle]
      then begin
        R := FMap.ViewRect;
        R.Location := R.Location - FMousePosDelta[mbMiddle];
        SetViewport(R);
      end;

      if FMouseDown[mbLeft] then
      begin
          if ssCtrl in AShift then
          begin
            FMap.OffsetSelected(FMousePosDelta[mbLeft]);
          end
          else if FZoomUse and (FZoomRect.Contains(FMap.ViewportToAbsolute(AX, AY)) or FZoomDown)
          then begin
            R := FZoomRect;
            R.Location := R.Location + FMousePosDelta[mbLeft];
            SetZoomRect(R);
          end;
      end;

     { Seg := FMap.SegmentAt(AX, AY, true, true);

      if Assigned(Seg)
      then begin
        FMap.HighlightSegment(Seg, true, false);
      end;

      if (FMap.HighlightedCount > 0) and (FMap.HighlightedSegment[0] <> Seg)
      then FMap.HighlightSegment(FMap.HighlightedSegment[0], false, false);}
    end;

    maUp:
    begin
      case AButton of
        TMouseButton.mbLeft:
        begin
          FZoomDown := false;
        end;

        TMouseButton.mbRight:
        begin

        end;

        TMouseButton.mbMiddle:
        begin
          Screen.Cursor := crDefault;
        end;
      end;
    end;
  end;
end;

procedure TfmMain.UpdateToolWindowPos;
begin
  if not Assigned(FStickyManager)
  then Exit;

  FPosChanging := true;
  FStickyManager.ProcessMainElement;
  FPosChanging := false;
end;

end.
