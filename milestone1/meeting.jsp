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
							// INSERT the faculty attributes INTO the faculty table.
							PreparedStatement pstmt_faculty = conn.prepareStatement(
									"INSERT INTO meeting(course_number, section_id, scheduled_date, scheduled_time, room, meeting_type) " +
											"VALUES (?, ?, ?, ?, ?, ?)");

							pstmt_faculty.setString(1, request.getParameter("course_number"));
							pstmt_faculty.setString(2, request.getParameter("section_id"));
							pstmt_faculty.setString(3, request.getParameter("scheduled_date"));
							pstmt_faculty.setString(4, request.getParameter("scheduled_time"));
							pstmt_faculty.setString(5, request.getParameter("room"));
							pstmt_faculty.setString(6, request.getParameter("meeting_type"));
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

					String sql = "SELECT * FROM meeting";
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
							<form action="meeting.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="section_id" required></th>
								<th><input value="" name="scheduled_date" required></th>
								<th><input value="" name="scheduled_time" required></th>
								<th><input value="" name="room" required></th>
								<th><input value="" name="meeting_type" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("course_number")%></td><%
						%><td><%= rs.getString("section_id")%></td><%
						%><td><%= rs.getString("scheduled_date")%></td><%
						%><td><%= rs.getString("scheduled_time")%></td><%
						%><td><%= rs.getString("room")%></td><%
						%><td><%= rs.getString("meeting_type")%></td><%
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
