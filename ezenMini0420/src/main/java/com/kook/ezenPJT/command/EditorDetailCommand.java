package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EditorDto;
import com.kook.ezenPJT.util.Constant;

public class EditorDetailCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		int edid = Integer.parseInt(request.getParameter("edId"));
		EditorDto dto = edao.editorDetail(edid);
		model.addAttribute("editDto", dto);
	}
}
