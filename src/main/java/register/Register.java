package register;

import com.example.*;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/register")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Register() {super();}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.getWriter().append("Served at: ").append(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uname = request.getParameter("uname");
        String password = request.getParameter("password");
        User user = new User(uname, password, false);
        RegisterDao rDao = new RegisterDao();
        boolean result = rDao.insert(user);
        
        if (result) {
        	request.setAttribute("dynamicContent", uname );
            RequestDispatcher dispatcher = request.getRequestDispatcher("registerConfirmation.jsp");
            dispatcher.forward(request, response);
        }
        else {
        	request.setAttribute("errorTitle", "Sign Up Error");
			request.setAttribute("errorMessage", "Please check database or database connection and try again.");
			request.getRequestDispatcher("userRegister.jsp").forward(request, response);
        }
        
    }

    public void destroy() {
    }
}