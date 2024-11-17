<%@ page
	import="java.util.Properties, java.io.FileInputStream, java.io.IOException, com.example.Sighting, com.example.User, com.example.Plant, java.text.SimpleDateFormat"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./css/modals.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<script src="./js/custom.js"></script>
<script src="./js/modal.js"></script>
</head>

<div id="markerModal" class="modal">
	<div class="modal-content">
		<h1 id="modalTitle" class="pageTitle"></h1>
		<form id="markerForm" onsubmit="submitMarker(event)">
			<div class="column-group">
				<div class="column">
					<div id="reportSightingsMap" class="reportSightingsMap"></div>
					<span class="button-group">
						<button id="reportButton" class="major-button primary-button" type="submit">Report</button>
						<button class="major-button secondary-button" type="button"
							onclick="closeModal()">Close</button>
					</span>
				</div>
				<div class="column">
					<span class="input-span">
						<div class="form-group">
							<label class="required textfield-label" for="plantName">Plant
								Name</label> <input type="text" id="plantName" name="plantName"
								placeholder="Try your best to identify the plant" />
						</div>
						<div class="form-group">
							<label class="required textfield-label" for="date">Date</label> <input
								type="date" id="date" name="date" />
						</div>
					</span>
					<div class="form-group">
						<label class="textfield-label" for="description">Description</label>
						<textarea id="description" name="description"
							placeholder="Try your best to describe the plant and the nearby surroundings"></textarea>
					</div>
					<span class="input-span">
						<div>
							<div class="form-group">
								<label class="textfield-label" for="radius">Estimated
									Radius (meters)</label> <input type="number" id="radius" name="radius"
									min="0" placeholder="Estimated radius" required />
							</div>
							<div class="form-group">
								<label class="required textfield-label" for="photo">Photo
									of Plant</label> <input type="file" id="photo" name="photo"
									accept="image/*" />
							</div>
						</div>
						<div id="specificTags" class="form-group">
							<label class="textfield-label" for="specificTags">Based
								on your knowledge, please indicate if this plant is poisonous,
								invasive, and/or endangered.</label>
							<div>
								<label class="checkbox-label prevent-select"> <input
									type="checkbox" value="poisonous"> <span
									class="checkbox"></span> Poisonous
								</label> <label class="checkbox-label prevent-select"> <input
									type="checkbox" value="invasive"> <span
									class="checkbox"></span> Invasive
								</label> <label class="checkbox-label prevent-select"> <input
									type="checkbox" value="endangered"> <span
									class="checkbox"></span> Endangered
								</label>
							</div>
						</div>
					</span>
				</div>
			</div>
		</form>
	</div>
</div>
</html>
