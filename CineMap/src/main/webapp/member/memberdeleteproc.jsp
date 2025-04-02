<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
String id = (String)session.getAttribute("idKey");

boolean b = memberManager.memberDelete(id);

if(b){
%>
	<script>
	location.href = "index.jsp";
	</script>
<%
}else{
%>
	<script>
		alert("수정 실패\n 관리자에게 문의 바람");
		history.back();
	</script>
<%
}
%>