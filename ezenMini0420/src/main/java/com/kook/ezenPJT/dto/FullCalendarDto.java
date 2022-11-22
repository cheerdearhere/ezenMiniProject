package com.kook.ezenPJT.dto;
//fullcalendar를 처리할 DTO

import java.sql.Timestamp;

public class FullCalendarDto {
	private int cNo;
	private String cId;
	private String cTitle;
	private String cStart;
	private String cEnd;
	private Timestamp tStart;
	private Timestamp tEnd;
	private String cAllDay;
	public FullCalendarDto() {
		super();
	}
	public FullCalendarDto(int cNo, String cId, String cTitle, String cStart, String cEnd, Timestamp tStart,
			Timestamp tEnd, String cAllDay) {
		super();
		this.cNo = cNo;
		this.cId = cId;
		this.cTitle = cTitle;
		this.cStart = cStart;
		this.cEnd = cEnd;
		this.tStart = tStart;
		this.tEnd = tEnd;
		this.cAllDay = cAllDay;
	}
	public int getcNo() {
		return cNo;
	}
	public void setcNo(int cNo) {
		this.cNo = cNo;
	}
	public String getcId() {
		return cId;
	}
	public void setcId(String cId) {
		this.cId = cId;
	}
	public String getcTitle() {
		return cTitle;
	}
	public void setcTitle(String cTitle) {
		this.cTitle = cTitle;
	}
	public String getcStart() {
		return cStart;
	}
	public void setcStart(String cStart) {
		this.cStart = cStart;
	}
	public String getcEnd() {
		return cEnd;
	}
	public void setcEnd(String cEnd) {
		this.cEnd = cEnd;
	}
	public Timestamp gettStart() {
		return tStart;
	}
	public void settStart(Timestamp tStart) {
		this.tStart = tStart;
	}
	public Timestamp gettEnd() {
		return tEnd;
	}
	public void settEnd(Timestamp tEnd) {
		this.tEnd = tEnd;
	}
	public String getcAllDay() {
		return cAllDay;
	}
	public void setcAllDay(String cAllDay) {
		this.cAllDay = cAllDay;
	}
	
}
