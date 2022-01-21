<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Report1e</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>

    <h1>MS Student Report</h1>

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
                    <form action="report_1e.jsp" method="get"> 
                        <input type="hidden" value="select" name="action">
                        <select name="ssn">
                            <option value="">choose student</option>
                            <%
					            Statement stmt = conn.createStatement();
                                String sql = "SELECT * FROM master INNER JOIN student ON master.student_id = student.student_id";
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
                                sql = "SELECT * FROM degree WHERE degree_type = 'M.S.';";
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


                    // Display degree ***************************************************
                    %><h2>Degree</h2><%
                    // create statement
                    PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT * FROM degree WHERE degree_id = ? ");
                    pstmt.setString(1, request.getParameter("degree_id"));
                    String degree_id = request.getParameter("degree_id");
                    // execute statement
                    rs = pstmt.executeQuery();
                    ResultSetMetaData md = rs.getMetaData();

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


                    // Completed Concentrations ***************************************************
                    %><h2>Completed Concentrations</h2><%
                    pstmt = conn.prepareStatement(
                           "SELECT * FROM student WHERE ssn = ?"
                    );
                    pstmt.setString(1, request.getParameter("ssn"));
                    // execute statement
                    rs = pstmt.executeQuery();
                    String student_id = "";
                    while(rs.next()) {
                        student_id = rs.getString("student_id");
                    }

                    String query = "(SELECT concentration FROM degree_concentration INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number INNER JOIN course ON course.course_number = coursework.course_number INNER JOIN grade_conversion ON grade_conversion.letter_grade = coursework.grade WHERE student_id = ? AND degree_id = ?  GROUP BY (concentration) HAVING ROUND(AVG(number_grade), 2) >= MAX(min_gpa)) INTERSECT ( SELECT concentration FROM degree_concentration WHERE degree_id = ?  EXCEPT SELECT concentration FROM ( SELECT concentration, course_number FROM degree_concentration WHERE degree_id = ?  EXCEPT SELECT concentration, coursework.course_number FROM degree_concentration INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number WHERE (grade < 'F' OR grade = 'P') AND student_id = ? AND degree_id = ?) incomplete)";
                           
                    System.out.println(query);
                    pstmt = conn.prepareStatement(
                           query
                    );
                            
                    pstmt.setString(1, student_id);
                    pstmt.setString(2, degree_id);
                    pstmt.setString(3, degree_id);
                    pstmt.setString(4, degree_id);
                    pstmt.setString(5, student_id);
                    pstmt.setString(6, degree_id);
                    
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
                        %><td><%= rs.getString("concentration")%></td><%
                        %></tr><%
                    }
                    %></table><%







                    // Failed Concentration  ***************************************************    
                    %><h2>Failed GPA Concentrations</h2><%
                    // create statement
                    System.out.println(degree_id);
                    query = "SELECT t1.concentration, t2.course_number, t2.next_offering FROM( SELECT concentration FROM degree_concentration INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number INNER JOIN course ON course.course_number = coursework.course_number INNER JOIN grade_conversion ON grade_conversion.letter_grade = coursework.grade WHERE student_id = ? AND degree_id = ?  GROUP BY (concentration) HAVING ROUND(AVG(number_grade), 2) < MAX(min_gpa)) t1 LEFT JOIN( SELECT needed.course_number, concentration, next_offering FROM ( SELECT coursework.course_number, concentration FROM coursework, degree_concentration WHERE student_id = ? AND coursework.course_number = degree_concentration.course_number) needed INNER JOIN( SELECT course_number, MIN(CONCAT(CONCAT(active_year, ' '), season)) AS next_offering FROM class WHERE active_year > 2021 OR (active_year = 2021 AND season > 'spring') GROUP BY course_number) schedule ON needed.course_number = schedule.course_number) t2 ON (t1.concentration = t2.concentration)";
                    System.out.println(query);
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, student_id);
                    pstmt.setString(2, degree_id);
                    pstmt.setString(3, student_id);
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
                            %><td><%= rs.getString("concentration")%></td><%
                            %><td><%= rs.getString("course_number")%></td><%
                            %><td><%= rs.getString("next_offering")%></td><%
                        %></tr><%
                    }
                    %></table><%



















query = "SELECT t1.concentration, t2.course_number, t2.next_offering FROM( SELECT concentration FROM degree_concentration INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number INNER JOIN course ON course.course_number = coursework.course_number INNER JOIN grade_conversion ON grade_conversion.letter_grade = coursework.grade WHERE student_id = ? AND degree_id = ?  GROUP BY (concentration) HAVING ROUND(AVG(number_grade), 2) < MAX(min_gpa)) t1 LEFT JOIN( SELECT needed.course_number, concentration, next_offering FROM ( SELECT coursework.course_number, concentration FROM coursework, degree_concentration WHERE student_id = ? AND coursework.course_number = degree_concentration.course_number) needed INNER JOIN( SELECT course_number, MIN(CONCAT(CONCAT(active_year, ' '), season)) AS next_offering FROM class WHERE active_year > 2021 OR (active_year = 2021 AND season > 'spring') GROUP BY course_number) schedule ON needed.course_number = schedule.course_number) t2 ON (t1.concentration = t2.concentration)";





                    // Needed Concentration  ***************************************************
                    %><h2>Needed Concentrations</h2><%
                    // create statement
                    System.out.println(degree_id);
                    query = " SELECT needed.concentration, needed.course_number, schedule.next_offering FROM ( (SELECT * FROM ( SELECT concentration, course_number FROM degree_concentration WHERE degree_id = ?  EXCEPT SELECT concentration, coursework.course_number FROM degree_concentration INNER JOIN coursework ON degree_concentration.course_number = coursework.course_number WHERE (grade < 'F' OR grade = 'P') AND student_id = ? AND degree_id = ?) incomplete)) needed LEFT JOIN( SELECT course_number, MIN(CONCAT(CONCAT(active_year, ' '), season)) AS next_offering FROM class WHERE active_year > 2021 OR (active_year = 2021 AND season > 'spring') GROUP BY course_number) schedule ON (needed.course_number = schedule.course_number) " ;
                    System.out.println(query);
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, degree_id);
                    pstmt.setString(2, student_id);
                    pstmt.setString(3, degree_id);
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
                            %><td><%= rs.getString("concentration")%></td><%
                            %><td><%= rs.getString("course_number")%></td><%
                            %><td><%= rs.getString("next_offering")%></td><%
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
