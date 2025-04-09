<%@ page import="java.util.List"%>
<%@ page import="pack.review.ReviewDto"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="pack.review.ReviewDao"%>
<%@ page import="pack.movie.MovieDto"%>
<%@ page import="pack.movie.MovieDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  int movieId = Integer.parseInt(request.getParameter("movieId"));
  String bpage = request.getParameter("page");

  MovieDao movieDao = new MovieDao();
  ReviewDao reviewDao = new ReviewDao();

  MovieDto movie = movieDao.getMovieById(movieId);
  List<ReviewDto> reviews = reviewDao.getReviewsByMovieId(movieId);
  double avgRating = reviewDao.getAverageRating(movieId);

  if (session.getAttribute("user_id") == null) {
    session.setAttribute("user_id", "testuser");
    session.setAttribute("nickname", "haruka");
  }

  request.setAttribute("movie", movie);
  request.setAttribute("reviews", reviews);
  request.setAttribute("avgRating", avgRating);
  request.setAttribute("bpage", bpage);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>${movie.title} - 상세 보기</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/review/reviewcontent.css">
</head>
<body>

<!-- ✅ 공통 상단 include -->
<%@ include file="../index_top.jsp"%>

<div class="movie-detail-container">

  <div class="movie-header">
    <a href="reply.jsp?movieId=${movie.id}&page=${bpage}" class="login-check" data-url="reply.jsp?movieId=${movie.id}&page=${bpage}">리뷰 쓰기</a>
    <c:if test="${not empty sessionScope.admin}">
      <a href="edit.jsp?id=${movie.id}&page=${bpage}">수정하기</a>
      <a href="moviedeleteproc.jsp?id=${movie.id}&page=${bpage}" class="confirm-delete">삭제하기</a>
    </c:if>
    <a href="movielist.jsp?page=${bpage}">목록 보기</a>
  </div>

  <div class="movie-title">${movie.title}</div>

  <div class="movie-info-wrapper">
    <div class="movie-info">
      <p class="movie-meta">개봉일: ${movie.releaseDate}</p>
      <p class="movie-meta">장르: ${movie.genre}</p>
      <p class="movie-meta">출연: ${movie.actorName}</p>
      <p class="movie-meta">
        평균 별점: <fmt:formatNumber value="${avgRating}" pattern="0.0" /> / 5.0
        <span class="stars">★</span>
      </p>
    </div>
    <div class="movie-image">
      <img src="${movie.imageUrl}" alt="${movie.title} 포스터">
    </div>
  </div>

  <div class="movie-description">
    ${movie.description}
  </div>

  <div class="comment-box">
    <h3>리뷰 목록</h3>

    <c:if test="${empty reviews}">
      <p>등록된 리뷰가 없습니다.</p>
    </c:if>

    <c:forEach var="review" items="${reviews}">
      <c:set var="indent" value="${review.nested * 20}" />
      <div class="comment" style="margin-left:${indent}px;">
        <c:if test="${review.nested == 1 && review.rating > 0}">
          <div class="stars">
            <c:forEach var="i" begin="1" end="5">
              <c:choose>
                <c:when test="${i <= review.rating}">★</c:when>
                <c:otherwise>☆</c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </c:if>

        <p><b>${review.nickname}</b>: ${review.cont}</p>

        <p class="meta">
          (<fmt:formatDate value="${review.cdate}" pattern="yyyy-MM-dd HH:mm" />)

          <button class="likeBtn" data-num="${review.num}">
            ❤️ <span id="like-${review.num}">${review.likeCount}</span>
          </button>

          <c:if test="${review.nested == 1}">
            <a href="reply.jsp?num=${review.num}&page=${bpage}" class="login-check" data-url="reply.jsp?num=${review.num}&page=${bpage}">답글</a>
          </c:if>

          <c:if test="${sessionScope.user_id == review.userId}">
            <a href="reviewupdate.jsp?num=${review.num}&movieId=${movie.id}&page=${bpage}">수정</a>
            <a href="reviewdelete.jsp?num=${review.num}&movieId=${movie.id}&page=${bpage}" class="confirm-delete">삭제</a>
          </c:if>
        </p>
      </div>
    </c:forEach>
  </div>

</div>

<!-- ✅ 좋아요 및 로그인 체크 스크립트 -->
<script>
const contextPath = "<%= request.getContextPath() %>";
const isLoggedIn = <%= session.getAttribute("user_id") != null %>;

document.addEventListener("DOMContentLoaded", function () {
  document.querySelectorAll(".likeBtn").forEach(button => {
    button.addEventListener("click", function () {
      const num = this.getAttribute("data-num");
      const url = contextPath + "/review/ajax/like.jsp?num=" + num;
      const countSpan = document.getElementById("like-" + num);
      const btn = this;

      fetch(url)
        .then(response => response.text())
        .then(result => {
          const trimmed = result.trim();
          if (trimmed === "unauthorized") {
            alert("로그인 후 이용 가능합니다.");
            return;
          }
          if (trimmed.startsWith("liked:")) {
            const count = trimmed.split(":")[1];
            countSpan.textContent = count;
            btn.title = "좋아요 취소";
            return;
          }
          if (trimmed.startsWith("unliked:")) {
            const count = trimmed.split(":")[1];
            countSpan.textContent = count;
            btn.title = "좋아요";
            return;
          }
        });
    });
  });

  document.querySelectorAll(".login-check").forEach(link => {
    link.addEventListener("click", function (e) {
      if (!isLoggedIn) {
        e.preventDefault();
        alert("로그인 후 이용 가능합니다.");
      } else {
        location.href = this.getAttribute("data-url");
      }
    });
  });

  document.querySelectorAll(".confirm-delete").forEach(link => {
    link.addEventListener("click", function (e) {
      const confirmed = confirm("정말 삭제하시겠습니까?");
      if (!confirmed) {
        e.preventDefault();
      }
    });
  });
});
</script>

</body>
</html>