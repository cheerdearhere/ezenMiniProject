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
	<h3 class="text-center text-danger">게시판</h3>
	<table id="searchTable" class="table table-bordered table-hover">
		<thead>
			<tr>
				<th>번호</th>
				<th>작성자</th>
				<th>제목</th>
				<th>작성일</th>
				<th>히트수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${listContent}" var="dto">
				<tr>
					<td class="bid">${dto.bId}</td>
					<td>${dto.bName}</td><!-- user id -->
					<td>
						<c:forEach begin="1" end="${dto.bIndent}">-</c:forEach>
						<a class="contentView" href="contentView?bId=${dto.bId}">
							${dto.bTitle}
						</a>
					</td>
					<td>${dto.bDate}</td>
					<td>${dto.bHit}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
<script>
$(document).ready(function(){
	//내용보기
	$("a.contentView").click(function(event){
		event.preventDefault();
		let ceo = $(event.target);
		$.ajax({
			url: ceo.attr("href"),
			type: "get",
			data: "",
			success: function(data){
				$("#hjumbo").text("게시글 내용 보기.");
				$("#mainRegion").html(data);	
			},
			error: function(){
				$("#mbody").text("contentView: 서버 접속 실패");
				$("#modal").trigger("click");
			}			
		});
	});
});
</script>
</body>
</html>