<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@include file="../includes/header.jsp"%>
<link rel="stylesheet" type="text/css" href="/resources/css/payment.css">
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
$(document).ready(function(){
	$("#allCheck").click(function(){
        var chk = $("#allCheck").prop("checked");
        if(chk) {
            $(".checkbox").prop("checked", true);
        } else {
             $(".checkbox").prop("checked", false);
        }
        $(".checkbox").click(function(){
            $("#allCheck").prop("checked", false);
		});
	});
	$("#deleteBtn").click(function(){
		alert('장바구니에서 삭제합니다.');
	});
	$("#checkDelete").click(function(){
		
	});
});
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<section class="order">
	<div class="content">
		<h2>장바구니 목록</h2>
		<input type="hidden" name="product_id" value="${cvo.product_id}">
		<p class="orderList">
			<button type="button" onclick="location.href='orderList'">결제 목록</button>
		</p>
			<table width="80%">
				<thead>
					<tr>
						<th><input type="checkbox" id="allCheck">카트 아이디</th>
						<th>받는 사람 이름</th>
						<th>받는 사람 주소</th>
						<th>상품 이름</th>
						<th>가격</th>
						<th>개수</th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>

					<c:forEach var="cvo" items="${list}">
						<tr>
							<td class="center"><input type="checkbox" class="checkbox">${cvo.cart_id}</td>
							<td class="center" id="order_name">${cvo.user_name}</td>
							<td class="center" id="order_address">${cvo.user_address}</td>
							<td class="center">${cvo.product_name}</td>
							<td class="center" id="order_totalprice">${cvo.cart_totalprice}</td>
							<td class="center" id="order_totalcount">${cvo.cart_totalcount}</td>
							<td class="center"><a href='/deleteCart?cart_id=${cvo.cart_id}'><button type="button" id="deleteBtn">삭제</button></a></td>
							<td class="center"><a href='/payment?product_id=${cvo.product_id}&order_totalcount=${cvo.cart_totalcount}&order_totalprice=${cvo.cart_totalprice}'>
							<button type="button" id="deleteBtn">주문</button></a></td>
						</tr>
					</c:forEach>
					<c:if test="${list.size() == 0 }">
						<tr>
							<td colspan='7' align="center">게시글이 존재하지 않습니다.</td>
						</tr>
					</c:if>

				</tbody>
			</table>
			<div class="button">
				<button type="button" id="checkDelete">삭제</button>
				<button type="button" onclick="location.href='payment'">주문</button>
			</div>
	</div>
</section>
</html>
<%@include file="../includes/footer.jsp"%>