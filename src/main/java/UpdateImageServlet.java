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

@WebServlet("/updateImage")
@MultipartConfig
public class UpdateImageServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String condition = request.getParameter("condition");
		String imageAttributeName = request.getParameter("imageAttributeName");
		String conditionValue = request.getParameter("conditionValue");
		String table = request.getParameter("table");
		Part image = request.getPart("image");
		
		String databaseUser = "root";
		String databasePassword = System.getenv("DB_PASSWORD");
		try {
			java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", databaseUser, databasePassword);
            if (image != null) {
            	String sql = "UPDATE myflorabase." + table + " SET " + imageAttributeName + " = ? WHERE " + condition + " = ?";
            	InputStream imageInputStream = image.getInputStream();
                try (PreparedStatement statement = con.prepareStatement(sql)) {
                    statement.setBlob(1, imageInputStream);
                    statement.setInt(2, Integer.parseInt(conditionValue)); 

                    int rowsUpdated = statement.executeUpdate(); 
                    response.getWriter().write(rowsUpdated + " row(s) updated."); 
                }
                imageInputStream.close();
            }
            con.close();
		} catch(SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
        } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			image.delete();
		}
	}
}