package pack.board;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentDTO {
    private int no;
    private String name;
    private String content;
    private java.sql.Timestamp createdAt;
    private int likes;
    private int gno;
    private int ono;
    private int nested;

}