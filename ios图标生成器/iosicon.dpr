program iosicon;

uses
  Forms,
  uMainIosIcon in 'uMainIosIcon.pas' {frmMainIosIcon},
  uFormImageNormal in 'uFormImageNormal.pas' {frmImageNormal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainIosIcon, frmMainIosIcon);
  Application.CreateForm(TfrmImageNormal, frmImageNormal);
  Application.Run;
end.
