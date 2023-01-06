package kr.happyjob.study.admsst.model;

public class FileuploadModel {
	
	public int getBd_no() {
		return bd_no;
	}
	public void setBd_no(int bd_no) {
		this.bd_no = bd_no;
	}
	public String getBd_title() {
		return bd_title;
	}
	public void setBd_title(String bd_title) {
		this.bd_title = bd_title;
	}
	public String getLoginID() {
		return loginID;
	}
	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}
	public String getBd_contents() {
		return bd_contents;
	}
	public void setBd_contents(String bd_contents) {
		this.bd_contents = bd_contents;
	}
	public String getBd_date() {
		return bd_date;
	}
	public void setBd_date(String bd_date) {
		this.bd_date = bd_date;
	}
	public int getBd_type() {
		return bd_type;
	}
	public void setBd_type(int bd_type) {
		this.bd_type = bd_type;
	}
	public int getAtt_no() {
		return att_no;
	}
	public void setAtt_no(int att_no) {
		this.att_no = att_no;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getAtt_ori() {
		return att_ori;
	}
	public void setAtt_ori(String att_ori) {
		this.att_ori = att_ori;
	}
	public String getAtt_nli() {
		return att_nli;
	}
	public void setAtt_nli(String att_nli) {
		this.att_nli = att_nli;
	}
	public String getAtt_mul() {
		return att_mul;
	}
	public void setAtt_mul(String att_mul) {
		this.att_mul = att_mul;
	}
	public int getAtt_size() {
		return att_size;
	}
	public void setAtt_size(int att_size) {
		this.att_size = att_size;
	}
	private int bd_no;  //게시글 번호
	private String bd_title; //게시글 제목
	private String loginID; //게시글 작성자
	private String bd_contents; //게시글 내용
	private String bd_date; //게시글 날짜
	private int bd_type; //게시글 분류
	private int att_no; // 파일 번호
	private String name; 
	private String att_ori; //파일 원본명
	private String att_nli; //파일 논리 경로
	private String att_mul; //파일 물리 경로
	private int att_size; //파일 사이즈
}
