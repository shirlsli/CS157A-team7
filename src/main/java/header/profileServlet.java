package header;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/profile")
public class profileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public profileServlet() {super();}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        response.getWriter().append("Served at: ").append(request.getContextPath());
        request.setAttribute("profileActive", "active");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp"); 
        dispatcher.forward(request, response);
        response.sendRedirect("profile.jsp"); 
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        
    }

    public void destroy() {
    }
}