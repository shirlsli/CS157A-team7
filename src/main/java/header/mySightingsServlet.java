package header;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/mySightings")
public class mySightingsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public mySightingsServlet() {super();}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        response.getWriter().append("Served at: ").append(request.getContextPath());
        request.setAttribute("mySightingActive", "active");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("sightings.jsp"); // this needs to be changed to the correct jsp file? using sightings.jsp as temporary test
        dispatcher.forward(request, response);
        response.sendRedirect("sightings.jsp"); // this needs to be changed to the correct jsp file? using sightings.jsp as temporary test
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        
    }

    public void destroy() {
    }
}