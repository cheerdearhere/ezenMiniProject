package com.kook.ezenPJT.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.util.Constant;

public class EzenBoardPageListCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		String pageNo = request.getParameter("pageNo");
		ArrayList<EzenBoardDto> dtos = edao.pageList(pageNo);
		//view에서 사용할 객체명
		model.addAttribute("listContent",dtos);
	}
}
