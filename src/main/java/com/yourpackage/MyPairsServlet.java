package com.yourpackage;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/MyPairsServlet")
public class MyPairsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // session validation
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        List<PairProfile> myPairs = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pairup", "root", "root"
            );

            // 1️⃣ GET userId from email
            String getUserId = "SELECT id FROM users WHERE email = ?";
            PreparedStatement ps1 = conn.prepareStatement(getUserId);
            ps1.setString(1, userEmail);
            ResultSet rs1 = ps1.executeQuery();

            int userId = -1;
            if (rs1.next()) userId = rs1.getInt("id");
            rs1.close();
            ps1.close();

            // 2️⃣ GET profile_id from profile_characteristics
            String getProfileId = "SELECT profile_id FROM profile_characteristics WHERE user_id = ?";
            PreparedStatement ps2 = conn.prepareStatement(getProfileId);
            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();

            int myProfileId = -1;
            if (rs2.next()) myProfileId = rs2.getInt("profile_id");
            rs2.close();
            ps2.close();

            // 3️⃣ FETCH PAIRED PROFILES
            String getPairs = """
                SELECT 
                    IF(p.profile1_id = ?, p.profile2_id, p.profile1_id) AS paired_profile_id
                FROM paired_profiles p
                WHERE p.profile1_id = ? OR p.profile2_id = ?
            """;

            PreparedStatement ps3 = conn.prepareStatement(getPairs);
            ps3.setInt(1, myProfileId);
            ps3.setInt(2, myProfileId);
            ps3.setInt(3, myProfileId);

            ResultSet rs3 = ps3.executeQuery();

            List<Integer> pairedProfileIds = new ArrayList<>();
            while (rs3.next()) {
                pairedProfileIds.add(rs3.getInt("paired_profile_id"));
            }
            rs3.close();
            ps3.close();

            // 4️⃣ FETCH USER DETAILS OF EACH paired_profile_id
            String getUserDetails = """
                SELECT u.name, u.email, pc.skills , pc.profile_picture
                FROM profile_characteristics pc
                JOIN users u ON pc.user_id = u.id
                WHERE pc.profile_id = ?
            """;

            PreparedStatement ps4 = conn.prepareStatement(getUserDetails);

            for (int pid : pairedProfileIds) {
                ps4.setInt(1, pid);
                ResultSet rs4 = ps4.executeQuery();

                if (rs4.next()) {
                    PairProfile p = new PairProfile(
                    		 pid, // profileId
                             rs4.getString("name"),
                             rs4.getString("email"),
                             rs4.getString("skills"),
                             rs4.getString("profile_picture")
                    );
                    myPairs.add(p);
                }
                rs4.close();
            }

            ps4.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("myPairsList", myPairs);
        request.setAttribute("showPairs", true);

        request.getRequestDispatcher("pairup.jsp").forward(request, response);
    }
}
