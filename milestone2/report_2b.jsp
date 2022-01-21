<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Schedule Report2b</title>
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
                    <form action="report_2b.jsp" method="get">
                        <input type="hidden" value="select" name="action">

                        <select name="section_id">
                            <option value="">choose course number and section id</option>
                            <%
                                Statement stmt = conn.createStatement();
                                String sql = "SELECT course_number, section_id FROM class WHERE class.season = 'spring' AND class.active_year = 2021;";
                                ResultSet rs = stmt.executeQuery(sql);
                                while(rs.next()) {
                            %><option value='<%=rs.getString("section_id")%>'><%= rs.getString("course_number") + " " + rs.getString("section_id")%></option><%
                            }
                        %>
                        </select>

                        <th><input type="submit" value="Get Report"></th>
                    </form>

                <%
                // EVENT LISTENER **************************
                if (action != null && action.equals("select")) {

                    // 2 ***************************************************
                    %><h2>Available Time</h2><%
                   
                    // CREATE VIEW 
                    stmt = conn.createStatement();
                    sql = "drop view if exists day_time_converted;\n" +
                            "drop view if exists day_and_time;\n" +
                            "drop view if exists courses_taking;\n" +
                            "drop view if exists students_enrolled;\n" +
                            "\n" +
                            "create view students_enrolled as\n" +
                            "select student_id \n" +
                            "from enrollment \n" +
                            "where section_id = '" +
                            request.getParameter("section_id") +
                            "';\n" +
                            "create view courses_taking as\n" +
                            "select distinct course_number, section_id\n" +
                            "from enrollment, students_enrolled\n" +
                            "where enrollment.student_id = students_enrolled.student_id;\n" +
                            "\n" +
                            "create view day_and_time as\n" +
                            "select distinct meeting_day, start_time \n" +
                            "from recurring_meeting a, courses_taking b\n" +
                            "where a.course_number = b.course_number\n" +
                            "and a.section_id = b.section_id;\n" +
                            "\n" +
                            "create view day_time_converted as\n" +
                            "select distinct b.day, a.start_time\n" +
                            "from day_and_time a, day_abv_conversion b\n" +
                            "where a.meeting_day = b.abbreviation;";
                    stmt.execute(sql);

                    // GET CONFLICTS
                    stmt = conn.createStatement();
                    sql = " select distinct a.month, a.date, a.day, a.start_time, a.end_time\n" +
                            "from review_day a, day_time_converted b\n" +
                            "where (a.day, a.start_time) not in\n" +
                            "(\n" +
                            "select a.day, a.start_time\n" +
                            "from review_day a, day_time_converted b\n" +
                            "where a.day = b.day\n" +
                            "and a.start_time = b.start_time\n" +
                            ")\n" +
                            "order by a.month, a.date, a.start_time;";
                    rs = stmt.executeQuery(sql);
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
                            %><td><%= rs.getString("month")%></td><%
                            %><td><%= rs.getString("date")%></td><%
                            %><td><%= rs.getString("day")%></td><%
                            %><td><%= rs.getString("start_time")%></td><%
                            %><td><%= rs.getString("end_time")%></td><%
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