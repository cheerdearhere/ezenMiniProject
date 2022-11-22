package com.kook.ezenPJT.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EditorDto;
import com.kook.ezenPJT.util.Constant;

public class EditorListCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		String username = request.getParameter("edUser");
		ArrayList<EditorDto> dtos = edao.editorList(username);
		model.addAttribute("editorList",dtos);
	}
}
