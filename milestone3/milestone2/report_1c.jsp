<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Report1c</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>

    <h1>Grade Report</h1>

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
                    <form action="report_1c.jsp" method="get"> 
                        <input type="hidden" value="select" name="action">
                        <select name="ssn">
                            <option value="">choose student's ssn</option>
                            <%
					            Statement stmt = conn.createStatement();
                                String sql = "SELECT * FROM student;";
                                ResultSet rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%=rs.getString("ssn")%>'><%= rs.getString("ssn") + " " + rs.getString("first_name") + " " + rs.getString("last_name") %></option><%
                                }
                            %>
                        </select>
                        <th><input type="submit" value="Get Report"></th>
                    </form>
                    <%



                // EVENT LISTENER **************************
                if (action != null && action.equals("select")) {


                    // 1 ***************************************************
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


                    // 2 ***************************************************
                    %><h2>Coursework</h2><%
                    pstmt = conn.prepareStatement(
                        "SELECT class.*, coursework.grade, course.number_of_units FROM coursework INNER JOIN class ON coursework.course_number = class.course_number AND coursework.section_id = class.section_id INNER JOIN course ON course.course_number = class.course_number WHERE student_id = ?  ORDER BY (season,active_year)"
                    );
                            
                    pstmt.setString(1, student_id);
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
                        %><td><%= rs.getString("course_number")%></td><%
                        %><td><%= rs.getString("section_id")%></td><%
                        %><td><%= rs.getString("title")%></td><%
                        %><td><%= rs.getString("faculty_id")%></td><%
                        %><td><%= rs.getString("enrollment_limit")%></td><%
                        %><td><%= rs.getString("mandatory_discussion")%></td><%
                        %><td><%= rs.getString("season")%></td><%
                        %><td><%= rs.getString("active_year")%></td><%
                        %><td><%= rs.getString("grade")%></td><%
                        %><td><%= rs.getString("number_of_units")%></td><%
                        %></tr><%
                    }
                    %></table><%


                    // 3 ***************************************************
                    %><h2>Gpa</h2><%
                    pstmt = conn.prepareStatement(
                        "SELECT season, active_year, ROUND(AVG(grade_conversion.number_grade), 2) AS gpa FROM coursework INNER JOIN class ON coursework.course_number = class.course_number AND coursework.section_id = class.section_id INNER JOIN course ON course.course_number = class.course_number INNER JOIN grade_conversion ON grade_conversion.letter_grade = coursework.grade WHERE student_id = ?  GROUP BY (season, active_year)" 
                    );
                            
                    pstmt.setString(1, student_id);
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
                        %><td><%= rs.getString("season")%></td><%
                        %><td><%= rs.getString("active_year")%></td><%
                        %><td><%= rs.getString("gpa")%></td><%
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