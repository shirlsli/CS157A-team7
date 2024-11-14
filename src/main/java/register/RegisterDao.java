package register;
import com.example.*;


import java.sql.*;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;

public class RegisterDao {
    private String dburl="jdbc:mysql://localhost:3306/myflorabase";
    private String dbuname="root";
    private String dbpwd=System.getenv("DB_PASSWORD");
    private String dbdriver="com.mysql.jdbc.Driver";
    public void loadDriver(String dbdriver){
        try {
            Class.forName(dbdriver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection(){
        Connection con=null;
        try {
        	
            con = DriverManager.getConnection(dburl, dbuname,dbpwd);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    public boolean insert(User user){
        loadDriver(dbdriver);
        Connection con=getConnection();
        boolean result=true;


        String s = "SELECT * FROM myflorabase.user WHERE username = '" + user.getUsername() + "'";
        try{
            PreparedStatement ps = con.prepareStatement(s);
            ResultSet resultSet = ps.executeQuery();
            if (resultSet.isBeforeFirst() ) {
                return false;
            }


        } catch (SQLException e){
            e.printStackTrace();
            return false;
        }

        String sql="insert into myflorabase.user(username, password, description, isAdmin) values(?,?,?,?)";
        try {
            PreparedStatement ps=con.prepareStatement(sql);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getDescription());
            ps.setBoolean(4, user.isAdmin());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            result=false;
        }

        return result;
    }
    
    public boolean checkFor(String username) {
    	loadDriver(dbdriver);
        Connection con=getConnection();


        String s = "SELECT * FROM myflorabase.user WHERE username = '" + username + "'";
        try{
            PreparedStatement ps = con.prepareStatement(s);
            ResultSet resultSet = ps.executeQuery();
            if (resultSet.isBeforeFirst() ) {
                return false;
            }

        } catch (SQLException e){
            e.printStackTrace();
            return false;
        }
        return true;
    }
}
