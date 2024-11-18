import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;

import java.sql.Blob;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.example.User;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String databaseUser = "root";
		String databasePassword = System.getenv("DB_PASSWORD");
		String uname = request.getParameter("uname");
		String password = request.getParameter("password");

		// Connect to database and compare user's input
		try {
			java.sql.Connection con;
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false",
					databaseUser, databasePassword);
			String sql = "SELECT user_id, username, password, description, isAdmin FROM myflorabase.user WHERE username = ?";
			try (PreparedStatement statement = con.prepareStatement(sql)) {
				statement.setString(1, uname);
				ResultSet result = statement.executeQuery();

				if (result.next()) {
					// User exists, now verify password
					String storedPassword = result.getString("password");
					// correct password, create User object to return
					if (storedPassword.equals(password)) {

						int userId = result.getInt("user_id");
						String dbUsername = result.getString("username");
						String dbPassword = result.getString("password");
						String description = result.getString("description");
						boolean isAdmin = result.getBoolean("isAdmin");

						User user = new User(userId, dbUsername, dbPassword, description, isAdmin);

						HttpSession session = request.getSession();
						session.setAttribute("user", user);

						request.setAttribute("generalSightingActive", "active"); // set "Sightings" as active tab in
																					// header, since directing to
																					// sightings.jsp

						RequestDispatcher rd = request.getRequestDispatcher("sightings.jsp");
						rd.forward(request, response);
					} else {
						// Password does not match
						request.setAttribute("errorTitle", "Login Error");
						request.setAttribute("errorMessage", "Invalid password. Please try again.");

						RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
						rd.forward(request, response);
					}
				} else {
					// Username not found
					request.setAttribute("errorTitle", "Login Error");
					request.setAttribute("errorMessage", "Username not found. Please try again.");
					
					RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
					rd.forward(request, response);
				}
			}

			con.close();
		} catch (SQLException e) {
			System.out.println("SQLException caught: " + e.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}
