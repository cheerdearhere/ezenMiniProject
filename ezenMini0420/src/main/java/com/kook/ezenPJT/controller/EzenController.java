package com.kook.ezenPJT.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.social.google.connect.GoogleConnectionFactory;
import org.springframework.social.oauth2.AccessGrant;
import org.springframework.social.oauth2.GrantType;
import org.springframework.social.oauth2.OAuth2Operations;
import org.springframework.social.oauth2.OAuth2Parameters;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.github.scribejava.core.model.OAuth2AccessToken;
import com.kook.ezenPJT.command.AuthCommand;
import com.kook.ezenPJT.command.CalendarDeleteCommand;
import com.kook.ezenPJT.command.CalendarInsertCommand;
import com.kook.ezenPJT.command.CalendarListCommand;
import com.kook.ezenPJT.command.CalendarUpdateCommand;
import com.kook.ezenPJT.command.DashBoardCommand;
import com.kook.ezenPJT.command.DashBoardWrite;
import com.kook.ezenPJT.command.EditorDetailCommand;
import com.kook.ezenPJT.command.EditorInsertCommand;
import com.kook.ezenPJT.command.EditorListCommand;
import com.kook.ezenPJT.command.EzenAdminAuthCommand;
import com.kook.ezenPJT.command.EzenBoardContentCommand;
import com.kook.ezenPJT.command.EzenBoardDeleteCommand;
import com.kook.ezenPJT.command.EzenBoardListCommand;
import com.kook.ezenPJT.command.EzenBoardModifyCommand;
import com.kook.ezenPJT.command.EzenBoardPageListCommand;
import com.kook.ezenPJT.command.EzenBoardReplyCommand;
import com.kook.ezenPJT.command.EzenBoardReplyViewCommand;
import com.kook.ezenPJT.command.EzenBoardSearchListCommand;
import com.kook.ezenPJT.command.EzenBoardWriteCommand;
import com.kook.ezenPJT.command.EzenCommand;
import com.kook.ezenPJT.command.EzenJoinCommand;
import com.kook.ezenPJT.command.EzenRecipeCommand;
import com.kook.ezenPJT.command.EzenRecipeDetailsCommand;
import com.kook.ezenPJT.command.EzenRecipeWriteCommand;
import com.kook.ezenPJT.command.RecipeOrderCommand;
import com.kook.ezenPJT.command.RecipeOrderListCommand;
import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.AuthUserDto;
import com.kook.ezenPJT.dto.DashBoardDto;
import com.kook.ezenPJT.dto.EditorDto;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.dto.FullCalendarDto;
import com.kook.ezenPJT.dto.RecipeDto;
import com.kook.ezenPJT.dto.RecipeOrderDto;
import com.kook.ezenPJT.naver.NaverLoginBO;
import com.kook.ezenPJT.util.Constant;

@Controller
public class EzenController {
	private EzenCommand com;
	
	//암호화 처리 bean 주입(보안 관련 공통 사용 요소)
	private BCryptPasswordEncoder passwordEncoder;
	@Autowired
	public void setPasswordEncoder(BCryptPasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
		Constant.passwordEncoder = passwordEncoder;
	}

	//EzenDao class bean 주입
	private EzenDao edao;
	@Autowired
	public void setEdao(EzenDao edao) {
		this.edao = edao;
		Constant.edao = edao;
	}
	
	//NaverLoginBO 객체 주입
	private NaverLoginBO naverLoginBO;
	@Autowired
	public void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}

	//google login관련 bean을 field 형태로 주입
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;

/*client에서 request를 ajax로 보내고 그 response를 jsp로 보내면 
 * @ResponseBody없이 페이지가 data로 들어간다.
 * JSON은 어노테이션의 도움으로 SPRING이 처리하기때문에 필요하다. 
 */
//회원가입 form
	@RequestMapping("/joinView")
	public String joinView() {
		return "joinView";
	}
//home요청	
	@RequestMapping("/home")
	public String home() {
		return "home";
	}
//mainRegion에 mHome 변경
	@RequestMapping("/mHome")
	public String mHome() {
		return "mHome";
	}
	
	@RequestMapping(value="/join", produces="application/text; charset=UTF8")
	@ResponseBody//callback으로
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("join 요청");
		com = new EzenJoinCommand();
		com.execute(request, model);
		String result = (String)request.getAttribute("result");
		if(result.equals("success")) {
			return "join-success";			
		}
		else {
			return "join-failed";
		}
	}
//log in 
	@RequestMapping("/loginView")
	public String loginView(HttpServletRequest request, HttpServletResponse response, HttpSession session, Model model) {
		System.out.println("loginView 요청");
		//일반 method: 각각의 url에 따라 처리
		socialUrl(model, session);
		return "loginView";
	}
	//요청
	private void socialUrl(Model model, HttpSession session) {
		//kakao의 Oauth2 url(auth주소 + 카카오 발행 인증키(REST API 키) + 반환대상 페이지(kredirect) +respons_type
		//https://developers.kakao.com/
		String kakao_url = "https://kauth.kakao.com/oauth/authorize"
				+ "?client_id=baeea049fff19319b8ca84ac02362ad2"
				+ "&redirect_uri=https://localhost:8443/ezenPJT/kredirect"
				+ "&response_type=code";
		model.addAttribute("kakao_url",kakao_url);
		//naver의 url(https://developers.naver.com/main/)
		//네이버 아이디로 인증 url을 생성하기 위해 NaverLoginBO클래스의 getAuthorizationUrl method 호출
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		System.out.println("naver: " +naverAuthUrl);
		model.addAttribute("naver_url", naverAuthUrl);
		//google의 url
		//구글 code 발행 OAuth2를 처리하는 객체
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		String url = oauthOperations.buildAuthenticateUrl(GrantType.AUTHORIZATION_CODE,googleOAuth2Parameters);
		//GrantType은 Oauth2처리 방식 AUTHORIZATION_CODE는 서버사이드 인증,googleOAuth2Parameters는
		//빈에 설정된 scope와 redirect정보를 가진 객체
		System.out.println("구글:" + url);
		model.addAttribute("google_url", url);
	}

	//login 성공이후 main요청 
	@RequestMapping("/main")//security-context.xml에서
	public String main(HttpServletRequest request, Model model, Authentication authentication) {
		System.out.println("main 요청");
		//로그인 성공후 id와 role정보를 얻어내기위한 method를 만들어 사용
		getUsername(authentication, request);
		String username = (String)request.getAttribute("username");
		String auth = (String)request.getAttribute("auth");
		com = new EzenRecipeCommand();
		com.execute(request, model);
		return "mainView";
	}
	//로그인 성공후 id와 role정보를 얻어내기위해 직접만든 일반 method(mapping x)
	private void getUsername(Authentication authentication, HttpServletRequest request) {
		UserDetails userDetails = (UserDetails)authentication.getPrincipal();
		String username = userDetails.getUsername();
		Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
		String auth = authorities.toString();
		request.setAttribute("username", username);
		request.setAttribute("auth", auth);
	}
	
	//social login redirect: kakao
	@RequestMapping(value="/kredirect", produces="application/json; charset=UTF8")
	public String kredirect(@RequestParam String code, HttpServletResponse response, 
			Model model, HttpServletRequest request) throws Exception{
		System.out.println("#########" + code);
		//kakao에서 보낸 정보가 담긴 토큰
		String access_Token = getKakaoAccessToken(code,response);
		System.out.println("###access_Token###: " + access_Token);
		//토큰을 해석해서 사용자정보를 map에 담음
		HashMap<String, Object> userInfo = getKakaoUserInfo(access_Token);
		String email = (String)userInfo.get("email");
		String authUsername = "kakao_"+email;
		String authPw =(String)userInfo.get("nickname");
		String cryptPw = passwordEncoder.encode(authPw);
		
		AuthUserDto dto = new AuthUserDto(authUsername,cryptPw,null);
		authDB(request,model,dto);
		
		model.addAttribute("authUser",authUsername);
		model.addAttribute("authPw",authPw);
		
		return "socialLogin";
	}
	//social login관련 일반 method: kakao access-token
	public String getKakaoAccessToken (String authorize_code,HttpServletResponse response)  {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8"); 
		String access_Token = "";
		String refresh_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token"; //토큰 정보를 받기 위한 요청 경로
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			// URL연결은 입출력에 사용 될 수 있고, POST 혹은 PUT 요청을 하려면 setDoOutput을 true로 설정해야함.
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			//kakao로 응답해주는 값
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			sb.append("grant_type=authorization_code");
			sb.append("&client_id=baeea049fff19319b8ca84ac02362ad2");  //본인이 발급받은 key
			sb.append("&redirect_uri=https://localhost:8443/ezenPJT/kredirect");
			sb.append("&code=" + authorize_code);
			bw.write(sb.toString());
			bw.flush();
			//결과 코드가 200이라면 성공
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);
			// 요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
			 BufferedReader br = 
		            	new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			 //java.io.InputStreamReader.InputStreamReader
			 String line = "";
	         String result = "";
	         while ((line = br.readLine()) != null) {
	        	result += line;
	         }
	         System.out.println("response body : " + result);
	         JSONParser parser = new JSONParser();
	         //org.json.simple.parser.JSONParser
	         Object obj = parser.parse(result); //parse메서드는 Object반환
	         JSONObject jsonObj = (JSONObject) obj;
	         access_Token = (String)jsonObj.get("access_token");
	         refresh_Token = (String)jsonObj.get("refresh_token");
			 System.out.println("access_token : " + access_Token);
			 System.out.println("refresh_token : " + refresh_Token);
			 br.close();
			 bw.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return access_Token; //kakao에서 제공해주는 이용자 정보 토큰
	}
	//social login관련 일반 method: kakao access-token에서 사용자 정보 얻기
	public HashMap<String,Object> getKakaoUserInfo (String access_Token) {
		HashMap<String, Object> userInfo = new HashMap<String, Object>();
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			//요청에 필요한 Header에 포함될 내용
			conn.setRequestProperty("Authorization", "Bearer " + access_Token);
			int responseCode = conn.getResponseCode(); //200이면 정상
			System.out.println("responseCode : " + responseCode);
			BufferedReader br = 
					new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line = "";
	        String result = "";
	        while ((line = br.readLine()) != null)  {
	        	 result += line;
	        }
	        System.out.println("response body : " + result);
	        
	        //정보 추출
	        JSONParser parser = new JSONParser();
	        Object obj = parser.parse(result);
	        JSONObject jsonObj = (JSONObject) obj;
	        String id = jsonObj.get("id").toString(); //kakao의 고유 번호(보통 시퀀스 번호)
	        JSONObject properties = (JSONObject)jsonObj.get("properties");
	        JSONObject kakao_account = (JSONObject)jsonObj.get("kakao_account"); //검수(비즈니스 등록)후에 사용가능
	        String accessToken = (String)properties.get("access_token");
	        String nickname = (String)properties.get("nickname");
	        String email = (String)kakao_account.get("email"); //검수(비즈니스 등록)후에 사용가능
	        userInfo.put("accessToken", access_Token);
            userInfo.put("nickname", nickname);
            userInfo.put("email", email);
            userInfo.put("id", id);
            System.out.println("=============");
            System.out.println("acces token  " + accessToken);
            System.out.println("nickname  " + nickname);
            System.out.println("email  " + email); 
            System.out.println("id  " + id);
		}
		catch(Exception e1) {
			e1.getMessage();
		}
		return userInfo;
	}	
	//social login redirect: Naver
	@RequestMapping(value="/nredirect", produces="application/json; charset=UTF8")
	public String nredirect(@RequestParam String code, 
			@RequestParam String state, HttpSession session, Model model, HttpServletRequest request) throws Exception{
		System.out.println("nredirect 요청");
		System.out.println("state: " + state);
		OAuth2AccessToken oauthToken = naverLoginBO.getAccessToken(session, code, state);
		String apiResult = naverLoginBO.getUserProfile(oauthToken);
		System.out.println("apiResult: " + apiResult);
		//String 형식인 apiResult를 JSON Object형태로 바꿈
		JSONParser parser = new JSONParser();//org.json.simple에서 만든 JSON
		Object obj = parser.parse(apiResult);//자바의 String 객체를 자바의 Object객체로
		JSONObject jsonObj = (JSONObject) obj;//자바의 Object를 JSONObject로
		//결과가 저장되어있는 JSON형식의 객체
		JSONObject responseObj =(JSONObject)jsonObj.get("response");
		System.out.println("naver user 정보: " + responseObj);
		//response의 값 반환
		String email = (String)responseObj.get("email");
		String name = (String)responseObj.get("name");
		String id = (String)responseObj.get("id");
		System.out.println("email: " + email + " /name: " + name + " /id: " + id);
		//DB등록 준비(실제에서는 위의 정보 확인 없이 바로 auth-과정)
		String authUsername = "naver_"+ email;
		String authPw = name;
		String cryptPw = passwordEncoder.encode(authPw);
		AuthUserDto dto = new AuthUserDto(authUsername,cryptPw,null);
		//db입력 method 호출
		authDB(request,model,dto);
		//model에 입력
		model.addAttribute("authUser",authUsername);
		model.addAttribute("authPw",authPw);
		return "socialLogin";
	}
	//social login redirect: gredirect
	@RequestMapping(value="/gredirect", produces="application/text; charset=UTF8")
	public String googleCallback(Model model, @RequestParam String code, HttpServletResponse response, HttpServletRequest request) 
			throws IOException{
		System.out.println("google redirect 요청");
		//google code 발행, OAuth2를 처리하는 객체
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		//access token 처리 객체
		AccessGrant accessGrant = oauthOperations.exchangeForAccess(code, googleOAuth2Parameters.getRedirectUri(), null);
		String accessToken = accessGrant.getAccessToken();
		HashMap<String, Object> map = getGoogleUserInfo(accessToken, response);
		String email = (String)map.get("email");
		String name = (String)map.get("name");
		String id = (String)map.get("id");
		System.out.println("email: " + email + "/ name: " + name + "/ id: " + id);
		//DB에 저장할 계정과 비밀번호
		String authUsername = "google_"+email;
		String authPw = (String)map.get("name");
		String cryptPw = passwordEncoder.encode(authPw);
		AuthUserDto dto = new AuthUserDto(authUsername,cryptPw,null);
		//DB등록 method 호출
		authDB(request,model,dto);
		model.addAttribute("authUser",authUsername);
		model.addAttribute("authPw",authPw);
		return "socialLogin";
	}
	//구글사용자정보 얻기 메서드
	   public HashMap<String,Object> getGoogleUserInfo(String access_Token,HttpServletResponse response) {
	      response.setCharacterEncoding("UTF-8");
	      response.setContentType("text/html;charset=UTF-8"); 
	      HashMap<String,Object> gUserInfo = new HashMap<String,Object>();
	      //구글 사용자 정보 요청 경로
	      String reqURL = "https://www.googleapis.com/userinfo/v2/me?access_token=" + access_Token;
	      try {
	         URL url = new URL(reqURL); 
	         HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	         conn.setRequestProperty("Authorization", "Bearer " + access_Token);
	         int responseCode = conn.getResponseCode(); 
	         System.out.println("responseCode : "+responseCode);
	         if(responseCode == 200) { //200은 연결 성공
	            BufferedReader br = 
	               new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8")); 
	            String line = ""; 
	            String result = "";
	            while ((line = br.readLine()) != null) {
	               result += line;
	            }
	            JSONParser parser = new JSONParser(); //문자열을 json객체화하는 객체
	            Object obj = parser.parse(result);
	            JSONObject jsonObj = (JSONObject) obj;
	            String name_obj = (String)jsonObj.get("name");
	            String email_obj = (String)jsonObj.get("email");
	            String id_obj = "GOOGLE_" + (String)jsonObj.get("id");
	            //유저 정보
	            gUserInfo.put("name", name_obj); 
	            gUserInfo.put("email", email_obj); 
	            gUserInfo.put("id", id_obj);
	            System.out.println("gUserInfo : " + gUserInfo);   
	         }
	      }
	      catch(Exception e) {
	         e.printStackTrace();
	      }
	      return gUserInfo;
	   }
	  //social login의 결과를 DB에 저장하는 method
	   private void authDB(HttpServletRequest request, Model model, AuthUserDto dto) {
		   com = new AuthCommand(); 
		   request.setAttribute("dto", dto);
		   com.execute(request, model);
	   }
//login 실패 처리(authentication-failure-url)
	@RequestMapping("/processLogin")
	public ModelAndView processLogin(
			@RequestParam(value="log", required=false) String log, 
			@RequestParam(value="error", required=false) String error,
			@RequestParam(value="logout", required=false) String logout,
			//HttpSession은 소셜관련해서 사용
			HttpSession session, Model pmodel) {
		System.out.println("processLogin 요청");
		ModelAndView model = new ModelAndView();
		if(log != null && log !="") {
			model.addObject("log", "before login!");
		}
		if(error != null && error != "") {//?로 쿼리인 error=1 전송
			model.addObject("error", "Invalid username or password");
		}
		if(logout != null && logout != "") {//?로 쿼리인 logout=1 전송
			model.addObject("logout", "You've been logged out successfully");
		}
		//user권한이면 main으로 가고 나머지 로그아웃과 에러는 로그인 창으로 이동
		socialUrl(pmodel,session);
		model.setViewName("loginView");
		return model;
	}
	@RequestMapping("/logoutView")
	public String logoutView() {
		System.out.println("logoutView 요청");
		return "logoutView";
	}
	
	//recipe 등록
	//ajax로 보내지만 data를 받지 않고 form으로 이동하기에 ResponseBody는 사용하지않음
	@RequestMapping("/rwriteView")
	public String rwriteView() {
		System.out.println("rwriteView 요청");
		return "rwriteView";
	}
	//DB에 등록
	@RequestMapping("/recipeWrite")
	public String recipeWrite(MultipartHttpServletRequest mtpRequest, Model model) {
		System.out.println("recipeWrite 요청");
		String rClass = mtpRequest.getParameter("rClass");
		String rtrName = mtpRequest.getParameter("rtrName");
		String rTitle = mtpRequest.getParameter("rTitle");
		String rContent = mtpRequest.getParameter("rContent");
		String rPrice1= mtpRequest.getParameter("rPrice");
		String rAddress = mtpRequest.getParameter("rAddress");
		int rPrice = Integer.parseInt(rPrice1);
		int rId = 0;//rId는 DB의 RECIPE_SEQ를 사용(초기화만)
		String rPhoto = null;//file은 DB에 저장할사진 이름(구분하기위한 이름을 지정)
		
		//반환되는 파일 데이터는 MultipartFile형이고 getFile로 구한다.
		MultipartFile mf = mtpRequest.getFile("rPhoto");
		//upload되는 파일 저장위치(workspace, tomcat server), 절대경로 사용,path 마지막에 /
		//war파일로 배포할때는 path1필요없음
		String path = "E:/choIk/WorkSpace/ezenMini0420/src/main/webapp/resources/upimage/";
		String path1 = "E:/choIk/apache-tomcat-9.0.63/wtpwebapps/ezenMini0420/resources/upimage/";
		//currentTimeMillis() + upload 파일의 원래이름으로 파일명 구분
		String originFileName = mf.getOriginalFilename(); 
		long preName = System.currentTimeMillis();
		long fileSize = mf.getSize();
		//파일 용량 확인
		System.out.println(originFileName + " file Size: " + fileSize);
		String safeFile = path + preName + originFileName;
		String safeFile1 = path1 + preName + originFileName;
		//DB에 저장할 파일이름 rPhoto를 지정
		rPhoto = preName + originFileName;
		RecipeDto rdto = new RecipeDto(rId, rClass, rtrName, rTitle, rPhoto, rContent,rPrice,rAddress);
		//MultipartHttpServletRequest 객체로 전달
		mtpRequest.setAttribute("rdto", rdto);
		//command로 DB에 insert 처리
		com = new EzenRecipeWriteCommand();
		com.execute(mtpRequest, model);
		
		//model객체의 값을 추출할때는 asMap() method 사용
		Map<String, Object> map = model.asMap();
		String res = (String)map.get("result");
		System.out.println("res: " + res);
		if(res.equals("success")) {
			try {
				mf.transferTo(new File(safeFile));
				mf.transferTo(new File(safeFile1));
			}
			catch(Exception e) {
				e.printStackTrace();
			}
			return "redirect:main";
		}
		else {
			return "main";
		}
	}
	
	@RequestMapping("/recipeDetails")
	public String recipeDetails(HttpServletRequest request, Model model) {
		System.out.println("recipeDetails 요청");
		com = new EzenRecipeDetailsCommand();
		com.execute(request, model);
	      
		if(model.containsAttribute("rDetails")) {
	    	System.out.println("success");
	    	return "recipeDetailsView";
		}
		else {
			return "redirect:main";
		}
	}
	//장바구니: db처리가 아님. localStorage
	@RequestMapping("/recipeCart") 
	public String recipeCart(HttpServletRequest request, Model model) {
		System.out.println("recipeCart 요청");
		return "recipeCart";
	}
	//recipe order write, list 
	@RequestMapping("/recipeorder")
	public String recipeorder(RecipeOrderDto dto, HttpServletRequest request, Model model) {
		System.out.println("recipe order 요청");
		request.setAttribute("rodto", dto);
		//form에서 받은 정보를 바로 dto객체로 받아 command로 전달
		com = new RecipeOrderCommand();
		com.execute(request, model);
		//DB저장이 끝나고 레시피 목록을 list
		com = new RecipeOrderListCommand();
		com.execute(request, model);
		return "recipeorderView";
	} 
	//recipe order list
	@RequestMapping("/recipeorderView")
	public String recipeorderView(HttpServletRequest request, Model model) {
		System.out.println("recipeorderView 요청");
		com = new RecipeOrderListCommand();
		com.execute(request, model);
		return "recipeorderView";
	}
	//admin page
	@RequestMapping("/adminView")
	public String adminView() {
		System.out.println("adminView 요청");
		return "adminView";
	}
	
	@RequestMapping("/authAdmin")
	@ResponseBody
	public String authAdmin(HttpServletRequest request, Model model) {
		System.out.println("authAdmin 요청");
		com = new EzenAdminAuthCommand();
		com.execute(request, model);
		
		Map<String, Object> map = model.asMap();
		String res = (String)map.get("result");
		if(res.equals("success")) {
			return "success";
		}
		else {
			return "failed";
		}
	}
	//게시판
	@RequestMapping("/eBoard")
	public String eBoard(HttpServletRequest request, Model model) {
		System.out.println("eBoard 요청");
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView";
	}
	//pagination
	@RequestMapping("/plist")
	public String purl(HttpServletRequest request, Model model) {
		System.out.println("plist 요청");
		System.out.println(request.getParameter("pageNo"));
		com = new EzenBoardPageListCommand();
		com.execute(request, model);
		return "pageBoard";
	}
	//search
	@RequestMapping("/searchBoard")
	public String searchBoard(HttpServletRequest request, Model model) {
		System.out.println("searchBoard요청");
		com = new EzenBoardSearchListCommand();
		com.execute(request,model);		
		return "searchBoard";
	}
	//write form
	@RequestMapping("/writeView")
	public String writeView() {
		System.out.println("writeView 요청");
		return "writeView";
	}
	
	//bWrite
	@RequestMapping(value="/bWrite", produces="application/text; charset=UTF8")
	public String bWrite(HttpServletRequest request, Model model) {
		System.out.println("bWrite 요청");
		com = new EzenBoardWriteCommand();
		com.execute(request, model);
		/* ajax를 사용하지 않을때(one page가 아닐때)는 redirect를 사용
		return "redirect:eBoardView" */
		//ajax를 위해 command를 사용
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView";
	}
	
	//contentView
	@RequestMapping("/contentView")
	public String contentView(HttpServletRequest request, Model model) {
		System.out.println("contentView 요청");
		com = new EzenBoardContentCommand();
		com.execute(request, model);
		return "contentView";
	}
	
	//modify
	@RequestMapping(value="/modify", produces="application/text; charset=UTF8")
	public String modify(HttpServletRequest request, Model model) {
		System.out.println("modify 요청");
		com = new EzenBoardModifyCommand();
		com.execute(request, model);
		//수정 후 리스트
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView";
	}
	
	@RequestMapping("/delete")
	public String delete(HttpServletRequest request, Model model) {
		System.out.println("delete 요청");
		com = new EzenBoardDeleteCommand();
		com.execute(request, model);
		//삭제 후 리스트
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView"; 
	}
	
	@RequestMapping(value="/replyView", produces="application/text; charset=UTF8")
	public String replyView(HttpServletRequest request, Model model) {
		System.out.println("replyView 요청");
		com = new EzenBoardReplyViewCommand();
		com.execute(request, model);
		return "replyWrite";
	}
	
	@RequestMapping(value="/reply", produces="application/text; charset=UTF8")
	public String reply(EzenBoardDto dto, HttpServletRequest request, Model model) {
		System.out.println("reply 요청");
		request.setAttribute("formDto", dto);
		com = new EzenBoardReplyCommand();
		com.execute(request, model);
		//댓글 작성 후 리스트
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView"; 
	}

	@RequestMapping("/util")
	public String util() {
		System.out.println("util 요청");
		return "utils";
	}
	//CK Edit(외부 라이브러리라 security를 적용할 수 없음 >> security-context.xml에서 미처리 적용) 
	@RequestMapping("/ckedit")//직접 DB에 저장은 아님
	public void ckedit(MultipartHttpServletRequest request, HttpServletResponse response) throws IOException{
		System.out.println("ckedit(편집창 이미지 처리) 요청");
		//편집창에서 PC의 이미지를 사용할 경우 서버에서 이미지를 받아 다룰 공간
		String path = "/ezenPJT/editUpload";//개발자 지정폴더: resources의 업로드 이미지를 요청할 request 경로 준비
		String real_save_path = request.getServletContext().getRealPath(path);//톰캣서버에 저장되는 위치
		System.out.println("real path: " + real_save_path);
		
		//MultipartFile을 이용해 파일을 업로드
		MultipartFile mf = request.getFile("upload");//ckedit request에서 type="file"의 name을 upload로 보냄
		String originFileName = mf.getOriginalFilename();
		long fileSize = mf.getSize();
		System.out.println(originFileName + "// size: " + fileSize);
		
		//파일이름 중복방지
		String uuid = UUID.randomUUID().toString();
		//파일 저장
		String path1 = "F:/WorkSpace/ezenMini0420/src/main/webapp/resources/editUpload/";//workspace
		String path2 = "F:/DevelopStudyResource/TomcatServer/apache-tomcat-9.0.63/wtpwebapps/ezenMini0420/resources/editUpload/";//tomcat(정식 서비스에선 삭제)
		String safeFile1 = path1 + uuid + originFileName;
		String safeFile2 = path2 + uuid + originFileName;
		System.out.println("saved path: " + safeFile1);
		String changeFileName = uuid + originFileName;
		try {
			mf.transferTo(new File(safeFile1));
			mf.transferTo(new File(safeFile2));
		}
		catch(Exception e) {
			e.printStackTrace();
		} 
		//저장한 후 그 이미지를 CK Editor의 편집창으로 전달 
		JSONObject outData = new JSONObject(); //Java의 Map과 유사(key:value), put()...
		//key와 value를 매핑해 넣음(CK Editor의 모듈에서 요청하는 key 값 사용)
		outData.put("uploaded",true);//업로드 확인
		//url = protocol://도메인(서버주소:포트)/request 경로/파일명
		outData.put("url",request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"+changeFileName);
		//key값으로 url 검토
		String url = (String)outData.get("url");
		System.out.println("uploaded url: " + url);
		//HttpServletResponse를 통해 전송
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(outData.toString());
	}
	//ckedit1(내용을 db에 저장)
	@RequestMapping(value="/ckedit1", produces="application/text; charset=UTF8")//ajax로 요청해 전달할때 한글 처리(return값)
	public String ckedit1(EditorDto dto, HttpServletRequest request, Model model) {
		System.out.println("ckedit1 요청");
		//mapping된 dto를 안쓰면 getParameter()를 사용해 data를 준비
		request.setAttribute("edDto", dto);
		//DB에 insert
		com = new EditorInsertCommand();
		com.execute(request, model);
		//저장 후 list 요청
		com = new EditorListCommand();
		com.execute(request, model);
		return "editorList";
	}
	//ckeditList
	@RequestMapping(value="/cedList",produces="application/text; charset=UTF8")
	public String cedList(HttpServletRequest request, Model model) {
		System.out.println("cedList 요청");
		com = new EditorListCommand();
		com.execute(request, model);
		return "editorList";
	}
	//server-sent event
	@RequestMapping("/sse")
	public String sse() {
		System.out.println("SSE 요청");
		return "sseView";
	}
	//edContView요청 처리
	@RequestMapping(value="/edContView", produces="application/text; charset=UTF8")
	public String edContView(HttpServletRequest request, Model model) {
		com = new EditorDetailCommand();
		com.execute(request, model);
		return "edDetailView";
	}
	@RequestMapping("/seventEx")
	public void seventEx(HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("single sse");
		response.setContentType("text/event-stream");//event-stream으로 sse처리
		response.setCharacterEncoding("UTF-8");
		//response객체에 담아 보냄.
		PrintWriter writer = response.getWriter();
		for(int i=0;i<20;i++) {
			writer.write("data: " + System.currentTimeMillis() + "\n\n");
			//client의 event객체에 JSON 형태로 보냄: "data:현재시간"
			writer.flush();
			try {//반복 간격 1초
				Thread.sleep(1000);
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		writer.close();
	}
	@RequestMapping("/meventEx")
	public void meventEx(HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("multi sse");
		response.setContentType("text/event-stream");
		response.setCharacterEncoding("UTF-8");
		PrintWriter writer = response.getWriter();
		
		//client에 보낼 이밴트 객체
		int upVote = 0;
		int downVote = 0;
		
		for(int i = 0; i<20; i++) {
			upVote += (int)(Math.random()*10);
			downVote += (int)(Math.random()*10);
			
			//event:이벤트종류
			//data:해당 이벤트에 들어갈 값(발생시킨 난수)
			writer.write("event:upVote\n");
			writer.write("data:" + upVote + "\n\n");
			
			writer.write("event:downVote\n");
			writer.write("data:" + downVote + "\n\n");
			
			writer.flush();
			try {
				Thread.sleep(1000);
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		writer.close();
	}
	//calendar
	@RequestMapping("/fCalendar")
	public String fCalendar() {
		System.out.println("fCalendar 요청");
		return "fCalendar";
	}
	@RequestMapping(value="/calendar", produces="application/json; charset=UTF8")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> carledar( HttpServletRequest request, Model model) {
		System.out.println("calendar 요청");
		System.out.println("cId: " + request.getParameter("cId"));
		
		com = new CalendarListCommand();
		com.execute(request, model);
		
		//가져온 데이터를 처리할 calendarList
		HashMap<String, Object> map = (HashMap<String, Object>)model.asMap();
		ArrayList<FullCalendarDto> calendarList = (ArrayList)map.get("calendarList");
		//데이터를 보낼 clistArr
		ArrayList<HashMap<String, Object>> clistArr = new ArrayList<HashMap<String, Object>>(); 
		for(FullCalendarDto dto : calendarList) {
			HashMap<String, Object> clistMap = new HashMap<String, Object>();
			String cAllDay = dto.getcAllDay();
			boolean allDay;
			if(cAllDay.equals("true")) {
				allDay = true;
			}
			else {
				allDay = false;
			}
			clistMap.put("cNo", dto.getcNo());
			clistMap.put("cId", dto.getcId());
			clistMap.put("title", dto.getcTitle());
			clistMap.put("start", dto.getcStart());
			clistMap.put("end", dto.getcEnd());
			clistMap.put("allDay", allDay);
			
			clistArr.add(clistMap);
		}
		return clistArr;
	}
	//calendarInsert
	@RequestMapping(value="/calendarInsert", produces="application/json; charset=UTF8")
	@ResponseBody
	public String calendarInsert(@RequestBody FullCalendarDto fullCalendarDto, HttpServletRequest request, Model model) {
		System.out.println("calendarInsert 요청");
		String start = fullCalendarDto.getcStart();
		String end = fullCalendarDto.getcEnd();
		
		//문자열 형식의 시간 data를 LocalDateTime형식으로 변환, DateTimeFormatter를 사용할 수 있음. 
		//DateTimeFormatter formatDateTime = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
		//LocalDateTime localDateTime = LocalDateTime.from(formatDateTime.parse(start));

		//하지만 시간표시에 z가 붙는 경우 작동을 안할 수 있어 ISO형식을 사용해 적용
		DateTimeFormatter ISO_DATE_TIME = DateTimeFormatter.ISO_DATE_TIME;
		LocalDateTime localDateStart = LocalDateTime.from(ISO_DATE_TIME.parse(start));
		//LocalDateTime을 Timestamp로 변환
		Timestamp stampStart = Timestamp.valueOf(localDateStart);
		
		//end도 마찬가지
		LocalDateTime localDateEnd = LocalDateTime.from(ISO_DATE_TIME.parse(end));
		Timestamp stampEnd = Timestamp.valueOf(localDateEnd);
		
		System.out.println("stamp start: " + stampStart);
		System.out.println("stamp end: " + stampEnd);
		
		//시간계산을 위한 millisecond를 사용하기위해 posix형식으로 변환(지금 안씀)
		Long posixStart = stampStart.getTime();
		Long posixEnd = stampEnd.getTime();
		
		fullCalendarDto.settStart(stampStart);
		fullCalendarDto.settEnd(stampEnd);
		
		request.setAttribute("dto", fullCalendarDto);
		
		com = new CalendarInsertCommand();
		com.execute(request, model);
		
		return "success";
	}
	@RequestMapping(value="/calendarUpdate", produces="application/json; charset=UTF8")
	@ResponseBody 
	public String calendarUpdate(@RequestBody FullCalendarDto fullCalendarDto, 
			HttpServletRequest request, Model model) {
		System.out.println("calendarUpdate 요청");
		System.out.println("calendarUpdate No: " + fullCalendarDto.getcNo());
		
		request.setAttribute("dto", fullCalendarDto);
		com = new CalendarUpdateCommand();
		com.execute(request, model);
		return "success";
	}
	
	@RequestMapping(value="/calendarDelete", produces="application/json; charset=UTF8")
	@ResponseBody
	public String calendarDelete(@RequestBody FullCalendarDto fullCalendarDto, 
			HttpServletRequest request, Model model) {
		System.out.println("calendarDelete 요청");
		System.out.println("calendarDelete No: " + fullCalendarDto.getcNo());
		
		request.setAttribute("dto", fullCalendarDto);
		com = new CalendarDeleteCommand(); 
		com.execute(request, model);
		return "success";
	}
	//파일변환
	@RequestMapping("/fconvert")  
	public String fconvert() {
		System.out.println("fconvert");
		return "fconvertView";
	}
	//pdf 보여주기 
	@RequestMapping("/pdfPlay") 
	public String pdfPlay() {
		System.out.println("pdfPlay");
		return "pdfPlay";
	}
	@RequestMapping("/about")
	public String about(){
		System.out.println("about 요청");
		return "about";
	}
	
	//dashboard 보기
	@RequestMapping("/dash")
	public String dash() {
		return "dashBoard";
	}
	
	@RequestMapping(value="/dashView", produces="application/json; charset=UTF8")
	@ResponseBody
	public JSONObject dashView(HttpServletRequest request, Model model) {
		System.out.println("dashView 요청");
		String subcmd = request.getParameter("subcmd");
		System.out.println("subcmd: " + subcmd);
		
		com = new DashBoardCommand();
		com.execute(request, model);
		
		JSONObject result = getDashData(request, model);
		return result;
	}
	//map형태의 값을 JSONObject의 형태로 변환
	private JSONObject getDashData(HttpServletRequest request, Model model) {
		HashMap<String, Object> dashMap = (HashMap<String, Object>)model.asMap();
		ArrayList<DashBoardDto> dashList = (ArrayList<DashBoardDto>)dashMap.get("dashArray");//command에서 지정한 key값
		
		JSONArray dashArr = new JSONArray();
		for(DashBoardDto dto : dashList) {
			JSONObject data = new JSONObject();
			//JSONObject 객체는 map형식(key-value)으로된 JSON객체
			data.put("month", dto.getMonth());
			data.put("pc", dto.getPcQty());
			data.put("monitor", dto.getMonitorQty());
			
			dashArr.add(data);
		}
		JSONObject result = new JSONObject();
		//JSONObject result는 key가 datas인 value dashArr객체를 갖는다. 
		result.put("datas", dashArr);
		
		return result;
	}
	@RequestMapping("/bar")
	public String bar() {
		return "bar";
	}
	@RequestMapping("/pie")
	public String pie() {
		return "pie";
	}
	@RequestMapping("/statis")
	public String statis() {
		System.out.println("statis요청");
		return "statis";
	}

	@RequestMapping(value= "/statisWrite", produces = "application/text; charset=UTF8") 
	public String statisWrite(DashBoardDto dto,HttpServletRequest request, Model model) {
		
		com = new DashBoardWrite();
		request.setAttribute("dto", dto);
		com.execute(request, model);
		
		return "redirect:dash";
	}
}
