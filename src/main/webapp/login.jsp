<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Log In</title>
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/errorBox.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">

</head>
<body>
	<div class="container">
		<div id="signUpPage">
			<div>
				<span id="signUpPageHeader" class="prevent-select"> <img
					src='assets/myFlorabase_Logo_Text.svg' width="59" height="98" />
					<h1 class="centerText">Log In</h1>
				</span>

				<form action="LoginServlet" method="post">
					<div class="inputGroup textfield-label">
						<label>Username</label> <span><input type="text"
							name="uname" placeholder="Enter your username" required></span>
					</div>
					<div class="inputGroup textfield-label">
						<label>Password</label> <input type="password" name="password"
							placeholder="Enter your password" required>

						<!-- //TODO: Add toggle to show password -->
						<!-- <button type="button" id="toggle-psw"
							class="toggle-button material-symbols-outlined"
							onclick="togglePswVisibility()">visibility_off</button> -->
					</div>
					<div class="centerButtons">
						<div id="logInButtons">
							<button class="major-button primary-button" type="submit"
								value="Log In">Log In</button>
						</div>
					</div>
				</form>
				<div class="centerButtons">
					<label class="label prevent-select">OR</label>
					<button class="major-button secondary-button" value="Sign Up"
						onclick="window.location.href='userRegister.jsp'">Sign Up</button>
				</div>
			</div>
		</div>

	</div>

	<!-- Include the errorBox.jsp for displaying error messages when present -->
	<jsp:include page="WEB-INF/components/errorBox.jsp" />

	<!-- <script>
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
</script> -->
</html>