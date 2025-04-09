<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="memberBean" class="pack.member.MemberBean"/>
<jsp:setProperty property="*" name="memberBean"/>

<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
String id = (String)session.getAttribute("idKey");
boolean b = false;

if (id != null) {
    b = memberManager.memberUpdate(memberBean);
}
response.sendRedirect("mypage.jsp");
%>
