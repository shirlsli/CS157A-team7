import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.example.Location;
import com.example.Plant;
import com.example.Sighting;
import com.example.User;
import com.google.gson.Gson;

@WebServlet("/deleteSighting")
public class DeleteSightingServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		BufferedReader reader = new BufferedReader(new InputStreamReader(request.getInputStream()));
		String contents = "";
        String line;
        while ((line = reader.readLine()) != null) {
            contents += line;
        }
        Gson gson = new Gson();
        Sighting sighting = gson.fromJson(contents, Sighting.class);

		String databaseUser = "root";
		String databasePassword = System.getenv("DB_PASSWORD");
		// will need to check if there is a plant associated with this sighting
		try {
			java.sql.Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false",
					databaseUser, databasePassword);
			String sql = "DELETE FROM myflorabase.sighting WHERE sighting_id = ?";
			try (PreparedStatement statement = con.prepareStatement(sql)) {
				statement.setInt(1, sighting.getSightingId());
				int rowsUpdated = statement.executeUpdate();
				response.getWriter().write(rowsUpdated + " row(s) updated.");
			}
			con.close();
		} catch (SQLException e) {
			System.out.println("SQLException caught: " + e.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
}
