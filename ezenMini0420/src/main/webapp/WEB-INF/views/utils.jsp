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
<title>util</title>
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

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id"/>
</sec:authorize>
<!-- CKEditor의 CDN은 메인화면으로 줘야 uncaught에러가 발생하지 않기때문에 모든 CDN은 mainView에 작성해야한다. 
	AJAX로 로드되는 화면에도 적용되야하기때문이다.  -->

<div class="container mt-5 mb-5">
	<a href="fCalendar" class="btn btn-danger">Full Calendar</a> &emsp;
	<a href="sse" id="sse" class="btn btn-primary">서버 이벤트</a> &emsp;
	<a href="fcovert" id="fconvert" class="btn btn-info">파일변환</a> &emsp;
	<a href="pdfPlay" id="pdfPlay" class="btn btn-success">PDF Play</a> &emsp;
	<a href="util" id="cedit" class="btn btn-outline-primary">CKEditor</a> &emsp;
	<a href="cedList" id="cedList" class="btn btn-outline-primary">CKEditor 목록</a>
</div>

<h3 class="text-center mb-4">CKEditor로 게시판 처리</h3>
<!-- multpart Files일때 form id="" action="ckedit1?csrf처리" method="post" enctype="multipart/form-data"로 처리-->
<form id="editForm" action="ckedit1" method="post">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	<div class="form-group">
		<label for="title">제목</label>
		<input type="text" id="title" class="form-control" name="edTitle"/>
	</div>
	<div class="form-group">
		<label for="user">작성자</label>
		<input type="text" id="user" name="edUser" value="<c:out value='${user_id}'/>" readonly/>
	</div>
	<div class="form-group d-none">
		<label for="content">내용</label>
		<textarea class="form-control ck-content" id="editor" name="editor"></textarea>
	</div>
	<!-- submit은 외부버튼과 연결해 내용을 보고난뒤 보내도록할 예정이라 visibility를 hidden으로 -->
	<input id="editSub" type="submit" value="ckedit" style="visibility:hidden;"/>
</form>
<!-- toolbar-container는 메뉴 툴바, ckeditor는 내용을 처리 
	module에서 처리하는 부분이므로 가능한 이름은 그대로 사용 -->
<div id="toolbar-container" style="max-width:100%;"></div>
<div id="ckeditor" class="ck-content" style="max-width:100%;min-height:400px;border:1px solid grey;line-height:0.8rem;"></div>
<br/><br/>
<!-- ck editor의 내용에 추가 조정, 확인 후 form의 submit button과 연동 -->
<button onclick="myFunction()" class="btn btn-primary">전송</button>

<!-- 바닐라는 아니고 추가기능이 들어간 버전/ 개발진에서 입력한 내용이므로 가능한 그대로 사용 -->
<script type="module">	
 DecoupledEditor
    .create( document.querySelector('#ckeditor'),{    	    	
    	language: 'ko',	       	    	
    	ckfinder: { //이미지 처리 모듈
	   		uploadUrl: 'ckedit' //요청경로	   		
	   	},//기능 버튼 선택
	   	toolbar: ['ckfinder', '|','imageUpload', '|', 'heading', '|', 'bold', 'italic','link', 'bulletedList',
	   		'numberedList', 'blockQuote', '|', 'undo','redo','Outdent','Indent','fontsize',
	   		'fontfamily','insertTable','alignment', '|', 'fontColor', 'fontBackgroundColor']			
    })       
    .then(function(editorD) {
    	//window.editorResize = editor;
    	const toolbarContainer = document.querySelector( '#toolbar-container' );
        toolbarContainer.appendChild( editorD.ui.view.toolbar.element );        
    });
</script>

<script>
//표시된 전송버튼을 클릭한 event 발생시 진행할 function
function myFunction(){
	//ckeditor창에 작성된 내용을 html형태로 textarea에 옮겨서 서버로 보내준다. 이미지는 이름과 경로를 보냄
	$("#ckeditor svg").remove();//ckeditor창을 반환할때 검정삼각형(svg로 생성됨)을 제거
	let content = $("#ckeditor").html(); //편집창의 내용을 가져움
	$("#editor").html(content);//textarea의 내용부에 작성
	//$("#cview").html(content);//미리보기용으로 쓸때 작성
	setTimeout(function(){
		$("#editSub").trigger("click");
	},1000);//1초동안 서버로 갈 html을 보여줌
	$("#editForm").submit(function(event){//form의 내용을 보냄
		event.preventDefault();
		$.ajax({
			url: "ckedit1",
			type: "post",
			data: $("#editForm").serialize(),
			success: function(data){
				$("#hjumbo").text("입력내용을 저장했습니다.");
				$("#mainRegion").html(data);
				//$("#ckeditor1").html(content);//성공 후 내용확인 할때
			},
			error: function(){
				$("#mbody").text("서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});	
}

$(document).ready(function(){
	$("#sse").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "sse",
			type: "get",
			success: function(data){
				$("#hjumbo").text("SSE 처리창 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("SSE: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#fconvert").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "fconvert",
			type: "get",
			success: function(data){
				$("#hjumbo").text("파일 변환 처리창 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#pdfPlay").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "pdfPlay",
			type: "get",
			success: function(data){
				$("#hjumbo").text("pdf를 보여주는 창 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#cedit").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "util",
			type: "get",
			success: function(data){
				$("#hjumbo").text("에디터 창 입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	$("#cedList").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "cedList",
			type: "get",
			success: function(data){
				$("#hjumbo").text("에디터로 작성한 목록입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
});
</script>
</body>
</html>