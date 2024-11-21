
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.example.Plant;
import com.google.gson.Gson;

@WebServlet("/searchPlants")
public class SearchPlantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("query");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String dbUrl = "jdbc:mysql://localhost:3306/myFlorabase?autoReconnect=true&useSSL=false";
        String dbUser = "root";
        String dbPassword = System.getenv("DB_PASSWORD");

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            String sql = "SELECT plant_id, name, scientific_name, poisonous, invasive, endangered FROM Plant WHERE name LIKE ? OR scientific_name LIKE ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, "%" + query + "%");
            stmt.setString(2, "%" + query + "%");

            ResultSet rs = stmt.executeQuery();
            ArrayList<Plant> plants = new ArrayList<>();
            while (rs.next()) {
                Plant plant = new Plant(
                    rs.getInt("plant_id"),
                    rs.getString("name"),
                    rs.getString("scientific_name"),
                    sql, rs.getBoolean("poisonous"),
                    rs.getBoolean("invasive"),
                    rs.getBoolean("endangered")
                );
                plants.add(plant);
            }

            String json = new Gson().toJson(plants);
            out.print(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
