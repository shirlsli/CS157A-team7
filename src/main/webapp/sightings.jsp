<%@ page
	import="java.sql.*, java.util.Properties, java.io.FileInputStream, java.io.IOException, com.example.Sighting, com.example.User, com.example.Plant, java.util.Date"%>
<%

String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");
Sighting sighting = new Sighting(1, "Roses are red, violets are blue", 2.0, new Date());
Plant plant = new Plant(1, "Rose", "Rosa rubiginosa", "Roses are red, violets are blue", true, true, true);
request.setAttribute("sighting", sighting);
request.setAttribute("plant", plant);

String dUser; // assumes database name is the same as username
dUser = "root";
String pwd = System.getenv("DB_PASSWORD");
User user = null;

try {
	java.sql.Connection con;
	Class.forName("com.mysql.jdbc.Driver");
	con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", dUser, pwd);
	Statement statement = con.createStatement();
	String sql = "SELECT * FROM myflorabase.user WHERE user_id=1";
	ResultSet rs = statement.executeQuery(sql);
	if (rs.next()) {
		int userId = rs.getInt("user_id");
		String username = rs.getString("username");
		String password = rs.getString("password");
		String description = rs.getString("description");
		boolean isAdmin = rs.getBoolean("isAdmin");
		user = new User(userId, username, password, description, isAdmin);
		request.setAttribute("user", user);
	}
	

	rs.close();
	statement.close();
	con.close();
} catch (SQLException e) {
	System.out.println("SQLException caught: " + e.getMessage());
}

%>
<!DOCTYPE html>
<html>
<head>
<title>Sightings</title>
<!-- Link to External CSS -->
<link rel="icon" href="assets/myFlorabase_Logo_No_Text.svg" type="image/svg">
<link rel="stylesheet" type="text/css" href="./css/modals.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<div class="sightingsPage">
		<jsp:include page="WEB-INF/components/header.jsp"></jsp:include>
		<div class="column-group">
			<div id="map" class="column"></div>
			<div class="column sightings-column">
				<h1 class="pageTitle">Sightings</h1>
				<jsp:include page="WEB-INF/components/sighting.jsp"></jsp:include>
			</div>
		</div>

		<!-- Modal Structure -->
		<div id="markerModal" class="modal">
			<div class="modal-content">
				<h1 class="pageTitle">Report a New Sighting</h1>
				<form id="markerForm" onsubmit="submitMarker(event)">
					<div class="column-group">
						<div class="column">
							<div id="reportSightingsMap" class="reportSightingsMap"></div>
							<span class="button-group">
								<button class="major-button primary-button" type="submit">Report</button>
								<button class="major-button secondary-button" type="button"
									onclick="closeModal()">Close</button>
							</span>
						</div>
						<div class="column">
							<span class="input-span">
								<div class="form-group">
									<label class="required textfield-label" for="plantName">Plant
										Name</label> <input type="text" id="plantName" name="plantName"
										placeholder="Try your best to identify the plant" />
								</div>
								<div class="form-group">
									<label class="required textfield-label" for="date">Date</label>
									<input type="date" id="date" name="date" />
								</div>
							</span>
							<div class="form-group">
								<label class="textfield-label" for="description">Description</label>
								<textarea id="description" name="description"
									placeholder="Try your best to describe the plant and the nearby surroundings"></textarea>
							</div>
							<span class="input-span">
								<div>
									<div class="form-group">
										<label class="textfield-label" for="radius">Estimated
											Radius (meters)</label> <input type="number" id="radius"
											name="radius" min="0" placeholder="Estimated radius" required />
									</div>
									<div class="form-group">
										<label class="required textfield-label" for="photo">Photo
											of Plant</label> <input type="file" id="photo" name="photo"
											accept="image/*" />
									</div>
								</div>
								<div id="specificTags" class="form-group">
									<label class="textfield-label" for="specificTags">Based
										on your knowledge, please indicate if this plant is poisonous,
										invasive, and/or endangered.</label>
									<div>
										<label class="checkbox-label prevent-select"> <input
											type="checkbox" value="poisonous"> <span
											class="checkbox"></span> Poisonous
										</label> <label class="checkbox-label prevent-select"> <input
											type="checkbox" value="invasive"> <span
											class="checkbox"></span> Invasive
										</label> <label class="checkbox-label prevent-select"> <input
											type="checkbox" value="endangered"> <span
											class="checkbox"></span> Endangered
										</label>
									</div>
								</div>
							</span>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<!-- Load the Google Maps JavaScript API -->
	<script async
		src="https://maps.googleapis.com/maps/api/js?key=<%=apiKey%>&callback=initMap">
		
	</script>

	<!-- Link to External JavaScript -->
	<script src="./js/test.js"></script>
	<script src="./js/modal.js"></script>
</body>
</html>
