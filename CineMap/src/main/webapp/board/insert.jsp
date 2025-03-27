<%@page import="pack.post.PostDTO"%>
<%@page import="pack.post.PostManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager" />
<jsp:useBean id="dto" class="pack.post.PostDTO" />

<%
    request.setCharacterEncoding("UTF-8");

    int nextNo = postManager.getNextPostNo();
    dto.setNo(nextNo); // 번호 수동 지정

    dto.setName(request.getParameter("name"));
    dto.setTitle(request.getParameter("title"));
    dto.setCategory(request.getParameter("category"));
    dto.setContent(request.getParameter("content"));
    dto.setViews(0);
    dto.setLikes(0);

    boolean success = postManager.insertPost(dto);
    if (success) {
        response.sendRedirect("list.jsp");
    } else {
        out.print("<script>alert('등록 실패'); history.back();</script>");
    }
%>