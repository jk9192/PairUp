<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link
  rel="stylesheet"
  href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css"
/>

<meta charset="UTF-8">
<title>Search</title>
<style>
 body {
    margin: 0;
    font-family: "Comic Sans MS", cursive;
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
  .logo{
  height: 40px;
  width:auto;
   object-fit: contain;
    border-radius: 6px; 
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
            <a href="pairup.jsp">PairUp</a>
            <a href="groups.jsp">Groups</a>
            <a href="hacksearch.jsp">HackSearch</a>
            <a href="LogoutServlet" class="logout">Logout</a>
            
        </div>
</nav>


<div class="search-bar">
<input type="text" name="search-field">
<button>Search<i class="fas fa-search"></i></button>
</div>

<div class="container">

</div>



</body>
</html>