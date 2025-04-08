package pack.member;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

public interface SqlMapperInter {
	@Select("select * from member")
	public List<MemberDto> selectDataAll();
	
	@Select("select * from member where id=#{id}")
	public MemberDto selectMemberPart(String id);
	
	@Select("select id from member where id=#{id}")
	public String checkId(String id);
	
	@Select("select * from member where id=#{id} and passwd=#{passwd}")
	public MemberDto selectLogin(String id);
	
	@Insert("insert into member values(#{id}, #{passwd}, #{name}, #{nickname}, #{email}, #{phone}, #{birthdate})")
	public int insertMemberData(MemberBean memberBean);
	
	@Update("update member set passwd = #{passwd}, name = #{name}, nickname = #{nickname}, email = #{email}, phone = #{phone}, birthdate = #{birthdate} WHERE id = #{id}")
	public int updateMemberData(MemberBean memberBean);
	
	@Delete("delete from member where id=#{id}")
	public int deleteMemberData(String id);
}
