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

@WebServlet("/getProfilePic")
public class ProfilePicServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		HttpSession curSession = request.getSession();
//		User user = (User) curSession.getAttribute("loggedInUser");
		String userId = request.getParameter("userId");
		String databaseUser = "root";
		String databasePassword = "root";
		try {
			java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", databaseUser, databasePassword);

            String sql = "SELECT profile_pic FROM myflorabase.user WHERE user_id = ?";
            try (PreparedStatement statement = con.prepareStatement(sql)) {
            	statement.setInt(1, Integer.parseInt(userId));
            	try (ResultSet rs = statement.executeQuery()) {
            		if (rs.next()) {
                        Blob blob = rs.getBlob("profile_pic");
                        if (blob != null) {
                        	byte[] profilePic = blob.getBytes(1, (int) blob.length());
                            response.setContentType("image/jpeg");
                            response.setContentLength(profilePic.length);
                            ServletOutputStream outputStream = response.getOutputStream();
                            outputStream.write(profilePic);
                            outputStream.flush();
                            outputStream.close();
                        } else {
                        	File defaultPicFile = new File("../../eclipse-workspace/myFlorabase/src/main/webapp/assets/default_profile_pic.jpg"); // need to change based on where working directory is
                            byte[] defaultProfilePic = Files.readAllBytes(defaultPicFile.toPath());
                        	response.setContentType("image/jpeg");
                            response.setContentLength(defaultProfilePic.length);
                            ServletOutputStream outputStream = response.getOutputStream();
                            outputStream.write(defaultProfilePic);
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