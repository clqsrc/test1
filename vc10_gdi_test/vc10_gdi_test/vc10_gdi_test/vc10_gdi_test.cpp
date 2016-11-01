// vc10_gdi_test.cpp : 定义控制台应用程序的入口点。
//

// vs2010下release版本调试设置
// 设置在Release模式下调试的方法：
// 1.工程项目上右键 -> 属性
// 2.c++ -> 常规 -〉调试信息格式    选  程序数据库(/Zi)或(/ZI), 注意：如果是库的话，只能(Zi) //默认 Zi
// 3.c++ -> 优化 -〉优化            选  禁止（/Od） //默认 O2
// 4.连接器 -〉调试 -〉生成调试信息 选  是 （/DEBUG）

// 要用 wx 库,工程必须是 "使用多字节字符集"

#include "stdafx.h"

#include <wx/wxprec.h>
#ifndef WX_PRECOMP
#include <wx/wx.h>
#endif

#include <wx/treectrl.h>


int _tmain(int argc, _TCHAR* argv[])
{
	int i = 1;

	printf("%i", i);

	return 0;
}//

