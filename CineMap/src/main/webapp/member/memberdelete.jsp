<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="pack.member.MemberManager"%>
<%@ page import="pack.member.MemberDto"%>

<% request.setCharacterEncoding("utf-8"); %>
<%
    String id = (String) session.getAttribute("idKey");
    MemberDto memberDto = null;

    if (id != null) {
        MemberManager manager = new MemberManager();
        memberDto = manager.getMemberInfo(id);
        request.setAttribute("memberDto", memberDto);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원탈퇴</title>
    <link rel="stylesheet" type="text/css" href="../css/board.css">
    <script src="../js/script.js"></script>
    <style>
        /* 기본 스타일 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 50%;
            margin: 0 auto;
            padding-top: 20px;
        }

        /* 회원탈퇴 섹션 */
        .delete-account {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .delete-account h2 {
            text-align: center;
            color: #333;
        }

        .delete-account form {
            margin-top: 20px;
        }

        .delete-account label {
            display: block;
            margin-bottom: 8px;
            color: #333;
        }

        .delete-account input[type="text"],
        .delete-account input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .delete-account button {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            width: 48%;
            margin-top: 10px;
        }

        .delete-account button:hover {
            background-color: #e53935;
        }

        .cancel-button {
            background-color: #4CAF50;
        }

        .cancel-button:hover {
            background-color: #45a049;
        }

        /* 버튼 그룹 */
        .button-group {
            display: flex;
            justify-content: space-between;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="delete-account">
            <h2>회원 탈퇴</h2>
            <form action="memberdeleteproc.jsp" method="post">
                <!-- 아이디는 수정 불가, 읽기 전용 -->
                <label for="id">아이디</label>
                <input type="text" id="id" name="id" value="<%= memberDto.getId() %>" readonly>

                <!-- 비밀번호 입력란 -->
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" required>

                <div class="button-group">
                    <button type="submit">회원탈퇴</button>
                    <button type="button" class="cancel-button" onclick="window.location.href='mypage.jsp'">취소</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
