<link rel="stylesheet" href="css/header.css">
<header class="prevent-select">

	<span id="navbar"> 
		<img id="logo-img" src='assets/myFlorabase_Logo_No_Text.svg' />
		<h1 id="headerTextTitle">myFlorabase</h1>
		<div class="topnav" id="right-Topnav">
			<button id="sightings" onClick="sightings()" class="${generalSightingActive} hover-underline-animation">Sightings</button> 
			<button id="mySightings" onClick="mySightings()" class="${mySightingActive} hover-underline-animation">My Sightings</button> 
			<button id="reportSightings" onClick="reportSightings()" class=" ${reportSightingActive} hover-underline-animation">Report Sighting</button>

		</div>
		<div id="profile-container" >
			<div id="profile-underline" class="${profileActive}">
				
			</div>
			<button id="profile-button" class="${userType}" onClick="profile()">
				<img id="profile-img" src="assets/default_profile_pic.jpg" alt="Profile picture">
				</button>
		</div>

	</span>


</header>
<script>

function sightings() {
	window.location='sightings';
}

function mySightings() {
	window.location='mySightings';
}

function reportSightings() {
	window.location='report';
}

function profile() {
	window.location='profile';
}


</script>

