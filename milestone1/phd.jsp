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
			<li><a href="student.jsp">student</a></li>
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
							// INSERT the phd attributes INTO the phd table.
							// also insert some main attributes to student table.
							PreparedStatement pstmt_student = conn.prepareStatement(
									"INSERT INTO student(student_id, first_name, middle_name, last_name, ssn, is_enrolled, residency) " +
											"VALUES (?, ?, ?, ?, ?, ?, ?)");

							pstmt_student.setString(1, request.getParameter("student_id"));
							pstmt_student.setString(2, request.getParameter("first_name"));
							pstmt_student.setString(3, request.getParameter("middle_name"));
							pstmt_student.setString(4, request.getParameter("last_name"));
							pstmt_student.setString(5, request.getParameter("ssn"));
							pstmt_student.setInt(6, Integer.parseInt(request.getParameter("is_enrolled")));
							pstmt_student.setString(7, request.getParameter("residency"));
							pstmt_student.executeUpdate();

							//update graduate table
							PreparedStatement pstmt_graduate = conn.prepareStatement(
									"INSERT INTO graduate(student_id, department) " +
											"VALUES (?, ?)");

							pstmt_graduate.setString(1, request.getParameter("student_id"));
							pstmt_graduate.setString(2, request.getParameter("department"));
							pstmt_graduate.executeUpdate();

							//update phd table
							PreparedStatement pstmt_phd = conn.prepareStatement(
									"INSERT INTO phd(student_id, is_candidate, advisor_id) " +
											"VALUES (?, ? , ?)");

							pstmt_phd.setString(1, request.getParameter("student_id"));
							pstmt_phd.setInt(2, Integer.parseInt(request.getParameter("is_candidate")));
							pstmt_phd.setString(3, request.getParameter("advisor_id"));
							pstmt_phd.executeUpdate();

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
					
					String sql ="SELECT student.student_id,first_name,middle_name, last_name, ssn, " +
							"is_enrolled, residency, department, is_candidate, advisor_id " +
							"FROM student INNER JOIN graduate ON student.student_id = graduate.student_id " +
							"INNER JOIN phd ON graduate.student_id = phd.student_id;";

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
							<form action="phd.jsp" method="get">
								<input type="hidden" value="insert" name="action">
								<th><input value="" name="student_id" required></th>
								<th><input value="" name="first_name" required></th>
								<th><input value="" name="middle_name"></th>
								<th><input value="" name="last_name" required></th>
								<th><input value="" name="ssn" required></th>
								<th><input value="" name="is_enrolled" required></th>
								<th><input value="" name="residency" required></th>
								<th><input value="" name="department" required></th>
								<th><input value="" name="is_candidate" required></th>
								<th><input value="" name="advisor_id"></th>
								<th><input type="submit" value="Insert"></th>
							</form>
						</tr>
					<%

					// fill values
					while(rs.next()) {
						%><tr><%
						%><td><%= rs.getString("student_id")%></td><%
						%><td><%= rs.getString("first_name")%></td><%
						%><td><%= rs.getString("middle_name")%></td><%
						%><td><%= rs.getString("last_name")%></td><%
						%><td><%= rs.getInt("ssn")%></td><%
						%><td><%= rs.getInt("is_enrolled")%></td><%
						%><td><%= rs.getString("residency")%></td><%
						%><td><%= rs.getString("department")%></td><%
						%><td><%= rs.getInt("is_candidate")%></td><%
						%><td><%= rs.getString("advisor_id")%></td><%
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