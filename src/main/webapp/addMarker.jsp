<%
     String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Interactive Google Maps</title>
    <!-- Link to External CSS -->
    <link rel="stylesheet" type="text/css" href="./css/modals.css">
</head>
<body>
    <h1>Interactive Google Map</h1>
    <div id="map"></div>

    <!-- Modal Structure -->
	<div id="markerModal" class="modal">
	    <div class="modal-content">
	        <span class="close" onclick="closeModal()">&times;</span>
	        <h2>Add a Sighting</h2>
	        <form id="markerForm" onsubmit="submitMarker(event)">
	            <div class="form-group">
	                <label for="latitude">Latitude:</label>
	                <input type="text" id="latitude" name="latitude" readonly />
	            </div>
	            <div class="form-group">
	                <label for="longitude">Longitude:</label>
	                <input type="text" id="longitude" name="longitude" readonly />
	            </div>
	            <div class="form-group">
	                <label for="title">Title:</label>
	                <input type="text" id="title" name="title" required />
	            </div>
	            <div class="form-group">
	                <label for="description">Description:</label>
	                <input type="text" id="description" name="description" />
	            </div>
	            <div class="form-group">
	                <label for="radius">Radius (meters):</label>
	                <input type="number" id="radius" name="radius" min="0" required />
	            </div>
	            <div class="form-group">
	                <label for="photo">Photo:</label>
	                <input type="file" id="photo" name="photo" accept="image/*" />
	            </div>
	            <button type="submit">Add Marker</button>
	        </form>
	    </div>
	</div>

    <!-- Load the Google Maps JavaScript API -->
    <script async
        src="https://maps.googleapis.com/maps/api/js?key=<%= apiKey %>&callback=initMap">
    </script>
    <!-- Link to External JavaScript -->
    <script src="./js/test.js"></script>
    <script src="./js/modal.js"></script>
</body>
</html>
