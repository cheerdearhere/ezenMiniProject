package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.FullCalendarDto;
import com.kook.ezenPJT.util.Constant;

public class CalendarDeleteCommand implements EzenCommand {
	@Override
	public void execute(HttpServletRequest request, Model model) {
		EzenDao edao = Constant.edao;
		FullCalendarDto dto = (FullCalendarDto)request.getAttribute("dto");
		edao.calendarDelete(dto);
	}
} 
