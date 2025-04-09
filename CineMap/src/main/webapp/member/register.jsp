<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<style>
    /* 화면 중앙 위쪽에 위치하도록 CSS 수정 */
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        height: 100vh;
        background-color: #f4f4f4;
    }

    .container {
        width: 600px;
        background-color: #ffffff;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin-top: 20px; /* 위쪽에 여백을 주어 화면 중앙 위쪽에 배치 */
    }

    h2 {
        text-align: center;
        color: #333;
    }

    table {
        width: 100%;
        margin: 0 auto;
    }

    td {
        padding: 10px;
        text-align: left;
    }

    input[type="text"], input[type="password"], input[type="button"], input[type="reset"] {
        width: 100%;
        padding: 8px;
        margin: 5px 0;
        box-sizing: border-box;
    }

    /* 아이디 중복확인 버튼을 입력칸 옆에 배치하기 위한 스타일 */
    .id-check-container {
        display: flex;
        align-items: center;
    }

    #btnId {
        margin-left: 10px;
        width: auto; /* 버튼 크기를 입력창과 동일하지 않게 설정 */
        padding: 8px 15px;
        cursor: pointer;
        background-color: #4CAF50;
        color: white;
        border: none;
    }

    #btnId:hover {
        background-color: #45a049;
    }

    input[type="button"], input[type="reset"] {
        background-color: #4CAF50;
        color: white;
        border: none;
        cursor: pointer;
    }

    input[type="button"]:hover, input[type="reset"]:hover {
        background-color: #45a049;
    }

    .cancel-button {
        background-color: #f44336;
    }

    .cancel-button:hover {
        background-color: #e53935;
    }
</style>
<script type="text/javascript">
	window.onload = function() {
		regForm.id.focus();
		document.getElementById("btnId").onclick = idCheck;
		document.getElementById("btnSubmit").onclick = inputCheck;
	}
	function idCheck(){
		if(regForm.id.value === ""){
			regForm.id.focus();
		}else{
			const url = "idcheck.jsp?id=" + regForm.id.value;
			window.open(url,"id", "toolbar=no,width=300,height=150,top=200,left=100");
		}
	}
	function inputCheck() { // 회원 가입
		if(regForm.id.value==="") { 
			alert("아이디를 입력하세요"); 
			regForm.id.focus(); 
			return; 
		}
		regForm.submit();
	}
</script>
</head>
<body>
	<div class="container">
		<h2>회원가입</h2>
		<form name="regForm" method="post" action="registerproc.jsp">
			<table>
				<tr align="center" style="background-color: #556677">
				</tr>
				<tr>
					<td>아이디</td>
					<td>
						<div class="id-check-container">
							<input type="text" name="id" value="${param.id}">
							<input type="button" value="ID중복확인" id="btnId">
						</div>
					</td>
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
					<td><input type="text" name="name" size="15" value="${param.name}"></td>
				</tr>
				<tr>
					<td>닉네임</td>
					<td><input type="text" name="nickname" size="15" value="${param.nickname}"></td>
				</tr>
				<tr>
					<td>이메일</td>
					<td><input type="text" name="email" size="27" value="${param.email}"></td>
				</tr>
				<tr>
					<td>전화번호</td>
					<td><input type="text" name="phone" size="20" value="${param.phone}"></td>
				</tr>
				<tr>
					<td>생년월일</td>
					<td>
			           <input type="text" name="birthdate" size="16" maxlength="8" placeholder="년도(예: 19901225)" value="${param.birthdate}">
			       </td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center;">
						<input type="button" value="회원가입" id="btnSubmit">&nbsp;&nbsp; 
					</td>
				</tr>
			</table>
		</form>
		<input type="button" value="로그인" onclick="location.href='login.jsp'">
	</div>
</body>
</html>
