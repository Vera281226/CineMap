<%@page import="pack.mybatis.SqlMapConfig"%>
<%@page import="org.apache.ibatis.session.SqlSession"%>
<%@page import="pack.member.MemberManager"%>
<%@page import="pack.member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% request.setCharacterEncoding("utf-8"); %>
<%
    String id = (String)session.getAttribute("idKey");
    MemberDto memberDto = null;

    SqlSession sqlSession = SqlMapConfig.getSqlSession().openSession();
    
    if (id != null) {
        MemberManager manager = new MemberManager();
        memberDto = manager.getMember(id);

        request.setAttribute("memberDto", memberDto);
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/member/mypage.css">
</head>
<body>
    <div class="container">
        <!-- 나의 정보 -->
        <div class="my-info">
            <h2>나의 정보</h2>
            <div class="info-details">
                <div><strong>아이디:</strong> ${memberDto.id}</div>
                <div><strong>닉네임:</strong> ${memberDto.nickname}</div>
                <div><strong>이메일:</strong> ${memberDto.email}</div>
            </div>
            <div class="buttons">
                <button id="btnUpdate">회원수정</button>
                <button id="btnDelete">회원탈퇴</button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // 회원수정 버튼 클릭 시 memberupdate.jsp로 이동
        document.getElementById("btnUpdate").addEventListener("click", function() {
            window.location.href = "../member/memberupdate.jsp"; // 회원 수정 페이지로 이동
        });

        // 회원탈퇴 버튼 클릭 시 memberdelete.jsp로 이동
        document.getElementById("btnDelete").addEventListener("click", function() {
            window.location.href = "../member/memberdelete.jsp"; // 회원 탈퇴 페이지로 이동
        });
    </script>
</body>
</html>
