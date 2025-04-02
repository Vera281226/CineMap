<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="memberManager" class="pack.member.MemberManager" />

<%
request.setCharacterEncoding("utf-8");

String id = request.getParameter("id");
String passwd = request.getParameter("passwd");

boolean b = memberManager.loginCheck(id, passwd);

if(b){
	session.setAttribute("idKey", id);
	response.sendRedirect("index.jsp");
}else{
	response.sendRedirect("logfail.html");
}

%>
