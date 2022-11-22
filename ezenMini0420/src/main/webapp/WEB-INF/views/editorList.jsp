<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>   
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix ="sec" uri = "http://www.springframework.org/security/tags" %>
<%@ page session="false" %>              
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<!--RWD first-->
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<title>editorList</title>
</head>
<body>

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id" />		
</sec:authorize>

<h3 class="text-center threeDEffect text-info">Editor를 이용한 게시판</h3>
<a id="edUtil" href='util' class="btn btn-danger mb-3">처음으로</a>
<table id="edEditTable" class="table table-bordered table-hover">
	<thead>
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>제목</th>
			<th>작성일</th>			
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${editorList}" var="dto">
			<tr>
				<td class="eid">${dto.edId}</td>
				<td class="euser">${dto.edUser}</td>				
				<td>					
					<a class="edContView" href="edContView?edId=${dto.edId}">${dto.edTitle}</a>
				</td>
				<td>${dto.edDate}</td> <!-- Timestamp형의 문자열로 출력 -->				
		    </tr>
		</c:forEach>		
	</tbody>	
</table>

<script>
$(document).ready(function(){
	$("#edUtil").click(function(evnet){
		event.preventDefault();
		$.ajax({
			type : "get",
			url : "util",
			success : function(data) {
				$("#hjumbo").text("Utility페이지");				
		    	$("#mainRegion").html(data);	
			},
			error: function() {
				$("#mbody").text("서버접속 실패");
				$("#modal").trigger("click");	
			}	
		});
	});
	
	$(".edContView").click(function(event){		
		event.preventDefault();		
		let eTarget = $(event.target);
		$.ajax({
			url : eTarget.attr("href"),
			type : "get",
			success : function(data) {
				$("#hjumbo").text("Utility상세페이지");				
		    	$("#mainRegion").html(data);	
			},
			error: function() {
				$("#mbody").text("서버접속 실패!.");
				$("#modal").trigger("click");	
			}	
		});
	});
	
});
</script>
</body>
</html>