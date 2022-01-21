<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Report1a</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>

    <h1>Student Report</h1>

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
                    <form action="report_1a.jsp" method="get"> 
                        <input type="hidden" value="select" name="action">
                        <select name="ssn">
                            <option value="">choose student</option>
                            <%
					            Statement stmt = conn.createStatement();
                                String sql = "SELECT ssn, first_name, last_name FROM student;";
                                ResultSet rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%=rs.getString("ssn")%>'><%= rs.getString("ssn") + " " + rs.getString("first_name") + " " +  rs.getString("last_name")%></option><%

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
                    %><h2>Enrollment</h2><%
                    pstmt = conn.prepareStatement(
                            "SELECT enrollment.grade_option, course.number_of_units, enrollment.course_number, enrollment.section_id, title, faculty_id, enrollment_limit, mandatory_discussion, season, active_year FROM enrollment INNER JOIN class ON enrollment.course_number = class.course_number AND enrollment.section_id = class.section_id INNER JOIN course ON course.course_number = class.course_number WHERE student_id = ?");
                            
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
                        %><td><%= rs.getString("grade_option")%></td><%
                        %><td><%= rs.getString("number_of_units")%></td><%
                        %><td><%= rs.getString("course_number")%></td><%
                        %><td><%= rs.getString("section_id")%></td><%
                        %><td><%= rs.getString("title")%></td><%
                        %><td><%= rs.getString("faculty_id")%></td><%
                        %><td><%= rs.getString("enrollment_limit")%></td><%
                        %><td><%= rs.getString("mandatory_discussion")%></td><%
                        %><td><%= rs.getString("season")%></td><%
                        %><td><%= rs.getString("active_year")%></td><%
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