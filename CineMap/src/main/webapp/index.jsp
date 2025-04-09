<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%
    if (request.getAttribute("recentPosts") == null) {
        response.sendRedirect(request.getContextPath() + "/index");
        return;
    }
%>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/main.css">
    <title>시네맵</title>
</head>
<body>

<%@include file="../index_top.jsp" %> <!-- ✅ 공통 헤더 포함 -->

<main>
  <div class="content-wrapper"> <!-- ✅ 왼쪽 + 오른쪽 영역 포함하는 컨테이너 -->

    <!-- ✅ 왼쪽 게시글 영역 -->
    <div class="left-section">
      <div class="free-board">
        <c:forEach items="${recentPosts}" var="post">     
          <a href="${pageContext.request.contextPath}/board/view.jsp?no=${post.no}">
            ${post.title}
          </a><br>
        </c:forEach>
      </div>

      <div class="free-board">
        <c:forEach items="${popularPosts}" var="post">     
          <a href="${pageContext.request.contextPath}/board/view.jsp?no=${post.no}">
            ${post.title}
          </a><br>
        </c:forEach>
      </div>
    </div>

    <!-- ✅ 오른쪽 포스터 슬라이더 -->
    <div class="right-section">
      <div class="movie-slider">
        <c:forEach items="${currentMovies}" var="movie">
          <div class="movie-item">
            <a href="${pageContext.request.contextPath}/review/reviewcontent.jsp?movieId=${movie.id}">
              <img src="${movie.imageUrl}" alt="${movie.title}">
              <div class="movie-title">${movie.title}</div>
            </a>
          </div>
        </c:forEach>
      </div>
    </div>

  </div>
</main>

</body>
</html>
