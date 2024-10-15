var clickedLocation;

// Open the modal
function openModal(location) {
    const modal = document.getElementById('markerModal');
    modal.style.display = "block";
    document.getElementById('latitude').value = location.lat();
    document.getElementById('longitude').value = location.lng();
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
	fetch('/myFlorabase/addLog', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message: "hi" })  // Sending "hi" as a JSON object
    })
    .then(response => response.text())
    .then(data => console.log('Server response:', data))
    .catch(error => console.error('Error:', error));
		
    const title = document.getElementById('title').value.trim();
    const description = document.getElementById('description').value.trim();
    const radius = parseInt(document.getElementById('radius').value, 10);
    const latitude = parseFloat(document.getElementById('latitude').value);
    const longitude = parseFloat(document.getElementById('longitude').value);
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
        position: { lat: latitude, lng: longitude },
        title: title,
    });

    // Prepare content for the info window
    let infoContent = `<h3>${title}</h3>`;
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
