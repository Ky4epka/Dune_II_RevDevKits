unit MainWindowMapRenderer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MapRenderer, Reaper;

type
  TfrMainWindowMapRenderer = class(TfrMapRenderer)
  private
    fSimilarPercent: Single;
    { Private declarations }
  protected
    procedure Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); override;
    procedure Renderer_OnMouseMove(Sender: TObject;
                                   Shift: TShiftState; X, Y: Integer); override;
    procedure Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); override;
  public
    { Public declarations }

    property SimilarPercent: Single read fSimilarPercent write fSimilarPercent;
  end;

implementation

{$R *.dfm}

procedure TfrMainWindowMapRenderer.Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
var
  iX, iY: Integer;
  iCellData: TGUICell;
  iList: TList;
begin
  Inherited Renderer_OnMouseDown(Sender, Button, Shift, X, Y);

  case Button of
    TMouseButton.mbLeft:
    begin
    end;
  end;
end;

procedure TfrMainWindowMapRenderer.Renderer_OnMouseMove(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Inherited Renderer_OnMouseMove(Sender, Shift, X, Y);
end;

procedure TfrMainWindowMapRenderer.Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Inherited Renderer_OnMouseUp(Sender, Button, Shift, X, Y);
end;

end.
