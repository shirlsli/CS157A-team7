var clickedLocation;
var loc;
// Open the modal
function openModal(location) {
	const modal = document.getElementById('markerModal');
	modal.style.display = "block";
	loadReportSightingsMap(location);
	loc = location;
}

async function loadReportSightingsMap(location) {
	const mapElement = document.getElementById("reportSightingsMap");
	const { Map } = await google.maps.importLibrary("maps");
	AdvancedMarkerElement = (await google.maps.importLibrary("marker")).AdvancedMarkerElement;

	let map = new Map(mapElement, {
		zoom: 16,
		center: location,
		mapId: "DEMO_MAP_ID",
	});

	let marker = new AdvancedMarkerElement({
		map: map,
		position: location
	});
}

// Close the modal
function closeModal() {
	const modal = document.getElementById('markerModal');
	modal.style.display = "none";
	document.getElementById('markerForm').reset();
}

// Handle form submission
function submitMarker(event) {
    event.preventDefault();
	
	// Sending a simple log message "hi" to the addLog servlet
	fetch('/myFlorabase/AddLogServlet', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message: "hi" })  // Sending "hi" as a JSON object
    })
    .then(response => response.text())
    .then(data => console.log('Server response:', data))
    .catch(error => console.error('Error:', error));

	const plantName = document.getElementById('plantName').value.trim();
	const date = document.getElementById('date').value.trim();
	const description = document.getElementById('description').value.trim();
	const radius = parseInt(document.getElementById('radius').value, 10);
	const selected = document.querySelectorAll('#specificTags input[type="checkbox"]');
	const selectedValues = [];
	selected.forEach((checkbox) => {
		if (checkbox.checked) {
			selectedValues.push(checkbox.value);
		}
	});
	const photoInput = document.getElementById('photo');
	const photoFile = photoInput.files[0];

	// Validate radius
	if (isNaN(radius) || radius < 0) {
		alert('Please enter a valid radius.');
		return;
	}
	// Create a new marker using AdvancedMarkerElement in test.js

	const newMarker = new AdvancedMarkerElement({
		map: map,
		position: loc,
		title: plantName,
	});

	// Prepare content for the info window
	let infoContent = `<h3>${plantName}</h3>`;
	if (description) {
		infoContent += `<p>${description}</p>`;
	}

	if (photoFile) {
		const reader = new FileReader();
		reader.onload = function(e) {
			infoContent += `<img src="${e.target.result}" alt="Marker Photo" style="max-width: 200px; max-height: 200px;"/>`;
			attachInfoWindow(newMarker, infoContent);
		};
		reader.readAsDataURL(photoFile);
	} else {
		attachInfoWindow(newMarker, infoContent);
	}

	// Close the modal
	closeModal();
}

// Attach an info window to a marker
function attachInfoWindow(marker, content) {
	const infoWindow = new google.maps.InfoWindow({
		content: content
	});

	marker.addListener('click', function() {
		infoWindow.open(map, marker);
	});
}

// Close the modal when the user clicks outside of it
window.onclick = function(event) {
	const modal = document.getElementById('markerModal');
	if (event.target == modal) {
		closeModal();
	}
}
