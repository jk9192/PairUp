package com.yourpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;

@WebServlet("/SkipProfileServlet")
public class SkipProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String receiverId = request.getParameter("receiverProfileId");
        if (receiverId == null || receiverId.isEmpty()) {
            response.sendRedirect("search.jsp");
            return;
        }

        String senderEmail = (String) session.getAttribute("userEmail");
        int rProfileId = Integer.parseInt(receiverId);
        int senderProfileId = -1;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pairup", "root", "root");

            // 1. Find sender's profile_id
            String querySender = """
                SELECT p.profile_id
                FROM profile_characteristics p
                JOIN users u ON p.user_id = u.id
                WHERE u.email = ?
            """;

            PreparedStatement psSender = con.prepareStatement(querySender);
            psSender.setString(1, senderEmail);
            ResultSet rs = psSender.executeQuery();

            if (rs.next()) {
                senderProfileId = rs.getInt("profile_id");
            } else {
                con.close();
                response.sendRedirect("search.jsp");
                return;
            }

            // 2. Insert skip entry (NO checking needed)
            String insertQuery = """
                INSERT INTO skipped_profiles (sender_id, receiver_id)
                VALUES (?, ?)
            """;

            PreparedStatement psInsert = con.prepareStatement(insertQuery);
            psInsert.setInt(1, senderProfileId);
            psInsert.setInt(2, rProfileId);
            psInsert.executeUpdate();

            con.close();

            // 3. Return to search results
            String lastQuery = request.getParameter("query");
            if (lastQuery == null) lastQuery = "";

            response.sendRedirect("SearchServlet?query=" +
                    URLEncoder.encode(lastQuery, "UTF-8"));

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
