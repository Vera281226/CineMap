<%@page import="pack.member.MemberManager"%>
<%@page import="pack.member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="memberManager" class="pack.member.MemberManager" scope="page"/>

<%
    request.setCharacterEncoding("utf-8");
    String id = (String)session.getAttribute("idKey");
    
    MemberDto dto = memberManager.getMember(id);
    
    if (dto == null) {
        response.sendRedirect("../index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원수정</title>
<script type="text/javascript">
window.onload = () => {
    document.querySelector("#btnUpdate").onclick = memberUpdate;
    document.querySelector("#btnUpdateCancel").onclick = memberUpdateCancel; 
}

//쇼핑몰 고객이 로그인 후 자신의 정보 수정
function memberUpdate(){
    // 입력자료 오류검사 ...
    document.updateForm.submit();
}

function memberUpdateCancel(){
    location.href = "../index.jsp";
}
</script>
<style>
    /* body 전체를 flexbox로 설정하여 콘텐츠 중앙 정렬 */
    body {
        display: flex;
        justify-content: center; /* 가로 중앙 정렬 */
        align-items: flex-start; /* 세로 위쪽 정렬 */
        height: 100vh;
        margin: 0;
        font-family: Arial, sans-serif;
    }

    /* 컨텐츠를 담을 테이블 스타일 설정 */
    table {
        border-collapse: collapse;
        width: 80%; /* 테이블 너비 설정 */
        max-width: 800px; /* 테이블 최대 너비 설정 */
        margin-top: 50px; /* 위쪽 여백 추가 */
    }

    td {
        padding: 8px;
        text-align: left;
    }

    input[type="button"] {
        padding: 10px;
        font-size: 14px;
        cursor: pointer;
    }

    input[type="text"], input[type="password"] {
        padding: 5px;
        width: 100%;
        max-width: 200px;
    }

    /* 제목 스타일 추가 */
    b {
        font-size: 18px;
        text-align: center; /* 제목을 중앙 정렬 */
        display: block; /* b 태그를 블록으로 설정하여 정렬 효과 적용 */
        margin-bottom: 20px; /* 제목과 다른 요소 간의 간격 추가 */
    }
</style>
</head>
<body>
    <table>
        <tr>
            <td align="center">
                <form name="updateForm" method="post" action="memberupdateproc.jsp">
                    <table>
                        <tr>
                            <td colspan="2">
                                <b>회원 정보 수정</b> <!-- 타이틀을 중앙에 배치 -->
                            </td>
                        </tr>
                        <tr>
                            <td>아이디</td>
                            <td><input type="hidden" name="id" value="<%=dto.getId() %>"><%=dto.getId() %></td> <!-- id는 수정에서 제외 -->
                        </tr>
                        <tr>
							<td>비밀번호</td>
							<td><input type="password" name="passwd" size="15" value="<%=dto.getPasswd() %>"></td>
						</tr>
						<tr>
							<td>이름</td>
							<td><input type="text" name="name" size="15" value="<%=dto.getName() %>"></td>
						</tr>
						<tr>
							<td>닉네임</td>
							<td><input type="text" name="nickname" size="15" value="<%=dto.getNickname() %>"></td>
						</tr>
						<tr>
							<td>이메일</td>
							<td><input type="text" name="email" size="27" value="<%=dto.getEmail() %>"></td>
						</tr>
						<tr>
							<td>전화번호</td>
							<td><input type="text" name="phone" size="20" value="<%=dto.getPhone() %>"></td>
						</tr>
						<tr>
							<td>생년월일</td>
							<td><input type="text" name="birthdate" size="16" value="<%=dto.getBirthdate() %>"></td>
						</tr>
                        <tr>
                            <td colspan="2" style="text-align: center;">                       
                                <input type="button" value="회원정보 수정" id="btnUpdate">&nbsp;&nbsp; 
                                <input type="button" value="홈으로" id="btnUpdateCancel">&nbsp;&nbsp; 
                            </td>
                        </tr>
                    </table>
                </form>
            </td>
        </tr>
    </table>
</body>
</html>