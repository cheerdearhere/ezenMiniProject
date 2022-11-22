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
</head>
<body>

<h3 class="text-center mb-3">Server-Sent Event</h3>
<button type="button" class="btn btn-primary"id="sebtn">싱글 이벤트</button> &emsp;
<button type="button" class="btn btn-success" id="mebtn">멀티이벤트</button>&emsp; 
<hr/>
<h4 class="text-center mb-3">싱글 Server-Sent Event 내용(data)</h4>
<div id="sseDisp1" class="text-center mb-3"></div> <!-- 싱글 -->
<h4 class="text-center mb-3">멀티 Server-Sent Event 내용(data) 1</h4>
<div id="sseDisp2" class="text-center mb-3"></div> <!-- 멀티1 -->
<h4 class="text-center mb-3">멀티 Server-Sent Event 내용(data) 2</h4>
<div id="sseDisp3" class="text-center mb-3"></div> <!-- 멀티2 -->

<script>
$(document).ready(function(){
	$("#sebtn").click(function(){
		//이벤트를 받기위한 이벤트 소스 객체
		let eventSource = new EventSource("seventEx");//seventEx는 controller의 경로
		eventSource.onmessage = function(event){
		//서버에 업데이트 될때마다 message 이벤트 발생
		//event객체는 서버의 이벤트 내용 객체
			$("#sseDisp1").text(event.data);//event객체에 업데이트된 data가 실려온 것을 출력
		}
	});
	//멀티이벤트
	$("#mebtn").click(function(){
		let eventSource = new EventSource("meventEx");
		//(upvote는 서버에서 정한 이벤트 이름, 이벤트 처리 함수, false는 캡쳐링으로 fals는 버블링 방식 사용 표시)
		eventSource.addEventListener("upVote",function(event){
			$("#sseDisp2").text(event.data);
		},false);
		eventSource.addEventListener("downVote",function(event){
			$("#sseDisp3").text(event.data);
		},false);
	});
});
</script>
</body>
</html>