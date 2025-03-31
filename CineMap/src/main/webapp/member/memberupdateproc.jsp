<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="memberBean" class="pack.member.MemberBean"/>
<jsp:setProperty property="*" name="memberBean"/>

<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
String id = (String)session.getAttribute("idKey");

boolean b = memberManager.memberUpdate(memberBean, id);

if(b){
%>
	<script>
	location.href = "../guest/guest_index.jsp";
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
%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>