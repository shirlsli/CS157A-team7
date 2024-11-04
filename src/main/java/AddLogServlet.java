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

        String plantName = request.getParameter("plantName");
        String date = request.getParameter("date");
        String description = request.getParameter("description");
        String radiusStr = request.getParameter("radius");
        String[] selectedValuesArray = request.getParameterValues("selectedValues");

        int radius = 0;
        try {
            radius = Integer.parseInt(radiusStr);
        } catch (NumberFormatException e) {
            System.out.println("Invalid radius value: " + radiusStr);
        }

        String selectedValues = (selectedValuesArray != null) ? String.join(", ", selectedValuesArray) : "None";

        System.out.println("Plant Name: " + plantName);
        System.out.println("Date: " + date);
        System.out.println("Description: " + description);
        System.out.println("Radius: " + radius);
        System.out.println("Selected Values: " + selectedValues);

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("Log received successfully.");

        String databaseUser = "root";
        String databasePassword = System.getenv("DB_PASSWORD"); 
        try {
            Class.forName("com.mysql.jdbc.Driver");

            java.sql.Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false",
                databaseUser,
                databasePassword
            );

            String createTableSQL = "CREATE TABLE IF NOT EXISTS Sightings (" +
                "id INT AUTO_INCREMENT PRIMARY KEY," +
                "plantName VARCHAR(255)," +
                "date DATE," +
                "description TEXT," +
                "radius INT," +
                "selectedValues TEXT" +
                ")";
            try (PreparedStatement createTableStatement = con.prepareStatement(createTableSQL)) {
                createTableStatement.executeUpdate();
            }

            String insertSQL = "INSERT INTO Sightings (plantName, date, description, radius, selectedValues) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement insertStatement = con.prepareStatement(insertSQL)) {
                insertStatement.setString(1, plantName);
                insertStatement.setString(2, date);
                insertStatement.setString(3, description);
                insertStatement.setInt(4, radius);
                String selectedValuesString = (selectedValuesArray != null) ? String.join(", ", selectedValuesArray) : null;
                insertStatement.setString(5, selectedValuesString);
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