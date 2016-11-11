package com.example.fuyoo_trunk;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;
import android.view.View;
import apublic.*;
import android.view.*;
import android.widget.*;
import android.content.*; //for Intent


public class MainActivity extends Activity 
{
	MainActivity _this;

    @Override
    protected void onCreate(Bundle savedInstanceState) 
    {
        super.onCreate(savedInstanceState);
        
        //--------------------------------------------------
        _this = this;
        //--------------------------------------------------
        //全屏,不显示标题头
        Functions.SetFullScreen(this);
        
        //
        //确定界面的布局
		AbsoluteLayout abslayout = new AbsoluteLayout(this);
        setContentView(abslayout);
        
        View temp = new View(this);

        temp.setId(1);

        //this.addView(temp);
        
        //创建一个button按钮
        Button btn1 = new Button(this);
        btn1.setText("this is a button");
        btn1.setId(1);
        //确定这个控件的大小和位置
        AbsoluteLayout.LayoutParams lp1 =
	        new AbsoluteLayout.LayoutParams(
		        ViewGroup.LayoutParams.WRAP_CONTENT,
		        ViewGroup.LayoutParams.WRAP_CONTENT,
		        0,100);
        abslayout.addView(btn1, lp1);
        
        //设置按钮事件
        SetOnClick(btn1);
        
        //--------------------------------------------------
        //注意,这个是默认  xml 文件里的,会和上面的动态创建冲突的
        //setContentView(R.layout.activity_main);
    }//


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
    	MainActivity tmp = this;
    	button.setOnClickListener(new Button.OnClickListener() { //更准确点应该是View.OnClickListener
    	    public void onClick(View v)
    	    {
    	        //this.ShowLogin(); //no
    	        //tmp.ShowLogin(); //no
    	    	_this.ShowLogin(); //yes
    	    }
    	});    	
    	
    }//
    
    //普通的
    void ShowLogin1()
    {
        //新建一个Intent对象 
        Intent intent = new Intent();
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);  
        ////intent.putExtra("name","LeiPei");    
        //指定intent要启动的类
        intent.setClass(MainActivity.this, FormLogin.class); //no,奇怪为何手工类不行//手工新建立的  Activity 必须在 AndroidManifest.xml  文件中声明
        //intent.setClass(MainActivity.this, FormT1.class); //ok
        //启动一个新的Activity
        MainActivity.this.startActivity(intent);
        //关闭当前的Activity
        MainActivity.this.finish();
    	
    }//
    
    //动画的
    void ShowLogin()
    {
        //新建一个Intent对象 
    	Intent intent = new Intent(MainActivity.this, FormLogin.class);
        //intent.putExtra("type", Constant.REGIST_CHOOSE_XIAOQU);
        //startActivityForResult(intent, Constant.REGIST_CHOOSE_XIAOQU);
    	MainActivity.this.startActivity(intent);
        overridePendingTransition(R.anim.push_left_in, R.anim.push_left_out); //向左退出的动画,这里表示定义在 xml 中的

        
        MainActivity.this.finish();
    	
    }//    
    
    
}//

