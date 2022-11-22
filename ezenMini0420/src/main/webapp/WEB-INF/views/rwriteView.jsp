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
<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8,IE=EmulateIE9"/> 
<title>Insert</title>
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
</head>
<body>

<!-- mainRegion에 들어갈 창 -->
<h3 class="text-center"> 요리 등록 </h3>
<!-- file을 보낼때는 post 방식임에도 csrf를 action 뒤에 query(?)로 enctype을 줘야 사용 가능 -->
<form action="recipeWrite?${_csrf.parameterName}=${_csrf.token}" method="post" enctype="multipart/form-data">
	<h4>레시피 구분</h4>
	<div class="form-check-inline">
		<label class="form-check-label" for="radio1">
			<input type="radio" class="form-check-input" id="radio1" name="rClass" value="Korean" checked/>한식
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label" for="radio2">
			<input type="radio" class="form-check-input" id="radio2" name="rClass" value="Japanese"/>일식
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label" for="radio3">
			<input type="radio" class="form-check-input" id="radio3" name="rClass" value="Chinese"/>중식
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label" for="radio4">
			<input type="radio" class="form-check-input" id="radio4" name="rClass" value="Europe"/>양식
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label" for="radio5">
			<input type="radio" class="form-check-input" id="radio5" name="rClass" value="Fusion"/>퓨전
		</label>
	</div><br/><br/>
	<div class="form-group">
		<label for="rname">식당명</label>
		<input type="text" class="form-control" id="rname" name="rtrName" required/>
	</div>
	<div class="form-group">
		<label for="title">요리 이름</label>
		<input type="text" class="form-control" id="title" name="rTitle" required/>
	</div>
	<div class="form-gorup">
		<label for="photo">레시피 사진</label>
		<input type="file" class="form-control" id="photo" name="rPhoto" required/>
	</div>
	<div class="form-group">
		<label for="price">레시피 가격</label>
		<input type="number" class="form-control" id="price" name="rPrice" placeholder="레시피 가격" required/>
	</div>
	<div class="form-group">
		<label for="address">식당주소</label>
		<input type="text" class="form-control" id="address" name="rAddress" required/>
	</div>
	
	<div class="form-group">
		<label for="content">요리 설명</label>
		<textarea rows="10" class="form-control" id="content" placeholder="레시피 설명" name="rContent" required></textarea>
	</div>
	<button type="submit" class="btn btn-success">레시피 등록</button> &emsp;
	<a href="main" class="btn btn-primary">목록보기</a>
</form>
</body>
</html>