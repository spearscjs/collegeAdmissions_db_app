<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Report1d</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>

    <h1>Undergraduate Student Report</h1>

    <ul>	
        <li><a href="index.html">home</a></li>
    </ul>	
    
    




    <%
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


                // CREATE FORM ****************************
                    %>
                    <form action="report_1d.jsp" method="get"> 
                        <input type="hidden" value="select" name="action">
                        <select name="ssn">
                            <option value="">choose student</option>
                            <%
					            Statement stmt = conn.createStatement();
                                String sql = "SELECT * FROM student;";
                                ResultSet rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%= rs.getString("ssn")%>'><%= rs.getString("ssn") + " " + rs.getString("first_name") + " " + rs.getString("last_name") %></option><%
                                }
                            %>
                        </select>
                        <select name="degree_id">
                            <option value="">choose degree</option>
                            <%
					            stmt = conn.createStatement();
                                sql = "SELECT * FROM degree WHERE degree_type = 'B.S.';";
                                rs = stmt.executeQuery(sql);
                                while(rs.next()) {
                                    String a = "asd asd";
						            %><option value='<%= rs.getString("degree_id") %>'> <%=rs.getString("degree_id")%> </option><%
                                }
                            %>
                        </select>
                        <th><input type="submit" value="Get Report"></th>
                    </form>
                    <%



                // EVENT LISTENER **************************
                if (action != null && action.equals("select")) {


                    // Display student **************************************************
                    %><h2>Student</h2><%
                    // create statement
                    PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT student_id, ssn, first_name, middle_name, last_name FROM student WHERE ssn = ?");
                    pstmt.setString(1, request.getParameter("ssn"));
                    // execute statement
                    rs = pstmt.executeQuery();
                    ResultSetMetaData md = rs.getMetaData();

                    %><table><%
                    // add column name headers
                    %><tr><%
                    for(int i = 2; i <= md.getColumnCount(); i++) {
                        %><th><%=md.getColumnName(i)%></th><%
                    }
                    %></tr><%
                    // fill values
                    String student_id = "";
                    while(rs.next()) {
                        %><tr><%
                            %><td><%= rs.getString("ssn")%></td><%
                            %><td><%= rs.getString("first_name")%></td><%
                            %><td><%= rs.getString("middle_name")%></td><%
                            %><td><%= rs.getString("last_name")%></td><%
                            student_id = rs.getString("student_id");

                        %></tr><%
                    }
                    %></table><%

                    // Display degree ***************************************************
                    %><h2>Degree</h2><%
                    // create statement
                    pstmt = conn.prepareStatement(
                            "SELECT * FROM degree WHERE degree_id = ? ");
                    pstmt.setString(1, request.getParameter("degree_id"));
                    // execute statement
                    rs = pstmt.executeQuery();
                    md = rs.getMetaData();

                    %><table><%
                    // add column name headers
                    %><tr><%
                    for(int i = 1; i <= md.getColumnCount(); i++) {
                        %><th><%=md.getColumnName(i)%></th><%
                    }
                    %></tr><%
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
                    %></table><%


                    // 2 ***************************************************
                    %><h2>Remaining Requirements</h2><%
                    pstmt = conn.prepareStatement(
                        " SELECT x.requirement, MIN(units_needed) AS units_needed, MAX(units_taken) AS units_taken FROM ( SELECT * FROM (SELECT 'lower division' AS requirement, SUM(number_of_units) AS units_taken, degree.lower_div_units_required - SUM(number_of_units) AS units_needed FROM coursework INNER JOIN course ON course.course_number = coursework.course_number INNER JOIN degree ON degree.degree_id = ?  WHERE (grade < 'D' OR grade = 'P') AND division = 'lower' AND coursework.student_id = ?  GROUP BY (lower_div_units_required) UNION SELECT 'upper division' AS requirement, SUM(number_of_units) AS units_taken, degree.upper_div_units_required - SUM(number_of_units) AS units_needed FROM coursework INNER JOIN course ON course.course_number = coursework.course_number INNER JOIN degree ON degree.degree_id = ?  WHERE (grade < 'D' OR grade = 'P') AND division = 'upper' AND coursework.student_id = ?  GROUP BY (upper_div_units_required) UNION SELECT 'technical elective' AS requirement, SUM(number_of_units) AS units_taken, degree.tech_elective_unit - SUM(number_of_units) AS units_needed FROM technical_elective INNER JOIN course ON course.course_number = technical_elective.course_number INNER JOIN coursework ON coursework.course_number = course.course_number INNER JOIN degree ON degree.degree_id = ?  WHERE (grade < 'D' OR grade = 'P') AND coursework.student_id = ?  GROUP BY (tech_elective_unit) ) requirements UNION SELECT 'grad units' AS requirement, SUM(number_of_units) AS units_taken, degree.grad_units_in_major - SUM(number_of_units) AS units_needed FROM coursework INNER JOIN course ON course.course_number = coursework.course_number INNER JOIN degree ON degree.degree_id = ?  WHERE (grade < 'D' OR grade = 'P') AND division = 'graduate' AND coursework.student_id = ?  GROUP BY (grad_units_in_major) UNION SELECT'lower division' AS requirement, 0 AS units_taken, lower_div_units_required AS units_needed FROM degree WHERE degree_id = ?  UNION SELECT'upper division' AS requirement, 0 AS units_taken, upper_div_units_required AS units_needed FROM degree WHERE degree_id = ?  UNION SELECT'technical elective' AS requirement, 0 AS units_taken, tech_elective_unit AS units_needed FROM degree WHERE degree_id = ?  UNION SELECT'grad units' AS requirement, 0 AS units_taken, grad_units_in_major AS units_needed FROM degree WHERE degree_id = ?) x GROUP BY (requirement)"
                    );
                    pstmt.setString(1, request.getParameter("degree_id"));
                    pstmt.setString(2, student_id);
                    pstmt.setString(3, request.getParameter("degree_id"));
                    pstmt.setString(4, student_id);
                    pstmt.setString(5, request.getParameter("degree_id"));
                    pstmt.setString(6, student_id);
                    pstmt.setString(7, request.getParameter("degree_id"));
                    pstmt.setString(8, student_id);
                    pstmt.setString(9, request.getParameter("degree_id"));
                    pstmt.setString(10, request.getParameter("degree_id"));
                    pstmt.setString(11, request.getParameter("degree_id"));
                    pstmt.setString(12, request.getParameter("degree_id"));
                    // execute statement
                    rs = pstmt.executeQuery();
                    md = rs.getMetaData();

                    %><table><%
                    // add column name headers
                    %><tr><%
                    for(int i = 1; i <= md.getColumnCount(); i++) {
                        %><th><%=md.getColumnName(i)%></th><%
                    }
                    %></tr><%
                    // fill values
                    while(rs.next()) {
                        %><tr><%
                        %><td><%= rs.getString("requirement")%></td><%
                        %><td><%= rs.getString("units_taken")%></td><%
                        int units_needed = rs.getInt("units_needed");
                        if(units_needed < 0) units_needed = 0;
                        %><td><%=units_needed%></td><%
                        %></tr><%
                    }
                    %></table><%

                    conn.close();
                }
            }
            catch(Exception e) {
                %><h2><%=e%></h2><%	
                conn.setAutoCommit(true);
                System.out.println(e);
            }


            
        }
        catch(SQLException e) {
            System.out.println("Error in connecting to PostgreSQL server");
            System.out.println(e);
        }
    %>
		
	
</body>

</html>

