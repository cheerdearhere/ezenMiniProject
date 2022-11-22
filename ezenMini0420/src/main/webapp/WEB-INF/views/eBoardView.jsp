<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<title>게시판</title>
<!--jquery
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script> -->
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
<script src="js/jquery.twbsPagination.js"></script>
</head>
<body>

<form id="searchForm" class="form-inline" action="#">
	<button class="btn btn-success ml-auto" type="button" disabled>
		<i class="fa fa-search"></i>
	</button>
	<input id="searchInput" class="form-control mr-sm-2" type="text" placeholder="Search"/>
</form>

<div id="submain">
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
</div>
<!-- pagination을 위한 api(jquery.twbsPagination.js) 사용 -->
<nav aria-label="page navigation"><!-- aria-label: 라벨표시가 안되는 것을 예방 -->
	<ul class="pagination justify-content-center" id="pagination" style="margin:20px 0">
	</ul>
</nav>
<a id="write" class="btn btn-primary" href="writeView">글작성</a>

<script>
//pagination 구현
//$(document).ready(function(){});을 단축해서 사용
$(function(){
	//twbsPagination(): 외부의 js파일을 적용시킴
	window.pagObj = $("#pagination").twbsPagination({
		totalPages: 35, //총 페이지 수
		visiblePages: 10, //한 화면에서 볼수있는 페이지 수
		onPageClick: function(event, page){//페이지 이동 클릭하면 발생시킬 기능
			console.info(page + ' (from options)');
			$(".page-link").on("click",function(event){
			//page-link: bootstrap4에서 사용하는 페이지 이동링크(a element)의 class
				event.preventDefault();
				let peo = $(event.target);//이벤트 발생 대상
				let pageNo = peo.text();//page number
				let purl;
				let pageA;
				let pageNo1;
				let pageNo2;
				if(pageNo != "First" && pageNo !="Previous" && pageNo != "Next" && pageNo != "Last"){
					purl = "plist?pageNo=" + pageNo;//기능 값을 제외하고는 pagenumber지정
				}
				else if(pageNo == "Next") {
					pageA = $("li.active > a");//.active를 지닌 li의 a element
					pageNo = pageA.text();
					pageNo1 = parseInt(pageNo);//페이지 번호를 계산해 변경하기위해 int로 형변환
					pageNo2 = pageNo1 + 1;
					purl = "plist?pageNo=" + pageNo2;
				}
				else if(pageNo == "Previous") {
					pageA = $("li.active > a");//.active를 지닌 li의 a element
					pageNo = pageA.text();
					pageNo1 = parseInt(pageNo);//페이지 번호를 계산해 변경하기위해 int로 형변환
					pageNo2 = pageNo1 - 1;
					purl = "plist?pageNo=" + pageNo2;
				}
				else if(pageNo == "First") {
					pageNo2 = 1;
					purl = "plist?pageNo=" + pageNo2;
				}
				else if(pageNo == "Last") {
					pageNo2 = 35;//마지막 페이지는 어떻게?
					purl = "plist?pageNo=" + pageNo2;
				}
				else {
					return;
				}//if-else
				$.ajax({//ajax로 처리
					url: purl,
					type: "get",
					data: "",
					success: function(data){
						$("#hjumno").text("게시판의" + pageNo + "페이지 입니다.");
						$("#submain").html(data);
						//page-link의 super인 page-item에 class(active)추가
						let parent = peo.parent();
						parent.addClass("active");
					},
					error: function(){
						$("#mbody").text("게시판" + pageNo + ": 서버 접속 실패");
						$("#modal").trigger("click");
					}
				});//ajax
			});//on("click")
		}//onPageClick
	})//twbsPagination(chaining을 위해 ;를 제외)
	.on("page", function(event,page){//twbsPagination에 chaining
		console.info(page + ' (from event listening)');
	});//on("page")
	
	//글쓰기
	$("#write").click(function(event){
		event.preventDefault();
		$.ajax({
			url: "writeView",
			type: "get",
			data: "",
			success: function(data){
				$("#hjumno").text("게시판에 글쓰기 form 입니다.");
				$("#mainRegion").html(data);	
			},
			error: function(){
				$("#mbody").text("write form: 서버 접속 실패");
				$("#modal").trigger("click");
			}
		});
	});
	
	//내용보기
	$("a.contentView").click(function(event){
		event.preventDefault();
		let ceo = $(event.target);
		$.ajax({
			url: ceo.attr("href"),
			type: "get",
			data: "",
			success: function(data){
				$("#hjumno").text("게시글 내용 보기.");
				$("#mainRegion").html(data);	
			},
			error: function(){
				$("#mbody").text("contentView: 서버 접속 실패");
				$("#modal").trigger("click");
			}			
		});
	});
	
	//검색창에 key가 입력될때마다 작동
	$("#searchInput").on("keyup",function(){
		//이벤트가 일어난 element의 content value를 가져와 소문자로 변환
		var value = $(this).val().toLowerCase();//입력된 값
		$("#searchTable tr").filter(function(){//filter()로 지정된 element를 검색
			$(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
			//toggle: 테이블의 행에서 text 중 같은 값이 있을때(-1이 아닐때) 표시하고 없을때(-1)는 안보이게함.
		});
	});
	//이렇게만 처리하면 표시된 페이지에서만 처리되기때문에 ctrl+f와 큰 차이가 없다. 
	//커서가 위치했을때 전체 내용에서 찾도록 ajax로 처리
	
	//DB에서 게시물을 가져와 javascript로 filterring
	$("#searchInput").on("focus",function(){
		$.ajax({
			url: "searchBoard",
			type: "get",
			data: "",
			success: function(data){
				$("#hjumno").text("게시판 내용 검색");
				$("#mainRegion").html(data);	
			},
			error: function(){
				$("#mbody").text("searchBoard: 서버 접속 실패");
				$("#modal").trigger("click");
			}	
		});
	});
});
</script>
</body>
</html>