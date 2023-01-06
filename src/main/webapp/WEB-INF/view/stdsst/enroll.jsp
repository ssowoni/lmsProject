<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- abc -->
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>수강신청</title>

<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>

<script type="text/javascript">

	var pagesize = 5; // 현재페이지의 레코드 수
	var pagenumsize = 5; // 네이게이션 넘버
	
 	$(function() {
		
		// 게시판 조회
		fListenroll();
		// 버튼 클리시 이벤트처리
		fRegisterButtonClickEvent();
		
		$("#searchvalue").keydown(function (key) {
		        if (key.keyCode == 13) {
		            $("#btnSearch").click();
		        }
	    });
		$("#searchvalue").focus();
		
	});
	 // 테이블 불러오기
	function fListenroll(clickpagenum) {
		
		clickpagenum = clickpagenum || 1;
		
		var param = {
				searchtype : $("#searchtype").val() ,  // select박스 id
				searchvalue : $("#searchvalue").val() , // text id
				clickpagenum : clickpagenum,  // 클릭 페이지
				pagesize : pagesize // 페이지 사이즈
		};
		
		var searchcallback = function(returndata) {
			console.log("returndata : " + returndata);
			
			searchcallbackprocess(returndata,clickpagenum);
			
		}
		
		callAjax("/supportC/listenroll.do", "post", "text", true, param, searchcallback);
		
		 
	} 
	 
	function searchcallbackprocess(returndata,clickpagenum) {
		
		$("#listenroll").empty().append(returndata); // empty 값을 초기화 해주고  append 추가하라 (returndata)를
		
		var totalcnt = $("#searchlistcnt").val(); // searchlistcnt은 list에서 정해놓은 히든 id, totalcnt 총 페이지 호출
		
		var paginationHtml = getPaginationHtml(clickpagenum, totalcnt, pagesize, pagenumsize, 'fListenroll');
		console.log("paginationHtml : " + paginationHtml);
		//swal(paginationHtml);
		$("#comnfileuploadPagination").empty().append( paginationHtml );  // 테이블 아래 페이징 처리하는 네비게이션
		
	}
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {  // 버튼 이벤트 액션
		$('a[name=btn]').click(function(e) {  // <a 태크에 name이 'btn'인것을 clock 했을떄
			e.preventDefault(); // 중복방지

			var btnId = $(this).attr('id');
			
			switch (btnId) {
				case 'btnSearch' : // 검색버튼
					fListenroll(); // 페이지 재조회
					break;
				case 'btnSave' :  // 모달 신청(저장) 버튼
					finsertenroll(); // insert하는 액션
					break;
				case 'btnClose' : // 모달 목록보기 버튼
					gfCloseModal(); // 모달 닫고 현재 페이지 보여주기
					break;
				case 'btnDelete' :
					$("#action").val("D"); // action html에 input 히든타입으로  컨트롤러로 보내주고있음
					finsertenroll(); // 페이지 재조회
					break;
					
			}
		});
	}
	
	
	function fn_forminit(object) { // 단건으로 검색한 모달창
				
		if (object == null || object=="") {
			$("#enrollTitle").text(""); // 제목 텍스트
			$("#cont").val(""); // 내용 텍스트
			$("#enrollNo").text(""); // 강의시작 텍스트
			$("#enrollpd").text(""); // 강의종료 텍스트
			$("#fileori").val(""); // 다운로드파일이름
			$("#btnSave").hide(); // 신청 텍스트
			$("#btnDelete").hide(); // 신청취소버튼
			$("#fileori").val(""); // 다운로드파일이름
			$("#upfile").val("");

			$("#title").focus();

		} else {
			$("#enrollTitle").text(object.in_title); // 제목 텍스트
			$("#cont").val(object.in_contents); // 내용 텍스트
			$("#enrollNo").text(object.li_date); // 강의시작 텍스트
			$("#enrollpd").text(object.li_redate); // 강의종료 텍스트
			$("#fileori").val(object.att_ori); // 다운로드파일이름
			$("#btnSave").show(); // 신청 텍스트
			$("#li_no").val(object.li_no);
			/* alert("test1"); */
			
			var fileyn = "";
			var inhtml = "";
			
			if (object.att_ori == null || object.att_ori =="") { // 원본명이 널값이거나 빈무자열이면    || 둘중에 하나라도 
				$("#filedownloaddiv").empty(); // 파일 다운로드 최기화
				
			} else {
				inhtml = "<a href='javascript:download()'>" + object.att_ori + "("  + object.att_size+ ")</a>";  // att_ori 파일원본명 att_size 파일 사이즈
				$("#filedownloaddiv").empty().append(inhtml); // 파일다운로드id.최가화.추가(inhtml) 다운로드 기능
				/* alert("test33"); */
			}
			
			 if(object.cnt > 0) {  // 신청한 강의의 cnt가 있으면 
				$("#btnSave").hide(); // 신청버튼
				$("#fileori").show(); // 다운로드파일이름
				$("#btnDelete").show(); // 신청취소버튼
				/* alert("test2"); */ 
				
				if(object.daycnt > 0) { // 강의시작보다 날짜가 안지나면 
					$("#btnDelete").show(); // 신청취소버튼
					$("#btnSave").hide();  // 신청버튼
					/* alert("test444"); */
					
				} else { // 강의시작한 날짜가 지나면 
					$("#btnDelete").hide(); // 신청취소버튼
					$("#btnSave").hide(); // 신청버튼 
					/* alert("test555"); */
				}
				
			} else { // 신청한 강의의 cnt가 없으면
				/* alert("test6"); */
			    $("#btnSave").show();  // 신청버튼	
				$("#btnDelete").hide(); // 신청취소버튼
			    $("#fileori").hide(); // 다운로드파일이름 
			    $("#li_no").val(object.li_no);
				
			}  
		}

		
	}
	//단건조회 함수
	function fselectone(ln_no) {
		
		var param = {
				ln_no : ln_no // 강의코드넘버로 한 레코드 검색
		}
	
	
		var searchcb = function( selectonersn ) { // selectonersn은 사용자가 임의로 정하는 변수명
			console.log(JSON.stringify(selectonersn));
			//console.log(JSON.stringify(selectonersn.searchone));
			
			$("#action").val("I");	 
			fn_forminit(selectonersn.searchone); // 변수명.serchone 키값이다
			
			gfModalPop("#layer1"); // 모달 액션
		
	}
		
	callAjax("/supportC/selectenroll.do", "post", "json", true, param, searchcb);
	}
	// 강의신청 insert
	function finsertenroll() {
			
			var param = {
					ln_no : $("#ln_no").val(), // 과정 넘버
					li_no : $("#li_no").val(), // 강의코드 넘버
					action : $("#action").val() // 컨트롤러에 액션 
					
			};
			
			var insertcallback= function(rtn) {
				/* console.log(JSON.stringify(rtn)); */
				
				alert("신청 되었습니다.");
				
				gfCloseModal(); // 모달 닫기
				
				var savepageno = 1;
				
				console.log("action : " + $("#action").val());
				
				if($("#action").val() == "I") {
					 //console.log("#action : " + action.val());
					savepageno = $("#hclickpagenum").val();
				}
				
				fListenroll(savepageno); // 페이지 재조회(페이지 넘버1번)
				
			}
			callAjax("/supportC/insertenroll.do", "post", "json", true,  $("#myForm").serialize(), insertcallback);
		}
	
	
		function download() {
				
				var params = "<input type='hidden' name='ln_no' value='"+ $("#ln_no").val() +"' />"; // vlaue값을 지정해줌
		
				jQuery(
						"<form action='/supportC/download.do' method='post'>"
								+ params + "</form>").appendTo('body').submit().remove();// ().appendTo 앞에걸 뒤로 to붙인다 submit() 폼태크에만 전송메소드  remove()제거메소드
		}																				// append 뒤에있는걸 앞으로 붙인다
</script>
</head>
<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="hclickpagenum" name="hclickpagenum"  value="" />
	<input type="hidden" id="action" name="action"  value="" />
	<input type="hidden" id="ln_no" name="ln_no"  value="" />
	<input type="hidden" id="li_no" name="li_no"  value="" />
	<input type="hidden" id="swriter" value="${loginId}">
	
	<!-- 모달 배경 -->
	<div id="mask"></div>

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a> <span
								class="btn_nav bold">학습지원</span> <span class="btn_nav bold">수강신청 -과정공지- 일정</span> 
								<a href="../careerA/jobInfoMgt.do" class="btn_set refresh">새로고침</a>
						</p>
						
						<p class="conTitle">
							<span>신청 및 공지일정</span> <span class="fr"></span>
						</p>	
						<table style="margin-top: 10px" width="100%" cellpadding="5" cellspacing="0" border="1"  align="left"   style="collapse; border: 1px #50bcdf;">
	                        <tr style="border: 0px; border-color: blue">
	                           <td width="50" height="25" style="font-size: 100%; text-align:left; padding-right:25px;">
						 			<select id="searchtype" name="searchtype" style="width: 150px;" v-model="searchKey">
			                     		 <option value="" >전체</option>
					                     <option value="title" >제목</option>
					                     <option value="writer">작성자</option>
		                  			</select>
		                   
		                  <input type="text" id="searchvalue" name="searchvalue" style="width: 180px; height: 28px;margin:10px 10px;">
		                  	<a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
		                     
		                 	   </td> 
	                          
	                        </tr>
                        </table>     
		                <div class="divEnrollList">
							<table class="col" id="dateDay">
								<caption>caption</caption>
								<colgroup>
									<col width="40%">
									<col width="30%">
									<col width="30%">
								</colgroup>
								
								<thead>
									<tr>
										<th scope="col">제목</th>
										<th scope="col">작성일</th>
										<th scope="col">작성자</th>
									</tr>
								</thead>
								<tbody id="listenroll"></tbody>
							</table>
						</div>
									<!-- 테이블 페이지 네비게이션 -->
						<div class="paging_area"  id="comnfileuploadPagination"> </div>
		                     
					</div>
				</li>
			</ul>
		</div>
	</div>
	
	<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				
			</dt>
			
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th><strong>제목</strong></th>
							<td style="display:flex; justify-content:space-between; line-height:27px;">
								<strong><span id="enrollTitle"></span></strong>
							<span>
								<strong>강의기간 &nbsp;:&nbsp;<span id="enrollNo"></span></strong>
								<strong>&nbsp;~&nbsp; <span id="enrollpd"></span></strong>	
							</span>					
							</td>
						</tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td>
							     <textarea class="inputTxt p100"	name="cont" id="cont" > </textarea>
						   </td>
						<tr>
							<th scope="row">첨부파일 <span class="font_red">*</span></th>
							<td>
							    <input type="file" id="upfile" name="upfile"  onChange="fpreview(event)" />
						   	</td>
						</tr>
						<tr>
							<th scope="row" >파일 다운로드<span class="font_red">*</span></th>
							<td id="fileori">
							     <div id="filedownloaddiv"></div>
						   </td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30" style="display:flex; justify-content:space-between;">
					<a href="" class="btnType gray" id="btnClose" name="btn"><span>목록보기</span></a> 
					<span>
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>신청</span></a>
					<a href="" class="btnType blue" id="btnDelete" name="btn"><span>신청취소</span></a>
					</span> 
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div> 
</form>
						
</body>
</html>