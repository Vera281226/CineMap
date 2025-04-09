<%@ page import="pack.review.ReviewBean" %>
<%@ page import="pack.review.ReviewDao" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    request.setCharacterEncoding("utf-8");

    int num = Integer.parseInt(request.getParameter("num"));
    int movieId = Integer.parseInt(request.getParameter("movieId"));
    String cont = request.getParameter("cont");
    String bpage = request.getParameter("page");
    
    
    String[] badWords = {"ㅅㅂ", "tq"};
    for (String word : badWords) {
        if (cont != null && cont.contains(word)) {
            out.println("<script>alert('금지된 단어가 포함되어 있습니다.'); history.back();</script>");
            return;
        }
    }
    
    int rating = 0;
    String ratingParam = request.getParameter("rating");
    if (ratingParam != null && !ratingParam.trim().isEmpty()) {
        try {
            rating = Integer.parseInt(ratingParam);
        } catch (Exception ignored) {
            rating = 0;
        }
    }


    String userId = (String) session.getAttribute("user_id");

    ReviewBean bean = new ReviewBean();
    bean.setNum(num);
    bean.setMovieId(movieId);
    bean.setCont(cont);
    bean.setRating(rating);
    bean.setUserId(userId);  // 수정 시 userId 체크 보안

    ReviewDao dao = new ReviewDao();
    dao.updateReview(bean);

    response.sendRedirect("reviewcontent.jsp?movieId=" + movieId + "&page=" + bpage);
%>
