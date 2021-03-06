<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@include file="../includes/header.jsp"%>
<link rel="stylesheet" type="text/css" href="/resources/css/payment.css">
<link rel="stylesheet" type="text/css" href="/resources/css/nboard.css">
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
function page(page){
	document.listForm.action="/admin/orderAllList";
	document.listForm.pageNo.value=page;
	document.listForm.submit();
	
}
$(document).ready(function(){
	$(".button").click(function(){
		let tr = $(this).closest("tr");
		let formData = new FormData();
		let formDataorder_id = tr.find(".order_id").val();
		let formDataorder_status = tr.find(".order_status").val();
		let formDataorder_name = tr.find(".order_name").val();
		let formDataorder_address = tr.find(".order_address").val();
		let formDataproduct_id = tr.find(".product_id").val();
		let formDataorder_totalprice = tr.find(".order_totalprice").val();
		let formDataorder_totalcount = tr.find(".order_totalcount").val();
		formData.append('order_id',formDataorder_id);
		formData.append('order_status',formDataorder_status);
		formData.append('order_name',formDataorder_name);
		formData.append('order_address',formDataorder_address);
		formData.append('product_id',formDataproduct_id);
		formData.append('order_totalprice',formDataorder_totalprice);
		formData.append('order_totalcount',formDataorder_totalcount);
		console.log(formDataorder_id);
		updateOrderList(formData ,$(this));
	});
});

function updateOrderList(formData, btn){
	let status = formData.get('order_status');
	$.ajax({
		url : '/admin/updateOrderList',
		method : 'POST',
		dataType : 'json',
		processData : false,
		contentType : false,
		data : formData,
		success : function(){
			let order_status_pic = "";
			if(status == "1"){
				order_status_pic = "<i class='fas fa-credit-card fa-4x' style='color:#e2e2e2;'></i>"
			} else if(status == "2"){
				order_status_pic = "<i class='fas fa-box fa-4x'></i>"
			} else if(status == "3"){
				order_status_pic = "<i class='fas fa-truck-loading fa-4x'></i>"
			} else if(status == "4"){
				order_status_pic = "<i class='fas fa-shipping-fast fa-6x'></i>"
			} else {
				order_status_pic = "<i class='fas fa-check fa-4x' style='color:#e2e2e2;'></i>"
			}
			btn.closest("tr").find(".torder_status").html(order_status_pic);
			order_status_pic
			alert(formData.get('order_id')+"??? ????????? ?????????????????????.");
		},
		error : function(errorThrown){
			console.log(errorThrown);
		}
	});
}
</script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<section class="order">
	<div class="content">
	${pBoard}
		<h2>?????? ??????</h2>
			<table width="80%">
				<thead>
					<tr>
						<th>?????? ?????????</th>
						<th>?????? ??????</th>
						<th>?????? ?????? ??????</th>
						<th>?????? ?????? ??????</th>
						<th>?????? ?????????</th>
						<th>??????</th>
						<th>??????</th>
						<th>?????????</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="ovo" items="${list}">
						<%-- <c:if test="${sessionScope.user.user_id == ovo.pboard_user_id}"> --%>
							<tr>
								<td>${ovo.order_id}</td>
								
								<td><span class="torder_status">
									<c:choose>
									<c:when test="${ovo.order_status eq 1}">
										<i class="fas fa-credit-card fa-4x"></i>
									</c:when>
									<c:when test="${ovo.order_status eq 2}" >
										<i class="fas fa-box fa-4x" style="color:#e2e2e2;"></i>
									</c:when>
									<c:when test="${ovo.order_status eq 3}">
										<i class="fas fa-truck-loading fa-4x" style="color:#e2e2e2;"></i>
									</c:when>
									<c:when test="${ovo.order_status eq 4}">
										<i class="fas fa-shipping-fast fa-6x" style="color:#e2e2e2;"></i>
									</c:when>
									<c:otherwise>
										<i class="fas fa-check fa-4x"></i>
									</c:otherwise>
								</c:choose>
								</span>
	 							<select class="order_status" name="selectStatus">
									<option value="0"<c:if test="${ovo.order_status == 0}">selected</c:if>>?????? ??????</option>
									<option value="1"<c:if test="${ovo.order_status == 1}">selected</c:if>>?????? ??????</option>
									<option value="2"<c:if test="${ovo.order_status == 2}">selected</c:if>>????????? ??????</option>
									<option value="3"<c:if test="${ovo.order_status == 3}">selected</c:if>>????????????</option>
									<option value="4"<c:if test="${ovo.order_status == 4}">selected</c:if>>?????? ???</option>
									<option value="5"<c:if test="${ovo.order_status == 5}">selected</c:if>>?????? ??????</option>
								</select>
								</td>
								<td class="torder_name">${ovo.order_name}</td>
								<td class="torder_address">${ovo.order_address}</td>
								<td class="tproduct_id">${ovo.product_name}</td>
								
									<fmt:formatNumber type="number" maxFractionDigits="3"
							value="${ovo.order_totalprice}" var="price"></fmt:formatNumber>
								<td class="torder_totalprice">${price}</td>
								<td class="torder_totalcount">${ovo.order_totalcount}</td>
								<td class="center">
									<fmt:parseDate value="${ovo.order_regdate}" pattern="yyyy-MM-dd" var="order_regdate" />
									<fmt:formatDate value="${order_regdate}" pattern="yyyy-MM-dd" var="regDate"/>
									
									${regDate}
								</td>
								<td class="center"><button type="button" class="button">??????</button></td>
								<input type="hidden" class="order_id" value="${ovo.order_id}">
								<input type="hidden" class="order_status" value="${ovo.order_status}">
								<input type="hidden" class="order_name" value="${ovo.order_name}">
								<input type="hidden" class="order_address" value="${ovo.order_address}">
								<input type="hidden" class="product_id" value="${ovo.product_id}">
								<input type="hidden" class="order_totalprice" value="${ovo.order_totalprice}">
								<input type="hidden" class="order_totalcount" value="${ovo.order_totalcount}">
								<input type="hidden" class="pboard_user_id" value="${ovo.pboard_user_id}">
							</tr>
						<%-- </c:if> --%>
					</c:forEach>
					<c:if test="${list.size() == 0 }">
						<tr>
							<td colspan='8' align="center">????????? ???????????? ????????????.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<!-- ????????? ?????? -->
			<div id="pagination-box">
					<nav>
						<ul class="pagination" style="text-align: center; margin: 0 auto;">
							<c:if test="${pageNavi.prev}">
								<li onClick="javascript:page(${pageNavi.startPage-1});"><a href="#" tabindex="-1">&lt;</a></li>
							</c:if>
							<c:forEach begin="${pageNavi.startPage }" end="${pageNavi.endPage }" var="page">
								<c:choose>
									<c:when test="${page eq pageNavi.cri.pageNo }">
										<li onClick="page(${page })"><a href="#">${page }<span class="active"></span></a></li> <!-- ??????????????? -->
									</c:when>
									<c:otherwise>
										<li onClick="page(${page })"><a href="#">${page }</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${pageNavi.next}">
								<li onClick="page(${pageNavi.endPage+1});"><a href="#">&gt;</a></li>
							</c:if>
						</ul>
					</nav>
			</div>
			<!-- ????????? ??? -->
			<form method=get action="/admin/orderAllList" name="listForm">
                 <!-- ???????????? ?????? ????????? -->
                 ${pageNavi.cri.type }
                 <input type=hidden name=pageNo value=${pageNavi.cri.pageNo }>
                 <input type=hidden name=orderby value=${pageNavi.cri.orderby }> 
                 <!-- ???????????? ?????? ????????? ??? -->
			</form>
	</div>
</section>
</html>
<%@include file="../includes/footer.jsp"%>