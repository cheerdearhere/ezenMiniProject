package com.kook.ezenPJT.dto;

public class RecipeDto {
	private int rId;
	private String rClass;
	private String rtrName;
	private String rTitle;
	private String rPhoto;
	private String rContent;
	private int rPrice;
	private String rAddress;
	public RecipeDto() {
		super();
		// TODO Auto-generated constructor stub
	}
	public RecipeDto(int rId, String rClass, String rtrName, String rTitle, String rPhoto, String rContent, int rPrice,
			String rAddress) {
		super();
		this.rId = rId;
		this.rClass = rClass;
		this.rtrName = rtrName;
		this.rTitle = rTitle;
		this.rPhoto = rPhoto;
		this.rContent = rContent;
		this.rPrice = rPrice;
		this.rAddress = rAddress;
	}
	public int getrId() {
		return rId;
	}
	public void setrId(int rId) {
		this.rId = rId;
	}
	public String getrClass() {
		return rClass;
	}
	public void setrClass(String rClass) {
		this.rClass = rClass;
	}
	public String getRtrName() {
		return rtrName;
	}
	public void setRtrName(String rtrName) {
		this.rtrName = rtrName;
	}
	public String getrTitle() {
		return rTitle;
	}
	public void setrTitle(String rTitle) {
		this.rTitle = rTitle;
	}
	public String getrPhoto() {
		return rPhoto;
	}
	public void setrPhoto(String rPhoto) {
		this.rPhoto = rPhoto;
	}
	public String getrContent() {
		return rContent;
	}
	public void setrContent(String rContent) {
		this.rContent = rContent;
	}
	public int getrPrice() {
		return rPrice;
	}
	public void setrPrice(int rPrice) {
		this.rPrice = rPrice;
	}
	public String getrAddress() {
		return rAddress;
	}
	public void setrAddress(String rAddress) {
		this.rAddress = rAddress;
	}
	
}
