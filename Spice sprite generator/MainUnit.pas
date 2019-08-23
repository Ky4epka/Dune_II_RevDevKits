unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.Generics.Collections, Vcl.Samples.Spin;

const
  OriginalFileName = 'original.bmp';
  OutputDir = 'Output';
  DefaultFileNameFormat = 'sprite%d.bmp';
  GenerateColors: Array [0..1] of TColor = ($0024B0,
                                            $006CD8);

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    imOriginalSprite: TImage;
    Label1: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    Panel5: TPanel;
    imResultSprite: TImage;
    btGenerate: TButton;
    btSave: TButton;
    SaveDialog1: TSaveDialog;
    tbRatio: TTrackBar;
    seValue: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure btGenerateClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure tbRatioChange(Sender: TObject);
    procedure seValueChange(Sender: TObject);
  private
    fOriginal: TBitmap;
    fComposition: TBitmap;
    fResult: TBitmap;
    fRateInt: Integer;
    fFromUpdate: Boolean;
    { Private declarations }
  public
    { Public declarations }

    procedure Perform();
    procedure Generate();
    procedure SaveToFile(const AFileName: String);
    procedure UpdateUI(Handle: Boolean);
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure ClearBitmap(AImage: TBitmap; AClearColor: TColor);
var
  I, J: Integer;
  Pixel: PRGBQuad;
begin
  AImage.Canvas.Pixels[0,0] := AClearColor;
  for I := 0 to AImage.Height - 1 do
  begin
    Pixel := AImage.ScanLine[I];

    for J := 0 to AImage.Width - 1 do
    begin
      Pixel^.rgbRed := GetRValue(AClearColor);
      Pixel^.rgbGreen := GetGValue(AClearColor);
      Pixel^.rgbBlue := GetBValue(AClearColor);
      Pixel^.rgbReserved := 0;
      Inc(Pixel, 1);
    end;
  end;
end;


procedure FillNoise(AImage: TBitmap; ARate: Single; ANoiseColors: Array of TColor);
var
  I, J, RatedCount, Pos: Integer;
  Pixel: PRGBQuad;
  FreePixels: TList<TPoint>;
  Point: TPoint;
  Color: TColor;
begin
  FreePixels := TList<TPoint>.Create();
  ClearBitmap(AImage, clBlack);

  try
    for I := 0 to AImage.Height - 1
    do for J := 0 to AImage.Width - 1
       do FreePixels.Add(TPoint.Create(J, I));

    RatedCount := Round(FreePixels.Count * ARate);
    I := 0;
    while (FreePixels.Count > 0) and
          (I < RatedCount)
    do begin
      Pos := Random(FreePixels.Count - 1);
      Point := FreePixels[Pos];
      FreePixels.Delete(Pos);
      J := Round(Random() * (High(ANoiseColors) - Low(ANoiseColors))) + Low(ANoiseColors);
      Color := ANoiseColors[J];
      Pixel := Pointer(Integer(AImage.ScanLine[Point.Y]) + Point.X * 4);
      Pixel^.rgbRed := GetRValue(Color);
      Pixel^.rgbGreen := GetGValue(Color);
      Pixel^.rgbBlue := GetBValue(Color);
      Pixel^.rgbReserved := 255;
      Inc(I);
    end;
    
  finally
    FreePixels.Free;
  end;
end;

procedure TfmMain.Perform;
begin
  fOriginal.LoadFromFile(OriginalFileName);
  imOriginalSprite.Picture.Assign(fOriginal);
  fComposition.SetSize(fOriginal.Width, fOriginal.Height);
  fResult.SetSize(fOriginal.Width, fOriginal.Height);
end;

procedure TfmMain.Generate;
begin
  FillNoise(fResult, tbRatio.Position / tbRatio.Max, GenerateColors);
  fComposition.Canvas.Draw(0, 0, fOriginal);
  fComposition.Canvas.Draw(0, 0, fResult);
  imResultSprite.Picture.Assign(fComposition);
end;

procedure TfmMain.SaveToFile(const AFileName: string);
begin
  fResult.SaveToFile(AFileName);
end;

procedure TfmMain.seValueChange(Sender: TObject);
begin
  if (fFromUpdate)
  then Exit;

  fRateInt := seValue.Value;
  UpdateUI(true);
end;

procedure TfmMain.tbRatioChange(Sender: TObject);
begin
  if (fFromUpdate)
  then Exit;

  fRateInt := tbRatio.Position;
  UpdateUI(true);
end;

procedure TfmMain.UpdateUI(Handle: Boolean);
begin
  fFromUpdate := true;
  try
    seValue.Value := fRateInt;
    tbRatio.Position := fRateInt;
  finally
    fFromUpdate := false;
  end;
end;

procedure TfmMain.btGenerateClick(Sender: TObject);
begin
  Generate();
end;

procedure TfmMain.btSaveClick(Sender: TObject);
var
  ExeDir: String;
begin
  ExeDir := ExtractFileDir(ParamStr(0));

  if (SaveDialog1.InitialDir = '')
  then begin
    if (ForceDirectories(IncludeTrailingPathDelimiter(ExeDir) + OutputDir)) then
    begin
      SaveDialog1.InitialDir := IncludeTrailingPathDelimiter(ExeDir) + OutputDir;
    end;
  end;

  SaveDialog1.FileName := Format(DefaultFileNameFormat, [fRateInt]);
  if (SaveDialog1.Execute)
  then begin
    SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fOriginal := TBitmap.Create;
  fComposition := TBitmap.Create;
  fComposition.PixelFormat := pf32bit;
  fComposition.AlphaFormat := afIgnored;
  fResult := TBitmap.Create;
  fResult.HandleType := bmDIB;
  fResult.PixelFormat := pf32bit;
  fResult.AlphaFormat := afPremultiplied;
  Perform();
end;

end.
