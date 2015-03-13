program ImgListEd;

uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  About in 'About.pas' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ImageList Editor';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
