<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,jakarta.servlet.http.HttpSession" %>
<%
    session = request.getSession(false);
    if(session==null || session.getAttribute("userEmail")==null){
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
<meta charset="UTF-8">
<title>Search</title>
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
/>

<style>
body {
  margin: 0;
  font-family: "Comic Sans MS", cursive;
  background-color: #f8f9fa;
}

/* ===== NAVBAR ===== */
nav {
  background: #D8BFD8;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  height: 45px;
  padding: 0 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

nav a {
  text-decoration: none;
  color: #333;
  margin-right: 25px;
  transition: 0.3s;
}

nav a:hover {
  color: #007bff;
}

.logo {
  height: 40px;
  width: auto;
  object-fit: contain;
  border-radius: 6px;
}

/* ===== SEARCH BAR ===== */
.search-bar {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

#search-input {
  padding: 8px;
  width: 280px;
  border-radius: 5px;
  border: 1px solid #ccc;
}

.search-bar button {
  margin-left: 10px;
  padding: 8px 15px;
  border: none;
  background: #D8BFD8;
  border-radius: 5px;
  cursor: pointer;
  transition: 0.3s;
}

.search-bar button:hover {
  background: #c59bd1;
}

input, button {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

::placeholder {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

/* ===== CONTAINER ===== */
.container {
  margin-top: 30px;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
  padding: 20px 40px;
}

/* ===== PROFILE CARD ===== */
.profile-card {
  background: white;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  padding: 20px;
  text-align: center;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.profile-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 14px rgba(0,0,0,0.15);
}

.profile-card img {
  width: 90px;
  height: 90px;
  object-fit: cover;
  border-radius: 50%;
  margin-bottom: 10px;
  border: 2px solid #D8BFD8;
}

.profile-card h3 {
  margin: 8px 0;
  color: #333;
}

.profile-card p {
  font-size: 14px;
  color: #666;
  margin: 4px 0;
}

/* ===== BUTTONS ===== */
.buttons {
  margin-top: 10px;
  display: flex;
  justify-content: center;
  gap: 10px;
}

.view-btn,
.pair-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 13px;
  transition: 0.3s;
}

.view-btn {
  background: #007bff;
  color: white;
}

.pair-btn {
  background: #6f42c1;
  color: white;
}

.view-btn:hover {
  background: #0056b3;
}

.pair-btn:hover {
  background: #563d7c;
}

/* ===== NO RESULTS ===== */
.container p {
  text-align: center;
  grid-column: 1 / -1;
  font-size: 16px;
  color: #777;
}
</style>
</head>

<body>



<nav>
  <img class="logo" src="navlogo.png" alt="logo of pair up">
  <div>
    <a href="welcome.jsp">Home</a>
    <a href="search.jsp">Search <i class="fas fa-search"></i></a>
    <a href="ProfileServlet?mode=view">Profile</a>
    <a href="pairup.jsp">PairUp</a>
    <a href="groups.jsp">Groups</a>
    <a href="hacksearch.jsp">HackSearch</a>
    <a href="notifications.jsp"><i class="fa-solid fa-bell" style="font-size:20px; cursor:pointer;"></i>
</a>
    <a href="LogoutServlet" class="logout">Logout</a>
  </div>
</nav>




<div class="search-bar">
  <form method="get" action="SearchServlet">
    <input id="search-input" type="text" placeholder="Search using name, skill or college" name="query">
    <button type="submit">Search <i class="fas fa-search"></i></button>
  </form>
</div>




<div class="container">
<%
String searchQuery = (String) request.getAttribute("searchQuery");
List<Map<String, String>> profiles = (List<Map<String, String>>) request.getAttribute("profiles");

if (profiles != null && !profiles.isEmpty()) {
    for (Map<String, String> user : profiles) {
%>

  <div class="profile-card">
    <img src="<%= user.get("profile_picture") != null ? user.get("profile_picture") : "defaultpic.png" %>" alt="Profile Picture">
    <h3><%= user.get("username") %></h3>
    <p><strong>College:</strong> <%= user.get("college") %></p>
    <p><strong>Skills:</strong> <%= user.get("skills") %></p>

    <div class="buttons">
      <form action="ViewProfileServlet" method="get">
        <input type="hidden" name="profileId" value="<%= user.get("profile_id") %>">
        <button type="submit" class="view-btn">View Profile</button>
      </form>



	 
	   <%
    String pairStatus = user.get("pair_status");
    if ("none".equals(pairStatus)) {
	   %>
	   
	   
	  <form action="PairRequestServlet" method="post">
        <input type="hidden" name="receiverProfileId" value="<%= user.get("profile_id") %>">
        <button type="submit" class="pair-btn">Send Pair Request</button>
    </form>
    
    <%
    } 
    
    
    else if ("pending".equalsIgnoreCase(pairStatus)) {
%>
    <button class="pair-btn" disabled>Request Sent</button>
<%
    } else if ("accepted".equalsIgnoreCase(pairStatus)) {
%>
    <button class="pair-btn" disabled>Paired ✔</button>
<%
    } else if ("rejected".equalsIgnoreCase(pairStatus)) {
%>

<form action="PairRequestServlet" method="post">
        <input type="hidden" name="receiverProfileId" value="<%= user.get("profile_id") %>">
        <button type="submit" class="pair-btn">Send Again</button>
    </form>
<%
    }
%>
    </div>
  </div>

<%
    }
    
    
} else if (searchQuery != null) {
%>
  <p>No results found for "<%= searchQuery %>".</p>
<%
}
%>
</div>

</body>
</html>
