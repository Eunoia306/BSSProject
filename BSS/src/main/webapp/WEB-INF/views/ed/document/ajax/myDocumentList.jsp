<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>


<table class="table">
	<thead>
		<tr>
			<th>번호</th>
			<th>결재제목</th>
			<th>기안부서</th>
			<th>기안자</th>
			<th>결재자</th>
			<th>상태</th>
			<th>기안일자</th>
		</tr>
	</thead>
	<tbody class="listBody">
		<c:forEach items="${paging.dataList }" var="data">
			<tr class="datatr" data-docno="${data.docNo}">
				<td>${data.rnum}</td>
				<td>${data.docTitle}</td>
				<td>${data.depName }</td>
				<td>${data.empName }</td>
				<td>
					<c:forEach items="${signpathEmpList }" var="signpathEmp">
						<c:if test="${signpathEmp.docNo == data.docNo }">
								<span class="me-1">${signpathEmp.empName }</span>
						</c:if>
					</c:forEach>
				</td>
				<td>
					<c:if test="${data.code =='D_01'}">
						<span class="rounded-5 p-2 bg-primary-subtle ">${data.codeKoName}</span>
					</c:if>
					<c:if test="${data.code =='D_02'}">
						<span class="rounded-5 p-2 bg-success-subtle">${data.codeKoName}</span>
					</c:if>
					<c:if test="${data.code =='D_04'}">
						<span class="rounded-5 p-2 bg-danger-subtle">${data.codeKoName}</span>
					</c:if>
				</td>
				<td>${data.formatDocUpdate}</td>
			</tr>
		</c:forEach>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="7">${paging.pagingHTML }</td>
		</tr>
	</tfoot>
</table>

<script>
$(".listBody").on("click","tr.datatr",function(event) {
	let docNo = $(this).data("docno");
	location.href = `${pageContext.request.contextPath}/ed/document/documentFormView.do?docNo=\${docNo}`;
});
</script>