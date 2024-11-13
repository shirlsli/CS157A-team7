import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.sql.Blob;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.User;

@WebServlet("/getImage")
public class ImageServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		HttpSession curSession = request.getSession();
//		User user = (User) curSession.getAttribute("loggedInUser");
		String condition = request.getParameter("condition");
		String conditionValue = request.getParameter("conditionValue");
		String imageAttributeName = request.getParameter("imageAttributeName");
		String databaseUser = "root";
		String databasePassword = System.getenv("DB_PASSWORD");
		try {
			java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", databaseUser, databasePassword);

            String sql = "SELECT " + imageAttributeName + " FROM myflorabase.user WHERE " + condition + " = " + conditionValue;
            try (PreparedStatement statement = con.prepareStatement(sql)) {
            	try (ResultSet rs = statement.executeQuery()) {
            		if (rs.next()) {
                        Blob blob = rs.getBlob("profile_pic");
                        if (blob != null) {
                        	byte[] image = blob.getBytes(1, (int) blob.length());
                            response.setContentType("image/jpeg");
                            response.setContentLength(image.length);
                            ServletOutputStream outputStream = response.getOutputStream();
                            outputStream.write(image);
                            outputStream.flush();
                            outputStream.close();
                        } else {
                        	File defaultImageFile = new File("rose.png"); // need to change based on where working directory is
                            byte[] defaultImage = Files.readAllBytes(defaultImageFile.toPath());
                        	response.setContentType("image/jpeg");
                            response.setContentLength(defaultImage.length);
                            ServletOutputStream outputStream = response.getOutputStream();
                            outputStream.write(defaultImage);
                            outputStream.flush();
                            outputStream.close();
                        }
                    }
            	}
            }
            
            con.close();
		} catch(SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
        } catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}