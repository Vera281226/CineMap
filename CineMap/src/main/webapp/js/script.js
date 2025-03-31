function idCheck(){
	if(regForm.id.value === ""){
		alert("id를 입력하세요");
		regForm.id.focus();
	}else{
		const url = "idcheck.jsp?id=" + regForm.id.value;
		window.open(url,"id", "toolbar=no,width=300,height=150,top=200,left=100");
	}
}

function inputCheck(){
	// 입력 자료 검사 후 서버로 전송
	if(regForm.id.value === ""){
		alert("id를 입력하세요");
		regForm.id.focus();
		return;
	}
	
	// 이하 생략 ...
	
	// 패스워드 일치 여부 확인
	if (regForm.passwd.value !== regForm.repasswd.value) {
	    alert("패스워드가 일치하지 않습니다.");
	    regForm.repasswd.focus();
	    return;
	}
	regForm.submit();
}

// 로그인
function funcLogin(){
	if(loginForm.id.value === ""){
		alert("회원 id 입력");
		loginForm.id.focus();
	}else if(loginForm.passwd.value === ""){
		alert("회원 비밀번호 입력");
		loginForm.passwd.focus();
	}else{
		loginForm.action = "loginproc.jsp";
		loginForm.method = "post";
		loginForm.submit();
	}
}

// 회원가입
function funcNewMember(){
	location.href = "register.jsp";
}


// 쇼핑몰 고객이 로그인 후 자신의 정보 수정
function memberUpdate(){
	// 입력자료 오류검사 ...
	
	document.updateForm.submit();
	
}


function memberUpdateCancel(){
	location.href = "../guest/guest_index.jsp";
}

function memberDelete(){
	alert("생략");
}