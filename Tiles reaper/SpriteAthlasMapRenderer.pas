unit SpriteAthlasMapRenderer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Reaper, MapRenderer;

type
  TAthlasEditMode = (aemNone, aemClearCell);

  TfrSpriteAthlasMapRenderer = class (TfrMapRenderer)
  private
    fEditMode: TAthlasEditMode;

    procedure SetEditMode(AValue: TAthlasEditMode);
  public
    constructor Create(AOwner: TComponent);
  
    procedure Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); override;
    procedure Renderer_OnMouseMove(Sender: TObject;
                                   Shift: TShiftState; X, Y: Integer); override;
    procedure Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); override;

    property AthlasEditMode: TAthlasEditMode read fEditMode write SetEditMode;
  end;

implementation

constructor TfrSpriteAthlasMapRenderer.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
end;

procedure TfrSpriteAthlasMapRenderer.SetEditMode(AValue: TAthlasEditMode);
begin
  fEditMode := AValue;
end;

procedure TfrSpriteAthlasMapRenderer.Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Inherited Renderer_OnMouseDown(Sender, Button, Shift, X, Y);

  case Button of
    TMouseButton.mbLeft:
    begin
      if (PressedCell <> nil)
      then begin
        if Map.SpriteAtIsEmpty(PressedCell.Position)
        then begin
          ShowMessage('Is empty');
        end;
        
      end;
    end;
    TMouseButton.mbRight: ;
    TMouseButton.mbMiddle: ;
  end;
end;


procedure TfrSpriteAthlasMapRenderer.Renderer_OnMouseMove(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
var
  iCell: TCell;
begin
  Inherited Renderer_OnMouseMove(Sender, Shift, X, Y);

  case fEditMode of
    aemNone: ;
    aemClearCell:
    begin
      if (mbLeft in MouseButtons) and
         Assigned(HoveredCell) 
      then Map.SetSpriteEmpty(HoveredCell.Position);        
    end;
  end;
end;

procedure TfrSpriteAthlasMapRenderer.Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Inherited Renderer_OnMouseUp(Sender, Button, Shift, X, Y);

  case fEditMode of
    aemNone: ;
    aemClearCell:
    begin
      Map.DeleteEmptySprites;
      MapChanged;
    end;
  end;
end;

end.
