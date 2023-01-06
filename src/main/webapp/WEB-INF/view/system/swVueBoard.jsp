<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<!-- abc -->
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>파일업로드 샘플</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
    
    var pagesize = 10;
    var pagenumsize = 5;
   
	/* Vue 객체들 */   
	
	//게시글 목록
    var boardList;
	//게시글 검색
    var searchFunction;
	//게시글 등록 시 파일 미첨부
    var nofilepopup;
	//게시글 등록 시 파일 첨부
    var filepopup;
    
	/** OnLoad event */ 
	$(function() {
		
		init(); // vue 객체 생성 및 초기화
		
		listsearch(); // 전체 게시글 조회 or 파라미터로 페이지 번호 받아서 게시글 조회
		
		comcombo("GRADE", "samplecom", "all", ""); //commonAjax.js에 정의된 공통 함수
		
		fRegisterButtonClickEvent();
	});
    
	/** 버튼 이벤트 등록 */
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();

			//.attr()은 요소(element)의 속성(attribute)의 값을 가져오거나 속성을 추가한다.
			var btnId = $(this).attr('id');
			
			switch (btnId) {
				case 'btnSearch' :
					listsearch();
					break;
				case 'btnSave' :
					fsavefileupload();
					break;	
				case 'btnDelete' :
					//$("#action").val("D");
					nofilepopup.action = "D";
					alert("삭제되었습니다.")
					fsavefileupload();
					break;	
				case 'btnSavefile' :
					fsavefileuploadatt();
					break;		
				case 'btnDeletefile' :
					$("#action").val("D");
					fsavefileuploadatt();
					break;		
				case 'btnClose' :
					gfCloseModal();
					break;
				case 'btnClosefile' :
					gfCloseModal();
					break;
			}
		});
	}
	

	
	function init() {
		
    	
    	boardList = new Vue({
								el : '#divfileuploadList',
								data : {
				
										listitem : [],
										pagenavi : ""
				
								},
								methods : {
									
									selectOne : function(no){
										//fPopModal();
									fn_selectone(no);
									},
									
									selectOneFile : function(no){
									fn_selectonefile(no)
									}
									
						
								}
			
		})
    	
    	
    	searchFunction = new Vue({
					    		el : '#searcharea',
								data : {
									searchtype :"",
									searchvalue :""
										
					
								},
						
    		
    	})
    	
    	nofilepopup = new Vue({
    							el : '#layer1',
    							data : {
    								
   									  title : "",
                          	          cont : "",
                          	          action : "",
                          	          no : 0,
                          	          delshow:true
    							},
    							
    	})	
    	
    	filepopup = new Vue({
    							el:'#layer2',
    							data : {
    								titlefile : "",
    								contfile: "",
    								disdownload :"",
    								dispreview :"",
    								action:"",
    								no :0,
    								delshow : true
    							},
    							methods : {
    								fpreview : function(event){
    									
    									var image = event.target;
    								}
    							}
    	})		
		
		
		
	}
	
	/*파라미터로 page번호 받아와서 해당 페이지 게시글 조회하는 함수
	파라미터 없이 listsearch() 호출 시 null값이 인자로 들어와 전체 게시글 조회*/
	function listsearch(pagenum) {
		
		/* if(pagenum==null || pagenum==''){
			pagenum =1;
		} */
		pagenum = pagenum || 1;
		
		var param= {
				pagenum : pagenum,
				pagesize : pagesize,
				searchvalue : searchFunction.searchvalue,
				searchtype : searchFunction.searchtype
				
				
		}
		
		var callListSearch = function(returndata){
			
			boardList.listitem= returndata.searchlist;
			
		 var paginationHtml = getPaginationHtml(pagenum, returndata.searchlistcnt, pagesize, pagenumsize, 'listsearch');
			console.log("paginationHtml : " + paginationHtml);
			
			boardList.pagenavi = paginationHtml; 
			
		}
		
		//callAjax("/admsst/swboardList.do", "post", "json", true, param, callListSearch);
		callAjax('/admsst/listFileuploadvue.do','post','json',true,param,callListSearch);
		
		
		
		
	}
	
	
	//===============================================================
	/*파일 미첨부   팝업 처리  시작 
	<a	 class="btnType blue" href="javascript:fPopModal();" name="modal"><span>신규등록</span></a>
	*/	
	function fPopModal() {
		
		fn_forminit();
		//layer1번 id 값을 갖는 html 태그 아래 모달 템플릿을 띄운다.
		gfModalPop("#layer1");
		
		
		
	}
	
	/*callAjax를 통해 받아온 data에 따라 처음 작성한 게시글인지, 게시글의 수정인지 판단하여 모달창을 보여줌. action값을 지정함.
	   처음 게시글 작성시 기본 데이터 x , 게시글 수정시 데이터 불러와서 보여줌.*/
	function fn_forminit(data) {
		
		
		if(data==null || data==""){
			nofilepopup.title = "";
			nofilepopup.cont = "";
			nofilepopup.no="";
			nofilepopup.action = "I";
			nofilepopup.delshow=false;
			
		}else{
			nofilepopup.title = data.bd_title;
			nofilepopup.cont = data.bd_contents;
			nofilepopup.no = data.bd_no;
			nofilepopup.action = "U";
			nofilepopup.delshow=true;


			
		}
				
		
		
	}
	
	/*게시글 저장 버튼 누르면 저장(수정, 등록 모두 똑같이 동작)*/
	function fsavefileupload() {
		
		
		
		var param = {
				
				//넘겨주는 parameter 값은 mapper에서 {title} 이렇게 사용!!
				title : nofilepopup.title,
				cont : nofilepopup.cont,
				action : nofilepopup.action,
				bd_no : nofilepopup.no
				
		}
		
		
		var callInsertData = function(returndata){
			
			if(returndata.result =="SUCESS"){
				if(returndata.action=="I"){
				alert("저장완료!")
				}else if(returndata.action=="U"){
					alert("수정완료")
				}
				gfCloseModal();
			}
			
			listsearch();	
			
		}
		
	
		//callAjax("/admsst/saveFileupload.do", "post", "json", true, param, callInsertData);
		callAjax("/admsst/saveFileupload.do", "post", "json", true, param, callInsertData);
		
		
		
	}
	
	/*게시글 제목 눌렀을 때 실행되는 함수 */
	function fn_selectone(no) {
		
		
		var param = {
				bd_no : no
		}
		
		var callOneSearch = function(returndata){
			
			fn_forminit(returndata.searchone);
			gfModalPop("#layer1");
			
		}
		
		
		//callAjax("/admsst/swOneBoardList.do", "post", "json", true, param, callOneSearch);
		callAjax("/admsst/selectFileupload.do", "post", "json", true, param, callOneSearch);
		
		
		
	} 
	/*  파일 미첨부   팝업 처리  끝	 */
	
	
	
	//========================================================
		
	/*  파일 첨부   팝업 처리  시작 */
	function fPopModalfile() {
		
		fn_forminitfile();
		gfModalPop("#layer2");
		
		
	
	}
	/* 모달 창 띄우기*/
	function fn_forminitfile(object) {
		
		if(object ==null || object ==""){
			
			filepopup.titlefile ="";
			filepopup.confile ="";
			filepopup.no ="";
			filepopup.action ="I";
			filepopup.disdownload ="";
			filepopup.dispreview="";
			
			filepopup.delshow = false;
		
		}else {
			filepopup.titlefile =object.title;
			filepopup.confile ="";
			filepopup.no ="";
			filepopup.action ="I";
			filepopup.disdownload ="";
			filepopup.dispreview="";
			
			filepopup.delshow = true;
			
	        //만약에 파일이 있으면
	        if(object.att_no != "0") {
	        	 var orifile = object.att_nli;     	   // 파일 원본 
				 var orifilearr = orifile.split(".");  // 파일명과 확장자 나눈다.
					
	             var ext = orifilearr[1]; //확장자만 찾아온다. 
	             
	             //확장자가 대문자로 넘어오면 인식하지 못 하기 때문에 toLowerCase()로 무조건 소문자로 바꿔온다.
	             if(ext.toLowerCase() == "jpg" || ext.toLowerCase() == "png" || ext.toLowerCase() == "gif") {
	                  filepopup.dispreview = "<img src='" + object.att_nli + "''>";
	              } else {
	                  filepopup.dispreview = "";
	              }
				   
				   filepopup.disdownload = "<a href='javascript:download()'>" + object.att_ori + "("  + object.att_size+ ")</a>"; 
				   
				   
	        } else {
	        	filepopup.dispreview = "";
	        	filepopup.disdownload = "";
	        }
		}
		
	}
	
	
	// 단건조회 액션
	/* 게시글 제목을 눌렀을 때 실행되는 함수 */
	function fn_selectonefile(no) {
		
	
		
	} 
	
	
	function fsavefileuploadatt() {
		
	
	}
	
	function download() {
		
		
	}	
	
	/*파일 첨부   팝업 처리  끝 */
	
</script>

</head>

<body>
<form id="myForm" action=""  method="">
	<input type="hidden" id="hclickpagenum" name="hclickpagenum"  value="" />
	<input type="hidden" id="action" name="action"  value="" />
	<input type="hidden" id="bd_no" name="bd_no"  value="" />
	
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
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">게시판</span> <a href="../system/swVueBoard.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>게시판</span> <span class="fr"> 
							    <a	 class="btnType blue" href="javascript:fPopModal();"  name="modal"><span>신규등록</span></a>
							    <a	 class="btnType blue" href="javascript:fPopModalfile();" name="modal"><span>신규등록(파일)</span></a>
							</span>
						</p>
						
						<div id="searcharea">
							<table style="margin-top: 10px" width="100%" cellpadding="5" cellspacing="0" border="1"  align="left"   style="collapse; border: 1px #50bcdf;">
		                        <tr style="border: 0px; border-color: blue">
		                           <td width="50" height="25" style="font-size: 100%; text-align:left; padding-right:25px;">
		                                  <select id="samplecom"  style="width: 150px;">
										</select> 
										
			     	                      <select id="searchtype" name="searchtype" v-model="searchtype" style="width: 150px;" >
			     	                            <option value="" >전체</option>
												<option value="seq" >순번</option>
												<option value="title" >제목</option>
												<option value="writer" >작성자</option>
										</select> 
									
		     	                       <input type="text" style="width: 300px; height: 25px;" id="searchvalue" name="searchvalue" v-model="searchvalue">                    
			                           <a href="" class="btnType blue" id="btnSearch" name="btn"><span>검  색</span></a>
		                           </td> 
		                           
		                        </tr>
	                        </table> 
                        </div>
                        
                        
                        <!-- 게시판의 게시글 목록 테이블  -->
						<div id="divfileuploadList">
							<table class="col">
								<caption>caption</caption>
								<colgroup>
									<col width="10%">
									<col width="40%">
									<col width="25%">
									<col width="25%">
								</colgroup>
	
								<thead>
									<tr>
										<th scope="col" >순번</th>
										<th scope="col">제목</th>
										<th scope="col">작성자</th>
										<th scope="col">작성일</th>
									</tr>
								</thead>
								<!-- vue에 게시글 목록을 받아올 객체 생성 후 on_load 함수에서 db의 목록을 받아  listitem 저장함 ( listsearch()함수에서 실행)-->
								<tbody id="listfileupload" v-for="(item,index) in listitem" >
								     <tr>
								         <td @click="selectOne(item.bd_no)"> {{ item.bd_no }}  </td>
								         <td> {{ item.bd_title }}  </td>
								         <td> {{ item.loginID }}  </td>
								         <td> {{ item.bd_date }}  </td>
								     </tr>    
								</tbody>
							</table>
							
							<div class="paging_area"  id="comnfileuploadPagination" v-html="pagenavi"> </div>
						</div>
	
						
						
						
						
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>

	<!-- 모달팝업 -->
	<div id="layer1" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>글 작성</strong>
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
							<th scope="row">제목 <span class="font_red" >*</span></th>
							<td><input type="text" class="inputTxt p100" name="title" id="title" v-model ="title" /></td>
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red" >*</span></th>
							<td>
							     <textarea class="inputTxt p100"	name="cont" id="cont" v-model ="cont"  > </textarea>
						   </td>
						</tr>
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->
				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
					<!-- show는 지정한 속성 즉 delshow가 true일때만 보이게 된다. -->
					<a href="" class="btnType blue" id="btnDelete" name="btn" v-show="delshow"><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

	<div id="layer2" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>글 작성(파일)</strong>
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
							<th scope="row">제목 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" name="titlefile" id="titlefile"     /></td>
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td>
							     <textarea class="inputTxt p100"	name="contfile" id="contfile"   > </textarea>
						   </td>
						</tr>
						<tr>
							<th scope="row">파일 <span class="font_red">*</span></th>
							<td>
							     <input type="file" id="upfile" name="upfile"   />
						   </td>
						</tr>
						<tr>
							<th scope="row">파일 다운로드<span class="font_red">*</span></th>
							<td>
							     <div id="filedownloaddiv" > </div>
						   </td>
						</tr>						
						<tr>
							<th scope="row">파일 미리보기<span class="font_red">*</span></th>
							<td>
							     <div id="filepewviewdiv" > </div>
						   </td>
						</tr>								
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSavefile" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeletefile" name="btn" ><span>삭제</span></a> 
					<a href=""	class="btnType gray"  id="btnClosefile" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>

	<!--// 모달팝업 -->
</form>
</body>
</html>