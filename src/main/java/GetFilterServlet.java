import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import com.example.User;

@WebServlet("/GetFilterServlet")
public class GetFilterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public GetFilterServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"User not logged in\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"error\": \"User not logged in\"}");
            return;
        }

        int userId = user.getUserId();
        String databaseUser = "root";
        String databasePassword = System.getenv("DB_PASSWORD");
        String dbUrl = "jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false";
        List<String> plantNames = new ArrayList<>();

        try (Connection con = DriverManager.getConnection(dbUrl, databaseUser, databasePassword)) {
            // Get active filter_ids for the user
            String userFilterQuery = "SELECT filter_id FROM user_filter WHERE user_id = ?";
            List<Integer> activeFilterIds = new ArrayList<>();

            try (PreparedStatement userFilterStmt = con.prepareStatement(userFilterQuery)) {
                userFilterStmt.setInt(1, userId);
                try (ResultSet rs = userFilterStmt.executeQuery()) {
                    while (rs.next()) {
                        int filterId = rs.getInt("filter_id");

                        // Check if the filter is active
                        String filterQuery = "SELECT active FROM Filter WHERE filter_id = ?";
                        try (PreparedStatement filterStmt = con.prepareStatement(filterQuery)) {
                            filterStmt.setInt(1, filterId);
                            try (ResultSet filterRs = filterStmt.executeQuery()) {
                                if (filterRs.next() && filterRs.getBoolean("active")) {
                                    activeFilterIds.add(filterId);
                                }
                            }
                        }
                    }
                }
            }

            // Get plant_ids from the active filters
            List<Integer> plantIds = new ArrayList<>();
            if (!activeFilterIds.isEmpty()) {
                String withinQuery = "SELECT plant_id FROM Within WHERE filter_id = ?";
                try (PreparedStatement withinStmt = con.prepareStatement(withinQuery)) {
                    for (int filterId : activeFilterIds) {
                        withinStmt.setInt(1, filterId);
                        try (ResultSet rs = withinStmt.executeQuery()) {
                            while (rs.next()) {
                                plantIds.add(rs.getInt("plant_id"));
                            }
                        }
                    }
                }
            }

            // Get plant names from plant_ids
            if (!plantIds.isEmpty()) {
                String plantQuery = "SELECT name FROM Plant WHERE plant_id = ?";
                try (PreparedStatement plantStmt = con.prepareStatement(plantQuery)) {
                    for (int plantId : plantIds) {
                        plantStmt.setInt(1, plantId);
                        try (ResultSet rs = plantStmt.executeQuery()) {
                            if (rs.next()) {
                                plantNames.add(rs.getString("name"));
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"error\": \"Database error occurred\"}");
            return;
        }

        // Convert plant names list to JSON and write to response
        String jsonResponse = new Gson().toJson(plantNames);
        out.write(jsonResponse);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
