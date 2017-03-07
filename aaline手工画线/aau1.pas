unit aau1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  ca:TCanvas;
  i:Integer;
  x,y,h,w:Integer;
  yf:Double;

  //上点的距离差
  //下点的距离差
  off:Double;//本点的距离差
  color:Byte;//TColor;//

begin

  ca := TCanvas.Create;

  ca.Handle := GetDC(Self.Handle);

  ca.LineTo(100, 100);

  h := 100; w := 300;
  for i := 0 to w-1 do
  begin
    x := i;

    yf := x * (h/w);

    y := Trunc(yf);

    //ca.Pixels[x, y] := clBlack;

    //计算它上下两个点的像素值
    off := Abs(yf - y);

    color := Trunc(255 * (1 - off));

    color := 255 - color;

    ca.Pixels[x, y] := RGB(color, color, color);

  end;


  ca.Free;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  ca:TCanvas;
  i:Integer;
  x,y,h,w:Integer;
  yf:Double;

  off1:Double;//上点的距离差
  off2:Double;//下点的距离差
  off:Double;//本点的距离差
  color:Byte;//TColor;//

  procedure p1;
  begin
    y := y + 1;  //上面的点//因为 windows 的坐标问题,其实是下面的点

    //ca.Pixels[x, y] := clBlack;

    //计算它上下两个点的像素值
    off := Abs(yf - y);

    color := Trunc(255 * (1 - off));

    color := 255 - color;

    ca.Pixels[x, y] := RGB(color, color, color);

  end;
  
begin

  ca := TCanvas.Create;

  ca.Handle := GetDC(Self.Handle);

  //ca.LineTo(100, 100);

  h := 100; w := 300;
  //h := 100; w := 100;
  for i := 0 to w-1 do
  begin
    x := i;

    yf := x * (h/w);

    y := Trunc(yf);

    //ca.Pixels[x, y] := clBlack;

    //计算它上下两个点的像素值
    off := Abs(yf - y);

    color := Trunc(255 * (1 - off));

    color := 255 - color;

    ca.Pixels[x, y] := RGB(color, color, color);

    p1();//画下 y 轴下面的点

  end;


  ca.Free;

end;

end.
