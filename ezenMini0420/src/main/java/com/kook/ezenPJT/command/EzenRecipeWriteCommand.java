package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;
import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.RecipeDto;
import com.kook.ezenPJT.util.Constant;

public class EzenRecipeWriteCommand implements EzenCommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		RecipeDto dto = (RecipeDto)request.getAttribute("rdto");
		String result = edao.recipeWrite(dto);
		model.addAttribute("result", result);
	}

}
