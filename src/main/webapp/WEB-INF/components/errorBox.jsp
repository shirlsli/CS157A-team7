<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// Check if errorTitle and errorMessage are set in the request
String errorMessage = (String) request.getAttribute("errorMessage");
boolean showErrorBox = (errorMessage != null);
%>

<%
if (showErrorBox) {
%>
<html>
<head>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
</head>
<div class="modal" id="errorModal">
	<div class="modal-content">
		<p class="modal-message"><%=errorMessage%></p>
		<button class="major-button primary-button modal-button" onclick="closeModal()">Close</button>
	</div>
</div>
<script>
	function closeModal() {
		document.getElementById('errorModal').style.display = 'none';
	}
</script>
</html>
<%
}
%>