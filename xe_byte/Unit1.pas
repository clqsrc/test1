unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Path1: TPath;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  s:string;
  p:PByte;
  //t:RawByteString;
begin
  //ShowMessage(IntToStr(SizeOf(('中文'[1]))));  //确实是两个字节一个字符//unicode 的,而且手机下是 0 开始
  s := '1中文123中文abc';
  p := PByte(PChar(s));
  ShowMessage(IntToStr(p[0])); //ok 手机,pc 下通用
  ShowMessage(IntToStr(p[1])); //ok 手机,pc 下通用
end;

end.
