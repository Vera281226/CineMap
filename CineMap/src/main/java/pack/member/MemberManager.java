package pack.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import pack.mybatis.SqlMapConfig;

public class MemberManager {
	private SqlSessionFactory sqlSessionFactory = SqlMapConfig.getSqlSession();
	
	// 아이디 중복확인
	public boolean idCheckProcess(String id) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
		
		try {
			SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
			
			String existId=inter.checkId(id);
			if(existId != null) {
				b = false;
			} else {
				b = true;
			}
			sqlSession.commit();
			inter=null;
		} catch (Exception e) {
			System.out.println("idCheckProcess err: " + e.getMessage());
			sqlSession.rollback();
		} finally {
			if(sqlSession != null) sqlSession.close();
		}
		return b;
	}
	
	// 회원가입
	public boolean memberInsert(MemberBean mbean) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
		
		try { 
			SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
			
			if(inter.insertMemberData(mbean) > 0) b = true;
			sqlSession.commit();
			inter = null;
		} catch (Exception e) {
			System.out.println("memberInsert err: " + e.getMessage());
			sqlSession.rollback();
		} finally {
			if(sqlSession != null) sqlSession.close();
		}
		return b;
	}
	
	// 로그인 확인
	public boolean loginCheck(String id, String passwd) { 
		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
		
		try {
			SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
			
			MemberDto dto=inter.selectLogin(id);
			if(dto != null) b = true;
			inter = null;
		} catch (Exception e) {
			System.out.println("loginCheck err: " + e.getMessage());
			sqlSession.rollback();
		} finally {
			if(sqlSession != null) sqlSession.close();
		}
		return b;
	}
	
	// 로그인한 회원 정보 얻기
	public MemberDto getMember(String id) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		MemberDto memberDto = null;
		try {
			SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
			memberDto = inter.selectMemberPart(id);
			inter = null;
		} catch (Exception e) {
			System.out.println("getMember err: " + e.getMessage());
			sqlSession.rollback();
		} finally {
			if(sqlSession != null) sqlSession.close();
		}
		return memberDto;
	}
	
	// 회원 수정
	public boolean memberUpdate(MemberBean memberBean, String id) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
				
		try {
			SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
			
			// 비밀번호 비교 후 업데이트 결정
			MemberDto dto = inter.selectMemberPart(id);
			if(dto.getPasswd().equals(memberBean.getPasswd())) {
				if(inter.updateMemberData(memberBean) > 0) b = true;
				sqlSession.commit();
			}
			inter = null;
			
		} catch (Exception e) {
			System.out.println("memberUpdate err: " + e.getMessage());
			sqlSession.rollback();
		} finally {
			if(sqlSession != null) sqlSession.close();
		}
		return b;
	}
	
	public boolean memberDelete(String id) {
		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
		
		try {
			SqlMapperInter inter = sqlSession.getMapper(SqlMapperInter.class);
			
			int count = inter.deleteMemberData(id);
			if(count > 0) {
				b = true;
				sqlSession.commit();	
			}else {
				sqlSession.rollback();
			}
			inter = null;
		} catch (Exception e) {
			System.out.println("memberDelete err: " + e.getMessage());
			sqlSession.rollback();
		} finally {
			if(sqlSession != null) sqlSession.close();
		}
		return b; 
	}
}
