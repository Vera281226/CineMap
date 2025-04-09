<%@page import="pack.cookie.CookieManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
session.removeAttribute("idKey");
//session.invalidate();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript">
<%
CookieManager cm = CookieManager.getInstance();
session.removeAttribute("idKey");
response.addCookie(cm.deleteCookie("UID"));
response.addCookie(cm.deleteCookie("UPD"));
response.addCookie(cm.deleteCookie("AUT"));
%>
location.href="/CineMap/index.jsp";
</script>
</body>
</html>