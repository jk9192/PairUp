<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*,jakarta.servlet.http.HttpSession" %>
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
  
   
%>

<!DOCTYPE html>
<html>
<head>
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<meta charset="UTF-8">
<title>Notifications</title>
<style>
  body {
        margin: 0;
        font-family: "Comic Sans MS", "Comic Sans", cursive;
        background-color: #f8f9fa;
    }
    
    nav{
     background: #D8BFD8;
     box-shadow: 0 2px 10px rgba(0,0,0,0.1);
     height:45px;
     padding: 0px 40px;
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
    
    
     .logout {
        color: #e63946 !important;
        font-weight: bold;
    }
   
    
    /* POST BOX  chaluuuuuuuu krte hai*/

    
    input, button {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

::placeholder {
  font-family: Comic Sans MS, Comic Sans, cursive;
}
.logo{
  height: 40px;
  width:auto;
  object-fit: contain;
   border-radius: 6px; 
  }
  
  .container {
  width: 70%;
  margin: 50px auto;
  text-align: center;
}

/* Heading */
.welcome {
  font-size: 30px;
  margin-bottom: 40px;
  color: #4a0072;
  font-weight: 600;
  letter-spacing: 0.5px;
}

/* Request cards */
.post {
  background: #ffffff;
  border-radius: 15px;
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
  padding: 20px;
  margin-bottom: 25px;
  text-align: left;
  transition: transform 0.2s ease, box-shadow 0.3s ease;
}

.post:hover {
  transform: translateY(-3px);
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
}

.post h4 {
  margin: 0;
  color: #6f42c1;
  font-size: 20px;
}

.post p {
  margin: 8px 0;
  color: #333;
}

.post-time {
  font-size: 13px;
  color: #777;
  margin-bottom: 15px;
}

/* Buttons */
.post-btn {
  background-color: #6f42c1;
  color: white;
  border: none;
  border-radius: 25px;
  padding: 8px 18px;
  margin-right: 10px;
  cursor: pointer;
  font-weight: 500;
  transition: 0.3s;
}

.post-btn:hover {
  background-color: #4a0072;
}

.post-btn.reject {
  background-color: #A0522D;
}

.post-btn.reject:hover {
  background-color: #A0522D;
}

input, button {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

::placeholder {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

</style>
</head>
<body>

<nav>
  <img class ="logo" src="navlogo.png" alt="logo of pair up" >
   <div>
            <a href="welcome.jsp">Home</a>
            <a href="search.jsp">Search <i class="fas fa-search"></i>
            </a>
            <a href="ProfileServlet?mode=view">Profile</a>
            <a href="MyPairsServlet">PairUp</a>
            <a href="groups.jsp">Groups</a>
            <a href="hacksearch.jsp">HackSearch</a>
            <a href="notifications.jsp"><i class="fa-solid fa-bell" style="font-size:20px; cursor:pointer;"></i>
</a>
            <a href="LogoutServlet" class="logout">Logout</a>
            
        </div>
</nav>

<div class="container">
<h2 class="welcome">Incoming Pair Requests 💌</h2>
<%
   Connection conn=null;
   PreparedStatement ps=null;
   ResultSet rs=null;
   int userId = -1;
   int currentProfileId=-1;
   try{
      Class.forName("com.mysql.cj.jdbc.Driver");
      conn=DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup","root","root");
      
      
      ps = conn.prepareStatement("SELECT id FROM users WHERE email = ?");
      ps.setString(1, userEmail);
      rs = ps.executeQuery();
      if (rs.next()) {
          userId = rs.getInt("id");
      }
      rs.close();
      ps.close();
      
      
      ps=conn.prepareStatement("SELECT profile_id FROM profile_characteristics WHERE user_id=?");
      ps.setInt(1,userId);
      rs=ps.executeQuery();
      if(rs.next()) currentProfileId=rs.getInt("profile_id");
      rs.close(); ps.close();

      ps=conn.prepareStatement(
        "SELECT pr.request_id, pr.sender_id, pc.username, pc.skills, pr.created_at " +
        "FROM pair_requests pr JOIN profile_characteristics pc ON pr.sender_id=pc.profile_id " +
        "WHERE pr.receiver_id=? AND pr.status='pending'"
      );
      
      ps.setInt(1,currentProfileId);
      rs=ps.executeQuery();

      boolean hasRequests=false;
      while(rs.next()){
         hasRequests=true;
%>
   <div class="post">
      <h4><i class="fa-solid fa-user"></i> <%=rs.getString("username")%></h4>
      <p><strong>Skills:</strong> <%=rs.getString("skills")%></p>
      <p class="post-time">Sent on: <%=rs.getTimestamp("created_at")%></p>

      <form action="AcceptPairRequestServlet" method="post" style="display:inline;">
         <input type="hidden" name="request_id" value="<%=rs.getInt("request_id")%>">
         <input type="hidden" name="sender_id" value="<%=rs.getInt("sender_id")%>">
         <input type="hidden" name="receiver_id" value="<%=currentProfileId%>">
         <button class="post-btn" type="submit">Accept ✅</button>
      </form>

      <form action="RejectPairRequestServlet" method="post" style="display:inline;">
         <input type="hidden" name="request_id" value="<%=rs.getInt("request_id")%>">
         <button class="post-btn" type="submit" style="background-color:#A0522D;">Reject ❌</button>
      </form>
   </div>
<%
      }
      if(!hasRequests){
%>
   <p>No pending requests at the moment! 😄</p>
<%
      }
   }catch(Exception e){
      e.printStackTrace();
   }finally{
      try{if(rs!=null)rs.close();}catch(Exception e){}
      try{if(ps!=null)ps.close();}catch(Exception e){}
      try{if(conn!=null)conn.close();}catch(Exception e){}
   }
%>
</div>