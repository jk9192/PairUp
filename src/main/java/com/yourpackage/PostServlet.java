package com.yourpackage;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;


@WebServlet("/PostServlet")
public class PostServlet extends HttpServlet {	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false); 
		if(session==null || session.getAttribute("userEmail")==null) {
			response.sendRedirect("login.jsp");
			return;
		}
		String userEmail = (String) session.getAttribute("userEmail");
		String content = request.getParameter("content");
		if (content == null || content.trim().isEmpty()) {
            response.sendRedirect("welcome.jsp");
            return;
        }
	    ResultSet rs = null;
	    PreparedStatement psProfile = null;
		Connection con = null;
		PreparedStatement ps = null;
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup","root","root");
			 String getProfileIdQuery = """
		                SELECT p.profile_id 
		                FROM users u 
		                JOIN profile_characteristics p ON u.id = p.user_id 
		                WHERE u.email = ?
		            """;
			 
	       psProfile = con.prepareStatement(getProfileIdQuery);
			psProfile.setString(1, userEmail);
            rs = psProfile.executeQuery();
			
            int profileId = -1;
            if (rs.next()) {
                profileId = rs.getInt("profile_id");
            } else {
                response.sendRedirect("welcome.jsp");
                return;
            }
            
            
            
            
            
			String query = "INSERT INTO posts (profile_id, content) VALUES (?, ?) ;";
			ps = con.prepareStatement(query);
		 ps.setInt(1, profileId);
	       ps.setString(2, content);
	        ps.executeUpdate();
			
	        
	        response.sendRedirect("welcome.jsp");
	        
	        
			
		}
		catch(Exception e) {
			
			 e.printStackTrace();
	            response.sendRedirect("error.jsp");
			
		}
		finally {
			try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (psProfile != null) psProfile.close(); } catch(Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
		}
		
	
	}

}
