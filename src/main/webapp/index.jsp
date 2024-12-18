<%@ page import="java.sql.*, java.io.IOException, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%
	// Getting database credentials from environment variables
	String dbUser = "root";
	String dbPassword = System.getenv("DB_PASSWORD");
	String dbUrl = "jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false";

	// SQL statements for creating tables
	String createLocationTableSQL = "CREATE TABLE `Location` ("
			+ "`location_id` INT AUTO_INCREMENT NOT NULL, "
			+ "`latitude` DOUBLE NOT NULL, "
			+ "`longitude` DOUBLE NOT NULL, "
			+ "`name` VARCHAR(1000), "
			+ "PRIMARY KEY (`location_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createSightingTableSQL = "CREATE TABLE `Sighting` ("
			+ "`sighting_id` INT AUTO_INCREMENT NOT NULL, "
			+ "`plant_id` INT NOT NULL, "
			+ "`user_id` INT NOT NULL, "
			+ "`location_id` INT NOT NULL, "
			+ "`description` TEXT, "
			+ "`date` DATE, "
			+ "`photo` MEDIUMBLOB, "
			+ "`radius` INT, "
			+ "PRIMARY KEY (`sighting_id`, `plant_id`, `user_id`, `location_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createPlantTableSQL = "CREATE TABLE `Plant` ("
			+ "`plant_id` INT AUTO_INCREMENT NOT NULL, "
			+ "`name` VARCHAR(100) NOT NULL, "
			+ "`scientific_name` VARCHAR(100) NOT NULL, "
			+ "`description` TEXT, "
			+ "`poisonous` BOOLEAN, "
			+ "`invasive` BOOLEAN, "
			+ "`endangered` BOOLEAN, "
			+ "PRIMARY KEY (`plant_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createUserTableSQL = "CREATE TABLE `User` ("
			+ "`user_id` INT AUTO_INCREMENT PRIMARY KEY, "
			+ "`username` VARCHAR(30) NOT NULL, "
			+ "`password` VARCHAR(45) DEFAULT NULL, "
			+ "`profile_pic` MEDIUMBLOB DEFAULT NULL, "
			+ "`description` VARCHAR(500) DEFAULT NULL, "
			+ "`isAdmin` TINYINT(1) DEFAULT 0,"
			+ "`zoom` int NOT NULL DEFAULT 100,"
			+ "`location_id` int NOT NULL DEFAULT '1'"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createFilterTableSQL = "CREATE TABLE `Filter` ("
			+ "`filter_id` INT AUTO_INCREMENT NOT NULL,"
			// + "`color` varchar(45) DEFAULT NULL,"
			+ "`filter_name` varchar(255) NOT NULL,"
			+ "PRIMARY KEY (`filter_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createReportsTableSQL = "CREATE TABLE `Reports` ("
			+ "`user_id` int NOT NULL,"
			+ "`sighting_id` int NOT NULL,"
			+ "`date` date DEFAULT NULL,"
			+ "`name` varchar(100) DEFAULT NULL,"
			+ "PRIMARY KEY (`user_id`,`sighting_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createAllergicTableSQL = "CREATE TABLE `Allergic` ("
			+ "`user_id` int NOT NULL,"
			+ "`plant_id` int NOT NULL,"
			+ "PRIMARY KEY (`user_id`, `plant_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createEditsTableSQL = "CREATE TABLE `Edits` ("
			+ "`user_id` int NOT NULL,"
			+ "`sighting_id` int NOT NULL,"
			+ "`edit_date` date NOT NULL,"
			+ "PRIMARY KEY (`user_id`, `sighting_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createWithinTableSQL = "CREATE TABLE `Within` ("
			+ "`plant_id` int NOT NULL,"
			+ "`filter_id` int NOT NULL,"
			+ "PRIMARY KEY (`plant_id`, `filter_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createFlagTableSQL = "CREATE TABLE `Flag` ("
			+ "`flag_id` INT AUTO_INCREMENT NOT NULL,"
			+ "`user_id` int NOT NULL,"
			+ "`sighting_id` int NOT NULL,"
			+ "`reason` VARCHAR(500) DEFAULT NULL,"
			+ "PRIMARY KEY (`flag_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
	String createUser_FilterTableSQL = "CREATE TABLE `user_filter` ("
			+ "`user_id` int NOT NULL,"
			+ "`filter_id` int NOT NULL,"
			+ "`active` tinyint NOT NULL DEFAULT '1',"
			+ "PRIMARY KEY (`user_id`,`filter_id`)"
			+ ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";

	Connection con = null;
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		con = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
		try (Statement statement = con.createStatement()) {
			// statement.executeUpdate("DROP SCHEMA IF EXISTS myFlorabase");
			// statement.executeUpdate("CREATE SCHEMA myFlorabase");
			statement.executeUpdate("USE myFlorabase");

			// statement.executeUpdate("DROP TABLE IF EXISTS Users");
			statement.executeUpdate("DROP TABLE IF EXISTS MapPreference"); // this table should no longer exist
			statement.executeUpdate("DROP TABLE IF EXISTS Filter");
			// statement.executeUpdate("DROP TABLE IF EXISTS Location");
			// statement.executeUpdate("DROP TABLE IF EXISTS Sighting");
			// statement.executeUpdate("DROP TABLE IF EXISTS Plant");
			// statement.executeUpdate("DROP TABLE IF EXISTS Reports");
			// statement.executeUpdate("DROP TABLE IF EXISTS Allergic");
			// statement.executeUpdate("DROP TABLE IF EXISTS Edits");
			statement.executeUpdate("DROP TABLE IF EXISTS Within");
			// statement.executeUpdate("DROP TABLE IF EXISTS Flag");
			statement.executeUpdate("DROP TABLE IF EXISTS User_Filter");

			// statement.executeUpdate(createUserTableSQL);
			statement.executeUpdate(createFilterTableSQL);
			// statement.executeUpdate(createLocationTableSQL);
			// statement.executeUpdate(createSightingTableSQL);
			// statement.executeUpdate(createPlantTableSQL);
			// statement.executeUpdate(createReportsTableSQL);
			// statement.executeUpdate(createAllergicTableSQL);
			// statement.executeUpdate(createEditsTableSQL);
			statement.executeUpdate(createWithinTableSQL);
			// statement.executeUpdate(createFlagTableSQL);
			statement.executeUpdate(createUser_FilterTableSQL);

			// USER table (15)
			/* statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user1', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', true);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user2', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user3', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user4', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user5', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user6', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user7', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user8', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user9', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user10', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user11', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user12', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user13', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user14', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);");
			statement.executeUpdate("INSERT INTO myflorabase.user (username, password, profile_pic, description, isAdmin)"
				+ "VALUES ('user15', 'root', NULL, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', false);"); */
			
			// FILTER table (8)
			statement.executeUpdate("INSERT INTO myflorabase.filter (filter_name) VALUES ('All Plants')");
			statement.executeUpdate("INSERT INTO myflorabase.filter (filter_name) VALUES ('Trees')");
			statement.executeUpdate("INSERT INTO myflorabase.filter (filter_name) VALUES ('Allergies')");
			statement.executeUpdate("INSERT INTO myflorabase.filter (filter_name) VALUES ('Filter')");
			statement.executeUpdate("INSERT INTO myflorabase.filter (filter_name) VALUES ('Tree')");
			statement.executeUpdate("INSERT INTO myflorabase.filter (filter_name) VALUES ('Flowers')");
			
			// USER_FILTER table (user and filters)
			
			// default filter 'All' (all users with default filter)
			// get the number of users already in the table 
			String getNumUsersSQL = "SELECT * FROM user;";
			PreparedStatement ps = con.prepareStatement(getNumUsersSQL);
            ResultSet resultSet = ps.executeQuery();
         	
           /*  int numberOfUsers = 0; */
            // Check if the result set has data (it should have 1 row with the count)
            while (resultSet.next()) {
                // Get the count from the first column (which is the result of COUNT(*))
                int userId = resultSet.getInt(1);
                out.println("userId: " + userId + "<br/>");
				statement.executeUpdate("INSERT INTO myflorabase.user_filter (user_id, filter_id) VALUES (" + userId + ", 1)");
            
				if (userId == 1){
					statement.executeUpdate("INSERT INTO myflorabase.user_filter (user_id, filter_id) VALUES (1, 2)");
					statement.executeUpdate("INSERT INTO myflorabase.user_filter (user_id, filter_id) VALUES (1, 3)");
					statement.executeUpdate("INSERT INTO myflorabase.user_filter (user_id, filter_id) VALUES (1, 4)");
					statement.executeUpdate("INSERT INTO myflorabase.user_filter (user_id, filter_id) VALUES (1, 5)");
					statement.executeUpdate("INSERT INTO myflorabase.user_filter (user_id, filter_id) VALUES (1, 6)");
					
				}
            }
            
			
			// WITHIN table (plants and filters)
			
			// get all the plants for the default filter
			String getNumPlantsSQL = "SELECT * FROM plant;";
			ps = con.prepareStatement(getNumPlantsSQL);
            resultSet = ps.executeQuery();
         	
            
            // Check if the result set has data (it should have 1 row with the count)
            while (resultSet.next()) {
                // Get the count from the first column (which is the result of COUNT(*))
                int plantId = resultSet.getInt(1);
                out.println("plantId: " + plantId + "<br/>");
             	// create default filter for each existing user
				statement.executeUpdate("INSERT INTO myflorabase.within (plant_id, filter_id) VALUES (" + plantId + ", 1)");
				
				// just use the first plant for the other custom filters
             	if (plantId ==1){
             		statement.executeUpdate("INSERT INTO myflorabase.within (filter_id, plant_id) VALUES (2, 1)");
    				statement.executeUpdate("INSERT INTO myflorabase.within (filter_id, plant_id) VALUES (3, 1)");
    				statement.executeUpdate("INSERT INTO myflorabase.within (filter_id, plant_id) VALUES (4, 1)");
    				statement.executeUpdate("INSERT INTO myflorabase.within (filter_id, plant_id) VALUES (5, 1)");
    				statement.executeUpdate("INSERT INTO myflorabase.within (filter_id, plant_id) VALUES (6, 1)");
             	}
            }
            
       
			// LOCATION table (1)
			// statement.executeUpdate("INSERT INTO myflorabase.location (latitude, longitude, name) VALUES ('37.3352', '121.8811', 'SJSU')");
			
			// SIGHTING table (2)
			// statement.executeUpdate("INSERT INTO myflorabase.sighting (sighting_id, plant_id, user_id, location_id, description, date, photo, radius) VALUES (1, 1, 1, 1, 'Roses are red, violets are blue', '2024-11-11', null, 2)");
			// statement.executeUpdate("INSERT INTO myflorabase.sighting (sighting_id, plant_id, user_id, location_id, description, date, photo, radius) VALUES (2, 1, 2, 1, 'Found more roses', '2024-11-12', null, 2)");

			// PLANT table (1)
			// statement.executeUpdate("INSERT INTO myflorabase.plant (plant_id, name, scientific_name, description, poisonous, invasive, endangered) VALUES (1, 'Rose', 'Rosa rubiginosa', null, true, true, true)");

			out.println("Initial entries in table \"myFlorabase\": <br/>");

			ResultSet rs = statement.executeQuery("SELECT * FROM User");
			while (rs.next()) {
				out.println("<tr>" + "<td>" + rs.getString(1) + "</td>" + "<td>" + rs.getString(3) + "</td>" + "<td>"
						+ rs.getString(4) + "</td>" + "</tr>");
			}
			resultSet.close();
			ps.close();
			rs.close();
			statement.close();
			con.close();
		}
	} catch (SQLException e) {
		out.println("SQLException caught: " + e.getMessage());
	} catch (ClassNotFoundException e) {
		out.println("<p>MySQL JDBC Driver not found: " + e.getMessage() + "</p>");
		e.printStackTrace();
	} finally {
		if (con != null) {
			try {
				con.close();
			} catch (SQLException e) {
				out.println("<p>Failed to close the connection: " + e.getMessage() + "</p>");
			}
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
	<title>Database Setup</title>
</head>
<body>
	<h1>Database Initialization</h1>
</body>
</html>