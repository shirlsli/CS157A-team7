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
	<div id="registerConfirmationPage">
		<div>
			<span id="registerConfirmationHeader" class="prevent-select">
				<img src='assets/myFlorabase_Logo_Text.svg' width="59" height="98" />
				<h1 class="centerText">${headermsg}</h1>
			</span>
			<div>
				<div id="registerConfirmationMessage prevent-select" class="prevent-select">
					<span><label>${dynamicContent}</label></span>
				</div>
				<div class="centerButtons">
					<div id="signUpButtons">
						<button onclick="${onclick}" id="signUpButton" class="major-button primary-button"
							value="${buttonText}">${buttonText}</button>
			</div>


		</div>
	</div>

</body>
</html>