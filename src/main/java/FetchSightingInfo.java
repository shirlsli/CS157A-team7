import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.Location;
import com.example.Plant;
import com.example.Sighting;
import com.example.User;
import com.google.gson.Gson;

@WebServlet("/getSightingInfo")
public class FetchSightingInfo extends HttpServlet {
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String sightingUserId = request.getParameter("userId");
		String sightingPlantId = request.getParameter("plantId");
		String sightingLocationId = request.getParameter("locationId");
		String dUser = "root";
		String pwd = System.getenv("DB_PASSWORD");
		User user = null;
		Plant plant = null;
		Location location = null;
		List<Object> pkg = new ArrayList<>();

		try {
			java.sql.Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", dUser,
					pwd);
			Statement statement = con.createStatement();
			String fetchUserSQL = "SELECT * FROM myflorabase.user WHERE user_id=" + sightingUserId;
			String fetchPlantSQL = "SELECT * FROM myflorabase.plant WHERE plant_id=" + sightingPlantId;
			String fetchLocationSQL = "SELECT * FROM myflorabase.location WHERE location_id="
					+ sightingLocationId;
			ResultSet rs = statement.executeQuery(fetchUserSQL);
			if (rs.next()) {
				int userId = rs.getInt("user_id");
				String username = rs.getString("username");
				String password = rs.getString("password");
				String description = rs.getString("description");
				boolean isAdmin = rs.getBoolean("isAdmin");
				user = new User(userId, username, password, description, isAdmin);
				pkg.add(user);
			}
			rs = statement.executeQuery(fetchPlantSQL);
			// Plant(int plantId, String name, String scientificName, String description,
			// boolean poisonous, boolean invasive, boolean endangered)
			if (rs.next()) {
				int plantId = rs.getInt("plant_id");
				String name = rs.getString("name");
				String scientificName = rs.getString("scientific_name");
				String description = rs.getString("description");
				boolean poisonous = rs.getBoolean("poisonous");
				boolean invasive = rs.getBoolean("invasive");
				boolean endangered = rs.getBoolean("endangered");
				plant = new Plant(plantId, name, scientificName, description, poisonous, invasive, endangered);
				pkg.add(plant);
			}
			rs = statement.executeQuery(fetchLocationSQL);
			// Location(int locationId, double latitude, double longitude, String name)
			if (rs.next()) {
				int locationId = rs.getInt("location_id");
				double latitude = rs.getDouble("latitude");
				double longitude = rs.getDouble("longitude");
				String name = rs.getString("name");
				location = new Location(locationId, latitude, longitude, name);
				pkg.add(location);
			}
			rs.close();
			statement.close();
			con.close();
			Gson gson = new Gson();
			String jsonResponse = gson.toJson(pkg);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			response.getWriter().write(jsonResponse);
		} catch (SQLException | ClassNotFoundException e) {
			System.out.println("SQLException caught: " + e.getMessage());
		}
	}
}
