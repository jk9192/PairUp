package com.yourpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/TinderFeedServlet")
public class TinderFeedServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendError(401, "Unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String receiverIdStr = request.getParameter("receiverId");

        if (action == null || receiverIdStr == null) {
            response.sendError(400, "Bad Request");
            return;
        }

        int receiverId = Integer.parseInt(receiverIdStr);
        String senderEmail = (String) session.getAttribute("userEmail");

        try (
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pairup", "root", "root"
            )
        ) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Get sender profile ID
            String getSenderQuery = """
                SELECT profile_id
                FROM profile_characteristics pc
                JOIN users u ON pc.user_id = u.id
                WHERE u.email = ?
            """;

            PreparedStatement psSender = con.prepareStatement(getSenderQuery);
            psSender.setString(1, senderEmail);
            ResultSet rsSender = psSender.executeQuery();

            int senderProfileId = -1;
            if (rsSender.next()) senderProfileId = rsSender.getInt("profile_id");
            rsSender.close();
            psSender.close();

            if (senderProfileId == -1) {
                response.sendError(404, "Profile not found");
                return;
            }

            if (action.equals("accept")) {

                // Check if already paired/request exists
                String checkQuery = """
                    SELECT * FROM pair_requests 
                    WHERE sender_id = ? AND receiver_id = ?
                """;

                PreparedStatement psCheck = con.prepareStatement(checkQuery);
                psCheck.setInt(1, senderProfileId);
                psCheck.setInt(2, receiverId);

                ResultSet rsCheck = psCheck.executeQuery();

                boolean exists = rsCheck.next();

                rsCheck.close();
                psCheck.close();

                if (!exists) {
                    // Insert new pair request
                    String insertQuery = """
                        INSERT INTO pair_requests (sender_id, receiver_id, status)
                        VALUES (?, ?, 'pending')
                    """;

                    PreparedStatement psInsert = con.prepareStatement(insertQuery);
                    psInsert.setInt(1, senderProfileId);
                    psInsert.setInt(2, receiverId);
                    psInsert.executeUpdate();
                    psInsert.close();
                }
            }

            // action=skip → do nothing

            response.setStatus(200);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Internal Server Error");
        }
    }
}
