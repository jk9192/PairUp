package com.yourpackage;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root")) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            PreparedStatement psUser = con.prepareStatement("SELECT id, name, email FROM users WHERE email = ?");
            psUser.setString(1, userEmail);
            ResultSet rsUser = psUser.executeQuery();

            if (rsUser.next()) {
                int userId = rsUser.getInt("id");
                request.setAttribute("userName", rsUser.getString("name"));
                request.setAttribute("userEmail", rsUser.getString("email"));

                PreparedStatement psProfile = con.prepareStatement("SELECT * FROM profile_characteristics WHERE user_id = ?");
                psProfile.setInt(1, userId);
                ResultSet rsProfile = psProfile.executeQuery();

                if (rsProfile.next()) {
                    request.setAttribute("current_focus", rsProfile.getString("current_focus"));
                    request.setAttribute("skills", rsProfile.getString("skills"));
                    request.setAttribute("bio", rsProfile.getString("bio"));
                    request.setAttribute("profile_picture", rsProfile.getString("profile_picture"));
                    request.setAttribute("college", rsProfile.getString("college"));
                }

                rsProfile.close();
                psProfile.close();
            }

            rsUser.close();
            psUser.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Decide which JSP to open
        String mode = request.getParameter("mode");
        if ("edit".equals(mode)) {
            RequestDispatcher rd = request.getRequestDispatcher("edit_profile.jsp");
            rd.forward(request, response);
        } else {
            RequestDispatcher rd = request.getRequestDispatcher("profile.jsp");
            rd.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        // ✅ Get multiple skills properly
        String[] selectedSkills = request.getParameterValues("skills");
        String skills = "";
        if (selectedSkills != null) {
            skills = String.join(",", selectedSkills);
        }

        String bio = request.getParameter("bio");
        String profilePic = request.getParameter("profile_picture");
        String college = request.getParameter("college");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");

            // Get user_id
            PreparedStatement psUser = con.prepareStatement("SELECT id FROM users WHERE email = ?");
            psUser.setString(1, userEmail);
            ResultSet rsUser = psUser.executeQuery();

            int userId = -1;
            if (rsUser.next()) userId = rsUser.getInt("id");
            rsUser.close();
            psUser.close();

            if (userId == -1) {
                response.sendRedirect("login.jsp");
                return;
            }

            // ✅ Insert OR Update Profile
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO profile_characteristics (user_id, skills, bio, profile_picture, college) " +
                "VALUES (?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE skills=?, bio=?, profile_picture=?, college=?"
            );

            ps.setInt(1, userId);
            ps.setString(2, skills);
            ps.setString(3, bio);
            ps.setString(4, profilePic);
            ps.setString(5, college);

            ps.setString(6, skills);
            ps.setString(7, bio);
            ps.setString(8, profilePic);
            ps.setString(9, college);

            ps.executeUpdate();
            ps.close();
            con.close();

            // Return to profile
            response.sendRedirect("ProfileServlet?updated=true");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}