package com.yourpackage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/FindCodingBuddyServlet")
public class FindCodingBuddyServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/pairup", "root", "root"
            );

            // STEP 1 — Get my profile_id
            String q1 = """
                SELECT pc.profile_id
                FROM profile_characteristics pc
                JOIN users u ON pc.user_id = u.id
                WHERE u.email = ?
            """;

            PreparedStatement ps1 = con.prepareStatement(q1);
            ps1.setString(1, userEmail);
            ResultSet rs1 = ps1.executeQuery();

            int myProfileId = -1;
            if (rs1.next()) myProfileId = rs1.getInt("profile_id");
            rs1.close();
            ps1.close();

            if (myProfileId == -1) {
                con.close();
                response.sendRedirect("welcome.jsp");
                return;
            }

            // STEP 2 — Build exclude list manually
            Set<Integer> excludeSet = new HashSet<>();
            excludeSet.add(myProfileId); // always exclude myself

            // Requests sent
            PreparedStatement psA = con.prepareStatement(
                    "SELECT receiver_id FROM pair_requests WHERE sender_id = ?"
            );
            psA.setInt(1, myProfileId);
            ResultSet rsA = psA.executeQuery();
            while (rsA.next()) excludeSet.add(rsA.getInt(1));
            rsA.close();
            psA.close();

            // Requests received
            PreparedStatement psB = con.prepareStatement(
                    "SELECT sender_id FROM pair_requests WHERE receiver_id = ?"
            );
            psB.setInt(1, myProfileId);
            ResultSet rsB = psB.executeQuery();
            while (rsB.next()) excludeSet.add(rsB.getInt(1));
            rsB.close();
            psB.close();

            // Already paired using paired_profiles (your correct table)
            PreparedStatement psC = con.prepareStatement(
                "SELECT profile1_id, profile2_id FROM paired_profiles WHERE profile1_id = ? OR profile2_id = ?"
            );
            psC.setInt(1, myProfileId);
            psC.setInt(2, myProfileId);

            ResultSet rsC = psC.executeQuery();
            while (rsC.next()) {
                int p1 = rsC.getInt("profile1_id");
                int p2 = rsC.getInt("profile2_id");

                if (p1 == myProfileId) excludeSet.add(p2);
                if (p2 == myProfileId) excludeSet.add(p1);
            }
            rsC.close();
            psC.close();

            // Convert set to list
            List<Integer> excludeList = new ArrayList<>(excludeSet);

            // If empty add -1 so SQL doesn't break
            if (excludeList.isEmpty()) excludeList.add(-1);

            // STEP 3 — Create NOT IN clause
            StringBuilder notIn = new StringBuilder("(");
            for (int i = 0; i < excludeList.size(); i++) {
                notIn.append(excludeList.get(i));
                if (i < excludeList.size() - 1) notIn.append(",");
            }
            notIn.append(")");

            // STEP 4 — Fetch profiles
            String fetchQuery = """
                SELECT pc.profile_id, pc.username, u.email, pc.skills, pc.profile_picture
                FROM profile_characteristics pc
                JOIN users u ON pc.user_id = u.id
                WHERE pc.profile_id NOT IN 
            """ + notIn;

            Statement st = con.createStatement();
            ResultSet rs3 = st.executeQuery(fetchQuery);

            List<PairProfile> swipeProfiles = new ArrayList<>();

            while (rs3.next()) {
                swipeProfiles.add(new PairProfile(
                        rs3.getInt("profile_id"),
                        rs3.getString("username"),
                        rs3.getString("email"),
                        rs3.getString("skills"),
                        rs3.getString("profile_picture")
                ));
            }

            rs3.close();
            st.close();
            con.close();

            request.setAttribute("swipeProfiles", swipeProfiles);
            request.getRequestDispatcher("pairup.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Internal Server Error");
        }
    }
}
