<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (request.getAttribute("searchMovie") == null) {
        response.sendRedirect(request.getContextPath() + "/search");
        return;
    }
if (request.getAttribute("searchPosts") == null) {
    response.sendRedirect(request.getContextPath() + "/search");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>검색 결과</title>
</head>
<body>
<%@include file="index_top.jsp" %>
    <h1>검색 결과</h1>
    <!-- 영화 검색 결과 -->
    <div class="result-section">
        <h2>영화 검색 결과</h2>
        <c:choose>
            <c:when test="${not empty searchMovie}">
                    <c:forEach var="movie" items="${searchMovie}">
                             <img src="${movie.imageUrl}" alt="${movie.title}">     
                    </c:forEach>
            </c:when>
            <c:otherwise>
                <p>검색된 영화가 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- 게시글 검색 결과 -->
    <div class="result-section">
        <h2>게시글 검색 결과</h2>
        <c:choose>
            <c:when test="${not empty searchPosts}">
                <ul>
                    <c:forEach var="post" items="${searchPosts}">
                        <li class="result-item">
                            게시글 제목: ${post.title}<br>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p>검색된 게시글이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>