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

<h3 class="text-center text-ingo mt-2">레시피 주문내역</h3>
<a href="main" class="btn btn-danger mb-3">목록으로</a>
<table class="table table-bordered table-hover">
	<thead>
		<tr>
			<th>주문번호</th>
			<th>상품번호</th>
			<th>레시피 이름</th>
			<th>주문 수량</th>
			<th>주문일</th>
			<th>가격</th>
			<th>총액</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${recipeOrderList}" var="dto">
			<tr>
				<td><c:out value="${dto.rOid}"/></td>
				<td><c:out value="${dto.rPid}"/></td>
				<td><c:out value="${dto.rOtitle}"/></td>
				<td><c:out value="${dto.rOquanty}"/></td>
				<td><c:out value="${dto.rOquanty}"/></td>
				<td><c:out value="${dto.rOdate}"/></td>
				<td><c:out value="${dto.rOtotal}"/></td>
			</tr>
		</c:forEach>
	</tbody>
</table>
</body>
</html>