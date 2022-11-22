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
<title>Insert</title>
<!--jquery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!--propper jquery -->
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<!--latest javascript -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<!--bootstrap-->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
<!--fontawesome icon-->
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
<!--google icon -->
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">

<style>
#searchPanel{
	width: 65%;
	position: relative;
	top: 60px;
	z-index: 5;
	padding: 5px;
	margin: auto;
	background-color: #FFFFFF;
}
#address {
	padding: 10px;
}
#googleMap{
	width: 100%;
	height: 600px;
	margin: 0;
	padding: 0;
}
</style>
</head>
<body>

<h3 class="text-center">Contacts</h3>
<div id="searchPanel"> <!-- 지도에서 주수로 위치를 찾는 위치 입력창 -->
	<input type="text"  id="address" placeholder="주소를 입력하세요" size="70px"/>
	<button id="submit" type="button" class="btn btn-primary" value="Geocode">지도 검색</button>
</div>
<div id="googleMap" class="mx-auto mb-5"></div>

<!-- 연락처 정보 -->
<div class="row">
	<div class="col-md-4 d-flex flex-column">
		<div class="d-flex flex-row">
			<div>
				<i class="fa fa-home" aria-hidden="true"></i>
				<!-- aria-hidden: 스크린 리더를 제한시키는 기능 on -->
			</div>
			<div>
				<h5>Binghamton, New York</h5>
				<p>4343 Hinkle Deegan Lake Road</p>
			</div>
		</div>
		<div class="d-flex flex-row">
			<div>
				<i class="fa fa-headphones" aria-hidden="true"></i>
			</div>
			<div> 
				<h5>00 (958) 9865 562</h5>
				<p>Mon to Fri 9 am to 6 pm
			</div>
		</div>
		<div class="d-flex flex-row">
			<div>
				<i class="fa fa-envelope" aria-hidden="true"></i>
			</div>
			<div>
				<h5>support@colorlib.com</h5>
				<p>Send us Your query anytime!</p>
			</div>
		</div>
	</div>
	<div class="col-md-8">
		<form class="text-right" id="myForm" action="" method="post">
			<div class="row">
				<div class="col-md-6 form-group">
					<input type="text" name="name" placeholder="Enter your name" onfocus="this.placeholder=''"
					onblur="this.placeholder='Enter your name'" class="mb-20 form-control"/>
					<input name="email" placeholder="Enter email address" pattern="[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{1,63}$"
					onfocus="this.placeholder=''" onblur="this.placeholder='Enter your email'"
					class="mb-20 form-control" type="email"/>
					<input name="subject" type="text" class="mb-20 form-control" 
					placeholder="Enter subject" onfocus="this.placeholder=''" onblur="this.placeholder='Enter subject'"/>
				</div>
				<div class="col-md-6 form-group">
					<textarea class="form-cotrol w-100" name="message" rows="5">
					</textarea>
				</div>
				<div class="col-md-12">
					<div style="text-align:left;"></div>
					<button class="btn btn-primary" style="float:right">send message</button>
				</div>
			</div>
		</form>
	</div>
</div>
<!-- 개발자가 구현하는 부분 -->
<script>
function initMap(){
	console.log('Map is initialized.');
	let map;//지도표시영역
	getLocation();
	function getLocation(){
		if(navigator.geolocation){
			//필요에 따라 method사용
			navigator.geolocation.watchPosition(showPosition);//위치변화를 반복해서 사용
		}
		else{
			map=$("#googleMap");
			map.text("Geolocation is not supported by this browser.");
		}
	}
	function showPosition(position){
		lati = position.coords.latitude;
		longi = position.coords.longitude;
		//지도표시용 객체
		map = new google.maps.Map(document.getElementById('googleMap'),{
			zoom:16,//배율
			center: new google.maps.LatLng(lati,longi)//지도의 중앙 위치 지정
		});
		//표시용 marker
		let marker = new google.maps.Marker({
			position: new google.maps.LatLng(lati,longi),
			map: map,//map 표시 객체
			title: 'Hello World'//마커에 붙는 글자
		});
	}
	let geocoder = new google.maps.Geocoder();
	document.getElementById('submit').addEventListener('click',function(){
		console.log('submit 버튼 클릭 이벤트 실행');
		geocodeAddress(geocoder, map);
	});
	function geocodeAddress(geocoder, resultMap){
		console.log('geocodeAddress 함수 실행');
		let address = document.getElementById('address').value;
		//필요에 따라 data를 EL문으로 입력해서 사용
		geocoder.geocode({'address':address},function(result,status){
			console.log(result);
			console.log(status);
			//주소에 마커를 지정, 지도 이동
			if(status === 'OK'){
				resultMap.setCenter(result[0].geometry.location);
				//geometry.location 주소에 의해 변경된 위치 값을 중앙으로 설정
				resultMap.setZoom(18);
				let marker = new google.maps.Marker({
					map: resultMap,
					position: result[0].geometry.location,
					title: 'Hello World'
				});
				console.log('latitude: ' + marker.position.lat());
				console.log('longitude: ' + marker.position.lng());
			}
			else{
				alert('geocode가 다음의 이유로 성공하지 못했습니다: ' + status);
			}
		});
	}
}
//async는 html parsing을 멈추고
//defer는 html parsing을 script 종료때까지 멈춤. 
//async defer 두개를 한번에 쓰면 백그라운드에서 다운로드를해서 html을 방해하지 않음. 
//https://maps.googleapis.com/maps/api/js?key=개인의고유키값&callback=콜백함수&v=weekly&channel=2

</script>
<!-- 구글의 map javascript api를 가져오는 부분 -->
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBJQLAdgFqD-x3wEGjfQrb7CuKYXpwGhXw&callback=initMap&v=weekly&channel=2">
</script>
</body>
</html>