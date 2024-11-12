import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig
@WebServlet("/AddLogServlet")
public class AddLogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Retrieve parameters from the request
        String plantIdStr = request.getParameter("plantId");
        String userIdStr = request.getParameter("userId");
        String locationIdStr = request.getParameter("locationId");
        String date = request.getParameter("date");
        String description = request.getParameter("description");
        String radiusStr = request.getParameter("radius");
        String latitudeStr = request.getParameter("latitude");  
        String longitudeStr = request.getParameter("longitude");
        Part photoPart = request.getPart("photo");

        // Print raw parameter values to check for nulls
        System.out.println("Received Parameters:");
        System.out.println("plantId: " + plantIdStr);
        System.out.println("userId: " + userIdStr);
        System.out.println("locationId: " + locationIdStr);
        System.out.println("date: " + date);
        System.out.println("description: " + description);
        System.out.println("radius: " + radiusStr);
        System.out.println("latitude: " + latitudeStr);
        System.out.println("longitude: " + longitudeStr);

        int plantId = 0;
        int userId = 0;
        int locationId = 0;
        int radius = 0;
        double latitude = 0.0;
        double longitude = 0.0;

        // Parse integer parameters with individual try-catch blocks for better error identification
        try {
            if (plantIdStr != null) {
                plantId = Integer.parseInt(plantIdStr);
            } else {
                System.out.println("plantId is null");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid plantId: " + plantIdStr);
        }

        try {
            if (userIdStr != null) {
                userId = Integer.parseInt(userIdStr);
            } else {
                System.out.println("userId is null");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid userId: " + userIdStr);
        }

        try {
            if (locationIdStr != null) {
                locationId = Integer.parseInt(locationIdStr);
            } else {
                System.out.println("locationId is null");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid locationId: " + locationIdStr);
        }

        try {
            if (radiusStr != null) {
                radius = Integer.parseInt(radiusStr);
            } else {
                System.out.println("radius is null");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid radius: " + radiusStr);
        }

        // Optionally, parse latitude and longitude if needed
        try {
            if (latitudeStr != null) {
                latitude = Double.parseDouble(latitudeStr);
            } else {
                System.out.println("latitude is null");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid latitude: " + latitudeStr);
        }

        try {
            if (longitudeStr != null) {
                longitude = Double.parseDouble(longitudeStr);
            } else {
                System.out.println("longitude is null");
            }
        } catch (NumberFormatException e) {
            System.out.println("Invalid longitude: " + longitudeStr);
        }

        // Reverse geocode to get location name
        String locationName = "";
        try {
            String apiUrl = String.format("https://nominatim.openstreetmap.org/reverse?lat=%s&lon=%s&format=json", latitudeStr, longitudeStr);
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("User-Agent", "Mozilla/5.0"); // Set user agent to prevent getting blocked

            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) { // Success
                BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String inputLine;
                StringBuilder responseContent = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    responseContent.append(inputLine);
                }
                in.close();

                // Parse JSON response manually
                String responseStr = responseContent.toString();
                int startIndex = responseStr.indexOf("\"display_name\":\"");
                if (startIndex != -1) {
                    startIndex += 16; // Move past "display_name":"
                    int endIndex = responseStr.indexOf("\"", startIndex);
                    if (endIndex != -1) {
                        locationName = responseStr.substring(startIndex, endIndex);
                    }
                }
                System.out.println("Location: " + locationName);
            } else {
                System.out.println("GET request failed.");
            }
        } catch (Exception e) {
            System.out.println("Error during reverse geocoding: " + e.getMessage());
            e.printStackTrace();
        }

        // Print parsed values
        System.out.println("Parsed Values:");
        System.out.println("Plant ID: " + plantId);
        System.out.println("User ID: " + userId);
        System.out.println("Location ID: " + locationId);
        System.out.println("Date: " + date);
        System.out.println("Description: " + description);
        System.out.println("Radius: " + radius);
        System.out.println("Latitude: " + latitude);
        System.out.println("Longitude: " + longitude);
        System.out.println("Location Name: " + locationName);

        // Set response to inform the client that the log was received
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("Log received successfully.");

        // Database connection details
        String databaseUser = "root";
        String databasePassword = System.getenv("DB_PASSWORD"); 
        java.sql.Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false",
                databaseUser,
                databasePassword
            );

            // Create Location table if it doesn't exist
            String createTableSQL = "CREATE TABLE IF NOT EXISTS Location ("
                    + "location_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "latitude DOUBLE NOT NULL, "
                    + "longitude DOUBLE NOT NULL, "
                    + "name VARCHAR(1000)"
                    + ")";
            String createSightingTableSQL = "CREATE TABLE IF NOT EXISTS Sighting ("
                    + "sighting_id INT AUTO_INCREMENT PRIMARY KEY, "
                    + "plant_id INT, "
                    + "user_id INT, "
                    + "location_id INT, "
                    + "description TEXT, "
                    + "date DATE, "
                    + "photo BLOB, "
                    + "radius INT"
                    + ")";

            try (PreparedStatement createTableStatement = con.prepareStatement(createTableSQL);
                 PreparedStatement createSightingTableStatement = con.prepareStatement(createSightingTableSQL)) {
                createTableStatement.executeUpdate();
                createSightingTableStatement.executeUpdate();
            }

            // Check if location already exists in the database
            String selectLocationSQL = "SELECT location_id FROM Location WHERE name = ?";
            try (PreparedStatement selectLocationStatement = con.prepareStatement(selectLocationSQL)) {
                selectLocationStatement.setString(1, locationName);
                try (ResultSet resultSet = selectLocationStatement.executeQuery()) {
                    if (resultSet.next()) {
                        locationId = resultSet.getInt("location_id");
                        System.out.println("Existing location found with ID: " + locationId);
                    } else {
                        // Insert new Location entry if it doesn't exist
                        String insertLocationSQL = "INSERT INTO Location (latitude, longitude, name) VALUES (?, ?, ?)";
                        try (PreparedStatement insertLocationStatement = con.prepareStatement(insertLocationSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            insertLocationStatement.setDouble(1, latitude);
                            insertLocationStatement.setDouble(2, longitude);
                            insertLocationStatement.setString(3, locationName);
                            insertLocationStatement.executeUpdate();

                            // Get the generated location_id
                            try (ResultSet generatedKeys = insertLocationStatement.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    locationId = generatedKeys.getInt(1);
                                    System.out.println("New location inserted with ID: " + locationId);
                                }
                            }
                        }
                    }
                }
            }

            // Handle photo file
            byte[] photoBytes = null;
            if (photoPart != null && photoPart.getSize() > 0) {
                photoBytes = new byte[(int) photoPart.getSize()];
                photoPart.getInputStream().read(photoBytes);
            }

            // Insert the new sighting into the Sighting table
            String insertSQL = "INSERT INTO Sighting (plant_id, user_id, location_id, description, date, photo, radius) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement insertStatement = con.prepareStatement(insertSQL)) {
                insertStatement.setInt(1, plantId);
                insertStatement.setInt(2, userId);
                insertStatement.setInt(3, locationId);
                insertStatement.setString(4, description);
                insertStatement.setString(5, date);
                if (photoBytes != null) {
                    insertStatement.setBytes(6, photoBytes);
                } else {
                    insertStatement.setNull(6, java.sql.Types.BLOB);
                }
                insertStatement.setInt(7, radius);
                insertStatement.executeUpdate();
            }

        } catch(SQLException e) {
            System.out.println("SQLException caught: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Ensure the connection is closed even if an exception occurs
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    System.out.println("Failed to close the connection: " + e.getMessage());
                }
            }
        }
    }
}