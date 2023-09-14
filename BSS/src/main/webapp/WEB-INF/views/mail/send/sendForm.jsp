<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<script src="${pageContext.request.contextPath}/resources/js/ckeditor/ckeditor.js"></script>

<html>
<head>
    <title>메일 작성</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
        }

        .container {
            width: 100%;
            margin: 0 auto;
            padding: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        h4 {
            margin-top: 0;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 3px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .btn {
            padding: 5px 15px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-success {
            background-color: #4caf50;
            color: white;
            border: none;
        }

        .btn-secondary {
            background-color: #ccc;
            color: black;
            border: none;
        }

        .table-border {
            border-collapse: collapse;
            width: 100%;
            border: 1px solid #ddd;
        }

        .table-border th,
        .table-border td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
            
        }

        .linear-input-group {
            display: flex;
            align-items: center;
        }

        .linear-input-group .form-control {
            flex: 1;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h5>☗ 메일 ▸ 메일 전송</h5>
<hr color="black">
        <form:form method="post" modelAttribute="mail" enctype="multipart/form-data">
            <table class="table-border">
                <tr>
                    <th>보내는 사람</th>
                    <td>
                        <div class="linear-input-group">
                            <input class="form-control" type="text" name="receiveMailSender" value="${empMail}" readonly />
                        </div>
                    </td>
                </tr>
				<tr>
				    <th>받는 사람</th>
				    <td>
				    	<c:choose>
				    		<c:when test="${not empty mailReplyAdd}">
				    			<div class="linear-input-group">
				            		<input class="form-control" type="text" name="receiveMailReceiver" value="${mailReplyAdd }" />
				           			<button class="btn btn-secondary btn-sm" type="button" onclick="writeToMyself()">내게쓰기</button>
				       			</div>
				        			<span class="error">${errors["receiveMailReceiver"]}</span>
				    		</c:when>
				    		<c:otherwise>
				    			<div class="linear-input-group">
				            		<input class="form-control" type="text" name="receiveMailReceiver" value="${mail.receiveMailReceiver}" />
				            		<button class="btn btn-secondary btn-sm" type="button" onclick="writeToMyself()">내게쓰기</button>
				        		</div>
				        		<span class="error">${errors["receiveMailReceiver"]}</span>
				    		</c:otherwise>
				    	</c:choose>
				    </td>
				</tr>
                <tr>
                    <th>제목</th>
                    <td>
                        <input class="form-control" type="text" name="receiveMailTitle" value="${mail.receiveMailTitle}" />
                        <span class="error">${errors["receiveMailTitle"]}</span>
                    </td>
                </tr>
                <tr>
                	<th>첨부 파일</th>
                	<td>
						<input type="file" name="mailFiles" multiple/>
					</td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td>
                        <textarea class="form-control" name="receiveMailContent" id="receiveMailContent">${mail.receiveMailContent}</textarea>
                        <span class="error">${errors["receiveMailContent"]}</span>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input class="btn btn-success" type="submit" id="submitBtn" value="전송">
                        <button class="btn btn-secondary" type="button" onclick="saveTemp()">임시저장</button>
                        <input class="btn btn-danger" type="reset" value="취소">
                        <button class="btn btn-primary" type="button" id="btnAutoSend">자동완성</button>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>


<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-loading-overlay/2.1.7/loadingoverlay.min.js"></script>
<script>
    // 전송 버튼을 클릭했을 때의 이벤트 핸들러를 추가
    $("#submitBtn").click(function () {
        // 로딩 오버레이 표시
        $.LoadingOverlay("show", {
            image: "<%=request.getContextPath()%>/resources/img/mailsend.gif",
            imageAnimation: false
        });

        $("#myForm").submit();
    });

    CKEDITOR.replace('receiveMailContent');
    
    function saveTemp() {
        var receiveMailSender = encodeURIComponent("${empMail}");
        var receiveMailReceiver = encodeURIComponent(document.getElementsByName("receiveMailReceiver")[0].value);
        var receiveMailTitle = encodeURIComponent(document.getElementsByName("receiveMailTitle")[0].value);
        var receiveMailContent = encodeURIComponent(CKEDITOR.instances.receiveMailContent.getData());

        var queryString = "receiveMailSender=" + receiveMailSender +
                          "&receiveMailReceiver=" + receiveMailReceiver +
                          "&receiveMailTitle=" + receiveMailTitle +
                          "&receiveMailContent=" + receiveMailContent;

        var xhr = new XMLHttpRequest();
        xhr.open("POST", "${pageContext.request.contextPath}/mailTemp/tempMail.do?" + queryString, true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    alert("메일이 임시 저장되었습니다.");
                    location.href = "${pageContext.request.contextPath }/mailTemp/tempList.do";
                } else {
                    alert("임시 저장 중 오류가 발생했습니다.");
                }
            }
        };
        xhr.send();
    }
    
    document.addEventListener("DOMContentLoaded", function() {
        const autofillButton = document.getElementById("btnAutoSend");

        autofillButton.addEventListener("click", function(){
            const ckEditorInstance = CKEDITOR.instances.receiveMailContent;
            const receiveMailTitle = document.querySelector('input[name=receiveMailTitle]');
            
            receiveMailTitle.value = "경력증명서(김지민)";
            
            ckEditorInstance.setData("요청하신 경력증명서 보내드리겠습니다.");
        });
    });
    
    function writeToMyself() {
        var receiveMailReceiver = document.getElementsByName("receiveMailReceiver")[0];
        receiveMailReceiver.value = "${empMail}";
    }
    
    CKEDITOR.editorContif = function(config){
    	config.entermode = CKEDITOR.ENTER_BR;
    }
</script>