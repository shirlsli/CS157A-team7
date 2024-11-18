import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
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

@MultipartConfig
@WebServlet("/editSighting")
public class EditSightingServlet extends HttpServlet {
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		int sightingId = Integer.parseInt(request.getParameter("sightingId"));
		int plantId = Integer.parseInt(request.getParameter("plantId"));
		String plantName = request.getParameter("plantName");
		String date = request.getParameter("date");
		String description = request.getParameter("description");
		String radius = request.getParameter("radius");
		Part photo = request.getPart("photo");

		String databaseUser = "root";
		String databasePassword = System.getenv("DB_PASSWORD");
		try {
			java.sql.Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false",
					databaseUser, databasePassword);
			String sql = "UPDATE myflorabase.sighting SET " + (date != null ? "date = " + "'" + date + "'" : "")
					+ (description != null ? ", description = " + "'" + description + "'" : "")
					+ (radius != null ? ", radius = " + Integer.parseInt(radius) : "");
			InputStream imageInputStream = null;
			if (photo != null) {
				sql = sql + ", photo = ?";
				imageInputStream = photo.getInputStream();
			} 
			sql = sql + " WHERE sighting_id = " + sightingId + ";";
			try (PreparedStatement statement = con.prepareStatement(sql)) {
				if (photo != null) {
					statement.setBlob(1, imageInputStream);
				}
				int rowsUpdated = statement.executeUpdate();
				response.getWriter().write(rowsUpdated + " row(s) updated.");
				if (imageInputStream != null) {
					imageInputStream.close();
				}
			}
			String updatePlantSQl = "UPDATE myflorabase.plant SET name = ? WHERE plant_id = ?";
			try (PreparedStatement statement = con.prepareStatement(updatePlantSQl)) {
				statement.setString(1, plantName);
				statement.setInt(2, plantId);
				int rowsUpdated = statement.executeUpdate();
				response.getWriter().write(rowsUpdated + " row(s) updated.");
			}
			con.close();
		} catch (SQLException e) {
			System.out.println("SQLException caught: " + e.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (photo != null) {
				photo.delete();
			}
		}
	}
}
