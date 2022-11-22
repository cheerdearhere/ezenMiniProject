package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.util.Constant;

public class EzenBoardModifyCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		
		int bId = Integer.parseInt(request.getParameter("bId"));
		String bTitle = request.getParameter("bTitle");
		String bName =request.getParameter("bName");
		String bContent = request.getParameter("bContent");
		
		EzenBoardDto dto = new EzenBoardDto(bId,bName,bTitle,bContent);
		edao.modify(dto);
	}
}
