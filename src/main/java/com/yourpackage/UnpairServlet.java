package com.yourpackage;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UnpairServlet")
public class UnpairServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int profile1 = Integer.parseInt(request.getParameter("profile1"));
        int profile2 = Integer.parseInt(request.getParameter("profile2"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");

            // 1️⃣ Remove entry from paired_profiles
            ps = conn.prepareStatement(
                "DELETE FROM paired_profiles WHERE " +
                "(profile1_id=? AND profile2_id=?) OR (profile1_id=? AND profile2_id=?)"
            );
            ps.setInt(1, profile1);
            ps.setInt(2, profile2);
            ps.setInt(3, profile2);
            ps.setInt(4, profile1);
            ps.executeUpdate();
            ps.close();

            // 2️⃣ Optional: clean old pending requests
            ps = conn.prepareStatement(
                "DELETE FROM pair_requests WHERE " +
                "(sender_id=? AND receiver_id=?) OR (sender_id=? AND receiver_id=?)"
            );
            ps.setInt(1, profile1);
            ps.setInt(2, profile2);
            ps.setInt(3, profile2);
            ps.setInt(4, profile1);
            ps.executeUpdate();

            response.sendRedirect("pairup.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ex) {}
            try { if (conn != null) conn.close(); } catch (Exception ex) {}
        }
    }
}
