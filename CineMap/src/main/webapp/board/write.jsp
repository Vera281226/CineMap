<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
</head>
<body>

<h2>게시글 작성</h2>

<form action="insert.jsp" method="post">
    작성자: <input type="text" name="name" required /><br/>
    제목: <input type="text" name="title" required /><br/>
    
    카테고리:
    <select name="category">
        <option value="스포">스포</option>
        <option value="개봉예정작">개봉예정작</option>
        <option value="공지사항">공지사항</option>
        <option value="자유게시판">자유게시판</option>
    </select><br/>

    내용:<br/>
    <textarea name="content" rows="10" cols="50" required></textarea><br/>

    <input type="submit" value="작성 완료" />
</form>

</body>
</html>