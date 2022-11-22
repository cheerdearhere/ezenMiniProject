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
<title>file convert</title>
<!--jquery 오류로 주석처리
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>-->
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
<!-- JS PDF -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/1.5.3/jspdf.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.2.11/jspdf.plugin.autotable.min.js"></script>
<!-- tableHTMLExport -->
<script src="js/tableHTMLExport.js"></script>
<!-- HTML to canvas -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js"></script>
</head>
<body>

<!-- 테이블을 PDF,CSV(엑셀), JSON파일 형태로 변환 -->
<h3 class="text-center text-info mt-2 mb-5">jQuery TableHTMLExport Plugin Examples</h3>
<table class="table table-bordered table-hover" id="example">
	<thead class="thead-dark">
		<tr>
			<th scope="col">#</th><!-- scope는 시각장애인을 위한 인식방식 -->
			<th scope="col">First</th>
			<th scope="col">Last</th>
			<th scope="col">Handle</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<th scope="row">1</th>
			<td>국현섭</td>
			<td>Otto</td>
			<td>@mdo</td>
		</tr>
		<tr>
			<th scope="row">2</th>
   			<td>Jacob</td>
   			<td>Thornton</td>
   			<td>@fat</td>
		</tr>
		<tr>
			<th scope="row">3</th>
			<td>김영희</td>
			<td>Otto</td>
			<td>@mdo</td>				
		</tr>
		<tr>
			<th scope="row">4</th>
   			<td>Smith</td>
   			<td>Thornton</td>
   			<td>@fat</td>
		</tr>
		<tr>
			<th scope="row">5</th>
			<td>국현섭</td>
			<td>Otto</td>
			<td>@mdo</td>				
		</tr>
		<tr>
			<th scope="row">6</th>
   			<td>Jacob</td>
   			<td>Thornton</td>
   			<td>@fat</td>
		</tr>
		<tr>
			<th scope="row">7</th>
			<td>김영희</td>
			<td>Otto</td>
			<td>@mdo</td>				
		</tr>
		<tr>
			<th scope="row">8</th>
   			<td>Smith</td>
   			<td>Thornton</td>
   			<td>@fat</td>
		</tr>
	</tbody>
</table>
<p class="lead mt-5"><!-- .lead: BS4의 class로 p의 글자크기와 라인 간격을 증가시킴-->
	<button id="json" class="btn btn-primary">TO JSON</button>
	<button id="csv" class="btn btn-info">TO CSV</button>
	<button id="pdf" class="btn btn-danger">TO PDF</button>
	<button id="print" class="btn btn-success" onclick=" window.print()">전체화면 인쇄</button>
</p>

<script>
$(document).ready(function(){
	//변환버튼과 tableHTMLExport 연결
	$("#json").on("click",function(){
		$("#example").tableHTMLExport({
			type:'json',//json
			filename:'sample.json'
		});
	});
	$("#csv").on("click",function(){
		$("#example").tableHTMLExport({
			type:'csv',//스프레드시트
			filename:'sample.csv'
		});
	});
	/*pdf변환은 그대로 사용하면 한글지원을 안함
	$("#pdf").on("click",function(){
		$("#example").tableHTMLExport({
			type: 'pdf',
			filename:'sample.pdf'
		});
	});
	*/
	$("#pdf").on("click", function(){
		//selector를 기준으로 해당 화면을 canvas개체로 입력
		html2canvas(document.getElementById("example"),{
			//객체형으로 canvas를 받음
			onrendered:function(canvas){
				//toDataURL(이미지MIME 타입): 이미지를 문자열 데이터화함
				var imgData=canvas.toDataURL('images/png');
				console.log('Report imageURL: ' + imgData);
				//jsPDF(첫화면(default: portrait),단위(mm, cm...),크기(a4, [가로,세로]))
				var doc = new jsPDF('p','mm',[297,210]);
				//addImage(이미지 문자열 데이터, 파일유형, 시작x,시작y,종료x,종료y);
				doc.addImage(imgData,'PNG',5,5,55,20);
				doc.save('sample.pdf');//저장
			}//jsPDF를 text로 받을 수 있지만 한글이 깨짐. text로 받을때는 font처리후 진행
		});
	});
});
</script>
</body>
</html>