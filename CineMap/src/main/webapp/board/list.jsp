<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="pack.post.PostDto" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:useBean id="dao" class="pack.post.PostDao" />

<%
    String category = request.getParameter("category");
    if (category == null) category = "";

    String sort = request.getParameter("sort");
    if (sort == null || sort.isEmpty()) sort = "recent";

    int pageSize = 5;
    int pageno = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null) pageno = Integer.parseInt(pageParam);

    int start = (pageno - 1) * pageSize;

    String type = request.getParameter("type");
    String keyword = request.getParameter("keyword");

    List<PostDto> list;
    int totalPosts;

    if (type != null && keyword != null && !type.isEmpty() && !keyword.isEmpty()) {
        list = dao.searchPosts(type, keyword, start, pageSize, "recent");
        totalPosts = dao.countSearchPosts(type, keyword);
    } else if (!category.isEmpty()) {
        list = dao.getPostsByCategoryPageSorted(category, start, pageSize, sort);
        totalPosts = dao.getCategoryPostCount(category);
    } else {
        list = dao.getPostsByPageSorted(start, pageSize, sort);
        totalPosts = dao.getTotalPostCount();
    }

    int totalPages = (int)Math.ceil(totalPosts / (double)pageSize);
    if (totalPages == 0) totalPages = 1;

    StringBuilder paramBuilder = new StringBuilder();
    if (!category.isEmpty()) paramBuilder.append("&category=").append(category);
    if (!sort.isEmpty()) paramBuilder.append("&sort=").append(sort);
    if (type != null && keyword != null && !type.isEmpty() && !keyword.isEmpty()) {
        paramBuilder.append("&type=").append(type).append("&keyword=").append(keyword);
    }

    request.setAttribute("list", list);
    request.setAttribute("totalPosts", totalPosts);
    request.setAttribute("pageno", pageno);
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("paramString", paramBuilder.toString());
%>

<%@ include file="../index_top.jsp" %>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/board/board.css">

<main class="board-main">
    <h2>게시판</h2>

    <!-- 카테고리 필터 -->
    <div class="category-menu">
        <a href="list.jsp?sort=${param.sort}" class="${empty param.category ? 'active' : ''}">전체</a>
        <a href="list.jsp?category=스포&sort=${param.sort}" class="${param.category == '스포' ? 'active' : ''}">스포</a>
        <a href="list.jsp?category=개봉예정작&sort=${param.sort}" class="${param.category == '개봉예정작' ? 'active' : ''}">개봉예정작</a>
        <a href="list.jsp?category=공지사항&sort=${param.sort}" class="${param.category == '공지사항' ? 'active' : ''}">공지사항</a>
        <a href="list.jsp?category=자유게시판&sort=${param.sort}" class="${param.category == '자유게시판' ? 'active' : ''}">자유게시판</a>
    </div>

    <!-- 정렬 + 검색 -->
    <div class="board-controls">
        <form method="get" action="list.jsp">
            <label for="sort">정렬:</label>
            <select name="sort" id="sort" onchange="this.form.submit()">
                <option value="recent" ${param.sort == 'recent' || empty param.sort ? 'selected' : ''}>최신순</option>
                <option value="views" ${param.sort == 'views' ? 'selected' : ''}>조회순</option>
                <option value="likes" ${param.sort == 'likes' ? 'selected' : ''}>추천순</option>
            </select>
            <input type="hidden" name="category" value="${param.category}" />
        </form>

        <form action="list.jsp" method="get">
            <select name="type">
                <option value="title" ${param.type == 'title' ? 'selected' : ''}>제목</option>
                <option value="nickname" ${param.type == 'nickname' ? 'selected' : ''}>작성자</option>
                <option value="content" ${param.type == 'content' ? 'selected' : ''}>내용</option>
            </select>
            <input type="text" name="keyword" placeholder="검색어 입력" value="${param.keyword}" />
            <button type="submit">검색</button>
        </form>
    </div>

    <!-- 게시글 목록 -->
    <table class="board-table">
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
                <th>추천수</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dto" items="${list}">
                <tr>
                    <td>${dto.no}</td>
                    <td>
					  <a href="view.jsp?no=${dto.no}&category=${param.category}&sort=${param.sort}">
					    ${dto.title}
					  </a>
					</td>
                    <td>${dto.nickname}</td>
                    <td>${dto.displayDate}</td>
                    <td>${dto.views}</td>
                    <td>${dto.likes}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <div class="pagination">
        <c:choose>
            <c:when test="${pageno > 1}">
                <a href="list.jsp?page=${pageno - 1}${paramString}">❮</a>
            </c:when>
            <c:otherwise><span class="disabled">❮</span></c:otherwise>
        </c:choose>

        <c:forEach var="i" begin="1" end="${totalPages}">
            <a href="list.jsp?page=${i}${paramString}" class="${i == pageno ? 'active' : ''}">${i}</a>
        </c:forEach>

        <c:choose>
            <c:when test="${pageno < totalPages}">
                <a href="list.jsp?page=${pageno + 1}${paramString}">❯</a>
            </c:when>
            <c:otherwise><span class="disabled">❯</span></c:otherwise>
        </c:choose>
    </div>

    <!-- 글쓰기 버튼 -->
    <c:if test="${param.category != '공지사항' || sessionScope.idKey == 'admin'}">
        <form action="write.jsp" method="get">
            <button type="submit">글쓰기</button>
        </form>
    </c:if>
</main>
