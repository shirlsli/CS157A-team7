var clickedLocation;
var loc;
// Open the modal
function openModal(location, sighting, plant) {
	const modalTitle = document.getElementById('modalTitle');
	if (sighting != null) {
		modalTitle.textContent = "Edit this Sighting";
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
	sessionStorage.setItem("sighting", JSON.stringify(sighting));
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

	const sightingRaw = sessionStorage.getItem("sighting");
	const sighting = sightingRaw !== "undefined" ? JSON.parse(sightingRaw) : null;
	// Prepare URL-encoded data
	const formData = new FormData();
	formData.append('sightingId', sighting ? sighting.sightingId : -1);
	formData.append('plantId', sighting ? sighting.plantId : -1);
	formData.append('userId', sighting ? sighting.userId : -1);
	formData.append('locationId', sighting ? sighting.locationId : -1);
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

	let url = '/myFlorabase/AddLogServlet';

	if (sighting) {
		url = '/myFlorabase/editSighting';
	}
	// Send the data to the server
	fetch(url, {
		method: 'POST',
		body: formData
	})
		.then(response => response.text())
		.then(data => {
			console.log('Successfully completed operation');
			closeModal();
			createPopup(sighting, (sighting) ? "Your edits have been saved." : "Thank you for your report! It's been successfully created.", "Close", "");
		})
		.catch(error => console.error('Error:', error));
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

function createPopup(sighting, message, primaryButtonText, secondaryButtonText, primaryCallback) {
	const popupContainer = document.getElementById("popupContainer");
	popupContainer.classList.add('popup-modal');
	const popup = document.createElement('div');
	popup.classList.add('popup-modal-content');
	const popupMessage = document.createElement('p');
	popupMessage.textContent = message;
	popupMessage.classList.add('popup-modal-message');
	popup.appendChild(popupMessage);
	if (secondaryButtonText !== "") {
		createSaveCancelButtons(popup, primaryButtonText, secondaryButtonText, primaryCallback, function() {
			popupContainer.removeChild(popup);
			popupContainer.classList.remove('popup-modal');
		});
	} else {
		const primaryButton = document.createElement("button");
		primaryButton.classList.add("primary-button", "popup-modal-button");
		primaryButton.textContent = primaryButtonText;

		primaryButton.addEventListener("click", function() {
			window.location.reload();
		});
		popup.appendChild(primaryButton);
	}
	popupContainer.appendChild(popup);
}

// Close the modal when the user clicks outside of it
window.onclick = function(event) {
	const modal = document.getElementById('markerModal');
	if (event.target == modal) {
		closeModal();
	}
}