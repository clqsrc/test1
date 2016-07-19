unit stringbyte;

//System.RawByteString 和 AnsiString 都是无法在 xe10 的手机环境下使用的,这个在转换 des 加密算法等要操作原始字节的代码时就得不到正确的内容

interface

uses
  Types;

//这些函数在操作 xe10 内置默认字符串时都要先转成 gbk 或者 utf8 字符串

//代替 d7 下的 pchar 和 pbyte (xe10下 pbyte 不能直接使用)
function PByte_String(const s:string):PByte;
//代替 d7 下的 Length //函数名相似,更易修改旧代码
function Length_String(const s:string):Integer;
//Length_String 的别名,更易理解
function ByteCount(const s:string):Integer;

implementation

//以此代码为基础
//procedure TForm1.Button1Click(Sender: TObject);
//var
//  s:string;
//  p:PByte;
//  //t:RawByteString;
//begin
//  //ShowMessage(IntToStr(SizeOf(('中文'[1]))));  //确实是两个字节一个字符//unicode 的,而且手机下是 0 开始
//  s := '1中文123中文abc';
//  p := PByte(PChar(s));
//  ShowMessage(IntToStr(p[0])); //ok 手机,pc 下通用
//  ShowMessage(IntToStr(p[1])); //ok 手机,pc 下通用
//end;

//代替 d7 下的 string[i]
function PByte_String(const s:string):PByte;
var
  p:PByte;
begin
  p := PByte(PChar(s));
  //ShowMessage(IntToStr(p[0])); //ok 手机,pc 下通用
  //ShowMessage(IntToStr(p[1])); //ok 手机,pc 下通用

  Result := p;

end;

//代替 d7 下的 Length //函数名相似,更易修改旧代码
function Length_String(const s:string):Integer;
begin
  Result := 0;
  if Length(s) = 0 then Exit;

  //实际不行,手机环境下是 0 开始, pc 下是 1 开始//Result := Length(s) * SizeOf(s[0]);

  Result := Length(s);
{$IFDEF UNICODE}
  Result := Length(s) * 2;
{$ENDIF UNICODE}

end;

//Length_String 的别名,更易理解
function ByteCount(const s:string):Integer;
begin
  Result := Length_String(s);
end;


end.



