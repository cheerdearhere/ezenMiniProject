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

<h3 class="text-center">Dash Board(bar)</h3>
<div class="mb-3">
	<a id="bar" href="bar" class="btn btn-primary">막대그래프</a>&emsp;
	<a id="pie" href="pie" class="btn btn-danger">pie그래프</a>&emsp;
	<a id="line" href="dash" class="btn btn-success">Line그래프</a>
</div>
<div>
	<canvas id="canvas" style="min-height:350px;border:1px solid gray;width:100%;"></canvas>
</div>

<script>
$(document).ready(function(){
	//LineChart와 거의 같음
	let chartLabels = [];
	let chartData1 = [];
	let chartData2 = [];
	//그래픽에서 사용하려는 데이터와 설정
	let barChartData = {
			labels : chartLabels,//그래프의 기본축(x or y)에서 사용할 값
			datasets: [
				{
					label: "월별 PC 판매량", //x축 이름(label의 종류)
					fillColor: "rgba(220,220,220,0.2)",
					strokeColor: "rgba(220,220,220,1)",
					pointColor: "rgba(220,220,220,1)",
					pointStrokeColor: "#fff",
					pointHighlightFill: "#fff",
					pointHilightStroke: "rgba(220,220,220,1)",
					data: chartData1,
					//막대그래프의 색지정(한 화면에 4개씩만)
					backgroundColor: [
						"#FF6384",
						"#FF6384",
						"#FF6384",
						"#FF6384"
						]
				},
				{
					label: "월별 모니터 판매량", 
					fillColor: "rgba(151,187,205,0.2)",
					strokeColor: "rgba(151,187,205,1)",
					pointColor: "rgba(151,187,205,1)",
					pointStrokeColor: "#fff",
					pointHighlightFill: "#fff",
					pointHilightStroke: "rgba(151,187,205,1)",
					data: chartData2,
					backgroundColor: [
						"#36A2EB",
						"#36A2EB",
						"#36A2EB",
						"#36A2EB"
					]
				}
			]		
		};
	function createChart(){
		let ctx = document.getElementById("canvas").getContext("2d");
		new Chart(ctx,{//line은 Chart.line
			type: 'horizontalBar',//수평 막대그래프: xAxes 사용
			//type: 'bar', //수직 막대그래프 : yAxes사용
			data: barChartData,
			options: {
				scales: {
					xAxes:[
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
		data: {
			cmd : 'chart',
			subcmd : 'line',
			${_csrf.parameterName} : "${_csrf.token}"
		},
		dataType: 'json',
		success: function(result){
			$.each(result.datas, function(index, obj){
				chartLabels.push(obj.month);
				chartData1.push(obj.pc);
				chartData2.push(obj.monitor);
			});
			createChart();
		},
		error: function(){
			$("#mbody").text("bar: 서버접속 실패");
			$("#modal").trigger("click");
		}
	});
});
</script>
</body>
</html>