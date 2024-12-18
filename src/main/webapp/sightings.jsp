<%@ page
	import="java.sql.*, java.util.Properties, com.google.gson.Gson, java.io.FileInputStream, java.io.IOException, java.util.HashMap, java.util.List, java.util.ArrayList, com.example.Sighting, com.example.User, com.example.Plant, com.example.Filter, java.util.Date"%>
<%
String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");
HttpSession curSession = request.getSession(false);
User user = (User) curSession.getAttribute("user");
String userJson = new Gson().toJson(user);
boolean mySightingsPage = false;
if (request.getAttribute("mySightingActive") != null) {
	mySightingsPage = true;
}


String dUser; // assumes database name is the same as username
dUser = "root";
String pwd = System.getenv("DB_PASSWORD");

if (pwd == null) {
	System.out.println("DB_PASSWORD environment variable is not set.");
}

List<Filter> filters = new ArrayList<>();
if (user != null){
	try {
		java.sql.Connection con;
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false", dUser, pwd);
		Statement statement = con.createStatement();

		String filtersSQL = "SELECT uf.filter_id, filter_name, active FROM myflorabase.user_filter uf, myflorabase.filter f WHERE uf.filter_id = f.filter_id AND user_id = '"
		+ user.getUserId() + "'";
		ResultSet rs = statement.executeQuery(filtersSQL);
		while (rs.next()) {
			int filterId = rs.getInt("filter_id");
			String filterName = rs.getString("filter_name");
			int active = rs.getInt("active");
			boolean isActive = false;
			if (active == 1) {
		isActive = true;
			}
			Filter filter = new Filter(filterId, filterName, isActive);
			filters.add(filter);
		}
		rs.close();
		statement.close();
		con.close();
	} catch (SQLException e) {
		System.out.println("SQLException caught: " + e.getMessage());
	}
}

%>
<!DOCTYPE html>
<html>
<head>
<title><%=!mySightingsPage ? "Sightings" : "My Sightings"%></title>
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
<script>var user = <%=userJson%>; /*  for disabling map click */</script>

	<div id="sightingsPage" class="sightingsPage">
		<div id="header"><jsp:include
				page="WEB-INF/components/header.jsp"></jsp:include></div>

		<div id="sightingsDiv">
			<div>
				<div id="map" class="column"></div>
				
					<!--  -->
					<%if (user != null) { %>
					<div id="custom_filters">
						<div id="filtersDiv">
							<span class="section-title-with-button">
								<h2 id="map_filter_title">My Map Filters</h2>
							</span>
							<%
							for (Filter f : filters) {
							%>
							<label id="filter-checkbox-row" class="checkbox-label prevent-select">
								<input type="checkbox" value="<%=f.getFilterId()%>"
								class="filters-checkbox" <%=f.isActive() ? "checked" : ""%>
								onchange="updateActiveFilters()"> <span class="checkbox"></span>
								<%=f.getFilterName()%> <span class="icon-row"> 
							</span>
							</label>
							<%
							}
							%>
						</div>
					</div>
					<%} %>	
				<div id="container">
					<button class="major-button secondary-button" type="button"
						id="tree">Tree</button>
					<button class="major-button secondary-button" type="button"
						id="grass">Grass</button>
					<button class="major-button secondary-button" type="button"
						id="weed">Weed</button>
					<button class="major-button secondary-button" type="button"
						id="none">None</button>
				</div>
			</div>
			<div class="column sightings-column">
				<div class="sightings-component sightings-column-div">
					<span class="sightings-title"><h1 class="pageTitle"><%=!mySightingsPage ? "Sightings" : "My Sightings"%></h1>
						<div>
							<img src='assets/filter_icon.svg' width="30" height="30"
								onclick="showFilterDropdown()" /> <span id="filterDropdown">
								<div>
									<label class="checkbox-label prevent-select"> <input
										id="mostRecentCheckbox" type="checkbox"
										onchange="dropdownSubmit(this)"> <span
										class="checkbox"></span> Most Recent
									</label> <label class="checkbox-label prevent-select"> <input
										id="oldestCheckbox" type="checkbox"
										onchange="dropdownSubmit(this)"> <span
										class="checkbox"></span> Oldest
									</label> 
									
									
									
									<span id="filterDropdownCloseButton">
										<button class="major-button secondary-button" type="button"
											onclick="hideFilterDropdown()">Close</button>
									</span>
								</div>

							</span>
						</div> </span>
					<!-- Search bar -->
					<%
					if (!mySightingsPage) {
					%>
					<div class="search-container">
						<input id="searchBar" type="text" class="icon" name="searchQuery"
							onkeydown="searchBarQuery(event)"
							placeholder="Search for a specific plant" />
					</div>
					<div id="searchResultsLabel"></div>
					<%
					} else {
					%>
					<div class="spacer"></div>
					<%
					}
					%>
					<div id="sightingsList"></div>
				</div>

			</div>
		</div>
		<!-- Modal Structure -->
		<jsp:include page="WEB-INF/components/modal.jsp"></jsp:include>
		<!-- Error Box to handle Search -->
		<jsp:include page="WEB-INF/components/errorBox.jsp" />
		<div id="popupContainer"></div>
	</div>

	<script src="./js/buttons.js"></script>
	<script src="./js/modal.js"></script>
	<script>
		
	
		var allSightings = [];
		var enterPressed = false;
		window.addEventListener("load", function() {
			const isSightingsPage = <%=!mySightingsPage%>;
			const sightingsListContainer = document.getElementById('sightingsList');
			fetch("/myFlorabase/getSightings")
			.then(response => {
			  return response.json();
			})
			.then(sightings => {
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
					  const curUser = <%=userJson%>;
					  if (isSightingsPage) {
						  const sightingComponent = createSighting(sighting, info[0], info[1], info[2], curUser);
					  	sightingsListContainer.appendChild(sightingComponent);
					  	allSightings.push(sightingsComponent.cloneNode(true));
					  } else {
						  if (info[0].username === curUser.username) {
							  const sightingComponent = createSighting(sighting, info[0], info[1], info[2], curUser);
					  		sightingsListContainer.appendChild(sightingComponent);
					  		allSightings.push(sightingsComponent.cloneNode(true));
						  }
					  }
				  })
				  .catch(error => {
					  console.error("Issue with fetching from FetchSightingInfo", error);
				  });
			  });
			})
			.catch(error => {
			  console.error("Issue with fetching from FetchSightingsServlet", error);
			});
		})

		function showFilterDropdown() {
			const dropdownContainer = document.getElementById("filterDropdown");
			dropdownContainer.style.display = "block";
		}

		function hideFilterDropdown() {
			const dropdownContainer = document.getElementById("filterDropdown");
			dropdownContainer.style.display = "none";
		}
		
		function searchBarQuery(event) {
			const sightingsList = document.getElementById("sightingsList");
			const searchBarLabelDiv = document.getElementById("searchResultsLabel");
			searchBarLabelDiv.innerHTML = "";
			if (event.key === "Enter") {
				const sightingsArr = enterPressed ? allSightings : Array.from(sightingsList.children);
				const searchQuery = getSearchQuery().trim().toLowerCase();
				if (searchQuery === "") {
					sightingsList.replaceChildren(...allSightings);
				} else {
					searchBarLabelDiv.classList.add('prevent-select');
					const selectedMarkerResult = document.createElement("h3");
					selectedMarkerResult.style.marginBottom = "5px";
					selectedMarkerResult.textContent = "Selected Marker Result";
					const underline = document.createElement("div");
					underline.id = "searchResultsUnderline";
					const searchNum = document.createElement("p");
					searchNum.style.marginBottom = "20px";
					const newSightingsArr = sightingsArr.filter((node) => {
					    const plantName = node.childNodes[0].childNodes[0].childNodes[1].childNodes[0].childNodes[0].textContent.trim().toLowerCase();
						return plantName === searchQuery;
					});
					searchNum.textContent = newSightingsArr.length + " sighting" + (newSightingsArr.length === 1 ? " " : "s ") + "for this plant";
					searchBarLabelDiv.appendChild(selectedMarkerResult);
					searchBarLabelDiv.appendChild(underline);
					searchBarLabelDiv.appendChild(searchNum);
					sightingsList.replaceChildren(...newSightingsArr);
					if (!enterPressed) {
						allSightings = sightingsArr;
					}
				}
				enterPressed = true;
			} 
		}

		function dropdownSubmit(checkbox) {
			const label = checkbox.closest('label');
			const labelText = label.textContent.trim();
			// check if another checkbox is checked, if so must uncheck it
			const mostRecentCheckbox = document.getElementById("mostRecentCheckbox");
			const oldestCheckbox = document.getElementById("oldestCheckbox");
			if (labelText === "Oldest" && mostRecentCheckbox.checked) {
				mostRecentCheckbox.checked = false;
			} else if (labelText === "Most Recent" && oldestCheckbox.checked) {
				oldestCheckbox.checked = false;
			}
			const sightingsList = document.getElementById("sightingsList");
			const sightingsArr = Array.from(sightingsList.children);
			sightingsArr.sort((a, b) => {
			    const textA = a.childNodes[0].childNodes[0].childNodes[1].childNodes[1].childNodes[1].childNodes[2].childNodes[0].data.trim().slice(3);
			    const textB = b.childNodes[0].childNodes[0].childNodes[1].childNodes[1].childNodes[1].childNodes[2].childNodes[0].data.trim().slice(3);
				const dateA = new Date(textA);
				const dateB = new Date(textB);
				if (labelText === "Most Recent") {
			        return dateB - dateA;
			    }
				return dateA - dateB;
			});
			console.log(sightingsArr);
			sightingsList.replaceChildren(...sightingsArr);
			hideFilterDropdown();
		}

		function createSighting(sighting, user, plant, location, curUser) {
			const sightingComponent = document.createElement('div');
			const headerContainer = document.createElement('div');
			sightingComponent.classList.add('prevent-select', 'sightings-component');
			const container = document.createElement('span');
			headerContainer.classList.add('header-container');

			const sightingPhoto = document.createElement('img');
			sightingPhoto.src = "/myFlorabase/getImage?condition=sighting_id&conditionValue=" + sighting.sightingId + "&imageAttributeName=photo" + "&table=sighting";
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
			editIcon.classList.add(curUser != null && (curUser.isAdmin || curUser.username === user.username) ? 'icon-shown' : 'icon-hidden');
			editIcon.addEventListener('mouseover', function() {
				changeImage(this, 'assets/edit_icon_hover.svg');
			});

			editIcon.addEventListener('mouseout', function() {
				changeImage(this, 'assets/edit_icon.svg');
			});

			editIcon.addEventListener('click', function() {
				changeImage(this, 'assets/edit_icon_hover.svg');
				editSighting(location.latitude, location.longitude, sighting, plant);
			});
			editButton.appendChild(editIcon);

			const trashButton = document.createElement('button');
			trashButton.classList.add('icon-button');
			const trashIcon = document.createElement('img');
			trashIcon.src = 'assets/trash_icon.svg';
			trashIcon.width = 20;
			trashIcon.height = 20;
			trashIcon.classList.add(curUser != null && (curUser.isAdmin || curUser.username === user.username) ? 'icon-shown' : 'icon-hidden');
			trashIcon.addEventListener('mouseover', function() {
				changeImage(this, 'assets/trash_icon_hover.svg');
			});

			trashIcon.addEventListener('mouseout', function() {
				changeImage(this, 'assets/trash_icon.svg');
			});

			trashIcon.addEventListener('click', function() {
				changeImage(this, 'assets/trash_icon_hover.svg');
				deleteSighting(sighting);
			});
			trashButton.appendChild(trashIcon);

			const flagButton = document.createElement('button');
			flagButton.classList.add('icon-button');
			const flagIcon = document.createElement('img');
			flagIcon.src = 'assets/flag_icon.svg';
			flagIcon.width = 20;
			flagIcon.height = 20;
			flagIcon.classList.add(curUser != null ? 'icon-shown' : 'icon-hidden');
			flagIcon.addEventListener('mouseover', function() {
				changeImage(this, 'assets/flag_icon_hover.svg');
			});

			flagIcon.addEventListener('mouseout', function() {
				changeImage(this, 'assets/flag_icon.svg');
			});

			flagIcon.addEventListener('click', function() {
				changeImage(this, 'assets/flag_icon_hover.svg');
				flagSighting(sighting, curUser);
			});
			flagButton.appendChild(flagIcon);

			iconRow.appendChild(editButton);
			iconRow.appendChild(trashButton);
			iconRow.appendChild(flagButton);

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
			const username = document.createElement('p');
			username.classList.add(user.isAdmin ? 'isAdmin' : 'isRegular');
			username.id = "profileUsername";
			username.textContent = user.username;

			const spottedOn = document.createElement('p');
			spottedOn.textContent = "on " + sighting.date;

			spottedBy.appendChild(spottedByText);
			spottedBy.appendChild(username);
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
			descriptionLabel.classList.add('sighting-row', 'description-label');
			descriptionLabel.textContent = 'Description';

			const description = document.createElement('p');
			description.classList.add('sighting-row');
			description.textContent = sighting.description;

			const tagRow = document.createElement('span');
			tagRow.classList.add('tag-row');
			const poisonousTag = document.createElement('span');
			poisonousTag.classList.add(plant.poisonous ? 'icon-shown' : 'icon-hidden');
			poisonousTag.classList.add('tag');
			poisonousTag.classList.add('poisonous');
			const poisonousText = document.createElement('p');
			poisonousText.id = 'tagText';
			poisonousText.textContent = 'Poisonous';
			poisonousTag.appendChild(poisonousText);

			const invasiveTag = document.createElement('span');
			invasiveTag.classList.add(plant.invasive ? 'icon-shown' : 'icon-hidden');
			invasiveTag.classList.add('tag');
			invasiveTag.classList.add('invasive');
			const invasiveText = document.createElement('p');
			invasiveText.id = 'tagText';
			invasiveText.textContent = 'Invasive';
			invasiveTag.appendChild(invasiveText);

			const endangeredTag = document.createElement('span');
			endangeredTag.classList.add(plant.endangered ? 'icon-shown' : 'icon-hidden');
			endangeredTag.classList.add('tag');
			endangeredTag.classList.add('endangered');
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

		function editSighting(latitude, longitude, sighting, plant) {
			const location = new google.maps.LatLng(latitude, longitude);
			openModal(location, sighting, plant);
		}

		function deleteSighting(sighting) {
			createPopup(sighting, "Are you sure you want to delete this sighting?", "Delete", "Cancel", function() {
				const dateValue = new Date(sighting.date);
				const year = dateValue.getFullYear();
				const month = String(dateValue.getMonth() + 1).padStart(2, '0');
				const day = String(dateValue.getDate()).padStart(2, '0');
				const formattedDate = year + "-" + month + "-" + day;
				sighting.date = formattedDate;
				fetch('/myFlorabase/deleteSighting', {
					method: 'POST',
					headers: {
				        'Content-Type': 'application/json'
				    },
					body: JSON.stringify(sighting)
				})
					.then(response => response.text())
					.then(data => {
						console.log("Successfully deleted sighting");
						window.location.reload();
					})
					.catch(error => console.error('Error:', error));
			}, false);
		}

		function flagSighting(sighting, curUser) {
			createPopup(sighting, "Submit a reason for flagging this sighting", "Flag", "Cancel", function(flagReason) {
				console.log(flagReason);
			}, true, curUser);
		}
		
		// activate/deactivate filters
	    function updateActiveFilters() {
	    	
	    	const filterCheckboxes = document.querySelectorAll('.filters-checkbox');
	      	const activeFilters = [];
	      	const inactiveFilters = [];
	        filterCheckboxes.forEach(checkbox => {
	        	if (checkbox.checked) {
	        		activeFilters.push(checkbox.value);  // Store checked values
	        	} else {
	        		inactiveFilters.push(checkbox.value); // Store unchecked values
	        	}
	        }); 
	     	// Prepare URL-encoded data
			const formData = new FormData();
			
			// Append the value of each checked checkbox to the FormData object
		    activeFilters.forEach(value => {
		        formData.append('activeFilters', value);
		    });
			
			// Append the value of each unchecked checkbox to the FormData object
		    inactiveFilters.forEach(value => {
		        formData.append('inactiveFilters', value);
		    });
		    
		 	// Log each key-value pair in the FormData object
	        for (const [key, value] of formData.entries()) {
	            console.log(key, `:`, value);
	        }
						
			// Send the data to the server
			fetch('/myFlorabase/EditActiveFilterServlet', {
				method: 'POST',
				body: formData // FormData handles setting the correct multipart/form-data header
			})
				.then(response => response.text())
				.then(data => {
					console.log('Server response:', data)
					updateMapWithSightings();
				})
				.catch(error => console.error('Error:', error));
	    }
	    
	</script>

	<!-- Load the Google Maps JavaScript API -->
	<script>
		// Expose the API key to the external JavaScript file
		var GOOGLE_MAPS_API_KEY = "<%=apiKey%>";
	</script>

	<script async
		src="https://maps.googleapis.com/maps/api/js?key=<%=apiKey%>&callback=initMap">
	</script>

	<!-- Link to External JavaScript -->
	<script src="./js/custom.js"></script>
</body>
</html>