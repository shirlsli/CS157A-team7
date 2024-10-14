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
  // The location of Uluru
  const position = { lat: -25.344, lng: 131.031 };
  // Request needed libraries.
  //@ts-ignore
  const { Map } = await google.maps.importLibrary("maps");
  AdvancedMarkerElement = (await google.maps.importLibrary("marker")).AdvancedMarkerElement;

  // The map, centered at Uluru
  map = new Map(document.getElementById("map"), {
    zoom: 4,
    center: position,
    mapId: "DEMO_MAP_ID",
  });

  // The marker, positioned at Uluru
  const marker = new AdvancedMarkerElement({
    map: map,
    position: position,
    title: "Uluru",
  });

  // Add click listener to the map
  map.addListener('click', function(event) {
    clickedPosition = event.latLng;
    openModal(clickedPosition);
  });
}

// Initialize the map
initMap();