unit uNBServer;

//���������̰߳�ȫ���������,�����ļ�
//����Ҫ����:
//1.���Ʒ��Ͱ��Ĵ�С,ÿ�����ӵĺ��ܵĶ�Ӧ������.
//2.���ƽ��հ��ľ���С,Ŀǰֻ������ÿ�����ӵ�.

interface

uses
  Windows, WinSock, SysUtils, Classes, ExtCtrls, DateUtils,
  uSocketFunction;

const
  NBS_MAX_CONNECT = 2000;//���������,Ŀǰ֧�� 2000 �Ϳ�����

type
  TSocket = WinSock.TSocket;//Cardinal;//u_int;//clq //c ����ԭ�����ȷ���޷��ŵ�//TSocket ����������//IdWinSock2 ������// 2015/4/10 14:42:46 ����ֻ�� WinSock �ĺ���������

type
  //������ TIdTCPServer �Ľӿ���ͬ//ConnectID ��ͬ�����������е�λ��
  TOnExecute = procedure (Socket:TSocket; ConnectID:Integer) of object;

  //�������� iocp �Ľӿ�,���Բ�ʵ��//����ʵ��һ��αװ�����
  //���ӵ���
  //TOnSocketConnectProc = procedure (Socket: TSocket; var OuterFlag:Integer{���ⲿ�������ӱ�־}) of object;

type
  NBSConnect = record
    Socket:TSocket;
    //ConnectTime:DWORD;//GetTickCount ��
    ConnectTime:Int64;//UnixToDateTime ��,�� C ��������ȽϺ�, GetTickCount ��Ϊ��
    LastActive:Int64;//���һ�λʱ��,������ȫ��ʱӦ��ɾ�������ϲ��������//ֵ����ͬ��
    Connected:Boolean;//�Ƿ�������
    ShutDown:Boolean;//�Ƿ� shutdown Ҫ���������ݺ�ر� socket
    IsSet:Boolean;//û�õ��Ľڵ�

    //�����ǽ������ݵı�־,��Ҫ���������ط�
    //RECV_lastLen
    //��Ŀǰ�����д���������Ȼ���ò�����,�Ժ������ӵĴ�����Ծ����ܿ�
    RecvStream:TMemoryStream;
    SendStream:TMemoryStream;


  end;

type
  //��װ iocp ����
  TNBServer = class(TComponent)//(TObject)
  private
    listenso:TSocket;

    //ȫ���ö�ʱ��ʵ��,�����߳�
    workTimer:TTimer;
    //Ϊ�˾��������ڴ����ʹ�����鱣����������ʵ�����Ժ���������,�Լ��߽�//ʵ����ռ���˶����ڴ�
    Conncts:array[0..NBS_MAX_CONNECT-1] of NBSConnect;

    procedure OnWorkTimer(Sender: TObject);
    procedure DoAccept;
    function GetBlankConnect: Integer;
    function CanRecv(so: TSocket): Boolean;
    function CanSend(so: TSocket): Boolean;
    procedure InitConncts;
    class procedure ClearData_Fun(var Memory: TMemoryStream;
      dataLen: Integer);
    function ReadData(Socket: TSocket; ConnectID:Integer):Integer;
    function GetConnect(ConnectID: Integer;
      var Connect: NBSConnect): Boolean;
    function SendData(Socket: TSocket; ConnectID: Integer): Integer;

  public
    port:Integer;

    //��̫׼ȷ��������
    ConnectedCount:Integer;

    //������ TIdTCPServer �Ľӿ���ͬ
    OnExecute:TOnExecute;

    //������û�������㳬ʱ//Ĭ��Ϊ 10 ��
    timeOut:Integer;

    //�� indy OnExecute �� ReadBuffer ���ƵĽӿ�//indy ��һ�����ȡ���,����ӿ���Ҫ��ȡ���,���سɹ�ʱ�ű�ʾ�����
    //procedure TIdTCPConnection.ReadBuffer(var ABuffer; const AByteCount: Integer);
    procedure ReadBuffer(var ABuffer; const AByteCount: Integer; Socket: TSocket; ConnectID:Integer);

    //���׳��쳣��
    function Read(var Buffer; Count: Integer; Socket: TSocket; ConnectID:Integer): Longint;

    //����һ�������� //�ӿ�ͬ���� WriteBuffer
    procedure SendBuffer(const Buffer; Count: Longint; Socket: TSocket; ConnectID:Integer);
    //����һ���� //�ӿ�ͬ���� WriteStream
    procedure SendStream(AStream: TMemoryStream; Socket: TSocket; ConnectID:Integer);


    //�� indy ��ͬ���� ReadBuffer,Read ֮������ݲ���Ҫ�Ļ�Ҫ�ֹ�����//�ƺ���̫��,��üӸ���־���û�ѡ���Ƿ��ֹ�����
    procedure ClearReadData(Socket: TSocket; ConnectID:Integer);

    //�ر�һ������
    procedure CloseConnect(Socket:TSocket; ConnectID:Integer);
    //ȫ��������ɺ��Զ��ر�,������ԭʼ shutdown api ����
    procedure ShutDownConnect(Socket: TSocket; ConnectID: Integer);

    //���� OnExcute �е� TIdTCPConnection.RecvBufferSize
    function RecvBufferSize(Socket:TSocket; ConnectID:Integer):Integer;

    function Active:Boolean;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  //������˵�Ѿ��ж�ʱ���ڹ����˾�Ҫ�ȴ���һ��,����û�� sleep ����������ѭ��
  g_atWorkTimer:Boolean = False;  

implementation

uses
  uLogFile;

{ TNBServer }

function TNBServer.Active: Boolean;
begin
  Result := False;

  if not ListenPort(self.listenso, port) then Exit;

  SetNoBlock(self.listenso);

  workTimer.Interval := 1;//û�����,��ʵ�� 10 ���
  workTimer.Enabled := True;

  Result := True;
end;

constructor TNBServer.Create(AOwner: TComponent);
begin
  //inherited;
  inherited Create(AOwner);

  //������û�������㳬ʱ//Ĭ��Ϊ 10 ��
  timeOut := 10;


  //��ʼ����������
  Self.InitConncts;

  workTimer := TTimer.Create(Self);
  workTimer.OnTimer := Self.OnWorkTimer;

end;

destructor TNBServer.Destroy;
begin
  workTimer.Enabled := False;
  OnExecute := nil;

  inherited Destroy;
end;

//ȡһ��û�ù�������������//��һ��,����̫��������
function TNBServer.GetBlankConnect:Integer;
var
  i:Integer;
begin
  Result := -1;

  for i := 0 to NBS_MAX_CONNECT-1 do
  begin
    if Conncts[i].IsSet = False then
    begin
      Result := i;
      Break;
    end;

  end;

end;


//��ʼ����������
procedure TNBServer.InitConncts;
var
  i:Integer;
begin
  for i := 0 to NBS_MAX_CONNECT-1 do
  begin
    Conncts[i].RecvStream := TMemoryStream.Create;
    Conncts[i].SendStream := TMemoryStream.Create;

  end;

end;


//�������ӵĹ���
procedure TNBServer.DoAccept;
var
  so:TSocket;
  index:Integer;
begin
  if not AcceptSocket(listenso, so) then Exit;
  SetNoBlock(so);

  index := GetBlankConnect;
  if index = -1 then
  begin
    closesocket(so);//û�취,û�п�λ����
    Exit;
  end;

  Conncts[index].IsSet := True;
  Conncts[index].Socket := so;
  Conncts[index].ConnectTime := DateTimeToUnix(now);
  Conncts[index].Connected := True;
  Conncts[index].ShutDown := False;//�Ƿ� shutdown Ҫ���������ݺ�ر� socket
  Conncts[index].LastActive := DateTimeToUnix(now);

  //_send(so, 'aaa', 2, 0);//test

end;

function TNBServer.CanRecv(so: TSocket):Boolean;
var
  addr:sockaddr_in;//TInAddr;//TSockAddrIn
  arg:Integer;
  recvSet:TFDSet;
  r:Integer;
  tmOut:TTimeVal;
  SctTimeOut:Integer;
  errno:Integer;
  err: string;

begin
  Result := False;
  //if Connect.ShutDown=True then Exit;//����,Ӧ�÷ŵ� canread ��

  tmOut.tv_sec := 0;//20;//2;
  tmOut.tv_usec := 0;
  FD_ZERO(recvSet);
  FD_SET(so, recvSet);

  //�󲿷ִ���ֻ�����ж��Ƿ�ɶ�,��Ҳ����Ϊ�����жϿ�д
  //r := select(0, @recvSet, @recvSet, nil, @tmOut);
  r := select(0, @recvSet, 0,  nil, @tmOut);//ֻ�жϿɶ�
  if (r = 0) or (r = SOCKET_ERROR) then
  begin
    //ErrMsg := '���ӷ�����ʧ�ܣ�';
    Result := False;
    exit;
  end;

  Result := True;

end;

function TNBServer.CanSend(so: TSocket):Boolean;
var
  addr:sockaddr_in;//TInAddr;//TSockAddrIn
  arg:Integer;
  recvSet:TFDSet;
  r:Integer;
  tmOut:TTimeVal;
  SctTimeOut:Integer;
  errno:Integer;
  err: string;

begin

  tmOut.tv_sec := 0;//20;//2;
  tmOut.tv_usec := 0;
  FD_ZERO(recvSet);
  FD_SET(so, recvSet);

  //�󲿷ִ���ֻ�����ж��Ƿ�ɶ�,��Ҳ����Ϊ�����жϿ�д
  //r := select(0, @recvSet, @recvSet, nil, @tmOut);
  //r := select(0, @recvSet, 0, nil, @tmOut);//ֻ�жϿɶ�
  r := select(0, 0, @recvSet, nil,  @tmOut);//ֻ�жϿɶ�//�����ǿ�д
  if (r = 0) or (r = SOCKET_ERROR) then
  begin
    //ErrMsg := '���ӷ�����ʧ�ܣ�';
    Result := False;
    exit;
  end;

  Result := True;

end;


function TNBServer.GetConnect(ConnectID:Integer; var Connect:NBSConnect):Boolean;
begin
  Result := False;

  if ConnectID<0 then Exit;
  if ConnectID>=NBS_MAX_CONNECT then Exit;

  Connect := self.Conncts[ConnectID];

  Result := True;
end;

//closesocket(Socket); //�½ӿں� iocp ��һ��,������Ҫ����ԭʼ socket �ر�,��Ϊû����⵽�ر��ź�
//�ر�һ������,���ȴ�������ȫ������
procedure TNBServer.ShutDownConnect(Socket:TSocket; ConnectID:Integer);
var
  //s:TMemoryStream;

  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  //closesocket(Connect.Socket);
  //shutdown(Socket, 0); //0 �����ٶ���1������д��2 ��д������//ʵ����Ҳ���� shutdown ��Ϊ���������Ƿ�Ƭ��,��Щ��Ƭ�������ﻹû�ܽ��뻺����,
  //Ӧ���ڷ��͹������ж�ȫ�����ͺ�� shutdown

  //s := self.Conncts[ConnectID].RecvStream;
  //s.Clear;

  Connect.RecvStream.Clear;
//  Connect.SendStream.Clear;//�������ɲ������

  //--------------------------------------------------
  //�� TNBServer.DoAccept �еĹ����෴
//  Conncts[ConnectID].IsSet := False;
  //Conncts[index].Socket := so;
  //Conncts[index].ConnectTime := DateTimeToUnix(now);
//  Conncts[ConnectID].Connected := False;
  Conncts[ConnectID].ShutDown := True;
  //Conncts[index].LastActive := DateTimeToUnix(now);


end;


//�ر�һ������
procedure TNBServer.CloseConnect(Socket:TSocket; ConnectID:Integer);
var
  //s:TMemoryStream;

  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  if Connect.ShutDown=False then //�Ѿ� shutdown �Ĳ�Ҫ�� closesocket ��Ϊ��������һ�����������
  closesocket(Connect.Socket);

  //s := self.Conncts[ConnectID].RecvStream;
  //s.Clear;

  Connect.RecvStream.Clear;
  Connect.SendStream.Clear;

  //--------------------------------------------------
  //�� TNBServer.DoAccept �еĹ����෴
  Conncts[ConnectID].IsSet := False;
  //Conncts[index].Socket := so;
  //Conncts[index].ConnectTime := DateTimeToUnix(now);
  Conncts[ConnectID].Connected := False;
  //Conncts[index].LastActive := DateTimeToUnix(now);


end;


procedure TNBServer.OnWorkTimer(Sender: TObject);
var
  i:Integer;
  count:Integer;
  r:Integer;
  now_sec:Int64;
begin

  try
    //������˵�Ѿ��ж�ʱ���ڹ����˾�Ҫ�ȴ���һ��,����û�� sleep ����������ѭ��
    if g_atWorkTimer=True then Exit;
    g_atWorkTimer := True;
    Sleep(1);//�⼸��ѡ��Խ��� cpu ռ�û��Ǻ��а�����,�����Լ������ʱ�ͺõ��򿪽��в���

    //--------------------------------------------------

    count := 0;

    //��������
    DoAccept;

    now_sec := DateTimeToUnix(now);


    for i := 0 to NBS_MAX_CONNECT-1 do
    begin
      if Conncts[i].IsSet = False then Continue;

      if Conncts[i].Connected then Inc(count);

      //��ȡ
      //if CanRecv(Conncts[i].Socket) then
      if (Conncts[i].ShutDown=False)and(CanRecv(Conncts[i].Socket)) then //shutdown ������¾Ͳ�����
      begin
        r := ReadData(Conncts[i].Socket, i);

        if r = 0 then //select ��Ч֮����Ȼ��ȡΪ 0 �Ǿ��ǶϿ�������//�Լ� shutdown ���� close �ǵ����������
        begin

          //closesocket(Conncts[i].Socket);
          CloseConnect(Conncts[i].Socket, i);
        end;

        Conncts[i].LastActive := now_sec;//Ҫ���ûʱ��,����ʱҪ��Ҫ��?

        Conncts[i].RecvStream.Seek(0, soFromBeginning);//Ҫ�ƶ���ȡλ�õ���ǰ,�����¼��е��û��쳣ʧ��

        if Assigned(Self.OnExecute) then Self.OnExecute(Conncts[i].Socket, i);
      end;

      //select �жϵĶϿ��¼��������ر�,��������,��Ҫ�жϳ�ʱ
      if (Conncts[i].Connected)and(now_sec - Conncts[i].LastActive > timeOut) then
      begin
        CloseConnect(Conncts[i].Socket, i);
      end;

      //����
      if CanSend(Conncts[i].Socket) then
      begin
        //��ȡ�����������ٴ����¼�,�������ȴ����¼��ٷ�������//��������Ӧ�ô�������һ���Լ����¼�
        //if Assigned(Self.OnExecute) then Self.OnExecute(Conncts[i].Socket, i);

        r := SendData(Conncts[i].Socket, i);


        //��ʵ��һ���ܷ������ݵ�ʱ����Ǹ�������,������Ϊ���ӵ��¼�

      end;


    end;

    Self.ConnectedCount := count;

  finally
    //Sleep(1);//��Ҫ��������
    g_atWorkTimer := False;
  end;
end;


//��������,����õ��Ĳ�������,�ͷ������˵Ĵ�����һ����
class procedure TNBServer.ClearData_Fun(var Memory:TMemoryStream; dataLen:Integer);
var
  tmp:TMemoryStream;
  p:PAnsiChar;
  clearSize:Integer;
begin

  if (dataLen<=0) or (dataLen>Memory.Size) then Exit;

  if (dataLen = Memory.Size) then//ȫ������Ļ���վ�����
  begin
    Memory.Clear;
    Exit;
  end;

  clearSize := Memory.Size - dataLen;
  if (clearSize > 200 * 1024 * 1024) then
  begin
    MessageBox(0, PChar('�ͷų����쳣 [' + IntToStr(dataLen) + ']'), '', 0);
    Memory.Clear;
    Exit;
  end;

  tmp := TMemoryStream.Create;


//  helper.FMemory.Seek(dataLen, soBeginning);//û���������Ǳ���ȫ��
  Memory.SaveToStream(tmp);

  //p := PAnsiChar(FMemory.Memory);
  p := PAnsiChar(tmp.Memory);
  p := p + dataLen;

  //tmp.WriteBuffer(p, helper.FMemory.Size - dataLen);//������쳣
  //tmp.WriteBuffer(p^, FMemory.Size - dataLen);//ע������ ָ����÷�

  Memory.Clear;
  Memory.WriteBuffer(p^, tmp.Size - dataLen);//ע������ ָ����÷�


//  FMemory.Free;
//  FMemory := tmp;
  tmp.Free;


end;

//�Լ���ȡ����
function TNBServer.ReadData(Socket: TSocket; ConnectID:Integer):Integer;
var
  s:TMemoryStream;

  buf:array[0..4096-1] of AnsiChar;
  r:Integer;
  Connect:NBSConnect;

begin
  //Result := 0;//Ϊ 0 ��ʾ���ӹر���,��������ȡ��Ĭ��ֵ
  Result := -1;//Ϊ 0 ��ʾ���ӹر���,��������ȡ��Ĭ��ֵ

  if GetConnect(ConnectID, Connect)=False then Exit;
  //if Connect.ShutDown=True then Exit;//����,Ӧ�÷ŵ� canread ��

  s := self.Conncts[ConnectID].RecvStream;

  r := WinSock.recv(Socket, buf, SizeOf(buf), 0);
  //r := recv(FSocket, buf, 8, 0);//test
  if r>0 then
  begin
    s.Seek(0, soFromEnd);//ȷ��������������ĩβ

    //ע�ⲻ���� FMemory.WriteBuffer(buf, bufLen); ����˵����������ָ��,Ҳ���ڲ���ת��һ��ָ��?
    s.WriteBuffer(buf, r);
    s.Seek(0, soFromBeginning);//Ҫ�ƶ���ȡλ�õ���ǰ


    //if FMemory.Size > 1024 * 1024 * 2 then
    if s.Size > 1024 * 1024 * 100 then
    begin
      //MessageBox(0, '�������Ӵӷ�����������̫�����ݶ�δ����', '�ڲ�����', 0);
      LogFile('�������Ӵӷ�����������̫�����ݶ�δ����');
    end;
  end;

  Result := r;

end;


//�Լ�������
function TNBServer.SendData(Socket: TSocket; ConnectID:Integer):Integer;
var
  //s:TMemoryStream;

  //buf:array[0..4096-1] of AnsiChar;
  r:Integer;
  Connect:NBSConnect;

begin
  //Result := 0;//Ϊ 0 ��ʾ���ӹر���,��������ȡ��Ĭ��ֵ
  Result := -1;//Ϊ 0 ��ʾ���ӹر���,��������ȡ��Ĭ��ֵ

  if GetConnect(ConnectID, Connect)=False then Exit;

  if Connect.SendStream.Size>0 then
  begin

    r := WinSock.send(Socket, Connect.SendStream.Memory^, Connect.SendStream.Size, 0);//���������ʹʧ�ܶ� cpu ������Ҳ�ǳ���,����Ҫ���Ʒ��ͻ����С

    if r>0 then
    begin
      ClearData_Fun(Connect.SendStream, r);
      Connect.SendStream.Seek(0, soFromBeginning);//Ҫ�ƶ���ȡλ�õ���ǰ

    end;
    Result := r;
  end;

  //���������ݺ�,����� shutdown ����,�������ر�//���յ�ʱ���� shutdown Ҳ��ʾ����������
  if (Connect.SendStream.Size=0) and (Connect.ShutDown=True) then
  begin
    shutdown(Connect.Socket, 0);//shutdown(Socket, 0); //0 �����ٶ���1������д��2 ��д������
    CloseConnect(Socket, ConnectID);//���� socket api shutdown ����ܹر�
  end;


  //Result := r;

end;


//�� indy ��ͬ���� ReadBuffer,Read ֮������ݲ���Ҫ�Ļ�Ҫ�ֹ�����//�ƺ���̫��,��üӸ���־���û�ѡ���Ƿ��ֹ�����
procedure TNBServer.ClearReadData(Socket: TSocket; ConnectID:Integer);
var
  s:TMemoryStream;

  buf:array[0..4096-1] of AnsiChar;
  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  s := self.Conncts[ConnectID].RecvStream;

  ClearData_Fun(s, s.Position);

end;


//�û���ȡ����
//�� indy OnExecute �� ReadBuffer ���ƵĽӿ�//indy ��һ�����ȡ���,����ӿ���Ҫ��ȡ���,���سɹ�ʱ�ű�ʾ�����
//procedure TIdTCPConnection.ReadBuffer(var ABuffer; const AByteCount: Integer);

procedure TNBServer.ReadBuffer(var ABuffer; const AByteCount: Integer; Socket: TSocket; ConnectID:Integer);
var
  s:TMemoryStream;

  buf:array[0..4096-1] of AnsiChar;
  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  s := self.Conncts[ConnectID].RecvStream;

  //��ʵ��ȡ�������� ReadData ��
  //--------------------------------------------------
  //�����ǽ���,�����ж�,����յ��û���Ҫ�ĳ�������û�

  //�� TIdTCPConnection.ReadBuffer ��ԭ���Ͽ���������׳��쳣�����û����ݲ���,���� try//���׳��쳣��,Ҫ�� Read ����
  s.ReadBuffer(ABuffer, AByteCount);

end;

//ֱ������ TCustomMemoryStream.Read
function TNBServer.Read(var Buffer; Count: Longint; Socket: TSocket; ConnectID:Integer): Longint;
var
  s:TMemoryStream;

  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  s := self.Conncts[ConnectID].RecvStream;

  Result := s.Read(Buffer, Count);

end;

//����һ��������
procedure TNBServer.SendBuffer(const Buffer; Count: Longint; Socket: TSocket; ConnectID:Integer);
var
  //s:TMemoryStream;

  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  Connect.SendStream.Seek(0, soFromEnd);//ȷ��������������ĩβ
  Connect.SendStream.WriteBuffer(Buffer, Count);

end;

//����һ���� //�ӿ�ͬ���� WriteStream
procedure TNBServer.SendStream(AStream: TMemoryStream; Socket: TSocket; ConnectID:Integer);
var
  //s:TMemoryStream;

  r:Integer;

  Connect:NBSConnect;

begin
  if GetConnect(ConnectID, Connect)=False then Exit;

  Connect.SendStream.Seek(0, soFromEnd);//ȷ��������������ĩβ
  Connect.SendStream.WriteBuffer(AStream.Memory^, AStream.Size);

end;


function TNBServer.RecvBufferSize(Socket: TSocket;
  ConnectID: Integer): Integer;
var
  //s:TMemoryStream;

  r:Integer;

  Connect:NBSConnect;

begin
  Result := 0;
  
  if GetConnect(ConnectID, Connect)=False then Exit;

  Result := Connect.RecvStream.Size;

end;

end.