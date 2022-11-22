package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;
import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.util.Constant;

public class EzenBoardWriteCommand implements EzenCommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		String name= request.getParameter("bName");
		String title = request.getParameter("bTitle");
		String content = request.getParameter("bContent");
		
		edao.bWrite(name,title,content);
	}
}
