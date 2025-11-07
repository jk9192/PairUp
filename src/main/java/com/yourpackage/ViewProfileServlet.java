package com.yourpackage;
import java.sql.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/ViewProfileServlet")
public class ViewProfileServlet extends HttpServlet {
	

// yae servlet hum jab call krre hai jab
	// hume jo particular user ke card p hm usse hum 
	// profile dekhna chahre h basically
	// profile.jsp call krni kiski uss user ki jiski profile card h
	// without edit profile option ->  now this is the main thing
	// should i make another viewprofile.jsp ? without the edit option
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// viewprofile jsp p redirect krna haii
		
		HttpSession session = request.getSession(false);
		if(session==null || session.getAttribute("userEmail")==null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		String profileId = request.getParameter("profileId");
		if(profileId==null || profileId.isEmpty()) {
			response.sendRedirect("search.jsp");
			return;
		}
		
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup","root", "root");
			String query = "SELECT p.username,p.bio, p.skills, p.college, p.profile_picture " +
                    "FROM profile_characteristics p " +
                    "WHERE p.profile_id = ?";
			ps = con.prepareStatement(query);
			ps.setString(1,profileId);
			rs= ps.executeQuery();
			if(rs.next()) {
			Map<String,String>profileData =new HashMap<>();
			profileData.put("username",rs.getString("username"));
			profileData.put("bio",rs.getString("bio"));
			profileData.put("skills",rs.getString("skills"));
			profileData.put("profile_picture",rs.getString("profile_picture"));
			profileData.put("college",rs.getString("college"));
			request.setAttribute("profileData", profileData);
			RequestDispatcher rd = request.getRequestDispatcher("viewprofile.jsp");
			rd.forward(request,response);
			
			}
			else {
                response.getWriter().println("Profile not found!");
            }
			
		}
		catch(Exception e) {
			 e.printStackTrace();
	            response.getWriter().println("Error fetching profile.");
		}
		finally {
			  try { if (rs != null) rs.close(); } catch (Exception e) {}
	            try { if (ps != null) ps.close(); } catch (Exception e) {}
	            try { if (con != null) con.close(); } catch (Exception e) {}
		}
		
	}

}
