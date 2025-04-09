package pack.member;

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
			MemberMapperInter inter = sqlSession.getMapper(MemberMapperInter.class);
			String existId=inter.checkId(id);     
			if(existId != null) { 
				b = true;
			} else {
				b = false;
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
			MemberMapperInter inter = sqlSession.getMapper(MemberMapperInter.class);
			  
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

	public boolean loginCheck(String id) {

		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
		
		try {
			MemberMapperInter inter = sqlSession.getMapper(MemberMapperInter.class);

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
			MemberMapperInter inter = sqlSession.getMapper(MemberMapperInter.class);

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
	public boolean memberUpdate(MemberBean memberBean) {

		SqlSession sqlSession = sqlSessionFactory.openSession();
		boolean b = false;
				
		try {

			MemberMapperInter inter = sqlSession.getMapper(MemberMapperInter.class);
				// 비밀번호 비교 후 업데이트 결정
				if(inter.updateMemberData(memberBean) > 0) b = true;
				sqlSession.commit();

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
			MemberMapperInter inter = sqlSession.getMapper(MemberMapperInter.class);
			
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
