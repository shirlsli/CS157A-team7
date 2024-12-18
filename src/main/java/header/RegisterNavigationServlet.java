package header;

import com.example.*;

import java.io.*;
import javax.servlet.http.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/signup")
public class RegisterNavigationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public RegisterNavigationServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		RequestDispatcher dispatcher = request.getRequestDispatcher("userRegister.jsp");
		request.setAttribute("registerHeaderButton", "active-regular"); // set active header tab
		dispatcher.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
	}

	public void destroy() {
	}
}