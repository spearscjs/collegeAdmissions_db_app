<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Schedule Report2a</title>
	<style>
		table, th, td {
			border: 1px solid black;
		}
	</style>
</head>


<body>

    <h1>Schedule Report</h1>

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
                    <form action="report_2a.jsp" method="get"> 
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



                    // 2 ***************************************************
                    %><h2>Schedule Conflict</h2><%
                   
                    // CREATE VIEW 
                    stmt = conn.createStatement();
                    sql = "CREATE OR REPLACE VIEW class_info as select enrollment.student_id, recurring_meeting.course_number, recurring_meeting.section_id, recurring_meeting.meeting_day, recurring_meeting.start_time from enrollment inner join recurring_meeting on recurring_meeting.course_number = enrollment.course_number and recurring_meeting.section_id = enrollment.section_id where enrollment.student_id= '" + student_id + "'";
                    stmt.execute(sql);

                    // GET CONFLICTS
                    stmt = conn.createStatement();
                    sql = " select a.course_number, a.section_id, b.course_number as conflict_course_number, b.section_id as conflict_section_id from recurring_meeting a, class_info b where a.section_id != b.section_id and a.course_number != b.course_number and a.meeting_day = b.meeting_day and a.start_time = b.start_time";
                    rs = stmt.executeQuery(sql);
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
                            %><td><%= rs.getString("conflict_course_number")%></td><%
                            %><td><%= rs.getString("conflict_section_id")%></td><%
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