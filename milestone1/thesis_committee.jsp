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

					// ACTION LISTENER
					try {
						if (action != null && action.equals("insert")) {
							// Begin transaction
							conn.setAutoCommit(false);

							// Create the prepared statement and use it to
							// INSERT the course attributes INTO the course table.
							PreparedStatement pstmt_course = conn.prepareStatement(
									"INSERT INTO thesis_committee(student_id, faculty_id) " +
											"VALUES (?, ?)");

							pstmt_course.setString(1, request.getParameter("student_id"));
							pstmt_course.setString(2, request.getParameter("faculty_id"));
							int rowCount = pstmt_course.executeUpdate();

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

					String sql = "SELECT * FROM thesis_committee";
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
							<form action="thesis_committee.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="student_id" required></th>
								<th><input value="" name="faculty_id" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("student_id")%></td><%
						%><td><%= rs.getString("faculty_id")%></td><%
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
