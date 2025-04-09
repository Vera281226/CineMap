<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
request.setCharacterEncoding("utf-8");
String id = request.getParameter("id");
boolean b = memberManager.idCheckProcess(id);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/style.css" rel="stylesheet" type="text/css">
</head>
<body style="text-align: center;margin-top: 30px">
<%
if(b){
%>
	이미 사용 중인 아이디입니다.<br> 다른 아이디를 입력하세요.<br><br>
	<a href="#" onclick="opener.regForm.id.focus(); window.close();">닫기</a>
<%	
}else{
%>
	사용 가능한 아이디입니다.<br><br>
	<a href="#" onclick="opener.regForm.passwd.focus(); window.close();">닫기</a>
<%
}
%>
</body>
</html>