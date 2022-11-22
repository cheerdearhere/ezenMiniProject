package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.RecipeOrderDto;
import com.kook.ezenPJT.util.Constant;

public class RecipeOrderCommand implements EzenCommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		RecipeOrderDto dto = (RecipeOrderDto)request.getAttribute("rodto");
		edao.recipeOrder(dto);
	}
}
