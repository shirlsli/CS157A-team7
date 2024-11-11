<%@ page import="java.util.Properties, java.io.FileInputStream, java.io.IOException" %>
<%
    String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");
    if (apiKey == null || apiKey.isEmpty()) {
        out.println("<p style='color:red;'>GOOGLE_MAPS_API_KEY is not set.</p>");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Pollen Heatmaps and Advanced Map Features</title>
    <style>
        /* Map container styling */
        #map {
            height: 600px;
            width: 100%;
        }
        /* Control buttons styling */
        #container {
            position: absolute;
            display: inline-block;
            z-index: 10;
            margin: 10px;
            top: 10px;
            left: 50%;
            transform: translateX(-50%);
        }
        button {
            width: 100px;
            height: 34px;
            display: inline-block;
            margin: 0 5px;
            border: none;
            box-shadow: 0px 0px 4px 0px rgba(0,0,0,0.29);
            color: #FFF;
            font-weight: 400;
            border-radius: 4px;
            font-family: "Google Sans", "Roboto", "Arial";
            line-height: 1em;
            cursor: pointer;
        }
        /* Button colors */
        #tree { background: #009c1a; }
        #grass { background: #22b600; }
        #weed { background: #26cc00; }
        #none { background: #555555; }
        button:active { background: #999999 !important; }
        
        /* Modal container */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 100; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }
        
        /* Modal content */
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto; /* 15% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 80%; /* Could be more or less, depending on screen size */
            border-radius: 8px;
        }
        
        /* Close button */
        .close-button {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        
        .close-button:hover,
        .close-button:focus {
            color: black;
            text-decoration: none;
        }
    </style>
    <script>
        // Expose the API key to the external JavaScript file
        var GOOGLE_MAPS_API_KEY = "<%= apiKey %>";
    </script>
</head>
<body>
    <!-- Control Buttons -->
    <div id="container">
        <button type="button" id="tree">TREE</button>
        <button type="button" id="grass">GRASS</button>
        <button type="button" id="weed">WEED</button>
        <button type="button" id="none">NONE</button>
    </div>
    <!-- Map Container -->
    <div id="map"></div>
    
    <!-- Modal Structure -->
    <div id="myModal" class="modal">
        <div class="modal-content">
            <span class="close-button">&times;</span>
            <p id="modal-text">Some text in the Modal..</p>
        </div>
    </div>

    <!-- Load your custom JavaScript file first -->
    <script src="js/custom.js" defer></script>
    <!-- Load the Google Maps JavaScript API after custom.js -->
    <script
        src="https://maps.googleapis.com/maps/api/js?key=<%= apiKey %>&callback=initMap&v=weekly&language=en"
        defer
    ></script>
</body>
</html>
