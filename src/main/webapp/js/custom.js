/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */
// Initialize and add the map
let map;
let clickedPosition;
let AdvancedMarkerElement;

// Define the current pollen type (default to TREE_UPI)
let pollen = "TREE_UPI";

// --- Begin Pollen Heatmap Logic ---

// Define the PollenMapType class
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
        const key = this.apiKey; // Use the injected API key

        img.style.opacity = 0.8;
        img.style.width = this.tileSize.width + "px";
        img.style.height = this.tileSize.height + "px";
        img.src = `https://pollen.googleapis.com/v1/mapTypes/${mapType}/heatmapTiles/${zoom}/${x}/${y}?key=${key}`;
        return img;
    }

    releaseTile(tile) {
        // Optional: Handle tile release if needed
    }

    getNormalizedCoord(coord, zoom) {
        let { x, y } = coord;
        const tileRange = 1 << zoom;

        // Don't repeat across Y-axis (vertically)
        if (y < 0 || y >= tileRange) {
            return null;
        }

        // Repeat across X-axis horizontally
        x = ((x % tileRange) + tileRange) % tileRange;
        return { x, y };
    }
}

// Function to update the pollen heatmap overlay
function updatePollenMapType(map, apiKey) {
    map.overlayMapTypes.removeAt(0); // Remove existing overlay
    const newPollenMapType = new PollenMapType(new google.maps.Size(256, 256), apiKey);
    map.overlayMapTypes.insertAt(0, newPollenMapType);
}

// --- End Pollen Heatmap Logic ---

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

  // Add click listener to the map
  map.addListener('click', function(event) {
    clickedPosition = event.latLng;
    openModal(clickedPosition);
  });

  // --- Begin Pollen Heatmap Integration ---

  // Retrieve the API key from a global variable (ensure this is set in your HTML/JSP)
  const apiKey = window.GOOGLE_MAPS_API_KEY;

  if (!apiKey) {
      console.error("Google Maps API key is not found.");
      return;
  }

  // Define and add the pollen heatmap overlay
  const pollenMapType = new PollenMapType(new google.maps.Size(256, 256), apiKey);
  map.overlayMapTypes.insertAt(0, pollenMapType);

  // Add event listeners to the control buttons
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
      map.overlayMapTypes.removeAt(0); // Remove the pollen overlay
  });

  // --- End Pollen Heatmap Integration ---
}

// Ensure initMap is accessible globally if needed
window.initMap = initMap;

// Initialize the map
initMap();
