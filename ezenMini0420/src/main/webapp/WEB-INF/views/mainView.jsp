<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
<title>main</title>
<!--jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--propper jquery -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!--latest javascript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<!-- 그래픽 처리용 Chart.js API 라이브러리 추가 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.js"></script>
<!--bootstrap-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!--fontawesome icon-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
<!--google icon -->
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<!-- Chart.js API -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.min.js"></script>
<!-- CKEditor API -->
<script src="https://cdn.ckeditor.com/ckeditor5/30.0.0/decoupled-document/ckeditor.js"></script> 
<script src="https://ckeditor.com/apps/ckfinder/3.5.0/ckfinder.js"></script>
<link rel="stylesheet" href="assets/content-styles.css" type="text/css">

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

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id"/>
</sec:authorize>
<div class="container mt-1 p-0">
	<div class="jumbotron text-center mb-0 p-4">
		<h3 id="hjumbo">home페이지로 BS4, jQuery, AJAX, RWD를 이용하고 있습니다</h3>
	</div>
</div>
<nav class="navbar navbar-expand-md bg-dark navbar-dark container sticky-top font-weight-bold">
	<a class="navbar-brand" href="home">
		<img alt="Logo" src="images/bird.jpg" style="width: 40px;">
	</a>
	<!-- collapsible navbar button -->
	<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
		<span class="navbar-toggler-icon"></span>
	</button>
	<div class="collapse navbar-collapse" id="collapsibleNavbar">
		<ul class="navbar-nav">
			<li class="nav-item">
				<a class="nav-link" href="mHome" id="mHome">
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
					<a class="dropdown-item" id="eBoard" href="eBoard">게시판</a>
					<a class="dropdown-item" href="qna">QnA</a>
				</div>
			</li>
			<li class="nav-item">
				<a id="dashBoard" class="nav-link" href="dash">DashBoard</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="util" id="mUtil">Utils</a>
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
			<!-- auth가 ROLE_ADMIN일때 -->
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
	<a id="rwriteView" class="btn btn-success" href="rwriteView">레시피 등록</a>
	<a id="recipeCart" class="btn btn-info" href="recipeCart">장바구니 보기</a>
	<a id="recipeorderView" class="btn btn-info" href="recipeorderView?rOuser=${user_id}">주문내역 보기</a>
	<h3 class="text-center text-info">레시피</h3>
	<div class="row mb-3">
		<c:forEach items="${recipeList}" var="dto">
			<div class="col-md-4" style="hight:auto;">
				<div class="card" style="width:300px">
					<h5>${dto.rClass}</h5><!-- 요리구분 -->
					<img class="card-img-top" src="upimage/${dto.rPhoto}" alt="image" style="max-width:280px;height:280px;"/>
					<div class="card-body">
						<h5 class="card-title">식당명: ${dto.rtrName}</h5>
						<h5 class="card-text">요리명: ${dto.rTitle}</h5>
						<h5 class="cart-text">가격: ${dto.rPrice}</h5>
						<a href="recipeDetails?rId=${dto.rId}" class="pclick btn btn-primary stretched-link">
							자세히 보기
						</a>
					</div>
				</div>
			</div>
		</c:forEach>
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
	//recipe 등록
	$("#rwriteView").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "rwriteView",
			type: "get",
			data: "",
			success: function(data){
				$("#hjumbo").text("레시피 등록");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("recipe 등록: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	//자세히보기 등록(recipeDetails)
	$(".pclick").click(function(event){
		//pclick class로 등록된 객체들(반복 출력되는 카드들)
		event.preventDefault();
		let evo = $(event.target);
		//pclick class로 등록된 객체들(반복 출력되는 카드들) 중 이벤트를 발생한 객체를 대상으로 실행
		let url = evo.attr("href");
		$.ajax({
			url: url,
			type: "get",
			data: "",
			success: function(data){
				$("#hjumbo").text("상세 페이지");
				$("#mainRegion").html(data);	
			},
			error: function(){
				$("#mbody").text("recipe details: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#adminView").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "adminView",
			type: "get",
			data: "",
			success: function(data){
				$("#hjumbo").text("admin 등록");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("admin 등록: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#mHome").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "mHome",
			type: "get",
			data: "",
			success: function(data){
				$("#hjumbo").text("mHome 이동");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("mHome 요청: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});		
	});
	$("#eBoard").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#eBoard").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("Main내부의 게시판");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("게시판: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#mUtil").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#mUtil").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("Utility 모음입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("utils: 서버 접속 실패");
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
	$("#dashBoard").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#dashBoard").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("DashBoard 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("dash board: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#recipeCart").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#recipeCart").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("장바구니 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("장바구니: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	
	$("#recipeorderView").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#recipeorderView").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("주문내역 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("주문목록: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});

});
</script>

<script>
history.pushState(null, document.title, location.href);
window.addEventListener('popstate', function(event) {
    history.pushState(null, document.title, location.href); 
});
</script>

</body>
</html>

<!-- 
[Spring] 동시 접속자 수 계산해주는 Listener 객체
https://jeaha.dev/121
 -->