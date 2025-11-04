<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="jakarta.servlet.http.HttpSession" %>
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
<meta charset="UTF-8">
<title>WELCOME</title>
<style>
  body {
        margin: 0;
        font-family: "Comic Sans MS", "Comic Sans", cursive;
        background-color: #f8f9fa;
    }
    
    nav{
     background: #D8BFD8;
     box-shadow: 0 2px 10px rgba(0,0,0,0.1);
     padding: 15px 40px;
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
    
       .container {
        width: 60%;
        margin: 40px auto;
        text-align: center;
    }
    
       .welcome {
        font-size: 28px;
        margin-bottom: 40px;
        color: #444;
    }
    
    
    /* POST BOX  chaluuuuuuuu krte hai*/
    
    .post-box{
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #fff;
    padding: 15px;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }
    
    .post-input {
    width: 75%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 20px;
        outline: none;
    }
    
     .post-btn {
     	background-color: #007bff;
     	margin-left: 10px;
     	color: white;
        border: none;
        border-radius: 20px;
        padding: 10px 20px;
         cursor: pointer;
        transition: 0.3s; 
     
     }
   
   .post-btn:hover {
        background-color: #0056b3;
    }
   
   
    .posts .post {
        background-color: white;
        border-radius: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        padding: 15px;
        margin-bottom: 15px;
        text-align: left;
    }
    
      .post h4 {
        margin: 0;
        color: #007bff;
    }
    
    .post p {
        margin: 8px 0 0 0;
        color: #333;
    }
    
    .post-time {
        font-size: 12px;
        color: gray;
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
  <div style="font-size:22px; font-weight:bold; color:#444;">PairUp 💻</div>
   <div>
            <a href="welcome.jsp">Home</a>
            <a href="ProfileServlet?mode=view">Profile</a>
            <a href="pairup.jsp">PairUp</a>
            <a href="groups.jsp">Groups</a>
            <a href="hacksearch.jsp">HackSearch</a>
            <a href="LogoutServlet" class="logout">Logout</a>
        </div>
</nav>



  <%
    String userName = (String) session.getAttribute("userName");
%>

<div class="container">

    <div class="welcome">
        Welcome back, <%= userName != null ? userName : "User" %> 👋
    </div>

    <!-- POST INPUT BOX -->
    <div class="post-box">
        <form action="PostServlet" method="post" style="display:flex; width:100%; justify-content:center;">
            <input type="text" name="content" class="post-input" placeholder="Share your progress or thoughts..." required>
            <button type="submit" class="post-btn">Post</button>
        </form>
    </div>

    <!-- POSTS FEED -->
    <div class="posts">
        <div class="post">
            <h4>@jay_chhabra</h4>
            <p>Solved 2 DSA questions today 💪</p>
            <div class="post-time">Posted 2 hours ago</div>
        </div>

        <div class="post">
            <h4>@designersmile</h4>
            <p>Redesigned the PairUp interface ✨ Can’t wait to show it!</p>
            <div class="post-time">Posted 5 hours ago</div>
        </div>

        <div class="post">
            <h4>@webwarrior</h4>
            <p>Looking for a React partner to build a dashboard project ⚡</p>
            <div class="post-time">Posted 1 day ago</div>
        </div>
    </div>

</div>

        








</body>
</html>