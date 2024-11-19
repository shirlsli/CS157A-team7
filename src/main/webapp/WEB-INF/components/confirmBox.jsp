<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if confirmMessage is set in the request
    String confirmMessage = (String) request.getAttribute("confirmMessage");
    boolean showConfirmBox = (confirmMessage != null);
%>

<% if (showConfirmBox) { %>
    <div class="modal" id="confirmModal">
        <div class="modal-content">
            <div class="modal-message"><%= confirmMessage %></div>
            <div class="modal-buttons">
                <button class="modal-button delete-button" onclick="confirmDelete()">Delete</button>
                <button class="modal-button cancel-button" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>
    <script>
        function closeModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        function confirmDelete() {
            // Add Logic for deleting
            alert("Delete confirmed!");
            closeModal();
        }
    </script>
<% } %>
