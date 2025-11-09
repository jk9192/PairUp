package com.yourpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


@WebServlet("/PairRequestServlet")
public class PairRequestServlet extends HttpServlet {
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false); 
		if(session==null || session.getAttribute("userEmail")==null) {
			response.sendRedirect("login.jsp");
			return;
		}
		
		String receiverId = request.getParameter("receiverProfileId"); // jisko jayegi pairRequest

		if(receiverId == null || receiverId.isEmpty()) {
			response.sendRedirect("search.jsp");
			return;
		}
		
		
		// session is established then.. we check..
		// Sender ka nikalo
		String senderEmail = (String) session.getAttribute("userEmail");
		
		 int rProfileId = Integer.parseInt(receiverId);
		 int senderProfileId = -1;
		 try {
			 Class.forName("com.mysql.cj.jdbc.Driver");
			 Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup","root","root");
			 String getSenderQuery = """
	                    SELECT p.profile_id 
	                    FROM profile_characteristics p 
	                    JOIN users u ON p.user_id = u.id 
	                    WHERE u.email = ?
	                    """;
			 
			 PreparedStatement psSender = con.prepareStatement(getSenderQuery);
	         psSender.setString(1, senderEmail);
	            
	         
	         ResultSet rs = psSender.executeQuery();
	         
	         if(rs.next()) {
	        	   senderProfileId = rs.getInt("profile_id");
	         }
	         else {
	        	   con.close();
	           response.sendRedirect("search.jsp");
	           return;
	         }
			 
	         String checkQuery = """
	                    SELECT * FROM pair_requests 
	                    WHERE (sender_id = ? AND receiver_id = ?) 
	                       OR (sender_id = ? AND receiver_id = ?)
	                    """;
	         
	         
	         
	         PreparedStatement psCheck = con.prepareStatement(checkQuery);
	            psCheck.setInt(1, senderProfileId);
	            psCheck.setInt(2, rProfileId);
	            psCheck.setInt(3, rProfileId);
	            psCheck.setInt(4, senderProfileId);

	            
	            
	            ResultSet rsCheck = psCheck.executeQuery();
	            if (rsCheck.next()) {
	            	// request already exists
	                con.close();
	                response.sendRedirect("SearchServlet?query=");
	                return;
	            }
	            
	            
	            String insertQuery = """
	                    INSERT INTO pair_requests (sender_id, receiver_id, status)
	                    VALUES (?, ?, 'pending')
	                    """;
	            PreparedStatement psInsert = con.prepareStatement(insertQuery);
	            psInsert.setInt(1, senderProfileId);
	            psInsert.setInt(2, rProfileId);
	            psInsert.executeUpdate();

	            con.close();
	            String lastQuery = request.getParameter("query");
	            if (lastQuery == null) lastQuery = "";
	            response.sendRedirect("SearchServlet?query=" + URLEncoder.encode(lastQuery, "UTF-8"));
		 }
		 catch (Exception e) {
	            e.printStackTrace();
	            response.sendRedirect("error.jsp");
	        }
		
	}

}
