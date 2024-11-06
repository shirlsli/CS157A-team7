<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if errorTitle and errorMessage are set in the request
    String errorTitle = (String) request.getAttribute("errorTitle");
    String errorMessage = (String) request.getAttribute("errorMessage");
    boolean showErrorBox = (errorTitle != null && errorMessage != null);
%>

<% if (showErrorBox) { %>
    <div class="modal" id="errorModal">
        <div class="modal-content">
            <div class="modal-header"><%= errorTitle %></div>
            <div class="modal-message"><%= errorMessage %></div>
            <button class="modal-button" onclick="closeModal()">Close</button>
        </div>
    </div>
    <script>
        function closeModal() {
            document.getElementById('errorModal').style.display = 'none';
        }
    </script>
<% } %>