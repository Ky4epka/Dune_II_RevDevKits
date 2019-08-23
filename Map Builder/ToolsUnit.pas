unit ToolsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, StickyWindowsManager,
  Vcl.ComCtrls, Vcl.StdCtrls, System.Math, Vcl.ExtDlgs;

type
  TToolCategory = (tcSegment, tcZoom, tcCommon);

  TToolCallback = procedure (Sender: TObject; ACategory: TToolCategory; AData: Pointer; var AHandled: Boolean) of object;

  PSegmentData = ^TSegmentData;
  TSegmentData = record

  private
    FUse: Boolean;
    FMultiselect: Boolean;
    FImageFile: String;
    FPosition: TPoint;
    FSize: TSize;
    FAutosize: Boolean;
    FFixed: Boolean;

    FbtAdd_Push: Boolean;
    FbtRemove_Push: Boolean;

    FbtSendToFront_Push: Boolean;
    FbtSendToBack_Push: Boolean;
    FbtSendBefore_Push: Boolean;
    FbtSendAfter_Push: Boolean;

    FbtCombine_Horz_Push: Boolean;
    FbtCombine_Vert_Push: Boolean;

    FMapBounds: TRect;
  public
    constructor Create(AUse: Boolean; const AImageFile: String; const APosition: TPoint; const ASize: TSize;
                       AAutosize: Boolean; AFixed: Boolean; AMapBounds: TRect); overload;
    constructor Create(AData: PSegmentData); overload;

    procedure Assign(AData: PSegmentData);
    procedure Zero;

    property Use: Boolean read FUse write FUse;
    property Multiselect: Boolean read FMultiselect write FMultiselect;
    property ImageFile: String read FImageFile write FImageFile;
    property Position: TPoint read FPosition write FPosition;
    property Size: TSize read FSize write FSize;
    property Autosize: Boolean read FAutosize write FAutosize;
    property Fixed: Boolean read FFixed write FFixed;
    property MapBounds: TRect read FMapBounds write FMapBounds;

    property btAdd_Push: Boolean read FbtAdd_Push write FbtAdd_Push;
    property btRemove_Push: Boolean read FbtRemove_Push write FbtRemove_Push;

    property btSendToFront_Push: Boolean read FbtSendToFront_Push write FbtSendToFront_Push;
    property btSendToBack_Push: Boolean read FbtSendToBack_Push write FbtSendToBack_Push;
    property btSendBefore_Push: Boolean read FbtSendBefore_Push write FbtSendBefore_Push;
    property btSendAfter_Push: Boolean read FbtSendAfter_Push write FbtSendAfter_Push;

    property btCombine_Horz_Push: Boolean read FbtCombine_Horz_Push write FbtCombine_Horz_Push;
    property btCombine_Vert_Push: Boolean read FbtCombine_Vert_Push write FbtCombine_Vert_Push;
  end;

  PZoomData = ^TZoomData;
  TZoomData = record

  private
    FUse: Boolean;
    FEnabled: Boolean;
    FLayer: TBitmap;
    FZoomStep: Integer;
    FZoomStepRange: TPoint;
    FPosition: TPoint;
    FZoomLayerSize: TSize;
    FMapBounds: TRect;
  public
    constructor Create(AUse: Boolean; AEnabled: Boolean; ALayer: TBitmap;
                       AZoomStep: Integer; const APosition: TPoint;
                       const AZoomLayerSize: TSize; const AMapBounds: TRect); overload;
    constructor Create(AData: PZoomData); overload;

    procedure Assign(AData: PZoomData);

    procedure Zero;

    property Use: Boolean read FUse write FUse;
    property Enabled: Boolean read FEnabled write FEnabled;
    property Layer: TBitmap read FLayer write FLayer;
    property ZoomStep: Integer read FZoomStep write FZoomStep;
    property ZoomStepRange: TPoint read FZoomStepRange write FZoomStepRange;
    property Position: TPoint read FPosition write FPosition;
    property ZoomLayerSize: TSize read FZoomLayerSize write FZoomLayerSize;
    property MapBounds: TRect read FMapBounds write FMapBounds;
  end;

  PCommonData = ^TCommonData;
  TCommonData = record
  private
    FSize: TSize;

    FbtLoadSegmentMap_Down: Boolean;
    FbtCalcMapSize_Down: Boolean;
  public
    constructor Create(AData: PCommonData);

    procedure Assign(AData: PCommonData);

    procedure Zero;

    property Size: TSize read FSize write FSize;
    property btLoadSegmentMap_Down: Boolean read FbtLoadSegmentMap_Down write FbtLoadSegmentMap_Down;
    property btCalcMapSize_Down: Boolean read FbtCalcMapSize_Down write FbtCalcMapSize_Down;
  end;

  TButtonPushed = (bpAddSegment, bpRemoveSegment, bpSendToFront, bpSendToBack,
                   bpSendBefore, bpSendAfter, bpCombineHorz, bpLoadSegmentMap,
                   bpCombineVert, bpCalcMapSize);

  TButtonsPushed = set of TButtonPushed;

  TfmTools = class(TForm)
    pcTools: TPageControl;
    tsSegmentInfo: TTabSheet;
    tsZoom: TTabSheet;
    gbImage: TGroupBox;
    gbPosition: TGroupBox;
    gbModificators: TGroupBox;
    pLayer: TPanel;
    imLayer: TImage;
    pLayerTools: TPanel;
    edLayerPath: TEdit;
    btLayerPathSelect: TButton;
    edPosition_X: TEdit;
    lbPosition_X: TLabel;
    edPosition_Y: TEdit;
    lbPosition_Y: TLabel;
    udPosition_X: TUpDown;
    udPosition_Y: TUpDown;
    lbPosition_Width: TLabel;
    lbPosition_Height: TLabel;
    edPosition_Width: TEdit;
    udPosition_Width: TUpDown;
    edPosition_Height: TEdit;
    udPosition_Height: TUpDown;
    cbPosition_AutoSize: TCheckBox;
    cbModificators_Fixed: TCheckBox;
    gbZoomLayer: TGroupBox;
    imZoomLayer: TImage;
    tbZoomScale: TTrackBar;
    pZoomScale_Labels: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbZoom_Enable: TCheckBox;
    gbZoomPosition: TGroupBox;
    lbZoomPosition_X: TLabel;
    edZoomPosition_X: TEdit;
    edZoomPosition_Y: TEdit;
    lbZoomPosition_Y: TLabel;
    udZoomPosition_X: TUpDown;
    udZoomPosition_Y: TUpDown;
    tsCommonInfo: TTabSheet;
    gbSegControl: TGroupBox;
    btSegAdd: TButton;
    btSegRemove: TButton;
    GroupBox1: TGroupBox;
    btSeg_SendToFront: TButton;
    btSeg_SendToBack: TButton;
    btSeg_SendBefore: TButton;
    btSeg_SendAfter: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    gbCombine: TGroupBox;
    btCombine_Horz: TButton;
    gbMap: TGroupBox;
    edMap_Width: TEdit;
    lbMap_Width: TLabel;
    udMap_Width: TUpDown;
    edMap_Height: TEdit;
    udMap_Height: TUpDown;
    lbMap_Height: TLabel;
    btLoadSegmentMap: TButton;
    btCombine_Vert: TButton;
    btCalcMapSize: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edLayerPathChange(Sender: TObject);
    procedure udPosition_XChanging(Sender: TObject; var AllowChange: Boolean);
    procedure cbPosition_AutoSizeClick(Sender: TObject);
    procedure cbZoom_EnableClick(Sender: TObject);
    procedure tbZoomScaleChange(Sender: TObject);
    procedure udZoomPosition_XChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure edZoomPosition_XChange(Sender: TObject);
    procedure btSegAddClick(Sender: TObject);
    procedure btSegRemoveClick(Sender: TObject);
    procedure btSeg_SendToFrontClick(Sender: TObject);
    procedure btSeg_SendToBackClick(Sender: TObject);
    procedure btSeg_SendBeforeClick(Sender: TObject);
    procedure btSeg_SendAfterClick(Sender: TObject);
    procedure btLayerPathSelectClick(Sender: TObject);
    procedure btCombine_HorzClick(Sender: TObject);
    procedure edMap_WidthChange(Sender: TObject);
    procedure udMap_WidthChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btLoadSegmentMapClick(Sender: TObject);
    procedure btCombine_VertClick(Sender: TObject);
    procedure btCalcMapSizeClick(Sender: TObject);
  private
    FButtonPushed: Array [TButtonPushed] of Boolean;

    FStickyElement: TStickyElement;

    FUIUpdating: Boolean;
    FData: Array [TToolCategory] of Pointer;
    FCallback: TToolCallback;

    FZoomLayer: TBitmap;
    { Private declarations }

    procedure WMWindowPosChanging(var Message: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WndProc(var Msg: TMessage); override;

    procedure AssignDataTo(ACategory: TToolCategory; ASource, ADestination: Pointer);

    procedure UpdateSegmentCategory;
    procedure UpdateZoomCategory;
    procedure UpdateCommonCategory;

    procedure UpdateCategory(ACategory: TToolCategory);

    procedure CollectSegmentCategory;
    procedure CollectZoomCategory;
    procedure CollectCommonCategory;

    procedure CollectCategory(ACategory: TToolCategory);


    procedure ResetPushButtons;
  public
    { Public declarations }


    procedure SetData(ACategory: TToolCategory; AData: Pointer);
    procedure GetData(ACategory: TToolCategory; AData: Pointer);

    property ToolCallback: TToolCallback read FCallback write FCallback;
  end;

var
  fmTools: TfmTools = nil;

implementation

uses
  MainUnit;

{$R *.dfm}

constructor TSegmentData.Create(AUse: Boolean; const AImageFile: string; const APosition: TPoint; const ASize: TSize; AAutosize: Boolean; AFixed: Boolean; AMapBounds: TRect);
begin
  Zero;
  FUse := AUse;
  FImageFile := AImageFile;
  FPosition := APosition;
  FSize := ASize;
  FAutosize := AAutoSize;
  FFixed := AFixed;
  FMapBounds := AMapBounds;
end;

constructor TSegmentData.Create(AData: PSegmentData);
begin
  Zero;
  Assign(AData);
end;

procedure TSegmentData.Assign(AData: PSegmentData);
begin
  Zero;
  FUse := AData^.Use;
  FMultiselect := AData^.FMultiselect;
  FImageFile := AData^.ImageFile;
  FPosition := AData^.Position;
  FSize := AData^.Size;
  FAutosize := AData^.AutoSize;
  FFixed := AData^.Fixed;
  FMapBounds := AData^.MapBounds;
  FbtAdd_Push := AData^.FbtAdd_Push;
  FbtRemove_Push := AData^.FbtRemove_Push;
  FbtSendToFront_Push := AData^.FbtSendToFront_Push;
  FbtSendToBack_Push := AData^.FbtSendToBack_Push;
  FbtSendBefore_Push := AData^.FbtSendBefore_Push;
  FbtSendAfter_Push := AData^.FbtSendAfter_Push;
  FbtCombine_Horz_Push := AData^.FbtCombine_Horz_Push;
  FbtCombine_Vert_Push := AData^.FbtCombine_Vert_Push;
end;

procedure TSegmentData.Zero;
begin
  FUse := false;
  FMultiselect := false;
  FImageFile := '';
  FPosition := TPoint.Create(0,0);
  FSize := TSize.Create(0, 0);
  FAutosize := false;
  FFixed := false;
  FMapBounds := TRect.Empty;
  FbtSendToFront_Push := false;
  FbtSendToBack_Push := false;
  FbtSendBefore_Push := false;
  FbtSendAfter_Push := false;
  FbtCombine_Horz_Push := false;
  FbtCombine_Vert_Push := false;
end;


constructor TZoomData.Create(AUse: Boolean; AEnabled: Boolean; ALayer: TBitmap; AZoomStep: Integer; const APosition: TPoint; const AZoomLayerSize: TSize; const AMapBounds: TRect);
begin
  Zero;
  FUse := AUse;
  FEnabled := AEnabled;
  FLayer := ALayer;
  FZoomStep := AZoomStep;
  FPosition := APosition;
  FZoomLayerSize := AZoomLayerSize;
  FMapBounds := AMapBounds;
end;

constructor TZoomData.Create(AData: PZoomData);
begin
  Zero;
  Assign(AData);
end;

procedure TZoomData.Assign(AData: PZoomData);
begin
  FUse := AData^.Use;
  FEnabled := AData^.Enabled;
  FLayer := AData^.Layer;
  FZoomStep := AData^.ZoomStep;
  FPosition := AData^.Position;
  FZoomLayerSize := AData^.ZoomLayerSize;
  FMapBounds := AData^.FMapBounds;
end;

procedure TZoomData.Zero;
begin
  FUse := false;
  FEnabled := false;
  FLayer := nil;
  FZoomStep := 0;
  FZoomStepRange := Point(1, 32);
  FPosition := TPoint.Create(0,0);
  FZoomLayerSize := TSize.Create(0, 0);
  FMapBounds := TRect.Empty;
end;


constructor TCommonData.Create;
begin
  Zero;
  Assign(AData);
end;

procedure TCommonData.Assign(AData: PCommonData);
begin
  FSize := AData^.Size;
  FbtLoadSegmentMap_Down := AData^.FbtLoadSegmentMap_Down;
  FbtCalcMapSize_Down := AData^.FbtCalcMapSize_Down;
end;

procedure TCommonData.Zero;
begin
  FSize := TSize.Create(0, 0);
  FbtLoadSegmentMap_Down := false;
  FbtCalcMapSize_Down := false;
end;

procedure TfmTools.FormCreate(Sender: TObject);
begin
  FStickyElement := fmMain.StickyManager.SubscribeWindow(Self, [sRight]);

  FData[tcSegment] := AllocMem(SizeOf(TSegmentData));
  PSegmentData(FData[tcSegment])^.Zero;
  FData[tcZoom] := AllocMem(SizeOf(TZoomData));
  PZoomData(FData[tcZoom])^.Zero;
  FData[tcCommon] := AllocMem(SizeOf(TCommonData));
  PCommonData(FData[tcCommon])^.Zero;

  FZoomLayer := TBitmap.Create;

  UpdateCategory(tcSegment);
  UpdateCategory(tcZoom);
  UpdateCategory(tcCommon);
end;

procedure TfmTools.FormDestroy(Sender: TObject);
begin
  PSegmentData(FData[tcSegment])^.Zero;
  PZoomData(FData[tcZoom])^.Zero;
  PCommonData(FData[tcCommon])^.Zero;
  FreeMem(FData[tcSegment]);
  FreeMem(FData[tcZoom]);
  FreeMem(FData[tcCommon]);
  FZoomLayer.Free;
end;

procedure TfmTools.FormShow(Sender: TObject);
begin
  Top := fmMain.Top;

  if Assigned(FStickyElement)
  then FStickyElement.UpToDefaultPosition([sRight]);
end;

procedure TfmTools.WMWindowPosChanging(var Message: TWMWindowPosMsg);
var
  WPT: TPoint;
begin
  Inherited;

  if not Assigned(FStickyElement)
    or (Message.WindowPos.hwnd <> Handle)
    or (Message.Msg <> WM_WINDOWPOSCHANGING)
    or (Message.WindowPos.flags and SWP_NOMOVE = SWP_NOMOVE)
  then Exit;

  WPT := Point(Message.WindowPos.x, Message.WindowPos.y);
  FStickyElement.Process(WPT.X, WPT.Y);
  Message.WindowPos.x := WPT.X;
  Message.WindowPos.y := WPT.Y;

  if sRight in FStickyElement.SidesTest
  then Caption := 'sRight'
  else Caption := 'none';

end;

procedure TfmTools.WndProc(var Msg: TMessage);
begin

  case Msg.Msg of
    WM_NCLBUTTONDOWN:
    begin
      if Assigned(FStickyElement)
      then FStickyElement.UnstickDeltaLastPos := Point(LoWord(Msg.LParam) - Left, HiWord(Msg.LParam) - Top);
    end;

    WM_NCMOUSEMOVE:
    begin
    end;

    WM_NCLBUTTONUP:
    begin
      if Assigned(FStickyElement)
      then FStickyElement.ResetUnstickDelta;
    end;
  end;

  Inherited WndProc(Msg);
end;

procedure TfmTools.AssignDataTo(ACategory: TToolCategory; ASource: Pointer; ADestination: Pointer);
begin
  case ACategory of
    tcSegment: PSegmentData(ADestination)^.Assign(ASource);
    tcZoom: PZoomData(ADestination)^.Assign(ASource);
    tcCommon: PCommonData(ADestination)^.Assign(ASource);
  end;
end;

procedure TfmTools.UpdateSegmentCategory;
var
  Data: PSegmentData;
  FExists: Boolean;
begin
  Data := FData[tcSegment];
  FUIUpdating := true;
  try
    edLayerPath.Text := Data^.ImageFile;
    FExists := FileExists(Data^.ImageFile);

    if FExists
    then begin
      pLayer.Caption := '';
      imLayer.Picture.LoadFromFile(Data^.ImageFile)
    end
    else begin
      pLayer.Caption := 'No image';
      imLayer.Picture := nil;
    end;

    udPosition_X.Min := Data^.MapBounds.Left;
    udPosition_X.Max := Data^.MapBounds.Right - Data^.Size.Width;
    udPosition_X.Position := Data^.Position.X;
    udPosition_Y.Min := Data^.MapBounds.Top;
    udPosition_Y.Max := Data^.MapBounds.Bottom - Data^.Size.Height;
    udPosition_Y.Position := Data^.Position.Y;
    cbPosition_AutoSize.Checked := Data^.Autosize;

    if Data^.Autosize
    then begin
      udPosition_Width.Position := imLayer.Picture.Width;
      udPosition_Height.Position := imLayer.Picture.Height;
    end
    else begin
      udPosition_Width.Position := Data^.Size.cx;
      udPosition_Height.Position := Data^.Size.cy;
    end;

    cbModificators_Fixed.Checked := Data^.Fixed;

    imLayer.Enabled := FExists and Data^.Use and not Data^.Fixed;
    edLayerPath.Enabled := Data^.Use and not Data^.Fixed;
    btLayerPathSelect.Enabled := Data^.Use and not Data^.Fixed;

    gbPosition.Enabled := FExists and Data^.Use;
    lbPosition_X.Enabled := FExists and Data^.Use and not Data^.Fixed;
    edPosition_X.Enabled := FExists and Data^.Use and not Data^.Fixed;
    udPosition_X.Enabled := FExists and Data^.Use and not Data^.Fixed;

    lbPosition_Y.Enabled := FExists and Data^.Use and not Data^.Fixed;
    edPosition_Y.Enabled := FExists and Data^.Use and not Data^.Fixed;
    udPosition_Y.Enabled := FExists and Data^.Use and not Data^.Fixed;

    cbPosition_AutoSize.Enabled := FExists and Data^.Use and not Data^.Fixed;

    lbPosition_Width.Enabled := not Data^.Autosize and FExists and Data^.Use and not Data^.Fixed;
    edPosition_Width.Enabled := not Data^.Autosize and FExists and Data^.Use and not Data^.Fixed;
    udPosition_Width.Enabled := not Data^.Autosize and FExists and Data^.Use and not Data^.Fixed;

    lbPosition_Height.Enabled := not Data^.Autosize and FExists and Data^.Use and not Data^.Fixed;
    edPosition_Height.Enabled := not Data^.Autosize and FExists and Data^.Use and not Data^.Fixed;
    udPosition_Height.Enabled := not Data^.Autosize and FExists and Data^.Use and not Data^.Fixed;

    gbModificators.Enabled := FExists and FExists and Data^.Use;
    cbModificators_Fixed.Enabled := FExists and FExists and Data^.Use;

    btSegAdd.Enabled := true;
    btSegRemove.Enabled := Data^.Use and not Data^.Fixed;
    btSeg_SendToFront.Enabled := Data^.Use and not Data^.Fixed;
    btSeg_SendToBack.Enabled := Data^.Use and not Data^.Fixed;
    btSeg_SendBefore.Enabled := Data^.Use and Data^.Multiselect;
    btSeg_SendAfter.Enabled := Data^.Use and Data^.Multiselect;
    btCombine_Horz.Enabled := Data^.Use and Data^.Multiselect;
    btCombine_Vert.Enabled := Data^.Use and Data^.Multiselect;
  finally
    FUIUpdating := false;
  end;
end;

procedure ScaleCanvas(ACanvas: TCanvas; ARect: TRect; AScale: Integer; ADestCanvas: TCanvas);
var
  iX, iY: Integer;
  iR: TRect;
begin
  iR := TRect.Empty;

  iR.Bottom := AScale;

  for iY := ARect.Top to ARect.Bottom
  do begin
    iR.Left := 0;
    iR.Right := AScale;

    for iX := ARect.Left to ARect.Right do
    begin
      With ADestCanvas do begin
        Pen.Style := psSolid;
        Pen.Color := ACanvas.Pixels[iX, iY];
        Brush.Style := bsSolid;
        Brush.Color := Pen.Color;

        if (AScale = 1)
        then Pixels[iR.Left, iR.Top] := ACanvas.Pixels[iX, iY]
        else Rectangle(iR);
      end;
      Inc(iR.Left, AScale);
      Inc(iR.Right, AScale);
    end;

    Inc(iR.Top, AScale);
    Inc(iR.Bottom, AScale);
  end;
end;

procedure ScaleImage(AImage: TBitmap; ARect: TRect; AScale: Integer; ADestImage: TBitmap; ADestX, ADestY: Integer);

  procedure ScalePixel(iLines: TList; APxl: PRGBTriple; AX, AY: Integer);
  var
    iCol, iRow: Integer;
  begin
    for iRow := AY to AY + AScale - 1
    do begin
      if (iRow >= ADestImage.Height)
      then Continue;

      for iCol := AX to AX + AScale - 1
      do begin
        if (iCol >= ADestImage.Width)
        then Continue;

        PRGBTriple(Integer(iLines[iRow]) + iCol * 3)^ := APxl^;
      end;
    end;
  end;

var
  iPxl: PRGBTriple;
  iColor: TColor;
  iX, iY, iDX, iDY: Integer;
  iDLines: TList;
  iLine: Pointer;
begin
  iDLines := TList.Create;

  try
    for iDY := 0 to ADestImage.Height - 1
    do iDLines.Add(ADestImage.ScanLine[iDY]);

    for iY := ARect.Top to ARect.Bottom - 1
    do begin
      iLine := AImage.ScanLine[iY];

      for iX := ARect.Left to ARect.Right - 1
      do begin
        iPxl := Pointer(Integer(iLine) + iX * 3);
        ScalePixel(iDLines, iPxl, iX * AScale + ADestX - ARect.Left, iY * AScale + ADestY - ARect.Top);
      end;
    end;
  finally
    iDLines.Free;
  end;
end;

procedure TfmTools.UpdateZoomCategory;
var
  Data: PZoomData;
  R: TRect;
  Bmp: TBitmap;
begin
  Data := FData[tcZoom];
  FUIUpdating := true;
  try
    if Assigned(Data^.Layer) and (Data^.Use) and (Data^.Enabled) and (Data^.ZoomStep > 0)
    then begin
      Bmp := TBitmap.Create;
      Bmp.PixelFormat := pf24bit;
      Bmp.HandleType := bmDIB;
      try
        FZoomLayer.PixelFormat := pf24bit;
        FZoomLayer.HandleType := bmDIB;
        FZoomLayer.SetSize(imZoomLayer.Width, imZoomLayer.Height);

        R := TREct.Empty;
        R.Location := Data^.Position;

        if (Data^.ZoomStep > 0) then
        begin
          R.Width := imZoomLayer.Width div Data^.ZoomStep + 1;
          R.Height := imZoomLayer.Height div Data^.ZoomStep + 1;
        end
        else begin
          R.Size := TSize.Create(0, 0);
        end;

        Data^.ZoomLayerSize := R.Size;
        Bmp.SetSize(R.Size.cx, R.Size.cy);
        Bmp.Canvas.CopyRect(Rect(0, 0, Bmp.Width, Bmp.Height), Data^.Layer.Canvas, R);
        R.Location := Point(0, 0);

        //Bmp.Canvas.CopyRect(Rect(1, 1, Bmp.Width - 1, Bmp.Height - 1), Data^.Layer.Canvas, R);

        if (Data^.ZoomStep > 1)
        then ScaleImage(Bmp, R, Data^.FZoomStep, FZoomLayer, 0, 0)
        else StretchBlt(FZoomLayer.Canvas.Handle, 0, 0, imZoomLayer.Width - 1, imZoomLayer.Height - 1,
                   Data^.Layer.Canvas.Handle, R.Left, R.Top, R.Width, R.Height, SRCCOPY);
        {StretchBlt(imZoomLayer.Canvas.Handle, 0, 0, imZoomLayer.Width - 1, imZoomLayer.Height - 1,
                   Bmp.Canvas.Handle, 0, 0, Bmp.Width - 1, Bmp.Height - 1, SRCCOPY);}
        imZoomLayer.Picture.Bitmap := Bmp;
      finally
        Bmp.Free;
      end;
    end
    else begin
      imZoomLayer.Picture := nil;
    end;

    cbZoom_Enable.Checked := Data^.Enabled;
    tbZoomScale.Position := Data^.ZoomStep;
    udZoomPosition_X.Min := Data^.MapBounds.Left;
    udZoomPosition_X.Max := Data^.MapBounds.Right;
    udZoomPosition_Y.Min := Data^.MapBounds.Left;
    udZoomPosition_Y.Max := Data^.MapBounds.Right;
    udZoomPosition_X.Position := Data^.Position.X;
    udZoomPosition_Y.Position := Data^.Position.Y;

    cbZoom_Enable.Enabled := Data^.Use and Assigned(Data^.Layer);
    gbZoomLayer.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    imZoomLayer.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    tbZoomScale.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);

    gbZoomPosition.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    lbZoomPosition_X.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    edZoomPosition_X.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    udZoomPosition_X.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);

    lbZoomPosition_Y.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    edZoomPosition_Y.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);
    udZoomPosition_Y.Enabled := Data^.Use and Data^.Enabled and Assigned(Data^.Layer);

  finally
    FUIUpdating := false;
  end;
end;

procedure TfmTools.UpdateCommonCategory;
var
  Data: PCommonData;
begin
  FUIUpdating := true;
  try
    Data := FData[tcCommon];
    udMap_Width.Position := Data^.Size.cx;
    udMap_Height.Position := Data^.Size.cy;
  finally
    FUIUpdating := false;
  end;
end;

procedure TfmTools.UpdateCategory(ACategory: TToolCategory);
begin
  case ACategory of
    tcSegment: UpdateSegmentCategory;
    tcZoom: UpdateZoomCategory;
    tcCommon: UpdateCommonCategory;
  end;
end;

procedure TfmTools.CollectSegmentCategory;
var
  Data: PSegmentData;
begin
  Data := FData[tcSegment];
  Data^.ImageFile := edLayerPath.Text;
  Data^.Position := Point(udPosition_X.Position, udPosition_Y.Position);
  Data^.Size := TSize.Create(udPosition_Width.Position, udPosition_Height.Position);

  Data^.Autosize := cbPosition_AutoSize.Checked or (Data^.Size.cx + Data^.Size.cy = 0);
  Data^.Fixed := cbModificators_Fixed.Checked;
  Data^.btAdd_Push := FButtonPushed[bpAddSegment];
  Data^.btRemove_Push := FButtonPushed[bpRemoveSegment];
  Data^.btSendToFront_Push := FButtonPushed[bpSendToFront];
  Data^.btSendToBack_Push := FButtonPushed[bpSendToBack];
  Data^.btSendBefore_Push := FButtonPushed[bpSendBefore];
  Data^.btSendAfter_Push := FButtonPushed[bpSendAfter];
  Data^.btCombine_Horz_Push := FButtonPushed[bpCombineHorz];
  Data^.btCombine_Vert_Push := FButtonPushed[bpCombineVert];

  ResetPushButtons;
end;

procedure TfmTools.CollectZoomCategory;
var
  Data: PZoomData;
begin
  Data := FData[tcZoom];
  Data^.Enabled := cbZoom_Enable.Checked;
  Data^.ZoomStep := tbZoomScale.Position;
  Data^.Position := Point(udZoomPosition_X.Position, udZoomPosition_Y.Position);
  Data^.ZoomStepRange := Point(tbZoomScale.Min, tbZoomScale.Max);

  if (Data^.ZoomStep > 0)
  then Data^.ZoomLayerSize := TSize.Create(imZoomLayer.Width div Data^.ZoomStep, imZoomLayer.Height div Data^.ZoomStep)
  else Data^.ZoomLayerSize := TSize.Create(0, 0);

  ResetPushButtons;
end;

procedure TfmTools.edLayerPathChange(Sender: TObject);
begin
  CollectCategory(tcSegment);
end;

procedure TfmTools.edMap_WidthChange(Sender: TObject);
begin
  CollectCategory(tcCommon);
end;

procedure TfmTools.edZoomPosition_XChange(Sender: TObject);
begin
  CollectZoomCategory;

  if not FUIUpdating
  then UpdateZoomCategory;

  CollectCategory(tcZoom);
end;

procedure TfmTools.CollectCommonCategory;
var
  Data: PCommonData;
begin
  Data := FData[tcCommon];
  Data^.Size := TSize.Create(udMap_Width.Position, udMap_Height.Position);
  Data^.btLoadSegmentMap_Down := FButtonPushed[bpLoadSegmentMap];
  Data^.btCalcMapSize_Down := FButtonPushed[bpCalcMapSize];

  ResetPushButtons;
end;

procedure TfmTools.btCalcMapSizeClick(Sender: TObject);
begin
  FButtonPushed[bpCalcMapSize] := true;
  CollectCategory(tcCommon);
end;

procedure TfmTools.btCombine_HorzClick(Sender: TObject);
begin
  FButtonPushed[bpCombineHorz] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btCombine_VertClick(Sender: TObject);
begin
  FButtonPushed[bpCombineVert] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btLayerPathSelectClick(Sender: TObject);
begin
  if OpenPictureDialog.Execute then
  begin
    edLayerPath.Text := OpenPictureDialog.FileName;
    UpdateSegmentCategory;
    CollectCategory(tcSegment);
  end;
end;

procedure TfmTools.btLoadSegmentMapClick(Sender: TObject);
begin
  FButtonPushed[bpLoadSegmentMap] := true;
  CollectCategory(tcCommon);
end;

procedure TfmTools.btSegAddClick(Sender: TObject);
begin
  FButtonPushed[bpAddSegment] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btSegRemoveClick(Sender: TObject);
begin
  FButtonPushed[bpRemoveSegment] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btSeg_SendAfterClick(Sender: TObject);
begin
  FButtonPushed[bpSendAfter] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btSeg_SendBeforeClick(Sender: TObject);
begin
  FButtonPushed[bpSendBefore] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btSeg_SendToBackClick(Sender: TObject);
begin
  FButtonPushed[bpSendToBack] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.btSeg_SendToFrontClick(Sender: TObject);
begin
  FButtonPushed[bpSendToFront] := true;
  CollectCategory(tcSegment);
end;

procedure TfmTools.cbPosition_AutoSizeClick(Sender: TObject);
begin
  CollectSegmentCategory;

  if not FUIUpdating
  then UpdateSegmentCategory;

  CollectCategory(tcSegment);
end;

procedure TfmTools.cbZoom_EnableClick(Sender: TObject);
begin
  CollectZoomCategory;

  if not FUIUpdating
  then UpdateZoomCategory;

  CollectCategory(tcZoom);
end;

procedure TfmTools.CollectCategory(ACategory: TToolCategory);
var
  iHandled: Boolean;
  iDataCopy: Pointer;
begin
  if FUIUpdating
  then Exit;

  iDataCopy := nil;
  iHandled := false;

  try
    case ACategory of
      tcSegment:
      begin
        iDataCopy := AllocMem(SizeOf(TSegmentData));
        PSegmentData(iDataCopy).Assign(FData[ACategory]);
        CollectSegmentCategory;
      end;

      tcZoom: begin
        iDataCopy := AllocMem(SizeOf(TZoomData));
        PZoomData(iDataCopy).Assign(FData[ACategory]);
        CollectZoomCategory;
      end;

      tcCommon: begin
        iDataCopy := AllocMem(SizeOf(TCommonData));
        PCommonData(iDataCopy).Assign(FData[ACategory]);
        CollectCommonCategory;
      end;
    end;

    if Assigned(FCallback)
    then FCallback(Self, ACategory, FData[ACategory], iHandled);

    if (iHandled) and Assigned(iDataCopy)
    then AssignDataTo(ACategory, iDataCopy, FData[ACategory]);
  finally
    if Assigned(iDataCopy)
    then FreeMem(iDataCopy);
  end;
end;

procedure TfmTools.SetData(ACategory: TToolCategory; AData: Pointer);
begin
  AssignDataTo(ACategory, AData, FData[ACategory]);
  UpdateCategory(ACategory);
end;

procedure TfmTools.ResetPushButtons;
var
  iBtn: Integer;
begin
  for iBtn := Integer(Low(TButtonPushed)) to Integer(High(TButtonPushed))
  do FButtonPushed[TButtonPushed(iBtn)] := false;
end;

procedure TfmTools.tbZoomScaleChange(Sender: TObject);
begin
  CollectZoomCategory;

  if not FUIUpdating
  then UpdateZoomCategory;

  CollectCategory(tcZoom);
end;

procedure TfmTools.udMap_WidthChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  CollectCategory(tcCommon);
end;

procedure TfmTools.udPosition_XChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  CollectCategory(tcSegment);
end;

procedure TfmTools.udZoomPosition_XChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  CollectZoomCategory;

  if not FUIUpdating
  then UpdateZoomCategory;

  CollectCategory(tcZoom);
end;

procedure TfmTools.GetData(ACategory: TToolCategory; AData: Pointer);
begin
  AssignDataTo(ACategory, FData[ACategory], AData);
end;

end.
