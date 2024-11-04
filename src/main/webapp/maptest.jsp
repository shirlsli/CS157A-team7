<%@ page import="java.util.Properties, java.io.FileInputStream, java.io.IOException" %>
<%
    String apiKey = System.getenv("GOOGLE_MAPS_API_KEY");
    if (apiKey == null || apiKey.isEmpty()) {
        System.out.println("GOOGLE_MAPS_API_KEY is not set.");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Pollen Heatmaps Around the World</title>
    <style>
        /*
        * Always set the map height explicitly to define the size of the div element
        * that contains the map.
        */
        #map {
            height: 600px;
        }
        #container {
            position: absolute;
            display: inline-block;
            z-index: 10;
            margin-left: 50%;
            transform: translateX(-50%);
            bottom: 40px;
        }
        button {
            width: 100px;
            height: 34px;
            display: inline-block;
            position: relative;
            text-align: center;
            border: none;
            box-shadow: 0px 0px 4px 0px rgba(0,0,0,0.29);
            color: #FFF;
            font-weight: 400;
            border-radius: 4px;
            margin-left: 4px;
            font-family: "Google Sans", "Roboto", "Arial";
            line-height: 1em;
        }
        #tree { background: #009c1a; }
        #grass { background: #22b600; }
        #weed { background: #26cc00; }
        button:active { background: #999999 !important; }
    </style>
    <script>
        let pollen = "TREE_UPI";
        class PollenMapType {
            tileSize;
            alt = null;
            maxZoom = 16;
            minZoom = 3;
            name = null;
            projection = null;
            radius = 6378137;
            constructor(tileSize) {
                this.tileSize = tileSize;
            }
            getTile(coord, zoom, ownerDocument) {
                const img = ownerDocument.createElement("img");
                const mapType = pollen;
                const normalizedCoord = getNormalizedCoord(coord, zoom);
                if (!normalizedCoord) {
                    return null;
                }
                const x = normalizedCoord.x;
                const y = normalizedCoord.y;
                const key = "<%= apiKey %>";
                console.log(y);
                console.log(x);
                img.style.opacity = 0.8;
                console.log(`Requesting tile: https://pollen.googleapis.com/v1/mapTypes/\${mapType}/heatmapTiles/\${zoom}/\${x}/\${y}?key=\${key}`);
                img.src = `https://pollen.googleapis.com/v1/mapTypes/\${mapType}/heatmapTiles/\${zoom}/\${x}/\${y}?key=\${key}`;
                return img;
            }
            releaseTile(tile) {}
        }

        function getNormalizedCoord(coord, zoom) {
            const y = coord.y;
            let x = coord.x;
            const tileRange = 1 << zoom;

            // Don't repeat across Y-axis (vertically)
            if (y < 0 || y >= tileRange) {
                return null;
            }

            // Repeat across X-axis
            if (x < 0 || x >= tileRange) {
                x = ((x % tileRange) + tileRange) % tileRange;
            }
            return { x: x, y: y };
        }

        function initMap() {
            const myLatLng = { lat: 40.3769, lng: -80.5417 };
            const map = new google.maps.Map(document.getElementById("map"), {
                mapId: "ffcdd6091fa9fb03",
                zoom: 5, // Increased initial zoom for better visibility
                center: myLatLng,
                maxZoom: 16,
                minZoom: 3,
                restriction: {
                    latLngBounds: { north: 80, south: -80, west: -180, east: 180 },
                    strictBounds: true,
                },
                streetViewControl: false,
            });
            const pollenMapType = new PollenMapType(new google.maps.Size(256, 256));
            map.overlayMapTypes.insertAt(0, pollenMapType);

            document.querySelector("#tree").addEventListener("click", function() {
                pollen = "TREE_UPI";
                map.overlayMapTypes.removeAt(0);
                const pollenMapType = new PollenMapType(new google.maps.Size(256, 256));
                map.overlayMapTypes.insertAt(0, pollenMapType);
            });
            document.querySelector("#grass").addEventListener("click", function() {
                pollen = "GRASS_UPI";
                map.overlayMapTypes.removeAt(0);
                const pollenMapType = new PollenMapType(new google.maps.Size(256, 256));
                map.overlayMapTypes.insertAt(0, pollenMapType);
            });
            document.querySelector("#weed").addEventListener("click", function() {
                pollen = "WEED_UPI";
                map.overlayMapTypes.removeAt(0);
                const pollenMapType = new PollenMapType(new google.maps.Size(256, 256));
                map.overlayMapTypes.insertAt(0, pollenMapType);
            });
        }
    </script>
    <script
        src="https://maps.googleapis.com/maps/api/js?callback=initMap&v=weekly&key=<%= apiKey %>&language=en" defer>
    </script>
</head>
<body>
    <div id="container">
        <button type="button" id="tree">TREE</button>
        <button type="button" id="grass">GRASS</button>
        <button type="button" id="weed">WEED</button>
    </div>
    <div id="map"></div>
</body>
</html>