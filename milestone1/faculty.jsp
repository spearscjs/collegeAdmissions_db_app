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
		h2 {
			color: red;
		}
	</style>
</head>


<body>
		<ul>	
			<li><a href="index.html">home</a></li>
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
					String action = request.getParameter("action");
					// Check if an insertion is requested
					try {
						if (action != null && action.equals("insert")) {
							// Begin transaction
							conn.setAutoCommit(false);

							// Create the prepared statement and use it to
							// INSERT the faculty attributes INTO the faculty table.
							PreparedStatement pstmt_faculty = conn.prepareStatement(
									"INSERT INTO faculty(faculty_id, first_name, middle_name, last_name, title, department) " +
											"VALUES (?, ?, ?, ?, ?, ?)");

							pstmt_faculty.setString(1, request.getParameter("faculty_id"));
							pstmt_faculty.setString(2, request.getParameter("first_name"));
							pstmt_faculty.setString(3, request.getParameter("middle_name"));
							pstmt_faculty.setString(4, request.getParameter("last_name"));
							pstmt_faculty.setString(5, request.getParameter("title"));
							pstmt_faculty.setString(6, request.getParameter("department"));
							pstmt_faculty.executeUpdate();

							// Commit transaction
							conn.commit();
							conn.setAutoCommit(true);
						}
						
					}
					catch(Exception e) {
						conn.rollback();
						%><h2><%=e%></h2><%	
						conn.setAutoCommit(true);
						System.out.println(e);
					}

					

					Statement stmt = conn.createStatement();
					
					String sql ="SELECT * FROM faculty;";

					ResultSet rs = stmt.executeQuery(sql);
					ResultSetMetaData md = rs.getMetaData();

					// add column name headers
					%><tr><%
					for(int i = 1; i <= md.getColumnCount(); i++) {
						%><th><%=md.getColumnName(i)%></th><%
					}
					%></tr><%

                    // add insert form
					%>
						<tr>
							<form action="faculty.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="faculty_id" required></th>
								<th><input value="" name="first_name" required></th>
								<th><input value="" name="middle_name"></th>
								<th><input value="" name="last_name" required></th>
								<th><input value="" name="title" required></th>
								<th><input value="" name="department" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("faculty_id")%></td><%
						%><td><%= rs.getString("first_name")%></td><%
						%><td><%= rs.getString("middle_name")%></td><%
						%><td><%= rs.getString("last_name")%></td><%
						%><td><%= rs.getString("title")%></td><%
						%><td><%= rs.getString("department")%></td><%
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