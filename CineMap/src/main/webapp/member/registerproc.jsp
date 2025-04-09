<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:useBean id="mbean" class="pack.member.MemberBean" />
<jsp:setProperty property="*" name="mbean" />

<jsp:useBean id="memberManager" class="pack.member.MemberManager" />
<c:set var="b" value="${memberManager.memberInsert(mbean)}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입 결과</title>
</head>
<body>
    <c:choose>
        <c:when test="${b}">
            <b>회원가입을 축하합니다</b><br>
            <a href="login.jsp">회원 로그인</a>
        </c:when>
        <c:otherwise>
            <b>회원가입 실패</b><br>
            <a href="register.jsp">가입 재시도</a>
        </c:otherwise>
    </c:choose>
</body>
</html>
