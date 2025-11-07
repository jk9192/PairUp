package com.yourpackage;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;


@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String unm = request.getParameter("name");
        String uem = request.getParameter("email");
        String pass = request.getParameter("pass");
		
		
		// lets make a connection to the database 
		// first load server
		  Connection con = null;
	      PreparedStatement ps = null;
	        PreparedStatement psProfile = null;
	      
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup","root","root");
			 String sql = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
			 ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
			  ps.setString(1,unm);
			  ps.setString(2,uem);
			  ps.setString(3,pass);
			  int rows = ps.executeUpdate();
			  
			  
			  if (rows > 0) {
				    ResultSet rs = ps.getGeneratedKeys();
				    int userId = -1;
				    if (rs.next()) {
				        userId = rs.getInt(1);
				    }

				    // Insert into profile_characteristics
				    String sqlProfile = "INSERT INTO profile_characteristics (user_id, username, current_focus, skills, bio, profile_picture, college) VALUES (?, ?, ?, ?, ?, ?, ?)";
				    psProfile = con.prepareStatement(sqlProfile);
				    psProfile.setInt(1, userId);       // user_id FK
				    psProfile.setString(2, unm);       // username default same as name
				    psProfile.setString(3, "");        // current_focus default empty
				    psProfile.setString(4, "No skills yet");        // skills default empty
				    psProfile.setString(5, "Not specified");        // bio default empty
				    psProfile.setString(6, "defaultpic.png"); // profile_picture default
				    psProfile.setString(7, "Not specified");        // college default empty
				    psProfile.executeUpdate();

				    response.sendRedirect("login.jsp");
				}
			  else {
	                out.println("<h3>Signup failed. Try again.</h3>");
	            }
			  
			  
			
		} 
		catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			 out.println("<h3>Error: " + e.getMessage() + "</h3>");
		} 
		finally {
            try {
                if (ps != null) ps.close();
                if (psProfile != null) psProfile.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
		

	
