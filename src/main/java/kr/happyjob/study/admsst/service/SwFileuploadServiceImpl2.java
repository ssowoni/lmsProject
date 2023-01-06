package kr.happyjob.study.admsst.service;

import java.util.List;
import java.util.Map;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.happyjob.study.admsst.dao.SwFileuploadDao2;
import kr.happyjob.study.admsst.model.FileuploadModel;;

@Service
public class SwFileuploadServiceImpl2 implements SwFileuploadService2 {

	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	
	@Value("${fileUpload.rootPath}")
	private String rootPath;
	
	@Value("${fileUpload.noticePath}")
	private String noticePath;
	
	@Value("${fileUpload.virtualRootPath}")
	private String virtualRootPath;
		
	@Autowired
	SwFileuploadDao2 swFileuploadDao;

	
	
	//게시글 목록 조회
	public List<FileuploadModel> listFileupload(Map<String, Object> paramMap) throws Exception {
		List<FileuploadModel> result = swFileuploadDao.listFileupload(paramMap);
		return result;
		
	}



	//게시글 총 개수
	public int searchlistcnt(Map<String, Object> paramMap) throws Exception {
		return swFileuploadDao.searchlistcnt(paramMap);
	}



	//게시글 단건 조회
	@Override
	public FileuploadModel selectFileupload(Map<String, Object> paramMap) throws Exception {
		return swFileuploadDao.selectFileupload(paramMap);
	}



	//게시글 삽입 
	@Override
	public void insertFileupload(Map<String, Object> paramMap) throws Exception {
		
		paramMap.put("fileyn", "N");
    	paramMap.put("filepro", "N");
		swFileuploadDao.insertFileupload(paramMap);
		
		
	}


	//게시글 수정
	@Override
	public void updateFileupload(Map<String, Object> paramMap) throws Exception {

		paramMap.put("fileyn", "N");
    	paramMap.put("filepro", "N");
		swFileuploadDao.updateFileupload(paramMap);
	}



	//게시글 삭제 
	@Override
	public void deleteFileupload(Map<String, Object> paramMap) throws Exception {

		swFileuploadDao.deleteFileupload(paramMap);
	}
    
}
