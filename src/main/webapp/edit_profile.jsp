<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");
    PreparedStatement ps = con.prepareStatement(
        "SELECT skills FROM profile_characteristics WHERE user_id = (SELECT id FROM users WHERE email = ?)"
    );
    ps.setString(1, userEmail);
    ResultSet rs = ps.executeQuery();
    String skills = "";
    if (rs.next()) {
        skills = rs.getString("skills");
        if (skills == null) skills = "";
    }
    rs.close();
    ps.close();
    con.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Profile</title>
<style>
body {
  font-family: "Comic Sans MS", cursive;
  background-color: #f8f9fa;
  margin: 0;
}
nav {
  background: #D8BFD8;
  padding: 15px 40px;
  display: flex;
  justify-content: space-between;
}
nav a { text-decoration: none; color: #333; margin-right: 25px; }
.logout { color: #e63946; font-weight: bold; }
.container {
  width: 70%;
  margin: 40px auto;
  background: white;
  padding: 40px;
  border-radius: 15px;
  box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
input[type="text"], textarea {
  width: 100%;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 10px;
  margin-top: 8px;
  font-family: "Comic Sans MS";
}
.save-btn {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 12px 25px;
  border-radius: 20px;
  margin-top: 20px;
  cursor: pointer;
}
.save-btn:hover { background-color: #0056b3; }
.skills-input-container {
  min-height: 50px;
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
  gap: 8px;
  border: 1px solid #ccc;
  border-radius: 10px;
  padding: 10px;
  background-color: #fff;
}
#skillsList {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  width: 100%;
  margin-bottom: 5px;
}
.skill-tag {
  background-color: #007bff;
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 14px;
  display: inline-flex;
  align-items: center;
  margin: 3px;
}
.skill-tag span {
  margin-left: 8px;
  cursor: pointer;
  font-weight: bold;
}
.hint {
  font-size: 13px;
  color: gray;
  margin-top: 5px;
  margin-bottom: 10px;
  font-style: italic;
}
</style>
</head>
<body>
<nav>
  <div style="font-size:22px; font-weight:bold; color:#444;">PairUp 💻</div>
  <div>
    <a href="welcome.jsp">Home</a>
    <a href="profile.jsp">Profile</a>
    <a href="pairup.jsp">PairUp</a>
    <a href="groups.jsp">Groups</a>
    <a href="hacksearch.jsp">HackSearch</a>
    <a href="LogoutServlet" class="logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h2>Edit Your Profile</h2>
  <form action="ProfileServlet" method="post">
    <label>Current Focus:</label>
    <input type="text" name="current_focus" value="${current_focus}">

    <label>Skills:</label>
    <div class="skills-input-container">
      <div id="skillsList"></div>
      <input type="text" id="skillInput" placeholder="Type a skill and press Enter">
      <input type="hidden" name="skills" id="skillsHidden">
    </div>
    <div class="hint">💡 Type a skill and press Enter. You can remove any skill by clicking ×.</div>

    <label>Bio:</label>
    <textarea name="bio">${bio}</textarea>

    <label>Profile Picture URL:</label>
    <input type="text" name="profile_picture" value="${profile_picture}">

    <button type="submit" class="save-btn">Save Changes</button>
  </form>
</div>

<script>
document.addEventListener("DOMContentLoaded", () => {
  const skillInput = document.getElementById("skillInput");
  const skillsList = document.getElementById("skillsList");
  const skillsHidden = document.getElementById("skillsHidden");

  let existingSkills = "<%= skills != null ? skills.trim() : "" %>";
  console.log("Existing skills raw from server:", existingSkills);

  let skills = [];
  if (existingSkills && existingSkills.length > 0) {
    skills = existingSkills.split(",").map(s => s.trim()).filter(s => s !== "");
  }
  console.log("Skills array after split:", skills);

  function addSkill(skill) {
	  if (!skill || skillsList.querySelector(`[data-skill='${skill}']`)) return;

	  const tag = document.createElement("div");
	  tag.className = "skill-tag";
	  tag.dataset.skill = skill;

	  // 🟦 Properly styled text and remove icon
	  const textSpan = document.createElement("span");
	  textSpan.textContent = skill;
	  textSpan.style.color = "white";
	  textSpan.style.fontWeight = "500";

	  const remove = document.createElement("span");
	  remove.textContent = " ×";
	  remove.style.marginLeft = "8px";
	  remove.style.cursor = "pointer";
	  remove.style.fontWeight = "bold";

	  tag.appendChild(textSpan);
	  tag.appendChild(remove);

	  // 🔹 Apply solid blue background to make text visible
	  tag.style.backgroundColor = "#007bff";
	  tag.style.padding = "6px 12px";
	  tag.style.borderRadius = "20px";
	  tag.style.margin = "3px";
	  tag.style.fontSize = "14px";
	  tag.style.display = "inline-flex";
	  tag.style.alignItems = "center";

	  skillsList.appendChild(tag);

	  remove.addEventListener("click", () => {
	    tag.remove();
	    skills = skills.filter(s => s !== skill);
	    skillsHidden.value = skills.join(",");
	  });

	  if (!skills.includes(skill)) skills.push(skill);
	  skillsHidden.value = skills.join(",");
	}


  // 🟦 Render all existing skills after DOM is ready
  window.addEventListener("load", () => {
    console.log("Rendering all existing skills now...");
    skills.forEach(skill => {
      console.log("Rendering skill:", skill);
      addSkill(skill);
    });
  });

  // Add skill with Enter key
  skillInput.addEventListener("keydown", (e) => {
    if (e.key === "Enter" && skillInput.value.trim() !== "") {
      e.preventDefault();
      addSkill(skillInput.value.trim());
      skillInput.value = "";
    }
  });

  // Sync hidden input before form submit
  const form = document.querySelector("form");
  form.addEventListener("submit", () => {
    const lastTyped = skillInput.value.trim();
    if (lastTyped !== "") addSkill(lastTyped);
    skillsHidden.value = skills.join(",");
  });
});
</script>

</body>
</html>
