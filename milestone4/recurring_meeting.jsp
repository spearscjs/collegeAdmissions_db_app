<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<%@page import="java.io.*, java.util.Date, java.util.Enumeration" %> 
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
									"INSERT INTO recurring_meeting(course_number, section_id, meeting_day, start_time, room, meeting_type) " +
											"VALUES (?, ?, ?, ?, ?, ?)");

							pstmt_faculty.setString(1, request.getParameter("course_number"));
							pstmt_faculty.setString(2, request.getParameter("section_id"));
							pstmt_faculty.setString(3, request.getParameter("meeting_day"));
							pstmt_faculty.setTime(4, java.sql.Time.valueOf(request.getParameter("start_time")));
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
						%><h2><%=e.getMessage()%></h2><%	
						conn.setAutoCommit(true);
						System.out.println(e);
					}
					

					Statement stmt = conn.createStatement();

					String sql = "SELECT * FROM recurring_meeting ORDER BY course_number, section_id";
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
							<form action="recurring_meeting.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="section_id" required></th>
								<th><input value="" name="meeting_day" required></th>
								<th><input value="" name="start_time" required></th>
								<th><input value="" name="room" required></th>
								<th>
									<select name="meeting_type" id="meeting_type">
										<option value="Lec">Lecture</option>
										<option value="Dis">Discussion</option>
										<option value="Lab">Lab</option>
									</select>
								</th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("course_number")%></td><%
						%><td><%= rs.getString("section_id")%></td><%
						%><td><%= rs.getString("meeting_day")%></td><%
						%><td><%= rs.getString("start_time")%></td><%
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
