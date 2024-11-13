<%@ page
	import="java.sql.*, java.util.Properties, java.io.FileInputStream, java.io.IOException, java.util.HashMap, java.util.List, java.util.ArrayList, com.example.Sighting, com.example.User, com.example.Plant, java.util.Date"%>
<%
String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");

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
	String fetchSightingsSQL = "SELECT * FROM myflorabase.sighting";
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
<link rel="icon" href="assets/myFlorabase_Logo_No_Text.svg"
	type="image/svg">
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
		<div id="header"><jsp:include
				page="WEB-INF/components/header.jsp"></jsp:include></div>
		<div class="column-group">
			<div id="map" class="column"></div>
			<div class="column sightings-column">
				<div class="sightings-component sightings-column-div">
					<span class="sightings-title"><h1 class="pageTitle">Sightings</h1>
						<img src='assets/filter_icon.svg' width="30" height="30" /> </span>
					<div id="sightingsList"></div>
				</div>
			</div>
		</div>
		<!-- Modal Structure -->
		<jsp:include page="WEB-INF/components/modal.jsp"></jsp:include>
	</div>
	<div id="container">
		<button type="button" id="tree">TREE</button>
		<button type="button" id="grass">GRASS</button>
		<button type="button" id="weed">WEED</button>
		<button type="button" id="none">NONE</button>
	</div>
	<!-- Load the Google Maps JavaScript API -->
	<script>
        // Expose the API key to the external JavaScript file
        var GOOGLE_MAPS_API_KEY = "<%=apiKey%>
		";
	</script>
	<script async
		src="https://maps.googleapis.com/maps/api/js?key=<%=apiKey%>&callback=initMap">
		
	</script>

	<script>
        window.onload = function() {
            var sightingsListContainer = document.getElementById('sightingsList');
            fetch("/myFlorabase/getSightings")
            .then(response => {
              return response.json();
            })
            .then(sightings => {
              console.log(sightings);  
              sightings.forEach(sighting => {
            	  fetch("/myFlorabase/getSightingInfo?userId=" + sighting.userId + "&plantId=" + sighting.plantId + "&locationId=" + sighting.locationId, {
            		  method: 'GET',
            		})
            	  .then(response => {
            		  return response.json();
            	  })
            	  .then(info => {
            		  console.log(info);
            		  // info[0] = user, info[1] = plant, info[2] = location
            		  const sightingComponent = createSighting(sighting, info[0], info[1], info[2]);
                	  sightingsListContainer.appendChild(sightingComponent);
            	  })
            	  .catch(error => {
            		  console.error("Issue with fetching from FetchSightingInfo", error);
            	  });
              })
            })
            .catch(error => {
              console.error("Issue with fetching from FetchSightingsServlet", error);
            });
        };
        
        function createSighting(sighting, user, plant, location) {
        	const sightingComponent = document.createElement('div');
        	const headerContainer = document.createElement('div');
        	  sightingComponent.classList.add('prevent-select', 'sightings-component');
        	  const container = document.createElement('span');
        	  headerContainer.classList.add('header-container');

        	  const sightingPhoto = document.createElement('img');
        	  sightingPhoto.src = "/myFlorabase/getImage?condition=sighting_id&conditionValue=" + sighting.sightingId + "&imageAttributeName=photo"; 
        	  sightingPhoto.width = 110;
        	  sightingPhoto.height = 100;
        	  sightingPhoto.classList.add('sighting-photo');
			  container.appendChild(sightingPhoto);

        	  const sightingDetails = document.createElement('div');
        	  sightingDetails.classList.add('sightings-component');

        	  const headerRow = document.createElement('span');
        	  headerRow.classList.add('section-title-with-button', 'sighting-row');

        	  const headerTitle = document.createElement('h3');
        	  headerTitle.classList.add('sighting-header');
        	  headerTitle.textContent = plant.name; 

        	  const iconRow = document.createElement('span');
        	  iconRow.classList.add('icon-row');

        	  const editButton = document.createElement('button');
        	  editButton.classList.add('icon-button');
        	  const editIcon = document.createElement('img');
        	  editIcon.src = 'assets/edit_icon.svg';
        	  editIcon.width = 20;
        	  editIcon.height = 20;
        	  editIcon.classList.add(user.isAdmin ? 'icon-shown' : 'icon-hidden');
        	  editIcon.addEventListener('mouseover', function() {
        		  changeImage(this, 'assets/edit_icon_hover.svg');
        		});

        		editIcon.addEventListener('mouseout', function() {
        		  changeImage(this, 'assets/edit_icon.svg');
        		});

        		editIcon.addEventListener('click', function() {
        		  changeImage(this, 'assets/edit_icon_hover.svg');
        		});
        	  editButton.appendChild(editIcon);

        	  const trashButton = document.createElement('button');
        	  trashButton.classList.add('icon-button');
        	  const trashIcon = document.createElement('img');
        	  trashIcon.src = 'assets/trash_icon.svg';
        	  trashIcon.width = 20;
        	  trashIcon.height = 20;
        	  trashIcon.classList.add(user.isAdmin ? 'icon-shown' : 'icon-hidden');
        	  trashIcon.addEventListener('mouseover', function() {
        		  changeImage(this, 'assets/trash_icon_hover.svg');
        		});

        		trashIcon.addEventListener('mouseout', function() {
        		  changeImage(this, 'assets/trash_icon.svg');
        		});

        		trashIcon.addEventListener('click', function() {
        		  changeImage(this, 'assets/trash_icon_hover.svg');
        		});
        	  trashButton.appendChild(trashIcon);

        	  iconRow.appendChild(editButton);
        	  iconRow.appendChild(trashButton);

        	  headerRow.appendChild(headerTitle);
        	  headerRow.appendChild(iconRow);
        	  headerContainer.appendChild(headerRow);

        	  const sightingInfo = document.createElement('div');

        	  const plantId = document.createElement('p');
        	  plantId.classList.add('sighting-row');
        	  plantId.textContent = 'PlantID: ' + plant.plantId;

        	  const spottedBy = document.createElement('span');
        	  spottedBy.classList.add('sighting-row', 'sentence');
        	  
        	  const spottedByText = document.createElement('p');
        	  spottedByText.textContent = 'Spotted by';
        	  const userUsername = document.createElement('p');
        	  userUsername.classList.add(user.isAdmin ? 'isAdmin' : 'isRegular');
        	  userUsername.id = "profileUsername";
        	  userUsername.textContent = user.username;
        	  
        	  const spottedOn = document.createElement('p');
        	  spottedOn.textContent = "on " + sighting.date;
        	  
        	  spottedBy.appendChild(spottedByText);
        	  spottedBy.appendChild(userUsername);
        	  spottedBy.appendChild(spottedOn);

        	  sightingInfo.appendChild(plantId);
        	  sightingInfo.appendChild(spottedBy);
        	  headerContainer.appendChild(sightingInfo);
        	  container.appendChild(headerContainer);

        	  const scientificNameRow = document.createElement('span');
        	  scientificNameRow.classList.add('sighting-row');
        	  const scientificNameIcon = document.createElement('img');
        	  scientificNameIcon.src = 'assets/scientific_name_icon.svg';
        	  scientificNameIcon.width = 20;
        	  scientificNameIcon.height = 15;
        	  const scientificName = document.createElement('p');
        	  scientificName.textContent = plant.scientificName;
        	  scientificNameRow.appendChild(scientificNameIcon);
        	  scientificNameRow.appendChild(scientificName);

        	  const locationRow = document.createElement('span');
        	  locationRow.classList.add('sighting-row');
        	  const locationIcon = document.createElement('img');
        	  locationIcon.src = 'assets/location_icon.svg';
        	  locationIcon.width = 20;
        	  locationIcon.height = 17;
        	  const locationText = document.createElement('p');
        	  locationText.textContent = location.name; 
        	  locationRow.appendChild(locationIcon);
        	  locationRow.appendChild(locationText);

        	  const descriptionLabel = document.createElement('p');
        	  descriptionLabel.classList.add('sighting-row', 'description-label', 'tag-row');
        	  descriptionLabel.textContent = 'Description';

        	  const description = document.createElement('p');
        	  description.classList.add('sighting-row');
        	  description.textContent = sighting.description;

        	  const tagRow = document.createElement('span');
        	  tagRow.classList.add('tag-row');

        	  const poisonousTag = document.createElement('span');
        	  poisonousTag.classList.add(plant.isPoisonous ? 'icon-shown' : 'icon-hidden', 'tag', 'poisonous');
        	  const poisonousText = document.createElement('p');
        	  poisonousText.id = 'tagText';
        	  poisonousText.textContent = 'Poisonous';
        	  poisonousTag.appendChild(poisonousText);

        	  const invasiveTag = document.createElement('span');
        	  invasiveTag.classList.add(plant.isInvasive ? 'icon-shown' : 'icon-hidden', 'tag', 'invasive');
        	  const invasiveText = document.createElement('p');
        	  invasiveText.id = 'tagText';
        	  invasiveText.textContent = 'Invasive';
        	  invasiveTag.appendChild(invasiveText);

        	  const endangeredTag = document.createElement('span');
        	  endangeredTag.classList.add(plant.isEndangered ? 'icon-shown' : 'icon-hidden', 'tag', 'endangered');
        	  const endangeredText = document.createElement('p');
        	  endangeredText.id = 'tagText';
        	  endangeredText.textContent = 'Endangered';
        	  endangeredTag.appendChild(endangeredText);

        	  tagRow.appendChild(poisonousTag);
        	  tagRow.appendChild(invasiveTag);
        	  tagRow.appendChild(endangeredTag);

        	  sightingDetails.appendChild(container);
        	  sightingDetails.appendChild(scientificNameRow);
        	  sightingDetails.appendChild(locationRow);
        	  sightingDetails.appendChild(descriptionLabel);
        	  sightingDetails.appendChild(description);
        	  sightingDetails.appendChild(tagRow);

        	  sightingComponent.appendChild(sightingDetails);

        	  return sightingComponent;
        }
        
        function changeImage(curImg, newImage) {
    		curImg.src = newImage;
    	}

    	function editSighting() {
    		// call openModal with this sighting object
    		// 
    	}
    </script>

	<!-- Link to External JavaScript -->
	<script src="./js/custom.js"></script>
	<script src="./js/modal.js"></script>
</body>
</html>
