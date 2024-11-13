package header;

import java.io.*;
import javax.servlet.http.*;

import com.example.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;

@WebServlet("/mySightings")
public class mySightingsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public mySightingsServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		request.setAttribute("mySightingActive", "active"); // set active header tab

		// set profile outline color
		HttpSession curSession = request.getSession(false);

		if (curSession == null || curSession.getAttribute("user") == null) {
			request.setAttribute("errorTitle", "You were logged out!");
			request.setAttribute("errorMessage", "Please Sign In again.");
			request.getRequestDispatcher("login.jsp").forward(request, response);
		} else {

			RequestDispatcher dispatcher = request.getRequestDispatcher("sightings.jsp"); // this needs to be changed to
																							// the correct jsp file?
																							// using sightings.jsp as
																							// temporary test
			dispatcher.forward(request, response);
		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
	}

	public void destroy() {
	}
}