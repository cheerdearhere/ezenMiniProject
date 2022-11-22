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

<sec:authorize access="isAuthenticated()">
	<sec:authentication property="principal.username" var="user_id"/>
</sec:authorize>
<h3 class="text-center mb-2">나의 장바구니</h3>
<a href="main" class="btn btn-danger mb-3">목록으로</a>
<table id="cartTable" class="table table-bordered table-hover">
<!-- thead만 만들고 tbody는 비움. id를 지정해놓고 script로 채워넣을 예정 -->
	<thead>
		<tr>
			<th>제품번호</th>
			<th>식당명</th>
			<th>요리명</th>
			<th>가격</th>
			<th>수량</th>
			<th>주문/취소</th>
		</tr>
	</thead>
	<tbody id="cartBody"></tbody>
</table>

<script>
$(document).ready(function(){
	if(typeof(Storage)=="undefined") {
		return;
	}
//여러 이벤트에서 사용할 변수들
	let i;//반복을 위한 값(인덱스)
	let keyName;//구분값(스토리지에서 뺀 키값)
	let cartItem;//key값에 따른 value(JSON문자열)
	let cartItemObj;//key와 item을 JavaScript 객체형으로
	//값을 빼서 사용할 준비
	let rId;
	let rClass;
	let rTitle;
	let rtrName;
	let rPrice;
	let rContent;
	let rPhoto;
	let rQty;
	
	//list로 tbody에 넣을 내용 입력(for문과 +=로 추가)
	let list="";
	for(i=0;i<localStorage.length;i++){
		keyName=localStorage.key(i);
		cartItem=localStorage.getItem(keyName);
		cartItemObj=JSON.parse(cartItem);
		rId=cartItemObj.rId;
		rClass=cartItemObj.rClass;
		rtrName=cartItemObj.rtrName;
		rTitle=cartItemObj.rTitle;
		rPrice=cartItemObj.rPrice;
		rContent=cartItemObj.rPhoto;
		rQty=cartItemObj.rQty;
		
		list += "<tr><td>"+rId+"</td><td>"+rtrName+
		"</td><td>"+rTitle+"</td><td>"+rPrice+"</td><td>"+rQty+"</td>"+
		"<td><button type='button' class='btn btn-success oBtn'>주문<span class='d-none'>"+keyName+"</span></button> "+
		"<button type='button' class='btn btn-danger dBtn'>취소<span class='d-none'>"+keyName+"</span></button></td></tr>";
	}
	
	//지정한 id의 tbody에 html()로 처리
	$("#cartBody").html(list);
	//keyname을 숨겨놓고 버튼을 누르면 loacal에서 받아서 주문진행
	$(".oBtn").click(function(event){
		event.preventDefault();
		//이벤트가 발생한 객체의 key값
		let eTarget = $(event.target);
		let ckeyname = eTarget.children("span").text();
		//prompt 창으로 입력받을 내용 variable
		let rphoneNo=prompt("받는 사람의 연락처를 적어주세요.", "010-");
		if(rphoneNo==null || rphoneNo==""){
			alert("입력값이 없습니다.");
			return;
		}
		let ruserAddr = prompt("배송지 주소");
		if(ruserAddr==null || ruserAddr==""){
			alert("입력값이 없습니다.");
			return;
		}
		let res = confirm("입력하신 연락처: " + rphoneNo +"/ 배송지: " + ruserAddr +"가 맞습니까?");
		if(res==true){
			console.log(ruserAddr);
		}
		else{
			alert("다시 입력해주세요.");
			return;
		}
	
		//local storage 정보
		cartItem=localStorage.getItem(ckeyname);
		cartItemObj=JSON.parse(cartItem);
		rId=cartItemObj.rId;
		rClass=cartItemObj.rClass;
		rtrName=cartItemObj.rtrName;
		rTitle=cartItemObj.rTitle;
		rPrice=cartItemObj.rPrice;
		rContent=cartItemObj.rPhoto;
		rQty=cartItemObj.rQty;
		let username = "<c:out value='${user_id}'></c:out>";
		//RecipeOderDto에 실어보낼 data 객체
		let orderObj = {
				rPid: rId,
				rOuser: username,
				rOquanty: rQty,
				rOphoneNo: rphoneNo,
				rOuserAddr: ruserAddr,
				rOtitle: rTitle,
				rOprice: rPrice,
				//security 처리를 위해 함께 가야함
				${_csrf.parameterName}:"${_csrf.token}"
		}
		$.ajax({
			url: "recipeorder",
			type: "post",
			data: orderObj,
			success:function(data){
				localStorage.removeItem(ckeyname);
				$("#hjumbo").text("주문 요청");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("주문 전달: 서버 접속 실패!");
				$("#modal").trigger("click");
			}
		});
	});
	//삭제 처리
	$(".dBtn").click(function(event){
		event.preventDefault();
		let eTarget=$(event.target);
		let dkeyname = eTarget.children("span").text();
		cartItem=localStorage.getItem(dkeyname);
		localStorage.removeItem(dkeyname);

		$.ajax({
			url: "recipeCart", 
			type: "get",
			data: "",
			success: function(data){
				$("#hjumbo").text("장바구니입니다.");
				$("#mainRegion").html(data);
			},
			error: function(){
				$("#mbody").text("장바구니: 서버 접속 실패!");
				$("#modal").trigger("click");
			}
		});
	});
});
</script>
</body>
</html>