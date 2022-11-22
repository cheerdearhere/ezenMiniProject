package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.util.Constant;

public class EzenBoardContentCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		String bid = request.getParameter("bId");
		System.out.println(bid);
		
		EzenBoardDto dto = edao.contentView(bid);
		
		if(dto != null) {
			model.addAttribute("contentView", dto);
		}
	}
}
