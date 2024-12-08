package Filter;
import com.example.*;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/FilterNameCheckServlet")
public class FilterNameCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FilterNameCheckServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession curSession = request.getSession(false);
		User curUser = (User) curSession.getAttribute("user");

		
		String filterName = request.getParameter("filterName").trim();
		String filter_id = request.getParameter("filterId");
		
        FilterDao fDao = new FilterDao();
        boolean isAvailable = fDao.checkForExistingFilterName(curUser, filter_id, filterName);

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.write("{\"available\": " + isAvailable + "}");
        out.flush();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
