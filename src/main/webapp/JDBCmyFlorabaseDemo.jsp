<%@ page import="java.sql.*"%>
<html>
<head>
  <title>Three Tier Architecture Demo</title>
</head>
<body>
<h1>JDBC Connection Example</h1>

<table border="1">
  <tr>
    <td>Uname</td>
    <td>Email</td>
    <td>Phone</td>
  </tr>
    <%
        String user; // assumes database name is the same as username
          user = "root";
        String password = ""; 
        try {
            java.sql.Connection con;
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/?autoReconnect=true&useSSL=false",user, password);
            out.println(" database successfully opened.<br/><br/>");

            Statement statement = con.createStatement();


            statement.executeUpdate("DROP SCHEMA IF EXISTS myFlorabase");
            statement.executeUpdate("CREATE SCHEMA myFlorabase");
            statement.executeUpdate("USE myFlorabase");
            String createMemberTable = "CREATE TABLE `Member` (`uname` varchar(30) NOT NULL, `password` varchar(45) DEFAULT NULL, `email` varchar(45) DEFAULT NULL, `phone` varchar(45) DEFAULT NULL, PRIMARY KEY (`uname`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci";
            statement.executeUpdate("DROP TABLE IF EXISTS Member");
            statement.executeUpdate(createMemberTable);

            statement.executeUpdate("INSERT INTO `myflorabase`.`member` (`uname`, `password`, `email`, `phone`) VALUES ('mike', 'hello', 'mike@email.com', '123-456-7890');");

            out.println("Initial entries in table \"myFlorabase\": <br/>");

            ResultSet rs = statement.executeQuery("SELECT * FROM Member");
            while (rs.next()) {
         out.println("<tr>" + "<td>" +  rs.getString(1) + "</td>"+ "<td>" +    rs.getString(3) + "</td>"+   "<td>" + rs.getString(4) + "</td>"  + "</tr>");
            }
            rs.close();
            statement.close();
            con.close();
        } catch(SQLException e) {
            out.println("SQLException caught: " + e.getMessage());
        }
    %>
</body>
</html>