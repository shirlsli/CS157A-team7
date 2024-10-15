import java.io.BufferedReader;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addLog")
public class AddLogServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Read the JSON data from the request
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        // Print the received message to the server console
        System.out.println("Received message from client: " + sb.toString());

        // Send a response back to the client
        response.setContentType("text/plain");
        response.getWriter().write("Log received successfully.");
    }
}
