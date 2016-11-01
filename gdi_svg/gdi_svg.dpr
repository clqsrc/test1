program gdi_svg;

uses
  Forms,
  gsMainForm in 'gsMainForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
