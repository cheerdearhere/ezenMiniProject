package com.kook.ezenPJT.dao;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import com.kook.ezenPJT.dto.AuthUserDto;
import com.kook.ezenPJT.dto.DashBoardDto;
import com.kook.ezenPJT.dto.EditorDto;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.dto.EzenJoinDto;
import com.kook.ezenPJT.dto.FullCalendarDto;
import com.kook.ezenPJT.dto.RecipeDto;
import com.kook.ezenPJT.dto.RecipeOrderDto;

public class EzenDao implements IEzenDao {
	@Autowired
	private SqlSession sqlSession;
	
	@Override
	public String join(EzenJoinDto dto) {
		System.out.println("join() method");
		String result=null;
		try {
			int res = sqlSession.insert("join", dto);
			System.out.println("result: " + res);
			if(res>0) {
				result = "success";
			}
			else {
				result = "failed";
			}
		}
		catch(Exception e) {
			e.printStackTrace();
			result="failed";
		}
		return result;
	}
	
	@Override //일반 로그인
	public EzenJoinDto login(String pid) {
		System.out.println(pid + "login method");
		EzenJoinDto result = sqlSession.selectOne("login", pid);
		return result;
	}
	//social login 등록 
	@Override
	public void authDB(AuthUserDto dto) {
		System.out.println("social Auth DB method");
		String authUsername = dto.getAuthUsername();
		AuthUserDto result = sqlSession.selectOne("authDB",authUsername);
		if(result == null) {//이전 등록한 기록이 없으면 생성
			authInsert(dto);
		}
	}
	@Override
	public void authInsert(AuthUserDto dto) {
		System.out.println("social Auth DB Insert method");
		int res = sqlSession.insert("authInsert",dto);
		System.out.println(res);
	}
	@Override//social login 처리
	public AuthUserDto authLogin(String uesrname) {
		System.out.println("Auth DB login method");
		AuthUserDto dto = sqlSession.selectOne("authLogin", uesrname);
		return dto;
	}
	//recipe관련 
	@Override
	public ArrayList<RecipeDto> recipeList(){
		System.out.println("recipeList() method");
		ArrayList<RecipeDto> dtos = (ArrayList)sqlSession.selectList("recipeList");
		return dtos;
	}
	@Override
	public String recipeWrite(RecipeDto dto) {
		System.out.println("recipeWrite() method");
		String result;
		int res = sqlSession.insert("recipeWrite", dto);
		if(res==1) {
			result = "success";
		}
		else {
			result = "failed";
		}
		return result;
	}
	@Override
	public RecipeDto recipeDetails(int rId) {
		System.out.println("recipeDetails() method");
		RecipeDto dto = sqlSession.selectOne("recipeDetails", rId);
		return dto;
	}
	@Override
	public void recipeOrder(RecipeOrderDto dto) {
		System.out.println("recipeOrder() method"); 
		int res = sqlSession.insert("recipeOrder", dto);
	}
	@Override
	public ArrayList<RecipeOrderDto> recipeOrderList(String oUser){
		System.out.println("recipeOrderList() method");
		ArrayList<RecipeOrderDto> dtos = (ArrayList)sqlSession.selectList("recipeOrderList",oUser);
		return dtos;
	}
	
	@Override 
	public String adminAuth(String pid, String auth) {
		System.out.println("adminAuth() method");
		String result;
		EzenJoinDto dto = new EzenJoinDto(pid, auth);
		int res = sqlSession.update("adminAuth", dto);
		System.out.println("auth res: " + res);
		if(res > 0) {
			result = "success";
		}
		else {
			result = "failed";
		}
		return result;
	}
	
	//board select
	@Override
	public ArrayList<EzenBoardDto> list(){
		System.out.println("list() method");
		ArrayList<EzenBoardDto> dtos = (ArrayList)sqlSession.selectList("list");
		return dtos;
	}
	//pagination select
	@Override
	public ArrayList<EzenBoardDto> pageList(String pageNo){
		System.out.println("pageList() method");
		int page = Integer.parseInt(pageNo);
		int startNo = (page - 1) * 10 + 1;
		System.out.println("startNo: " + startNo);
		ArrayList<EzenBoardDto> result = (ArrayList)sqlSession.selectList("pageList", startNo);
		return result;		
	}
	//searchList
	@Override
	public ArrayList<EzenBoardDto> searchList() {
		ArrayList<EzenBoardDto> dtos = (ArrayList)sqlSession.selectList("searchList");		
		return dtos;
	}	
	//bwrite
	@Override
	public void bWrite(String name, String title, String content) {
		System.out.println("bWrite() method");
		EzenBoardDto dto = new EzenBoardDto(name,title,content);
		sqlSession.insert("bWrite", dto);
	}
	
	//contentView
	@Override
	public EzenBoardDto contentView(String bid) {
		System.out.println("contentView() method");
		int bId = Integer.parseInt(bid);
		upHit(bId);
		EzenBoardDto dto = sqlSession.selectOne("contentView", bId);
		return dto;
	}
	
	//Hits
	@Override
	public void upHit(int bId) {
		System.out.println("upHit() method");
		sqlSession.update("upHit", bId);
	}
	
	//board modify
	@Override
	public void modify(EzenBoardDto dto) {
		System.out.println("board modify() method");
		sqlSession.update("modify", dto);
	}
	
	//board delete
	@Override
	public void delete(int bId) {
		System.out.println("board delete() method");
		sqlSession.delete("delete", bId);
	}
	
	//replyView
	@Override
	public EzenBoardDto replyView(int bId) {
		System.out.println("replyView() method");
		EzenBoardDto dto = sqlSession.selectOne("replyView", bId);
		return dto;
	}
	
	//reply
	@Override
	public void reply(EzenBoardDto dto) {
		System.out.println("reply() method");
		//group과 step을 기준으로 모양 입력하는 일반 method
		replyShape(dto.getbGroup(), dto.getbStep());
		int res = sqlSession.insert("reply", dto);
		System.out.println("result:" + res);
	}
	
	//reply 모양 처리: IEzenDao interface에도 추가
	@Override
	public void replyShape(int bGroup, int bStep) {
		System.out.println("replyShape() method");
		EzenBoardDto dto = new EzenBoardDto(bGroup, bStep);
		int res = sqlSession.update("replyShape", dto);
	}
//util관련
	//CK editor
	@Override
	public void editorInsert(EditorDto dto) {
		System.out.println("editorInsert() method");
		int res = sqlSession.insert("editorInsert", dto);
	}
	//editor 결과를 DB에 저장
	@Override
	public ArrayList<EditorDto> editorList(String username){
		System.out.println("editorList() method");
		ArrayList<EditorDto> dtos = (ArrayList)sqlSession.selectList("editorList", username);
		return dtos;
	}
	@Override
	public EditorDto editorDetail(int edid) {
		System.out.println("editorDetail() method");
		EditorDto dto = sqlSession.selectOne("editorDetail", edid);
		return dto;
	}
	//FullCalendar insert
	@Override 
	public void calendarInsert(FullCalendarDto dto) {
		System.out.println("calendarInsert() method");
		int res = sqlSession.insert("calendarInsert", dto);
	}
	
	//FullCaledar list
	@Override
	public ArrayList<FullCalendarDto> calendarList(String cId){
		System.out.println("calendarList() method");
		ArrayList<FullCalendarDto> list = (ArrayList)sqlSession.selectList("calendarList",cId);
		return list;
	}
	
	//FullCalendar Update
	@Override
	public void calendarUpdate(FullCalendarDto dto) {
		System.out.println("calendarUpdate() method");
		int res = sqlSession.update("calendarUpdate", dto);
	}
	
	//fullCalendar delete 
	@Override
	public void calendarDelete(FullCalendarDto dto) {
		System.out.println("calendarDelete() method");
		int res = sqlSession.delete("calendarDelete",dto);
	}
	
	//dashboard List
	@Override
	public ArrayList<DashBoardDto> dashBoardList(){
		System.out.println("dashBoardList() method");
		ArrayList<DashBoardDto> dtos = (ArrayList)sqlSession.selectList("dashBoardList");
		return dtos;
	}
	//dashboard write
	@Override
	public void dashBoardWrite(DashBoardDto dto) {
		System.out.println("dashBoard DB 입력 처리");
		int res = sqlSession.insert("dashBoardWrite", dto);
	}
	
	
}