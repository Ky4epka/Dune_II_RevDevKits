unit SpriteAthlasDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MapRenderer, Vcl.ExtCtrls, SpriteAthlasMapRenderer,
  Vcl.StdCtrls;

type
  TdlgSpriteAthlas = class(TForm)
    pRenderer: TPanel;
    gbTools: TGroupBox;
    rgMode: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rgModeClick(Sender: TObject);
  private
    fRenderer: TfrSpriteAthlasMapRenderer;
    { Private declarations }
  public
    { Public declarations }

    procedure SetAthlasImage(AImage: TBitmap);
    procedure UpdateAthlasEditMode;
  end;

var
  dlgSpriteAthlas: TdlgSpriteAthlas = nil;

implementation


{$R *.dfm}

procedure TdlgSpriteAthlas.FormCreate(Sender: TObject);
begin
  fRenderer := TfrSpriteAthlasMapRenderer.Create(Self);
  fRenderer.Parent := pRenderer;
  UpdateAthlasEditMode;
end;

procedure TdlgSpriteAthlas.FormShow(Sender: TObject);
begin
  fRenderer.Align := alClient;
end;

procedure TdlgSpriteAthlas.rgModeClick(Sender: TObject);
begin
  UpdateAthlasEditMode;
end;

procedure TdlgSpriteAthlas.SetAthlasImage(AImage: TBitmap);
begin
  fRenderer.SetMapImage(AImage);
end;

procedure TdlgSpriteAthlas.UpdateAthlasEditMode;
begin
  fRenderer.AthlasEditMode := TAthlasEditMode(rgMode.ItemIndex);
end;

end.
