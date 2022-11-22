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
<title>Home in mainView</title>
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
<div class="container" style="margin-top:30px">
	<div class="row">
		<div class="col-md-4">
			 <h2>About Me</h2>
			 <h5>Photo of me:</h5>
			 <div class="fakeimg">
			 	<img src="media/strawberry.png" style="width:100%;height:100%">
			 </div>
			 <p>Some text about me in culpa qui officia deserunt mollit anim..</p>
     			 <h3>Some Links</h3>
     			 <p>수직메뉴 만들기.</p>
     			 <ul class="nav nav-pills flex-column">
     			 	<li class="nav-item">
     			 		 <a class="nav-link active" href="#">Active</a>
     			 	</li>
     			 	<li class="nav-item">
     			 		<a class="nav-link" href="#">Link</a>
     			 	</li>
     			 	<li class="nav-item">
     			 		<a class="nav-link" href="#">Link</a>
     			 	</li>
     			 	<li class="nav-item">
     			 		<a class="nav-link" href="#">Link</a>
     			 	</li>
     			 </ul>
		</div>
		<div class="col-md-8">
			<h2>TITLE HEADING</h2>
			<h5>Title description, Dec 7, 2017</h5>
			<div class="fakeimg">
				<img src="media/beach.png" class="w-100 h-100"/>
			</div>
			<p>Some text..</p>
			<p>Some text.. Some text.. Some text..</p>  
			<br/>
			<h2>TITLE HEADING</h2>
			<h5>Title description, Dec 7, 2017</h5>
			<div class="fakeimg">
				<img src="media/Desert.png" class="w-100 h-100"/>
			</div>
			<p>Some text..</p>
			<p>Some text.. Some text.. Some text..</p>  
			<br/>
		</div>		
	</div>
</div>
</body>
</html>