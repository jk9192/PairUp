package com.yourpackage;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		  String searchQuery = request.getParameter("query");
	      HttpSession session = request.getSession(false);
	        if (session == null || session.getAttribute("userEmail") == null) {
	            response.sendRedirect("login.jsp");
	            return;
	        }
 
	        String userEmail = (String) session.getAttribute("userEmail");
	        
	        List<Map<String, String>> profiles = new ArrayList<>();
	        
	        
	        Connection con = null;
	        
	        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
	            try {
	                Class.forName("com.mysql.cj.jdbc.Driver");
	                 con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");
	                String getUserIdQuery = "SELECT p.profile_id FROM users u JOIN profile_characteristics p ON u.id = p.user_id WHERE u.email = ?";
	                PreparedStatement psUser = con.prepareStatement(getUserIdQuery);
	                psUser.setString(1, userEmail);
	                ResultSet rsUser = psUser.executeQuery();
	                int currentUserProfileId = -1;
	                if (rsUser.next()) {
	                    currentUserProfileId = rsUser.getInt("profile_id");
	                    // jis user ki profile m hum logged in hai wo..
	                }
	                String sql = "SELECT u.name, p.profile_id, p.username, p.college, p.skills, p.profile_picture, p.user_id " +
	                             "FROM users u JOIN profile_characteristics p ON u.id = p.user_id " +
	                             "WHERE (u.name LIKE ? OR p.skills LIKE ? OR p.college LIKE ?) AND u.email <> ?";

	                PreparedStatement ps = con.prepareStatement(sql);
	                String likeTerm = "%" + searchQuery + "%";
	                ps.setString(1, likeTerm);
	                ps.setString(2, likeTerm);
	                ps.setString(3, likeTerm);
	                ps.setString(4, userEmail);

	                ResultSet rs = ps.executeQuery();

	                while (rs.next()) {
	                    Map<String, String> user = new HashMap<>();
	                    int otherProfileId = rs.getInt("profile_id");

	                    user.put("name", rs.getString("name"));
	                    user.put("username", rs.getString("username"));
	                    user.put("college", rs.getString("college"));
	                    user.put("skills", rs.getString("skills"));
	                    user.put("profile_picture", rs.getString("profile_picture"));
	                    user.put("user_id", rs.getString("user_id"));
	                    user.put("profile_id", String.valueOf(otherProfileId));
	                    
	                    
	                    
	                    
	                    String statusQuery = "SELECT status FROM pair_requests WHERE (sender_id = ? AND receiver_id = ?)  OR (sender_id = ? AND receiver_id = ?)";
	                    PreparedStatement psStatus = con.prepareStatement(statusQuery);
	                    psStatus.setInt(1, currentUserProfileId);
	                    psStatus.setInt(2, otherProfileId);
	                    psStatus.setInt(3, otherProfileId);
	                    psStatus.setInt(4,currentUserProfileId);
	                    
	                    ResultSet rsStatus = psStatus.executeQuery();
	                    
	                    String requestStatus = "none";
	                    
	                    
	                    if (rsStatus.next()) {
	                        requestStatus = rsStatus.getString("status");
	                    }
	                    user.put("pair_status", requestStatus);
	                    profiles.add(user);
	                }

	                
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	            finally {
	                try { if (con != null) con.close(); } catch (Exception e) {}
	            }
	        }

	        request.setAttribute("profiles", profiles);
	        request.setAttribute("searchQuery", searchQuery);
	        RequestDispatcher rd = request.getRequestDispatcher("search.jsp");
	        rd.forward(request, response);
	
}
	
}
