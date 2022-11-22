package com.kook.ezenPJT.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.util.Constant;

public class EzenBoardSearchListCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;		
		ArrayList<EzenBoardDto> dtos = edao.searchList();
		//리턴된 jsp페이지에 dtos값 포함
		model.addAttribute("listContent", dtos);
	}

}
