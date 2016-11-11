package apublic;

import java.util.Hashtable; //据说 Hashtable 线程同步, hashmap 不同步
import android.view.*;
import android.app.Activity;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList; 

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

//功能同 ios Xml2Control.h

//不好,要另开文件
//public class Hashtable_controls extends Hashtable<String, View>
//{}//

public class Xml2Control
{
	
	//从 xml 中装载所有控件//资源文件路径
	public Hashtable<String, View> LoadFromXml(String fileName, View view, Hashtable<String, View> controls)
	{
		
		
		return controls;
	}//
	
	
	//从 xml 中装载所有控件//完整全路径
	public Hashtable<String, View> LoadFromXml_FullFileName(String fileName, View view, Hashtable<String, View> controls)
	{

	    if (controls == null) controls = new Hashtable<String, View>();
	    
    	//--------------------------------------------------
    	//先创建 xml 环境
    	DocumentBuilderFactory factory=null;
        DocumentBuilder builder=null;
        Document document=null;
        InputStream inputStream=null;
        //List<River> rivers=new ArrayList<River>();
        
        String errorXml = "密码错误";	    
        
        //--------------------------------------------------

	    //NSString *path = fileName; //支持全路径比较好
	    
        factory = DocumentBuilderFactory.newInstance();
        String s = "";
        try {
        	//--------------------------------------------------
        	//这是解码项目中自带的示例 xml
            //找到xml，并加载文档
            //inputStream = this.getResources().getAssets().open("ud_op_test2.xml");//这里是使用assets目录中的river.xml文件 其实可以从  url 或者是物理文件中取
            inputStream = new FileInputStream(fileName);//从物理文件读取,例如 sd 卡中
            
            InputStreamReader inputStreamReader = new InputStreamReader(inputStream, "gbk");
            BufferedReader in = new BufferedReader(inputStreamReader);
            StringBuffer sBuffer = new StringBuffer();
            sBuffer.append(in.readLine() + "\n");
            s = sBuffer.toString();
            
            //--------------------------------------------------
            //这是解码网络中取得的 xml
            //将一个字符串当做 xml 解码,如果不成功就直接显示其原始内容作为错误信息就行了
            //inputStream = new ByteArrayInputStream(errorXml.getBytes("ISO-8859-1"));
            //inputStream = new ByteArrayInputStream(s.getBytes());//这时的字符串已经转过码了,所以不需要再带  gbk 的转换标志

            //--------------------------------------------------
            builder = factory.newDocumentBuilder();
            document = builder.parse(inputStream);//上面为做示例生成了两个 inputStream ,实际项目中只能使用其中一个
            
            //找到根Element
            Element root = document.getDocumentElement();
            Functions.ShowMessage(root.getTagName(), (Activity)view.getContext());//这个得到  <Root> 节点
            //这里和 delphi 是不同的
            Element itemList = (Element)root.getElementsByTagName("Data").item(0);
            //Functions.ShowMessage(itemList.getTagName(), this);//这个得到  <ItemList> 节点
            NodeList nodes = itemList.getElementsByTagName("Row");
	    
    	    //NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile: path];

    	    //NSError *error;
    	    
    	    //第一个节点实际上是空白,所以直接这样是不行的//[Xml2Control CreateControls:doc.rootElement parent:view controls:dictionary];
          //遍历所有子节点
            for(int i=0;i<nodes.getLength();i++)
            {
                //获取元素节点
                Element node=(Element)(nodes.item(i));
            }
            //
//    	    for (int i=0; i<doc.rootElement.childCount; i++)
//    	    {
//    	        GDataXMLElement * node = doc.rootElement.children[i];
//    	        
//    	        [Xml2Control CreateControls:node parent:view controls:controls];
//    	        
//    	    }//for
    	    
        }//try
        catch (Exception e)
        {
            e.printStackTrace();
            
            try {
            	//Functions.ShowMessage("<这里在出错时直接显示要解析的  xml 源码就行>" + new String(errorXml.getBytes("ISO-8859-1"), "unicode"), this);
            	Functions.ShowMessage("<这里在出错时直接显示要解析的  xml 源码就行>" + s, (Activity)view.getContext());
            } catch (Exception e_codepage) {   
            	e_codepage.printStackTrace();
            }
        } 
//        catch (SAXException e) {
//            e.printStackTrace();
//        }
//         catch (ParserConfigurationException e) {
//            e.printStackTrace();
//        }
        finally
        {
            try 
            {
                inputStream.close();
            } catch (IOException e) {   
                e.printStackTrace();
            }
        }//try
	    
	    
	    return controls;		

	}//

	
}//




