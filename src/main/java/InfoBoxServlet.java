import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/InfoBoxServlet")
public class InfoBoxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public InfoBoxServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve message from query parameters
        String message = request.getParameter("infoMessage");

        // Set the message attribute for JSP
        request.setAttribute("infoMessage", message != null ? message : "Information have been updated");

        // Forward the request to infoBox.jsp
        request.getRequestDispatcher("/infoBox.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST requests the same way as GET requests
        doGet(request, response);
    }
}