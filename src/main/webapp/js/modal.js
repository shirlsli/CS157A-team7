var clickedLocation;
var loc;
// Open the modal
function openModal(location, sighting, plant) {
	console.log(location);
	const modalTitle = document.getElementById('modalTitle');
	if (sighting != null) {
		modalTitle.textContent = "Edit this Sighting";
		// set the other values
		const plantName = document.getElementById('plantName');
		plantName.value = plant.name;
		const date = document.getElementById('date');
		const dateValue = new Date(sighting.date);
		const year = dateValue.getFullYear();
		const month = String(dateValue.getMonth() + 1).padStart(2, '0');
		const day = String(dateValue.getDate()).padStart(2, '0');
		const formattedDate = `${year}-${month}-${day}`;
		date.value = formattedDate;
		const description = document.getElementById('description');
		description.textContent = sighting.description;
		const radius = document.getElementById('radius');
		radius.value = sighting.radius;
		const selected = document.querySelectorAll('#specificTags input[type="checkbox"]');
		if (plant.poisonous) {
			selected[0].checked = true;
		}
		if (plant.invasive) {
			selected[1].checked = true;
		}
		if (plant.endangered) {
			selected[2].checked = true;
		}
		const reportButton = document.getElementById("reportButton");
		reportButton.textContent = "Save";
	} else {
		modalTitle.textContent = "Report a New Sighting";
	}
	const modal = document.getElementById('markerModal');
	const header = document.getElementById('header');
	header.style.display = "hidden";
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
	const header = document.getElementById('header');
	header.style.display = "block";
	modal.style.display = "none";
	document.getElementById('markerForm').reset();
}

// Handle form submission
function submitMarker(event) {
	event.preventDefault();

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

	// Prepare URL-encoded data
	const formData = new FormData();
	formData.append('plantId', '1'); // Replace with actual plantId
	formData.append('userId', '1'); // Replace with actual userId
	formData.append('locationId', '1'); // Replace with actual locationId
	formData.append('plantName', plantName);
	formData.append('date', date);
	formData.append('description', description);
	formData.append('radius', radius);
	formData.append('latitude', loc.lat());
	formData.append('longitude', loc.lng());
	selectedValues.forEach(value => formData.append('selectedValues', value));
	if (photoFile) {
		formData.append('photo', photoFile);
	}

	// Send the data to the server
	fetch('/myFlorabase/AddLogServlet', {
		method: 'POST',
		body: formData // FormData handles setting the correct multipart/form-data header
	})
		.then(response => response.text())
		.then(data => console.log('Server response:', data))
		.catch(error => console.error('Error:', error));

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