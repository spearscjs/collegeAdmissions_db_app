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
			<li><a href="report_5.jsp">grade distribution query</a></li>
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
							// INSERT the coursework attributes INTO the coursework table.
							PreparedStatement pstmt_coursework = conn.prepareStatement(
									"INSERT INTO coursework(student_id, course_number, section_id, grade) " +
											"VALUES (?, ?, ?, ?)");

							pstmt_coursework.setString(1, request.getParameter("student_id"));
							pstmt_coursework.setString(2, request.getParameter("course_number"));
							pstmt_coursework.setString(3, request.getParameter("section_id"));
							pstmt_coursework.setString(4, request.getParameter("grade"));
							pstmt_coursework.executeUpdate();

							// Commit transaction
							conn.commit();
							conn.setAutoCommit(true);
						}
						else if (action != null && action.equals("delete")) {

							// Begin transaction
							conn.setAutoCommit(false);

							// Create the prepared statement and use it to
							// INSERT the coursework attributes INTO the coursework table.
							PreparedStatement pstmt_coursework = conn.prepareStatement(
									"DELETE FROM coursework WHERE student_id = ? AND course_number = ? AND section_id = ? AND grade = ?;");

							pstmt_coursework.setString(1, request.getParameter("student_id"));
							pstmt_coursework.setString(2, request.getParameter("course_number"));
							pstmt_coursework.setString(3, request.getParameter("section_id"));
							pstmt_coursework.setString(4, request.getParameter("grade"));
							pstmt_coursework.executeUpdate();

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

					String sql = "SELECT * FROM coursework";
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
							<form action="coursework.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="student_id" required></th>
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="section_id" required></th>
								<th><input value="" name="grade" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// add delete form
					%>
						<tr>
							<form action="coursework.jsp" method="get">
								<input type="hidden" value="delete" name="action">
								<th><input value="" name="student_id" required></th>
								<th><input value="" name="course_number" required></th>
								<th><input value="" name="section_id" required></th>
								<th><input value="" name="grade" required></th>
								<th><input type="submit" value="Delete"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
                            %><td><%= rs.getString("student_id")%></td><%
                            %><td><%= rs.getString("course_number")%></td><%
                            %><td><%= rs.getString("section_id")%></td><%
                            %><td><%= rs.getString("grade")%></td><%
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
