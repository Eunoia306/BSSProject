<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags"  prefix="security"%>
<button class="btn btn-outline-primary mb-2"  id="delete">선택삭제</button>
<table class="table table-bordered table-hover">
	<thead>
		<tr class="table-secondary textCenter">
			<th></th>
			<th>No.</th>
			<th>문서유형</th>
			<th>문서제목</th>
			<th>기안자</th>
			<th>기안일시</th>
			<th>반려자</th>
			<th>반려일시</th>
			<th>반려의견</th>
		</tr>
	</thead>
	<tbody>
		<c:if test="${empty paging.dataList}">
			<tr class="textCenter">
				<td colspan="9">현재 반려된 문서가 없습니다.</td>
			</tr>
		</c:if>
		<c:if test="${not empty paging.dataList}">
			<c:forEach items="${paging.dataList}" var="ret" varStatus="loop">
				<tr class="textCenter">
					<td ><input class="form-check-input prdtCheckBox" type="checkbox"
										name="docNo" value="${ret.docNo }">
					</td>
					<td class="align-middle"><c:out value="${loop.index + 1}" /></td>
					<td class="align-middle">${ret.docType }</td>
					<td class=" align-middle"><a href="${pageContext.request.contextPath}/ed/document/documentFormView.do?docNo=${ret.docNo}">${ret.docTitle }</a></td>
					<td class="align-middle">${ret.empName }</td>
					<td class="align-middle"> ${ret.docUpdatedate.toString().replace('T',' ') }</td>
					<td class="align-middle">${ret.approvalEmpName }</td>
					<td class="align-middle">${ret.seDate.toString().replace('T',' ') }</td>
					<td data-docno="${ret.docNo}">
						<!-- Button trigger modal -->
						<button type="button"  class="btn btn-primary modalBtn" data-bs-toggle="modal" data-bs-target="#staticBackdrop">
						  보기
						</button>
					</td>
				</tr>
			</c:forEach>
		</c:if>
	</tbody>
	<tfoot>
		<tr>
			<td colspan="9">${paging.pagingHTML }</td>
		</tr>
	</tfoot>
</table>


<!-- Modal -->
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="staticBackdropLabel">반려사유</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>


<script>


$(".modalBtn").on("click",function(){
	console.log("docNo = " + $(this).parent("td").data().docno);
	let docNo = $(this).parent("td").data().docno;
	let html="";
	let data ={
			docNo:docNo
	}
	let setting = {
		url : "${pageContext.request.contextPath}/ed/document/documentReturnSelect.do",
		method : "GET",
		dataType : "json",
		data : data,
		success : function(resp) {
			console.log(resp);
			let data = resp.document;
			html+=`<table class="textCenter table table-border">
		        	<tr>
		        		<td>반려자</td>
		        		<td>\${data.approvalEmpName}</td>
		        	</tr>
		        	<tr>
		        		<td>반려사유</td>
		        		<td>\${data.seReject}</td>
		        	</tr>
		        </table>`;
		      $(".modal-body").html(html);
		},
		error : function(jqXHR, status, error) {
			console.log(jqXHR)
			console.log(status)
			console.log(error)
		}
	}

	$.ajax(setting);
	
})

// $(staticBackdrop).on("show.bs.modal",function(){
// 	console.log(this)
// 	$.ajax(setting);
// })


$("#delete").on("click",function(){
    let selectDocNo = $('input[name="docNo"]:checked');
    let docNo = [];
    selectDocNo.each(function(index, value) {
        console.log(value);
        console.log($(value).parent("tr"))
        docNo.push(value.value); // value는 DOM 엘리먼트이므로 .value로 실제 값을 가져와야 합니다.
    });
    console.log("docNo", docNo);
    let data = {
        docArrayNo: docNo
    };
    console.log(data);
	let setting = {
		url : "${pageContext.request.contextPath}/ed/document/documentTempDelete.do",
		method : "POST",
		dataType : "json",
		headers: {'Content-Type': 'application/json'},
		data : JSON.stringify(data),
		success : function(resp) {
			console.log(resp.result)
			if(resp.result){
				alert("임시저장 결재서류가 삭제되었습니다.")
				selectDocNo.each(function(index, value) {
					value.parentElement.parentElement.remove();
			    });
			}
		},
		error : function(jqXHR, status, error) {
			console.log(jqXHR)
			console.log(status)
			console.log(error)
		}
	}

	$.ajax(setting);
})

$(".listBody").on("click","tr.datatr",function(event) {
	let docNo = $(this).data("docno");
	location.href = `${pageContext.request.contextPath}/ed/document/documentFormView.do?docNo=\${docNo}`;
});
</script>