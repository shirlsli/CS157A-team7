import java.io.IOException;
import java.sql.Blob;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.User;

@WebServlet("/profilePic")
public class ProfilePicServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession curSession = request.getSession();
		User user = (User) curSession.getAttribute("loggedInUser");
		String databaseUser = "root";
		String databasePassword = "root";
		try {
			java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", databaseUser, databasePassword);
            System.out.println("database successfully opened.<br/><br/>");

            Statement statement = con.createStatement();
            String sql = "SELECT profile_pic FROM user WHERE user_id=" + user.getUserId();
            ResultSet rs = statement.executeQuery(sql);
            
            if (rs.next()) {
                Blob blob = rs.getBlob("profile_pic");
                byte[] profilePic = blob.getBytes(1, (int) blob.length());
                response.setContentType("image/jpeg");
                response.setContentLength(profilePic.length);
                ServletOutputStream outputStream = response.getOutputStream();
                outputStream.write(profilePic);
                outputStream.close();
            }
            
            rs.close();
            statement.close();
            con.close();
		} catch(SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
        } catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
//		response.getWriter().append("Served at: ").append(request.getContextPath());
	}
}