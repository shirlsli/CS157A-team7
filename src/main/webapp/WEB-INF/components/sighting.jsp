<%@ page
	import="java.util.Properties, java.io.FileInputStream, java.io.IOException, com.example.Sighting, com.example.User, com.example.Plant, java.text.SimpleDateFormat"%>
<%
Sighting sighting = (Sighting) request.getAttribute("sighting");
User user = (User) request.getAttribute("user");
Plant plant = (Plant) request.getAttribute("plant");
SimpleDateFormat formatter = new SimpleDateFormat("MM/dd/yyyy");
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./css/modals.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
</head>

<script defer>
	function changeImage(curImg, newImage) {
		curImg.src = newImage;
	}
</script>

<div class="prevent-select">
	<span> <img class="sighting-photo"
		src='<%=sighting.getPhoto()%>' width="110" height="100" />
		<div>
			<span class="section-title-with-button sighting-row">
				<h3 class="sighting-header"><%=plant.getName()%></h3> <span
				class="icon-row">
					<button class="icon-button">
						<img src='assets/edit_icon.svg'
							class="<%=user.isAdmin() ? "icon-shown" : "icon-hidden"%>"
							onmouseover="changeImage(this, 'assets/edit_icon_hover.svg')"
							onmouseout="changeImage(this, 'assets/edit_icon.svg')" width="20"
							height="20" />
					</button>
					<button class="icon-button">
						<img src='assets/trash_icon.svg'
							class="<%=user.isAdmin() ? "icon-shown" : "icon-hidden"%>"
							onmouseover="changeImage(this, 'assets/trash_icon_hover.svg')"
							onmouseout="changeImage(this, 'assets/trash_icon.svg')" width="20"
							height="20" />
					</button>
			</span>
			</span>
			<div>
				<p class="sighting-row">
					PlantID:
					<%=plant.getPlantId()%></p>
				<span class="sighting-row sentence">
					<p>Spotted by</p>
					<p class="<%=user.isAdmin() ? "isAdmin" : "isRegular"%>"
						id="profileUsername"><%=user.getUsername()%></p>
					<p>
						on
						<%=formatter.format(sighting.getDate())%></p>
				</span>
			</div>
		</div>
	</span> <span class="sighting-row"> <img
		src='assets/scientific_name_icon.svg' width="20" height="15" />
		<p><%=plant.getScientificName()%></p>
	</span> <span class="sighting-row"> <img src='assets/location_icon.svg'
		width="20" height="17" />
		<p>Tower Lawn</p>
	</span>
	<p class="sighting-row description-label tag-row">Description</p>
	<p class="sighting-row"><%=sighting.getDescription()%></p>
	<span class="tag-row"> <span
		class="<%=plant.isPoisonous() ? "icon-shown" : "icon-hidden"%> tag poisonous">
			<p id="tagText">Poisonous</p>
	</span> <span
		class="<%=plant.isInvasive() ? "icon-shown" : "icon-hidden"%> tag invasive">
			<p id="tagText">Invasive</p>
	</span> <span
		class="<%=plant.isEndangered() ? "icon-shown" : "icon-hidden"%> tag endangered">
			<p id="tagText">Endangered</p>
	</span>
	</span>
</div>
</html>
