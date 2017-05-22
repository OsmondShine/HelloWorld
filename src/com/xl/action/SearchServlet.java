package com.xl.action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

public class SearchServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;
	static List<String> datas = new ArrayList<String>();
	static{
		//模拟数据
		datas.add("ajax");
		datas.add("ajax post");
		datas.add("becky");
		datas.add("bill");
		datas.add("james");
		datas.add("jerry");
//		datas.add("孙子兵法");
//		datas.add("论语");
//		datas.add("中庸");
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		req.setCharacterEncoding("utf-8");
		resp.setCharacterEncoding("utf-8");
//		System.out.println("---------------");
		//1.获取客户端发送的数据keyword
		String keyword = req.getParameter("keyword");
		//2.进行处理，并取得关联数据
		List<String> listData = getData(keyword);
		//返回Json格式
//		System.out.println(JSONArray.fromObject(listData));
		resp.getWriter().write(JSONArray.fromObject(listData).toString());
//		JSONArray.fromObject(listData);
	}
	//获得关联数据的方法
	public List<String> getData(String keyword){
		List<String> list = new ArrayList<String>();
		for (String data:datas){
			if (data.contains(keyword)){
				list.add(data);
			}
		}
		return list;
	}

}
