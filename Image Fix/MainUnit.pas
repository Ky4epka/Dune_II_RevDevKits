unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ImgList,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.ExtCtrls, System.ImageList,
  Vcl.Samples.Gauges;

const
  //IMAGES_ROOT = 'D:\Dune II\Maps';//'E:\Delphi Projects\Dune II\Maps\Sources';
  //RESULTS_ROOT = 'D:\Dune II\Maps\Result';
  IMAGES_ROOT = 'E:\Delphi Projects\Dune II\Maps\Sources';
  RESULTS_ROOT = 'E:\Delphi Projects\Dune II\Maps\Result';

  RESULT_FILE_MASK = 'Result %d.bmp';

  COLOR_LEFT_IMAGE_ACTIVE = $00FF00;
  COLOR_LEFT_IMAGE_INACTIVE = $009600;

  COLOR_RIGHT_IMAGE_ACTIVE = $0000FF;
  COLOR_RIGHT_IMAGE_INACTIVE = $000096;

  COLOR_RESULT_IMAGE_ACTIVE = $FF0000;
  COLOR_RESULT_IMAGE_INACTIVE = $960000;

  STATE_INDEX_LEFT            = 1;
  STATE_INDEX_PREV_LEFT       = 2;
  STATE_INDEX_RIGHT           = 3;
  STATE_INDEX_PREV_RIGHT      = 4;

type
  TfmMain = class(TForm)
    pLeftImage: TPanel;
    imgLeft: TImage;
    pRightImage: TPanel;
    imgRight: TImage;
    pResultImage: TPanel;
    imgResult: TImage;
    pTools: TPanel;
    gbDirectory: TGroupBox;
    dlbDirectory: TDirectoryListBox;
    gbFiles: TGroupBox;
    btnSave: TButton;
    twFiles: TTreeView;
    ilFilesImages: TImageList;
    spLeftImage_Border: TShape;
    spRightImage_Border: TShape;
    spResultImage_Border: TShape;
    edLeftImage_Focus: TEdit;
    edRightImage_Focus: TEdit;
    edResultImage_Focus: TEdit;
    ilStateImages: TImageList;
    spLeft_SelectRect: TShape;
    spRight_SelectRect: TShape;
    spLeft_SelectRect_Dublicate: TShape;
    spRight_SelectRectDublicate: TShape;
    btApplySelections: TButton;
    pAutoFind: TPanel;
    btLeftAuto: TButton;
    btRightAuto: TButton;
    btAuto: TButton;
    btProcessAll: TButton;
    gProgress: TGauge;
    procedure dlbDirectoryChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edLeftImage_FocusEnter(Sender: TObject);
    procedure edLeftImage_FocusExit(Sender: TObject);
    procedure edRightImage_FocusEnter(Sender: TObject);
    procedure edRightImage_FocusExit(Sender: TObject);
    procedure edResultImage_FocusEnter(Sender: TObject);
    procedure edResultImage_FocusExit(Sender: TObject);
    procedure spLeftImage_BorderMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spRightImage_BorderMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure spResultImage_BorderMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure twFilesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgLeftMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgLeftMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgRightMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgRightMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btApplySelectionsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure spLeft_SelectRectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spLeft_SelectRectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spLeft_SelectRectMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure spRight_SelectRectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spRight_SelectRectMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure spRight_SelectRectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btLeftAutoClick(Sender: TObject);
    procedure btRightAutoClick(Sender: TObject);
    procedure btAutoClick(Sender: TObject);
    procedure btProcessAllClick(Sender: TObject);
  private
    FReverse: Boolean;

    FPrevLeftIndex,
    FPrevRightIndex,

    FLeftIndex,
    FRightIndex: Integer;

    FFiles: TStringList;

    FLeftImage: TBitmap;
    FRightImage: TBitmap;
    FResultImage: TBitmap;
    FCursorImage: TBitmap;

    FLeftRect,
    FRightRect: TRect;

    FLeftImage_PressedButton: TMouseButton;
    FRightImage_PressedButton: TMouseButton;
    FLeftImage_Pressed: Boolean;
    FRightImage_PRessed: Boolean;

    FLeftImage_SelectionPressed: Boolean;
    FLeftImage_SelectionPos: TPoint;

    FRightImage_SelectionPressed: Boolean;
    FRightImage_SelectionPos: TPoint;

    { Private declarations }

  public
    { Public declarations }

    procedure DoSelectFile(ANode: TTreeNode);

    procedure UpdateFiles(const ADir: String);
    procedure UpdateSelectionIndexes;
    procedure UpdateLeftImage;
    procedure UpdateRightImage;
    procedure CopyLeftToResult;
    procedure CopyRightToResult;
    procedure UpdateResultImage;
    procedure UpdateLeftSelection;
    procedure UpdateRightSelection;
    procedure UpdateUI;
    procedure SaveResult;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

function FindImageInImage(Source, Image: TBitmap; TransparentColor: TColor): TPoint;
var
  I, J: Integer;
  W, H: Integer;
  SPxl, IPxl: PRGBTriple;
  SLines: TList;
  SLines2: TList;

  function ComparePixels(Pxl1, Pxl2: PRGBTriple): Boolean;
  begin
    Result := (Pxl1^.rgbtBlue = Pxl2^.rgbtBlue)
              and (Pxl1^.rgbtGreen= Pxl2^.rgbtGreen)
              and (Pxl1^.rgbtRed = Pxl2^.rgbtRed);
  end;

  function Compare(AX, AY: Integer): Boolean;
  var
    K, L, SX, SY: Integer;
    TPxl: TRGBTriple;
  begin
    Result := false;
    TPxl.rgbtBlue := GetBValue(TransparentColor);
    TPxl.rgbtGreen := GetGValue(TransparentColor);
    TPxl.rgbtRed := GetRValue(TransparentColor);

    for K := 0 to Image.Height - 1 do
    begin
      for L := 0 to Image.Width - 1 do
      begin
        SX := AX + L;
        SY := AY + K;
        SPxl := Pointer(Cardinal(SLines[SY]) + SX * 3);
        IPxl := Pointer(Cardinal(SLines2[K]) + L * 3);

        if not ComparePixels(SPxl, IPxl)
          and not ComparePixels(IPxl, @TPxl)
        then Exit;
      end;
    end;

    Result := true;
  end;

begin
  SLines := TList.Create;
  SLines2 := TList.Create;
  Result := Point(-1, -1);

  try
    W := Source.Width - Image.Width - 1;
    H := SOurce.Height - Image.Height - 1;

    for I := 0 to Source.Height - 1
    do SLines.Add(Source.ScanLine[I]);

    for I := 0 to Image.Height - 1
    do SLines2.Add(Image.ScanLine[I]);

    for I := 0 to H - 1 do
    begin
      for J := 0 to W - 1 do
      begin
        if Compare(J, I)
        then begin
          Result := Point(J, I);
          Exit;
        end;
      end;
    end;
  finally
    SLines2.Free;
    SLines.Free;
  end;
end;

procedure TfmMain.dlbDirectoryChange(Sender: TObject);
begin
  UpdateFiles(dlbDirectory.Directory);
end;

procedure TfmMain.edLeftImage_FocusEnter(Sender: TObject);
begin
  spLeftImage_Border.Pen.Color := COLOR_LEFT_IMAGE_ACTIVE;
end;

procedure TfmMain.edLeftImage_FocusExit(Sender: TObject);
begin
  spLeftImage_Border.Pen.Color := COLOR_LEFT_IMAGE_INACTIVE;
end;

procedure TfmMain.edResultImage_FocusEnter(Sender: TObject);
begin
  spResultImage_Border.Pen.Color := COLOR_RESULT_IMAGE_ACTIVE;
end;

procedure TfmMain.edResultImage_FocusExit(Sender: TObject);
begin
  spResultImage_Border.Pen.Color := COLOR_RESULT_IMAGE_INACTIVE;
end;

procedure TfmMain.edRightImage_FocusEnter(Sender: TObject);
begin
  spRightImage_Border.Pen.Color := COLOR_RIGHT_IMAGE_ACTIVE;
end;

procedure TfmMain.edRightImage_FocusExit(Sender: TObject);
begin
  spRightImage_Border.Pen.Color := COLOR_RIGHT_IMAGE_INACTIVE;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  FPrevLeftIndex := -1;
  FPrevRightIndex := -1;
  FLeftIndex := -1;
  FRightIndex := -1;
  FReverse := false;
  FLeftRect.Left := -1;
  FLeftRect.Right := -1;
  FLeftRect.Top := -1;
  FLeftRect.Bottom := -1;
  FRightRect.Left := -1;
  FRightRect.Right := -1;
  FRightRect.Top := -1;
  FRightRect.Bottom := -1;
  FFiles := TStringList.Create;
  FLeftImage := TBitmap.Create;
  FRightImage := TBitmap.Create;
  FResultImage := TBitmap.Create;
  FCursorImage := TBitmap.Create;
  FCursorImage.LoadFromFile('E:\Delphi Projects\Dune II\Image Fix\Images\Cursor.bmp');
  spLeft_SelectRect.Pen.Color := COLOR_LEFT_IMAGE_ACTIVE;
  spLeft_SelectRect_Dublicate.Pen.Color := COLOR_LEFT_IMAGE_INACTIVE;
  spRight_SelectRect.Pen.Color := COLOR_RIGHT_IMAGE_ACTIVE;
  spRight_SelectRectDublicate.Pen.Color := COLOR_RIGHT_IMAGE_INACTIVE;

  if DirectoryExists(IMAGES_ROOT)
  then dlbDirectory.Directory := IMAGES_ROOT;

  UpdateLeftSelection;
  UpdateRightSelection;
  UpdateUI;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  FResultImage.Free;
  FRightImage.Free;
  FLeftImage.Free;
  FFiles.Free;
end;

procedure TfmMain.imgLeftMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Tmp: Integer;
begin
  if (FLeftImage_Pressed) then
  begin
    if (FLeftImage_PressedButton = mbLeft) then
    begin
      FLeftRect.Right := X;
      FLeftRect.Bottom := Y;

      UpdateLeftSelection;
    end
  end;
end;

procedure TfmMain.imgLeftMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FLeftImage_Pressed := false;
end;

procedure TfmMain.imgRightMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Tmp: Integer;
begin
  if FRightImage_Pressed then
  begin
     FRightRect.Right := X;
     FRightRect.Bottom := Y;

     UpdateRightSelection;
  end;
end;

procedure TfmMain.imgRightMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FRightImage_PRessed := false;
end;

procedure TfmMain.spLeftImage_BorderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  N: TTreeNode;
  Counter: Integer;
begin
  FLeftImage_PressedButton := Button;

  if (Button = mbLeft) then
  begin
    twFiles.ClearSelection();
    if (FLeftIndex >= 0)
      and (FLeftIndex < FFiles.Count)
    then begin
      Counter := 0;
      N := twFiles.Items.GetFirstNode();
      while Assigned(N) do
      begin
        if (Counter = FLeftIndex)
        then N.Selected := true;

        Inc(Counter);
        N := N.getNextSibling();
      end;
    end;

    edLeftImage_Focus.SetFocus;
    FLeftImage_Pressed := true;
    FLeftRect.Left := X;
    FLeftRect.Top := Y;
    FLeftRect.Right := X;
    FLeftRect.Bottom := Y;
  end
  else
  if (Button = mbMiddle) then
  begin
    FLeftRect.Left := X - 25;
    FLeftRect.Top := Y - 25;
    FLeftRect.Width := 50;
    FLeftRect.Height := 50;
    UpdateLeftSelection;
  end
  else
  if (Button = mbRight) then
  begin
    FLeftRect.Left := -1;
    FLeftRect.Right := -1;
    FLeftRect.Top := -1;
    FLeftRect.Bottom := -1;
    UpdateLeftSelection;
  end;

end;

procedure TfmMain.spLeft_SelectRectMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLeftImage_SelectionPressed := true;
  FLeftImage_SelectionPos := Point(X, Y);
end;

procedure TfmMain.spLeft_SelectRectMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FLeftImage_SelectionPressed then
  begin
    FLeftRect.Offset(X - FLeftImage_SelectionPos.X, Y - FLeftImage_SelectionPos.Y);
    UpdateLeftSelection;
  end;
end;

procedure TfmMain.spLeft_SelectRectMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FLeftImage_SelectionPressed := false;
end;

procedure TfmMain.spResultImage_BorderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edResultImage_Focus.SetFocus;
end;

procedure TfmMain.spRightImage_BorderMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  N: TTreeNode;
  Counter: Integer;
begin
  if (Button = mbLeft) then
  begin
    twFiles.ClearSelection();
    if (FRightIndex >= 0)
      and (FRightIndex < FFiles.Count)
    then begin
      Counter := 0;
      N := twFiles.Items.GetFirstNode();
      while Assigned(N) do
      begin
        if (Counter = FRightIndex)
        then N.Selected := true;

        Inc(Counter);
        N := N.getNextSibling();
      end;
    end;

    edRightImage_Focus.SetFocus;
    FRightImage_PRessed := true;
    FRightRect.Left := X;
    FRightRect.Top := Y;
  end
  else
  if (Button = mbMiddle) then
  begin
    FRightRect.Left := X - 25;
    FRightRect.Top := Y - 25;
    FRightRect.Width := 50;
    FRightRect.Height := 50;
    UpdateRightSelection;
  end
  else
  begin
    FRightRect.Left := -1;
    FRightRect.Right := -1;
    FRightRect.Top := -1;
    FRightRect.Bottom := -1;
    UpdateRightSelection;
  end;
end;

procedure TfmMain.spRight_SelectRectMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FRightImage_SelectionPressed := true;
  FRightImage_SelectionPos := Point(X, Y);
end;

procedure TfmMain.spRight_SelectRectMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if FRightImage_SelectionPressed then
  begin
    FRightRect.Offset(X - FRightImage_SelectionPos.X, Y - FRightImage_SelectionPos.Y);
    UpdateRightSelection;
  end;
end;

procedure TfmMain.spRight_SelectRectMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FRightImage_SelectionPressed := false;
end;

procedure TfmMain.twFilesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  iNode: TTreeNode;
begin
  if (ssDouble in Shift)  then
  begin
    iNode := twFiles.GetNodeAt(X, Y);
    DoSelectFile(iNode);
  end;

  UpdateSelectionIndexes;
end;

procedure TfmMain.DoSelectFile(ANode: TTreeNode);
begin
    if Assigned(ANode) then
    begin
      if not FReverse
      then begin
        if (ANode.Index = FLeftIndex)
        then Exit;

        FPrevLeftIndex := FLeftIndex;
        FLeftIndex := ANode.Index;
        UpdateLeftImage;
      end
      else begin
        if (ANode.Index = FRightIndex)
        then Exit;

        FPrevRightIndex := FRightIndex;
        FRightIndex := ANode.Index;
        UpdateRightImage;
      end;

      FReverse := not FReverse;
    end;
end;

procedure TfmMain.UpdateFiles(const ADir: String);
var
  SRec: TSearchRec;
  I: Integer;
  iBitmap, iIcon: TBitmap;
  iNode: TTreeNode;
  ts: String;
begin
  FPrevLeftIndex := -1;
  FPrevRightIndex := -1;
  FLeftIndex := -1;
  FRightIndex := -1;
  FReverse := false;
  ilFilesImages.Clear;
  twFiles.Items.Clear;
  FFiles.Clear;

  FindFirst(IncludeTrailingPathDelimiter(ADir) + '*.bmp', faAnyFile, SRec);
  repeat
    if (SRec.Name = '')
      or (SRec.Name = '.')
      or (SRec.Name = '..')
      or (SRec.Attr and faDirectory = faDirectory)
      or not FileExists(IncludeTrailingPathDelimiter(ADir) + SRec.Name)
    then Continue;

    FFiles.Add(IncludeTrailingPathDelimiter(ADir) + SRec.Name);
  until (FindNext(SRec) <> 0);

  iBitmap := TBitmap.Create;
  iIcon := TBitmap.Create;
  iIcon.SetSize(ilFilesImages.Width, ilFilesImages.Height);
  try
    for I := 0 to FFiles.Count - 1 do
    begin
      ts := FFiles[I];
      iBitmap.LoadFromFile(ts);
      iIcon.Canvas.StretchDraw(Rect(0, 0, iIcon.Width, iIcon.Height), iBitmap);

      with iIcon.Canvas do
      begin
        Pen.Style := psSolid;
        Pen.Color := clBlack;
        Pen.Width := 1;
        Brush.Style := bsClear;
        Rectangle(Rect(0, 0, iIcon.Width, iIcon.Height));
      end;

      ilFilesImages.Add(iIcon, nil);

      iNode := twFiles.Items.Add(nil, ExtractFileName(FFiles[I]));
      iNode.ImageIndex := I;
      iNode.ExpandedImageIndex := I;
      iNode.SelectedIndex := I;
      iNode.StateIndex := -1;
    end;
  finally
    iIcon.Free;
    iBitmap.Free;
    UpdateUI;
  end;
end;

procedure TfmMain.UpdateSelectionIndexes;
var
  iNode: TTreeNode;
  iCounter: Integer;
begin
  iCounter := 0;
  iNode := twFiles.Items.GetFirstNode();
  while Assigned(iNode) do
  begin
    iNode.StateIndex := -1;

    if (iCounter = FLeftIndex)
    then iNode.StateIndex := STATE_INDEX_LEFT
    else
    if (iCounter = FRightIndex)
    then iNode.StateIndex := STATE_INDEX_RIGHT
    else
    if (iCounter = FPrevLeftIndex)
    then iNode.StateIndex := STATE_INDEX_PREV_LEFT
    else
    if (iCounter = FPrevRightIndex)
    then iNode.StateIndex := STATE_INDEX_PREV_RIGHT;

    iNode := iNode.getNextSibling();
    Inc(iCounter);
  end;
end;

procedure TfmMain.UpdateLeftImage;
begin
  FLeftRect.Left := -1;
  FLeftRect.Right := -1;
  FLeftRect.Top := -1;
  FLeftRect.Bottom := -1;
  FRightRect.Left := -1;
  FRightRect.Right := -1;
  FRightRect.Top := -1;
  FRightRect.Bottom := -1;
  FLeftImage.LoadFromFile(FFiles[FLeftIndex]);
  imgLeft.Picture.Bitmap := FLeftImage;
  imgLeft.Canvas.StretchDraw(Rect(0, 0, imgLeft.Width - 1, imgLeft.Height - 1), FLeftImage);

  FResultImage.Assign(FLeftImage);
  imgResult.Picture.Bitmap := FResultImage;
  imgResult.Canvas.StretchDraw(Rect(0, 0, imgResult.Width - 1, imgResult.Height - 1), FResultImage);
  UpdateLeftSelection;
  UpdateUI;
end;

procedure TfmMain.UpdateRightImage;
begin
  FLeftRect.Left := -1;
  FLeftRect.Right := -1;
  FLeftRect.Top := -1;
  FLeftRect.Bottom := -1;
  FRightRect.Left := -1;
  FRightRect.Right := -1;
  FRightRect.Top := -1;
  FRightRect.Bottom := -1;
  FRightImage.LoadFromFile(FFiles[FRightIndex]);
  imgRight.Picture.Bitmap := FRightImage;
  imgRight.Canvas.StretchDraw(Rect(0, 0, imgRight.Width - 1, imgRight.Height - 1), FRightImage);
  UpdateRightSelection;
  UpdateUI;
end;

procedure TfmMain.btApplySelectionsClick(Sender: TObject);
begin
  CopyLeftToResult;
  CopyRightToResult;
end;

procedure TfmMain.btAutoClick(Sender: TObject);
begin
  btLeftAutoClick(Sender);
  btRightAutoClick(Sender);
end;

procedure TfmMain.btLeftAutoClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := FindImageInImage(FLeftImage, FCursorImage, RGB(255, 0, 255));
  if (Pt.X <> -1)
    and (Pt.Y <> -1)
  then begin
    Pt.X := Pt.X div 2 + imgRight.Left;
    Pt.Y := Pt.Y div 2 + imgRight.Top;
    FLeftRect.Left := Pt.X - 5;
    FLeftRect.Top := Pt.Y - 5;
    FLeftRect.Right := Pt.X + FCursorImage.Width div 2 + 5;
    FLeftRect.Bottom := Pt.Y + FCursorImage.Height div 2 + 5;
    UpdateLeftSelection();
  end;
end;

procedure TfmMain.btnSaveClick(Sender: TObject);
begin
  SaveResult;
end;

procedure TfmMain.btProcessAllClick(Sender: TObject);

  procedure ProcessLine;
  var
    iNode: TTreeNode;
    iMod: Integer;
  begin
    iNode := twFiles.Items.GetFirstNode();
    iMod := 1;
    while Assigned(iNode) do
    begin
      twFiles.Select(iNode);
      DoSelectFile(iNode);
      UpdateSelectionIndexes;
      if (iMod mod 2 = 0) then
      begin
        btAutoClick(Sender);
        btApplySelectionsClick(Sender);
        btnSaveClick(Sender);
      end;
      Inc(iMod);
      iNode := iNode.getNextSibling();
      Application.ProcessMessages;
      Sleep(100);
    end;
  end;

var
  SR: TSearchRec;
  DirList: TStringList;
  I: Integer;
begin
  DirList := TStringList.Create;
  try
    FindFirst(IncludeTrailingPathDelimiter(dlbDirectory.Directory) + '*.*', faAnyFile, SR);
    repeat
      if (SR.Name = '')
        or (SR.Name = '.')
        or (SR.Name = '..')
      then Continue;

      if (SR.Attr and faDirectory = faDirectory) then
      begin
        DirList.Add(IncludeTrailingPathDelimiter(dlbDirectory.Directory) + SR.Name);
      end;
    until (FindNext(SR) <> 0);

    gProgress.Progress := 0;

    for I := 0 to DirList.Count - 1 do
    begin
      dlbDirectory.Directory := DirList[I];
      Application.ProcessMessages;
      ProcessLine();
      gProgress.Progress := Round(((I + 1) / DirList.Count) * 100);
      Application.ProcessMessages;
      Sleep(500);
    end;
  finally
    DirList.Free;
  end;
end;

procedure TfmMain.btRightAutoClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt := FindImageInImage(FRightImage, FCursorImage, RGB(255, 0, 255));
  if (Pt.X <> -1)
    and (Pt.Y <> -1)
  then begin
    Pt.X := Pt.X div 2 + imgRight.Left;
    Pt.Y := Pt.Y div 2 + imgRight.Top;
    FRightRect.Left := Pt.X - 5;
    FRightRect.Top := Pt.Y - 5;
    FRightRect.Right := Pt.X + FCursorImage.Width div 2 + 5;
    FRightRect.Bottom := Pt.Y + FCursorImage.Height div 2 + 5;
    UpdateRightSelection();
  end;
end;

procedure TfmMain.CopyLeftToResult;
var
  R: TRect;
begin
  R := FLEftRect;
  R.NormalizeRect;
  R.Offset(-imgLeft.Left, -imgLeft.Top);
  R := Rect(R.Left * 2, R.Top * 2, R.Right * 2, R.Bottom * 2);
  FResultImage.Canvas.CopyRect(R, FRightImage.Canvas, R);
  UpdateResultImage;
end;

procedure TfmMain.CopyRightToResult;
var
  R: TRect;
begin
  R := FRightRect;
  R.NormalizeRect;
  R.Offset(-imgRight.Left, -imgRight.Top);
  R := Rect(R.Left * 2, R.Top * 2, R.Right * 2, R.Bottom * 2);
  FResultImage.Canvas.CopyRect(R, FLeftImage.Canvas, R);
  UpdateResultImage;
end;

procedure TfmMain.UpdateResultImage;
begin
  imgResult.Picture.Bitmap := FResultImage;
  imgResult.Canvas.StretchDraw(Rect(0, 0, imgResult.Width - 1, imgResult.Height - 1), FResultImage);
end;

procedure TfmMain.UpdateLeftSelection;
var
  R: TRect;
begin
  R := FLeftRect;
  R.NormalizeRect;
  spLeft_SelectRect.BoundsRect := R;
  spLeft_SelectRect_Dublicate.BoundsRect := R;
  UpdateUI;
end;

procedure TfmMain.UpdateRightSelection;
var
  R: TRect;
begin
  R := FRightRect;
  R.NormalizeRect;
  spRight_SelectRect.BoundsRect := FRightRect;
  spRight_SelectRectDublicate.BoundsRect := FRightRect;
  UpdateUI;
end;

procedure TfmMain.UpdateUI;
begin
  btApplySelections.Enabled := (FLeftRect.Left <> -1)
                               or (FRightRect.Left <> -1);
  btnSave.Enabled := (FLeftIndex <> -1) and (FRightIndex <> -1);
end;

procedure TfmMain.SaveResult;
var
  LineDir, LevelDir, ClanDir, Dir, FileName: String;
  SR: TSearchRec;
  Counter: Integer;
  iNode: TTreeNode;
begin
  if (FLeftIndex < 0)
    or (FLeftIndex >= FFiles.Count)
  then Exit;

  Dir := ExtractFileDir(FFiles[FLeftIndex]);
  LineDir := ExtractFileName(Dir);
  Delete(Dir, Length(Dir) - Length(LineDir), MaxInt);
  LevelDir := ExtractFileName(Dir);
  Delete(Dir, Length(Dir) - Length(LevelDir), MaxInt);
  ClanDir := ExtractFileName(Dir);
  Delete(Dir, Length(Dir) - Length(ClanDir), MaxInt);

  Dir := IncludeTrailingPathDelimiter(RESULTS_ROOT) +
         IncludeTrailingPathDelimiter(ClanDir) +
         IncludeTrailingPathDelimiter(LevelDir) +
         IncludeTrailingPathDelimiter(LineDir);

  if ForceDirectories(Dir) then
  begin
    Counter := 0;
    FindFirst(IncludeTrailingPathDelimiter(Dir) + '*.*', faAnyFile, SR);
    repeat
      if (SR.Name = '')
        or (SR.Name = '.')
        or (SR.Name = '..')
        or (SR.Attr and faDirectory = faDirectory)
        or not FileExists(IncludeTrailingPathDelimiter(Dir) + SR.Name)
      then Continue;

      if (Format(RESULT_FILE_MASK, [Counter]) = Sr.Name)
      then Inc(Counter);
    until (FindNext(SR) <> 0);

    FileName := IncludeTrailingPathDelimiter(Dir) + Format(RESULT_FILE_MASK, [Counter]);
    FResultImage.SaveToFile(FileName);

    Counter := 0;
    iNode := twFiles.Items.GetFirstNode();
    while Assigned(iNode) do
    begin
      if (Counter = FLeftIndex) or (Counter = FRightIndex) then
      begin
        iNode.Text := iNode.Text + '*';
      end;
      Inc(Counter);
      iNode := iNode.getNextSibling();
    end;
  end;
end;

end.
