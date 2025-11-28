package com.yourpackage;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		String email = request.getParameter("email");
		String pass = request.getParameter("password");
		 Connection con = null;
	     PreparedStatement ps = null;
	     ResultSet rs = null;
	     
	     try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");
			String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, pass);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                session.setAttribute("userID",rs.getInt("id"));
                session.setAttribute("userName", rs.getString("name")); // ✅ store name
                response.sendRedirect("welcome.jsp");
            }
            else {
                // error phekege yo
                response.sendRedirect("login.jsp?error=Invalid email or password");
            }
			
			
		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			 out.println("<h3>Error: " + e.getMessage() + "</h3>");
		}
	     finally {
	            try {
	                if (rs != null) rs.close();
	                if (ps != null) ps.close();
	                if (con != null) con.close();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        
			
	}

	}
}