unit StickyWindowsManager;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, Vcl.Menus,
  Vcl.ExtCtrls, System.Math;

const
  DEFAULT_THREESHOLD = 25;

type
  TSide = (sLeft, sTop, sRight, sBottom);
  TSides = set of TSide;

  TStickyManager = class;

  TStickyElement = class

  private
  protected
    FManager: TStickyManager;
    FWnd: TWinControl;
    FSides: TSides;
    FSidesTest: TSides;
    FThreeshold: Integer;
    FFirstCalcUnstickDelta: Boolean;
    FUnstickDelta: TPoint;
    FUnstickDeltaLastPos: TPoint;
  public
    constructor Create;
    destructor Destroy; override;

    function SideTest(var ALeft, ATop: Integer): TSides;

    procedure Process(var ALeft, ATop: Integer);
    procedure UpdatePosition(ARecheck: Boolean);
    procedure UpToDefaultPosition(ASides: TSides);

    procedure CalcUnstickDelta(APos: TPoint);
    procedure ResetUnstickDelta;

    property Manager: TStickyManager read FManager write FManager;
    property Window: TWinControl read FWnd write FWnd;
    property Sides: TSides read FSides write FSides;
    property SidesTest: TSides read FSidesTest;
    property Threeshold: Integer read FThreeshold write FThreeshold;
    property UnstickDelta: TPoint read FUnstickDelta write FUnstickDelta;
    property UnstickDeltaLastPos: TPoint read FUnstickDeltaLastPos write FUnstickDeltaLastPos;
  end;

  TStickyManager = class

  private
  protected
    FList: TList;
    FMainElement: TWinControl;
    FDefaultThreeshold: Integer;
    FStickSubscribers: Boolean;
    FMainElementPosDelta: TPoint;
    FMainElementLastPos: TPoint;
    FFirstProcess: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetDefaultThreeshold(AValue: Integer);
    function GetDefaultThreeshold: Integer;

    function GetSubscriber(AIndex: Integer): TStickyElement; overload;
    function GetSubscriber(AWindow: TWinControl): TStickyElement; overload;
    function GetSubscribersCount: Integer;

    function SubscribeWindow(AWindow: TWinControl; ASides: TSides; AThreeshold: Integer = 0): TStickyElement;
    procedure UnsubscribeWindow(AWindow: TWinControl);
    procedure UnsubscribeElement(AElement: TStickyElement);

    procedure ClearSubscribers;

    procedure ProcessMainElement;

    property Subscribers[AIndex: Integer]: TStickyElement read GetSubscriber;
    property SubscribersCount: Integer read GetSubscribersCount;
    property DefaultThreeshold: Integer read GetDefaultThreeshold write SetDefaultThreeShold;
    property MainElement: TWinControl read FMainElement write FMainElement;
    property MainElementPosDelta: TPoint read FMainElementPosDelta write FMainElementPosDelta;
    property StickSubscribers: Boolean read FStickSubscribers write FStickSubscribers;
  end;

implementation

procedure SidesToPos(ABase, ADependent: TWinControl; ASides: TSides; var ALeft, ATop: Integer);
begin
  if (sLeft in ASides)
  then ALeft := ABase.Left - ADependent.Width
  else if (sRight in ASides)
       then ALeft := ABase.Left + ABase.Width;

  if (sTop in ASides)
  then ATop := ABase.Top - ADependent.Height
  else if (sBottom in ASides)
       then ATop := ABase.Top + ABase.Height;
end;

function _SidesTest(ABase, ATest: TWinControl; AThreeshold: Integer; var ALeft, ATop: Integer): TSides;
var
  DX, DY: Integer;
begin
  Result := [];

  DX := ALeft - ABase.Left;
  DY := ATop - ABase.Top;

  if InRange(DX, -ATest.Width - AThreeshold, -ATest.Width + AThreeshold)
  then Result := Result + [sLeft];

  if InRange(DY, -ATest.Height - AThreeshold, -ATest.Height + AThreeshold)
  then Result := Result + [sTop];

  if InRange(DX, ABase.Width - AThreeshold, ABase.Width + AThreeshold)
  then Result := Result + [sRight];

  if InRange(DY, ABase.Height - AThreeshold, ABase.Height + AThreeshold)
  then Result := Result + [sBottom];

  SidesToPos(ABase, ATest, Result, ALeft, ATop);
end;


constructor TStickyElement.Create;
begin
  Inherited Create;
  FManager := nil;
  FWnd := nil;
  FSides := [];
  FSidesTest := [];
  FThreeshold := DEFAULT_THREESHOLD;
  FFirstCalcUnstickDelta := true;
  FUnstickDelta := TPoint.Create(0,0);
  FUnstickDeltaLastPos := TPoint.Create(0,0);
end;

destructor TStickyElement.Destroy;
begin
  Inherited Destroy;
end;

function TStickyElement.SideTest(var ALeft: Integer; var ATop: Integer): TSides;
var
  iSide: Integer;
begin
  Result := _SidesTest(FManager.MainElement, FWnd, FThreeshold, ALeft, ATop);
  FSidesTest := Result;

  for iSide := Ord(Low(TSide)) to Ord(High(TSide))
  do if not (TSide(iSide) in FSides)
     then FSidesTest := FSidesTest - [TSide(iSide)];
end;

procedure TStickyElement.Process(var ALeft: Integer; var ATop: Integer);
var
  TS: TSides;
  iL, iT: Integer;
begin
  iL := ALeft;
  iT := ATop;
  TS := SideTest(iL, iT);

  if (   ((sLeft in FSides) and (sLeft in TS))
      or ((sRight in FSides) and (sRight in TS))
     )
  then ALeft := iL;

  if (   ((sTop in FSides) and (sTop in TS))
      or ((sBottom in FSides) and (sBottom in TS))
     )
  then ATop := iT;
end;

procedure TStickyElement.UpdatePosition(ARecheck: Boolean);
var
  iL, iT: Integer;
  FH, FV: Boolean;
begin
  iL := FWnd.Left;
  iT := FWnd.Top;

  if ARecheck
  then Process(iL, iT)
  else SidesToPos(FManager.MainElement, FWnd, FSidesTest, iL, iT);

  FH := (sLeft in FSidesTest) or (sRight in FSidesTest);
  FV := (sTop in FSidesTest) or (sBottom in FSidesTest);

  if (FH <> FV)
  then begin
    if (FH)
    then iT := FWnd.Top + FManager.MainElementPosDelta.Y
    else if (FV)
         then iL := FWnd.Left + FManager.MainElementPosDelta.X;
  end;

  FWnd.Left := iL;
  FWnd.Top := iT;
end;

procedure TStickyElement.UpToDefaultPosition(ASides: TSides);
begin
  FSidesTest := ASides;
  UpdatePosition(false);
end;

procedure TStickyElement.CalcUnstickDelta;
begin
  FUnstickDeltaLastPos := APos;
end;

procedure TStickyElement.ResetUnstickDelta;
begin
  FFirstCalcUnstickDelta := true;
  FUnstickDeltaLastPos := TPoint.Create(0,0);
  FUnstickDelta := TPoint.Create(0,0);
end;


constructor TStickyManager.Create;
begin
  Inherited Create;
  FList := TList.Create;
  FMainElement := nil;
  FMainElementPosDelta := TPoint.Create(0,0);
  FMainElementLastPos := TPoint.Create(0,0);
  FDefaultThreeshold := DEFAULT_THREESHOLD;
  FStickSubscribers := false;
  FFirstProcess := true;
end;

destructor TStickyManager.Destroy;
begin
  ClearSubscribers;
  FList.Free;
  Inherited Destroy;
end;

procedure TStickyManager.SetDefaultThreeshold(AValue: Integer);
begin
  FDefaultThreeshold := AValue;
end;

function TStickyManager.GetDefaultThreeshold;
begin
  Result := FDefaultThreeshold;
end;

function TStickyManager.GetSubscriber(AIndex: Integer): TStickyElement;
begin
  Result := FList[AIndex];
end;

function TStickyManager.GetSubscriber(AWindow: TWinControl): TStickyElement;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to FList.Count - 1
  do if (TStickyElement(FList[I]).Window = AWindow)
     then Exit(FList[I]);
end;

function TStickyManager.GetSubscribersCount;
begin
  Result := FList.Count;
end;

function TStickyManager.SubscribeWindow(AWindow: TWinControl; ASides: TSides; AThreeshold: Integer = 0): TStickyElement;
begin
  Result := GetSubscriber(AWindow);
  if Assigned(Result)
  then begin
    Result.Sides := ASides;
    Result.Threeshold := AThreeshold;
    Exit;
  end;

  if (AThreeshold = 0)
  then AThreeshold := DefaultThreeshold;

  Result := TStickyElement.Create;
  Result.Manager := Self;
  Result.Window := AWindow;
  Result.Sides := ASides;
  Result.Threeshold := AThreeshold;
  FList.Add(Result);
end;

procedure TStickyManager.UnsubscribeWindow(AWindow: TWinControl);
begin
  UnsubscribeElement(GetSubscriber(AWindow));
end;

procedure TStickyManager.UnsubscribeElement(AElement: TStickyElement);
var
  Idx: Integer;
begin
  Idx := FList.IndexOf(AElement);
  if (Idx <> -1) then
  begin
    FList.Delete(Idx);
    AElement.Free;
  end;
end;

procedure TStickyManager.ClearSubscribers;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1
  do TStickyElement(FList[I]).Free;

  FList.Clear;
end;

procedure TStickyManager.ProcessMainElement;
var
  I: Integer;
begin
  if FFirstProcess
  then FFirstProcess := false
  else FMainElementPosDelta := Point(FMainElement.Left, FMainElement.Top) - FMainElementLastPos;

  for I := 0 to FList.Count - 1
  do TStickyElement(FList[I]).UpdatePosition(FStickSubscribers);

  FMainElementLastPos := Point(FMainElement.Left, FMainElement.Top);
end;

end.
