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
<title> Title</title>
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
#googleMap {
width: 100%;
height: 100%;
margin: 0;
padding: 0;
}
</style>
</head>
<body>


<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id"/>
</sec:authorize>
<div class="row mt-5">
	<div class="col-md-4">
		<img src="upimage/${rDetails.rPhoto}" alt="사진" style="max-width:100%;height:400px" class="mx-auto img-resposive"/>	
	</div>
	<div class="col-md-4">
		<h3 class="text-center">${rDetails.rClass}</h3>
		<h3 class="text-center">${rDetails.rtrName}</h3>
		<h3 class="text-center">${rDetails.rTitle}</h3>
		<h3 class="text-center">${rDetails.rContent}</h3>
		<h3 class="text-center">${rDetails.rPrice}원</h3>
		<hr/>
		<form action="recipeorder" id="rOrder" method="post">
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
			<input type="hidden" name="rPid" value="${rDetails.rId}"/>
			<input type="hidden" name="rOuser" value="${user_id}"/>
			<input type="hidden" name="rOtitle" value="${rDetails.rTitle}"/>
			<input type="hidden" name="rOprice" value="${rDetails.rPrice}"/>
			<div class="form-group text-center">
				<h3>
					<label for="uOrder">주문수량</label>
					<input type="number" class="form-control w-50 mx-auto" id="uOrder" 
					name="rOquanty" placeholder="주문수량을 입력하세요" value="1" required/>
				</h3>
			</div>
			<div class="text-center">
				<button type="button" id="preOrder" class="btn btn-success">주문</button>&emsp;
				<button type="button" id="cartbtn" class="btn btn-light" onclick="stored()">
					<i class="fa fa-shopping-cart fa-2x" aria-hidden="true"></i>
				</button>
			</div>
			<div id="orderAdd" class="text-center d-none">
				<div class="form-group text-center">
					<label for="phonNo">전화번호</label>
					<input type="text" name="rOphoneNo" id="phoneNo" class="form-control w-50 mx-auto" placeholder="전화번호" required/>
				</div>
				<div class="form-group text-center">
					<label for="userAddr">배달 주소</label>
					<input type="text" name="rOuserAddr" id="userAddr" class="form-control w-50 mx-auto" required/>
				</div>
				<button type="submit" class="btn btn-primary">확인</button>
			</div>
		</form>
		<p class="text-center">
			<a href="main" class="btn btn-danger">목록으로</a>
		</p>
	</div>
	<div class="col-md-4">
		<h3 class="text-center">오시는 길</h3>
		<div id="googleMap" class="mb-2"></div>
		<div id="search-panel">
			<button id="mapBtn" type="button" class="btn btn-primary d-none" value="Geocode">위치</button>
		</div>
	</div>
</div>

<!-- google map 처리 -->
<script>
function initMap(){
	console.log('Map is initialized.');
	let map;
	let address = '<c:out value="${rDetails.rAddress}"></c:out>';
	getLocation();
	function getLocation(){
		if(navigator.geolocation){
			navigator.geolocation.getCurrentPosition(showPosition);
		}
		else{
			map=$("#googleMap");
			map.text("Geolocation is not supported by this browser.");
		}
	}

	$("#mapBtn").click(function(){
		console.log('mapBtn 버튼 클릭');
		let geocoder = new google.maps.Geocoder();
		geocodeAddress(geocoder, map);
	});
	
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
		
		$("#mapBtn").trigger("click");
	}
	let geocoder = new google.maps.Geocoder();
	
	function geocodeAddress(geocoder, resultMap){
		console.log('geocodeAddress 함수 실행');
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
</script>
<!-- 구글의 map javascript api를 가져오는 부분 -->
<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBJQLAdgFqD-x3wEGjfQrb7CuKYXpwGhXw&callback=initMap&v=weekly&channel=2">
</script>

<!-- local storage로 장바구니 처리 -->
<script>
function stored(){
	if(typeof(Storage)=="undefined"){
		return;
	}
	//localStorage.clear();//임시로 시험 가동때마다 삭제
	//중간에 삭제되는 키값에 대비한 maxKeyValue. 연산을 위해 int로 변환
	let maxKeyValue = 0;
	let keyValue;
	for(let i=0 ; i<localStorage.length ; i++){
		keyName = localStorage.key(i);//키값
		if(parseInt(keyName) > maxKeyValue) {
			maxKeyValue = parseInt(keyName);//keyName은 문자열
			keyValue = maxKeyValue;
		}
	}
	
	keyValue = maxKeyValue + 1;
	//입력받은 값 사용
	let orderQty = $("#uOrder").val();
	//입력값이 없거나 잘못된 경우
	if(parseInt(orderQty) < 1){
		alert("주문 수량을 입력하세요");
		return;
	}
	//객체형 데이터 key : "value"
	let recipeValue = {
		rId: "${rDetails.rId}",
		rClass: "${rDetails.rClass}",
		rtrName: "${rDetails.rtrName}",
		rTitle: "${rDetails.rTitle}",
		rPrice: "${rDetails.rPrice}",
		rContent: "${rDetails.rContent}",
		rPhoto: "upimage/"+"${rDetails.rPhoto}",
		rQty: orderQty
	}
	
	//javascript 객체형으로 입력한 내용을 JSON 문자열로전환해 local storage에 입력
	localStorage.setItem(keyValue, JSON.stringify(recipeValue));
	
	$.ajax({
		url: "recipeCart",
		type: "get",
		data: "",
		success: function(data){
			$("#hjumbo").text("장바구니입니다.");
			$("#mainRegion").html(data);
		},
		error: function(){
			$("#mbody").text("장바구니: 서버 접속 실패!");
			$("#modal").trigger("click");
		}
	});
}
</script>

<!-- 주문 관련 -->
<script>
$("#preOrder").click(function(){
	let orderQty = $("#uOrder").val();//form에서 입력값은 모두 문자열
	//수량 입력 요청
	if(parseInt(orderQty) < 1){
		alert("주문 수량을 입력하세요");
		return;
	}
	//element의 class를 삭제
	$("#orderAdd").removeClass("d-none");
	//d-none을 삭제하여 숨겼던 주문 상세 창을 보여줌
});
$("#rOrder").submit(function(e){
	e.preventDefault();
	$.ajax({
		url: $("#rOrder").attr("action"),
		type: "post",
		data: $("#rOrder").serialize(),
		success: function(data){
			$("#hjumbo").text("주문 요청");
			$("#mainRegion").html(data);
		},
		error: function(){
			$("#mbody").text("주문 전달: 서버 접속 실패!");
			$("#modal").trigger("click");
		}
	});
});
</script>
</body>
</html>