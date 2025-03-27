package pack.post;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PostDTO {
    private int no;
    private String name;
    private String category;
    private String title;
    private String content;
    private java.sql.Timestamp createdAt;
    private int views;
    private int likes;

}
