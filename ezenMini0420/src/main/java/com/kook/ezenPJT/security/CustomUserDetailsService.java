package com.kook.ezenPJT.security;

import java.util.ArrayList;
import java.util.Collection;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.kook.ezenPJT.dao.EzenDao;
import com.kook.ezenPJT.dto.AuthUserDto;
import com.kook.ezenPJT.dto.EzenJoinDto;
import com.kook.ezenPJT.util.Constant;

public class CustomUserDetailsService implements UserDetailsService {

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		EzenDao edao = Constant.edao;
		EzenJoinDto fdto = null;//EZENUSER DB�� record�� mapping
		AuthUserDto adto = null;//social login�� ������ AUTHUSER DB�� record�� mapping
		Boolean flag = false;
		
		if(username.startsWith("kakao_") || username.startsWith("naver_") || username.startsWith("google_")) {
			//username�� ������ social�� ���Ѱ�� AuthUserDto�� ���
			adto = edao.authLogin(username);
		}
		else {//social login�� �ƴѰ�� EzenUserDto�� ���
			fdto = edao.login(username);
			flag=true;
			if(fdto == null) {
				System.out.println("Spring security���� dto null�� �α��� ����");
				throw new UsernameNotFoundException("No user found with username");
				//spring security���� ���ܸ� ó��
			}
		}
		
		System.out.println("EzenJoinDto: " + fdto);
		System.out.println("AuthUserDto: " + adto);

		if(flag) { //flag == true�� ���
			String pw = fdto.getPpw();//EzenJoinDto
			String auth = fdto.getAuth();
			System.out.println("pw: " + pw + "// auth: " + auth);
			Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
			//roles: ROLE_USER, ROLE_MANAGE, ROLE_ADMIN �� ���� ���� �޴� ��ü(���� ������ ���� �� �־� ArrayList ���)
			//ROLE_TEMPORARY_USER�� �ӽû����
			roles.add(new SimpleGrantedAuthority(auth));
			UserDetails user = new User(username,pw,roles);
			return user;
		}
		else {//flag==false�ΰ��
			String pw = adto.getAuthPw();//AuthUserDto
			String auth = adto.getAuth();
			//���� ������ ����
			System.out.println("pw: " + pw + "// auth: " + auth);
			Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
			roles.add(new SimpleGrantedAuthority(auth));
			UserDetails user = new User(username,pw,roles);
			return user;
		}
	}
}
