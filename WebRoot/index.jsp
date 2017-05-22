<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <style type="text/css">
	  #mydiv{
	  	position: absolute;
	  	left:50%;
	  	top:50%;
	  	margin-left: -200px;
	  	margin-top: -50px;
	  }
	  .mouseOver{
	  	background: #708090;
	  	color:#FFFAFA;
	  }
	  .mouseOut{
	  	background: #FFFAFA;
	  	color:#000000;
	  }
  </style>
  
  <script type="text/javascript">
  	var xmlHttp;
  	//获取用户输入内容并显示关联信息的函数
  	function getMoreContents(){
  		//1.获取用户输入
  		var content=document.getElementById("keyword");
  		if (content.value == ""){
  			clearContent();
  			return;
  		}
  		//2.采用ajax异步方式发送数据到服务器
  		//创建异步传输对象:xmlHttp
  		xmlHttp = createXMLHttp();
		var url = "search?keyword=" + escape(content.value);
		//true(代表异步传输)表示js脚本会在send()方法之后继续执行,而不会等待来自服务器的响应
		xmlHttp.open("GET", url, true);
		//xmlHttp绑定回调方法，这个回调方法会在xmlHttp状态改变的时候被调用
		//xmlHttp的状态0-4，我们只关心4(complete)这个状态
		//完成之后调用回调方法
		xmlHttp.onreadystatechange = callback;
		xmlHttp.send(null);
  	}
	//获得XmlHttp对象
	function createXMLHttp(){
	//大多浏览器适用
	var xmlHttp;
	if (window.XMLHttpRequest){
		xmlHttp = new XMLHttpRequest();
	}	
	//要考虑浏览器的兼容性
	if (window.ActiveXObject){
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		if (!xmlHttp){
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		}
	}
	return xmlHttp;
	}  
  
  	function callback(){
  		//4代表完成
  		if (xmlHttp.readyState == 4){
  			//200代表服务器响应成功
  			//404代表资源未找到，500代表服务器内部错误
  			if (xmlHttp.status == 200){
  				//交互成功， 获得相应的数据，是文本格式
  				var result = xmlHttp.responseText;
  				//解析获得数据
  				var json = eval("(" + result + ")");
  				//将数据动态的显示到输入框下面
				setContent(json);
  			}
  		}
  	}
  	//设置关联数据的展示，参数代表的是关联信息
  	function setContent(contents){
  		clearContent();
  		setLocation();
  		//获得关联数据的长度，以便确定生成<tr></tr>数量的多少
  		var size = contents.length;
  		//设置内容
  		for (var i = 0; i< size; i++){
  			//代表的是json格式数据的第i个元素
  			var nextNode = contents[i];
  			var tr = document.createElement("tr");
  			var td = document.createElement("td");
  			td.setAttribute("border", "0");
  			td.setAttribute("bgcolor", "#FFFAFA");
  			td.onmouseover = function(){
  				this.className = 'mouseOver';
  			};
  			td.onmouseout = function(){
  				this.className = 'mouseOut';
  			};
  			td.onmousedown = function(){
				//当鼠标点击一个关联数据时，关联数据自动设置为输入框值
				document.getElementById("keyword").value = this.innerHTML;
				document.getElementById("popDiv").style.border = "none";
			};
  			var text = document.createTextNode(nextNode);
  			td.appendChild(text);
  			tr.appendChild(td);
  			document.getElementById("content_table_body").appendChild(tr);
  		}
  	}
  	//清空之前的数据
  	function clearContent(){
  		var contentTableBody = document.getElementById("content_table_body");
  		var size = contentTableBody.childNodes.length;
  		for (var i=size-1; i>=0; i--){
  			contentTableBody.removeChild(contentTableBody.childNodes[i]);
  		}
  		document.getElementById("popDiv").style.border = "none";
  	}
  	//当输入框失去焦点时，关联数据清空
  	function keywordBlur(){
  		clearContent();
  	}
  	//设置显示关联信息的位置
  	function setLocation(){
	  	//关联信息的显示位置要和输入框一致
	  	var content = document.getElementById("keyword");
	  	var width = content.offsetWidth;//输入框的宽度
	  	var left = content["offsetLeft"];//到左边框的距离
	  	var top = content["offsetTop"] + content.offsetHight;//到顶部的距离
	  	//获得显示数据的div
	  	var popDiv = document.getElementById("popDiv");
	  	popDiv.style.border = "black 1px solid";
	  	popDiv.style.left = left + "px";
	  	popDiv.style.top = top + "px";
	  	popDiv.style.width = width + "px";
	  	document.getElementById("content_table").style.width = width + "px";	//?
  	}
  </script>
    <base href="<%=basePath%>">
    
    <title>Ajax异步传输</title>
  </head>
  
  <body>
	<div id="mydiv">
		<!-- 输入框 -->
		<input type="text" size="50" id="keyword" onkeyup="getMoreContents()" onblur="keywordBlur()" onfocus="getMoreContents()"/>
		<input type="button" value="百度一下" width="50px"/>
		<!-- 内容展示区 -->
		<div id="popDiv">
			<table id="content_table" bgcolor="#FFFAFA" border="0" cellspacing="0" cellpadding="0">
				<tbody id="content_table_body">
				<!-- 动态查询数据显示区 -->
				</tbody>
			</table>
		</div>
	</div>
  </body>
</html>
