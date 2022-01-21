<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>CSE132</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>
		<ul>	
			<li><a href="index.html">home</a></li>
			<li><a href="undergraduate.jsp">undergraduate</a></li>
			<li><a href="fifth_year.jsp">fifth year</a></li>
			<li><a href="master.jsp">master</a></li>
			<li><a href="phd.jsp">phd</a></li>
		</ul>			
		<table>
			<%
				// FILL HTML TABLE **********************************************************************
				Class.forName("org.postgresql.Driver");
				String jdbcURL = "jdbc:postgresql://localhost:5432/cse132";
				String username =  "postgres";
				String password = "admin";	

				try {
					// setup connection 
					Connection conn = DriverManager.getConnection(jdbcURL, username, password);
					System.out.println("Connected to PostgreSQL server");

					// queries 
					Statement stmt = conn.createStatement();
					
					String sql = "SELECT * FROM student;";
                    
					ResultSet rs = stmt.executeQuery(sql);
					ResultSetMetaData md = rs.getMetaData();

					// add column name headers
					%><tr><%
					for(int i = 1; i <= md.getColumnCount(); i++) {
						%><th><%=md.getColumnName(i)%></th><%
					}
					%></tr><%


					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("student_id")%></td><%
						%><td><%= rs.getString("first_name")%></td><%
						%><td><%= rs.getString("middle_name")%></td><%
						%><td><%= rs.getString("last_name")%></td><%
						%><td><%= rs.getInt("ssn")%></td><%
						%><td><%= rs.getInt("is_enrolled")%></td><%
						%><td><%= rs.getString("residency")%></td><%
						%></tr><%
					}
					
				
					conn.close();

					
				}
				catch(SQLException e) {
					System.out.println("Error in connecting to PostgreSQL server");
					System.out.println(e);
				}
			%>
		</table>
		
	
</body>

</html>