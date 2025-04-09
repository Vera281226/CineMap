<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="pack.cookie.CookieManager" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% CookieManager cm = CookieManager.getInstance(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>시네맵 - 영화 커뮤니티</title>

    <!-- 외부 라이브러리 -->
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <!-- 메인 CSS -->
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
    <!-- ✅ 상단 헤더 -->
    <header>
        <div class="logo">
            <a href="${pageContext.request.contextPath}/index.jsp">시네맵</a>
        </div>

        <div class="search-bar">
            <input type="text" id="movieSearch" name="movieSearch" placeholder="영화 제목 입력">
        </div>

        <div class="login">
            <c:choose>
                <c:when test="${not empty sessionScope.idKey}">
                    <a href="${pageContext.request.contextPath}/member/mypage.jsp">마이페이지</a>
                    <a href="${pageContext.request.contextPath}/member/logout.jsp">로그아웃</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/member/login.jsp">로그인</a>
                </c:otherwise>
            </c:choose>
        </div>

        <button id="theme-toggle">🌙</button>
    </header>

    <!-- ✅ 네비게이션 메뉴 -->
    <nav>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/board/list.jsp?category=공지사항">공지사항</a></div>
        <div class="menu-item"><a href="${pageContext.request.contextPath}/review/movielist.jsp">영화 리뷰</a></div>

        <!-- 영화관 드롭다운 -->
        <div class="menu-item dropdown" id="dropdown-container">
            <a id="menu-toggle">영화관</a>
            <div class="submenu" id="dropdown-menu">
                <a href="${pageContext.request.contextPath}/location/theaterGroup.jsp?name=CGV">CGV</a>
                <a href="${pageContext.request.contextPath}/location/theaterGroup.jsp?name=메가박스">메가박스</a>
                <a href="${pageContext.request.contextPath}/location/theaterGroup.jsp?name=롯데시네마">롯데시네마</a>
                <a href="${pageContext.request.contextPath}/location/theaterGroup.jsp?name=기타">그 외</a>
            </div>
        </div>

        <!-- 자유게시판 드롭다운 -->
        <div class="menu-item dropdown" id="board-dropdown-container">
            <a id="board-menu-toggle">자유 게시판</a>
            <div class="submenu" id="board-dropdown-menu">
                <a href="${pageContext.request.contextPath}/board/list.jsp">전체</a>
                <a href="${pageContext.request.contextPath}/board/list.jsp?category=스포">스포</a>
                <a href="${pageContext.request.contextPath}/board/list.jsp?category=개봉예정작">개봉예정작</a>
                <a href="${pageContext.request.contextPath}/board/list.jsp?category=자유게시판">자유게시판</a>
            </div>
        </div>
    </nav>

    <!-- ✅ 스크립트 영역 -->
    <script>
    $(function () {
        const searchInput = $("#movieSearch");
        const themeToggle = document.getElementById("theme-toggle");

        // 자동완성 기능
        searchInput.autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: "/CineMap/autocomplete.jsp",
                    dataType: "json",
                    data: { term: request.term },
                    success: function (data) {
                        response(data);
                    },
                    error: function () {
                        response([]);
                    }
                });
            },
            minLength: 1
        });

        // Enter 키 이벤트 핸들러
        searchInput.on("keydown", function (event) {
            if (event.keyCode === 13) {
                event.preventDefault();
                const searchTerm = searchInput.val().trim();
                if (searchTerm) {
                    window.location.href = "${pageContext.request.contextPath}/search?query=" + encodeURIComponent(searchTerm);
                }
            }
        });

        // 다크모드 토글
        const savedTheme = localStorage.getItem("theme");
        if (savedTheme === "dark") {
            document.body.classList.add("dark-mode");
            themeToggle.textContent = "☀️";
        } else {
            themeToggle.textContent = "🌙";
        }

        themeToggle.addEventListener("click", () => {
            const isDarkMode = document.body.classList.toggle("dark-mode");
            themeToggle.textContent = isDarkMode ? "☀️" : "🌙";
            localStorage.setItem("theme", isDarkMode ? "dark" : "light");
            
            updateThemeImages(isDarkMode);
        });

        // 드롭다운 - 영화관 (timeout 적용)
        const theaterContainer = document.getElementById("dropdown-container");
        const theaterDropdown = document.getElementById("dropdown-menu");
        let theaterTimeout;

        theaterContainer.addEventListener("mouseenter", () => {
            clearTimeout(theaterTimeout);
            theaterDropdown.classList.add("show");
            boardDropdown.classList.remove("show"); // 다른 메뉴 닫기
        });
        theaterContainer.addEventListener("mouseleave", () => {
            theaterTimeout = setTimeout(() => {
                theaterDropdown.classList.remove("show");
            }, 300);
        });

        // 드롭다운 - 자유게시판 (timeout 적용)
        const boardContainer = document.getElementById("board-dropdown-container");
        const boardDropdown = document.getElementById("board-dropdown-menu");
        let boardTimeout;

        boardContainer.addEventListener("mouseenter", () => {
            clearTimeout(boardTimeout);
            boardDropdown.classList.add("show");
            theaterDropdown.classList.remove("show"); // 다른 메뉴 닫기
        });
        boardContainer.addEventListener("mouseleave", () => {
            boardTimeout = setTimeout(() => {
                boardDropdown.classList.remove("show");
            }, 300);
        });
    });
    </script>
</body>
<%
    // 1. 이미 로그인된 경우 건너뜀
    if (session.getAttribute("idKey") == null) {
        // 2. 쿠키 확인
        Cookie[] cookies = request.getCookies();
        String autValue = null;
        String uidValue = null;
        String updValue = null;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("AUT".equals(cookie.getName())) autValue = cookie.getValue();
                if ("UID".equals(cookie.getName())) uidValue = cookie.getValue();
                if ("UPD".equals(cookie.getName())) updValue = cookie.getValue();
            }
        }

        // 3. 자동 로그인 조건 충족 시
        if ("1".equals(autValue) && uidValue != null && updValue != null) {
            try {
                // 4. 복호화
                String username = cm.readDecryptCookie(new Cookie("UID", uidValue));
                String password = cm.readDecryptCookie(new Cookie("UPD", updValue));

                // 5. 자동 로그인 폼 생성 및 제출
%>
                <form id="autoLoginForm" action="/CineMap/member/loginproc.jsp" method="post" style="display:none;">
                    <input type="text" name="id" value="<%= username %>">
                    <input type="password" name="passwd" value="<%= password %>">
                </form>
                <script>
                    document.getElementById('autoLoginForm').submit();
                </script>
<%
            } catch (Exception e) {
                e.printStackTrace();
                // 복호화 실패 시 쿠키 삭제
                response.addCookie(cm.deleteCookie("AUT"));
                response.addCookie(cm.deleteCookie("UID"));
                response.addCookie(cm.deleteCookie("UPD"));
            }
        }
    }
%>
</html>
