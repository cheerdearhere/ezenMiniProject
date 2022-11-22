package com.kook.ezenPJT.command;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import org.springframework.ui.Model;
import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenBoardDto;
import com.kook.ezenPJT.util.Constant;
public class EzenBoardListCommand implements EzenCommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		ArrayList<EzenBoardDto> dtos = edao.list();
		model.addAttribute("listContent", dtos);
	}

}
