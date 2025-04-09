<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Comparator"%>
<%@page import="pack.post.PostDto"%>
<%@page import="pack.board.CommentDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="dao" class="pack.post.PostDao" />
<jsp:useBean id="commentManager" class="pack.board.CommentManager"/>

<%
request.setCharacterEncoding("utf-8");
    int no = Integer.parseInt(request.getParameter("no"));

    // 조회수 중복 방지용 세션 체크
    ArrayList<Integer> viewedPosts = (ArrayList<Integer>) session.getAttribute("viewedPosts");
    if (viewedPosts == null) {
        viewedPosts = new ArrayList<>();
        session.setAttribute("viewedPosts", viewedPosts);
    }
    if (!viewedPosts.contains(no)) {
    	dao.increaseViews(no);
        viewedPosts.add(no);
    }

    PostDto post = dao.getPostByNo(no);
    String loginId = (String)session.getAttribute("idKey");
    boolean isOwner = (loginId != null && loginId.equals(post.getId()));
    
    // 관리자 확인
    boolean isAdmin = "admin".equals(loginId);

    // 댓글 조회 및 정렬
    ArrayList<CommentDto> commentList = commentManager.getCommentsByPost(no);
    Collections.sort(commentList, (c1, c2) -> {
        if (c1.getGno() != c2.getGno()) return Integer.compare(c1.getGno(), c2.getGno());
        return Integer.compare(c1.getOno(), c2.getOno());
    });

    String category = request.getParameter("category");
    if (category == null) category = "";
    String sort = request.getParameter("sort");
    if (sort == null || sort.isEmpty()) sort = "recent";

    // 게시글 추천용 세션
    ArrayList<Integer> likedPosts = (ArrayList<Integer>) session.getAttribute("likedPosts");
    if (likedPosts == null) {
        likedPosts = new ArrayList<>();
        session.setAttribute("likedPosts", likedPosts);
    }
    boolean alreadyLikedPost = likedPosts.contains(post.getNo());

    // 댓글 좋아요용 세션
    ArrayList<Integer> likedComments = (ArrayList<Integer>) session.getAttribute("likedComments");
    if (likedComments == null) {
        likedComments = new ArrayList<>();
        session.setAttribute("likedComments", likedComments);
    }
%>

<%@ include file="/index_top.jsp" %>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/board/view.css">


<main class="board-main">
    <h2 class="board-title">게시글 상세정보</h2>

    <!-- 카테고리 메뉴 -->
    <div class="category-menu">
        <a href="list.jsp?sort=<%=sort%>" class="<%=category.isEmpty() ? "active" : ""%>">전체</a>
        <a href="list.jsp?category=스포&sort=<%=sort%>" class="<%="스포".equals(category) ? "active" : ""%>">스포</a>
        <a href="list.jsp?category=개봉예정작&sort=<%=sort%>" class="<%="개봉예정작".equals(category) ? "active" : ""%>">개봉예정작</a>
        <a href="list.jsp?category=공지사항&sort=<%=sort%>" class="<%="공지사항".equals(category) ? "active" : ""%>">공지사항</a>
        <a href="list.jsp?category=자유게시판&sort=<%=sort%>" class="<%="자유게시판".equals(category) ? "active" : ""%>">자유게시판</a>
    </div>

<div class="container">
    <div class="post-title"><%=post.getTitle()%></div>

    <div class="post-wrapper">
        <div class="post-views">조회수: <%=post.getViews()%></div>
        <div class="post-content"><%=post.getContent()%></div>
        <div class="post-info">
            작성자: <%=post.getNickname()%><br/>
            작성일: <%=post.getCreatedAt()%>
        </div>
    </div>

    <%
    if (isOwner || isAdmin) {
    %>
    <div style="text-align: right; margin-top: 10px;">
    	<% if (isOwner) { %>
        <form action="edit.jsp" method="get" style="display: inline;">
            <input type="hidden" name="no" value="<%=post.getNo()%>" />
            <input type="submit" value="수정" />
        </form>
        <% } %>
        <form action="delete.jsp" method="get" style="display: inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
            <input type="hidden" name="no" value="<%=post.getNo()%>" />
            <input type="submit" value="삭제" />
        </form>
    </div>
    <%
    }
    %>

    <!-- 게시글 추천 (토글 방식) -->
    <form action="like.jsp" method="post" style="text-align: right; margin-top: 20px;">
    	<input type="hidden" name="no" value="<%=post.getNo()%>" />
    	<input type="submit"
           value="<%=loginId == null ? "👍 추천하기" : (alreadyLikedPost ? "추천 취소하기" : "👍 추천하기")%>"
           <%=(loginId == null) ? "disabled" : ""%> />
    	<span style="margin-left: 10px; color: #888;">추천 수: <%=post.getLikes()%></span>
	</form>

    <!-- 댓글 작성 -->
    <h3 style="margin-top: 50px;">댓글 작성</h3>
    <%
    if (loginId != null) {
    %>
        <form action="writeComment.jsp" method="post">
            <input type="hidden" name="postNo" value="<%=post.getNo()%>">
            <textarea name="content" required placeholder="댓글을 입력하세요" style="width: 100%; height: 60px;"></textarea>
            <input type="submit" value="댓글 작성">
        </form>
    <%
    } else {
    %>
        <p style="color: gray;">※ 로그인 후 댓글을 작성할 수 있습니다.</p>
    <%
    }
    %>

    <!-- 댓글 목록 -->
    <h3 style="margin-top: 40px;">댓글 목록</h3>
    <table class="comment-table">
        <tr><th>작성자</th><th>내용</th><th>작성일</th><th>좋아요</th><th>관리</th></tr>
        <%
        for (CommentDto c : commentList) {
                    String indent = "&nbsp;&nbsp;".repeat(c.getNested()) + (c.getNested() > 0 ? "┖ " : "");
        %>
        <tr>
            <td><%= indent + c.getNickname() %></td>
            <td><%= c.getContent() %></td>
            <td><%= c.getCreatedAt() %></td>
            <td>
                <form action="likeComment.jsp" method="post" style="display: inline;">
                    <input type="hidden" name="commentNo" value="<%= c.getNo() %>">
                    <input type="hidden" name="postNo" value="<%= post.getNo() %>">
                    <input type="submit" value="👍" <%= likedComments.contains(c.getNo()) ? "disabled" : "" %> />
                    <span><%= c.getLikes() %></span>
                </form>
            </td>
            <td>
                <% if (loginId != null && loginId.equals(c.getId())) { %>
                    <form action="editComment.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="commentNo" value="<%= c.getNo() %>">
                        <input type="hidden" name="postNo" value="<%= post.getNo() %>">
                        <input type="submit" value="수정">
                    </form>
                    <form action="deleteComment.jsp" method="post" style="display: inline;" onsubmit="return confirm('댓글을 삭제하시겠습니까?');">
                        <input type="hidden" name="commentNo" value="<%= c.getNo() %>">
                        <input type="hidden" name="postNo" value="<%= post.getNo() %>">
                        <input type="submit" value="삭제">
                    </form>
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</main>

<script>
// 페이지 이동 전 스크롤 위치 저장
window.addEventListener("beforeunload", function () {
    sessionStorage.setItem("scrollY", window.scrollY);
});

// 페이지 로드 후 스크롤 위치 복원
window.addEventListener("load", function () {
    const scrollY = sessionStorage.getItem("scrollY");
    if (scrollY) {
        window.scrollTo(0, parseInt(scrollY));
    }
});
</script>