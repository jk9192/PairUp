package com.yourpackage;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AcceptPairRequestServlet")
public class AcceptPairRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("request_id"));
        int senderId = Integer.parseInt(request.getParameter("sender_id"));
        int receiverId = Integer.parseInt(request.getParameter("receiver_id"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");

            // 1️⃣ Mark request as accepted
            ps = conn.prepareStatement("UPDATE pair_requests SET status='accepted' WHERE request_id=?");
            ps.setInt(1, requestId);
            ps.executeUpdate();
            ps.close();

            // 2️⃣ Insert into paired_profiles
            ps = conn.prepareStatement(
                "INSERT INTO paired_profiles (profile1_id, profile2_id, paired_at) VALUES (?, ?, NOW())"
            );
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.executeUpdate();
            ps.close();

            // 3️⃣ Delete other pending requests between the two users
            ps = conn.prepareStatement(
                "DELETE FROM pair_requests WHERE " +
                "((sender_id=? AND receiver_id=?) OR (sender_id=? AND receiver_id=?)) AND status='pending'"
            );
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setInt(3, receiverId);
            ps.setInt(4, senderId);
            ps.executeUpdate();

            response.sendRedirect("notifications.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (conn != null) conn.close(); } catch (Exception ex) {}
        }
    }
}
