package com.example;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

@WebServlet("/Register")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Register() {super();}

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.getWriter().append("Served at: ").append(request.getContextPath());

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String uname = request.getParameter("uname");
        String password = request.getParameter("password");
        User user = new User(uname, password, false);
        RegisterDao rDao = new RegisterDao();
        String result = rDao.insert(user);
        response.getWriter().print(result);
    }

    public void destroy() {
    }
}