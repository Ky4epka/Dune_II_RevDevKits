unit MapCellBindList;

interface

uses
  Windows,
  SysUtils,
  Types,
  Classes,
  Graphics,
  MapCellSpace,
  IniFiles;

type
  PMapCellData = ^TMapCellData;
  TMapCellData = record
  public
    const Record_Name = 'TMapCellData';

    var
    CellName: String;
    Position: TPoint;
    PathCost: Integer;
    GroundSpeedScale: Single;
    AirSpeedScale: Single;
    CanHasSpice: Boolean;
    SpiceValue: Single;
    CellColor: TColor;
    CanBuildingsPlaces: Boolean;
    CanGroundUnitsPlaces: Boolean;
    SpriteNameSpace: String;
    SpriteNameSpacePivot: Boolean;

    procedure Assign(AData: PMapCellData);
    procedure CopyTo(ADestData: PMapCellData);
    procedure SetDefault;

    procedure SaveData(AIni: TCustomIniFile; const ASection: String);
    procedure LoadData(AIni: TCustomIniFile; const ASection: String);
  end;

  TMapCellBindList = class;

  TMapCell = class
    private
      fOwner: TMapCellBindList;
      fData: TMapCellData;

      function GetData: PMapCellData;
    public
      constructor Create(AOwner: TMapCellBindList); overload;
      procedure AssignData(AData: PMapCellData);
      procedure CopyDataTo(ADestData: PMapCellData);

      destructor Destroy(); override;

      procedure SaveData(AIni: TCustomIniFile; AIndex: Integer);
      procedure LoadData(AIni: TCustomIniFile; AIndex: Integer);

      property Data: PMapCellData read GetData;
  end;

  TMapCellBindList = class
  protected
    fMapCellNamespaceList: TMapCellNamespaceList;
    fCells: TList;
    fAssociatedAthlas: String;

    function CellIndexAt(APosX: Integer; APosY: Integer): Integer; overload;
    function CellIndexAt(APosition: TPoint): Integer; overload;
    function CellIndexAt(const AName: String): Integer; overload;
  public
    constructor Create();
    destructor Destroy(); override;

    function AddCell(): TMapCell;
    procedure RemoveCell(AIndex: Integer); overload;
    procedure RemoveCell(APosX, APosY: Integer); overload;
    procedure RemoveCell(APosition: TPoint); overload;
    procedure RemoveCell(const AName: String); overload;

    procedure Clear();

    function CellAt(AIndex: Integer): TMapCell; overload;
    function CellAt(APosX: Integer; APosY: Integer): TMapCell; overload;
    function CellAt(APosition: TPoint): TMapCell; overload;
    function CellAt(const AName: String): TMapCell; overload;


    procedure SaveData(AIni: TCustomIniFile);
    procedure LoadData(AIni: TCustomIniFile);

    procedure SaveToFile(const AFileName: String);
    procedure LoadFromFile(const AFileName: String);

    property MapCellNamespaceList: TMapCellNamespaceList read fMapCellNamespaceList;
    property AssociatedAthlas: String read fAssociatedAthlas write fAssociatedAthlas;
  end;

implementation



procedure TMapCellData.Assign(AData: PMapCellData);
begin
  CellName := string.Copy(AData^.CellName);
  Position := AData^.Position;
  PathCost := AData^.PathCost;
  GroundSpeedScale := AData^.GroundSpeedScale;
  AirSpeedScale := AData^.AirSpeedScale;
  CanHasSpice := AData^.CanHasSpice;
  SpiceValue := AData^.SpiceValue;
  CellColor := AData^.CellColor;
  CanBuildingsPlaces := AData^.CanBuildingsPlaces;
  CanGroundUnitsPlaces := AData^.CanGroundUnitsPlaces;
  SpriteNameSpace := string.Copy(AData^.SpriteNameSpace);
  SpriteNameSpacePivot := AData^.SpriteNameSpacePivot;
end;

procedure TMapCellData.CopyTo(ADestData: PMapCellData);
begin
  ADestData^.Assign(@Self);
end;

procedure TMapCellData.SetDefault;
begin
  CellName := 'default_cell';
  Position := TPoint.Zero;
  PathCost := 1;
  GroundSpeedScale := 1;
  AirSpeedScale := 1;
  CanHasSpice := false;
  SpiceValue := 0;
  CellColor := clBlack;
  CanBuildingsPlaces := false;
  CanGroundUnitsPlaces := true;
  SpriteNameSpace := '';
  SpriteNameSpacePivot := false;
end;

procedure TMapCellData.SaveData(AIni: TCustomIniFile; const ASection: string);
begin
  AIni.WriteString(ASection, Record_name + '_CellName', CellName);
  AIni.WriteInteger(ASection, Record_name + '_Position_X', Position.X);
  AIni.WriteInteger(ASection, Record_name + '_Position_Y', Position.Y);
  AIni.WriteInteger(ASection, Record_name + 'PathCost', PathCost);
  AIni.WriteFloat(ASection, Record_name + 'GroundSpeedScale', GroundSpeedScale);
  AIni.WriteFloat(ASection, Record_name + 'AirSpeedScale', AirSpeedScale);
  AIni.WriteBool(ASection, Record_name + 'CanHasSpice', CanHasSpice);
  AIni.WriteString(ASection, Record_name + 'CellColor', IntToHex(CellColor, 8));
  AIni.WriteBool(ASection, Record_name + 'CanBuildingsPlaces', CanBuildingsPlaces);
  AIni.WriteBool(ASection, Record_name + 'CanGroundUnitsPlaces', CanGroundUnitsPlaces);
  AIni.WriteString(ASection, Record_name + 'SpriteNameSpace', SpriteNameSpace);
  AIni.WriteBool(ASection, Record_name + 'SpriteNameSpacePivot', SpriteNameSpacePivot);
end;

procedure TMapCellData.LoadData(AIni: TCustomIniFile; const ASection: string);
var
  iStr: String;
  iInt: Integer;
begin
  CellName := AIni.ReadString(ASection, Record_name + '_CellName', 'default_cell');
  Position.X := AIni.ReadInteger(ASection, Record_name + '_Position_X', 0);
  Position.Y := AIni.ReadInteger(ASection, Record_name + '_Position_Y', 0);
  PathCost := AIni.ReadInteger(ASection, Record_name + 'PathCost', 1);
  GroundSpeedScale := AIni.ReadFloat(ASection, Record_name + 'GroundSpeedScale', 1);
  AirSpeedScale := AIni.ReadFloat(ASection, Record_name + 'AirSpeedScale', 1);
  CanHasSpice := AIni.ReadBool(ASection, Record_name + 'CanHasSpice', false);
  iStr := AIni.ReadString(ASection, Record_name + 'CellColor', IntToHex(clBlack, 8));

  if not TryStrToInt(iStr, iInt)
  then iInt := clBlack;

  CellColor := iInt;
  CanBuildingsPlaces := AIni.ReadBool(ASection, Record_name + 'CanBuildingsPlaces', false);
  CanGroundUnitsPlaces := AIni.ReadBool(ASection, Record_name + 'CanGroundUnitsPlaces', false);
  SpriteNameSpace := AIni.ReadString(ASection, Record_name + 'SpriteNameSpace', '');
  SpriteNameSpacePivot := AIni.ReadBool(ASection, Record_name + 'SpriteNameSpacePivot', false);
end;

constructor TMapCell.Create(AOwner: TMapCellBindList);
begin
  Inherited Create;
  fOwner := AOwner;
  fData.SetDefault;
end;

function TMapCell.GetData;
begin
  Result := @fData;
end;

procedure TMapCell.AssignData(AData: PMapCellData);
begin
  fData.Assign(AData);
  fOwner.fMapCellNamespaceList.AddItem(fData.SpriteNameSpace, fData.Position, fData.SpriteNameSpacePivot);
end;

procedure TMapCell.CopyDataTo(ADestData: PMapCellData);
begin
  fData.CopyTo(ADestData);
end;

destructor TMapCell.Destroy;
begin
  fOwner.fMapCellNamespaceList.RemoveItem(fData.SpriteNameSpace, fData.Position);
  Inherited Destroy;
end;

procedure TMapCell.SaveData(AIni: TCustomIniFile; AIndex: Integer);
begin
  fData.SaveData(AIni, Format('%s_%d', [TMapCell.ClassName, AIndex]));
end;

procedure TMapCell.LoadData(AIni: TCustomIniFile; AIndex: Integer);
begin
  fData.LoadData(AIni, Format('%s_%d', [TMapCell.ClassName, AIndex]));
end;

constructor TMapCelLBindList.Create;
begin
  Inherited Create;
  fCells := TList.Create();
  fMapCellNamespaceList := TMapCellNamespaceList.Create;
end;

destructor TMapCellBindList.Destroy;
begin
  Clear();
  fCells.Free;
  Inherited Destroy;
end;

function TMapCellBindList.AddCell;
var
  iCell: TMapCell;
begin
  iCell := TMapCell.Create(Self);
  fCells.Add(iCell);
end;

procedure TMapCellBindList.RemoveCell(AIndex: Integer);
begin
  CellAt(AIndex).Free;
  fCells.Delete(AIndex);
end;

procedure TMapCellBindList.RemoveCell(APosX: Integer; APosY: Integer);
var
  iIndex: Integer;
begin
  iIndex := CellIndexAt(APosX, APosY);

  if (iIndex <> -1)
  then RemoveCell(iIndex);
end;

procedure TMapCellBindList.RemoveCell(APosition: TPoint);
var
  iIndex: Integer;
begin
  iIndex := CellIndexAt(APosition);

  if (iIndex <> -1)
  then RemoveCell(iIndex);
end;

procedure TMapCellBindList.RemoveCell(const AName: string);
var
  iIndex: Integer;
begin
  iIndex := CellIndexAt(AName);

  if (iIndex <> -1)
  then RemoveCell(iIndex);
end;

function TMapCellBindList.CellIndexAt(APosX: Integer; APosY: Integer): Integer;
var
  I: Integer;
  iPos: TPoint;
begin
  Result := -1;
  iPos := Point(APosX, APosY);

  for I := 0 to fCells.Count - 1
  do if (CellAt(I).fData.Position = iPos)
  then Exit(I);
end;

function TMapCellBindList.CellIndexAt(APosition: TPoint): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to fCells.Count - 1
  do if (CellAt(I).fData.Position = APosition)
  then Exit(I);
end;

function TMapCellBindList.CellIndexAt(const AName: string): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to fCells.Count - 1
  do if (CellAt(I).fData.CellName.Equals(AName))
  then Exit(I);
end;

function TMapCellBindList.CellAt(AIndex: Integer): TMapCell;
begin
  Result := fCells[AIndex];
end;

function TMapCellBindList.CellAt(APosX: Integer; APosY: Integer): TMapCell;
var
  iIndex: Integer;
begin
  Result := nil;
  iIndex := CellIndexAt(APosX, APosY);

  if (iIndex <> -1)
  then Result := CellAt(iIndex);
end;

function TMapCellBindList.CellAt(APosition: TPoint): TMapCell;
var
  iIndex: Integer;
begin
  Result := nil;
  iIndex := CellIndexAt(APosition);

  if (iIndex <> -1)
  then Result := CellAt(iIndex);
end;

function TMapCellBindList.CellAt(const AName: string): TMapCell;
var
  iIndex: Integer;
begin
  Result := nil;
  iIndex := CellIndexAt(AName);

  if (iIndex <> -1)
  then Result := CellAt(iIndex);
end;

procedure TMapCelLBindList.Clear();
begin
  while (fCells.Count > 0)
  do RemoveCell(fCells.Count - 1);
end;


procedure TMapCellBindList.SaveData(AIni: TCustomIniFile);
var
  I: Integer;
begin
  AIni.WriteInteger(TMapCellBindList.ClassName, 'CellCount', fCells.Count);
  AIni.WriteString(TMapCellBindList.ClassName, 'AssociatedAthlas', fAssociatedAthlas);

  for I := 0 to fCells.Count - 1
  do CellAt(I).SaveData(AIni, I);
end;

procedure TMapCellBindList.LoadData(AIni: TCustomIniFile);
var
  iCnt: Integer;
  I: Integer;
  iCell: TMapCell;
begin
  Clear;
  iCnt := AIni.ReadInteger(TMapCellBindList.ClassName, 'CellCount', 0);
  fAssociatedAthlas := AIni.ReadString(TMapCellBindList.ClassName, 'AssociatedAthlas', '');

  for I := 0 to iCnt -1
  do begin
    iCell := AddCell;
    iCell.LoadData(AIni, I);
  end;
end;

procedure TMapCellBindList.SaveToFile(const AFileName: string);
var
  iIni: TMemIniFile;
begin
  iIni := TMemIniFile.Create(AFileName);

  try
    SaveData(iIni);
    iIni.UpdateFile;
  finally
    iIni.Free;
  end;
end;

procedure TMapCellBindList.LoadFromFile(const AFileName: string);
var
  iIni: TMemIniFile;
begin
  iIni := TMemIniFile.Create(AFileName);

  try
    LoadData(iIni);
  finally
    iIni.Free;
  end;
end;

end.
