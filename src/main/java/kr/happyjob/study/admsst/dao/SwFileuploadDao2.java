package kr.happyjob.study.admsst.dao;

import java.util.List;
import java.util.Map;

import kr.happyjob.study.admsst.model.FileuploadModel;

public interface SwFileuploadDao2 {

	//게시글 전체 조회 
	public List<FileuploadModel> listFileupload(Map<String, Object> paramMap) throws Exception ;
	//게시글 총 개수
	public int searchlistcnt(Map<String, Object> paramMap) throws Exception;
	//게시글 단건 조회
	public FileuploadModel selectFileupload(Map<String, Object> paramMap) throws Exception ;
	
	
	//게시글 삽입
	public void insertFileupload(Map<String, Object> paramMap) throws Exception;
	//게시글 수정
	public void updateFileupload(Map<String, Object> paramMap) throws Exception;
	//게시글 삭제
	public void deleteFileupload(Map<String, Object> paramMap) throws Exception;
	
	
	//첨부파일 정보 삽입
	public void insertFileinfo(Map<String, Object> paramMap) throws Exception;
	//첨부파일 정보 삭제
	public void deleteFileinfobybdno(Map<String, Object> paramMap) throws Exception;
	
}
