import java.io.IOException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/updateMapPreference")
public class UpdateMapPreferenceServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String preferenceId = request.getParameter("preferenceId");
		String userId = request.getParameter("userId");
		String filterId = request.getParameter("filterId");
		String locationId = request.getParameter("locationId");
		String zoom = request.getParameter("zoom");
		
		String databaseUser = "root";
		String databasePassword = "root";
		try {
			java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", databaseUser, databasePassword);
            // creating a new MapPreference
            // only updating individual attributes
            if (zoom != null) {
            	String sql = "UPDATE myflorabase.mappreference SET zoom = ? WHERE preference_id = ?";
                try (PreparedStatement statement = con.prepareStatement(sql)) {
                    statement.setInt(1, Integer.parseInt(zoom));
                    statement.setInt(2, Integer.parseInt(preferenceId)); 

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