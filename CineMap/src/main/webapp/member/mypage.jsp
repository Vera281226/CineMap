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
            width: 80%;
            margin: 0 auto;
            padding-top: 20px;
            display: flex;
            flex-direction: column; /* 세로로 정렬 */
            align-items: flex-start; /* 왼쪽 정렬 */
        }

        /* 나의 정보 섹션 */
        .my-info {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%; /* 전체 너비 사용 */
            margin-bottom: 20px;
        }

        .my-info h2 {
            text-align: left;
            color: #333;
        }

        .info-details {
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 왼쪽 정렬 */
            margin-bottom: 20px;
        }

        .info-details div {
            margin-bottom: 10px;
        }

        .my-info button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            width: 45%;
            margin-top: 10px;
        }

        .my-info button:hover {
            background-color: #45a049;
        }

        /* 찜한 영화 섹션 */
        .favorite-movies {
            background-color: #ffffff;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 100%;
        }

        .favorite-movies h2 {
            text-align: left;
            color: #333;
        }

        .categories {
            display: flex;
            justify-content: flex-start; /* 왼쪽 정렬 */
            margin-top: 20px;
            width: 100%;
        }

        .category {
            background-color: #e0e0e0;
            padding: 15px;
            border-radius: 10px;
            margin-right: 10px;
            text-align: left;
            flex: 1;
        }

        .category:last-child {
            margin-right: 0;
        }

        .category h3 {
            margin-bottom: 15px;
        }

        .category ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .category li {
            margin: 10px 0;
        }

        .category a {
            text-decoration: none;
            color: #333;
        }

        .category a:hover {
            color: #4CAF50;
        }

        /* 버튼 스타일 */
        .category button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            width: 100%;
            margin-top: 10px;
            text-align: center;
        }

        .category button:hover {
            background-color: #45a049;
        }

    </style>
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

        <!-- 찜한 영화 -->
        <div class="favorite-movies">
            <h2>❤️ 찜한 영화</h2>
            <div class="categories">
                <!-- 내가 쓴 글 (버튼으로 변경) -->
                <div class="category">
                    <h3>내가 쓴 글</h3>
                    <button onclick="window.location.href='#';">글 목록 보기</button>
                </div>

                <!-- 나의 리뷰 (버튼으로 변경) -->
                <div class="category">
                    <h3>나의 리뷰</h3>
                    <button onclick="window.location.href='#';">리뷰 목록 보기</button>
                </div>
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
