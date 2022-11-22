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
	
	//��ȣȭ ó�� bean ����(���� ���� ���� ��� ���)
	private BCryptPasswordEncoder passwordEncoder;
	@Autowired
	public void setPasswordEncoder(BCryptPasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
		Constant.passwordEncoder = passwordEncoder;
	}

	//EzenDao class bean ����
	private EzenDao edao;
	@Autowired
	public void setEdao(EzenDao edao) {
		this.edao = edao;
		Constant.edao = edao;
	}
	
	//NaverLoginBO ��ü ����
	private NaverLoginBO naverLoginBO;
	@Autowired
	public void setNaverLoginBO(NaverLoginBO naverLoginBO) {
		this.naverLoginBO = naverLoginBO;
	}

	//google login���� bean�� field ���·� ����
	@Autowired
	private GoogleConnectionFactory googleConnectionFactory;
	@Autowired
	private OAuth2Parameters googleOAuth2Parameters;

/*client���� request�� ajax�� ������ �� response�� jsp�� ������ 
 * @ResponseBody���� �������� data�� ����.
 * JSON�� ������̼��� �������� SPRING�� ó���ϱ⶧���� �ʿ��ϴ�. 
 */
//ȸ������ form
	@RequestMapping("/joinView")
	public String joinView() {
		return "joinView";
	}
//home��û	
	@RequestMapping("/home")
	public String home() {
		return "home";
	}
//mainRegion�� mHome ����
	@RequestMapping("/mHome")
	public String mHome() {
		return "mHome";
	}
	
	@RequestMapping(value="/join", produces="application/text; charset=UTF8")
	@ResponseBody//callback����
	public String join(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("join ��û");
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
		System.out.println("loginView ��û");
		//�Ϲ� method: ������ url�� ���� ó��
		socialUrl(model, session);
		return "loginView";
	}
	//��û
	private void socialUrl(Model model, HttpSession session) {
		//kakao�� Oauth2 url(auth�ּ� + īī�� ���� ����Ű(REST API Ű) + ��ȯ��� ������(kredirect) +respons_type
		//https://developers.kakao.com/
		String kakao_url = "https://kauth.kakao.com/oauth/authorize"
				+ "?client_id=baeea049fff19319b8ca84ac02362ad2"
				+ "&redirect_uri=https://localhost:8443/ezenPJT/kredirect"
				+ "&response_type=code";
		model.addAttribute("kakao_url",kakao_url);
		//naver�� url(https://developers.naver.com/main/)
		//���̹� ���̵�� ���� url�� �����ϱ� ���� NaverLoginBOŬ������ getAuthorizationUrl method ȣ��
		String naverAuthUrl = naverLoginBO.getAuthorizationUrl(session);
		System.out.println("naver: " +naverAuthUrl);
		model.addAttribute("naver_url", naverAuthUrl);
		//google�� url
		//���� code ���� OAuth2�� ó���ϴ� ��ü
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		String url = oauthOperations.buildAuthenticateUrl(GrantType.AUTHORIZATION_CODE,googleOAuth2Parameters);
		//GrantType�� Oauth2ó�� ��� AUTHORIZATION_CODE�� �������̵� ����,googleOAuth2Parameters��
		//�� ������ scope�� redirect������ ���� ��ü
		System.out.println("����:" + url);
		model.addAttribute("google_url", url);
	}

	//login �������� main��û 
	@RequestMapping("/main")//security-context.xml����
	public String main(HttpServletRequest request, Model model, Authentication authentication) {
		System.out.println("main ��û");
		//�α��� ������ id�� role������ �������� method�� ����� ���
		getUsername(authentication, request);
		String username = (String)request.getAttribute("username");
		String auth = (String)request.getAttribute("auth");
		com = new EzenRecipeCommand();
		com.execute(request, model);
		return "mainView";
	}
	//�α��� ������ id�� role������ �������� �������� �Ϲ� method(mapping x)
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
		//kakao���� ���� ������ ��� ��ū
		String access_Token = getKakaoAccessToken(code,response);
		System.out.println("###access_Token###: " + access_Token);
		//��ū�� �ؼ��ؼ� ����������� map�� ����
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
	//social login���� �Ϲ� method: kakao access-token
	public String getKakaoAccessToken (String authorize_code,HttpServletResponse response)  {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8"); 
		String access_Token = "";
		String refresh_Token = "";
		String reqURL = "https://kauth.kakao.com/oauth/token"; //��ū ������ �ޱ� ���� ��û ���
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			// URL������ ����¿� ��� �� �� �ְ�, POST Ȥ�� PUT ��û�� �Ϸ��� setDoOutput�� true�� �����ؾ���.
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			//kakao�� �������ִ� ��
			BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
			StringBuilder sb = new StringBuilder();
			sb.append("grant_type=authorization_code");
			sb.append("&client_id=baeea049fff19319b8ca84ac02362ad2");  //������ �߱޹��� key
			sb.append("&redirect_uri=https://localhost:8443/ezenPJT/kredirect");
			sb.append("&code=" + authorize_code);
			bw.write(sb.toString());
			bw.flush();
			//��� �ڵ尡 200�̶�� ����
			int responseCode = conn.getResponseCode();
			System.out.println("responseCode : " + responseCode);
			// ��û�� ���� ���� JSONŸ���� Response �޼��� �о����
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
	         Object obj = parser.parse(result); //parse�޼���� Object��ȯ
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
		return access_Token; //kakao���� �������ִ� �̿��� ���� ��ū
	}
	//social login���� �Ϲ� method: kakao access-token���� ����� ���� ���
	public HashMap<String,Object> getKakaoUserInfo (String access_Token) {
		HashMap<String, Object> userInfo = new HashMap<String, Object>();
		String reqURL = "https://kapi.kakao.com/v2/user/me";
		try {
			URL url = new URL(reqURL);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			//��û�� �ʿ��� Header�� ���Ե� ����
			conn.setRequestProperty("Authorization", "Bearer " + access_Token);
			int responseCode = conn.getResponseCode(); //200�̸� ����
			System.out.println("responseCode : " + responseCode);
			BufferedReader br = 
					new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
			String line = "";
	        String result = "";
	        while ((line = br.readLine()) != null)  {
	        	 result += line;
	        }
	        System.out.println("response body : " + result);
	        
	        //���� ����
	        JSONParser parser = new JSONParser();
	        Object obj = parser.parse(result);
	        JSONObject jsonObj = (JSONObject) obj;
	        String id = jsonObj.get("id").toString(); //kakao�� ���� ��ȣ(���� ������ ��ȣ)
	        JSONObject properties = (JSONObject)jsonObj.get("properties");
	        JSONObject kakao_account = (JSONObject)jsonObj.get("kakao_account"); //�˼�(����Ͻ� ���)�Ŀ� ��밡��
	        String accessToken = (String)properties.get("access_token");
	        String nickname = (String)properties.get("nickname");
	        String email = (String)kakao_account.get("email"); //�˼�(����Ͻ� ���)�Ŀ� ��밡��
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
		System.out.println("nredirect ��û");
		System.out.println("state: " + state);
		OAuth2AccessToken oauthToken = naverLoginBO.getAccessToken(session, code, state);
		String apiResult = naverLoginBO.getUserProfile(oauthToken);
		System.out.println("apiResult: " + apiResult);
		//String ������ apiResult�� JSON Object���·� �ٲ�
		JSONParser parser = new JSONParser();//org.json.simple���� ���� JSON
		Object obj = parser.parse(apiResult);//�ڹ��� String ��ü�� �ڹ��� Object��ü��
		JSONObject jsonObj = (JSONObject) obj;//�ڹ��� Object�� JSONObject��
		//����� ����Ǿ��ִ� JSON������ ��ü
		JSONObject responseObj =(JSONObject)jsonObj.get("response");
		System.out.println("naver user ����: " + responseObj);
		//response�� �� ��ȯ
		String email = (String)responseObj.get("email");
		String name = (String)responseObj.get("name");
		String id = (String)responseObj.get("id");
		System.out.println("email: " + email + " /name: " + name + " /id: " + id);
		//DB��� �غ�(���������� ���� ���� Ȯ�� ���� �ٷ� auth-����)
		String authUsername = "naver_"+ email;
		String authPw = name;
		String cryptPw = passwordEncoder.encode(authPw);
		AuthUserDto dto = new AuthUserDto(authUsername,cryptPw,null);
		//db�Է� method ȣ��
		authDB(request,model,dto);
		//model�� �Է�
		model.addAttribute("authUser",authUsername);
		model.addAttribute("authPw",authPw);
		return "socialLogin";
	}
	//social login redirect: gredirect
	@RequestMapping(value="/gredirect", produces="application/text; charset=UTF8")
	public String googleCallback(Model model, @RequestParam String code, HttpServletResponse response, HttpServletRequest request) 
			throws IOException{
		System.out.println("google redirect ��û");
		//google code ����, OAuth2�� ó���ϴ� ��ü
		OAuth2Operations oauthOperations = googleConnectionFactory.getOAuthOperations();
		//access token ó�� ��ü
		AccessGrant accessGrant = oauthOperations.exchangeForAccess(code, googleOAuth2Parameters.getRedirectUri(), null);
		String accessToken = accessGrant.getAccessToken();
		HashMap<String, Object> map = getGoogleUserInfo(accessToken, response);
		String email = (String)map.get("email");
		String name = (String)map.get("name");
		String id = (String)map.get("id");
		System.out.println("email: " + email + "/ name: " + name + "/ id: " + id);
		//DB�� ������ ������ ��й�ȣ
		String authUsername = "google_"+email;
		String authPw = (String)map.get("name");
		String cryptPw = passwordEncoder.encode(authPw);
		AuthUserDto dto = new AuthUserDto(authUsername,cryptPw,null);
		//DB��� method ȣ��
		authDB(request,model,dto);
		model.addAttribute("authUser",authUsername);
		model.addAttribute("authPw",authPw);
		return "socialLogin";
	}
	//���ۻ�������� ��� �޼���
	   public HashMap<String,Object> getGoogleUserInfo(String access_Token,HttpServletResponse response) {
	      response.setCharacterEncoding("UTF-8");
	      response.setContentType("text/html;charset=UTF-8"); 
	      HashMap<String,Object> gUserInfo = new HashMap<String,Object>();
	      //���� ����� ���� ��û ���
	      String reqURL = "https://www.googleapis.com/userinfo/v2/me?access_token=" + access_Token;
	      try {
	         URL url = new URL(reqURL); 
	         HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	         conn.setRequestProperty("Authorization", "Bearer " + access_Token);
	         int responseCode = conn.getResponseCode(); 
	         System.out.println("responseCode : "+responseCode);
	         if(responseCode == 200) { //200�� ���� ����
	            BufferedReader br = 
	               new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8")); 
	            String line = ""; 
	            String result = "";
	            while ((line = br.readLine()) != null) {
	               result += line;
	            }
	            JSONParser parser = new JSONParser(); //���ڿ��� json��üȭ�ϴ� ��ü
	            Object obj = parser.parse(result);
	            JSONObject jsonObj = (JSONObject) obj;
	            String name_obj = (String)jsonObj.get("name");
	            String email_obj = (String)jsonObj.get("email");
	            String id_obj = "GOOGLE_" + (String)jsonObj.get("id");
	            //���� ����
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
	  //social login�� ����� DB�� �����ϴ� method
	   private void authDB(HttpServletRequest request, Model model, AuthUserDto dto) {
		   com = new AuthCommand(); 
		   request.setAttribute("dto", dto);
		   com.execute(request, model);
	   }
//login ���� ó��(authentication-failure-url)
	@RequestMapping("/processLogin")
	public ModelAndView processLogin(
			@RequestParam(value="log", required=false) String log, 
			@RequestParam(value="error", required=false) String error,
			@RequestParam(value="logout", required=false) String logout,
			//HttpSession�� �ҼȰ����ؼ� ���
			HttpSession session, Model pmodel) {
		System.out.println("processLogin ��û");
		ModelAndView model = new ModelAndView();
		if(log != null && log !="") {
			model.addObject("log", "before login!");
		}
		if(error != null && error != "") {//?�� ������ error=1 ����
			model.addObject("error", "Invalid username or password");
		}
		if(logout != null && logout != "") {//?�� ������ logout=1 ����
			model.addObject("logout", "You've been logged out successfully");
		}
		//user�����̸� main���� ���� ������ �α׾ƿ��� ������ �α��� â���� �̵�
		socialUrl(pmodel,session);
		model.setViewName("loginView");
		return model;
	}
	@RequestMapping("/logoutView")
	public String logoutView() {
		System.out.println("logoutView ��û");
		return "logoutView";
	}
	
	//recipe ���
	//ajax�� �������� data�� ���� �ʰ� form���� �̵��ϱ⿡ ResponseBody�� �����������
	@RequestMapping("/rwriteView")
	public String rwriteView() {
		System.out.println("rwriteView ��û");
		return "rwriteView";
	}
	//DB�� ���
	@RequestMapping("/recipeWrite")
	public String recipeWrite(MultipartHttpServletRequest mtpRequest, Model model) {
		System.out.println("recipeWrite ��û");
		String rClass = mtpRequest.getParameter("rClass");
		String rtrName = mtpRequest.getParameter("rtrName");
		String rTitle = mtpRequest.getParameter("rTitle");
		String rContent = mtpRequest.getParameter("rContent");
		String rPrice1= mtpRequest.getParameter("rPrice");
		String rAddress = mtpRequest.getParameter("rAddress");
		int rPrice = Integer.parseInt(rPrice1);
		int rId = 0;//rId�� DB�� RECIPE_SEQ�� ���(�ʱ�ȭ��)
		String rPhoto = null;//file�� DB�� �����һ��� �̸�(�����ϱ����� �̸��� ����)
		
		//��ȯ�Ǵ� ���� �����ʹ� MultipartFile���̰� getFile�� ���Ѵ�.
		MultipartFile mf = mtpRequest.getFile("rPhoto");
		//upload�Ǵ� ���� ������ġ(workspace, tomcat server), ������ ���,path �������� /
		//war���Ϸ� �����Ҷ��� path1�ʿ����
		String path = "E:/choIk/WorkSpace/ezenMini0420/src/main/webapp/resources/upimage/";
		String path1 = "E:/choIk/apache-tomcat-9.0.63/wtpwebapps/ezenMini0420/resources/upimage/";
		//currentTimeMillis() + upload ������ �����̸����� ���ϸ� ����
		String originFileName = mf.getOriginalFilename(); 
		long preName = System.currentTimeMillis();
		long fileSize = mf.getSize();
		//���� �뷮 Ȯ��
		System.out.println(originFileName + " file Size: " + fileSize);
		String safeFile = path + preName + originFileName;
		String safeFile1 = path1 + preName + originFileName;
		//DB�� ������ �����̸� rPhoto�� ����
		rPhoto = preName + originFileName;
		RecipeDto rdto = new RecipeDto(rId, rClass, rtrName, rTitle, rPhoto, rContent,rPrice,rAddress);
		//MultipartHttpServletRequest ��ü�� ����
		mtpRequest.setAttribute("rdto", rdto);
		//command�� DB�� insert ó��
		com = new EzenRecipeWriteCommand();
		com.execute(mtpRequest, model);
		
		//model��ü�� ���� �����Ҷ��� asMap() method ���
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
		System.out.println("recipeDetails ��û");
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
	//��ٱ���: dbó���� �ƴ�. localStorage
	@RequestMapping("/recipeCart") 
	public String recipeCart(HttpServletRequest request, Model model) {
		System.out.println("recipeCart ��û");
		return "recipeCart";
	}
	//recipe order write, list 
	@RequestMapping("/recipeorder")
	public String recipeorder(RecipeOrderDto dto, HttpServletRequest request, Model model) {
		System.out.println("recipe order ��û");
		request.setAttribute("rodto", dto);
		//form���� ���� ������ �ٷ� dto��ü�� �޾� command�� ����
		com = new RecipeOrderCommand();
		com.execute(request, model);
		//DB������ ������ ������ ����� list
		com = new RecipeOrderListCommand();
		com.execute(request, model);
		return "recipeorderView";
	} 
	//recipe order list
	@RequestMapping("/recipeorderView")
	public String recipeorderView(HttpServletRequest request, Model model) {
		System.out.println("recipeorderView ��û");
		com = new RecipeOrderListCommand();
		com.execute(request, model);
		return "recipeorderView";
	}
	//admin page
	@RequestMapping("/adminView")
	public String adminView() {
		System.out.println("adminView ��û");
		return "adminView";
	}
	
	@RequestMapping("/authAdmin")
	@ResponseBody
	public String authAdmin(HttpServletRequest request, Model model) {
		System.out.println("authAdmin ��û");
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
	//�Խ���
	@RequestMapping("/eBoard")
	public String eBoard(HttpServletRequest request, Model model) {
		System.out.println("eBoard ��û");
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView";
	}
	//pagination
	@RequestMapping("/plist")
	public String purl(HttpServletRequest request, Model model) {
		System.out.println("plist ��û");
		System.out.println(request.getParameter("pageNo"));
		com = new EzenBoardPageListCommand();
		com.execute(request, model);
		return "pageBoard";
	}
	//search
	@RequestMapping("/searchBoard")
	public String searchBoard(HttpServletRequest request, Model model) {
		System.out.println("searchBoard��û");
		com = new EzenBoardSearchListCommand();
		com.execute(request,model);		
		return "searchBoard";
	}
	//write form
	@RequestMapping("/writeView")
	public String writeView() {
		System.out.println("writeView ��û");
		return "writeView";
	}
	
	//bWrite
	@RequestMapping(value="/bWrite", produces="application/text; charset=UTF8")
	public String bWrite(HttpServletRequest request, Model model) {
		System.out.println("bWrite ��û");
		com = new EzenBoardWriteCommand();
		com.execute(request, model);
		/* ajax�� ������� ������(one page�� �ƴҶ�)�� redirect�� ���
		return "redirect:eBoardView" */
		//ajax�� ���� command�� ���
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView";
	}
	
	//contentView
	@RequestMapping("/contentView")
	public String contentView(HttpServletRequest request, Model model) {
		System.out.println("contentView ��û");
		com = new EzenBoardContentCommand();
		com.execute(request, model);
		return "contentView";
	}
	
	//modify
	@RequestMapping(value="/modify", produces="application/text; charset=UTF8")
	public String modify(HttpServletRequest request, Model model) {
		System.out.println("modify ��û");
		com = new EzenBoardModifyCommand();
		com.execute(request, model);
		//���� �� ����Ʈ
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView";
	}
	
	@RequestMapping("/delete")
	public String delete(HttpServletRequest request, Model model) {
		System.out.println("delete ��û");
		com = new EzenBoardDeleteCommand();
		com.execute(request, model);
		//���� �� ����Ʈ
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView"; 
	}
	
	@RequestMapping(value="/replyView", produces="application/text; charset=UTF8")
	public String replyView(HttpServletRequest request, Model model) {
		System.out.println("replyView ��û");
		com = new EzenBoardReplyViewCommand();
		com.execute(request, model);
		return "replyWrite";
	}
	
	@RequestMapping(value="/reply", produces="application/text; charset=UTF8")
	public String reply(EzenBoardDto dto, HttpServletRequest request, Model model) {
		System.out.println("reply ��û");
		request.setAttribute("formDto", dto);
		com = new EzenBoardReplyCommand();
		com.execute(request, model);
		//��� �ۼ� �� ����Ʈ
		com = new EzenBoardListCommand();
		com.execute(request, model);
		return "eBoardView"; 
	}

	@RequestMapping("/util")
	public String util() {
		System.out.println("util ��û");
		return "utils";
	}
	//CK Edit(�ܺ� ���̺귯���� security�� ������ �� ���� >> security-context.xml���� ��ó�� ����) 
	@RequestMapping("/ckedit")//���� DB�� ������ �ƴ�
	public void ckedit(MultipartHttpServletRequest request, HttpServletResponse response) throws IOException{
		System.out.println("ckedit(����â �̹��� ó��) ��û");
		//����â���� PC�� �̹����� ����� ��� �������� �̹����� �޾� �ٷ� ����
		String path = "/ezenPJT/editUpload";//������ ��������: resources�� ���ε� �̹����� ��û�� request ��� �غ�
		String real_save_path = request.getServletContext().getRealPath(path);//��Ĺ������ ����Ǵ� ��ġ
		System.out.println("real path: " + real_save_path);
		
		//MultipartFile�� �̿��� ������ ���ε�
		MultipartFile mf = request.getFile("upload");//ckedit request���� type="file"�� name�� upload�� ����
		String originFileName = mf.getOriginalFilename();
		long fileSize = mf.getSize();
		System.out.println(originFileName + "// size: " + fileSize);
		
		//�����̸� �ߺ�����
		String uuid = UUID.randomUUID().toString();
		//���� ����
		String path1 = "F:/WorkSpace/ezenMini0420/src/main/webapp/resources/editUpload/";//workspace
		String path2 = "F:/DevelopStudyResource/TomcatServer/apache-tomcat-9.0.63/wtpwebapps/ezenMini0420/resources/editUpload/";//tomcat(���� ���񽺿��� ����)
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
		//������ �� �� �̹����� CK Editor�� ����â���� ���� 
		JSONObject outData = new JSONObject(); //Java�� Map�� ����(key:value), put()...
		//key�� value�� ������ ����(CK Editor�� ��⿡�� ��û�ϴ� key �� ���)
		outData.put("uploaded",true);//���ε� Ȯ��
		//url = protocol://������(�����ּ�:��Ʈ)/request ���/���ϸ�
		outData.put("url",request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/"+changeFileName);
		//key������ url ����
		String url = (String)outData.get("url");
		System.out.println("uploaded url: " + url);
		//HttpServletResponse�� ���� ����
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(outData.toString());
	}
	//ckedit1(������ db�� ����)
	@RequestMapping(value="/ckedit1", produces="application/text; charset=UTF8")//ajax�� ��û�� �����Ҷ� �ѱ� ó��(return��)
	public String ckedit1(EditorDto dto, HttpServletRequest request, Model model) {
		System.out.println("ckedit1 ��û");
		//mapping�� dto�� �Ⱦ��� getParameter()�� ����� data�� �غ�
		request.setAttribute("edDto", dto);
		//DB�� insert
		com = new EditorInsertCommand();
		com.execute(request, model);
		//���� �� list ��û
		com = new EditorListCommand();
		com.execute(request, model);
		return "editorList";
	}
	//ckeditList
	@RequestMapping(value="/cedList",produces="application/text; charset=UTF8")
	public String cedList(HttpServletRequest request, Model model) {
		System.out.println("cedList ��û");
		com = new EditorListCommand();
		com.execute(request, model);
		return "editorList";
	}
	//server-sent event
	@RequestMapping("/sse")
	public String sse() {
		System.out.println("SSE ��û");
		return "sseView";
	}
	//edContView��û ó��
	@RequestMapping(value="/edContView", produces="application/text; charset=UTF8")
	public String edContView(HttpServletRequest request, Model model) {
		com = new EditorDetailCommand();
		com.execute(request, model);
		return "edDetailView";
	}
	@RequestMapping("/seventEx")
	public void seventEx(HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("single sse");
		response.setContentType("text/event-stream");//event-stream���� sseó��
		response.setCharacterEncoding("UTF-8");
		//response��ü�� ��� ����.
		PrintWriter writer = response.getWriter();
		for(int i=0;i<20;i++) {
			writer.write("data: " + System.currentTimeMillis() + "\n\n");
			//client�� event��ü�� JSON ���·� ����: "data:����ð�"
			writer.flush();
			try {//�ݺ� ���� 1��
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
		
		//client�� ���� �̹�Ʈ ��ü
		int upVote = 0;
		int downVote = 0;
		
		for(int i = 0; i<20; i++) {
			upVote += (int)(Math.random()*10);
			downVote += (int)(Math.random()*10);
			
			//event:�̺�Ʈ����
			//data:�ش� �̺�Ʈ�� �� ��(�߻���Ų ����)
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
		System.out.println("fCalendar ��û");
		return "fCalendar";
	}
	@RequestMapping(value="/calendar", produces="application/json; charset=UTF8")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> carledar( HttpServletRequest request, Model model) {
		System.out.println("calendar ��û");
		System.out.println("cId: " + request.getParameter("cId"));
		
		com = new CalendarListCommand();
		com.execute(request, model);
		
		//������ �����͸� ó���� calendarList
		HashMap<String, Object> map = (HashMap<String, Object>)model.asMap();
		ArrayList<FullCalendarDto> calendarList = (ArrayList)map.get("calendarList");
		//�����͸� ���� clistArr
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
		System.out.println("calendarInsert ��û");
		String start = fullCalendarDto.getcStart();
		String end = fullCalendarDto.getcEnd();
		
		//���ڿ� ������ �ð� data�� LocalDateTime�������� ��ȯ, DateTimeFormatter�� ����� �� ����. 
		//DateTimeFormatter formatDateTime = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
		//LocalDateTime localDateTime = LocalDateTime.from(formatDateTime.parse(start));

		//������ �ð�ǥ�ÿ� z�� �ٴ� ��� �۵��� ���� �� �־� ISO������ ����� ����
		DateTimeFormatter ISO_DATE_TIME = DateTimeFormatter.ISO_DATE_TIME;
		LocalDateTime localDateStart = LocalDateTime.from(ISO_DATE_TIME.parse(start));
		//LocalDateTime�� Timestamp�� ��ȯ
		Timestamp stampStart = Timestamp.valueOf(localDateStart);
		
		//end�� ��������
		LocalDateTime localDateEnd = LocalDateTime.from(ISO_DATE_TIME.parse(end));
		Timestamp stampEnd = Timestamp.valueOf(localDateEnd);
		
		System.out.println("stamp start: " + stampStart);
		System.out.println("stamp end: " + stampEnd);
		
		//�ð������ ���� millisecond�� ����ϱ����� posix�������� ��ȯ(���� �Ⱦ�)
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
		System.out.println("calendarUpdate ��û");
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
		System.out.println("calendarDelete ��û");
		System.out.println("calendarDelete No: " + fullCalendarDto.getcNo());
		
		request.setAttribute("dto", fullCalendarDto);
		com = new CalendarDeleteCommand(); 
		com.execute(request, model);
		return "success";
	}
	//���Ϻ�ȯ
	@RequestMapping("/fconvert")  
	public String fconvert() {
		System.out.println("fconvert");
		return "fconvertView";
	}
	//pdf �����ֱ� 
	@RequestMapping("/pdfPlay") 
	public String pdfPlay() {
		System.out.println("pdfPlay");
		return "pdfPlay";
	}
	@RequestMapping("/about")
	public String about(){
		System.out.println("about ��û");
		return "about";
	}
	
	//dashboard ����
	@RequestMapping("/dash")
	public String dash() {
		return "dashBoard";
	}
	
	@RequestMapping(value="/dashView", produces="application/json; charset=UTF8")
	@ResponseBody
	public JSONObject dashView(HttpServletRequest request, Model model) {
		System.out.println("dashView ��û");
		String subcmd = request.getParameter("subcmd");
		System.out.println("subcmd: " + subcmd);
		
		com = new DashBoardCommand();
		com.execute(request, model);
		
		JSONObject result = getDashData(request, model);
		return result;
	}
	//map������ ���� JSONObject�� ���·� ��ȯ
	private JSONObject getDashData(HttpServletRequest request, Model model) {
		HashMap<String, Object> dashMap = (HashMap<String, Object>)model.asMap();
		ArrayList<DashBoardDto> dashList = (ArrayList<DashBoardDto>)dashMap.get("dashArray");//command���� ������ key��
		
		JSONArray dashArr = new JSONArray();
		for(DashBoardDto dto : dashList) {
			JSONObject data = new JSONObject();
			//JSONObject ��ü�� map����(key-value)���ε� JSON��ü
			data.put("month", dto.getMonth());
			data.put("pc", dto.getPcQty());
			data.put("monitor", dto.getMonitorQty());
			
			dashArr.add(data);
		}
		JSONObject result = new JSONObject();
		//JSONObject result�� key�� datas�� value dashArr��ü�� ���´�. 
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
		System.out.println("statis��û");
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
