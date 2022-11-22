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
		EzenJoinDto fdto = null;//EZENUSER DB의 record와 mapping
		AuthUserDto adto = null;//social login을 저장할 AUTHUSER DB의 record와 mapping
		Boolean flag = false;
		
		if(username.startsWith("kakao_") || username.startsWith("naver_") || username.startsWith("google_")) {
			//username의 시작이 social을 통한경우 AuthUserDto를 사용
			adto = edao.authLogin(username);
		}
		else {//social login이 아닌경우 EzenUserDto를 사용
			fdto = edao.login(username);
			flag=true;
			if(fdto == null) {
				System.out.println("Spring security에서 dto null로 로그인 실패");
				throw new UsernameNotFoundException("No user found with username");
				//spring security에서 예외를 처리
			}
		}
		
		System.out.println("EzenJoinDto: " + fdto);
		System.out.println("AuthUserDto: " + adto);

		if(flag) { //flag == true인 경우
			String pw = fdto.getPpw();//EzenJoinDto
			String auth = fdto.getAuth();
			System.out.println("pw: " + pw + "// auth: " + auth);
			Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
			//roles: ROLE_USER, ROLE_MANAGE, ROLE_ADMIN 등 권한 값을 받는 객체(여러 권한을 받을 수 있어 ArrayList 사용)
			//ROLE_TEMPORARY_USER는 임시사용자
			roles.add(new SimpleGrantedAuthority(auth));
			UserDetails user = new User(username,pw,roles);
			return user;
		}
		else {//flag==false인경우
			String pw = adto.getAuthPw();//AuthUserDto
			String auth = adto.getAuth();
			//이후 과정은 같음
			System.out.println("pw: " + pw + "// auth: " + auth);
			Collection<SimpleGrantedAuthority> roles = new ArrayList<SimpleGrantedAuthority>();
			roles.add(new SimpleGrantedAuthority(auth));
			UserDetails user = new User(username,pw,roles);
			return user;
		}
	}
}
