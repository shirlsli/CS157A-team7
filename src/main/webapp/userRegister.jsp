<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>User Registration</title>
<link rel="icon" href="assets/myFlorabase_Logo_No_Text.svg"
	type="image/svg">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/errorBox.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&icon_names=visibility,visibility_off" />

</head>
<body>
	<div id="signUpPage">
		<div>
			<span id="signUpPageHeader" class="prevent-select"> <img
				src='assets/myFlorabase_Logo_Text.svg' width="59" height="98" />
				<h1 class="centerText">Sign Up</h1>
			</span>
			<form action="register" method="post">
				<div class="inputGroup prevent-select">
					<label class="textfield-label">Username</label> <span><input
						id="username" type="text" name="uname"
						placeholder="Enter your username" 
						pattern='^(?=[A-Za-z0-9_]{3,15}$)(?=.*[A-Za-z]).*'
						title='Must only use letters, numbers, and underscores. Must be 3 to 15 characters, and at least one character must be a letter'
						required></span> <label class="invalid" id="usernameStatus"></label>
				</div>
				<div class="inputGroup prevent-select">
					<div class="psw-wrap">
						<label class="textfield-label">Password</label> <input id="psw"
							type="password" name="password" placeholder="Enter your password"
							pattern='(?=.*[!@#\$%\^\&\*\(\),\.\?:\{\}\|"])(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}'
							title="Must contain at least one number and one uppercase and lowercase letter and one special character, and at least 8 or more characters"
							required>
						<button type="button" id="toggle-psw"
							class="toggle-button material-symbols-outlined"
							onclick="togglePswVisibility()">visibility_off</button>

					</div>

				</div>
				<div id="message">
					<h3>Password must contain the following:</h3>
					<p id="letter" class="invalid">
						A <b>lowercase</b> letter
					</p>
					<p id="capital" class="invalid">
						A <b>capital (uppercase)</b> letter
					</p>
					<p id="number" class="invalid">
						A <b>number</b>
					</p>
					<p id="special" class="invalid">
						A <b>special</b> character: <br> !@#$%^&*(),.?:{}&quot;|
					</p>
					<p id="length" class="invalid">
						Minimum <b>8 characters</b>
					</p>
				</div>
				<div class="inputGroup prevent-select">
					<div class="psw-wrap">
						<label class="textfield-label">Confirm Password</label> <input
							id="psw2" type="password" name="password"
							placeholder="Enter your password again" value="${password}"
							title="Passwords must match" required>
						<button type="button" id="toggle-psw2"
							class="toggle-button material-symbols-outlined"
							onclick="togglePsw2Visibility()">visibility_off</button>
					</div>

				</div>
				<div class="centerButtons">
					<div id="signUpButtons">
						<button id="signUpButton" class="major-button primary-button"
							value="Sign Up">Sign Up</button>
					</div>
					<label class="label prevent-select">OR</label>
					<%--                need to redirect this to the login page --%>
					<button onclick="window.location.href='login.jsp';"
						class="major-button secondary-button" value="Log in">Log
						in</button>
				</div>
			</form>
		</div>
		<jsp:include page="WEB-INF/components/errorBox.jsp" />
	</div>
		
</body>

<script>
	var myInput = document.getElementById("psw");
	var letter = document.getElementById("letter");
	var capital = document.getElementById("capital");
	var number = document.getElementById("number");
	var length = document.getElementById("length");
	var special = document.getElementById("special");

	var myInput2 = document.getElementById("psw2");
	var match = document.getElementById("match");

	// checks if the username is unique, gives live error message
	document.getElementById("username").addEventListener("input", function() {
			var username = this.value;
			var statusElement = document
					.getElementById("usernameStatus");

			if (username.length >= 3) { // Only send request if username has at least 3 characters
				// Create the AJAX request
				var xhr = new XMLHttpRequest();
				xhr.open("GET", "UsernameCheckServlet?username="
						+ encodeURIComponent(username), true);

				xhr.onload = function() {
					if (xhr.status === 200) {
						var response = JSON.parse(xhr.responseText);
						if (response.available) {
							statusElement.textContent = "";
							document.getElementById("username").setCustomValidity('');
						} else {
							statusElement.textContent = "Username is already taken. Please enter a different username.";
							document.getElementById("username").setCustomValidity('Please enter a different username');
						}
					} else {
						console.error("Error checking username availability");
					}
				};

				xhr.onerror = function() {
					console.error("Request failed");
				};

				xhr.send();
			} else {
				statusElement.textContent = "";
			}
		});

	// When the user clicks on the password field, show the message box
	myInput.onfocus = function() {
		if (!document.getElementById("psw").checkValidity()) {
			document.getElementById("message").style.display = "block";
		}
	}

	myInput2.onfocus = function() {
		if (document.getElementById("psw2").value == document
				.getElementById("psw").value) {
			myInput2.setCustomValidity('');
		} else {
			myInput2.setCustomValidity("Passwords must match");
		}
		myInput2.reportValidity();
	}
	myInput2.onkeyup = function() {
		if (document.getElementById("psw2").value == document
				.getElementById("psw").value) {
			myInput2.setCustomValidity('');
		} else {
			myInput2.setCustomValidity("Passwords must match");
		}
		myInput2.reportValidity();
	}

	// When the user clicks outside of the password field, hide the message box
	myInput.onblur = function() {
		if (document.getElementById("psw").checkValidity()) {
			document.getElementById("message").style.display = "none";
		}
	}

	// When the user starts to type something inside the password field
	myInput.onkeyup = function() {
		// Validate lowercase letters
		if (!document.getElementById("psw").checkValidity()) {
			document.getElementById("message").style.display = "block";
		}

		var lowerCaseLetters = /[a-z]/g;
		if (myInput.value.match(lowerCaseLetters)) {
			letter.classList.remove("invalid");
			letter.classList.add("valid");
		} else {
			letter.classList.remove("valid");
			letter.classList.add("invalid");
		}

		// Validate capital letters
		var upperCaseLetters = /[A-Z]/g;
		if (myInput.value.match(upperCaseLetters)) {
			capital.classList.remove("invalid");
			capital.classList.add("valid");
		} else {
			capital.classList.remove("valid");
			capital.classList.add("invalid");
		}

		// Validate numbers
		var numbers = /[0-9]/g;
		if (myInput.value.match(numbers)) {
			number.classList.remove("invalid");
			number.classList.add("valid");
		} else {
			number.classList.remove("valid");
			number.classList.add("invalid");
		}

		// Validate length
		if (myInput.value.length >= 8) {
			length.classList.remove("invalid");
			length.classList.add("valid");
		} else {
			length.classList.remove("valid");
			length.classList.add("invalid");
		}

		// Validate special characters
		var specialChars = /[!@#$%^&*(),.?:{}|"]/g;
		if (myInput.value.match(specialChars)) {
			special.classList.remove("invalid");
			special.classList.add("valid");
		} else {
			special.classList.remove("valid");
			special.classList.add("invalid");
		}

	}

	function togglePswVisibility() {
		var x = document.getElementById("psw");
		if (x.type === "password") {
			x.type = "text";
			document.getElementById("toggle-psw").innerHTML = "visibility";
		} else {
			x.type = "password";
			document.getElementById("toggle-psw").innerHTML = "visibility_off";
		}
	}
	function togglePsw2Visibility() {
		var x = document.getElementById("psw2");
		if (x.type === "password") {
			x.type = "text";
			document.getElementById("toggle-psw2").innerHTML = "visibility";
		} else {
			x.type = "password";
			document.getElementById("toggle-psw2").innerHTML = "visibility_off";

		}
	}
</script>
</html>