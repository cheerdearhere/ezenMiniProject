<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page session="false" %>
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
<title>Home</title>
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
		<h3>home페이지로 BS4, jQuery, AJAX, RWD를 이용하고 있습니다</h3>
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

<div class="container mt-1 border border-white">
	<!-- 캐러셀을 구현하는 콘테이너 클래스 carousel slide와 data-ride="carousel"속성이 필요 -->
	<div id="demo" class="carousel slide p-0" data-ride="carousel">
		<!-- 슬라이드의 위치를 표시하는 마커 엘리먼트는 ul을 이용,class="carousel-indicators"를 사용-->
		<!--data-target은 마커 위치,data-slide-to는 슬라이드 번호  -->
		<ul class="carousel-indicators">
			<li data-target="#demo" data-slide-to="0" class="active"></li>
			<li data-target="#demo" data-slide-to="1" ></li>
			<li data-target="#demo" data-slide-to="2" ></li>			
		</ul>
		<!--class="carousel-inner"는 스라이드 사진 포함하는 콘테이너  -->
		<!-- class="carousel-item"은 각각의 스라이드 사진을 나타내는 콘테이너로 이미지사진을 포함 -->
		<div class="carousel-inner">
			<div class="carousel-item active">
				 <img src="media/la.jpg" 
				 	alt="Los Angeles" />
				 <!-- img뒤에 carousel-caption클래스 콘테이너를 마들고 제목과 살명 추가 -->
				 <div class="carousel-caption">
			        <h3>Los Angeles</h3>
			        <p>We had such a great time in LA!</p>
			     </div>   	
			</div>
			<div class="carousel-item">
				 <img src="media/chicago.jpg" alt="Chicago" />
				 <div class="carousel-caption">
			        <h3>Chicago</h3>
			        <p>We had such a great time in LA!</p>
			     </div>    	
			</div>
			<div class="carousel-item">
				 <img src="media/ny.jpg" 
				 	 alt="New York" />
				  <div class="carousel-caption">
			        <h3>New York</h3>
			        <p>We had such a great time in LA!</p>
			     </div>   	
			</div>
		</div>
		
		<!-- 좌,우 콘트롤은 a를 사용하고 앞전으로 뒤로 가기를 처리 -->
		<a class="carousel-control-prev" href="#demo" data-slide="prev"> <!-- 앞전 -->
			<span class="carousel-control-prev-icon"></span> <!-- 아이콘처리 -->
		</a>
		<a class="carousel-control-next" href="#demo" data-slide="next"> <!-- 뒤 -->
			<span class="carousel-control-next-icon"></span> <!-- 아이콘처리 -->
		</a>
	</div>
</div>
<!-- ajax로 처리할때 나타낼 메인페이지 영역 -->
<div id="mainRegion" class="container mt-3">
	<div class="container" style="margin-top:30px">
		<div class="row">
			<div class="col-md-4">
				 <h2>About Me</h2>
				 <h5>Photo of me:</h5>
				 <div class="fakeimg">
				 	<img src="media/strawberry.png" style="width:100%;height:100%">
				 </div>
				 <p>Some text about me in culpa qui officia deserunt mollit anim..</p>
      			 <h3>Some Links</h3>
      			 <p>수직메뉴 만들기.</p>
      			 <ul class="nav nav-pills flex-column">
      			 	<li class="nav-item">
      			 		 <a class="nav-link active" href="#">Active</a>
      			 	</li>
      			 	<li class="nav-item">
      			 		<a class="nav-link" href="#">Link</a>
      			 	</li>
      			 	<li class="nav-item">
      			 		<a class="nav-link" href="#">Link</a>
      			 	</li>
      			 	<li class="nav-item">
      			 		<a class="nav-link" href="#">Link</a>
      			 	</li>
      			 </ul>
			</div>
			<div class="col-md-8">
				<h2>TITLE HEADING</h2>
				<h5>Title description, Dec 7, 2017</h5>
				<div class="fakeimg">
					<img src="media/beach.png" class="w-100 h-100"/>
				</div>
				<p>Some text..</p>
				<p>Some text.. Some text.. Some text..</p>  
				<br/>
				<h2>TITLE HEADING</h2>
				<h5>Title description, Dec 7, 2017</h5>
				<div class="fakeimg">
					<img src="media/Desert.png" class="w-100 h-100"/>
				</div>
				<p>Some text..</p>
				<p>Some text.. Some text.. Some text..</p>  
				<br/>
			</div>		
		</div>
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
</body>
</html>