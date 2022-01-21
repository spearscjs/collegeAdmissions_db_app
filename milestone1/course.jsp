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
							// INSERT the course attributes INTO the course table.
							PreparedStatement pstmt_course = conn.prepareStatement(
									"INSERT INTO course(course_number, course_name, division, instructor_consent, lab_required, number_of_units, grade_option, department) " +
											"VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

							pstmt_course.setString(1, request.getParameter("course_number"));
							pstmt_course.setString(2, request.getParameter("course_name"));
							pstmt_course.setString(3, request.getParameter("division"));
							pstmt_course.setInt(4, Integer.parseInt(request.getParameter("instructor_consent")));
							pstmt_course.setInt(5, Integer.parseInt(request.getParameter("lab_required")));
							pstmt_course.setInt(6, Integer.parseInt(request.getParameter("number_of_units")));
							pstmt_course.setString(7, request.getParameter("grade_option"));
							pstmt_course.setString(8, request.getParameter("department"));
							pstmt_course.executeUpdate();

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

					String sql = "SELECT * FROM course";
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
							<form action="course.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="course_name" required></th>
								<th><input value="" name="division" required></th>
								<th><input value="" name="instructor_consent" required></th>
								<th><input value="" name="lab_required" required></th>
								<th><input value="" name="number_of_units" required></th>
								<th><input value="" name="grade_option" required></th>
								<th><input value="" name="department" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("course_number")%></td><%
						%><td><%= rs.getString("course_name")%></td><%
						%><td><%= rs.getString("division")%></td><%
						%><td><%= rs.getInt("instructor_consent")%></td><%
						%><td><%= rs.getInt("lab_required")%></td><%
						%><td><%= rs.getInt("number_of_units")%></td><%
						%><td><%= rs.getString("grade_option")%></td><%
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