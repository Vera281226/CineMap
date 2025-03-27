package pack.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class CommentManager {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private DataSource ds;

    public CommentManager() {
        try {
            Context context = new InitialContext();
            ds = (DataSource) context.lookup("java:comp/env/jdbc_maria");
        } catch (Exception e) {
            System.out.println("DataSource 연결 실패: " + e.getMessage());
        }
    }

    // 게시판 댓글 전체 읽기
    public ArrayList<CommentDTO> getCommentsByPost(int postNo) {
    	ArrayList<CommentDTO> list = new ArrayList<CommentDTO>();
        String sql = "SELECT * FROM comments WHERE no = ? ORDER BY gno DESC, ono ASC";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postNo);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                CommentDTO dto = new CommentDTO();
                dto.setNo(rs.getInt("no"));
                dto.setName(rs.getString("name"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setLikes(rs.getInt("likes"));
                dto.setGno(rs.getInt("gno"));
                dto.setOno(rs.getInt("ono"));
                dto.setNested(rs.getInt("nested"));
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getCommentsByPost err: " + e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
            	// TODO: handle exception
            }
        }
        return list;
    }
}