package addFilter;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.example.User;

public class FilterDao {
	private String dburl = "jdbc:mysql://localhost:3306/myflorabase";
	private String dbuname = "root";
	private String dbpwd = System.getenv("DB_PASSWORD");
	private String dbdriver = "com.mysql.jdbc.Driver";

	public void loadDriver(String dbdriver) {
		try {
			Class.forName(dbdriver);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	public Connection getConnection() {
		Connection con = null;
		try {

			con = DriverManager.getConnection(dburl, dbuname, dbpwd);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return con;
	}

	public boolean checkForExistingFilterName(User curUser, String filterName) {
		loadDriver(dbdriver);
		Connection con = getConnection();

		String s = "SELECT * FROM myflorabase.user_filter uf, myflorabase.filter f WHERE user_id ='" + curUser.getUserId() +  "' AND uf.filter_id = f.filter_id AND filter_name ='"+ filterName+"';";
		try {
			PreparedStatement ps = con.prepareStatement(s);
			ResultSet resultSet = ps.executeQuery();
			if (resultSet.isBeforeFirst()) {
				return false;
			}

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}


}
