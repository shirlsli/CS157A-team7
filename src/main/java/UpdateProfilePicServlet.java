import java.io.IOException;
import java.io.InputStream;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.example.User;

@WebServlet("/updateProfilePic")
@MultipartConfig
public class UpdateProfilePicServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String userId = request.getParameter("userId");
		Part newProfilePic = request.getPart("newProfilePic");
		
		String databaseUser = "root";
		String databasePassword = "root";
		try {
			java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", databaseUser, databasePassword);
            if (newProfilePic != null) {
            	String sql = "UPDATE myflorabase.user SET profile_pic = ? WHERE user_id = ?";
            	InputStream profilePicInputStream = newProfilePic.getInputStream();
                try (PreparedStatement statement = con.prepareStatement(sql)) {
                    statement.setBlob(1, profilePicInputStream);
                    statement.setInt(2, Integer.parseInt(userId)); 

                    int rowsUpdated = statement.executeUpdate(); 
                    response.getWriter().write(rowsUpdated + " row(s) updated."); 
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