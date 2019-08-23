unit Reaper;

interface

uses
  Windows,
  SysUtils,
  Types,
  Classes,
  Graphics;

  const
    CELL_SIZE  = 32;
    COLLECTION_MAX_ROW_SIZE = 32;
    SPRITE_EMPTY_COLOR = clWhite;

  type
    TCell = class

    private
      fPosition: TPoint;
      fRect: TRect;
      fIgnore: Boolean;
      fData: Pointer;
      fFreeDataOnDestroy: Boolean;
      fSprite: TBitmap;

      procedure SetPosition(Value: TPoint);
    public
      constructor Create(); overload;
      constructor Create(const APosition: TPoint; const AIgnore: Boolean); overload;

      destructor Destroy(); override;
      procedure SetSprite(ASprite: TBitmap);
      procedure DoEmptySprite();
      function IsEmpty: Boolean;

      property Sprite: TBitmap read fSprite;
      property Position: TPoint read fPosition write SetPosition;
      property Rect: TRect read fRect;
      property Ignore: Boolean read fIgnore write fIgnore;
      property Data: Pointer read fData write fData;
      property FreeDataOnDestroy: Boolean read fFreeDataOnDestroy write fFreeDataOnDestroy;
    end;

    TMap = class
    private
    type
      TProcessCallback = procedure (ASender: TMap; AProgress: Real) of object;

    var
      fGraphicAnalog: TBitmap;
      fMap: TList;
      fSize: TSize;
      fSpriteBuffer: TBitmap;
      fOnProcessCallback: TProcessCallback;

      function CellAt(const APosition: TPoint): TCell;
      procedure AddRow;
      procedure DeleteRow(const AIndex: Integer);
      procedure AddColumn;
      procedure DeleteColumn(const AIndex: Integer);
      procedure SetSize(const ASize: TSize);
      procedure SetGraphicAnalog(const AGraphicAnalog: TBitmap);
      function SpriteAt(const APosition: TPoint): TBitmap;
      procedure DrawSpriteTo(ASprite: TBitmap; const APosition: TPoint);
      procedure UpdateGraphicAnalogSize;
      procedure AddSprite(ASprite: TBitmap; var ASearchIndex: Integer); overload;
      procedure AddSprite(ASprite: TBitmap); overload;
      function ContainsSprite(ASprite: TBitmap): Boolean;
      procedure UpdateGraphicAnalog;
      procedure UpdateCellsSprites();

    public
      constructor Create();
      destructor Destroy(); override;

      procedure CollectSpritesFrom(ASource: TMap; ADontAddEmpty: Boolean);
      procedure DeleteEmptySprites();

      procedure Clear();
      function IsEmpty(): Boolean;

      function IsValidPoint(const APoint: TPoint): Boolean;
      procedure ValidPointNeeded(const APoint: TPoint);
      function SpriteAtIsEmpty(const APosition: TPoint): Boolean;
      procedure SetSprite(const APosition: TPoint; ASprite: TBitmap);
      procedure SetSpriteEmpty(const APosition: TPoint);
      procedure MatchCellsAtSimilarPercent(ABaseCellCoord: TPoint; AMinPersent: Single; AResult: TList);

      procedure LoadGraphicAnalogFromFile(const AFileName: String);
      procedure SaveGraphicAnalogToFile(const AFileName: String);

      property GraphicAnalog: TBitmap read fGraphicAnalog write SetGraphicAnalog;
      property Cell[const APosition: TPoint]: TCell read CellAt;
      property Size: TSize read fSize write SetSize;
      property OnProcessCallback: TProcessCallback read fOnProcessCallback write fOnProcessCallback;
    end;

implementation


function RGBTripleEquals(APixel1, APixel2: PRGBTriple): Boolean;
begin
  Result := (APixel1^.rgbtRed = APixel2^.rgbtRed) and
            (APixel1^.rgbtGreen = APixel2^.rgbtGreen) and
            (APixel1^.rgbtBlue = APixel2^.rgbtBlue);
end;

function CompareBitmaps(ABitmap1, ABitmap2: TBitmap): Boolean;
var
  iPixel1,
  iPixel2: PRGBTriple;
  I, J: Integer;
begin
  if (ABitmap1.Width <> ABitmap2.Width) or
     (ABitmap1.Height <> ABitmap2.Height)
  then
    Exit(false);

  for I := 0 to ABitmap1.Height - 1
  do begin
    iPixel1 := ABitmap1.ScanLine[I];
    iPixel2 := ABitmap2.ScanLine[I];

    for J := 0 to ABitmap1.Width - 1
    do begin
      if not RGBTripleEquals(iPixel1, iPixel2)
      then
        Exit(false);

      Inc(iPixel1, 3);
      Inc(iPixel2, 3);
    end;
  end;

  Result := true;
end;

function CompareBitmapsEx(ABitmap1, ABitmap2: TBitmap): Single;
var
  iPixel1,
  iPixel2: PRGBTriple;
  I, J, iMatchCount: Integer;
begin
  Result := 0;

  if (ABitmap1.Width <> ABitmap2.Width) or
     (ABitmap1.Height <> ABitmap2.Height)
  then
    Exit();

  iMatchCount := 0;

  for I := 0 to ABitmap1.Height - 1
  do begin
    iPixel1 := ABitmap1.ScanLine[I];
    iPixel2 := ABitmap2.ScanLine[I];

    for J := 0 to ABitmap1.Width - 1
    do begin
      if RGBTripleEquals(iPixel1, iPixel2)
      then Inc(iMatchCount);

      Inc(iPixel1, 3);
      Inc(iPixel2, 3);
    end;
  end;

  Result := iMatchCount / (ABitmap1.Width * ABitmap1.Height);
end;

function IsBitmapSolidColor(ABitmap: TBitmap; AColor: TColor): Boolean;
var
  I, J: Integer;
  iPixel: PRGBTriple;
  iCompareColor: TRGBTriple;
begin
  iCompareColor.rgbtRed := GetRValue(AColor);
  iCompareColor.rgbtGreen := GetGValue(AColor);
  iCompareColor.rgbtBlue := GetBValue(AColor);

  for I := 0 to ABitmap.Height - 1
  do begin
    iPixel := ABitmap.ScanLine[I];

    for J := 0 to ABitmap.Width - 1
    do begin
      if (ABitmap.Canvas.Pixels[J, I] <> AColor)
      then Exit(false);
    end;
  end;

  Result := true;
end;

constructor TCell.Create;
begin
  Inherited Create;
  fSprite := TBitmap.Create;
  fSprite.HandleType := bmDIB;
  fSprite.PixelFormat := pf24bit;
  fSprite.SetSize(CELL_SIZE, CELL_SIZE);
  DoEmptySprite;
  Position := TPoint.Create(-1, -1);
  Ignore := false;
  Data := nil;
end;

constructor TCell.Create(const APosition: TPoint; const AIgnore: Boolean);
begin
  Inherited Create;
  fSprite := TBitmap.Create;
  fSprite.HandleType := bmDIB;
  fSprite.PixelFormat := pf24bit;
  fSprite.SetSize(CELL_SIZE, CELL_SIZE);
  DoEmptySprite;
  Position := APosition;
  Ignore := AIgnore;
  Data := nil;
end;

destructor TCell.Destroy;
begin
  if fFreeDataOnDestroy and
     Assigned(fData)
  then
    TObject(fData).Free;

  Inherited Destroy;
end;

procedure TCell.SetPosition(Value: TPoint);
begin
  fPosition := Value;
  fRect := TRect.Create(TPoint.Create(Value.X * CELL_SIZE, Value.Y * CELL_SIZE), CELL_SIZE, CELL_SIZE);
end;

procedure TCell.SetSprite(ASprite: TBitmap);
begin
  fSprite.Canvas.Draw(0,0, ASprite);
end;

procedure TCell.DoEmptySprite;
begin
  With fSprite.Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Color := SPRITE_EMPTY_COLOR;
    Brush.Style := bsSolid;
    Brush.Color := SPRITE_EMPTY_COLOR;
    Rectangle(0,0, fSprite.Width, fSprite.Height);
  end;
end;

function TCell.IsEmpty;
begin
  Result := IsBitmapSolidColor(fSprite, SPRITE_EMPTY_COLOR);
end;

constructor TMap.Create;
begin
  Inherited Create;
  fGraphicAnalog := TBitmap.Create;
  fGraphicAnalog.PixelFormat := pf24bit;
  fGraphicAnalog.HandleType := bmDIB;
  fMap := TList.Create;
  fSize := TSize.Create(0, 0);
  fSpriteBuffer := TBitmap.Create;
  fSpriteBuffer.PixelFormat := pf24bit;
  fSpriteBuffer.HandleType := bmDIB;
  fSpriteBuffer.SetSize(CELL_SIZE, CELL_SIZE);
end;

destructor TMap.Destroy;
begin
  Clear;
  Inherited Destroy;
end;

procedure TMap.CollectSpritesFrom(ASource: TMap; ADontAddEmpty: Boolean);
var
  iCurrentSprite: Integer;
var
  I: Integer;
  J: Integer;
  iCell: TCell;
begin
  Clear();
  SetSize(TSize.Create(ASource.Size.cx, 0));

  iCurrentSprite := -1;

  for I := 0 to ASource.Size.cy - 1
  do begin
    for J := 0 to ASource.Size.cx - 1
    do begin
      iCell := ASource.CellAt(TPoint.Create(J, I));
      if not iCell.Ignore
        //and not ContainsSprite(ASource.SpriteAt(TPoint.Create(J, I)))
       // and (not ADontAddEmpty or not ASource.CellAt(TPoint.Create(J, I)).IsEmpty)
      then AddSprite(iCell.Sprite, iCurrentSprite);

      if Assigned(fOnProcessCallback)
      then fOnProcessCallback(Self, (I * ASource.Size.cx + J) / (ASource.Size.cx * ASource.Size.cy))
    end;
  end;
end;

procedure TMap.DeleteEmptySprites;
var
  iTemp: TMap;
  I: Integer;
  J: Integer;
  iPosition: Integer;
begin
  iTemp := TMap.Create;
  iPosition := -1;

  try
    iTemp.GraphicAnalog := GraphicAnalog;
    Clear();
    SetSize(TSize.Create(iTemp.Size.cx, 0));

    for I := 0 to iTemp.Size.cy - 1
    do for J := 0 to iTemp.Size.cx - 1
       do begin
  //       if not iTemp.SpriteAtIsEmpty(TPoint.Create(J, I))
         //then
         AddSprite(iTemp.SpriteAt(TPoint.Create(J, I)));
       end;
  finally
    iTemp.Free;
  end;
end;

procedure TMap.Clear;
var
  I: Integer;
begin
  SetSize(TSIze.Create(0,0));
  UpdateGraphicAnalogSize;
end;

function TMap.IsEmpty(): Boolean;
begin
  Result := (Size.cx = 0) or
            (Size.cy = 0);
end;

function TMap.IsValidPoint(const APoint: TPoint): Boolean;
begin
  Result := (APoint.X >= 0) and
            (APoint.X < fSize.cx) and
            (APoint.Y >= 0) and
            (APoint.Y < fSize.cy)
end;

procedure TMap.ValidPointNeeded(const APoint: TPoint);
begin
  if not IsValidPoint(APoint)
  then raise Exception.Create(Format('Invalid map point', [APoint.X, APoint.X]));
end;

procedure TMap.LoadGraphicAnalogFromFile(const AFileName: string);
var
  iBitmap: TBitmap;
begin
  iBitmap := TBitmap.Create;

  try
    iBitmap.LoadFromFile(AFileName);
    GraphicAnalog := iBitmap;
  finally
    iBitmap.Free;
  end;
end;

procedure TMap.SaveGraphicAnalogToFile(const AFileName: string);
begin
  GraphicAnalog.SaveToFile(AFileName);
end;

function TMap.CellAt(const APosition: TPoint): TCell;
begin
  Result := TList(fMap[APosition.Y])[APosition.X];
end;

procedure TMap.AddRow;
var
  iRow: TList;
  I: Integer;
begin
  iRow := TList.Create;
  fMap.Add(iRow);
  fSize.cy := fMap.Count;

  for I := 0 to fSize.cx - 1
  do iRow.Add(TCell.Create(TPoint.Create(I, fSize.cy - 1), false));

  UpdateGraphicAnalogSize;
end;

procedure TMap.DeleteRow(const AIndex: Integer);
var
  iRow: TList;
  I: Integer;
begin
  iRow := fMap[AIndex];

  for I := 0 to iRow.Count - 1
  do TCell(iRow[I]).Free;

  iRow.Free;
  fMap.Delete(AIndex);
  fSize.cy := fMap.Count;

  UpdateGraphicAnalogSize;
end;

procedure TMap.AddColumn;
var
  I: Integer;
begin
  Inc(fSize.cx);

  for I := 0 to fSize.cy - 1
  do TList(fMap[I]).Add(TCell.Create(TPoint.Create(fSize.cx - 1, I), false));

  UpdateGraphicAnalogSize;
end;

procedure TMap.DeleteColumn(const AIndex: Integer);
var
  I: Integer;
begin
  if (fSize.cx <= 0)
  then Exit;

  for I := 0 to fMap.Count - 1
  do begin
    TCell(TList(fMap[I])[AIndex]).Free;
    TList(fMap[I]).Delete(AIndex);
  end;

  UpdateGraphicAnalogSize;
end;

procedure TMap.SetSize(const ASize: TSize);
var
  iDW, iDH: Integer;
  I: Integer;
begin
  iDW := ASize.cx - fSize.cx;
  iDH := ASize.cy - fSize.cy;

  if (iDW < -fSize.cx)
  then iDW := -fSize.cx;

  if (iDH < -fSize.cy)
  then iDH := -fSize.cy;

  for I := 0 to Abs(iDH) - 1
  do begin
    if (iDH > 0)
    then AddRow
    else DeleteRow(fSize.cy);
  end;

  for I := 0 to Abs(iDW) - 1
  do begin
    if (iDW > 0)
    then AddColumn
    else DeleteColumn(fSize.cx);
  end;
end;

procedure TMap.SetGraphicAnalog(const AGraphicAnalog: TBitmap);
begin
  Clear();

  if (AGraphicAnalog <> nil) and
    ((AGraphicAnalog.Width + AGraphicAnalog.Height) > 0)
  then begin
    SetSize(TSize.Create((AGraphicAnalog.Width div CELL_SIZE) + 1 * Integer(AGraphicAnalog.Width mod CELL_SIZE <> 0),
                         (AGraphicAnalog.Height div CELL_SIZE) + 1 * Integer(AGraphicAnalog.Height mod CELL_SIZE <> 0)));

    fGraphicAnalog.Canvas.Draw(0, 0, AGraphicAnalog);
    UpdateCellsSprites;
  end;
end;

function TMap.SpriteAt(const APosition: TPoint): TBitmap;
begin
  ValidPointNeeded(APosition);

  Result := CellAt(APosition).Sprite;
  Exit;
  Result := fSpriteBuffer;
  Result.Canvas.CopyRect(TRect.Create(0, 0, Result.Width, Result.Height),
                         fGraphicAnalog.Canvas,
                         CellAt(APosition).Rect);
end;

function TMap.SpriteAtIsEmpty(const APosition: TPoint): Boolean;
var
  iBitmap: TBitmap;
begin
  iBitmap := SpriteAt(APosition);
  Result := IsBitmapSolidColor(iBitmap, SPRITE_EMPTY_COLOR);
end;

procedure TMap.SetSprite(const APosition: TPoint; ASprite: TBitmap);
begin
  DrawSpriteTo(ASprite, APosition);
end;

procedure TMap.SetSpriteEmpty(const APosition: TPoint);
var
  iCell: TCell;
begin
  iCell := CellAt(APosition);
  iCell.DoEmptySprite;
  DrawSpriteTo(iCell.Sprite, iCell.Position);
end;

procedure TMap.DrawSpriteTo(ASprite: TBitmap; const APosition: TPoint);
var
  iPixPos: TPoint;
begin
  ValidPointNeeded(APosition);

  CellAt(APosition).SetSprite(ASprite);
  UpdateGraphicAnalog;
end;

procedure TMap.UpdateGraphicAnalogSize;
begin
  fGraphicAnalog.SetSize(fSize.cx * CELL_SIZE, fSize.cy * CELL_SIZE);
end;

procedure TMap.AddSprite(ASprite: TBitmap; var ASearchIndex: Integer);
var
  I: Integer;
begin
  if (IsBitmapSolidColor(ASprite, SPRITE_EMPTY_COLOR))
  then Exit;

  if (fSize.cx = 0)
  then begin
    SetSize(TSize.Create(COLLECTION_MAX_ROW_SIZE, fSize.cy));
    ASearchIndex := -1;
  end
  else if ((ASearchIndex = -1) and (fSize.cy > 0)) then
  begin
    for I := 0 to fSize.cx - 1
    do begin
      Inc(ASearchIndex);

      if SpriteAtIsEmpty(TPoint.Create(ASearchIndex, fSize.cy - 1))
      then begin
        Break;
      end;
    end;
  end;

  if (ASearchIndex = -1) or
     (ASearchIndex >= fSize.cx)
  then begin
    ASearchIndex := 0;
    AddRow;
  end;

  DrawSpriteTo(ASprite, TPoint.Create(ASearchIndex, fSize.cy - 1));
  Inc(ASearchIndex);
end;

procedure TMap.AddSprite(ASprite: TBitmap);
var
  iIndex: Integer;
begin
  iIndex := -1;
  AddSprite(ASprite, iIndex);
end;

function TMap.ContainsSprite(ASprite: TBitmap): Boolean;
var
  I: Integer;
  J: Integer;
begin
  Result := false;

  for I := 0 to fSize.cy - 1
  do begin
    for J := 0 to fSize.cx - 1
    do begin
      if CompareBitmaps(ASprite, SpriteAt(TPoint.Create(J, I)))
      then begin
        Result := true;
        Exit;
      end;
    end;
  end;
end;

procedure TMap.UpdateGraphicAnalog;
var
  I, J: Integer;
  iCell: TCell;
begin
  for I := 0 to fSize.cy - 1
  do for J := 0 to fSize.cx - 1
     do begin
       iCell := CellAt(TPoint.Create(J, I));
       fGraphicAnalog.Canvas.Draw(iCell.Rect.Location.X, iCell.Rect.Location.Y, iCell.Sprite);
     end;
end;

procedure TMap.UpdateCellsSprites;
var
  I, J: Integer;
  iCell: TCell;
begin
  for I := 0 to fSize.cy - 1
  do for J := 0 to fSize.cx - 1
     do begin
       iCell := CellAt(TPoint.Create(J, I));
       fSpriteBuffer.Canvas.CopyRect(Rect(0,0, fSpriteBuffer.Width, fSpriteBuffer.Height),
                                     fGraphicAnalog.Canvas,
                                     iCell.Rect);
       iCell.SetSprite(fSpriteBuffer);
     end;
end;

procedure TMap.MatchCellsAtSimilarPercent(ABaseCellCoord: TPoint; AMinPersent: Single; AResult: TList);
var
  I, J: Integer;
  iBaseCell, iCell: TCell;
begin
  AResult.Clear;
  iBaseCell := CellAt(ABaseCellCoord);

  for I := 0 to fSize.cy - 1
  do for J := 0 to fSize.cx - 1
     do begin
       if (ABaseCellCoord.X = J) and (ABaseCellCoord.Y = I)
       then Continue;


       iCell := CellAt(TPoint.Create(J, I));

       if (CompareBitmapsEx(iBaseCell.Sprite, iCell.Sprite) * 100 >= AMinPersent)
       then AResult.Add(iCell);
     end;
end;

end.
