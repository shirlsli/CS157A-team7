package register;
import com.example.*;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UsernameCheckServlet")
public class UsernameCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UsernameCheckServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        RegisterDao rDao = new RegisterDao();
        boolean isAvailable = rDao.checkFor(username);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.write("{\"available\": " + isAvailable + "}");
        out.flush();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
