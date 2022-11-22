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
<title>editor detail</title>
</head>
<body>

<h3 class="text-center threeDEffect text-info">Editor를 이용한 상세 내역</h3>
<a id="cedList" href='cedList' class="btn btn-danger mb-3">목록으로</a>

<form action="edmodify" method="post" id="edmodiCont">
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<div class="form-group">
		<label for="uId">번호</label>
		<input type="text" class="form-control" id="uId" name="edId" value="${editDto.edId}" readonly />
	</div>	
	<div class="form-group">
		<label for="uname">작성자</label>
		<input type="text" class="form-control" id="uname" name="edUser" value="${editDto.edUser}" readonly/>
	</div>
	<div class="form-group">
		<label for="title">제목</label>
		<input type="text" class="form-control" id="title" name="edTitle" value="${editDto.edTitle}">
	</div>	 
	<div class="form-group d-none">
		<label for="editor">내용</label>
		<textarea class="form-control" id="editor" name="editor" style="height:400px;">		
		</textarea>
	</div>		
	<button type="submit" id="edmodi1" class="btn btn-success mt-4 d-none">확인</button> 	
</form>
<div id="toolbar-container" style="max-width:100%"></div>
<div id="ckeditor" class="ck-content" style="max-width:100%;min-height:400px;border:1px solid grey;line-height:0.8rem"></div>
<button type="button" id="edmodi2" class="btn btn-success mt-4">수정</button> 	
<!-- ck editor를 통하지 않으면 이미지가 text로만 보임. 에디터를 통해 div로 호출할때 내용이 제대로 보임 -->
<script type="module">	
 DecoupledEditor
    .create( document.querySelector('#ckeditor'),{    	    	
    	language: 'ko',	       	    	
    	ckfinder: {
	   		uploadUrl: 'ckedit' //요청경로	   		
	   	},
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
$(document).ready(function(){
	$("#ckeditor").html('${editDto.editor}');
	//let tarea = $("#ckeditor").html();
	//$("#editor").html(tarea);
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
				$("#mbody").text("서버접속 실패!.");
				$("#modal").trigger("click");	
			}	
		});
	});
	$("#cedList").click(function(evnet){
		event.preventDefault();
		$.ajax({
			type : "get",
			url : "cedList",
			success : function(data) {
				$("#hjumbo").text("ck editor 목록");				
		    	$("#mainRegion").html(data);	
			},
			error: function() {
				$("#mbody").text("서버접속 실패");
				$("#modal").trigger("click");	
			}	
		});
	});

});
</script>
</body>
</html>