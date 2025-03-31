<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<script src="../js/script.js"></script>

<script type="text/javascript">
	window.onload = function() {
		regForm.id.focus();
		document.getElementById("btnId").onclick = idCheck;
		document.getElementById("btnSubmit").onclick = inputCheck;
	}
</script>
</head>
<body>
	<br>
	<table>
		<tr>
			<td align="center">
				<form name="regForm" method="post" action="registerproc.jsp">
					<table border="1">
						<tr align="center" style="background-color: #556677">
							<td colspan="2"><b style="color: #FFFFFF">회원 가입</b></td>
						</tr>
						<tr>
							<td>아이디</td>
							<td><input type="text" name="id">
								<input type="button" value="ID중복확인" id="btnId"></td>
						</tr>
						<tr>
							<td>비밀번호</td>
							<td><input type="password" name="passwd" size="15"></td>
						</tr>
						<tr>
							<td>비밀번호 확인</td>
							<td><input type="password" name="repasswd" size="15"></td>
						</tr>
						<tr>
							<td>이름</td>
							<td><input type="text" name="name" size="15"></td>
						</tr>
						<tr>
							<td>닉네임</td>
							<td><input type="text" name="nickname" size="15"></td>
						</tr>
						<tr>
							<td>이메일</td>
							<td><input type="text" name="email" size="27"></td>
						</tr>
						<tr>
							<td>전화번호</td>
							<td><input type="text" name="phone" size="20"></td>
						</tr>
						<tr>
							<td>생년월일</td>
							<td>
				               <input type="text" name="birthyear" size="8" maxlength="4" placeholder="년도(예: 1990)">
				               <input type="text" name="birthmonth" size="4" maxlength="2" placeholder="월(예: 12)">
				               <input type="text" name="birthday" size="4" maxlength="2" placeholder="일(예: 25)">
				           </td>
						</tr>
						<tr>
							<td colspan="2" style="text-align: center;">
								<input type="button" value="회원가입" id="btnSubmit">&nbsp;&nbsp; 
								<input type="reset" value="다시쓰기">
							</td>
						</tr>
					</table>
				</form>
					<input type="button" value="로그인" onclick="location.href='login.jsp'">
			</td>
		</tr>
	</table>
</body>
</html>