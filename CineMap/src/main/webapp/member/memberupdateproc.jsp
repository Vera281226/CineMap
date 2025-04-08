<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="memberBean" class="pack.member.MemberBean"/>
<jsp:setProperty property="*" name="memberBean"/>

<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
String id = (String)session.getAttribute("idKey");
boolean updateResult = false;
if (id != null) {
    updateResult = memberManager.memberUpdate(memberBean, id);
}
request.setAttribute("updateResult", updateResult);
%>

<c:choose>
    <c:when test="${updateResult}" >
        <script>
            alert("수정 성공");
            location.href = "../index.jsp";
        </script>
    </c:when>
    <c:otherwise>
        <script>
            alert("수정 실패\n 관리자에게 문의 바람");
            history.back();
        </script>
    </c:otherwise>
</c:choose>