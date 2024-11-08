const apiKey = process.env.GOOGLE_MAPS_API_KEY;

let map;
let clickedPosition;
let AdvancedMarkerElement;
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

    img.style.opacity = 0.8;
    img.src = `https://pollen.googleapis.com/v1/mapTypes/${mapType}/heatmapTiles/${zoom}/${x}/${y}?key=${apiKey}`;
    return img;
  }

  releaseTile(tile) {}
}

function getNormalizedCoord(coord, zoom) {
  const y = coord.y;
  let x = coord.x;
  const tileRange = 1 << zoom;

  if (y < 0 || y >= tileRange) {
    return null;
  }

  if (x < 0 || x >= tileRange) {
    x = ((x % tileRange) + tileRange) % tileRange;
  }

  return { x: x, y: y };
}

async function initMap() {
  const position = { lat: 37.3352, lng: -121.8811 };
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

  map.addListener('click', function (event) {
    clickedPosition = event.latLng;
    console.log(`Clicked position: ${clickedPosition.lat()}, ${clickedPosition.lng()}`);
  });

  const pollenMapType = new PollenMapType(new google.maps.Size(256, 256));
  map.overlayMapTypes.insertAt(0, pollenMapType);

  document.querySelector("#tree").addEventListener("click", function () {
    pollen = "TREE_UPI";
    map.overlayMapTypes.removeAt(0);
    const newPollenMapType = new PollenMapType(new google.maps.Size(256, 256));
    map.overlayMapTypes.insertAt(0, newPollenMapType);
  });

  document.querySelector("#grass").addEventListener("click", function () {
    pollen = "GRASS_UPI";
    map.overlayMapTypes.removeAt(0);
    const newPollenMapType = new PollenMapType(new google.maps.Size(256, 256));
    map.overlayMapTypes.insertAt(0, newPollenMapType);
  });

  document.querySelector("#weed").addEventListener("click", function () {
    pollen = "WEED_UPI";
    map.overlayMapTypes.removeAt(0);
    const newPollenMapType = new PollenMapType(new google.maps.Size(256, 256));
    map.overlayMapTypes.insertAt(0, newPollenMapType);
  });

  document.querySelector("#none").addEventListener("click", function () {
    map.overlayMapTypes.removeAt(0);
  });
}

initMap();