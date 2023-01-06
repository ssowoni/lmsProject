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
    var listnoticevue;
	//게시글 검색
    var sraecharea;
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
		
		//자바스크립트에서 listnoticevue.listitem, listnoticevue.pagenavi 이렇게 사용하기 위해 객체를 생성해준다. 
		listnoticevue = new Vue({
									//el : 어떤 요소에 적용할 지 정한다. HTML 코드에 선언된 id값이 divfileuploadList인 div 태그에 적용된다.
                                      el : "#divfileuploadList",
	                               data : { //data는 해당 VueJS에서 사용할 정보를 선언해주는 역할 Object 형태로 정보를 가지고 있다. 
	                            	   		//정보 선언 후 초기화 해주는 것.
	                            	   		//listitem은 게시글 조회 후 배열에 담는다.
	                            	           listitem : [],
	                            	           //pagenavi는 하단에 페이지 번호
                                               pagenavi : ""
	                               },
	                               //정보를 저장하는 저장소가 data라면 method는 함수를 저장하고 있는 곳이다. 
	                               methods : {
	                            	   ////id값이 divfileuploadList인 div 태그 하위에 td로 게시글 목록 조회할 때 아래 함수 쓴다. 
	                            	   //  <td @click="detailview(item.bd_no)">
	                            	   //게시글 순번 클릭 시 실행
	                            	   detailview : function(no) {
	                            		        //alert(no);
	                            		        fn_selectone(no);	
	                            	   },
	                            	   //@click은 버튼을 눌렀을 때 해당 함수가 실행된다는 의미이다. 
	                            	   //<td @click="detailviewfile(item.bd_no)"> {{ item.bd_title }}  </td>
	                            	   //게시글 제목 눌렀을 때 실행 
	                            	   detailviewfile : function(no) {
                            		        //alert(no);
                            		        fn_selectonefile(no);	
                            	       }
	                            	   
	                            	   
	                               }
		})
		
		sraecharea = new Vue({
                                    el : "#sraecharea",
                                 data : {
                                	   searchKey : "",
                                	 searchvalue : "",
                                	 samplecom : ""
                                 }     
			
		})
		
		nofilepopup = new Vue({
	                                 el : "#layer1",
	                              data : {
	                            	          title : "",
	                            	          cont : "",
	                            	          action : "",
	                            	          no : 0,
	                            	          delshow : false
	                              }        
		})
		
		filepopup = new Vue({
			  el : "#layer2",
              data : {
            	          titlefile : "",
            	          contfile: "",
            	          disdownload: "",
            	          dispreview: "",
            	          action : "",
            	          no : 0,
            	          delshow : false
              },
              methods : {
            	  fpreview : function(event) {
            		  var image = event.target;
            		  
            		  //event.target인 input 태그에 파일이 있는 경우 아래 문장 실행.
            			 if(image.files[0]){
            				 //blob:http://localhost/d0ba26d2-a8a6-47fa-9e44-35e79250fd36 : C:\fakepath\캡처.PNG
            				  alert(window.URL.createObjectURL(image.files[0]) + " : " + $("#upfile").val() );
            				   var imgpath =  window.URL.createObjectURL(image.files[0]);
            				  
            				   var inputhtml = "";
            				   
            				   var orifile = $("#upfile").val();    
            				   var orifilearr = orifile.split(".");  
            					
            		             var ext = orifilearr[1];
            		             
            		             if(ext.toLowerCase() == "jpg" || ext.toLowerCase() == "png" || ext.toLowerCase() == "gif") {
            		            	 //v-html을 사용해서 파일 미리보기에 저장되어있는 파일을 불러온다.  att_nli는 파일의 논리 경로 
            		            	 ///serverfile\notice\메이플.jpg, X:\FileRepository\notice\메이플.jpg
            		                  filepopup.dispreview = "<img src='" + object.att_nli + "''>";
            		               } else {
            		                  filepopup.dispreview = "";
            		               }
            				   
            		           //this는 vue를 가리키는 마법의 단어. 즉) this.dispreview는 vue에 정의된 dispreview를 가져오라는 의미이다.
            		           //this는 data내의 값을 불러올때와 메서드의 함수를 불러올때도 사용된다.
            				   this.dispreview = inputhtml;
            				   //$("#filepewviewdiv").empty().append(inputhtml);
            			 }            		  
            	  }
            	  
              }
		})
		
	}
	
	/*파라미터로 page번호 받아와서 해당 페이지 게시글 조회하는 함수
	파라미터 없이 listsearch() 호출 시 null값이 인자로 들어와 전체 게시글 조회*/
	function listsearch(pagenum) {
		
		//만약 pagenum에 값이 없으면 1페이지를 저장해라.
		pagenum = pagenum || 1;
		
		console.log("sraecharea.searchKey : " + sraecharea.searchKey + " sraecharea.searchvalue : " + sraecharea.searchvalue);

		//파라미터로 컨트롤러에 전달할 값들.
		var param = {
				pagenum : pagenum,
				pagesize : pagesize,
				searchtype : sraecharea.searchKey,
				searchvalue : sraecharea.searchvalue
		}
		
		// 
		var listcallback = function(returndata) {
			//컨트롤러를 통해 조회된 데이터들을 returndata에 담는다. 
			console.log(  "listcallback " + JSON.stringify(returndata) );
			
			//vue 객체로 생성한 listnoticevue 객체의 listitem 데이터에, 리턴 받은 값 중 searchlist의 값을 가져와 저장한다.
			//컨트롤러 코드 : model.addAttribute("searchlistcnt", searchlistcnt);
			listnoticevue.listitem = returndata.searchlist;
			
			var paginationHtml = getPaginationHtml(pagenum, returndata.searchlistcnt, pagesize, pagenumsize, 'listsearch');
			console.log("paginationHtml : " + paginationHtml);
			
			listnoticevue.pagenavi = paginationHtml;
			
		}
		
		callAjax("/admsst/listFileuploadvue.do", "post", "json", true, param, listcallback);
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
		
		if (data == null || data=="") {
			nofilepopup.title = "";
			nofilepopup.cont = "";
			nofilepopup.no = ""
			nofilepopup.action = "I";
			
			//삭제 버튼, delshow 가 true 일때만 보인다.
			nofilepopup.delshow = false;
		} else {
			nofilepopup.title = data.bd_title;
			nofilepopup.cont = data.bd_contents;
			nofilepopup.no = data.bd_no;
			nofilepopup.action = "U";			
			
			//삭제 버튼
			nofilepopup.delshow = true; //수정시에만 삭제 된다.
		}	
		
		//"bd_no":10,"bd_title":"file test   retest no att","loginID":"admin","bd_contents":"file test   retest no att","bd_date":"2022-10-27","bd_type":1,"att_no":0,"name":"admin","att_ori":null,"att_nli":null,"att_mul":null,"att_size":0}
	} 
	
	/*게시글 저장 버튼 누르면 저장 */
	function fsavefileupload() {
		
		var param = {
				title : nofilepopup.title ,
				cont : nofilepopup.cont,
				action : nofilepopup.action,
				bd_no : nofilepopup.no
				
		}
		
		//returndata : 컨트롤러에서 넘어온 데이터
		var listcallback = function(returndata) {
			console.log(  "listcallback " + JSON.stringify(returndata) );
			
			if(returndata.result == "SUCESS") {
				alert("저장 되었습니다.");
				
				gfCloseModal();
			}
			
			listsearch();
		}
		
		callAjax("/admsst/saveFileupload.do", "post", "json", true, param, listcallback);
		
	}
	
	/*게시글 제목 눌렀을 때 실행되는 함수 */
	function fn_selectone(no) {
		
		var param = {
				bd_no : no				
		}
		
		var selectoncallback = function(returndata) {
			console.log(  "listcallback " + JSON.stringify(returndata) );
			
			fn_forminit(returndata.searchone);
			
			gfModalPop("#layer1");
		}
		
		callAjax("/admsst/selectFileupload.do", "post", "json", true, param, selectoncallback);
		
	} 
	/*  파일 미첨부   팝업 처리  끝	 */
	
	
	//========================================================
	/*  파일 첨부   팝업 처리  시작 */
	function fPopModalfile() {
		
		fn_forminitfile();
		gfModalPop("#layer2");
		
	}
	/* 모달 창 띄우기*/
	//object는 컨트롤러를 통해 받아온 data 
	function fn_forminitfile(object) {
		
		if (object == null || object=="") {
			filepopup.titlefile = ""; //제목
			filepopup.contfile = ""; //내용
			filepopup.no = "";		//게시글 번호	
			filepopup.disdownload = ""; //파일 다운로드
			filepopup.dispreview = "";	//파일 미리보기
			filepopup.action = "I";   // 게시글 삽입
			
			$("#action").val("I");
			
			filepopup.delshow = false;
		} else {
			
			//"bd_no":10,"bd_title":"file test   retest no att","loginID":"admin","bd_contents":"file test   retest no att","bd_date":"2022-10-27","bd_type":1,"att_no":0,"name":"admin","att_ori":null,"att_nli":null,"att_mul":null,"att_size":0}
			// /sdsddsds/a.jpg
			// d:\fdfdfd\fdfdf\b.jpg
			filepopup.titlefile = object.bd_title; 
			filepopup.contfile = object.bd_contents;
			filepopup.no = object.bd_no;
			filepopup.action = "U";			
			
			$("#action").val("U");
			$("#bd_no").val(object.bd_no);
			
			
			filepopup.delshow = true;
			
	        //disdownload: "",
	        
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
		
		var param = {
				bd_no : no				
		}
		
		var selectoncallback = function(returndata) {
			console.log(  "listcallback " + JSON.stringify(returndata) );
			
			fn_forminitfile(returndata.searchone);
			
			gfModalPop("#layer2");
		}
		
		callAjax("/admsst/selectFileupload.do", "post", "json", true, param, selectoncallback);
		
	} 
	
	
	/*파일 첨부 게시글 삽입*/
	function fsavefileuploadatt() {
		
		var frm = document.getElementById("myForm");
		frm.enctype = 'multipart/form-data';
		var dataWithFile = new FormData(frm);
		
		
		
		
		var savecallback= function(rtn) {
			console.log(JSON.stringify(rtn));
			
			alert("저장 되었습니다.");
			
			gfCloseModal();
			
			var savepageno = 1;
			
			//if($("#action").val() == "U") {
			//	savepageno = $("#hclickpagenum").val();
			//}
			
			listsearch(savepageno);
			
		}
		
		callAjaxFileUploadSetFormData("/admsst/saveFileuploadatt.do", "post", "json", true, dataWithFile, savecallback);
	}
	
	function download() {
		
		var params = "<input type='hidden' name='bd_no' value='"+ filepopup.no +"' />";

		jQuery(
				"<form action='/admsst/downloadfile.do' method='post'>"
						+ params + "</form>").appendTo('body').submit().remove();
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
								class="btn_nav bold">학습관리</span> <span class="btn_nav bold">게시판</span> <a href="../system/comnCodMgr.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle">
							<span>게시판</span> <span class="fr"> 
							    <a	 class="btnType blue" href="javascript:fPopModal();" name="modal"><span>신규등록</span></a>
							    <a	 class="btnType blue" href="javascript:fPopModalfile();" name="modal"><span>신규등록(파일)</span></a>
							</span>
						</p>
						
						<div id="sraecharea">
							<table style="margin-top: 10px" width="100%" cellpadding="5" cellspacing="0" border="1"  align="left"   style="collapse; border: 1px #50bcdf;">
		                        <tr style="border: 0px; border-color: blue">
		                           <td width="50" height="25" style="font-size: 100%; text-align:left; padding-right:25px;">
		                                  <select id="samplecom"  style="width: 150px;" v-model="samplecom">
										</select> 
										
			     	                      <select id="searchtype" name="searchtype" style="width: 150px;" v-model="searchKey">
			     	                            <option value="" >전체</option>
												<option value="seq" >순번</option>
												<option value="title" >제목</option>
												<option value="writer" >작성자</option>
										</select> 
									
		     	                       <input type="text" style="width: 300px; height: 25px;" id="searchvalue" name="searchvalue"  v-model="searchvalue">                    
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
										<th scope="col">순번</th>
										<th scope="col">제목</th>
										<th scope="col">작성자</th>
										<th scope="col">작성일</th>
									</tr>
								</thead>
								<!-- vue에 게시글 목록을 받아올 객체 생성 후 on_load 함수에서 db의 목록을 받아  listitem 저장함 ( listsearch()함수에서 실행)-->
								<tbody id="listfileupload" v-for=" (item, index) in listitem" >
								     <tr>
								         <td @click="detailview(item.bd_no)"> {{ item.bd_no }}  </td>
								         <td @click="detailviewfile(item.bd_no)"> {{ item.bd_title }}  </td>
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
				<strong>글 편집</strong>
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
							<td><input type="text" class="inputTxt p100" name="title" id="title" v-model="title" /></td>
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td>
							     <textarea class="inputTxt p100"	name="cont" id="cont" v-model="cont" > </textarea>
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
				<strong>글 편집(파일)</strong>
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
							<td><input type="text" class="inputTxt p100" name="titlefile" id="titlefile"  v-model="titlefile"    /></td>
						</tr>
						<tr>
							<th scope="row">내용 <span class="font_red">*</span></th>
							<td>
							     <textarea class="inputTxt p100"	name="contfile" id="contfile" v-model="contfile"  > </textarea>
						   </td>
						</tr>
						<tr>
							<th scope="row">파일 <span class="font_red">*</span></th>
							<td>
							<!-- @click은 바로 함수가 실행되지만, @change는 값이 바뀌는 걸 인지 후에 실행된다. -->
							     <input type="file" id="upfile" name="upfile"  @change="fpreview(event)" />
						   </td>
						</tr>
						<tr>
							<th scope="row">파일 다운로드<span class="font_red">*</span></th>
							<td>
							     <div id="filedownloaddiv" v-html="disdownload"> </div>
						   </td>
						</tr>						
						<tr>
							<th scope="row">파일 미리보기<span class="font_red">*</span></th>
							<td>
							     <div id="filepewviewdiv" v-html="dispreview"> </div>
						   </td>
						</tr>								
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSavefile" name="btn"><span>저장</span></a> 
					<a href="" class="btnType blue" id="btnDeletefile" name="btn"  v-show="delshow"><span>삭제</span></a> 
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