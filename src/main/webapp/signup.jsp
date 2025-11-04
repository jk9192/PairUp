<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SignUp</title>
<style>

  body{
       font-family:Comic Sans MS, Comic Sans, cursive;
        background: #F5F5DC;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    input, button {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

::placeholder {
  font-family: Comic Sans MS, Comic Sans, cursive;
}
    .container {
    background: white;
    padding: 40px 50px;
    border-radius: 20px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    width: 400px;
    text-align: center;
}

h1 {
    color: #D2691E;
    margin-bottom: 20px;
}


input {
    width: 100%;
   padding: 12px;
    margin: 8px 0;
     border: 1px solid #ccc;
     border-radius:8px;
      outline: none;
      font-size: 15px;
      transition: 0.2s;
    }
    input:focus{
    border-color: #007bff;
    }
    
    .btn{
    	padding: 12px;
    	font-size:16px;
   	border-radius: 10px;
   	color: white;
    border: none;
    background: #28a745;
    cursor: pointer;
    transition: 0.3s;
    margin-top: 10px;
    width: 100%;
    }
    
    .btn:hover{
    background:#218838;}
    
    
    .login-link{
      color: #6A5ACD;
      display: block;
      text-decoration: none;
      font-size: 14px;
      margin-top:20px;
    }
    
    .login-link:hover{
    text-decoration: underline;}
    </style>
    
</head>
<body>

	<div class="container" >
	<h1>Create Your Account</h1>
	<form action="SignupServlet" method="post">
	<input type="text" name="name" placeholder="Full Name" required>
	<input type="text" name="email" placeholder="Email" required>
	<input type="text" name="pass" placeholder="Password" required>
	<button type="submit" class="btn">Sign Up</button>
	</form>
	
	<a href="login.jsp" class="login-link">Already have an account? Login</a>
	</div>
</body>
</html>