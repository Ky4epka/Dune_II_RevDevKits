program MapBuilder;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {fmMain},
  ZoomUnit in 'ZoomUnit.pas' {fmZoom},
  ToolsUnit in 'ToolsUnit.pas' {fmTools},
  StickyWindowsManager in 'StickyWindowsManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmZoom, fmZoom);
  Application.CreateForm(TfmTools, fmTools);
  Application.Run;
end.
