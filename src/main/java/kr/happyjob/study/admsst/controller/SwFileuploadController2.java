package kr.happyjob.study.admsst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.admsst.model.FileuploadModel;
import kr.happyjob.study.admsst.service.SwFileuploadService2;

@Controller
@RequestMapping("/admsst/")
public class SwFileuploadController2 {
	
	
	// Set logger
		private final Logger logger = LogManager.getLogger(this.getClass());
	
	@Autowired
	SwFileuploadService2 swfileuploadService;
	
	
	//게시글 목록 조회 전체
	@RequestMapping("swboardList.do")
	@ResponseBody
	public Map<String, Object> swboardList(Model model, @RequestParam Map<String,Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("controller start");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("result", "SUCESS");
		
		
		int clickpagenum = Integer.parseInt( String.valueOf(paramMap.get("pagenum"))) ;   
		int pagesize = Integer.parseInt( String.valueOf(paramMap.get("pagesize"))) ;  
		int startnum = (clickpagenum - 1) * pagesize;
		
		paramMap.put("startnum", startnum);
		paramMap.put("pagesize", pagesize);
		
		List<FileuploadModel> searchlist = swfileuploadService.listFileupload(paramMap);
		
		resultMap.put("searchlist", searchlist);
		
		
//		limit #{startnum},#{pagesize}
		
		int searchlistcnt = swfileuploadService.searchlistcnt(paramMap);
		resultMap.put("searchlistcnt", searchlistcnt);
		
		return resultMap;
	
	
	}
	
	
	//게시글 단건 조회
	@RequestMapping("swOneBoardList.do")
	@ResponseBody
	public Map<String, Object> swOneBoardList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		
		FileuploadModel searchone = swfileuploadService.selectFileupload(paramMap);
		
		resultMap.put("searchone", searchone);
		
		return resultMap;
	}
	
	
	//게시글 삽입
	@RequestMapping("swUploadList.do")
	@ResponseBody
	public Map<String, Object> swUploadList(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("paramMap = " + paramMap);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		//세션에서 가져온 값은 Object형태로 저장된다.  
		String loginId =String.valueOf(session.getAttribute("loginId"));
		//paramMap의 value 값 형태는 Object이다.
		String action = String.valueOf(paramMap.get("action"));
		
		paramMap.put("loginId", loginId);
		
		if("I".equals(action)){
			swfileuploadService.insertFileupload(paramMap);
		}else if("U".equals(action)) {
			swfileuploadService.updateFileupload(paramMap);
		}else if("D".equals(action)) {
			swfileuploadService.deleteFileupload(paramMap);
		}
		
		resultMap.put("result", "SUCESS");
		resultMap.put("action", action);
		
		
		return resultMap;
		
	}
	
	
	
	
	
	
	
}  
