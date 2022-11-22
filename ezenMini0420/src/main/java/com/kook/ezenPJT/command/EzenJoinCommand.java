package com.kook.ezenPJT.command;

import javax.servlet.http.HttpServletRequest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.ui.Model;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.EzenJoinDto;
import com.kook.ezenPJT.util.Constant;

public class EzenJoinCommand implements EzenCommand {

	@Override
	public void execute(HttpServletRequest request, Model model) {
		//암호화 객체
		BCryptPasswordEncoder passwordEncoder = Constant.passwordEncoder;
		//form의 원소값 추출
		String bid = request.getParameter("pid");
		String bpw = request.getParameter("ppw");
		String baddress = request.getParameter("paddress");
		String bhobby = request.getParameter("phobby");
		String bprofile = request.getParameter("pprofile");
		
		String bpw_org = bpw;
		bpw = passwordEncoder.encode(bpw_org);
		
		EzenJoinDto dto = new EzenJoinDto(bid,bpw,baddress,bhobby,bprofile,null,null);
		
		EzenDao edao = Constant.edao;
		String result = edao.join(dto);
		request.setAttribute("result", result);
	}

}
