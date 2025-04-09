<%@page import="pack.post.PostDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:useBean id="dao" class="pack.post.PostDao" />

<%
	String loginId = (String)session.getAttribute("idKey");
    int no = Integer.parseInt(request.getParameter("no"));
    PostDto dto = dao.getPostByNo(no);
    request.setAttribute("dto", dto);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/board/write.css">
</head>
<body>
<%@ include file="/index_top.jsp" %>
<div class="container">
<h2>게시글 수정</h2>

<form action="update.jsp" method="post" onsubmit="return checkForm();">
    <input type="hidden" name="no" value="${dto.no}" />
    <input type="hidden" name="id" value="${dto.id}" />

    작성자: <input type="text" name="nickname" value="${dto.nickname}" readonly /><br/>

    제목: <input type="text" name="title" value="${dto.title}" required /><br/>

    카테고리:
    <select name="category" required>
        <option value="스포" ${dto.category == '스포' ? 'selected' : ''}>스포</option>
        <option value="개봉예정작" ${dto.category == '개봉예정작' ? 'selected' : ''}>개봉예정작</option>
        <% if ("admin".equals(loginId)) { %>
        <option value="공지사항" ${dto.category == '공지사항' ? 'selected' : ''}>공지사항</option>
        <% } %>
        <option value="자유게시판" ${dto.category == '자유게시판' ? 'selected' : ''}>자유게시판</option>
    </select><br/>

    내용:<br/>
    <textarea name="content" rows="10" cols="50" required>${dto.content}</textarea><br/>

    <input type="submit" value="수정 완료" />
    <input type="button" value="수정 취소" onclick="location.href='view.jsp?no=${dto.no}'" />
</form>

<div class="error-message" id="errorMsg" style="color: red; margin-top: 10px;"></div>
</div>

<!-- 금지어 필터 스크립트 추가 -->
<script>
    const bannedWords = [
        "시발", "씨발", "ㅅㅂ", "ㅂㅅ", "병신", "ㅄ", "좆", "ㅈ같", "엿같", 
        "fuck", "shit", "asshole", "bitch", "dick", "nigger", "retard",
        "새끼", "꺼져", "죽어", "개새", "좃같", "지랄", "미친놈", "미친년",
        "fuck you", "존나", "개노답", "년놈", "등신", "멍청이", "노답"
    ];

    function containsBannedWord(text) {
        return bannedWords.some(word => text.toLowerCase().includes(word.toLowerCase()));
    }

    function checkForm() {
        const title = document.querySelector('input[name="title"]').value;
        const content = document.querySelector('textarea[name="content"]').value;
        const errorMsg = document.getElementById('errorMsg');
        errorMsg.textContent = "";

        if (containsBannedWord(title)) {
            errorMsg.textContent = "제목에 금지어가 포함되어 있습니다.";
            return false;
        }

        if (containsBannedWord(content)) {
            errorMsg.textContent = "내용에 금지어가 포함되어 있습니다.";
            return false;
        }

        return true;
    }
</script>

</body>
</html>