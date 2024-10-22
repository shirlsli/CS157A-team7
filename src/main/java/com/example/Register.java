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
        
        if (result) {
        	request.setAttribute("dynamicContent", uname );
            RequestDispatcher dispatcher = request.getRequestDispatcher("registerConfirmation.jsp");
            dispatcher.forward(request, response);
            response.sendRedirect("registerConfirmation.jsp");
        }
        else {
        	request.setAttribute("uname", uname);
        	request.setAttribute("password", password);
        	request.setAttribute("usrnmError", "Username '"+uname+"' already exists. Please choose another username.");
        	request.getRequestDispatcher("userRegister.jsp").forward(request, response);
        }
        

        
    }

    public void destroy() {
    }
}