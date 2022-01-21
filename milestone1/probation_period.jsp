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
							PreparedStatement pstmt_probation= conn.prepareStatement(
									"INSERT INTO probation_period(student_id, start_season, start_year, end_season, end_year, reason) " +
											"VALUES (?, ?, ?, ?, ?, ?)");

							pstmt_probation.setString(1, request.getParameter("student_id"));
							pstmt_probation.setString(2, request.getParameter("start_season"));
							pstmt_probation.setInt(3, Integer.parseInt(request.getParameter("start_year")));
							pstmt_probation.setString(4, request.getParameter("end_season"));
							pstmt_probation.setInt(5, Integer.parseInt(request.getParameter("end_year")));
							pstmt_probation.setString(6, request.getParameter("reason"));
							pstmt_probation.executeUpdate();

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

					String sql = "SELECT * FROM probation_period";
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
							<form action="probation_period.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="student_id" required></th>
								<th><input value="" name="start_season" required></th>
								<th><input value="" name="start_year" required></th>
								<th><input value="" name="end_season" required></th>
								<th><input value="" name="end_year" required></th>
								<th><input value="" name="reason" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
                            %><td><%= rs.getString("student_id")%></td><%
                            %><td><%= rs.getString("start_season")%></td><%
                            %><td><%= rs.getString("start_year")%></td><%
                            %><td><%= rs.getString("end_season")%></td><%
                            %><td><%= rs.getString("end_year")%></td><%
                            %><td><%= rs.getString("reason")%></td><%
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
