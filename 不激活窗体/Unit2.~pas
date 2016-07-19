unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TForm2 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  public
    //这个会让窗口不激活
    procedure CreateParams(var Params: TCreateParams); override;
    procedure MOUSEDOWN(var Msg:TMessage);// message WM_LBUTTONDOWN;
    procedure MOUSEACTIVATE(var Msg:TMessage); //message WM_MOUSEACTIVATE;
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;

  end;

var
  Form2: TForm2;

implementation

uses Unit1;

{$R *.dfm}

{ TForm2 }

procedure TForm2.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTTRANSPARENT;
end;


procedure TForm2.CreateParams(var Params: TCreateParams);
begin
//  Params.Style := 1140850688;
//  Params.ExStyle := 0;
                                   
  inherited CreateParams(Params); 

  //以下这些会产生边框和阴影,但不会成为不激活窗口
  with Params do
  begin
    Style := WS_POPUP or WS_BORDER;
    WindowClass.Style := WindowClass.Style or CS_SAVEBITS;
    if NewStyleControls then
      ExStyle := WS_EX_TOOLWINDOW;
    // CS_DROPSHADOW requires Windows XP or above
    if CheckWin32Version(5, 1) then
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW;
    if NewStyleControls then ExStyle := WS_EX_TOOLWINDOW;
    AddBiDiModeExStyle(ExStyle);
  end;
end;


procedure TForm2.MOUSEACTIVATE(var Msg: TMessage);
begin
//值 含义
//MA_ACTIVATE 激活窗体，但不删除鼠标消息。
//MA_NOACTIVATE 不激活窗体，也不删除鼠标消息。
//MA_ACTIVATEANDEAT 激活窗体，删除鼠标消息。
//MA_NOACTIVATEANDEAT 不激活窗体，但删除鼠标消息。

  Msg.Result := MA_NOACTIVATE;//这样确实就不激活了

  //同时要用这个显示窗体
  //SetWindowPos(form2.Handle, HWND_TOPMOST, P.X, P.Y, 0, 0, SWP_SHOWWINDOW or SWP_NOACTIVATE or SWP_NOSIZE);
  
end;

procedure TForm2.MOUSEDOWN(var Msg: TMessage);
begin
  //Msg.Result := 1;//奇怪,这个没什么用
//  Msg.Result := 0;

  //Form1.Show;
  
end;

end.
 