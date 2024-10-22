<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>User Registration</title>
<link rel="stylesheet" href="css/style.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

</head>
<body>
	<div id="signUpPage">
		<div>
			<span id="signUpPageHeader" class="prevent-select"> <img
				src='assets/myFlorabase_Logo_Text.svg' width="59" height="98" />
				<h1 class="centerText">Sign Up</h1>
			</span>
			<form action="submitForm" method="post">
				<div class="inputGroup prevent-select">
					<label class="textfield-label">Username</label> <span><input
						type="text" name="uname" placeholder="Enter your username"
						required></span>
				</div>
				<div class="inputGroup prevent-select">
					<label class="textfield-label">Password</label> <input id="psw"
						type="password" name="password" placeholder="Enter your password"
						pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}"
						title="Must contain at least one number and one uppercase and lowercase letter, and at least 8 or more characters"
						required>
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
					<p id="length" class="invalid">
						Minimum <b>8 characters</b>
					</p>
				</div>
				<div class="inputGroup prevent-select">
					<label class="textfield-label">Confirm Password</label> <input
						id="psw2" type="password" name="password"
						placeholder="Enter your password again"
						title="Passwords must match" required>
				</div>
				<div class="centerButtons">
					<div id="signUpButtons">
						<button id="signUpButton" class="major-button primary-button" value="Sign Up">Sign
							Up</button>
					</div>
					<label class="label prevent-select">OR</label>
					<%--                need to redirect this to the login page --%>
					<button class="major-button secondary-button" value="Log in">Log in</button>
				</div>
			</form>
		</div>
	</div>

</body>
<script>
	var myInput = document.getElementById("psw");
	var letter = document.getElementById("letter");
	var capital = document.getElementById("capital");
	var number = document.getElementById("number");
	var length = document.getElementById("length");

	var myInput2 = document.getElementById("psw2");
	var match = document.getElementById("match");

	// When the user clicks on the password field, show the message box
	myInput.onfocus = function() {
		document.getElementById("message").style.display = "block";
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
		document.getElementById("message").style.display = "none";
	}

	// When the user starts to type something inside the password field
	myInput.onkeyup = function() {
		// Validate lowercase letters
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
	}
</script>
</html>