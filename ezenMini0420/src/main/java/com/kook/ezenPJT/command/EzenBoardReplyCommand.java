package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.util.Constant;

public class EzenBoardReplyCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		//form-dto-DB가 mapping된 경우 매개변수에서 바로 받아 사용할 수 있다.
		EzenBoardDto dto = (EzenBoardDto)request.getAttribute("formDto");
		edao.reply(dto);
		
		/*form에서 가져올 내용 준비(dto객체를 사용하지 않는 경우)
		int bId = Integer.parseInt(request.getParameter("bId"));
		String bTitle = request.getParameter("bTitle");
		String bContent = request.getParameter("bContent");*/
	}
}
