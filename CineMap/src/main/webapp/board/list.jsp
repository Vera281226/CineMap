<%@page import="java.util.ArrayList"%>
<%@page import="pack.post.PostDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:useBean id="postManager" class="pack.post.PostManager"/>
<jsp:useBean id="dto" class="pack.post.PostDTO"/>
<%
    String category = request.getParameter("category");
    if (category == null) category = "";

    String sort = request.getParameter("sort");
    if (sort == null || sort.isEmpty()) sort = "recent";
%>
<%
    int pageSize = 3;
    int pageno = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) pageno = Integer.parseInt(pageParam);

    int start = (pageno - 1) * pageSize;

    String type = request.getParameter("type");
    String keyword = request.getParameter("keyword");

    ArrayList<PostDTO> list;
    int totalPosts;

    if (type != null && keyword != null && !type.isEmpty() && !keyword.isEmpty()) {
        list = postManager.searchPosts(type, keyword, start, pageSize, "recent");
        totalPosts = postManager.countSearchPosts(type, keyword);
    } else if (!category.isEmpty()) {
        list = postManager.getPostsByCategoryPageSorted(category, start, pageSize, sort);
        totalPosts = postManager.getCategoryPostCount(category);
    } else {
        list = postManager.getPostsByPageSorted(start, pageSize, sort);
        totalPosts = postManager.getTotalPostCount();
    }

    int totalPages = (int)Math.ceil(totalPosts / (double)pageSize);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<link rel="stylesheet" type="text/css" href="../css/board.css">
</head>
<body>

<h2>게시판</h2>
<!-- 카테고리 필터 -->
<div class="category-menu">
    <a href="list.jsp?<%= "sort=" + sort %>" class="<%= (category == null || category.isEmpty()) ? "active" : "" %>">전체</a>
    <a href="list.jsp?category=스포&sort=<%=sort%>" class="<%= "스포".equals(category) ? "active" : "" %>">스포</a>
    <a href="list.jsp?category=개봉예정작&sort=<%=sort%>" class="<%= "개봉예정작".equals(category) ? "active" : "" %>">개봉예정작</a>
    <a href="list.jsp?category=공지사항&sort=<%=sort%>" class="<%= "공지사항".equals(category) ? "active" : "" %>">공지사항</a>
    <a href="list.jsp?category=자유게시판&sort=<%=sort%>" class="<%= "자유게시판".equals(category) ? "active" : "" %>">자유게시판</a>
</div>

<!-- 정렬 + 검색 분리 정렬 -->
<div style="display: flex; justify-content: space-between; align-items: center; margin: 15px 0;">

    <!-- 왼쪽: 정렬 -->
    <form method="get" action="list.jsp" style="display: flex; align-items: center; gap: 8px;">
        <label for="sort">정렬:</label>
        <select name="sort" id="sort" onchange="this.form.submit()">
            <option value="recent" <%= ("recent".equals(request.getParameter("sort")) || request.getParameter("sort") == null) ? "selected" : "" %>>최신순</option>
            <option value="views" <%= "views".equals(request.getParameter("sort")) ? "selected" : "" %>>조회순</option>
            <option value="likes" <%= "likes".equals(request.getParameter("sort")) ? "selected" : "" %>>추천순</option>
        </select>
        <input type="hidden" name="category" value="<%= category %>" />
    </form>

    <!-- 오른쪽: 검색 -->
    <form action="list.jsp" method="get" style="display: flex; align-items: center; gap: 8px;">
        <select name="type" id="type">
            <option value="title" <%= "title".equals(request.getParameter("type")) ? "selected" : "" %>>제목</option>
            <option value="name" <%= "name".equals(request.getParameter("type")) ? "selected" : "" %>>작성자</option>
            <option value="content" <%= "content".equals(request.getParameter("type")) ? "selected" : "" %>>내용</option>
        </select>
        <input type="text" name="keyword" placeholder="검색어 입력" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" />
        <input type="submit" value="검색" />
    </form>

</div>

<table>
    <tr>
        <th>번호</th>
        <th>제목</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>조회수</th>
        <th>추천수</th>
        <th>수정</th>
        <th>삭제</th>
    </tr>
    <%
        for (int i = 0; i < list.size(); i++) {
            dto = list.get(i);
    %>
    <tr>
        <td><%= dto.getNo() %></td>
        <td><a href="view.jsp?no=<%=dto.getNo()%>"><%= dto.getTitle() %></a></td>
        <td><%= dto.getName() %></td>
        <td><%= dto.getCreatedAt() %></td>
        <td><%= dto.getViews() %></td>
        <td><%= dto.getLikes() %></td>
        <td>
            <form action="edit.jsp" method="get">
                <input type="hidden" name="no" value="<%=dto.getNo()%>" />
                <input type="submit" value="수정" />
            </form>
        </td>
        <td>
		    <form action="delete.jsp" method="get" onsubmit="return confirm('정말 삭제하시겠습니까?');">
		        <input type="hidden" name="no" value="<%=dto.getNo()%>" />
		        <input type="submit" value="삭제" />
		    </form>
		</td>
    </tr>
    <%
        }
    %>
</table>

<div style="display: flex; justify-content: space-between; align-items: center; margin: 20px 0;">

    <!-- 페이지네이션 -->
    <div class="pagination" style="flex: 1; text-align: center;">
        <%
            String categoryParam = (category != null && !category.isEmpty()) ? "&category=" + category : "";
            String sortParam = (sort != null && !sort.isEmpty()) ? "&sort=" + sort : "";
            String keywordParam = (keyword != null && !keyword.isEmpty()) ? "&type=" + type + "&keyword=" + keyword : "";
        %>

        <%-- 이전 버튼 --%>
        <% if (pageno > 1) { %>
            <a href="list.jsp?page=<%= pageno - 1 %><%= categoryParam %><%= sortParam %><%= keywordParam %>">❮</a>
        <% } else { %>
            <span class="disabled">❮</span>
        <% } %>

        <%-- 페이지 번호 --%>
        <%
            for (int i = 1; i <= totalPages; i++) {
                boolean isActive = (i == pageno);
        %>
            <a href="list.jsp?page=<%= i %><%= categoryParam %><%= sortParam %><%= keywordParam %>"
               class="<%= isActive ? "active" : "" %>">
                <%= i %>
            </a>
        <%
            }
        %>

        <%-- 다음 버튼 --%>
        <% if (pageno < totalPages) { %>
            <a href="list.jsp?page=<%= pageno + 1 %><%= categoryParam %><%= sortParam %><%= keywordParam %>">❯</a>
        <% } else { %>
            <span class="disabled">❯</span>
        <% } %>
    </div>

    <!-- 글쓰기 버튼 -->
    <form action="write.jsp" method="get" style="margin-left: 20px;">
        <input type="submit" value="글쓰기" />
    </form>

</div>

</body>
</html>