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
<title>PairUp</title>

<!-- Font Awesome for icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">

<style>
  /* ---------- Global ---------- */
  body {
    margin: 0;
    font-family: "Comic Sans MS", "Comic Sans", cursive;
    background-color: #f8f9fa;
  }

  /* ---------- Navbar ---------- */
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

  .logout {
    color: #e63946 !important;
    font-weight: bold;
  }

  .logo {
    height: 40px;
    width: auto;
    object-fit: contain;
    border-radius: 6px;
  }

  /* ---------- Buttons ---------- */
  button {
    background: #A0522D;
    color: white;
    font-size: 16px;
    padding: 10px 15px;
    border-radius: 10px;
    border: none;
    cursor: pointer;
    transition: 0.3s;
  }

  button:hover {
    background: #D8BFD8;
    color: black;
  }

  .btn {
    width: 50%;
    display: flex;
    justify-content: center;
    gap: 20px;
    margin: 30px auto;
  }

  /* ---------- Page Container ---------- */
  .container {
    width: 60%;
    margin: 0 auto;
    text-align: center;
  }

  /* ---------- Section Styling ---------- */
  .section {
    display: none; /* hidden by default */
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    padding: 20px;
    margin-top: 20px;
    text-align: left;
  }

  .section.active {
    display: block;
    animation: fadeIn 0.4s ease;
  }

  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
  }

  /* ---------- Post Box ---------- */
  .post-box {
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

  /* ---------- Feed Posts ---------- */
  .post {
    background-color: #fafafa;
    border-radius: 10px;
    box-shadow: 0 1px 6px rgba(0,0,0,0.1);
    padding: 15px;
    margin-bottom: 15px;
  }

  .post h4 {
    margin: 0;
    color: #007bff;
  }

  .post p {
    margin: 5px 0 0;
    color: #333;
  }

  .post-time {
    font-size: 12px;
    color: gray;
    margin-top: 5px;
  }
   input, button {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

::placeholder {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

.feed-content {
  display: none;
}

.feed-content.active {
  display: block;
  animation: fadeIn 0.4s ease;
}

</style>
</head>

<body>
  <!-- ---------- Navbar ---------- -->
  <nav>
    <img class="logo" src="navlogo.png" alt="PairUp logo">
    <div>
      <a href="welcome.jsp">Home</a>
      <a href="search.jsp">Search <i class="fas fa-search"></i></a>
      <a href="ProfileServlet?mode=view">Profile</a>
      <a href="pairup.jsp">PairUp</a>
      <a href="groups.jsp">Groups</a>
      <a href="hacksearch.jsp">HackSearch</a>
      <a href="notifications.jsp"><i class="fa-solid fa-bell" style="font-size:20px; cursor:pointer;"></i></a>
      <a href="LogoutServlet" class="logout">Logout</a>
    </div>
  </nav>

  <!-- ---------- Main Container ---------- -->
  <div class="container">
    <div class="btn">
      <button id="feedBtn">Find Your Coding Buddy</button>
      <button id="pairsBtn">My Pairs</button>
    </div>

    <!-- ---------- Feed Section ---------- -->
    <div id="feedSection" class="section active">
      <div class="post-box">
        <input type="text" class="post-input" placeholder="Share what you're looking for...">
        <button class="post-btn">Post</button>
      </div>
		
      <div class="feed-toggle">
    <button id="allFeedBtn" class="active">All Feed</button>
    <button id="matchedFeedBtn">Matched Feed</button>
  </div>
  

    
	    <div id="allFeed" class="feed-content active">	
      <div class="post">
        <h4>@coderJay</h4>
        <p>Looking for someone to practice DSA daily with! 💻</p>
        <div class="post-time">2 hours ago</div>
      </div>

      <div class="post">
        <h4>@neha_23</h4>
        <p>Anyone up for a weekend project collab?</p>
        <div class="post-time">5 hours ago</div>
      </div>  
      </div>
      
      
        <div id="matchedFeed" class="feed-content">
    <div class="post">
      <h4>@ritesh_ai</h4>
      <p>Looking for a React + Node.js partner 🔥</p>
      <div class="post-time">1 day ago</div>
    </div>

    <div class="post">
      <h4>@tanisha_code</h4>
      <p>Searching for someone good in DSA + Java 🤝</p>
      <div class="post-time">3 days ago</div>
    </div>
  </div>
  
    </div>

    <!-- ---------- My Pairs Section ---------- -->
    <div id="pairsSection" class="section">
      <h2>My Pairs</h2>

      <div class="post">
        <h4>👩‍💻 @Ritika</h4>
        <p>Paired for Java project sprint 🚀</p>
        <div class="post-time">Since Oct 2025</div>
      </div>

      <div class="post">
        <h4>👨‍💻 @Arjun</h4>
        <p>DSA 30-Day Challenge Partner 🧩</p>
        <div class="post-time">Since Sep 2025</div>
      </div>
    </div>
  </div>

  <!-- ---------- JavaScript for Section Toggle ---------- -->
  <script>
    const feedBtn = document.getElementById("feedBtn");
    const pairsBtn = document.getElementById("pairsBtn");
    const feedSection = document.getElementById("feedSection");
    const pairsSection = document.getElementById("pairsSection");

    feedBtn.addEventListener("click", () => {
      feedSection.classList.add("active");
      pairsSection.classList.remove("active");
    });

    pairsBtn.addEventListener("click", () => {
      pairsSection.classList.add("active");
      feedSection.classList.remove("active");
    });
    
    
    const allFeedBtn = document.getElementById("allFeedBtn");
    const matchedFeedBtn = document.getElementById("matchedFeedBtn");
    const allFeed = document.getElementById("allFeed");
    const matchedFeed = document.getElementById("matchedFeed");
    
    allFeedBtn.addEventListener("click", () => {
    	  allFeedBtn.classList.add("active");
    	  matchedFeedBtn.classList.remove("active");
    	  allFeed.classList.add("active");
    	  matchedFeed.classList.remove("active");
    	});

    	matchedFeedBtn.addEventListener("click", () => {
    	  matchedFeedBtn.classList.add("active");
    	  allFeedBtn.classList.remove("active");
    	  matchedFeed.classList.add("active");
    	  allFeed.classList.remove("active");
    	});
  </script>

</body>
</html>
