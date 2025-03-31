package pack.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MemberManager {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	private DataSource ds;
	
	public MemberManager() {
		try {
			Context context = new InitialContext();
			ds = (DataSource)context.lookup("java:comp/env/jdbc_maria");
		} catch (Exception e) {
			System.out.println("Driver 로딩 실패: " + e.getMessage());
		}
	}
	
	// 아이디 중복확인
	public boolean idCheckProcess(String id) {
		boolean b = false;
		
		try {
			conn = ds.getConnection();
			String sql = "select id from member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			b = rs.next();
		} catch (Exception e) {
			System.out.println("idCheckProcess err: " + e.getMessage());
		} finally {
			try {
				if (rs != null) rs.close();
				if (pstmt != null) pstmt.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {
				System.out.println(e2.getMessage());
			}
		}
		return b;
	}
	
	// 회원가입
	public boolean memberInsert(MemberBean mbean) {
		boolean b = false;
		
		try {
			conn = ds.getConnection();
			String sql = "insert into member values(?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,mbean.getId());
			pstmt.setString(2,mbean.getPasswd());
			pstmt.setString(3,mbean.getName());
			pstmt.setString(4,mbean.getNickname());
			pstmt.setString(5,mbean.getEmail());
			pstmt.setString(6,mbean.getPhone());
			pstmt.setString(7,mbean.getBirthdate());
			
			if(pstmt.executeUpdate() > 0) b = true;
			
		} catch (Exception e) {
			System.out.println("memberInsert err: " + e.getMessage());
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				System.out.println(e2.getMessage());
			}
		}
		return b;
	}
	
	// 로그인 확인
	public boolean loginCheck(String id, String passwd) {
		boolean b = false;
		
		try {
			conn = ds.getConnection();
			String sql = "select * from member where id=? and passwd=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, passwd);
			rs = pstmt.executeQuery();
			b = rs.next();
			
		} catch (Exception e) {
			System.out.println("loginCheck err: " + e.getMessage());
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				System.out.println(e2.getMessage());
			}
		}
		return b;
	}
	
	// 회원 수정용 정보 얻기
	public MemberDto getMember(String id) {
		MemberDto memberDto = null;
		try {
			conn = ds.getConnection();
			String sql = "select * from member where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				memberDto = new MemberDto();
				memberDto.setId(rs.getString("id"));
				memberDto.setPasswd(rs.getString("passwd"));
				memberDto.setName(rs.getString("name"));
				memberDto.setNickname(rs.getString("nickname"));
				memberDto.setEmail(rs.getString("email"));
				memberDto.setPhone(rs.getString("phone"));
				memberDto.setBirthdate(rs.getString("birthdate"));
				
			}
		} catch (Exception e) {
			System.out.println("getMember err: " + e.getMessage());
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				System.out.println(e2.getMessage());
			}
		}
		return memberDto;
	}
	
	// 회원 수정
	public boolean memberUpdate(MemberBean memberBean,String id) {
		boolean b = false;
		
		String sql = "update member set passwd=?,name=?,nickname=?,email=?,phone=?,birthdate=? where id=?";
		
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,memberBean.getPasswd());
			pstmt.setString(2,memberBean.getName());
			pstmt.setString(3,memberBean.getNickname());
			pstmt.setString(4,memberBean.getEmail());
			pstmt.setString(5,memberBean.getPhone());
			pstmt.setString(6,memberBean.getBirthdate());
			
			if(pstmt.executeUpdate()>0) b= true;
		} catch (Exception e) {
			System.out.println("memberUpdate err: " + e);
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				e2.getStackTrace();
			}
		}
		return b;
	}
}