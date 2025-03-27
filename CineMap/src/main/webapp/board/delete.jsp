<%@page import="pack.post.PostManager"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager" />

<%
    int no = Integer.parseInt(request.getParameter("no"));
    boolean success = postManager.deletePost(no);

    if (success) {
        response.sendRedirect("list.jsp");
    } else {
        out.print("<script>alert('삭제 실패'); history.back();</script>");
    }
%>