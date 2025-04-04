package pack.post;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class PostManager {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;
    private DataSource ds;

	public PostManager() {
		try {
			Context context = new InitialContext();
			ds = (DataSource)context.lookup("java:comp/env/jdbc_maria");
		} catch (Exception e) {
			System.out.println("Driver 로딩 실패: " + e.getMessage());
		}
	}

	// 게시판 전체 읽기
    public ArrayList<PostDTO> getAllPosts() {
    	ArrayList<PostDTO> list = new ArrayList<PostDTO>();
        String sql = "SELECT * FROM posts ORDER BY created_at DESC";
        try {
        	conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                list.add(dto);
            }
		} catch (Exception e) {
			System.out.println("getAllPosts err: " + e);
		} finally {
			try {
				if(rs != null) rs.close();
				if(pstmt != null) pstmt.close();
				if(conn != null) conn.close();
			} catch (Exception e2) {
				// TODO: handle exception
			}
		}
        return list;
    }

    // 게시글 수정
    public boolean updatePost(PostDTO dto) {
        boolean result = false;
        String sql = "UPDATE posts SET title=?, category=?, content=? WHERE no=?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getTitle());
            pstmt.setString(2, dto.getCategory());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt(4, dto.getNo());
            result = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("updatePost err: " + e.getMessage());
        } finally {
            try {
                if(pstmt != null) pstmt.close();
                if(conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return result;
    }
    
    // 게시글 1개 조회
    public PostDTO getPostByNo(int no) {
        PostDTO dto = null;
        String sql = "SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id WHERE p.no=?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, no);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setNickname(rs.getString("nickname")); // 여기 중요!
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
            }
        } catch (Exception e) {
            System.out.println("getPostByNo err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return dto;
    }
    
    // 게시글 작성
    public boolean insertPost(PostDTO dto) {
        boolean result = false;
        String sql = "INSERT INTO posts (no, id, category, title, content, created_at, views, likes) "
                   + "VALUES (?, ?, ?, ?, ?, NOW(), ?, ?)";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, dto.getNo());
            pstmt.setString(2, dto.getId());
            pstmt.setString(3, dto.getCategory());
            pstmt.setString(4, dto.getTitle());
            pstmt.setString(5, dto.getContent());
            pstmt.setInt(6, dto.getViews());
            pstmt.setInt(7, dto.getLikes());
            result = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("insertPost err: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return result;
    }
    
    // 가장 큰 글번호 조회 후 +1
    public int getNextPostNo() {
        int nextNo = 1;
        String sql = "SELECT IFNULL(MAX(no), 0) + 1 AS nextNo FROM posts";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                nextNo = rs.getInt("nextNo");
            }
        } catch (Exception e) {
            System.out.println("getNextPostNo err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return nextNo;
    }
    
    // 게시글 삭제
    public boolean deletePost(int no) {
        boolean result = false;
        Connection conn = null;
        PreparedStatement pstmt1 = null;
        PreparedStatement pstmt2 = null;

        try {
            conn = ds.getConnection();
            conn.setAutoCommit(false); // 트랜잭션 시작

            // 1. 댓글 먼저 삭제
            String deleteCommentsSql = "DELETE FROM comments WHERE post_no = ?";
            pstmt1 = conn.prepareStatement(deleteCommentsSql);
            pstmt1.setInt(1, no);
            pstmt1.executeUpdate();

            // 2. 게시글 삭제
            String deletePostSql = "DELETE FROM posts WHERE no = ?";
            pstmt2 = conn.prepareStatement(deletePostSql);
            pstmt2.setInt(1, no);
            int affected = pstmt2.executeUpdate();

            if (affected > 0) {
                conn.commit();  // 둘 다 성공 시 커밋
                result = true;
            } else {
                conn.rollback(); // 게시글 삭제 실패 시 롤백
            }

        } catch (Exception e) {
            System.out.println("deletePost err: " + e.getMessage());
            try {
                if (conn != null) conn.rollback();
            } catch (Exception e2) {}
        } finally {
            try {
                if (pstmt1 != null) pstmt1.close();
                if (pstmt2 != null) pstmt2.close();
                if (conn != null) conn.setAutoCommit(true); // 복구
                if (conn != null) conn.close();
            } catch (Exception e3) {}
        }
        return result;
    }
    
    // 카테고리별 게시글 조회
    public ArrayList<PostDTO> getPostsByCategory(String category) {
        ArrayList<PostDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM posts WHERE category = ? ORDER BY created_at DESC";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getPostsByCategory err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return list;
    }
    
    // 전체 게시글 페이징 조회
    public ArrayList<PostDTO> getPostsByPage(int start, int pageSize) {
        ArrayList<PostDTO> list = new ArrayList<>();
        String sql = "SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id ORDER BY p.created_at DESC LIMIT ?, ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, start);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                dto.setNickname(rs.getString("nickname")); // 닉네임 설정
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getPostsByPage err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return list;
    }
    
    // 전체 게시글 수
    public int getTotalPostCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM posts";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            System.out.println("getTotalPostCount err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return count;
    }
    
    // 카테고리 별 페이징 조회
    public ArrayList<PostDTO> getPostsByCategoryPage(String category, int start, int pageSize) {
        ArrayList<PostDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM posts WHERE category = ? ORDER BY created_at DESC LIMIT ?, ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            pstmt.setInt(2, start);
            pstmt.setInt(3, pageSize);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getPostsByCategoryPage err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return list;
    }
    
    // 카테고리 별 게시글 수
    public int getCategoryPostCount(String category) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM posts WHERE category = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            System.out.println("getCategoryPostCount err: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return count;
    }
    
    
    private String getOrderByClause(String sort) {
        switch (sort) {
            case "views":
                return "views DESC";
            case "likes":
                return "likes DESC";
            default:
                return "created_at DESC"; // 기본 정렬: 최신순
        }
    }
    
    // 전체 게시글 정렬, 페이징
    public ArrayList<PostDTO> getPostsByPageSorted(int start, int pageSize, String sort) {
        ArrayList<PostDTO> list = new ArrayList<>();
        String orderBy = getOrderByClause(sort);
        String sql = "SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id ORDER BY " + orderBy + " LIMIT ?, ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, start);
            pstmt.setInt(2, pageSize);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                dto.setNickname(rs.getString("nickname")); // 추가
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getPostsByPageSorted err: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return list;
    }
    
    // 카테고리 정렬, 페이징
    public ArrayList<PostDTO> getPostsByCategoryPageSorted(String category, int start, int pageSize, String sort) {
        ArrayList<PostDTO> list = new ArrayList<>();
        String orderBy = getOrderByClause(sort);
        String sql = "SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id WHERE p.category = ? ORDER BY " + orderBy + " LIMIT ?, ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, category);
            pstmt.setInt(2, start);
            pstmt.setInt(3, pageSize);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                dto.setNickname(rs.getString("nickname")); // 추가
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("getPostsByCategoryPageSorted err: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return list;
    }
    
    // 검색된 게시글 리스트 가져오기
    public ArrayList<PostDTO> searchPosts(String type, String keyword, int start, int size, String sort) {
        ArrayList<PostDTO> list = new ArrayList<>();
        String orderBy = getOrderByClause(sort);

        // 닉네임으로 검색 시 join 및 m.nickname으로 필터링
        String sql;
        if ("nickname".equals(type)) {
            sql = "SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id " +
                  "WHERE m.nickname LIKE ? ORDER BY " + orderBy + " LIMIT ?, ?";
        } else {
            sql = "SELECT p.*, m.nickname FROM posts p JOIN member m ON p.id = m.id " +
                  "WHERE p." + type + " LIKE ? ORDER BY " + orderBy + " LIMIT ?, ?";
        }

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setInt(2, start);
            pstmt.setInt(3, size);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                PostDTO dto = new PostDTO();
                dto.setNo(rs.getInt("no"));
                dto.setId(rs.getString("id"));
                dto.setCategory(rs.getString("category"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setCreatedAt(rs.getTimestamp("created_at"));
                dto.setViews(rs.getInt("views"));
                dto.setLikes(rs.getInt("likes"));
                dto.setNickname(rs.getString("nickname")); // 꼭 필요
                list.add(dto);
            }
        } catch (Exception e) {
            System.out.println("searchPosts err: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return list;
    }
    
    // 검색된 게시글 수 가져오기
    public int countSearchPosts(String type, String keyword) {
        int count = 0;
        String sql;

        if ("nickname".equals(type)) {
            sql = "SELECT COUNT(*) FROM posts p JOIN member m ON p.id = m.id WHERE m.nickname LIKE ?";
        } else {
            sql = "SELECT COUNT(*) FROM posts WHERE " + type + " LIKE ?";
        }

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) {
            System.out.println("countSearchPosts err: " + e.getMessage());
        } finally {
            try { if (rs != null) rs.close(); if (pstmt != null) pstmt.close(); if (conn != null) conn.close(); } catch (Exception e2) {}
        }
        return count;
    }
    
    // 추천수 증가
    public boolean increaseLikes(int no) {
        boolean result = false;
        String sql = "UPDATE posts SET likes = likes + 1 WHERE no = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, no);
            result = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("increaseLikes err: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return result;
    }
    
    // 조회수 증가
    public void increaseViews(int no) {
        String sql = "UPDATE posts SET views = views + 1 WHERE no = ?";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, no);
            pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("increaseViews err: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
    }
    
    // 추천 취소
    public boolean decreaseLikes(int no) {
        boolean result = false;
        String sql = "UPDATE posts SET likes = likes - 1 WHERE no = ? AND likes > 0";
        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, no);
            result = pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("decreaseLikes err: " + e.getMessage());
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
        return result;
    }
    
}
