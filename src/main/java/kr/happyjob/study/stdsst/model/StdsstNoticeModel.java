package kr.happyjob.study.stdsst.model;

import java.sql.Date;

public class StdsstNoticeModel {
	
	private int bd_no; 
    private String bd_title; 
    private String loginID; 
    private String bd_contents;
    private Date bd_date; 
    private int bd_type;
    private int att_no;
    private int bd_cnt;
    
   
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
	public Date getBd_date() {
		return bd_date;
	}
	public void setBd_date(Date bd_date) {
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
	public int getBd_cnt() {
		return bd_cnt;
	}
	public void setBd_cnt(int bd_cnt) {
		this.bd_cnt = bd_cnt;
	}
	
    
    

}
