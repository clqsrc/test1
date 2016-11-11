package com.example.fuyoo_trunk;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.Button;
import apublic.Functions;
import android.content.*; //for Intent


//新建登录窗口
public class FormLogin extends Activity 
{
	FormLogin _this;
	
    @Override
    protected void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        
        //setContentView(R.layout.activity_form_t1); return;
        
        ///*
        //--------------------------------------------------
        _this = this;
        //--------------------------------------------------
        //全屏,不显示标题头
        Functions.SetFullScreen(this);
        
        //
        //确定界面的布局
		AbsoluteLayout abslayout=new AbsoluteLayout (this);
        setContentView(abslayout);
        
        View temp = new View(this);

        temp.setId(1);

        //this.addView(temp);
        
        //创建一个button按钮
        Button btn1 = new Button(this);
        btn1.setText("this is a button2");
        btn1.setId(1);
        //确定这个控件的大小和位置
        AbsoluteLayout.LayoutParams lp1 =
	        new AbsoluteLayout.LayoutParams(
		        ViewGroup.LayoutParams.WRAP_CONTENT,
		        ViewGroup.LayoutParams.WRAP_CONTENT,
		        0,100);
        abslayout.addView(btn1, lp1);
        
        //--------------------------------------------------
        //注意,这个是默认 xml 文件里的,会和上面的动态创建冲突的
        //setContentView(R.layout.activity_main);
        //*/
        
        //设置按钮事件
        SetOnClick(btn1);
        
    }//
    
    
    //有什么用
    @Override
    public boolean onCreateOptionsMenu(Menu menu) 
    {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }//    
    
    //设置按钮事件
    void SetOnClick(Button button)
    {
    	FormLogin tmp = this;
//    	button.setOnClickListener(new Button.OnClickListener() { //更准确点应该是View.OnClickListener
//    	    public void onClick(View v)
//    	    {
//    	        //this.ShowLogin(); //no
//    	        //tmp.ShowLogin(); //no
//    	    	////_this.ShowLogin(); //yes
//    	    	
//    	    	Functions.ShowMessage("aaa", FormLogin.this);
//    	    }
//    	});    	
    	
    	//this.getWindow().getDecorView() 取 activity 的 当前 view
    	//Functions.SetOnClick(button, this, getWindow().getDecorView(), "ShowLogin");
    	Functions.SetOnClick(button, "ShowLogin", this);
    	
    }//
    
    //
    public void ShowLogin()
    {
    	Functions.ShowMessage("bbb", FormLogin.this);
        //新建一个Intent对象 
//        Intent intent = new Intent();
//        intent.putExtra("name","LeiPei");    
//        //指定intent要启动的类
//        intent.setClass(Activity01.this, Activity02.class);
//        //启动一个新的Activity
//        Activity01.this.startActivity(intent);
//        //关闭当前的Activity
//        Activity01.this.finish();
    	
    }//
    
    
}//


