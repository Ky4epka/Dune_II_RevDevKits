unit MapCellSpace;

interface

uses
  Windows,
  SysUtils,
  Types,
  Classes,
  Graphics;

type
  TMapCellNamespaceItem = class
    Position: TPoint;
    Pivot: Boolean;
  end;

  TMapCellNamespace = class
  protected
    fItems: TList;
    fName: String;

    function ItemIndex(const APosition: TPoint): Integer;
  public
    constructor Create(const AName: String);
    destructor Destroy; override;
    procedure Clear;

    function AddItem(const APosition: TPoint; APivot: Boolean): TMapCellNamespaceItem;
    function RemoveItem(AIndex: Integer): Boolean; overload;
    function RemoveItem(const APosition: TPoint): Boolean; overload;

    function ItemAt(AIndex: Integer): TMapCellNamespaceItem; overload;
    function ItemAt(const APosition: TPoint): TMapCellNamespaceItem; overload;
    function ItemCount: Integer;

    property Name: String read fName;
  end;

  TMapCellNamespaceList = class

  protected
    fList: TList;

    function AddNamespace(const ASpaceName: string): TMapCellNamespace;
    function RemoveNamespace(AIndex: Integer): Boolean; overload;
    function RemoveNamespace(const ASpaceName: string): Boolean; overload;
    function NamespaceIndex(const ASpaceName: string): Integer;
    function NamespaceAt(AIndex: Integer): TMapCellNamespace; overload;
    function NamespaceAt(const ASpaceName: string): TMapCellNamespace; overload;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    procedure AddItem(const ASpaceName: String; AItem: TPoint; APivot: Boolean);
    procedure RemoveItem(const ASpaceName: String; AItem: TPoint);
  end;

implementation

constructor TMapCellNamespace.Create(const AName: String);
begin
  Inherited Create;
  fItems := TList.Create;
  fName := AName;
end;

destructor TMapCellNamespace.Destroy;
begin
  Clear;
  fItems.Free;
  Inherited Destroy;
end;

procedure TMapCellNamespace.Clear;
begin
  while (fItems.Count > 0)
  do RemoveItem(fItems.Count - 1);
end;

function TMapCellNamespace.ItemIndex(const APosition: TPoint): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to fItems.Count -1
  do if ItemAt(I).Position = APosition
  then Exit(I);
end;

function TMapCellNamespace.AddItem(const APosition: TPoint; APivot: Boolean): TMapCellNamespaceItem;
var
  iItem: TMapCellNamespaceItem;
  iIndex: Integer;
begin
  iIndex := ItemIndex(APosition);
  if (iIndex <> -1)
  then Exit(ItemAt(iIndex));

  iItem := TMapCellNameSpaceItem.Create;
  iItem.Position := APosition;
  iItem.Pivot := APivot;
  fItems.Add(iItem);
end;

function TMapCellNamespace.RemoveItem(AIndex: Integer): Boolean;
begin
  Result := (AIndex >= 0) and
            (AIndex < fItems.Count);

  if Result
  then begin
    ItemAt(AIndex).Free;
    fItems.Delete(AIndex);
  end;
end;

function TMapCellNamespace.RemoveItem(const APosition: TPoint): Boolean;
begin
  Result := RemoveItem(ItemIndex(APosition));
end;

function TMapCellNamespace.ItemAt(AIndex: Integer): TMapCellNamespaceItem;
begin
  if (AIndex < 0) or (AIndex >= fItems.Count)
  then Exit(nil);

  Result := fItems[AIndex];
end;

function TMapCellNamespace.ItemAt(const APosition: TPoint): TMapCellNamespaceItem;
begin
  Result := ItemAt(ItemIndex(APosition));
end;

function TMapCellNamespace.ItemCount;
begin
  Result := fItems.Count;
end;

constructor TMapCellNamespaceList.Create;
begin
  Inherited Create;
end;

destructor TMapCellNamespaceList.Destroy;
begin
  Clear;
  fList.Free;
  Inherited Destroy;
end;

procedure TMapCellNamespaceList.Clear;
begin
  while (fList.Count > 0)
  do RemoveNamespace(fList.Count - 1);
end;

function TMapCellNamespaceList.AddNamespace(const ASpaceName: string): TMapCellNamespace;
var
  iNamespace: TMapCellNamespace;
  iIndex: Integer;
begin
  iIndex := NamespaceIndex(ASpaceName);
  if iIndex <> -1
  then Exit(NamespaceAt(iIndex));

  iNamespace := TMapCellNamespace.Create(ASpaceName);
  fList.Add(iNamespace);
end;

function TMapCellNamespaceList.RemoveNamespace(AIndex: Integer): Boolean;
begin
  Result := (AIndex >= 0) and (AIndex < fList.Count);

  if (Result) then
  begin
    NamespaceAt(AIndex).Free;
    fList.Delete(AIndex);
  end;
end;

function TMapCellNamespaceList.RemoveNamespace(const ASpaceName: string): Boolean;
begin
  Result := RemoveNameSpace(NameSpaceIndex(ASpaceName));
end;

function TMapCellNamespaceList.NamespaceIndex(const ASpaceName: string): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to fList.Count - 1
  do if (NamespaceAt(I).Name.Equals(ASpaceName))
  then Exit(I);
end;

function TMapCellNamespaceList.NamespaceAt(AIndex: Integer): TMapCellNamespace;
begin
  if (AIndex >= 0) and (AIndex < fList.Count)
  then Result := fList[AIndex]
  else Result := nil;
end;

function TMapCellNamespaceList.NamespaceAt(const ASpaceName: string): TMapCellNamespace;
begin
  Result := NamespaceAt(NamespaceIndex(ASpaceName));
end;

procedure TMapCellNamespaceList.AddItem(const ASpaceName: string; AItem: TPoint; APivot: Boolean);
var
  iNamespace: TMapCellNamespace;
begin
  iNamespace := AddNamespace(ASpaceName);

  if Assigned(iNamespace)
  then iNamespace.AddItem(AItem, APivot);
end;

procedure TMapCellNamespaceList.RemoveItem(const ASpaceName: string; AItem: TPoint);
var
  iNamespace: TMapCellNamespace;
begin
  iNamespace := NamespaceAt(ASpaceName);

  if Assigned(iNamespace)
  then begin
    iNamespace.RemoveItem(AItem);

    if (iNamespace.ItemCount = 0)
    then RemoveNamespace(ASpaceName);
  end;
end;

end.
