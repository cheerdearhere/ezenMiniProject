package com.kook.ezenPJT.dao;

import java.util.ArrayList;

import com.kook.ezenPJT.dto.AuthUserDto;
import com.kook.ezenPJT.dto.DashBoardDto;
import com.kook.ezenPJT.dto.EditorDto;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.dto.EzenJoinDto;
import com.kook.ezenPJT.dto.FullCalendarDto;
import com.kook.ezenPJT.dto.RecipeDto;
import com.kook.ezenPJT.dto.RecipeOrderDto;

public interface IEzenDao {
	public String join(EzenJoinDto dto);
	public EzenJoinDto login(String pid);
	public ArrayList<RecipeDto> recipeList();	
	public String recipeWrite(RecipeDto dto);
	public RecipeDto recipeDetails(int rId);
	public void recipeOrder(RecipeOrderDto dto);
	public ArrayList<RecipeOrderDto> recipeOrderList(String oUser);
	public String adminAuth(String pid, String auth);
	public ArrayList<EzenBoardDto> list();
	public ArrayList<EzenBoardDto> pageList(String pageNo);
	public void bWrite(String name, String title, String content);
	public EzenBoardDto contentView(String bId);
	public void upHit(int bId);
	public void modify(EzenBoardDto dto);
	public void delete(int bId);
	public EzenBoardDto replyView(int bId);
	public void reply(EzenBoardDto dto);
	public void replyShape(int bGroup, int Bstep);
	//util page
	public void editorInsert(EditorDto dto);
	public ArrayList<EditorDto> editorList(String username);
	public EditorDto editorDetail(int edid);
	public void calendarInsert(FullCalendarDto dto);
	public ArrayList<FullCalendarDto> calendarList(String cId);
	public void calendarUpdate(FullCalendarDto dto);
	public void calendarDelete(FullCalendarDto dto);
	public ArrayList<DashBoardDto> dashBoardList();
	public void dashBoardWrite(DashBoardDto dto);
	public void authDB(AuthUserDto dto);
	public void authInsert(AuthUserDto dto);
	public AuthUserDto authLogin(String uesrname);
	public ArrayList<EzenBoardDto> searchList();
} 
