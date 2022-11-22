package com.kook.ezenPJT.command;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.FullCalendarDto;
import com.kook.ezenPJT.util.Constant;

public class CalendarListCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		
		String cId = request.getParameter("cId");
		ArrayList<FullCalendarDto> dtos = edao.calendarList(cId);
		model.addAttribute("calendarList",dtos);
	}
}
