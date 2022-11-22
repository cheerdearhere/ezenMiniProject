package com.kook.ezenPJT.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.RecipeOrderDto;
import com.kook.ezenPJT.util.Constant;

public class RecipeOrderListCommand implements EzenCommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		String oUser = request.getParameter("rOuser");
		ArrayList<RecipeOrderDto> dtos = (ArrayList<RecipeOrderDto>)edao.recipeOrderList(oUser);
		model.addAttribute("recipeOrderList", dtos);
	}
}
