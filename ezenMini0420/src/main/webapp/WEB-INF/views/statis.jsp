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

<h3 class="text-center multiEffect">통계작성</h3>	
<form id="statisFrm" name="statisFrm" method="post" action="statisWrite">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<div class="form-group">
			<label for="uMonth">년-월</label>
			<input type="month" class="form-control" name="month"  id="uMonth" required/>			
		</div>
		<div class="form-group">
			<label for="uPc">PC판매량</label>
			<input type="number" class="form-control" name="pcQty" id="uPc"	placeholder="PC판매량" required/>
		</div>
		<div class="form-group">
			<label for="uMc">모니터판매량</label>
			<input type="number" class="form-control" name="monitorQty" id="uMc"	placeholder="모니터판매량" required/>
		</div>		
		<button type="submit" class="btn btn-success">저장</button>&nbsp;&nbsp;&nbsp;	
</form>
<script>
$(document).ready(function(){
	$("#statisFrm").submit(function(event){
		event.preventDefault();
		$.ajax({
			url : $("#statisFrm").attr("action"),
			type : $("#statisFrm").attr("method"),
			data : $("#statisFrm").serialize(),
			success : function(data){
				$("#hjumbo").text("DashBoard페이지 입니다.");
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