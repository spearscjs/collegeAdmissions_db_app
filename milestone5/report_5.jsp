<%@page language="java" contentType="text/html" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Schedule Report5</title>
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
        <li><a href="coursework.jsp">insert student grade</a></li>
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
                    <form action="report_5.jsp" method="get">
                        <input type="hidden" value="select" name="action">
                        <select name="course_number">
                            <option value="">choose course</option>
                             <%
					            Statement stmt = conn.createStatement();
                                String sql = "SELECT course_number, course_name FROM course;";
                                ResultSet rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%=rs.getString("course_number")%>'><%= rs.getString("course_number") + " : " + rs.getString("course_name") %></option><%
                                }
                            %>
                        </select>

                        <select name="faculty_id">
                            <option value="">choose professor</option>
                             <%
					            stmt = conn.createStatement();
                                sql = "SELECT * FROM faculty;";
                                rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%=rs.getString("faculty_id")%>'><%= rs.getString("faculty_id") + " : " + rs.getString("first_name") + " " + rs.getString("last_name") %></option><%
                                }
                            %>
                        </select>

                         <select name="season">
                            <option value="">choose quarter</option>
                             <%
					            stmt = conn.createStatement();
                                sql = "SELECT * FROM season;";
                                rs = stmt.executeQuery(sql);
                                while(rs.next()) {
						            %><option value='<%=rs.getString("season")%>'><%= rs.getString("season") %></option><%
                                }
                            %>
                        </select>

                        <select name="active_year">
                            <option value="">choose year</option>
                                <%
                                stmt = conn.createStatement();
                                sql = "SELECT * FROM active_year ORDER BY active_year DESC;";
                                rs = stmt.executeQuery(sql);
                                while(rs.next()) {
                                    %><option value='<%=rs.getInt("active_year")%>'><%= rs.getInt("active_year") %></option><%
                                }
                            %>
                        </select>
                        <th><input type="submit" value="Get Report"></th>
                    </form>
                    <%



                // EVENT LISTENER **************************
                if (action != null && action.equals("select")) {
                    
                    // Display student **************************************************
                    %>
                    <h2>Input</h2>
                    <table>
                        <tr>
                            <th>
                                course
                            </th>
                            <th>
                                professor
                            </th>
                            <th>
                                quarter
                            </th>
                            <th>
                                year
                            </th>
                        </tr>

                        <tr>
                            <td><%=request.getParameter("course_number")%></td>
                            <td><%=request.getParameter("faculty_id")%></td>
                            <td><%=request.getParameter("season")%></td>
                            <td><%=request.getParameter("active_year")%></td>
                        </tr>
                    </table>
                    
                    <%

                    // GRADE DISTRIBUTION **************************************************
                    %><h2>Course Grade Distribution (<%=request.getParameter("course_number")%>, professor <%=request.getParameter("faculty_id")%>, <%=request.getParameter("season")%> <%=request.getParameter("active_year")%>)</h2><%
                    // create statement
                    String query = "select course_number, grade, count\n" +
                            "from cpqg \n" +
                            "where course_number = ?\n" +
                            "and faculty_id = ?\n" +
                            "and active_year = ?\n" +
                            "and season = ?\n" +
                            "group by course_number, grade, count";
                    PreparedStatement pstmt = conn.prepareStatement(query);

                    pstmt.setString(1, request.getParameter("course_number"));
                    pstmt.setString(2, request.getParameter("faculty_id"));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("active_year")));
                    pstmt.setString(4, request.getParameter("season"));
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
                    String student_id = "";
                    while(rs.next()) {
                        %><tr><%
                            %><td><%= rs.getString("course_number")%></td><%
                            %><td><%= rs.getString("grade")%></td><%
                            %><td><%= rs.getInt("count")%></td><%

                        %></tr><%
                    }
                    %></table><% 



                    // PROFESSOR GRADE DISTRIBUTION **************************************************
                    %><h2>Grade Distribution (<%=request.getParameter("course_number")%>, professor <%=request.getParameter("faculty_id")%>)</h2><%
                    // create statement
                    query = "select course_number, grade, sum(count) as count\n" +
                            "from cpg \n" +
                            "where course_number = ?\n" +
                            "and faculty_id = ?\n" +
                            "group by course_number, grade";
                    pstmt = conn.prepareStatement(query);

                    pstmt.setString(1, request.getParameter("course_number"));
                    pstmt.setString(2, request.getParameter("faculty_id"));
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
                            %><td><%= rs.getString("grade")%></td><%
                            %><td><%= rs.getInt("count")%></td><%

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