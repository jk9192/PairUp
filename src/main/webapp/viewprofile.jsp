<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.HttpSession" %>

<%
Map<String, String> profileData = (Map<String, String>) request.getAttribute("profileData");
if (profileData == null) {
    out.println("<p>Profile not found!</p>");
    return;
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
  <img src="<%= profileData.get("profile_picture") != null ? profileData.get("profile_picture") : "defaultpic.png" %>" alt="Profile Picture">
  <h2><%= profileData.get("username") %></h2>
  <p><strong>College:</strong> <%= profileData.get("college") %></p>
  <p><strong>Skills:</strong> <%= profileData.get("skills") %></p>
  <p><strong>Bio:</strong> <%= profileData.get("bio") %></p>
</div>
</body>
</html>
