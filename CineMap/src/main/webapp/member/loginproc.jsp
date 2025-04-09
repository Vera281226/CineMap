<%@page import="org.apache.ibatis.reflection.SystemMetaObject"%>
<%@page import="pack.cookie.CookieManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="memberManager" class="pack.member.MemberManager" scope="session" />
<% request.setCharacterEncoding("utf-8"); %>

CookieManager cm = CookieManager.getInstance();

String id = request.getParameter("id");
String passwd = request.getParameter("passwd");
String rememberMe = request.getParameter("rememberMe");
	
if("1".equals(rememberMe)) {
	response.addCookie(cm.createCookie("AUT", "1"));
	response.addCookie(cm.createEncryptCookie("UID", id));
	response.addCookie(cm.createEncryptCookie("UPD", passwd));
}

boolean b = memberManager.loginCheck(id);

if(b){
	session.setAttribute("idKey", id);
	response.sendRedirect("/CineMap/index.jsp");
}else{
	response.sendRedirect("logfail.html");
}
%>