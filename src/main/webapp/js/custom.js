/*
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */
let map;
let clickedPosition;
let AdvancedMarkerElement;

// let pollen = "TREE_UPI"; 

class PollenMapType {
    constructor(tileSize, apiKey) {
        this.tileSize = tileSize;
        this.maxZoom = 16;
        this.minZoom = 3;
        this.apiKey = apiKey;
    }

    getTile(coord, zoom, ownerDocument) {
        const img = ownerDocument.createElement("img");
        const mapType = pollen;
        const normalizedCoord = this.getNormalizedCoord(coord, zoom);
        if (!normalizedCoord) {
            return null;
        }
        const { x, y } = normalizedCoord;
        const key = this.apiKey;

        img.style.opacity = 0.8;
        img.style.width = this.tileSize.width + "px";
        img.style.height = this.tileSize.height + "px";
        img.src = `https://pollen.googleapis.com/v1/mapTypes/${mapType}/heatmapTiles/${zoom}/${x}/${y}?key=${key}`;
        return img;
    }

    releaseTile(tile) {}

    getNormalizedCoord(coord, zoom) {
        let { x, y } = coord;
        const tileRange = 1 << zoom;

        if (y < 0 || y >= tileRange) {
            return null;
        }

        x = ((x % tileRange) + tileRange) % tileRange;
        return { x, y };
    }
}

function updatePollenMapType(map, apiKey) {
    map.overlayMapTypes.removeAt(0);
    const newPollenMapType = new PollenMapType(new google.maps.Size(256, 256), apiKey);
    map.overlayMapTypes.insertAt(0, newPollenMapType);
}

function attachInfoWindow(marker, content) {
    const infoWindow = new google.maps.InfoWindow({
        content: content
    });

    marker.addListener('click', function() {
        infoWindow.open(map, marker);
    });
}

async function initMap() {
    const position = { lat: 37.3352, lng: -121.8811 };
    //@ts-ignore
    const { Map } = await google.maps.importLibrary("maps");
    AdvancedMarkerElement = (await google.maps.importLibrary("marker")).AdvancedMarkerElement;

    map = new Map(document.getElementById("map"), {
        zoom: 16,
        center: position,
        mapId: "DEMO_MAP_ID",
    });

    const marker = new AdvancedMarkerElement({
        map: map,
        position: position,
        title: "SJSU",
    });

    map.addListener('click', function(event) {
        clickedPosition = event.latLng;
        openModal(clickedPosition);
    });

    const apiKey = window.GOOGLE_MAPS_API_KEY;

    if (!apiKey) {
        console.error("Google Maps API key is not found.");
        return;
    }

	fetch("/myFlorabase/getSightings")
	    .then(response => response.json())
	    .then(sightings => {
	        console.log(sightings);
	        let sightingsArray = [];
	        sightings.forEach(sighting => {
	            fetch(`/myFlorabase/getSightingInfo?userId=${sighting.userId}&plantId=${sighting.plantId}&locationId=${sighting.locationId}`, {
	                method: 'GET',
	            })
	            .then(response => response.json())
	            .then(info => {
	                console.log(info);
	                // info[0] = user, info[1] = plant, info[2] = location
	                sightingsArray.push(info);

	                // Create markers with info windows for each sighting
	                const location = { lat: info[2].latitude, lng: info[2].longitude };
	                const plantName = info[1].name;
	                const newMarker = new AdvancedMarkerElement({
	                    map: map,
	                    position: location,
	                    title: plantName,
	                });
	                console.log('Marker added for:', plantName);

	                let infoContent = `
	                    <div>
	                        <h3>${plantName}</h3>
	                        <p>Location: ${info[2].name}</p>
	                        <p>Reported by: ${info[0].username}</p>
	                    </div>`;

	                // If sighting has a photo, convert it to a base64 string
	                if (sighting.photo && sighting.photo.length > 0) {
	                    const photoBase64 = arrayBufferToBase64(sighting.photo);
	                    infoContent += `<img src="data:image/jpeg;base64,${photoBase64}" alt="Sighting Photo" style="max-width: 200px; max-height: 200px;"/>`;
	                }

	                attachInfoWindow(newMarker, infoContent);
	            })
	            .catch(error => {
	                console.error("Issue with fetching from FetchSightingInfo", error);
	            });
	        });
	        console.log("Parsed Sightings Array: ", sightingsArray);
	    })
	    .catch(error => {
	        console.error("Issue with fetching from FetchSightingsServlet", error);
	    });

	// Helper function to convert byte array to base64 string
	function arrayBufferToBase64(buffer) {
	    let binary = '';
	    const bytes = new Uint8Array(buffer);
	    for (let i = 0; i < bytes.byteLength; i++) {
	        binary += String.fromCharCode(bytes[i]);
	    }
	    return btoa(binary);
	}


    // Commented out the pollen-related map overlay initialization
    // const pollenMapType = new PollenMapType(new google.maps.Size(256, 256), apiKey);
    // map.overlayMapTypes.insertAt(0, pollenMapType);

    // Commented out pollen map type update listeners
    /*
    document.getElementById("tree").addEventListener("click", function() {
        pollen = "TREE_UPI";
        updatePollenMapType(map, apiKey);
    });
    document.getElementById("grass").addEventListener("click", function() {
        pollen = "GRASS_UPI";
        updatePollenMapType(map, apiKey);
    });
    document.getElementById("weed").addEventListener("click", function() {
        pollen = "WEED_UPI";
        updatePollenMapType(map, apiKey);
    });
    document.getElementById("none").addEventListener("click", function() {
        map.overlayMapTypes.removeAt(0);
    });
    */
}

window.initMap = initMap;
console.log("Test 2222");
initMap();