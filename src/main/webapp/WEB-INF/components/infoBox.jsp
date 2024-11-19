<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // Check if infoMessage is set in the request
    String infoMessage = (String) request.getAttribute("infoMessage");
    boolean showInfoBox = (infoMessage != null);
%>

<% if (showInfoBox) { %>
    <div class="modal" id="infoModal">
        <div class="modal-content">
            <div class="modal-message"><%= infoMessage %></div>
            <button class="modal-button" onclick="closeModal()">Close</button>
        </div>
    </div>
    <script>
        function closeModal() {
            document.getElementById('infoModal').style.display = 'none';
        }
    </script>
<% } %>