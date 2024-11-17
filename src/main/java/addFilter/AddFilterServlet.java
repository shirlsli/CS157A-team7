package addFilter;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.User;

@WebServlet("/AddFilterServlet")
@MultipartConfig
public class AddFilterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public AddFilterServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

		String filterName = request.getParameter("filterName");
		
        String[] selectedValues = request.getParameterValues("selectedPlants");
        
		HttpSession session = request.getSession(false);
		User user = (User) session.getAttribute("user");
		int userId = user.getUserId();
		
		String databaseUser = "root";
		String databasePassword = System.getenv("DB_PASSWORD");
		
		java.sql.Connection con = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false", databaseUser, databasePassword);
			
			// fun part here
			// add new entry into filter
			// add entry into map preference??? // create new table?
			// add entries to within
			
			if (selectedValues != null) {
				
	            for (String value : selectedValues) {
	                System.out.println("Selected value: " + value);
	            }
	        }
			
			
		} catch (SQLException e) {
			System.out.println("SQLException caught: " + e.getMessage());
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (con != null) {
				try {
					con.close();
				} catch (SQLException e) {
					System.out.println("Failed to close the connection: " + e.getMessage());
				}
			}
		}
		
		response.setContentType("text/plain");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write("Log received and processed successfully.");

	}

}
