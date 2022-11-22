package com.kook.ezenPJT.dto;

import java.sql.Timestamp;

public class EzenJoinDto {
	private String pid;
	private String ppw;
	private String paddress;
	private String phobby;
	private String pprofile;
	private Timestamp pdate;
	private String auth;
	public EzenJoinDto() {
		super();
	}
	public EzenJoinDto(String pid, String ppw, String paddress, String phobby, String pprofile, Timestamp pdate,
			String auth) {
		super();
		this.pid = pid;
		this.ppw = ppw;
		this.paddress = paddress;
		this.phobby = phobby;
		this.pprofile = pprofile;
		this.pdate = pdate;
		this.auth = auth;
	}
	//authAdmin
	public EzenJoinDto(String pid, String auth) {
		super();
		this.pid = pid;
		this.auth = auth;
	}
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	public String getPpw() {
		return ppw;
	}
	public void setPpw(String ppw) {
		this.ppw = ppw;
	}
	public String getPaddress() {
		return paddress;
	}
	public void setPaddress(String paddress) {
		this.paddress = paddress;
	}
	public String getPhobby() {
		return phobby;
	}
	public void setPhobby(String phobby) {
		this.phobby = phobby;
	}
	public String getPprofile() {
		return pprofile;
	}
	public void setPprofile(String pprofile) {
		this.pprofile = pprofile;
	}
	public Timestamp getPdate() {
		return pdate;
	}
	public void setPdate(Timestamp pdate) {
		this.pdate = pdate;
	}
	public String getAuth() {
		return auth;
	}
	public void setAuth(String auth) {
		this.auth = auth;
	}
}
