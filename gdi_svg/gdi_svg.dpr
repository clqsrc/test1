program gdi_svg;

uses
  Forms,
  gsMainForm in 'gsMainForm.pas' {Form1},
  frmDraw in 'frmDraw.pas' {formDraw};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TformDraw, formDraw);
  Application.Run;
end.
