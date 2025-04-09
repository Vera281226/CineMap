<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="pack.movie.MovieDao" %>

<%
  request.setCharacterEncoding("UTF-8");

  int id = Integer.parseInt(request.getParameter("id"));
  String bpage = request.getParameter("page");

  MovieDao dao = new MovieDao();
  boolean success = dao.deleteMovieById(id); // 삭제 성공 여부 체크

  if (success) {
    response.sendRedirect("movielist.jsp?page=" + bpage);
  } else {
    out.println("<script>alert('삭제 실패'); history.back();</script>");
  }
%>
