import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ConfirmBoxServlet")
public class ConfirmBoxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ConfirmBoxServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve message from query parameters
        String message = request.getParameter("message");

        // Set the confirmMessage attribute for JSP
        request.setAttribute("confirmMessage", message != null ? message : "Are you sure you want to proceed?");

        // Forward the request to confirmBox.jsp
        request.getRequestDispatcher("/confirmBox.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST requests the same way as GET requests
        doGet(request, response);
    }
}
