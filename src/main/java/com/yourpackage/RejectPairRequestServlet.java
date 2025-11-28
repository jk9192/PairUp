package com.yourpackage;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/RejectPairRequestServlet")
public class RejectPairRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int requestId = Integer.parseInt(request.getParameter("request_id"));

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");

            ps = conn.prepareStatement("UPDATE pair_requests SET status='rejected' WHERE request_id=?");
            ps.setInt(1, requestId);
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
