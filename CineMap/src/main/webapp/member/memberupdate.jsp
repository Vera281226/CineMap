<%@page import="pack.member.MemberManager"%>
<%@page import="pack.member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:useBean id="memberManager" class="pack.member.MemberManager" scope="page"/>

<%
request.setCharacterEncoding("utf-8");
String id = (String)session.getAttribute("idKey");
MemberDto memberDto = memberManager.getMember(id);

if(memberDto == null){
	response.sendRedirect("../guest/guest_index.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원수정</title>
<link rel="stylesheet" type="text/css" href="../css/board.css">
<script src="../js/script.js"></script>

<script type="text/javascript">
window.onload =() =>{
	
	document.querySelector("#btnUpdate").onclick = memberUpdate;
	document.querySelector("#btnUpdateCancel").onclick = memberUpdateCancel;
	document.querySelector("#btnDelete").onclick = memberDelete;
	
}
</script>
</head>
<body>
	<table>
		<tr>
			<td align="center">
				<form name="updateForm" method="post" action="memberupdateproc.jsp">
					<table border="1">
						<tr align="center" style="background-color: #8899aa">
							<td colspan="2"><b style="color: #FFFFFF"><%=memberDto.getName() %> 회원님의 정보를 수정합니다</b></td>
						</tr>
						<tr>
							<td width="16%">아이디</td>
							<td width="57%"><%=memberDto.getId() %></td> <!-- id는 수정에서 제외 -->
						</tr>
						<tr>
							<td>비밀번호</td>
							<td><input type="password" name="passwd" size="15" value="<%=memberDto.getPasswd() %>"></td>
						</tr>
						<tr>
							<td>이름</td>
							<td><input type="text" name="name" size="15" value="<%=memberDto.getName() %>"></td>
						</tr>
						<tr>
							<td>닉네임</td>
							<td><input type="text" name="name" size="15" value="<%=memberDto.getNickname() %>"></td>
						</tr>
						<tr>
							<td>이메일</td>
							<td><input type="text" name="email" size="27" value="<%=memberDto.getEmail() %>"></td>
						</tr>
						<tr>
							<td>전화번호</td>
							<td><input type="text" name="phone" size="20" value="<%=memberDto.getPhone() %>"></td>
						</tr>
						<tr>
							<td>생년월일</td>
							<td><input type="text" name="birthdate" size="15" value="<%=memberDto.getBirthdate() %>"></td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center;">
								<input type="button" value="홈으로" id="btnUpdateCancel">&nbsp;&nbsp; 
								<input type="button" value="회원정보 수정" id="btnUpdate">&nbsp;&nbsp; 
							</td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
	</table>
</body>
</html>