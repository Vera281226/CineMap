<%@page import="pack.member.MemberDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="memberManager" class="pack.member.MemberManager"/>

<%
String id = (String) session.getAttribute("idKey");
MemberDto dto = memberManager.getMember(id);
String passwdInput = (String) request.getAttribute("password");

if (id == null) {
    // 로그인 정보가 없을 경우
    out.println("<script>alert('로그인 정보가 없습니다.'); location.href='login.jsp';</script>");
    return;
}

try {
    
    if(passwdInput == dto.getPasswd()){
%>
        <script>
            location.href = "memberupdate.jsp";  
        </script>
<%
    }else{
%>
        <script>
            alert("비밀번호가 일치하지 않습니다.");
            history.back();  // 이전 페이지로 돌아감
        </script>
<%    	
    }
} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('서버 오류로 인한 실패. 다시 시도해주세요.'); location.href='../index.jsp';</script>");
}
%>