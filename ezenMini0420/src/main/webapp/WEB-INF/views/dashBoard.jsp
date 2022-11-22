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
<title>Insert Title</title>
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
</head>
<body>

<h3 class="text-center">Dash Board</h3>
<div class="mb-3">
	<a id="bar" href="bar" class="btn btn-primary">막대그래프</a>&emsp;
	<a id="pie" href="pie" class="btn btn-danger">pie그래프</a>&emsp;
	<a id="line" href="dash" class="btn btn-success">Line그래프</a>
	<a id="statis" href="statis" class="btn btn-info">통계작성</a>
</div>
<div>
	<canvas id="canvas" style="min-height:350px;border:1px solid gray;width:100%;"></canvas>
</div>

<script>
$(document).ready(function(){
	//데이터들의 소속을 표시할 배열
	let chartLabels = [];
	//차트로 표시할 데이터의 배열
	let chartData1 = [];
	let chartData2 = [];
	
	let lineChartData = {
		labels : chartLabels,//그래프의 x축에 들어갈 값
		datasets: [
			{
				label: "월별 PC 판매량", //x축 이름(label의 종류)
				fillColor: "rgba(220,220,220,0.2)",
				strokeColor: "rgba(220,220,220,1)",
				pointColor: "rgba(220,220,220,1)",
				pointStrokeColor: "#fff",
				pointHighlightFill: "#fff",
				pointHilightStroke: "rgba(220,220,220,1)",
				data: chartData1
			},
			{
				label: "월별 모니터 판매량", 
				fillColor: "rgba(151,187,205,0.2)",
				strokeColor: "rgba(151,187,205,1)",
				pointColor: "rgba(151,187,205,1)",
				pointStrokeColor: "#fff",
				pointHighlightFill: "#fff",
				pointHilightStroke: "rgba(151,187,205,1)",
				data: chartData2
			}
		]		
	};
	function createChart(){
		let ctx = document.getElementById("canvas").getContext("2d");//그림그리기 객체
		//Chart.Line(그릴대상element, {data:위에서지정, option:설정정보});
		//: Chart.js에서 제공하는 막대그래프를 그리는 메서드
		let LineChartDemo = Chart.Line(ctx,{
			data: lineChartData, // 사용할 데이터
			options: {
				scales: { //눈금표시
					yAxes: [//y축 눈금
						{
							ticks: {
								beginAtZero: true
							}
						}
					]
				}
			}
		});
	}
	$.ajax({
		url:"dashView",
		type:"post",
		data: { // 서버에서 getParameter로 처리
			cmd:'chart',
			subcmd:'line',
			${_csrf.parameterName}:"${_csrf.token}"
		},
		dataType: 'json',
		success: function(result){
			//jquery의 each()는 enhanced for문의 역할
			//result는 서버에서 JSONArray의 객체
			//result.datas는 배열형 객체(JSON Object), index는 색인번호, obj는 index의 객체
			$.each(result.datas, function(index, obj){
				chartLabels.push(obj.month); //배열의 마지막에 값을 넣는 push()
				chartData1.push(obj.pc);
				chartData2.push(obj.monitor);
			});
			createChart();
		},
		error: function(){
			$("#mbody").text("line: 서버접속 실패");
			$("#modal").trigger("click");
		}
	});
	$("#line").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#line").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("DashBoard: line 그래프");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("line 그래프: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#bar").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#bar").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("DashBoard: bar 그래프");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("bar 그래프: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#pie").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#pie").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("DashBoard: pie 그래프");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("pie 그래프: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#statis").click(function(event){
		event.preventDefault();		
		$.ajax({
			url : $("#statis").attr("href"),
			type : "get",
			data : "",
			success : function(data) {
				$("#hjumbo").text("통계 입력.");
				$("#mainRegion").html(data);
			},
			error : function() {
				$("#mbody").text("서버접속 실패!.");
				$("#modal").trigger("click");	
			}
		});
	});
});
</script>
</body>
</html>