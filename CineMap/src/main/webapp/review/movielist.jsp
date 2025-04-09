<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.movie.MovieDto" %>
<%@ page import="pack.movie.MovieDao" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // 캐시 무효화 설정
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    int bpage = 1;
    int pageList = 5;
    try {
        bpage = Integer.parseInt(request.getParameter("page"));
    } catch(Exception e) {
        bpage = 1;
    }
    if (bpage <= 0) bpage = 1;

    String searchWord = request.getParameter("searchWord");
    if (searchWord == null) searchWord = "";

    MovieDao dao = new MovieDao();
    int totalRecord = dao.getMovieCount(searchWord);
    int pageSu = totalRecord / pageList + (totalRecord % pageList > 0 ? 1 : 0);
    if (pageSu == 0) pageSu = 1;

    int start = (bpage - 1) * pageList;
    List<MovieDto> list = dao.getPagedMovies(start, pageList, searchWord);

    request.setAttribute("list", list);
    request.setAttribute("bpage", bpage);
    request.setAttribute("pageSu", pageSu);
    request.setAttribute("totalRecord", totalRecord);
    request.setAttribute("searchWord", searchWord);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>영화 목록</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/review/review.css">
</head>
<body>

<!-- 공통 헤더 include -->
<%@ include file="../index_top.jsp" %>

<main>

    <!-- 검색 및 새글작성 링크 -->
    <div class="search-and-nav-wrapper">
        <div class="nav">
            <a href="../index.jsp">메인으로</a>
            <a href="movielist.jsp?page=1">최근목록</a>
            <c:if test="${not empty sessionScope.admin}">
                <a href="moviewrite.jsp">새글작성</a>
            </c:if>
        </div>

        <div class="search-form">
            <form action="movielist.jsp" name="frm" method="post">
                <input type="text" name="searchWord" placeholder="영화 제목 입력" value="${searchWord}">
                <input type="submit" value="검색" id="btnSearch">
            </form>
        </div>
    </div>

    <!-- 영화 카드 목록 -->
    <div class="movie-list-container">
        <c:forEach var="movie" items="${list}">
            <div class="movie-card">
                <a href='reviewcontent.jsp?movieId=${movie.id}&page=${bpage}'>
                    <img src="${movie.imageUrl}" alt="영화 포스터">
                    <div class="title">${movie.title}</div>
                    <div class="meta">장르: ${movie.genre}</div>
                    <div class="meta">출연: ${movie.actorName}</div>
                    <div class="meta">개봉일: ${movie.releaseDate}</div>
                </a>
            </div>
        </c:forEach>
    </div>

    <!-- 페이지네이션 -->
    <div class="pagination">
        <c:if test="${bpage > 1}">
            <a href="movielist.jsp?page=${bpage - 1}&searchWord=${searchWord}">← 이전</a>
        </c:if>

        <c:forEach begin="1" end="${pageSu}" var="i">
            <c:choose>
                <c:when test="${i == bpage}">
                    <b class="current-page">[${i}]</b>
                </c:when>
                <c:otherwise>
                    <a href="movielist.jsp?page=${i}&searchWord=${searchWord}">[${i}]</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <c:if test="${bpage < pageSu}">
            <a href="movielist.jsp?page=${bpage + 1}&searchWord=${searchWord}">다음 →</a>
        </c:if>
    </div>

</main>

</body>
</html>