unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    aaa1: TMenuItem;
    bbb1: TMenuItem;
    ccc1: TMenuItem;
    ddd1: TMenuItem;
    Timer1: TTimer;
    PopupMenu3: TPopupMenu;
    N1111: TMenuItem;
    N2221: TMenuItem;
    N3331: TMenuItem;
    N4441: TMenuItem;
    N5551: TMenuItem;
    MainMenu1: TMainMenu;
    N7771: TMenuItem;
    N8881: TMenuItem;
    aaa2: TMenuItem;
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sl:TStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  sl := TStringList.Create;
  SetCaPture(Self.Handle);
  SetForegroundWindow(Self.Handle);

  SendMessage(Self.Handle, WM_CANCELMODE, 0, 0);//这个有效果
  TrackPopupMenu(N7771.Handle,  //PopupMenu1.Items.Handle,

    TPM_RIGHTALIGN or TPM_BOTTOMALIGN or TPM_RETURNCMD or TPM_LEFTBUTTON

    , X, Y, 0 { reserved }, Handle, nil);


  //PopupMenu1.Popup(X,y);//这个会阻塞当前函数
  //PopupMenu1.Popup(X+100,y);
  Caption :=DateTimeToStr(now);

  //有可能被定时器或者是别的消息响应销毁了,所以是要判断的,即使是在一个函数中,这就使得很多地方加锁变成必须的了(可能只是模式的情况下)
//  Caption := sl.Text;
  sl.Free;
  sl := nil;
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  PopupMenu2.Popup(X,y);

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  SendMessage(Self.Handle, WM_CANCELMODE, 0, 0);//这个有效果,不过好象要用 TPM_RETURNCMD 标志手工 TrackPopupMenu 才行,直接 PopupMenu1.Popup 是不行的
  //SendMessage(PopupMenu1.Handle, WM_CANCELMODE, 0, 0);

//  PopupMenu2.Popup(0, 0);

//  if sl<>nil then
//  begin
//    sl.Free;
//    sl := nil;
//
//  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //不设置一下主窗体 Menu 属性, TrackPopupMenu 弹出的子菜单的宽度就是几乎没有(可以是会创建菜单实体)
  Self.Menu := MainMenu1;
  Self.Menu := nil;


end;

end.
