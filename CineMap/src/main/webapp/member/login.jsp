<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String id = (String) session.getAttribute("idKey");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>

    <!-- ✅ 외부 CSS 연결 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/login.css">

    <!-- ✅ 로그인 기능 스크립트 -->
    <script type="text/javascript">
        function funcLogin() {
            const form = document.loginForm;
            if (form.id.value.trim() === "") {
                alert("아이디를 입력하세요");
                form.id.focus();
                return;
            }
            if (form.passwd.value.trim() === "") {
                alert("비밀번호를 입력하세요");
                form.passwd.focus();
                return;
            }

            form.action = "loginproc.jsp";
            form.method = "post";
            form.submit();
        }

        function funcNewMember() {
            window.location.href = "register.jsp";
        }

        window.onload = () => {
            const loginBtn = document.getElementById("btnLogin");
            const newMemberBtn = document.getElementById("btnNewMember");

            if (loginBtn) loginBtn.addEventListener("click", funcLogin);
            if (newMemberBtn) newMemberBtn.addEventListener("click", funcNewMember);
        };
    </script>
</head>

<body>
<%
if (id != null) {
%>
    <!-- ✅ 로그인 성공 시 환영 메시지 -->
    <b><%= id %>님 환영합니다!</b>
    지금부터 저희가 준비한 커뮤니티 기능 사용 가능합니다<br>
    <a href="${pageContext.request.contextPath}/member/logout.jsp">로그아웃</a>
<%
} else {
%>
    <!-- ✅ 로그인 폼 시작 -->
    <form name="loginForm" class="login-form">
        <table class="login-table">
            <tr>
                <!-- ✅ 로그인 타이틀 (가운데 정렬) -->
                <td colspan="2">
                    <div class="login-title">CineMap</div>
                </td>
            </tr>
            <tr>
                <!-- ✅ 라벨을 label 태그로 감싸서 정렬 -->
                
                <td><input type="text" name="id" id="id" class="input-box" placeholder="아이디"></td>
            </tr>
            <tr>
                
                <td><input type="password" name="passwd" id="passwd" class="input-box" placeholder="비밀번호"></td>
            </tr>
            <tr>
			<td colspan="2">
				 <input type="checkbox" id="rememberMe" name="rememberMe" value="1">
            <label for="rememberMe">자동 로그인</label>
			</td>
		</tr>
            <tr>
                <td colspan="2">
                    <!-- ✅ 로그인 / 회원가입 버튼 나란히 정렬 -->
                    <div class="button-row">
                        <input type="button" value="로그인" id="btnLogin">
                        <input type="button" value="회원가입" id="btnNewMember">
                    </div>
                </td>
            </tr>
        </table>
    </form>
<%
}
%>
</body>
</html>
