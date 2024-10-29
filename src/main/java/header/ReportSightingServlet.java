package header;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/report")
public class ReportSightingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ReportSightingServlet() {super();}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        response.getWriter().append("Served at: ").append(request.getContextPath());
        request.setAttribute("reportSightingActive", "active");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("sightings.jsp");
        dispatcher.forward(request, response);
        response.sendRedirect("sightings.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        
    }

    public void destroy() {
    }
}