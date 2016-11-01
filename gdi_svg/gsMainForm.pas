unit gsMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IGDIPlus,
  Dialogs;

type
  TForm1 = class(TForm)
    procedure FormPaint(Sender: TObject);
  private
    function DrawString(pszbuf: WideString): Boolean;
    function DrawString2(pszbuf: WideString): Boolean;
    function DrawString3(pszbuf: WideString): Boolean;
    
    //һ�� Bezier ����Ҫ�ĸ���: �����˵㡢�������Ƶ�
    procedure Draw_bez(Graphics:IGPGraphics);
    procedure Draw_curve(Graphics: IGPGraphics);
  public
    { Public declarations }

    //���ִ�С
    fontSize:Integer;
    //���ֵ���Ӱ����
    shadowSize:Integer;
    //�Զ����к�������б�
    //stringsForDraw:TStringList;
    //��ʼ�߿�λ�� top,left
    drawOffTop:Integer;
    drawOffLeft:Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function TForm1.DrawString2(pszbuf: WideString):Boolean;
var
  hdcScreen: HDC;
  //hBitMap: Windows.HBITMAP;
  rct: TRect;
  graphics: IGPGraphics;     //��װһ�� GDI+ ��ͼͼ��
  fontFamily: IGPFontFamily; //�����������ƵĻ�����Ƶ�����ʽ����ĳЩ�����һ������
  path: IGPGraphicsPath;     //��ʾһϵ���໥���ӵ�ֱ�ߺ�����
  strFormat: IGPStringFormat;//��װ�ı�������Ϣ����ʾ����
  pen,pen1,pen2: IGPPen;     //�������ڻ���ֱ�ߺ����ߵĶ���
  linGrBrush,linGrBrushW: IGPLinearGradientBrush;  //ʹ�����Խ����װ Brush
  brush: IGPSolidBrush;      //���嵥ɫ���ʣ������������ͼ����״
  image: TGPImage;           //ʹ��������������Ͳ���GDI+ͼ��
  i: Integer;

  graphics_form: IGPGraphics;
  tmp:TBitmap;
  tmpg:TGPBitmap;

  st,sl:Integer;

begin
  //---------------------��ʼ����ʼ������--------------------------------------

  hdcScreen := GetDC(Self.Handle);
  //GetWindowRect(Self.Handle,rct);
  rct := GetClientRect;

  tmp := TBitmap.Create;
  tmp.Width := rct.Right - rct.Left;//100;
  tmp.Height := rct.Bottom - rct.Top;

  tmp.Canvas.TextOut(0,0,'aaa');
  tmp.Canvas.TextOut(10,10,'ccc');

  graphics := TGPGraphics.Create(tmp.Canvas.Handle);
  graphics := TGPGraphics.Create(hdcScreen);
  graphics_form := TGPGraphics.Create(hdcScreen);



  graphics.SetSmoothingMode(SmoothingModeAntiAlias); //ָ��ƽ��������ݣ�
  graphics.SetInterpolationMode(InterpolationModeHighQualityBicubic);//ָ���ĸ�Ʒ�ʣ�˫���β�ֵ

  pen := TGPPen.Create(MakeColor(155,215,215,215),3);  //��ɫ������


  //�ʰ���ˢ?����Ч��
  //if False then
  linGrBrush := TGPLinearGradientBrush.Create(MakePoint(0, drawOffTop),    //���Խ�����ʼ��
                                                MakePoint(0, Trunc((fontSize*0.5)) + drawOffTop), //���Խ����ս��
                                                MakeColor(255,255,255,255), //���Խ�����ʼɫ
                                                //MakeColor(255,30,120,195)); //���Խ������ɫ
                                                MakeColor(255,30,120,195)); //���Խ������ɫ,ע���1�������� Alpha ͨ��

  //---------------------��ʼ����������ͱ���ͼ---------------------------------- 
  //if bBack then
  if true then
  begin
    //brush := TGPSolidBrush.Create(MakeColor(25,228,228,228));
    brush := TGPSolidBrush.Create(MakeColor(100, 0,0,0));
//    pen1 := TGPPen.Create(MakeColor(155,223,223,223));
//    pen2 := TGPPen.Create(MakeColor(55,223,223,223));
//    image := TGPImage.Create('back.png');             //����ͼƬ
    graphics.FillRectangle(brush,3,5,750,90);         //��䱳����ɫ//����Ἣ���Ӱ������
//    graphics.FillRectangle(linGrBrush,3,5,750,90);         //��䱳����ɫ//����Ἣ���Ӱ������
//    graphics.DrawRectangle(pen1,2,6,751,91);          //�ڲ㱳����
//    graphics.DrawRectangle(pen2,1,5,753,93);          //��㱳����
//    graphics.DrawImage(image,600,25);
  end;
  //---------------------��ʼ������һ���ֲ�Ĵ��ڵ�λ�ã���С����״�����ݺͰ�͸����---
  //ReleaseDC(Self.Handle,hdcScreen); tmp.Free; Exit;
  tmpg := TGPBitmap.Create(tmp);
  graphics_form.DrawImage(tmpg, 0, 0);//˫����

  //---------------------��ʼ���ͷź�ɾ��--------------------------------------
  ReleaseDC(Self.Handle,hdcScreen);
  //tmpg.Free;//�ƺ�����Ҫ
  tmp.Free;

end;

function TForm1.DrawString(pszbuf: WideString):Boolean;
var
  hdcScreen: HDC;
  //hBitMap: Windows.HBITMAP;
  rct: TRect;
  graphics: IGPGraphics;     //��װһ�� GDI+ ��ͼͼ��
  fontFamily: IGPFontFamily; //�����������ƵĻ�����Ƶ�����ʽ����ĳЩ�����һ������
  path: IGPGraphicsPath;     //��ʾһϵ���໥���ӵ�ֱ�ߺ�����
  strFormat: IGPStringFormat;//��װ�ı�������Ϣ����ʾ����
  pen,pen1,pen2: IGPPen;     //�������ڻ���ֱ�ߺ����ߵĶ���
  linGrBrush,linGrBrushW: IGPLinearGradientBrush;  //ʹ�����Խ����װ Brush
  brush: IGPSolidBrush;      //���嵥ɫ���ʣ������������ͼ����״
  image: TGPImage;           //ʹ��������������Ͳ���GDI+ͼ��
  i: Integer;

  graphics_form: IGPGraphics;
  tmp:TBitmap;
  tmpg:TGPBitmap;

  st,sl:Integer;

begin
  //---------------------��ʼ����ʼ������--------------------------------------

  hdcScreen := GetDC(Self.Handle);
  //GetWindowRect(Self.Handle,rct);
  rct := GetClientRect;

  tmp := TBitmap.Create;
  tmp.Width := rct.Right - rct.Left;//100;
  tmp.Height := rct.Bottom - rct.Top;

  tmp.Canvas.TextOut(0,0,'aaa');
  tmp.Canvas.TextOut(10,10,'ccc');

  graphics := TGPGraphics.Create(hdcScreen);




  graphics.SetSmoothingMode(SmoothingModeAntiAlias); //ָ��ƽ��������ݣ�
  graphics.SetInterpolationMode(InterpolationModeHighQualityBicubic);//ָ���ĸ�Ʒ�ʣ�˫���β�ֵ

  pen := TGPPen.Create(MakeColor(155,215,215,215),3);  //��ɫ������


  //�ʰ���ˢ?����Ч��
  //if False then
  linGrBrush := TGPLinearGradientBrush.Create(MakePoint(0, drawOffTop),    //���Խ�����ʼ��
                                                MakePoint(0, Trunc((fontSize*0.5)) + drawOffTop), //���Խ����ս��
                                                MakeColor(255,255,255,255), //���Խ�����ʼɫ
                                                //MakeColor(255,30,120,195)); //���Խ������ɫ
                                                MakeColor(255,30,120,195)); //���Խ������ɫ,ע���1�������� Alpha ͨ��

  //---------------------��ʼ����������ͱ���ͼ---------------------------------- 
  //if bBack then
  if true then
  begin
    //brush := TGPSolidBrush.Create(MakeColor(25,228,228,228));
    brush := TGPSolidBrush.Create(MakeColor(100, 0,0,0));
//    pen1 := TGPPen.Create(MakeColor(155,223,223,223));
//    pen2 := TGPPen.Create(MakeColor(55,223,223,223));
//    image := TGPImage.Create('back.png');             //����ͼƬ
    graphics.FillRectangle(brush,10,10,100,100);         //��䱳����ɫ//����Ἣ���Ӱ������
//    graphics.FillRectangle(linGrBrush,3,5,750,90);         //��䱳����ɫ//����Ἣ���Ӱ������
//    graphics.DrawRectangle(pen1,2,6,751,91);          //�ڲ㱳����
//    graphics.DrawRectangle(pen2,1,5,753,93);          //��㱳����
//    graphics.DrawImage(image,600,25);
  end;
  //---------------------��ʼ������һ���ֲ�Ĵ��ڵ�λ�ã���С����״�����ݺͰ�͸����---


  //---------------------��ʼ���ͷź�ɾ��--------------------------------------
  ReleaseDC(Self.Handle,hdcScreen);
  //tmpg.Free;//�ƺ�����Ҫ
  tmp.Free;

end;

function TForm1.DrawString3(pszbuf: WideString):Boolean;
var
  hdcScreen: HDC;
  //hBitMap: Windows.HBITMAP;
  rct: TRect;
  graphics: IGPGraphics;     //��װһ�� GDI+ ��ͼͼ��
  fontFamily: IGPFontFamily; //�����������ƵĻ�����Ƶ�����ʽ����ĳЩ�����һ������
  path: IGPGraphicsPath;     //��ʾһϵ���໥���ӵ�ֱ�ߺ�����
  strFormat: IGPStringFormat;//��װ�ı�������Ϣ����ʾ����
  pen,pen1,pen2: IGPPen;     //�������ڻ���ֱ�ߺ����ߵĶ���
  linGrBrush,linGrBrushW: IGPLinearGradientBrush;  //ʹ�����Խ����װ Brush
  brush: IGPSolidBrush;      //���嵥ɫ���ʣ������������ͼ����״
  image: TGPImage;           //ʹ��������������Ͳ���GDI+ͼ��
  i: Integer;

  graphics_form: IGPGraphics;
  tmp:TBitmap;
  tmpg:TGPBitmap;

  st,sl:Integer;

begin
  //---------------------��ʼ����ʼ������--------------------------------------

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

  graphics.SetSmoothingMode(SmoothingModeAntiAlias); //ָ��ƽ��������ݣ�
  graphics.SetInterpolationMode(InterpolationModeHighQualityBicubic);//ָ���ĸ�Ʒ�ʣ�˫���β�ֵ

  pen := TGPPen.Create(MakeColor(155,215,215,215),3);  //��ɫ������


  //����Ч��//����ɫˢ��
  linGrBrush := TGPLinearGradientBrush.Create(MakePoint(0, drawOffTop),    //���Խ�����ʼ��
                                                MakePoint(0, Trunc((fontSize*0.5)) + drawOffTop), //���Խ����ս��
                                                MakeColor(255,255,255,255), //���Խ�����ʼɫ
                                                //MakeColor(255,30,120,195)); //���Խ������ɫ
                                                MakeColor(255,30,120,195)); //���Խ������ɫ,ע���1�������� Alpha ͨ��

  linGrBrush := TGPLinearGradientBrush.Create(MakePoint(0, 0),    //���Խ�����ʼ��
                                                MakePoint(0, 100), //���Խ����ս��

                                                MakeColor(255,0,0,0), //���Խ�����ʼɫ

                                                MakeColor(255,30,120,195)); //���Խ������ɫ,ע���1�������� Alpha ͨ��

  //---------------------��ʼ����������ͱ���ͼ---------------------------------- 
  //if bBack then
  if true then
  begin
    //brush := TGPSolidBrush.Create(MakeColor(25,228,228,228));
    brush := TGPSolidBrush.Create(MakeColor(100, 0,0,0));
//    pen1 := TGPPen.Create(MakeColor(155,223,223,223));
//    pen2 := TGPPen.Create(MakeColor(55,223,223,223));
//    image := TGPImage.Create('back.png');             //����ͼƬ
    graphics.FillRectangle(linGrBrush,15,15,100,100);         //��䱳����ɫ//����Ἣ���Ӱ������
//    graphics.FillRectangle(linGrBrush,3,5,750,90);         //��䱳����ɫ//����Ἣ���Ӱ������
//    graphics.DrawRectangle(pen1,2,6,751,91);          //�ڲ㱳����
//    graphics.DrawRectangle(pen2,1,5,753,93);          //��㱳����
//    graphics.DrawImage(image,600,25);
  end;

  Draw_bez(graphics);
  Draw_curve(graphics);

  //---------------------��ʼ������һ���ֲ�Ĵ��ڵ�λ�ã���С����״�����ݺͰ�͸����---
  //ReleaseDC(Self.Handle,hdcScreen); tmp.Free; Exit;
  tmpg := TGPBitmap.Create(tmp);
  graphics_form.DrawImage(tmpg, 0, 0);//˫����

  //---------------------��ʼ���ͷź�ɾ��--------------------------------------
  ReleaseDC(Self.Handle,hdcScreen);
  //tmpg.Free;//�ƺ�����Ҫ
  tmp.Free;

end;

//from http://www.cnblogs.com/del/archive/2009/12/16/1625966.html
//GdiPlus[33]: ������ͼ���������

//һ�� Bezier ����Ҫ�ĸ���: �����˵㡢�������Ƶ�
procedure TForm1.Draw_bez(Graphics:IGPGraphics);
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


const
  Pts: array [0..5] of TGPPoint = (
    (X: 10;  Y:  40),
    (X: 100; Y:  60),
    (X: 150; Y:  20),
    (X: 130; Y: 100),
    (X: 70;  Y:  80),
    (X: 30;  Y: 140));

//һ�� Bezier ����Ҫ�ĸ���: �����˵㡢�������Ƶ�
procedure TForm1.Draw_curve(Graphics:IGPGraphics);
const
  m = 180;
  n = 160;
var
  //Graphics: IGPGraphics;
  Pen: IGPPen;
  BrushBak, Brush: IGPBrush;
begin
  //Graphics := TGPGraphics.Create(Handle);
  Pen := TGPPen.Create($FFFF0000, 2);
  BrushBak := TGPSolidBrush.Create($FFD8BFD8);
  Brush := TGPSolidBrush.Create($FFFFD700);

  with Graphics do
  begin
    FillPolygon(BrushBak, Pts);
    DrawCurve(Pen, Pts);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    DrawCurve(Pen, Pts, 1.5);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    DrawCurve(Pen, Pts, 0.5);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    DrawCurve(Pen, Pts, 0);

    //
    TranslateTransform(-Transform.OffsetX, 150);

    FillPolygon(BrushBak, Pts);
    DrawClosedCurve(Pen, Pts);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    DrawClosedCurve(Pen, Pts, 1.5);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    DrawClosedCurve(Pen, Pts, 0.5);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    DrawClosedCurve(Pen, Pts, 0);

    //
    TranslateTransform(-Transform.OffsetX, n);

    FillPolygon(BrushBak, Pts);
    FillClosedCurve(Brush, Pts);
    DrawClosedCurve(Pen, Pts);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    FillClosedCurve(Brush, Pts, FillModeAlternate, 1.5);
    DrawClosedCurve(Pen, Pts, 1.5);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    FillClosedCurve(Brush, Pts, FillModeAlternate, 0.5);
    DrawClosedCurve(Pen, Pts, 0.5);
    TranslateTransform(m, 0);

    FillPolygon(BrushBak, Pts);
    FillClosedCurve(Brush, Pts, FillModeAlternate, 0);
    DrawClosedCurve(Pen, Pts, 0);
  end;
end;


procedure TForm1.FormPaint(Sender: TObject);
begin

  //DrawString('aaa����');
  DrawString3('aaa����');

end;

end.