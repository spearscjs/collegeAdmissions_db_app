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

					try {
						if (action != null && action.equals("insert")) {
							// Begin transaction
							conn.setAutoCommit(false);

							// Create the prepared statement and use it to
							// INSERT the course attributes INTO the course table.
							PreparedStatement pstmt_course = conn.prepareStatement(
									"INSERT INTO degree(degree_id, degree_type, department, " +
											"lower_div_units_required, upper_div_units_required, " +
											"tech_elective_unit, grad_units_in_major, min_avg_grade) " +
											"VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

							pstmt_course.setString(1, request.getParameter("degree_id"));
							pstmt_course.setString(2, request.getParameter("degree_type"));
							pstmt_course.setString(3, request.getParameter("department"));
							pstmt_course.setInt(4, Integer.parseInt(request.getParameter("lower_div_units_required")));
							pstmt_course.setInt(5, Integer.parseInt(request.getParameter("upper_div_units_required")));
							pstmt_course.setInt(6, Integer.parseInt(request.getParameter("tech_elective_unit")));
							pstmt_course.setInt(7, Integer.parseInt(request.getParameter("grad_units_in_major")));
							pstmt_course.setFloat(8, Float.parseFloat(request.getParameter("min_avg_grade")));
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

					String sql = "SELECT * FROM degree";
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
							<form action="degree.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="degree_id" required></th>
								<th><input value="" name="degree_type" required></th>
								<th><input value="" name="department" required></th>
								<th><input value="" name="lower_div_units_required" required></th>
								<th><input value="" name="upper_div_units_required" required></th>
								<th><input value="" name="tech_elective_unit" required></th>
								<th><input value="" name="grad_units_in_major" required></th>
								<th><input value="" name="min_avg_grade" required></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
                            %><td><%= rs.getString("degree_id")%></td><%
                            %><td><%= rs.getString("degree_type")%></td><%
                            %><td><%= rs.getString("department")%></td><%
                            %><td><%= rs.getInt("lower_div_units_required")%></td><%
                            %><td><%= rs.getInt("upper_div_units_required")%></td><%
							%><td><%= rs.getInt("tech_elective_unit")%></td><%
							%><td><%= rs.getInt("grad_units_in_major")%></td><%
                            %><td><%= rs.getFloat("min_avg_grade")%></td><%
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
