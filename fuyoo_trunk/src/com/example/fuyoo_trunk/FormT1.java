package com.example.fuyoo_trunk;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;

public class FormT1 extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_form_t1);
	}//

	////@Override
	public boolean onCreateOptionsMenuaaa(Menu menu) 
	{
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.form_t1, menu);
		return true;
	}//

}//


