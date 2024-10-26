/**
 * @license
 * Copyright 2019 Google LLC. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */
// Initialize and add the map
let map;
let clickedPosition;
let AdvancedMarkerElement;

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
}

// Initialize the map
initMap();