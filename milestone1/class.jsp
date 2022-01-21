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
				String username = "postgres";
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
							// INSERT the class attributes INTO the class table.
							PreparedStatement pstmt_class = conn.prepareStatement(
									"INSERT INTO class(course_number, section_id, title, season, " +
											"active_year, faculty_id, enrollment_limit, mandatory_discussion) " +
											"VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

							pstmt_class.setString(1, request.getParameter("course_number"));
							pstmt_class.setString(2, request.getParameter("section_id"));
							pstmt_class.setString(3, request.getParameter("title"));
							pstmt_class.setString(4, request.getParameter("season"));
							pstmt_class.setInt(5, Integer.parseInt(request.getParameter("active_year")));
							pstmt_class.setString(6, request.getParameter("faculty_id"));
							pstmt_class.setInt(7, Integer.parseInt(request.getParameter("enrollment_limit")));
							pstmt_class.setInt(8, Integer.parseInt(request.getParameter("mandatory_discussion")));
							pstmt_class.executeUpdate();

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

					String sql = "SELECT * FROM class";
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
							<form action="class.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="section_id" required></th>
								<th><input value="" name="title" required></th>
								<th><input value="" name="season" required></th>
								<th><input value="" name="active_year" required></th>
								<th><input value="" name="faculty_id" required></th>
								<th><input value="" name="enrollment_limit" required></th>
								<th><input value="" name="mandatory_discussion" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("course_number")%></td><%
						%><td><%= rs.getString("section_id")%></td><%
						%><td><%= rs.getString("title")%></td><%
						%><td><%= rs.getString("season")%></td><%
						%><td><%= rs.getInt("active_year")%></td><%
						%><td><%= rs.getString("faculty_id")%></td><%
						%><td><%= rs.getInt("enrollment_limit")%></td><%
						%><td><%= rs.getInt("mandatory_discussion")%></td><%
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
