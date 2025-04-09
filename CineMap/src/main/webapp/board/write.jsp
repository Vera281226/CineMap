<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.member.MemberDto" %>
<%@ page import="pack.member.MemberManager" %>
<%@ page import="pack.cookie.CookieManager" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    String loginId = (String)session.getAttribute("idKey");
    if (loginId == null) {
        response.sendRedirect("../member/login.jsp");
        return;
    }

    MemberManager manager = new MemberManager();
    MemberDto memberDto = manager.getMember(loginId);
    request.setAttribute("memberDto", memberDto);

    // 쿠키에서 임시 저장값 불러오기
    CookieManager cookieManager = CookieManager.getInstance();
    String savedTitle = "", savedContent = "", savedCategory = "";

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            try {
                switch (c.getName()) {
                    case "savedTitle":
                        savedTitle = cookieManager.readCookie(c); break;
                    case "savedContent":
                        savedContent = cookieManager.readCookie(c); break;
                    case "savedCategory":
                        savedCategory = cookieManager.readCookie(c); break;
                }
            } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/board/write.css">
</head>
<body>
<%@ include file="/index_top.jsp" %>
<div class="container">
<h2>게시글 작성</h2>

<form action="insert.jsp" method="post" onsubmit="return checkForm();">
    <div class="form-row">
        <label>작성자:</label>
        <input type="text" name="nickname" value="${memberDto.nickname}" readonly />
    </div>

    <div class="form-row">
        <label>제목:</label>
        <input type="text" name="title" value="<%= savedTitle %>" required />
    </div>

    <div class="form-row">
        <label>카테고리:</label>
        <select name="category">
            <option value="스포" <%= "스포".equals(savedCategory) ? "selected" : "" %>>스포</option>
            <option value="개봉예정작" <%= "개봉예정작".equals(savedCategory) ? "selected" : "" %>>개봉예정작</option>
		    <% if ("admin".equals(loginId)) { %>
		        <option value="공지사항" <%= "공지사항".equals(savedCategory) ? "selected" : "" %>>공지사항</option>
		    <% } %>
            <option value="자유게시판" <%= "자유게시판".equals(savedCategory) ? "selected" : "" %>>자유게시판</option>
        </select>
    </div>

    <div class="form-row" style="flex-direction: column; align-items: flex-start;">
        <label>내용:</label>
        <textarea name="content" rows="10" cols="50" required><%= savedContent %></textarea>
    </div>

    <input type="hidden" name="id" value="${memberDto.id}" />
    <input type="submit" value="작성 완료" />
    <input type="button" value="작성 취소" onclick="document.getElementById('cancelForm').submit();" />
</form>

<form id="cancelForm" action="cancel.jsp" method="post" style="display:none;"></form>

<div class="error-message" id="errorMsg"></div>
</div>
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

    // 쿠키 저장 요청
	function saveCookie(name, value) {
	    fetch('save_cookie.jsp', {
	        method: 'POST',
	        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
	        body: 'name=' + encodeURIComponent(name) + '&value=' + encodeURIComponent(value)
	    });
	}

    document.querySelector('input[name="title"]').addEventListener('input', e => {
        saveCookie('savedTitle', e.target.value);
    });
    document.querySelector('textarea[name="content"]').addEventListener('input', e => {
        saveCookie('savedContent', e.target.value);
    });
    document.querySelector('select[name="category"]').addEventListener('change', e => {
        saveCookie('savedCategory', e.target.value);
    });
</script>

</body>
</html>