<%@page import="pack.post.PostDTO"%>
<%@page import="pack.post.PostManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager" />
<%
    int no = Integer.parseInt(request.getParameter("no"));
    PostDTO dto = postManager.getPostByNo(no); // getPostByNo()는 아래에 설명
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>
</head>
<body>

<h2>게시글 수정</h2>

<form action="update.jsp" method="post">
    <input type="hidden" name="no" value="<%=dto.getNo()%>" />
    작성자: <input type="text" name="name" value="<%=dto.getName()%>" readonly /><br/>
    제목: <input type="text" name="title" value="<%=dto.getTitle()%>" /><br/>
    
    카테고리:
    <select name="category">
        <option value="스포" <%=dto.getCategory().equals("스포") ? "selected" : "" %>>스포</option>
        <option value="개봉예정작" <%=dto.getCategory().equals("개봉예정작") ? "selected" : "" %>>개봉예정작</option>
        <option value="공지사항" <%=dto.getCategory().equals("공지사항") ? "selected" : "" %>>공지사항</option>
        <option value="자유게시판" <%=dto.getCategory().equals("자유게시판") ? "selected" : "" %>>자유게시판</option>
    </select><br/>

    내용:<br/>
    <textarea name="content" rows="10" cols="50"><%=dto.getContent()%></textarea><br/>
    <input type="submit" value="수정 완료" />
</form>

</body>
</html>