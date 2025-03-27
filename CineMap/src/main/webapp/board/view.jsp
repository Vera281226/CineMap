<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="pack.post.PostDTO"%>
<%@page import="pack.board.CommentDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager"/>
<jsp:useBean id="commentManager" class="pack.board.CommentManager"/>
<jsp:useBean id="post" class="pack.post.PostDTO"/>
<jsp:useBean id="comment" class="pack.board.CommentDTO"/>

<%
    request.setCharacterEncoding("utf-8");
    int no = Integer.parseInt(request.getParameter("no"));
    ArrayList<PostDTO> list = postManager.getAllPosts();
    for(PostDTO p : list) {
        if(p.getNo() == no) {
            post = p;
            break;
        }
    }

    ArrayList<CommentDTO> commentList = (ArrayList<CommentDTO>) commentManager.getCommentsByPost(no);

    // gno, ono 기준 정렬
    Collections.sort(commentList, new Comparator<CommentDTO>() {
        public int compare(CommentDTO c1, CommentDTO c2) {
            if (c1.getGno() != c2.getGno()) {
                return Integer.compare(c1.getGno(), c2.getGno());
            } else {
                return Integer.compare(c1.getOno(), c2.getOno());
            }
        }
    });
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>
<style>
    table { width: 100%; border-collapse: collapse; }
    th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    th { background-color: #f0f0f0; }
</style>
</head>
<body>

<h2>게시글 상세보기</h2>

<table>
    <tr><th>번호</th><td><%= post.getNo() %></td></tr>
    <tr><th>제목</th><td><%= post.getTitle() %></td></tr>
    <tr><th>작성자</th><td><%= post.getName() %></td></tr>
    <tr><th>작성일</th><td><%= post.getCreatedAt() %></td></tr>
    <tr><th>조회수</th><td><%= post.getViews() %></td></tr>
    <tr><th>내용</th><td><pre><%= post.getContent() %></pre></td></tr>
</table>

<h3>댓글</h3>
<table>
    <tr><th>작성자</th><th>내용</th><th>작성일</th></tr>
    <%
        for (CommentDTO c : commentList) {
            int nest = c.getNested();
            String indent = "";
            for (int i = 0; i < nest; i++) indent += "&nbsp;┖&nbsp;";
    %>
    <tr>
        <td><%= indent %><%= c.getName() %></td>
        <td><%= c.getContent() %></td>
        <td><%= c.getCreatedAt() %></td>
    </tr>
    <% } %>
</table>

<br><div><a href="list.jsp">목록으로</a></div>

</body>
</html>