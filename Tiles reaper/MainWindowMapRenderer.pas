unit MainWindowMapRenderer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Reaper, MapRenderer;

type
  TfrMainWindowMapRenderer = class (TfrMapRenderer)
  public
    procedure Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); override;
    procedure Renderer_OnMouseMove(Sender: TObject;
                                   Shift: TShiftState; X, Y: Integer); override;
    procedure Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton;
                                   Shift: TShiftState; X, Y: Integer); override;
  end;

implementation


procedure TfrMainWindowMapRenderer.Renderer_OnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Inherited Renderer_OnMouseDown(Sender, Button, Shift, X, Y);

  case Button of
    TMouseButton.mbLeft:
    begin
      if (PressedCell <> nil)
      then begin
        PressedCell.Ignore := true;
      end;
    end;
    TMouseButton.mbRight:
    begin
      if (PressedCell <> nil)
      then begin
        PressedCell.Ignore := false;
      end;
    end;
    TMouseButton.mbMiddle: ;
  end;

end;


procedure TfrMainWindowMapRenderer.Renderer_OnMouseMove(Sender: TObject; Shift: TShiftState; X: Integer; Y: Integer);
var
  iCell: TCell;
begin
  Inherited Renderer_OnMouseMove(Sender, Shift, X, Y);
  iCell := CellAtPx(TPoint.Create(X, Y));

  if (mbLeft in MouseButtons) or
       (mbRight in MouseButtons)
    then begin
      if Assigned(PressedCell) and
         Assigned(iCell)
      then iCell.Ignore := PressedCell.Ignore;
    end;
end;

procedure TfrMainWindowMapRenderer.Renderer_OnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer);
begin
  Inherited Renderer_OnMouseUp(Sender, Button, Shift, X, Y);
end;

end.
