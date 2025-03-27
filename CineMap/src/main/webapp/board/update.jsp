<%@page import="pack.post.PostDTO"%>
<%@page import="pack.post.PostManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager" />
<jsp:useBean id="dto" class="pack.post.PostDTO" />

<%
    request.setCharacterEncoding("UTF-8");

    dto.setNo(Integer.parseInt(request.getParameter("no")));
    dto.setName(request.getParameter("name"));
    dto.setCategory(request.getParameter("category"));
    dto.setTitle(request.getParameter("title"));
    dto.setContent(request.getParameter("content"));

    boolean success = postManager.updatePost(dto);
    if (success) {
        response.sendRedirect("view.jsp?no=" + dto.getNo());
    } else {
        out.print("<script>alert('수정 실패'); history.back();</script>");
    }
%>