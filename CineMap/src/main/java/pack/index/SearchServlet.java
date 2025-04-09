package pack.index;

import java.io.IOException;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pack.movie.MovieDto;
import pack.mybatis.SqlMapConfig;
import pack.post.PostDto;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private SqlSessionFactory sqlSessionFactory;

    @Override
    public void init() {
        sqlSessionFactory = SqlMapConfig.getSqlSession();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try (SqlSession session = sqlSessionFactory.openSession()) {
        	String title = request.getParameter("query");
        	//System.out.println(title);
        	
            IndexMapperInter mapper = session.getMapper(IndexMapperInter.class);
            List<MovieDto> searchMovie = mapper.selectSearchMovie(title);
            List<PostDto> searchPosts = mapper.selectSearchPosts(title);
            
            
            request.setAttribute("searchMovie", searchMovie);
            request.setAttribute("searchPosts", searchPosts);
            request.getRequestDispatcher("/search.jsp").forward(request, response);
        }
    }
}