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
<meta id="_csrf" name="_csrf" content="${_csrf.token}"/>
<title>Insert</title>
<!--jquery-->
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

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id"/>
</sec:authorize>
<h3 class="text-center">게시판 내용 보기 및 수정, 삭제</h3>
<form action="modify" method="post" id="modiContent">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<div class="form-group">
		<label for="uId">번호</label>
		<input type="text" class="form-control" id="uId" name="bId" value="${contentView.bId}" readonly/>
	</div>
	<div class="form-group">
		<label for="hit">조회수</label>
		<input type="text" class="form-control" id="hit" value="${contentView.bHit}" readonly/>		
	</div>
	<div class="form-group">
		<label for="uname">작성자</label>
		<input type="text" class="form-control" id="uname" name="bName" value="${contentView.bName}" readonly/>
	</div>
	<div class="form-group">
		<label for="title">제목:</label>
		<input type="text" class="form-control" id="title" name="bTitle" value="${contentView.bTitle}"/>
	</div>	
	<div class="form-group">
		<label for="content">내용</label>
		<textarea rows="10" class="form-control p-0"  name="bContent">
			${contentView.bContent}
		</textarea>
	</div>
	<button type="submit" class="btn btn-success">수정</button>&emsp;
	<a href="eBoard" id="contentBoard" class="btn btn-primary">목록보기</a>
	<a href="delete?bId=${contentView.bId}" id="contentDel" class="btn btn-danger">삭제</a>
	<a id="contentReplyView" href="replyView?bId=${contentView.bId}" class="btn btn-primary">댓글</a>
</form>
<script>
$(document).ready(function(){
	//삭제에도 사용해야하므로 위에서 선언
	let username = '<c:out value="${user_id}"/>';
	//그냥 EL문만 써도 되지만 컴파일러에 확실하게 인식시켜 모든 환경에서 사용하도록하기 위해
	//jsp의 c:out을 사용해 요청한다.
	let bname = '<c:out value="${contentView.bName}"/>';

	$("#contentBoard").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#contentBoard").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("Main내부의 게시판");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("게시판: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	//modi 구현
	$("#modiContent").submit(function(event){
		event.preventDefault();
		if(username != bname) {
			$("#mbody").text("권한이 없습니다");
			$("#modal").trigger("click");
			return false;
		}
		else {
			$.ajax({
				url : "modify",
				type : "post",
				data: $("#modiContent").serialize(),
				success: function(data){
					$("#hjumbo").text("수정완료. 게시판");
					$("#mainRegion").html(data);
				},
				error: function(){
					$("#mbody").text("수정요청: 서버 접속 실패");
					$("#modal").trigger("click");
				}
			});	 
		}
	});
	//content del
	$("#contentDel").click(function(event){
		event.preventDefault();
		if(username != bname) {
			$("#mbody").text("권한이 없습니다");
			$("#modal").trigger("click");
			return false;
		}
		else {
			$.ajax({
				url : $("#contentDel").attr("href"),
				type : "get",
				data: "",
				success: function(data){
					$("#hjumbo").text("삭제완료. 게시판");
					$("#mainRegion").html(data);
				},
				error: function(){
					$("#mbody").text("삭제요청: 서버 접속 실패");
					$("#modal").trigger("click");
				}
			});	 
		}
	});
	$("#contentReplyView").click(function(event){
		event.preventDefault();
		$.ajax({
			url: $("#contentReplyView").attr("href"),
			type: "get",
			data:"",
			success: function(data){
				$("#hjumbo").text("댓글창 요청");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("댓글창 요청: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});		
	});
});
</script>
</body>
</html>