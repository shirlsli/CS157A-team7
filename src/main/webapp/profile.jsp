<%@ page
	import="java.sql.*, com.example.User, com.example.MapPreference, com.example.Filter, java.util.List, java.util.ArrayList"%>
<html>
<head>
<title>myFlorabase Profile</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%
	/* HttpSession curSession = request.getSession();
	User user = (User) curSession.getAttribute("loggedInUser"); */
	String dUser; // assumes database name is the same as username
	dUser = "root";
	String pwd = "root";
	User user = null;
	MapPreference mp = null;
	List<Filter> filters = new ArrayList<>();
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
			Blob blob = rs.getBlob("profile_pic");
			String description = rs.getString("description");
			boolean isAdmin = rs.getBoolean("isAdmin");
			user = new User(userId, username, password, description, isAdmin);
			if (blob != null) {
		byte[] profilePic = blob.getBytes(1, (int) blob.length());
		response.setContentType("image/jpeg");
		response.setContentLength(profilePic.length);
		ServletOutputStream outputStream = response.getOutputStream();
		outputStream.write(profilePic);
		outputStream.close();
			} else {
		// set profile pic to default
			}
		}
		String mapPreferenceSQL = "SELECT * FROM myflorabase.mappreference WHERE user_id=" + user.getUserId();
		rs = statement.executeQuery(mapPreferenceSQL);
		if (rs.next()) {
			int preferenceId = rs.getInt("preference_id");
			int prefUserId = rs.getInt("user_id");
			int prefFilterId = rs.getInt("filter_id");
			int prefLocationId = rs.getInt("location_id");
			int zoom = rs.getInt("zoom");
			mp = new MapPreference(preferenceId, prefUserId, prefFilterId, prefLocationId, zoom);
		}

		String filtersSQL = "SELECT * FROM myflorabase.filter WHERE filter_id=" + mp.getFilterId();
		rs = statement.executeQuery(filtersSQL);
		while (rs.next()) {
			int filterId = rs.getInt("filter_id");
			String color = rs.getString("color");
			String filterName = rs.getString("filter_name");
			Filter filter = new Filter(filterId, color, filterName);
			filters.add(filter);
		}

		rs.close();
		statement.close();
		con.close();
	} catch (SQLException e) {
		System.out.println("SQLException caught: " + e.getMessage());
	}
	%>

	<script defer>
		function changeProfilePic() {

		}
		
		function primaryButtonClick(buttonId) {
			buttonId.style.border = '1px solid #EAAC9D';
			buttonId.style.background = 'white';
			buttonId.style.color = "#EAAC9D"
		    
		    setTimeout(() => {
		    	buttonId.style.border = '';
		    	buttonId.style.background = '#EAAC9D';
		    	buttonId.style.color = "black";
		    }, 200);
		}
		
		function secondaryButtonClick(buttonId) {
			buttonId.style.background = '#EAAC9D';
			buttonId.style.color = "black"
		    
		    setTimeout(() => {
		    	buttonId.style.background = 'white';
		    	buttonId.style.color = "#EAAC9D";
		    }, 200);
		}

		function editDescription(button) {
			secondaryButtonClick(button);
			button.style.display = "none";
			const descriptionDiv = document.getElementById("descriptionDiv");
			const description = document.getElementById("description").textContent;
			if (description && descriptionDiv) {
				const temp = description;
				descriptionDiv.removeChild(document.getElementById("description"));
				const textField = document.createElement("textarea");
				const cancelButton = document.createElement("button");
				const saveButton = document.createElement("button");
				textField.setAttribute("id", "descriptionEditBox");
				cancelButton.setAttribute("class", "secondary-button");
				saveButton.setAttribute("class", "primary-button");
				cancelButton.textContent = "Cancel";
				saveButton.textContent = "Save";
				const span = document.createElement("span");
				span.setAttribute("id", "buttonGroup");
				span.appendChild(saveButton);
				span.appendChild(cancelButton);
				descriptionDiv.appendChild(textField);
				descriptionDiv.appendChild(span);
				cancelButton.addEventListener("click", function() {
					secondaryButtonClick(cancelButton);
					endEditingDescription(temp, button);
				});
				saveButton.addEventListener("click", function() {
					primaryButtonClick(saveButton);
					const newDescription = textField.value;
					fetch('/myFlorabase/updateDescription', { 
					    method: 'POST',
					    headers: {
					        'Content-Type': 'application/x-www-form-urlencoded',
					    },
					    body: 'description=' + encodeURIComponent(newDescription) + '&userId=' + <%= user.getUserId() %>
					})
					.then(response => response.text())
					.then(data => {
					    console.log(data);
					    endEditingDescription(newDescription, button);
					})
					.catch(error => console.error('Error:', error));
				});
			}
		}

		function endEditingDescription(description, button) {
			const descriptionDiv = document.getElementById("descriptionDiv");
			const span = document.getElementById("buttonGroup");
			const descriptionEditBox = document.getElementById("descriptionEditBox");
			const descriptionText = document.createElement("p");
			descriptionText.setAttribute("id", "description");
			if (descriptionDiv && span && descriptionEditBox) {
				descriptionText.textContent = description;
				descriptionDiv.removeChild(span);
				descriptionDiv.removeChild(descriptionEditBox);
				descriptionDiv.appendChild(descriptionText);
				button.style.display = "block";
			}
		}
	</script>
	<jsp:include page="WEB-INF/components/header.jsp"></jsp:include>
	<div id="profilePage">
		<span> <img id="profilePic"
			class="prevent-select <%=user.isAdmin() ? "isAdmin" : "isRegular"%>"
			src="assets/default_profile_pic.jpg" onclick="changeProfilePic()" />
			<h1 class="<%=user.isAdmin() ? "isAdmin" : "isRegular"%>"
				id="profileUsername"><%=user.getUsername()%></h1>
		</span>
		<div id="descriptionDiv">
			<span class="section-title-with-button">
				<h2>Description</h2>
				<button class="secondary-button" onclick="editDescription(this)">Edit</button>
			</span>
			<p id="description"><%=user.getDescription()%></p>
		</div>
		<div id="zoomDiv">
			<span class="section-title-with-button">
				<h2>Default Zoom</h2>
				<button class="secondary-button" onclick="editDescription(this)">Edit</button>
			</span>
			<p id="zoom"><%=mp.getZoom()%>%
			</p>
		</div>
		<div id="filtersDiv">
			<span class="section-title-with-button">
				<h2>Filters</h2>
				<button class="secondary-button" onclick="editDescription(this)">Edit</button>
			</span>
			<%
			for (Filter f : filters) {
			%>
				<label class="checkbox-label prevent-select"> 
					<input type="checkbox">
					<span class="checkbox"></span> <%=f.getFilterName()%></label>
			<%
			}
			%>
		</div>
	</div>
</body>
</html>