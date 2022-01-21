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
							// INSERT the enrollment attributes INTO the enrollment table.
							PreparedStatement pstmt_enrollment = conn.prepareStatement(
									"INSERT INTO enrollment(student_id, course_number, section_id, grade_option) " +
											"VALUES (?, ?, ?, ?)");

							pstmt_enrollment.setString(1, request.getParameter("student_id"));
							pstmt_enrollment.setString(2, request.getParameter("course_number"));
							pstmt_enrollment.setString(3, request.getParameter("section_id"));
							pstmt_enrollment.setString(4, request.getParameter("grade_option"));
							pstmt_enrollment.executeUpdate();

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

					String sql = "SELECT * FROM enrollment ORDER BY course_number, section_id, student_id";
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
							<form action="enrollment.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="student_id" required></th>
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="section_id" required></th>
								<th><input value="" name="grade_option" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
                            %><td><%= rs.getString("student_id")%></td><%
                            %><td><%= rs.getString("course_number")%></td><%
                            %><td><%= rs.getString("section_id")%></td><%
                            %><td><%= rs.getString("grade_option")%></td><%
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
