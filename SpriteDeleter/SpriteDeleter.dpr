program SpriteDeleter;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {fmMain},
  MainWindowMapRenderer in 'MainWindowMapRenderer.pas' {frMainWindowMapRenderer: TFrame},
  MapRenderer in 'MapRenderer.pas' {frMapRenderer: TFrame},
  Reaper in 'Reaper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
