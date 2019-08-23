program TilesReaper;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  Reaper in 'Reaper.pas',
  MapRenderer in 'MapRenderer.pas' {frMapRenderer: TFrame},
  OKCANCL2 in 'e:\embarcadero\rad studio 10 seattle\embarcadero\studio\17.0\ObjRepos\EN\DelphiWin32\OKCANCL2.PAS' {OKRightDlg},
  SpriteAthlasDialog in 'SpriteAthlasDialog.pas' {dlgSpriteAthlas},
  MainWindowMapRenderer in 'MainWindowMapRenderer.pas',
  SpriteAthlasMapRenderer in 'SpriteAthlasMapRenderer.pas',
  AthlasAutoBuilder in 'AthlasAutoBuilder.pas' {dlgAthlasAutobuilder};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdlgSpriteAthlas, dlgSpriteAthlas);
  Application.CreateForm(TdlgAthlasAutobuilder, dlgAthlasAutobuilder);
  Application.Run;
end.
