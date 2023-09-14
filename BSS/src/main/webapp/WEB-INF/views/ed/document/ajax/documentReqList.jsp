<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags"  prefix="security"%>
<table class="table table-bordered table-hover">
	<thead>
		<tr class="table-secondary textCenter">
			<th>No.</th>
			<th>문서유형</th>
			<th>문서제목</th>
			<th>기안자</th>
			<th>기안부서</th>
			<th>기안일자</th>
		</tr>
	</thead>
    <tbody class="listBody">
    <c:if test="${empty paging.dataList}">
        <tr class="textCenter">
            <td colspan="6">현재 요청한 문서가 없습니다.</td>
        </tr>
    </c:if>
    <c:if test="${not empty paging.dataList}">
        <c:forEach items="${paging.dataList}" var="ref" varStatus="loop">
				<tr class="textCenter datatr" data-docno = ${ref.docNo }>
				<td>${ref.rnum }</td> <!-- 1번부터 부여하기 위해 +1-->
				<td>${ref.docType }</td>
				<td class="textLeft">${ref.docTitle }</td>
				<td>${ref.empName }</td>
				<td>${ref.depName }</td>
				<td>${ref.formatDocUpdate}</td>
			</tr>
        </c:forEach>
    </c:if>
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