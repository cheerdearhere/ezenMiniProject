package com.kook.ezenPJT.naver;

import com.github.scribejava.core.builder.api.DefaultApi20;

public class NaverLoginApi extends DefaultApi20 {
	//기본 생성자
	protected NaverLoginApi() {
	}
	
	//login api를 상수로 지정해 캡슐화
	private static class InstanceHolder{
		private static final NaverLoginApi INSTANCE = new NaverLoginApi();
	}
	public static NaverLoginApi instance() {
		return InstanceHolder.INSTANCE;
	}
	
	//DefaultApi20 class에서 상속받은 abstract method
	@Override
	public String getAccessTokenEndpoint() {
		return "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code";
	}
	@Override
	protected String getAuthorizationBaseUrl() {
		return "https://nid.naver.com/oauth2.0/authorize";
	}

}
