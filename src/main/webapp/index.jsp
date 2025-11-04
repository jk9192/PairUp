<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PairUp</title>
<style>
 body {
            font-family:Comic Sans MS, Comic Sans, cursive;
            background: #F5F5DC;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
   .container{
   			text-align: center;
   			background: white;
   			padding: 50px;
   			border-radius: 20px;
   			box-shadow:0 4px 20px rgba(0,0,0,0.1);
   			width: 350px;
   }     
   
   
 	
 	h2{
 	color:#6A5ACD; 
 	margin-bottom: 30px;
 	}
   
   
   
   .btn{
   display: block;
   text-decoration: none;
   background: #007bff;
   color: white;
   padding: 12px 0;
   border-radius: 10px;
   margin: 10px 0;
   transition: 0.3s;
   
   }
   .btn:hover {
    background: #0056b3;
}
.logo{
max-width:100%;
 height: auto;
  
}
</style>
</head>
<body>
   <div class="container">
   <img class="logo" src="logo.png" alt="Logo of PairUp">
   <h2>Find your perfect coding partner and grow together</h2>
   <a href="login.jsp" class="btn">Login</a>
   <a href="signup.jsp" class="btn" style="background:#28a745";>SignUp</a>
   
   </div>
</body>
</html>