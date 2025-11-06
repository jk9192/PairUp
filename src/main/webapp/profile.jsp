<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>

<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    String userName = "", currentFocus = "", skills = "", bio = "" ,college = "", profilePic = "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");

        String query = "SELECT u.name, p.current_focus, p.skills, p.bio, p.profile_picture,p.college " +
                       "FROM users u LEFT JOIN profile_characteristics p ON u.id = p.user_id WHERE u.email = ?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            userName = rs.getString("name");
            currentFocus = rs.getString("current_focus") != null ? rs.getString("current_focus") : "";
            skills = rs.getString("skills") != null ? rs.getString("skills") : "";
            bio = rs.getString("bio") != null ? rs.getString("bio") : "";
            profilePic = rs.getString("profile_picture") != null ? rs.getString("profile_picture") : profilePic;
            college = rs.getString("college") != null ? rs.getString("college") : "";
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <style>
        body {
            font-family: "Comic Sans MS", "Comic Sans", cursive;
            background-color: #f8f9fa;
            margin: 0;
        }
        nav {
            background: #D8BFD8;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
        }
        nav a { text-decoration: none; color: #333; margin-right: 25px; }
        .logout { color: #e63946; font-weight: bold; }
        .container {
            width: 70%; margin: 40px auto;
            background: white; padding: 40px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        .profile-pic {
            width: 120px; height: 120px;
            border-radius: 50%; object-fit: cover;
            border: 3px solid #D8BFD8;
        }
        .edit-btn {
            background-color: #007bff; color: white;
            border: none; padding: 10px 20px;
            border-radius: 20px; margin-top: 20px;
            cursor: pointer;
        }
        .edit-btn:hover { background-color: #0056b3; }
    </style>
</head>
<body>
<nav>
  <div style="font-size:22px; font-weight:bold; color:#444;">PairUp 💻</div>
  <div>
    <a href="welcome.jsp">Home</a>
    <a href="ProfileServlet?mode=edit">Edit Profile</a>
    <a href="pairup.jsp">PairUp</a>
    <a href="groups.jsp">Groups</a>
    <a href="hacksearch.jsp">HackSearch</a>
    <a href="LogoutServlet" class="logout">Logout</a>
  </div>
</nav>

<div class="container">
    <img src="<%= profilePic %>" class="profile-pic">
    <h2><%= userName %></h2>
    <p><b>Email:</b> <%= userEmail %></p>
    <p><b>Skills:</b></p>

<%
    if(skills == null || skills.trim().equals("")) {
%>
    <p>Not added yet</p>
<%
    } else {
        String[] skillList = skills.split(",");
%>
    <div style="margin-top:10px;">
<%
        for(String s : skillList) {
%>
        <span style="background:#D8BFD8; color:#333; padding:6px 12px; margin:5px; border-radius:15px; display:inline-block;">
            <%= s.trim() %>
        </span>
<%
        }
    }
%>

    <p><b>Bio:</b> <%= bio.isEmpty() ? "Write something about yourself!" : bio %></p>
	<p><b>College:</b> <%=college.isEmpty()? "Not Set!! ": college %></p>
    <!-- ✅ Fixed: Now sends mode=edit to servlet -->
    
    
    <form action="ProfileServlet" method="get">
        <input type="hidden" name="mode" value="edit">
        <button type="submit" class="edit-btn">Edit Profile</button>
    </form>
</div>
</body>
</html>
