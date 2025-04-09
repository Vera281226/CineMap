<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.review.ReviewDao"%>
<%@ page import="pack.review.ReviewDto"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    request.setCharacterEncoding("UTF-8");
    int num = Integer.parseInt(request.getParameter("num"));
    int movieId = Integer.parseInt(request.getParameter("movieId"));
    String bpage = request.getParameter("page");

    ReviewDao dao = new ReviewDao();
    ReviewDto review = dao.getReplyData(num);

    request.setAttribute("review", review);
    request.setAttribute("bpage", bpage);
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>리뷰 수정</title>
  <script>
    function check() {
      const frm = document.forms["frm"];
      if (frm.cont.value.trim() === "") {
        alert("내용을 입력하세요");
        frm.cont.focus();
        return;
      }
      if (frm.rating && frm.rating.value === "0") {
        alert("별점을 선택하세요");
        return;
      }
      frm.submit();
    }

    document.addEventListener("DOMContentLoaded", function () {
      const ratingInput = document.getElementById("rating");
      if (ratingInput) {
        const rating = parseInt("${review.rating != null ? review.rating : 0}");
        const stars = document.querySelectorAll(".star");

        stars.forEach((star, idx) => {
          star.addEventListener("click", () => {
            ratingInput.value = idx + 1;
            stars.forEach((s, i) => {
              s.textContent = i <= idx ? "★" : "☆";
            });
          });

          star.textContent = idx < rating ? "★" : "☆";
        });

        ratingInput.value = rating;
      }
    });
  </script>
</head>
<body>
  <form name="frm" method="post" action="reviewupdateproc.jsp">
    <input type="hidden" name="num" value="${review.num}">
    <input type="hidden" name="movieId" value="${review.movieId}">
    <input type="hidden" name="page" value="${bpage}">
    <input type="hidden" name="nested" value="${review.nested}">

    <table border="1">
      <tr>
        <td colspan="2"><h2>리뷰 수정</h2></td>
      </tr>
      <tr>
        <td>작성자</td>
        <td>${review.nickname}</td>
      </tr>
      <tr>
        <td>내용</td>
        <td><textarea name="cont" rows="10" style="width: 100%">${review.cont}</textarea></td>
      </tr>

      <c:if test="${review.nested == 1}">
        <tr>
          <td>별점</td>
          <td>
            <div id="star-rating">
              <input type="hidden" name="rating" id="rating" value="0">
              <c:forEach var="i" begin="1" end="5">
                <span class="star">☆</span>
              </c:forEach>
            </div>
          </td>
        </tr>
      </c:if>

      <tr>
        <td colspan="2" align="center">
          <input type="button" value="수정 완료" onclick="check()">
          <input type="button" value="취소" onclick="history.back()">
        </td>
      </tr>
    </table>
  </form>
</body>
</html>
