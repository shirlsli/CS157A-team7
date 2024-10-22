package com.example;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/submitForm")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Register() {super();}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String uname = request.getParameter("uname");
        String password = request.getParameter("password");
        User user = new User(uname, password, false);
        RegisterDao rDao = new RegisterDao();
        boolean result = rDao.insert(user);
        
//        response.getWriter().print(result);
        
        // Set a dynamic attribute to be used in the JSP
        if (result) {
        	request.setAttribute("headermsg", "Registered!");
        	request.setAttribute("dynamicContent", "Username: '" + uname + "' successfully signed up! Please login");
        	request.setAttribute("buttonText", "Log In");
        	request.setAttribute("onclick", "window.location.href='login.jsp';");
        }
        else {
        	request.setAttribute("headermsg", "Not Registered!");
        	request.setAttribute("dynamicContent", "Username: '" + uname + "' already exists. Please try again with a different username.");
        	request.setAttribute("buttonText", "Sign Up");
        	request.setAttribute("onclick", "window.location.href='userRegister.jsp';");
        }
        

        // Forward the request to the JSP page
        RequestDispatcher dispatcher = request.getRequestDispatcher("registerConfirmation.jsp");
        dispatcher.forward(request, response);
        response.sendRedirect("registerConfirmation.jsp");
    }

    public void destroy() {
    }
}