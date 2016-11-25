unit frmDraw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IGDIPlus,
  Dialogs;

type
  TformDraw = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    function DrawString3(pszbuf: WideString): Boolean;
    procedure Draw_bez(Graphics: IGPGraphics);
    { Private declarations }
  public
    { Public declarations }
    isDown:Boolean;
    //按下移动过的各个位置
    downPoint:array of TPoint;
  end;

var
  formDraw: TformDraw;

implementation

{$R *.dfm}

//一条 Bezier 线需要四个点: 两个端点、两个控制点
procedure TformDraw.Draw_bez(Graphics:IGPGraphics);
var
  //Graphics: IGPGraphics;
  Pen: IGPPen;
  P1,C1,C2,P2: TGPPoint;
begin
  P1 := MakePoint(30, 100);
  C1 := MakePoint(120, 10);
  C2 := MakePoint(170, 150);
  P2 := MakePoint(220, 80);

  //Graphics := TGPGraphics.Create(Handle);
  Pen := TGPPen.Create($FF0000FF, 2);

  Graphics.DrawBezier(Pen, P1, C1, C2, P2);

  Pen.Width := 1;
  Pen.Color := $FFFF0000;
  Graphics.DrawRectangle(Pen, P1.X-3, P1.Y-3, 6, 6);
  Graphics.DrawRectangle(Pen, P2.X-3, P2.Y-3, 6, 6);
  Graphics.DrawEllipse(Pen, C1.X-3, C1.Y-3, 6, 6);
  Graphics.DrawEllipse(Pen, C2.X-3, C2.Y-3, 6, 6);

  Pen.Color := $FFC0C0C0;
  Graphics.DrawLine(Pen, P1, C1);
  Graphics.DrawLine(Pen, P2, C2);

end;

function TformDraw.DrawString3(pszbuf: WideString):Boolean;
var
  hdcScreen: HDC;
  //hBitMap: Windows.HBITMAP;
  rct: TRect;
  graphics: IGPGraphics;     //封装一个 GDI+ 绘图图面
  fontFamily: IGPFontFamily; //定义有着相似的基本设计但在形式上有某些差异的一组字样
  path: IGPGraphicsPath;     //表示一系列相互连接的直线和曲线
  strFormat: IGPStringFormat;//封装文本布局信息，显示操作
  pen,pen1,pen2: IGPPen;     //定义用于绘制直线和曲线的对象
  linGrBrush,linGrBrushW: IGPLinearGradientBrush;  //使用线性渐变封装 Brush
  brush: IGPSolidBrush;      //定义单色画笔，画笔用于填充图形形状
  image: TGPImage;           //使用这个类来创建和操作GDI+图像
  i: Integer;

  graphics_form: IGPGraphics;
  tmp:TBitmap;
  tmpg:TGPBitmap;

  st,sl:Integer;

begin
  //---------------------开始：初始化操作--------------------------------------

  hdcScreen := GetDC(Self.Handle);
  //GetWindowRect(Self.Handle,rct);
  rct := GetClientRect;

  tmp := TBitmap.Create;
  tmp.Width := rct.Right - rct.Left;//100;
  tmp.Height := rct.Bottom - rct.Top;

  tmp.Canvas.TextOut(0,0,'aaa');
  tmp.Canvas.TextOut(10,10,'ccc');

  graphics := TGPGraphics.Create(tmp.Canvas.Handle);
  graphics_form := TGPGraphics.Create(hdcScreen);

  graphics.SetSmoothingMode(SmoothingModeAntiAlias); //指定平滑（抗锯齿）
  graphics.SetInterpolationMode(InterpolationModeHighQualityBicubic);//指定的高品质，双三次插值

  pen := TGPPen.Create(MakeColor(155,215,215,215),3);  //颜色、宽度


  //特殊效果//渐变色刷子

  linGrBrush := TGPLinearGradientBrush.Create(MakePoint(0, 0),    //线性渐变起始点
                                                MakePoint(0, 100), //线性渐变终结点

                                                MakeColor(255,0,0,0), //线性渐变起始色

                                                MakeColor(255,30,120,195)); //线性渐变结束色,注意第1个参数是 Alpha 通道

  //---------------------开始：画背景框和背景图---------------------------------- 

  Draw_bez(graphics);


  //---------------------开始：更新一个分层的窗口的位置，大小，形状，内容和半透明度---
  //ReleaseDC(Self.Handle,hdcScreen); tmp.Free; Exit;
  tmpg := TGPBitmap.Create(tmp);
  graphics_form.DrawImage(tmpg, 0, 0);//双缓冲

  //---------------------开始：释放和删除--------------------------------------
  ReleaseDC(Self.Handle,hdcScreen);
  //tmpg.Free;//似乎不需要
  tmp.Free;

end;

procedure TformDraw.FormPaint(Sender: TObject);
begin

  DrawString3('aaa中文');

end;

procedure TformDraw.FormCreate(Sender: TObject);
begin
  Self.isDown := False;
end;

procedure TformDraw.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Self.isDown := False;
end;

procedure TformDraw.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Self.isDown := True;

  SetLength(downPoint, 0);

end;

procedure TformDraw.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p:TPoint;

begin
  if Self.isDown = False then Exit;

  SetLength(downPoint, Length(downPoint)+1);

  p.X := X; p.Y := Y;
  downPoint[Length(downPoint)-1] := p;

end;

end.
