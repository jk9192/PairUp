<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="com.yourpackage.PairProfile" %>
<%@ page import="com.google.gson.Gson" %>
<%
    session = request.getSession(false);
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    
    
    
    Object attr = request.getAttribute("showPairs");
    boolean showPairs = false; // default to false
    if (attr instanceof Boolean) {
        showPairs = (Boolean) attr;
    }

    // Optional: also check URL parameter
    String qp = request.getParameter("showPairs");
    if ("true".equalsIgnoreCase(qp)) {
        showPairs = true;
    }

    
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>PairUp</title>

<!-- Font Awesome -->
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
    display: none;
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

.pair-container {
    margin-top: 30px;
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
    gap: 20px;
    padding: 20px 40px;
}

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

.buttons {
    margin-top: 10px;
    display: flex;
    justify-content: center;
    gap: 10px;
}

.view-btn {
    padding: 6px 12px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
    background: #007bff;
    color: white;
}

.view-btn:hover {
    background: #0056b3;
}

/* ---------- Tinder-style Feed ---------- */
#tinderContainer {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

#profileCard {
    width: 300px;
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
    text-align: center;
    padding: 20px;
    position: relative;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

#profileCard:hover {
    transform: translateY(-5px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.25);
}

#profileCard img {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    border: 3px solid #D8BFD8;
    object-fit: cover;
    margin-bottom: 15px;
}

#profileCard h3 {
    margin: 5px 0;
    color: #333;
}

#profileCard p {
    color: #666;
    font-size: 14px;
    margin: 5px 0 15px;
}

/* Tinder Buttons */
#profileCard .buttons {
    display: flex;
    justify-content: center;
    gap: 15px;
}

#profileCard .buttons button {
    padding: 10px 15px;
    font-size: 18px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    transition: transform 0.2s ease;
}

#acceptBtn {
    background: #FF6B6B; /* ❤️ */
    color: white;
}

#skipBtn {
    background: #A9A9A9; /* ❌ */
    color: white;
}

#acceptBtn:hover {
    transform: scale(1.1);
    background: #FF4C4C;
}

#skipBtn:hover {
    transform: scale(1.1);
    background: #888;
}

</style>
</head>

<body>
  <!-- Navbar -->
  <nav>
    <img class="logo" src="navlogo.png" alt="PairUp logo">
    <div>
      <a href="welcome.jsp">Home</a>
      <a href="search.jsp">Search <i class="fas fa-search"></i></a>
      <a href="ProfileServlet?mode=view">Profile</a>
      <a href="MyPairsServlet">PairUp</a>
      <a href="groups.jsp">Groups</a>
      <a href="hacksearch.jsp">HackSearch</a>
      <a href="notifications.jsp"><i class="fa-solid fa-bell" style="font-size:20px; cursor:pointer;"></i></a>
      <a href="LogoutServlet" class="logout">Logout</a>
    </div>
  </nav>

  <!-- Main Container -->
  <div class="container">
    <div class="btn">
     <button id="feedBtn"onclick="window.location.href='FindCodingBuddyServlet'">Find Your Coding Buddy</button>

      <button id="pairsBtn"onclick="window.location.href='MyPairsServlet'">My Pairs</button>

    </div>

    <!-- Feed Section -->
   <div id="feedSection" class="section active">
  <h2>Find Your Coding Buddy</h2>
  <div id="tinderContainer">
    <% 
       List<PairProfile> profiles = (List<PairProfile>) request.getAttribute("swipeProfiles");
       if(profiles != null && !profiles.isEmpty()) { 
    %>
        <div id="profileCard">
    <img id="profilePic" src="defaultpic.png"/>
    <h3 id="profileName">Loading...</h3>
    <p id="profileSkills">Loading skills...</p>

    <div class="buttons">
    <form action="PairRequestServlet" method="post">
        <input type="hidden" name="receiverProfileId" id="receiverId" value="">
        <button type="submit" id="acceptBtn">❤️ Pair Up</button>
    </form>

    <form action="SkipProfileServlet" method="post">
        <input type="hidden" name="skipId" id="skipId" value="">
        <button type="submit" id="skipBtn">❌ Skip</button>
    </form>
</div>

</div>
    <% } else { %>
        <p>No profiles available for now.</p>
    <% } %>
  </div>
</div>

    <!-- My Pairs Section -->
    <div id="pairsSection" class="section">
      <h2>My Pairs</h2>
      <div class="pair-container">
        <%
          List<PairProfile> myPairs = (List<PairProfile>) request.getAttribute("myPairsList");
          if (myPairs == null || myPairs.isEmpty()) {
        %>
          <p style="grid-column: 1 / -1; text-align:center;">You have no paired profiles yet.</p>
        <%
          } else {
            for (PairProfile user : myPairs) {
        %>
          <div class="profile-card">
            <img src="<%= user.getProfilePicture() != null ? user.getProfilePicture() : "defaultpic.png" %>" />
            <h3><%= user.getName() %></h3>
            <p><strong>Email:</strong> <%= user.getEmail() %></p>
            <p><strong>Skills:</strong> <%= user.getSkills() %></p>
            <div class="buttons">
              <form action="ViewProfileServlet" method="get">
                <input type="hidden" name="profileId" value="<%= user.getProfileId() %>">
                <button type="submit" class="view-btn">View Profile</button>
              </form>
            </div>
          </div>
        <%
            }
          }
        %>
      </div>
    </div>
  </div>
<%
List<PairProfile> swipeProfiles = (List<PairProfile>) request.getAttribute("swipeProfiles");
if (swipeProfiles == null) swipeProfiles = new java.util.ArrayList<>();
String swipeJson = new com.google.gson.Gson().toJson(swipeProfiles);
%>
<script>
document.addEventListener("DOMContentLoaded", () => {

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

    // showPairs boolean from backend
    const showPairs = <%= showPairs ? "true" : "false" %>;

    if(showPairs) {
        feedSection.classList.remove("active");
        pairsSection.classList.add("active");
    }

    const profiles = <%= swipeJson %>;
    let index = 0;

    if(profiles.length === 0) {
        document.getElementById("tinderContainer").innerHTML =
            "<p style='text-align:center;'>No more profiles!</p>";
        return;
    }

    const profilePic = document.getElementById("profilePic");
    const profileName = document.getElementById("profileName");
    const profileSkills = document.getElementById("profileSkills");
    const receiverInput = document.getElementById("receiverId");
    const skipInput = document.getElementById("skipId");

    // ---------------------------
    // UPDATE PROFILE CARD FUNCTION
    // ---------------------------
    const updateCard = () => {
        if(index >= profiles.length) {
            document.getElementById("tinderContainer").innerHTML =
                "<p style='text-align:center;'>No more profiles!</p>";
            return;
        }

        const p = profiles[index];

        // SEND CORRECT RECEIVER ID TO SERVLETS
        receiverInput.value = p.profileId;
        skipInput.value = p.profileId;

        profilePic.src = (p.profilePicture && p.profilePicture.trim() !== "")
                         ? p.profilePicture
                         : "defaultpic.png";

        profileName.innerText = p.name;
        profileSkills.innerText = p.skills;
    };

    // -------------------------
    // BUTTON ACTIONS (NO FETCH)
    // -------------------------
   document.getElementById("skipBtn").addEventListener("click", (e) => {
    e.preventDefault(); // stop form submission
    index++;
    updateCard();
    e.target.closest("form").submit();
});

    // FIRST CARD LOAD

</script>


</body>
</html>
