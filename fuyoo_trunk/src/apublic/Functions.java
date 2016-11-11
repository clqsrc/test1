package apublic;

//类似 ios 的公用函数

import android.os.Bundle;
import android.app.Activity;
import android.app.AlertDialog;
import android.view.*;
import android.widget.Button;

import java.lang.reflect.*; //反射函数需要的


public class Functions 
{
	//还可以在配置文件中设置整个程序的风格,如果是用函数,则每个 Activity 都要这样调用
	//--------------------------------------------------
	//<!-- Application theme. -->
	//<style name="AppTheme" parent="AppBaseTheme">
	//    <!-- All customizations that are NOT specific to a particular API-level can go here. -->
	//    <!-- 隐藏状态栏 -->
	//    <item name="android:windowFullscreen">true</item>
	//    <!-- 隐藏标题栏 -->
	//    <item name="android:windowNoTitle">true</item>
	//</style>	
	//--------------------------------------------------
	static public void SetFullScreen(Activity _this)
	{
		//在Activity的onCreate()方法中的super()和setContentView()两个方法之间加入
		//--------------------------------------------------

		//隐藏标题栏
		_this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		//隐藏状态栏
		_this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
						WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
	}//
	
	//显示一个消息框
	static public void ShowMessage(String s, Activity  ct)
	{
		new AlertDialog.Builder(ct)//self)    
		.setTitle("信息")  
		.setMessage(s)  
		.setPositiveButton("确定", null)  
		.show(); 
		
	}//
	
	//设置一个按钮[其实是 view]的  onClick 事件,来自据说是 xml 设计器的源码,因为java不能直接将函数作为参数传递[只能用类],所以其原理应该是
	//类的名称反射查找
	//太复杂,其实自己用的话可以写得简单点
	static public void SetOnClick(View _view, String funcName, Activity _activity)
	{
		//据说来自 View 类的源码
		final String handlerName = funcName;
		final View view = _view; //必须用一个 final 参数送到后面的匿名函数中去才行,普通变量是不行的
		final Activity activity = _activity;
		
		//view.getContext().getClass().getMethod("");

    	//view.setOnClickListener(new OnClickListener() {
		//view.setOnClickListener(new Button.OnClickListener() {
        view.setOnClickListener(new View.OnClickListener() {
        	
            private Method mHandler;
  
            public void onClick(View v) 
            {
                    try 
                    {
                        //mHandler = view.getContext().getClass().getMethod(handlerName, View.class);
                        ////mHandler = activity.getClass().getMethod(handlerName, View.class);
                        mHandler = activity.getClass().getMethod(handlerName);
                        
                        //这个是根据方法名称,以及方法参数的类型来获取指定的方法//用错了是不行的,要根据函数原来的参数列表来取
                    } 
                    catch (NoSuchMethodException e) //没找到这个名称的函数的话
                    {
                    	Functions.ShowMessage(handlerName + "函数不存在(注意参数类型).", activity);
                    	return;
                    	
                    	//还是不要抛出异常的好,在某些模拟器上会直接崩溃
//                        throw new IllegalStateException("Could not find a method " +
//                                handlerName + "(View) in the activity "
//                                + activity.getClass() + " for onClick handler"
//                                + " on view " + activity.getClass().getName(), e);
                    }//



                    try 
                    {
                        //mHandler.invoke(getContext(), View.this);
                    	////mHandler.invoke(view.getContext(), view);
                    	mHandler.invoke(activity); //invoke 的参数也必须对得上,并且要多传递一个 this
                    } 
                    catch (IllegalAccessException e) 
                    {
                    	Functions.ShowMessage(handlerName + "函数执行异常(注意参数类型).", activity);
                    	return;
                    	
                    	//还是不要抛出异常的好,在某些模拟器上会直接崩溃                    	
//                        throw new IllegalStateException("Could not execute non "
//                                + "public method of the activity", e);

                    } 
                    catch (InvocationTargetException e) 
                    {
                    	Functions.ShowMessage(handlerName + "函数执行异常(注意参数类型).", activity);
                    	return;                    	
//                        throw new IllegalStateException("Could not execute "
//                                + "method of the activity", e);

                    }
                    catch (Exception e) 
                    {
                    	Functions.ShowMessage(handlerName + "函数执行异常(注意参数类型)." + e.getMessage(), activity);
                    	return;
                    }                    
                    //try

                }//public 

            });//setOnClickListener

		
	}//

}//

