package com.kook.ezenPJT.dto;

import java.sql.Timestamp;

public class RecipeOrderDto {
	private int rOid;//PK. 시퀀스 넘버 적용
	private int rPid;//상품번호
	private String rOuser;
	private int rOquanty;
	private String rOphoneNo;
	private String rOuserAddr;
	private String rOtitle;
	private int rOprice;
	private int rOtotal;
	private Timestamp rOdate;//spl소속, 시간정보 포함
	
	public RecipeOrderDto() {
		super();
		// TODO Auto-generated constructor stub
	}

	public RecipeOrderDto(int rOid, int rPid, String rOuser, int rOquanty, String rOphoneNo, String rOuserAddr,
			String rOtitle, int rOprice, int rOtotal, Timestamp rOdate) {
		super();
		this.rOid = rOid;
		this.rPid = rPid;
		this.rOuser = rOuser;
		this.rOquanty = rOquanty;
		this.rOphoneNo = rOphoneNo;
		this.rOuserAddr = rOuserAddr;
		this.rOtitle = rOtitle;
		this.rOprice = rOprice;
		this.rOtotal = rOtotal;
		this.rOdate = rOdate;
	}

	public int getrOid() {
		return rOid;
	}

	public void setrOid(int rOid) {
		this.rOid = rOid;
	}

	public int getrPid() {
		return rPid;
	}

	public void setrPid(int rPid) {
		this.rPid = rPid;
	}

	public String getrOuser() {
		return rOuser;
	}

	public void setrOuser(String rOuser) {
		this.rOuser = rOuser;
	}

	public int getrOquanty() {
		return rOquanty;
	}

	public void setrOquanty(int rOquanty) {
		this.rOquanty = rOquanty;
	}

	public String getrOphoneNo() {
		return rOphoneNo;
	}

	public void setrOphoneNo(String rOphoneNo) {
		this.rOphoneNo = rOphoneNo;
	}

	public String getrOuserAddr() {
		return rOuserAddr;
	}

	public void setrOuserAddr(String rOuserAddr) {
		this.rOuserAddr = rOuserAddr;
	}

	public String getrOtitle() {
		return rOtitle;
	}

	public void setrOtitle(String rOtitle) {
		this.rOtitle = rOtitle;
	}

	public int getrOprice() {
		return rOprice;
	}

	public void setrOprice(int rOprice) {
		this.rOprice = rOprice;
	}

	public int getrOtotal() {
		return rOtotal;
	}

	public void setrOtotal(int rOtotal) {
		this.rOtotal = rOtotal;
	}

	public Timestamp getrOdate() {
		return rOdate;
	}

	public void setrOdate(Timestamp rOdate) {
		this.rOdate = rOdate;
	}
	
}
