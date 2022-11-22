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
<title>full calendar</title>
<!--jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--propper jquery -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!--latest javascript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<!--bootstrap-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!-- full calendar용 api 라이브러리 -->
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.2/main.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@5.11.2/main.min.css' rel='stylesheet'/>
<!--fontawesome icon-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
<!--google icon -->
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
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
<body>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="userId"/>
</sec:authorize>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

<div class="container mt-1 p-0">
	<div class="jumbotron text-center mb-0 p-4">
		<h3 id="hjumbo">Full Calendar api를 사용한 스캐쥴러로 spring security 서버와 연동되고 있습니다</h3>
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
				<a class="nav-link" href="dash">DashBoard</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="util" id="mUtil">Utils</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="about">About...</a>
			</li>
			<sec:authorize access="isAnonymous()">
				<li class="nav-item">
					<a class="nav-link" href="joinView" id="joinView">회원가입</a>				
				</li>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
				<li class="nav-item">
					<a class="nav-link" href="#">${userId}</a>
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

<div id="mainRegion" class="container mt-5 p-0">
	<div id="calendar"></div><!-- full calendar 표시 영역 -->
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
let calendar = null;
//let user_id = "${userId}";
let user_id = '<c:out value="${userId}"></c:out>';
$(document).ready(function(){
	$(function(){//jQuery 자동 실행함수
		let request = $.ajax({//calendar로 요청한 결과를 저장하는 변수 request
			url: "calendar?cId=${userId}",
			type: "get",
			dataType:"json"
		});//controller에 request를 보낸 후 다음을 수행
		request.done(function(data){
		//request 수행 마지막 작업 처리(=complete)
			console.log(data);//data는 javascript 객체 배열
			let calendarEl = document.getElementById('calendar');
			//calendar를 표시할 div element
			calendar = new FullCalendar.Calendar(calendarEl,{
				timeZone : "Asia/Seoul",//적용 타임존
				headerToolbar: {//calendar 위의 조작버튼
					left: 'prev, next today',
					center: 'title',
					right:'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
				},
				navLink: true,//활성화할 기능들
				editable: true,
				selectable: true,
				droppable: true,
				eventDrop: function(info) {//일정 정보 dropdown
					let obj = new Object();
					//confirm창의 입력값에 따라 boolean결정
					if(confirm("'"+info.event.title+"'의 일정을 수정하시겠습니까?")){
						obj.cTitle = info.event._def.title;
						obj.cStart = info.event._instance.range.start;
                		obj.cEnd = info.event._instance.range.end;
                		obj.cAllDay = info.event._instance.range.allDay;
						//cNo: fullcalendar DB에 입력될 번호(PK)
                		obj.cNo = info.event.extendedProps.cNo;
                		obj.cId = user_id; //사용자 아이디
               			obj.oldTitle = info.oldEvent._def.title;
               			obj.oldStart = info.oldEvent._instance.range.start;
               			obj.oldEnd = info.oldEvent._instance.range.end;
               			obj.oldAllDay = info.oldEvent._instance.range.allDay;
               			console.log(obj);
						$(function modifyData(){
							$.ajax({
								url: "calendarUpdate",
								type: "post",
								dataType: "json",
								data: JSON.stringify(obj),
								contentType: 'application/json',
								//보안을 위한 Xml Http Request 객체(xhr)를 보내기전 헤더에 삽입
								beforeSend: function(xhr){
									xhr.setRequestHeader('X-CSRF-Token',$('input[name="${_csrf.parameterName}"]').val());
								}
							});
						});
					}
					else{
						info.revert();//false일때 원래화면
					}
					calendar.unselect();//선택 없이 첫화면
					location.reloard();//완료 후 다시 로드
				},
				eventResize: function(info){//일정 크기 조절
					console.log(info);
					let obj = new Object();
					if(confirm("'" + info.event.title + "'의 일정을 수정하시겠습니까?")){
						obj.cTitle = info.event._def.title;
						obj.cStart = info.event._instance.range.start;
                		obj.cEnd = info.event._instance.range.end;
                		obj.cAllDay = info.event._instance.range.allDay;
                		obj.cNo = info.event.extendedProps.cNo;
                		obj.cId = user_id;
               			obj.oldTitle = info.oldEvent._def.title;
               			obj.oldStart = info.oldEvent._instance.range.start;
               			obj.oldEnd = info.oldEvent._instance.range.end;
               			obj.oldAllDay = info.oldEvent._instance.range.allDay;
						console.log(obj);
						$(function modifyData(){
							$.ajax({
								url: "calendarUpdate",
								type: "post",
								dataType: "json",
								data: JSON.stringify(obj),
								contentType: 'application/json',
								//보안을 위한 Xml Http Request 객체(xhr)를 보내기전 헤더에 삽입
								beforeSend: function(xhr){
									xhr.setRequestHeader('X-CSRF-Token',$('input[name="${_csrf.parameterName}"]').val());
								}
							});
						});
					}
					else{
						info.revert();
					}
					calendar.unselect();
					location.reload();
				},
				select: function(arg) {//insert 기능
					var title = prompt('일정이름을 적고 시간을 선택하세요.');
					if(title){
						calendar.addEvent({
							title: title,//입력받은 title을 title속성에 입력
							start: arg.start,//입력받은 매개변수의 인자
							end: arg.end,
							allDay: arg.allDay
						});
						console.log(arg);
						var obj = new Object();
						obj.cNo = 100;//값은 DB에서 seq으로 지정하므로 의미는 없음
						obj.cId = user_id;
						obj.cTitle = title;
						obj.cStart = arg.start;
						obj.cEnd = arg.end;
						//allDay는 boolean으로 DB에 입력할 수 없다. String으로 변환해 입력
						if(arg.allDay == true) {
							obj.cAllDay = "true";
						}
						else{
							obj.cAllDay = "false";
						}
						console.log(obj);
						$(function saveData(){
							$.ajax({
								url: "calendarInsert",
								type: "post",
								dataType: "json",
								data: JSON.stringify(obj),
								contentType: 'application/json',
								//보안을 위한 Xml Http Request 객체(xhr)를 보내기전 헤더에 삽입
								beforeSend: function(xhr){
									xhr.setRequestHeader('X-CSRF-Token',$('input[name="${_csrf.parameterName}"]').val());
								}
							});
						});
					}
					else {
						info.revert();						
					}
					calendar.unselect();
					location.reload();
				},
				//일정을 클릭하여 일정을 제거(delete) 기능
				eventClick: function(info){
					console.log(info);
					if(confirm("'" + info.event.title + "'의 일정을 삭제하시겠습니까?")) {
						info.event.remove();
						console.log(info.event);
						var obj = new Object();
						obj.cTitle = info.event._def.title;
						obj.cStart = info.event._instance.range.start;
                		obj.cEnd = info.event._instance.range.end;
                		obj.cId = user_id;
                		obj.cNo = info.event.extendedProps.cNo;
						$(function deleteData(){
							$.ajax({
								url: "calendarDelete",
								type: "post",
								dataType: "json",
								data: JSON.stringify(obj),
								contentType: 'application/json',
								beforeSend: function(xhr){
									xhr.setRequestHeader('X-CSRF-Token',$('input[name="${_csrf.parameterName}"]').val());
								}
							});
						});
					}
					else{
						info.revert();
					}
					calendar.unselect();
					location.reload();
				},
				locale: 'ko',//지역
				events: data//전달받은 결과값(javascript object 배열)을 저장하는 객체
			});
			calendar.render();//받은 data로 calendar 랜더링
		});
	});
});
</script>
</body>
</html>