package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface EzenCommand {
	public void execute(HttpServletRequest request, Model model);
}
