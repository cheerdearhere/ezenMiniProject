<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<!-- RWD -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- MS -->
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,IE=EmulateIE9"/> 
<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
<title>Insert</title>
<!--bootstrap-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!--jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--propper jquery -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!--latest javascript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<!--fontawesome icon-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
<!--google icon -->
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<style>
html, body{
	height: 100%;
	margin: 0;
	padding: 0;
}
.navbar {
	border-radius:0px;
	margin-bottom:0px;
}
.carousel-inner img {
	/*RWD를 위해 처리 */
	width: 100%;
	height : 100%;
}
#mainRegion{
	height:auto;
}
</style>
</head>
<body>

<!-- 권한을 획득했을때 유저의 id를 표시 -->
<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id"/>
</sec:authorize>

<div class="container mt-1 p-0">
	<div class="jumbotron text-center mb-0 p-4">
		<h3 id="hjumbo">home페이지로 BS4, jQuery, AJAX, RWD를 이용하고 있습니다</h3>
	</div>
</div>

<nav class="navbar navbar-expand-md bg-dark navbar-dark container sticky-top font-weight-bold">
	<a class="navbar-brand" href="#">
		<img alt="Logo" src="images/bird.jpg" style="width: 40px;">
	</a>
	<!-- collapsible navbar button -->
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" href="home">
					<i class="fas fa-home" style="font-size:30px;color:white;"></i>
				</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="place">Hot Place</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="main">Hot Recipe</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="pet">애완동물</a>
			</li>
			<li class="nav-item dropdown">
				<a class="nav-link dropdown-toggle" href="#" id="navbardrop" data-toggle="dropdown">
					알림판
				</a>
				<div class="dropdown-menu">
					<a class="dropdown-item" href="notice">공지사항</a>
					<a class="dropdown-item" href="board">게시판</a>
					<a class="dropdown-item" href="qna">QnA</a>
				</div>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="dash">DashBoard</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="util">Utils</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="about" id="about">About...</a>
			</li>
			<sec:authorize access="isAnonymous()">
				<li class="nav-item">
					<a class="nav-link" href="joinView" id="joinView">회원가입</a>				
				</li>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<li class="nav-item">
					<a class="nav-link" href="#">${user_id}</a>
				</li>
			</sec:authorize>
			<sec:authorize access="hasRole('ROLE_ADMIN')">
				<li class="nav-item">
					<a id="adminView" class="nav-link" href="adminView">admin</a>
				</li>
			</sec:authorize>
		</ul>
		<!-- 획득한 권한에 따라 로그인과 로그아웃 버튼을 생성함 -->
		<ul class="navbar-nav ml-auto">
			<sec:authorize access="isAnonymous()">
				<li class="nav-item">
					<a class="nav-link" href="loginView">로그인</a>
				</li>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<li class="nav-item">
					<a class="nav-link" href="logoutView">로그아웃</a>
				</li>
			</sec:authorize>
		</ul>
	</div>
</nav>

<!-- ajax로 처리할때 나타낼 메인페이지 영역 -->
<div id="mainRegion" class="container mt-3">
	<h3 id="loginfo"></h3>
	<h3 class="text-center text-info">로그인</h3>
	<!-- 로그인 관련 메세지를 서버에서 받아 작성할 공간 -->
	<div id="div1" class="text-success"></div>
	<form id="frm1" name="frm1" method="post" action="login">
	<!-- security에서 action을 기본설정(login)으로 하면 controller가 아닌 
	security-context의 form-login(login-processing-url:"/login")에서 request를 처리함 -->
		<!--csrf를 방지하기위한 헤더부분을 숨겨서 추가(head의 ms부에도 관련 추가)/ 
		파일업로드를 사용하기위해 페이지에서 처리(안쓰면 security-context.xml에서 csrf disabled를 true)-->
		<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<div class="form-group">
			<input type="email" class="form-control" name="pid" id="uId" placeholder="E-mail 주소 입력" required/>
		</div>
		<div class="form-group">
			<input type="password" class="form-control" name="ppw" id="uPw" placeholder="비밀번호 입력" required/>
		</div>
		<div class="form-group form-check">
			<input type="checkbox" class="form-check-input" id="remeberMe" name="remember-me" checked/>
			<label class="form-check-label" for="rememberMe" aria-describedby="rememberMeHelp">remember-me</label>
			<!-- aria-describedby는 스크린 리더에서 설명할 내용 -->
		</div> 
			<button type="submit" class="btn btn-success">로그인</button> &emsp;
<!-- 	<a href="joinView" class="btn btn-danger">회원가입</a> -->
	</form>
	<!-- oau 인증방식 사용 -->
	<div class="d-flex mt-4">
		<a id="klog" href="${kakao_url}" class="btn btn-light">
			<img width="130" src="images/kakao_login_large_narrow.png"/>
		</a>&nbsp;
		<a id="nlog" href="${naver_url}" class="btn btn-light">
			<img width="130" src="images/naverid_login_button_short.png"/>
		</a>&nbsp;
		<a id="glog" href="${google_url}" class="btn btn-light">
			<img width="130" src="images/btn_google_signin.png"/>
		</a>
	</div>
</div>

<!-- footer 영역 -->
<footer class="container mt-5 p-0">
	<div class="jumbotron text-center mb-0 p-4">
		<h3 class="text-center treeDEffect">Online Stroe Copyright</h3>
		<form action="#" method="post">
			<div class="form-group">
				<label for="email">&emsp;주문 문의</label>
				<input type="email" class="form-control" id="email" placeholder="Enter email"/>
			</div>
			<button type="submit" class="btn btn-danger">Sign Up</button>
		</form>
	</div>
</footer>

<!-- modal -->
<button id="modal" type="button" class="btn btn-primary d-none" data-toggle="modal" data-target="#myModal">
	Open modal
</button>
<div class="modal fade" id="myModal">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header bg-info">
				<h4 class="modal-title">
					<i class="fa fa-info-circle" aria-hidden="true">Info</i>
				</h4>
				<button type="button" class="close mclose" data-dismiss="modal">&times;</button>
			</div>
			<div class="modal-body">
				<h4 id="mbody" class="text-center">가입을 축하합니다.</h4>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary mclose" data-dismiss="modal">Close</button>
			</div>
		</div>
	</div>
</div>
<script>
$(document).ready(function(){
	//server언어인 jstl을 client인 script에서 사용해서 data를 가져와 쓸 수 있음
	//java > jstl > html > javascript순으로 언어 컴파일되어 우선 처리된 후 javascript가 사용
	//EL문을 바로쓸수도 있지만 jstl로 처리 후 진행하는 것도 좋음
	<c:choose>
		<c:when test="${not empty log}">
			$("#loginfo").text("welcome");
		</c:when>
		<c:when test="${not empty logout}">
			$("#loginfo").text("logout 성공");
		</c:when>
		<c:when test="${not empty error}">
			$("#loginfo").text("login 실패");
		</c:when>
		<c:otherwise>
			$("#loginfo").text("welcome");
		</c:otherwise>
	</c:choose>
	
	$("#joinView").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#joinView").attr("href"),
			type: "get",
			data: "",
			//resopose로 받은 data(jsp)를 해당 element에 전달
			//page는 바뀌지 않고 내용만 바뀜.
			success: function(data){
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#about").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#about").attr("href"),
			type: "get",
			data: "",
			//resopose로 받은 data(jsp)를 해당 element에 전달
			//page는 바뀌지 않고 내용만 바뀜.
			success: function(data){
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("회사 정보창");
				$("#modal").trigger("click");
			}
		});
	});

});
</script>

<!-- back방지 -->

<!--
<script>
history.pushState(null, null,location.href); 
window.addEventListener('popstate', function(event) {
    history.pushState(null, null, location.href); 	 
});
</script>
 -->
<script>
window.history.forward();
function noBack() {
	window.history.forward();
}
</script>

</body>
</html>