package com.kook.ezenPJT.naver;

import java.io.IOException;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.util.StringUtils;

import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

public class NaverLoginBO {
	//client id와 secret은 naver developer에서 받음
	private final static String CLIENT_ID="k38iZBy97xMbHmi43gq1";
	private final static String CLIENT_SECRET="VVmO_Er9JR";
	//콜백 uri와 session 명칭
	private final static String REDIRECT_URI = "https://localhost:8443/ezenPJT/nredirect";
	private final static String SESSION_STATE ="oauth_state";
	//프로필 조회 API URL
	private final static String PROFILE_API_URL = "https://openapi.naver.com/v1/nid/me";
	//naver id로 authentication URL 생성method
	public String getAuthorizationUrl(HttpSession session) {
		//세션 유효성 검증을 위한 난수 생성 method 사용
		String state = generateRandomString();
		//session에 저장하는 method사용
		setSession(session, state);
		//Scribe에서 제공하는 인증 URL 생성기능을 이용해 네이버 인증 URL을 생성하는 체인
		OAuth20Service oauthService = new ServiceBuilder()
				.apiKey(CLIENT_ID)
				.apiSecret(CLIENT_SECRET)
				.callback(REDIRECT_URI)
				.state(state)
				.build(NaverLoginApi.instance());
		return oauthService.getAuthorizationUrl();
	}
	//난수 만들기용 method
	private String generateRandomString() {
		/*java.util.UUID: 파일 저장시 중복을 피하기 위한 유일값을 생성하는 클래스
		GUID, currentTimeMills와 유사한 기능을함.*/
		return UUID.randomUUID().toString();
	}
	//session에 난수를 저장하는 method
	private void setSession(HttpSession session, String state) {
		session.setAttribute(SESSION_STATE, state);
	}
	
	//naver id로 redirect처리 및 AccessToken 획득 method
	public OAuth2AccessToken getAccessToken(HttpSession session, String code, String state) throws IOException{
		String sessionState = getSession(session);
		if(StringUtils.pathEquals(sessionState, state)) {
			OAuth20Service oauthService = new ServiceBuilder()
					.apiKey(CLIENT_ID)
					.apiSecret(CLIENT_SECRET)
					.callback(REDIRECT_URI)
					.state(state)
					.build(NaverLoginApi.instance());
			//Scribe에서 제공하는 AccessToken 획득 기능으로 naver log용 Access Token획득
			OAuth2AccessToken accessToken = oauthService.getAccessToken(code);
			return accessToken;
		}
		else {
			return null;
		}
	}
	//http session을 반환 
	private String getSession(HttpSession session) {
		return (String)session.getAttribute(SESSION_STATE);
	}
	//Access Token을 이용해 네이버 사용자 프로필 API를 호출
	public String getUserProfile(OAuth2AccessToken oauthToken) throws IOException{
		OAuth20Service oauthService = new ServiceBuilder()
				.apiKey(CLIENT_ID)
				.apiSecret(CLIENT_SECRET)
				.callback(REDIRECT_URI)
				.build(NaverLoginApi.instance());
		OAuthRequest request = new OAuthRequest(Verb.GET, PROFILE_API_URL, oauthService);
		oauthService.signRequest(oauthToken, request);
		Response response = request.send();
		return response.getBody();
	}
}
