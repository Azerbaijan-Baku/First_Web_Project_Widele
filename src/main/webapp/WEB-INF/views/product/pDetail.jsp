<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>
<link rel="stylesheet" href="/resources/css/main.css">
<script type="text/javascript"> //defer 넣으면 googleMap API와 충돌
document.title = '${sellerVO.user_name} : widele';
$(document).ready(function() {
	let type="${pBoard.pboard_unit_enabled}";
	let utype="${sessionScope.user.user_type}";
	if(type=="1"){
		if(utype=="0"){
		} else {
			alert("판매가 중지된 상품입니다.");
			history.back();
		}
	}
	$(".detail__count-input").change(function(){
		if($(".detail__count-input").val() > ${pBoard.pboard_unit_stocks}){
			alert(${pBoard.pboard_unit_stocks}+"개 이하로 구매할 수 있습니다.");
			$(".detail__count-input").val(${pBoard.pboard_unit_stocks});
			$(".pboard_unit_stocks").val(0);
			$("input[name=pboard_unit_stocks]").val(0);
			$(".detail__count-input").select();
		}
	});
	if ($("input[name=order_totalcount]").val() == 1) {
		$(".pboard_unit_stocks").val('${pBoard.pboard_unit_stocks}'-1);
		$("input[name=pboard_unit_stocks]").val('${pBoard.pboard_unit_stocks}'-1);
	}
	$(".up-button").click(function() {
		let tempcount = $("input[name=order_totalcount]").val();
		let totalcount = Number(tempcount) + 1;
		var stock = '${pBoard.pboard_unit_stocks}';
		var stockCompare = $("input[name=pboard_unit_stocks]").val();
		var price = '${pBoard.pboard_unit_price}';
		let stocks = 0;
		if(Number(stockCompare)>0){
			stocks = stock - Number(totalcount);
		}
		if(Number(stockCompare)<=0){
			alert("재고가 없습니다");
			totalcount = stock;
		}
		
		let totalprice = (Number(totalcount) * price).toString();
		console.log(totalprice.replace(/,/g,""));
		$("input[name=order_totalcount]").val(totalcount);
		$(".order_totalprice").val(totalprice.replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
		$("input[name=order_totalprice]").val();
		$(".pboard_unit_stocks").val(stocks);
		$("input[name=pboard_unit_stocks]").val(stocks);
	});
	$(".down-button").click(function() {
		let tempcount = $("input[name=order_totalcount]").val();
		let totalcount = 0;
		var price = '${pBoard.pboard_unit_price}';
		var stock = '${pBoard.pboard_unit_stocks}';
		if (Number(tempcount) <= 1) {
			totalcount = 1;
		} else {
			totalcount = Number(tempcount) - 1;
		}
		let totalprice = (Number(totalcount) * price).toString();
		let stocks = stock - Number(totalcount);
		console.log(totalprice.split(',').join(""));
		$("input[name=order_totalcount]").val(totalcount);
		$(".order_totalprice").val(totalprice.replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
		$("input[name=order_totalprice]").val(totalprice.split(',').join(""));
		$(".pboard_unit_stocks").val(stocks);
		$("input[name=pboard_unit_stocks]").val(stocks);
	});

});

	//자릿수 (,) 찍기
	function inputNumberAutoComma(obj) {
	     
	      // 콤마( , )의 경우도 문자로 인식되기때문에 콤마를 따로 제거한다.
	      var deleteComma = obj.value.replace(/\,/g, "");
	      let str = obj.value;
			//console.log(str)
			str = "" + str;
			if(blankCheck(str)){
				str = str.replace(/[^0-9]/g, "");
			}else{
				str = null;
			}
			
	   	 obj.value = str;
	
	     
	      // 기존에 들어가있던 콤마( , )를 제거한 이 후의 입력값에 다시 콤마( , )를 삽입한다.
	      obj.value=inputNumberWithComma(inputNumberRemoveComma(obj.value));
	  }
	function inputNumberWithComma(str) {
	
	       str = String(str);
	       return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, "$1,");
	}
	// 콤마( , )가 들어간 값에 콤마를 제거하는 함수
	function inputNumberRemoveComma(str) {
	
	    str = String(str);
	    return str.replace(/[^\d]+/g, "");
	}
	
	function blankCheck(str){
		if(str == null || str == "null"
			   || str == undefined || str == "undefined"
			   || str == '' || str == "" || str.length == 0
		   ){
			return null;
		}else{
			return str;
		}
	}
</script>
<!-- 페이징, 목록, 가격, 정렬 -->
<section class="section__content">
	<!-- New -->
	<div class="section__wrapper">
		<div class="section__productsList" id="new">
			<div class="detail__wrapper">
				<c:forEach var="fileThum" items="${fileThumList }">
					<c:url value="/fileDisplay" var="urlThum">
						<c:param name="file_name" value="${fileThum.file_s_savePath}"></c:param>
					</c:url>
					<img src="${urlThum }" class="thumnail__products-detail">
				</c:forEach>

				<form method="get" class="detail__form">
					<div>
						<input type="hidden" value="${pBoard.pboard_unit_no}"
							name="pboard_unit_no"> <input type="hidden"
							value="${pBoard.file_pictureId}" name="file_pictureId">
						<input type="hidden" value="${pBoard.pboard_unit_price}"
							name="pboard_unit_price">
						<input type="hidden" value="${pBoard.product_id}"
							name="product_id"> <input type="hidden"
							value="${pBoard.user_id}" name="user_id">

						<fmt:formatNumber type="number" maxFractionDigits="3"
							value="${pBoard.pboard_unit_price}" var="price"></fmt:formatNumber>
						<fmt:formatNumber type="number" maxFractionDigits="3"
							value="${pBoard.pboard_unit_stocks}" var="stocks"></fmt:formatNumber>
						<fmt:formatDate var="regdate"
							value="${pBoard.pboard_unit_regdate}" pattern="yy.MM.dd"
							timeZone="Asia/Seoul" />
						<fmt:formatDate var="updateDate"
							value="${pBoard.pboard_unit_updateDate}" pattern="yy.MM.dd"
							timeZone="Asia/Seoul" />
						<p>
							제품 <span>${productVO.product_name}</span>
						<p>
							가격 <span>${price}</span>
						<p>
							재고 <span>
							
								<input type="text" value="${stocks}" class="pboard_unit_stocks" disabled >
									<input type="hidden" value="${stocks}" name="pboard_unit_stocks">
							</span>
						<p>
							<span class="detail__count"><input type="text"
								name="order_totalcount" class="detail__count-input" value="1"
								min="0" max="${stocks}" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');"
								>
								<span>
									<button type="button" class="up-button">
										<i class="fas fa-chevron-up"></i>
									</button>
									<button type="button" class="down-button">
										<i class="fas fa-chevron-down"></i>
									</button>
								</span>
							</span>
						<p>
							총금액 <span>
								<input type="text" value="${price}" class="order_totalprice" readonly>
								<input type="hidden" value="${pBoard.pboard_unit_price}" name="order_totalprice" readonly>
							</span>
						<p>
							등록일 <span>${regdate}</span>
						<p>
							수정일 <span>${updateDate}</span> 
						<p>
							<input type="submit" class="detail__btn payment" value="결제" onclick="javascript: form.action='/payment';" />
							<input type="submit" class="detail__btn cart" value="장바구니" onclick="javascript: form.action='/cart';" />
					</div>
				</form>
			</div>
			<div class="detail__var">
				<ul role="menuitem">
					<li><a href="#description" role="presentation">상세정보</a></li>
					<li><a href="#review" role="presentation">리뷰</a></li>
				</ul>
			</div>
			<div class="detail__description">
				<div id="description">
					<ul id="fileList">
						<c:forEach var="fileDesc" items="${fileDescList }">
							<c:url value="/fileDisplay" var="urlDesc">
								<c:param name="file_name" value="${fileDesc.file_savePath}"></c:param>
							</c:url>
							<img src="${urlDesc}" class='detail__description-img'>
						</c:forEach>
					</ul>
				</div>
			</div>
			<%@include file="reviewproduct.jsp"%>
		</div>
	</div>
</section>


<%@include file="../includes/footer.jsp"%>
<script type="text/javascript" src="/resources/js/detail.js">
<!--
	
//-->
</script>