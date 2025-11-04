<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>

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
input {
    width: 100%;
    padding: 12px;
    margin: 8px 0;
    border: 1px solid #ccc;
    border-radius: 8px;
    outline: none;
    font-size: 15px;
    transition: 0.2s;
}
input:focus {
    border-color: #007bff;
}


.btn {
    padding: 12px;
    font-size: 16px;
    border-radius: 10px;
    color: white;
    border: none;
    background: #28a745;
    cursor: pointer;
    transition: 0.3s;
    margin-top: 10px;
    width: 100%;
}
.btn:hover {
    background: #218838;
}

.signup-link {
    color: #6A5ACD;
    display: block;
    text-decoration: none;
    font-size: 14px;
    margin-top: 20px;
}
.signup-link:hover {
    text-decoration: underline;
}
.error {
    color: red;
    font-size: 14px;
    margin-bottom: 10px;
}
</style>
</head>
<body>
<div class="container">

<h1>Welcome Back !</h1>
<% 
   String error = request.getParameter("error"); 
   if (error != null) { 
%>
    <p class="error"><%= error %></p>
<% 
   } 
%>
<form action="LoginServlet"  method="post">
<input type="text" name="email" placeholder="Email" required>
<input type="text" name="password"  placeholder="Password" required>
 <button type="submit" class="btn">Login</button>
</form>

   <a href="signup.jsp" class="signup-link">Don't have an account? Sign up</a>
</div>


</body>
</html>