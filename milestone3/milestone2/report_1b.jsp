<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Report1b</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>

    <h1>Class Report</h1>

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
                    <form action="report_1b.jsp" method="get"> 
                        <input type="hidden" value="select" name="action">
                        <select name="title">
                            <option value="">choose class's title</option>
                            <%
					            Statement stmt = conn.createStatement();
                                String sql = "SELECT DISTINCT title, course_number FROM class";
                                ResultSet rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%=rs.getString("title")%>'><%=rs.getString("course_number") + " : " + rs.getString("title")%></option><%
                                }
                            %>
                        </select>
                        <th><input type="submit" value="Get Report"></th>
                    </form>
                    <%
                // EVENT LISTENER **************************
                if (action != null && action.equals("select")) {
                    // 1 ***************************************************
                    %><h2>Class</h2><%
                    // create statement
                    PreparedStatement pstmt = conn.prepareStatement(
                            "SELECT course_number, season, active_year FROM class WHERE title = ?");
                    pstmt.setString(1, request.getParameter("title"));
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
                            %><td><%= rs.getString("course_number")%></td><%
                            %><td><%= rs.getString("season")%></td><%
                            %><td><%= rs.getString("active_year")%></td><%
                        %></tr><%
                    }
                    %></table><%
                    // 2 ***************************************************
                    %><h2>Enrollment</h2><%
                    pstmt = conn.prepareStatement(
                            "SELECT student.*, course.number_of_units, enrollment.grade_option FROM enrollment INNER JOIN class ON enrollment.course_number = class.course_number AND enrollment.section_id = class.section_id INNER JOIN student ON enrollment.student_id = student.student_id INNER JOIN course ON class.course_number = course.course_number WHERE class.title = ?");
                            
                    pstmt.setString(1, request.getParameter("title"));
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
                        %><td><%= rs.getString("student_id")%></td><%
						%><td><%= rs.getString("first_name")%></td><%
						%><td><%= rs.getString("middle_name")%></td><%
						%><td><%= rs.getString("last_name")%></td><%
						%><td><%= rs.getInt("ssn")%></td><%
						%><td><%= rs.getInt("is_enrolled")%></td><%
						%><td><%= rs.getString("residency")%></td><%
						%><td><%= rs.getInt("number_of_units")%></td><%
						%><td><%= rs.getString("grade_option")%></td><%
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