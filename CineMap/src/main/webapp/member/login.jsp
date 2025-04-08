<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<%
String id = (String)session.getAttribute("idKey");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link href="../css/style.css" rel="stylesheet" type="text/css">
<script type="text/javascript">
window.onload = () => {
		document.querySelector("#btnLogin").addEventListener("click", funcLogin);
		document.querySelector("#btnNewMember").addEventListener("click", funcNewMember);
}
//로그인
function funcLogin(){
	if(loginForm.id.value === ""){
		alert("아이디를 입력해주세요");
		loginForm.id.focus();
	}else if(loginForm.passwd.value === ""){
		alert("비밀번호를 입력해주세요");
		loginForm.passwd.focus();
	}else{
		loginForm.action = "loginproc.jsp";
		loginForm.method = "post";
		loginForm.submit();
	}
}

// 회원가입
function funcNewMember(){
	location.href = "register.jsp";
}
</script>

<style>
/* 화면을 중앙 상단에 배치 */
body {
    display: flex;
    justify-content: center;  /* 수평 중앙 정렬 */
    align-items: flex-start;  /* 수직 상단 정렬 */
    height: 100vh;  /* 화면 전체 높이를 사용 */
    margin: 0;  /* 기본 여백 제거 */
    background-color: #f4f4f4;  /* 배경색 */
    padding-top: 50px;  /* 상단에 여백 추가 (원하는 위치로 조정 가능) */
}

form {
    background-color: #fff;  /* 폼 배경색 */
    padding: 20px;  /* 폼 안의 여백 */
    border-radius: 10px;  /* 둥근 모서리 */
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);  /* 그림자 효과 */
    width: 300px;  /* 폼의 너비 */
    text-align: center;  /* 텍스트 중앙 정렬 */
}

input[type="text"] {
    width: 100%;
    padding: 10px;
    margin: 10px 0;  /* 위와 아래 여백 */
    font-size: 16px;
    border-radius: 5px;
    border: 1px solid #ccc;
}
</style>

</head>
<body>
<%-- EL로 로그인 상태 체크 --%>
<c:if test="${not empty sessionScope.idKey}">  <!-- 세션에 idKey 값이 존재할 경우 -->
    <!-- 인덱스 링크를 숨기기 위한 스타일 추가 -->
    <a href="/index.jsp" style="display:none;">인덱스</a>
</c:if>

<c:if test="${empty sessionScope.idKey}">  <!-- 세션에 idKey 값이 존재하지 않을 경우 (로그인되지 않은 상태) -->
    <form name="loginForm">
        <table>
            <tr>
                <td colspan="2" style="text-align: center;"> CineMap </td>
            </tr>
            <tr>
                <td><input type="text" name="id" placeholder="아이디"></td>  
            </tr>
            <tr>
                <td><input type="text" name="passwd" placeholder="비밀번호"></td>  
            </tr>
        </table>
        <input type="button" value="로 그 인" id="btnLogin">
        <input type="button" value="회원가입" id="btnNewMember">
    </form>
</c:if>
</body>
</html>
