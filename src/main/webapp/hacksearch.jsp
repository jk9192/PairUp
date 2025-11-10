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
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<meta charset="UTF-8">
<title>HackSearch</title>
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
.logo{
  height: 40px;
  width:auto;
  object-fit: contain;
   border-radius: 6px; 
  }
  
  
  
  .form-box {
    display: none;
    background-color: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    padding: 20px;
    margin-bottom: 30px;
  }
  .container {
  max-width: 1200px;
  margin: 2rem auto;
  background: #fff;
  padding: 2rem;
  border-radius: 10px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.05);
}
  
  input, select, textarea {
  width: 100%;
  padding: 10px;
  margin: 0.5rem 0 1rem 0;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 16px;
  transition: all 0.3s ease;
}

input:focus, textarea:focus, select:focus {
  border-color: #007bff;
  box-shadow: 0 0 5px rgba(0,123,255,0.3);
}

button {
  background: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  border-radius: 8px;
  font-size: 16px;
  cursor: pointer;
  transition: background 0.3s ease;
}

button:hover {
  background: #0056b3;
}

.post {
  background: #f7f9fc;
  padding: 1rem;
  border-radius: 10px;
  margin-bottom: 1.5rem;
  box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  transition: transform 0.2s ease;
}

.post:hover {
  transform: translateY(-3px);
}
h2 {
  color: #007bff;
  margin-bottom: 1rem;
  border-bottom: 2px solid #007bff;
  display: inline-block;
  padding-bottom: 4px;
}

@media (max-width: 768px) {
  .container {
    padding: 1rem;
  }
  header {
    flex-direction: column;
    text-align: center;
  }
  button {
    width: 100%;
  }
}


.feed{
margin:12px;}
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
            <a href="pairup.jsp">PairUp</a>
            <a href="groups.jsp">Groups</a>
            <a href="hacksearch.jsp">HackSearch</a>
            <a href="notifications.jsp"><i class="fa-solid fa-bell" style="font-size:20px; cursor:pointer;"></i>
</a>
            <a href="LogoutServlet" class="logout">Logout</a>
            
        </div>
</nav>




<div class="container">

<div class="post-to-board">
   <button onclick="toggleForm()">Post to Board (Team)</button>
</div>

  <div class="form-box" id="formBox">
    <form>
      <label><b>Skills you have in Team:</b></label>
      <input type="text" placeholder="e.g., Web Dev, ML, UI Design">

      <label><b>Skills you need For Team:</b></label>
      <input type="text" placeholder="e.g., Backend, React, Data Science">

      <label><b>Write Full Info:</b></label>
      <textarea rows="4" placeholder="Describe your team, goal, and what you’re building..."></textarea>

      <button type="submit">Post</button>
    </form>
  </div>
  
  
  <div class="feed">
  
  
    <div class="post">
      <h4>Team InnovateX</h4>
      <p><b>Have:</b> Frontend (React), UI Design</p>
      <p><b>Need:</b> Backend Dev (Node.js)</p>
      <p><b>Info:</b> Building a hackathon project on AI-based productivity tools.</p>
      <p class="post-time">Posted 2 hours ago</p>
    </div>

    <div class="post">
      <h4>Team QuantumBits</h4>
      <p><b>Have:</b> Python, AI/ML</p>
      <p><b>Need:</b> Web Developer (Flask/React)</p>
      <p><b>Info:</b> Working on healthcare diagnostics using ML.</p>
      <p class="post-time">Posted 5 hours ago</p>
    </div>

    <!-- Later dynamically generated posts will appear here -->
    <p class="no-posts">All team posts will be visible here. No filters yet — will be added later 😎</p>
  </div>
</div>
<script>
  function toggleForm() {
    const form = document.getElementById("formBox");
    form.style.display = form.style.display === "block" ? "none" : "block";
  }
</script>
</body>
</html>