import java.io.IOException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/AddLogServlet")
public class AddLogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String plantIdStr = request.getParameter("plantId");
        String userIdStr = request.getParameter("userId");
        String locationIdStr = request.getParameter("locationId");
        String date = request.getParameter("date");
        String description = request.getParameter("description");
        String radiusStr = request.getParameter("radius");

        int plantId = 0;
        int userId = 0;
        int locationId = 0;
        int radius = 0;
        try {
            plantId = Integer.parseInt(plantIdStr);
            userId = Integer.parseInt(userIdStr);
            locationId = Integer.parseInt(locationIdStr);
            radius = Integer.parseInt(radiusStr);
        } catch (NumberFormatException e) {
            System.out.println("Invalid numeric value provided: " + e.getMessage());
        }

        System.out.println("Plant ID: " + plantId);
        System.out.println("User ID: " + userId);
        System.out.println("Location ID: " + locationId);
        System.out.println("Date: " + date);
        System.out.println("Description: " + description);
        System.out.println("Radius: " + radius);

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("Log received successfully.");

        String databaseUser = "root";
        String databasePassword = System.getenv("DB_PASSWORD"); 
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            java.sql.Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false",
                databaseUser,
                databasePassword
            );

            String createTableSQL = "CREATE TABLE IF NOT EXISTS Sighting (" +
                "sighting_id INT AUTO_INCREMENT PRIMARY KEY," +
                "plant_id INT," +
                "user_id INT," +
                "location_id INT," +
                "description TEXT," +
                "date DATE," +
                "photo VARCHAR(255)," +
                "radius INT" +
                ")";
            try (PreparedStatement createTableStatement = con.prepareStatement(createTableSQL)) {
                createTableStatement.executeUpdate();
            }

            String insertSQL = "INSERT INTO Sighting (plant_id, user_id, location_id, description, date, photo, radius) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement insertStatement = con.prepareStatement(insertSQL)) {
                insertStatement.setInt(1, plantId);
                insertStatement.setInt(2, userId);
                insertStatement.setInt(3, locationId);
                insertStatement.setString(4, description);
                insertStatement.setString(5, date);
                insertStatement.setString(6, "dummy_photo.jpg");  // Dummy value for photo
                insertStatement.setInt(7, radius);
                insertStatement.executeUpdate();
            }

            con.close();
        } catch(SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
