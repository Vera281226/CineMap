<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:useBean id="memberManager" class="pack.member.MemberManager" scope="session" />
<% request.setCharacterEncoding("utf-8"); %>

<%-- EL로 로그인 처리 --%>
<c:set var="id" value="${id}" />
<c:set var="passwd" value="${passwd}" />

<c:choose>
    <c:when test="${memberManager.loginCheck(id)}">
        <c:set var="idKey" value="${id}" scope="session" />
        <c:redirect url="/index.jsp" />
    </c:when>
    <c:otherwise>
        <c:redirect url="logfail.html" />
    </c:otherwise>
</c:choose>
