<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pairup", "root", "root");
    PreparedStatement ps = con.prepareStatement(
        "SELECT skills, bio, profile_picture, college FROM profile_characteristics WHERE user_id = (SELECT id FROM users WHERE email = ?)"
    );
    ps.setString(1, userEmail);
    ResultSet rs = ps.executeQuery();

    String skills = "", bio = "", profile_picture = "", college = "";
    if (rs.next()) {
        skills = rs.getString("skills") != null ? rs.getString("skills") : "";
        bio = rs.getString("bio") != null ? rs.getString("bio") : "";
        profile_picture = rs.getString("profile_picture") != null ? rs.getString("profile_picture") : "";
        college = rs.getString("college") != null ? rs.getString("college") : "";
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Select2 CSS -->
<link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />

<!-- Select2 JS -->
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

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
input[type="text"], textarea, select {
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
.select2-selection {
  border-radius: 10px !important;
  padding: 4px !important;
}

.select2-selection__rendered {
  font-family: "Comic Sans MS" !important;
}
 
    input, button {
  font-family: Comic Sans MS, Comic Sans, cursive;
}

::placeholder {
  font-family: Comic Sans MS, Comic Sans, cursive;
  font-size:13px;
}
.save-btn:hover { background-color: #0056b3; }
</style>
</head>
<body>
<nav>
  <div style="font-size:22px; font-weight:bold; color:#444;">PairUp 💻</div>
  <div>
    <a href="welcome.jsp">Home</a>
    <a href="profile.jsp">Profile</a>
    <a href="MyPairsServlet">PairUp</a>
    <a href="groups.jsp">Groups</a>
    <a href="hacksearch.jsp">HackSearch</a>
    <a href="LogoutServlet" class="logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h2>Edit Your Profile</h2>
  <form action="ProfileServlet" method="post">

    <label><b>Skills / Current Focus:</b></label>
    <select id="skills" name="skills" multiple class="skill-select" style="width:100%;">
      <option value="C">C</option> <option value="C++">C++</option> <option value="Java">Java</option> <option value="Python">Python</option> <option value="JavaScript">JavaScript</option> <option value="TypeScript">TypeScript</option> <option value="Go">Go</option> <option value="Rust">Rust</option> <option value="Kotlin">Kotlin</option> <option value="Swift">Swift</option> <option value="HTML">HTML</option> <option value="CSS">CSS</option> <option value="React">React</option> <option value="Angular">Angular</option> <option value="Vue.js">Vue.js</option> <option value="Next.js">Next.js</option> <option value="Tailwind CSS">Tailwind CSS</option> <option value="Bootstrap">Bootstrap</option> <option value="Node.js">Node.js</option> <option value="Express.js">Express.js</option> <option value="Django">Django</option> <option value="Flask">Flask</option> <option value="Spring Boot">Spring Boot</option> <option value="Laravel">Laravel</option> <option value="Ruby on Rails">Ruby on Rails</option> <option value="ASP.NET">ASP.NET</option> <option value="MERN Stack">MERN Stack</option> <option value="MEAN Stack">MEAN Stack</option> <option value="PERN Stack">PERN Stack</option> <option value="Android (Java / Kotlin)">Android (Java / Kotlin)</option> <option value="iOS (Swift / Objective-C)">iOS (Swift / Objective-C)</option> <option value="Flutter">Flutter</option> <option value="React Native">React Native</option> <option value="Xamarin">Xamarin</option> <option value="Problem Solving">Problem Solving</option> <option value="Competitive Programming">Competitive Programming</option> <option value="System Design Basics">System Design Basics</option> <option value="Machine Learning">Machine Learning</option> <option value="Deep Learning">Deep Learning</option> <option value="NLP">NLP</option> <option value="Computer Vision">Computer Vision</option> <option value="Data Science">Data Science</option> <option value="AI Engineering">AI Engineering</option> <option value="AWS">AWS</option> <option value="Google Cloud (GCP)">Google Cloud (GCP)</option> <option value="Microsoft Azure">Microsoft Azure</option> <option value="Docker">Docker</option> <option value="Kubernetes">Kubernetes</option> <option value="Jenkins">Jenkins</option> <option value="Terraform">Terraform</option> <option value="CI/CD Pipelines">CI/CD Pipelines</option> <option value="MySQL">MySQL</option> <option value="PostgreSQL">PostgreSQL</option> <option value="MongoDB">MongoDB</option> <option value="SQLite">SQLite</option> <option value="Redis">Redis</option> <option value="Firebase">Firebase</option> <option value="Ethical Hacking">Ethical Hacking</option> <option value="Network Security">Network Security</option> <option value="Web Application Security">Web Application Security</option> <option value="Penetration Testing">Penetration Testing</option> <option value="Figma">Figma</option> <option value="Adobe XD">Adobe XD</option> <option value="UI Prototyping">UI Prototyping</option> <option value="Design Thinking">Design Thinking</option> <option value="Unity">Unity</option> <option value="Unreal Engine">Unreal Engine</option> <option value="Godot">Godot</option> <option value="C# for Games">C# for Games</option> <option value="Blockchain / Web3">Blockchain / Web3</option> <option value="IoT">IoT</option> <option value="AR / VR">AR / VR</option> <option value="Robotics">Robotics</option> <option value="Automation (Selenium, RPA)">Automation (Selenium, RPA)</option>
    </select>

    <label>Bio:</label>
    <textarea name="bio"><%= bio %></textarea>

    <label>Profile Picture URL:</label>
    <input type="text" name="profile_picture" value="<%= profile_picture %>">

    <label>College:</label>
    <select name="college" id="college" required>
     <option value="IIT Bombay">IIT Bombay</option> <option value="IIT Delhi">IIT Delhi</option> <option value="IIT Madras">IIT Madras</option> <option value="IIT Kanpur">IIT Kanpur</option> <option value="IIT Kharagpur">IIT Kharagpur</option> <option value="IIT Roorkee">IIT Roorkee</option> <option value="IIT Guwahati">IIT Guwahati</option> <option value="IIT Hyderabad">IIT Hyderabad</option> <option value="IIT BHU (Varanasi)">IIT BHU (Varanasi)</option> <option value="IIT Indore">IIT Indore</option> <option value="IIT Ropar">IIT Ropar</option> <option value="IIT Gandhinagar">IIT Gandhinagar</option> <option value="IIT Jodhpur">IIT Jodhpur</option> <option value="IIT Patna">IIT Patna</option> <option value="IIT Mandi">IIT Mandi</option> <option value="IIT Bhubaneswar">IIT Bhubaneswar</option> <option value="IIT Palakkad">IIT Palakkad</option> <option value="IIT Tirupati">IIT Tirupati</option> <option value="IIT Dhanbad (ISM)">IIT Dhanbad (ISM)</option> <option value="IIT Goa">IIT Goa</option> <option value="IIT Jammu">IIT Jammu</option> <option value="IIT Dharwad">IIT Dharwad</option> <option value="IIT (ISM) Dhanbad">IIT (ISM) Dhanbad</option> <!-- ================== NITs ================== --> <option value="NIT Trichy">NIT Trichy</option> <option value="NIT Surathkal">NIT Surathkal</option> <option value="NIT Warangal">NIT Warangal</option> <option value="NIT Rourkela">NIT Rourkela</option> <option value="NIT Calicut">NIT Calicut</option> <option value="NIT Allahabad">NIT Allahabad</option> <option value="NIT Durgapur">NIT Durgapur</option> <option value="NIT Kurukshetra">NIT Kurukshetra</option> <option value="NIT Jaipur">NIT Jaipur</option> <option value="NIT Nagpur">NIT Nagpur</option> <option value="NIT Bhopal">NIT Bhopal</option> <option value="NIT Silchar">NIT Silchar</option> <option value="NIT Meghalaya">NIT Meghalaya</option> <option value="NIT Agartala">NIT Agartala</option> <option value="NIT Hamirpur">NIT Hamirpur</option> <option value="NIT Arunachal Pradesh">NIT Arunachal Pradesh</option> <option value="NIT Manipur">NIT Manipur</option> <option value="NIT Mizoram">NIT Mizoram</option> <option value="NIT Nagaland">NIT Nagaland</option> <option value="NIT Puducherry">NIT Puducherry</option> <option value="NIT Sikkim">NIT Sikkim</option> <option value="NIT Srinagar">NIT Srinagar</option> <option value="NIT Delhi">NIT Delhi</option> <option value="NIT Goa">NIT Goa</option> <option value="NIT Uttarakhand">NIT Uttarakhand</option> <option value="NIT Jalandhar">NIT Jalandhar</option> <option value="NIT Raipur">NIT Raipur</option> <option value="NIT Patna">NIT Patna</option> <option value="NIT Arunachal">NIT Arunachal</option> <option value="NIT Andaman and Nicobar Islands">NIT Andaman and Nicobar Islands</option> <!-- ================== IIITs ================== --> <option value="IIIT Hyderabad">IIIT Hyderabad</option> <option value="IIIT Allahabad">IIIT Allahabad</option> <option value="IIIT Delhi">IIIT Delhi</option> <option value="IIIT Bangalore">IIIT Bangalore</option> <option value="IIIT Gwalior">IIIT Gwalior</option> <option value="IIIT Guwahati">IIIT Guwahati</option> <option value="IIIT Kota">IIIT Kota</option> <option value="IIIT Vadodara">IIIT Vadodara</option> <option value="IIIT Kottayam">IIIT Kottayam</option> <option value="IIIT Lucknow">IIIT Lucknow</option> <option value="IIIT Pune">IIIT Pune</option> <option value="IIIT Una">IIIT Una</option> <option value="IIIT Sri City">IIIT Sri City</option> <option value="IIIT Sonepat">IIIT Sonepat</option> <option value="IIIT Manipur">IIIT Manipur</option> <option value="IIIT Nagpur">IIIT Nagpur</option> <option value="IIIT Bhagalpur">IIIT Bhagalpur</option> <option value="IIIT Bhopal">IIIT Bhopal</option> <option value="IIIT Ranchi">IIIT Ranchi</option> <option value="IIIT Dharwad">IIIT Dharwad</option> <option value="IIIT Kalyani">IIIT Kalyani</option> <option value="IIIT Tiruchirappalli">IIIT Tiruchirappalli</option> <option value="IIIT Surat">IIIT Surat</option> <option value="IIIT Agartala">IIIT Agartala</option> <option value="IIIT Raichur">IIIT Raichur</option> <!-- ================== GGSIPU and Affiliated Colleges ================== --> <option value="Guru Gobind Singh Indraprastha University">Guru Gobind Singh Indraprastha University (Main Campus)</option> <option value="Maharaja Agrasen Institute of Technology">Maharaja Agrasen Institute of Technology (MAIT)</option> <option value="Bharati Vidyapeeth's College of Engineering">Bharati Vidyapeeth's College of Engineering (BVCOE)</option> <option value="Bhagwan Parshuram Institute of Technology">Bhagwan Parshuram Institute of Technology (BPIT)</option> <option value="Maharaja Surajmal Institute of Technology">Maharaja Surajmal Institute of Technology (MSIT)</option> <option value="Guru Tegh Bahadur Institute of Technology">Guru Tegh Bahadur Institute of Technology (GTBIT)</option> <option value="HMR Institute of Technology and Management">HMR Institute of Technology and Management</option> <option value="Northern India Engineering College">Northern India Engineering College (NIEC)</option> <option value="Ambedkar Institute of Advanced Communication Technologies and Research">Ambedkar Institute of Advanced Communication Technologies and Research (AIACTR)</option> <option value="BITS Pilani">BITS Pilani</option> <option value="BITS Goa">BITS Goa</option> <option value="BITS Hyderabad">BITS Hyderabad</option> <option value="VIT Vellore">VIT Vellore</option> <option value="VIT Chennai">VIT Chennai</option> <option value="SRM University">SRM University</option> <option value="Amity University">Amity University</option> <option value="Galgotias University">Galgotias University</option> <option value="Shiv Nadar University">Shiv Nadar University</option> <option value="Lovely Professional University">Lovely Professional University (LPU)</option> <option value="Chandigarh University">Chandigarh University</option> <option value="MIT-WPU Pune">MIT-WPU Pune</option> <option value="Thapar Institute of Engineering and Technology">Thapar Institute of Engineering and Technology</option> <option value="Manipal University">Manipal University</option> <option value="Symbiosis Institute of Technology">Symbiosis Institute of Technology</option> <option value="Other">Other</option>
    </select>

    <button type="submit" class="save-btn">Save Changes</button>
  </form>
</div>

<script>
$(document).ready(function() {
  $('#skills').select2({
      tags: true,
      tokenSeparators: [','],
      placeholder: "Select or type skills",
      width: '100%'
  });

  let storedSkills = "<%= skills %>";
  if (storedSkills.trim() !== "") {
      let skillArray = storedSkills.split(",").map(s => s.trim());
      skillArray.forEach(skill => {
          if ($("#skills option[value='" + skill + "']").length === 0) {
              $('#skills').append(new Option(skill, skill, true, true));
          }
      });
      $('#skills').val(skillArray).trigger('change');
  }

  $('#college').select2({
	    placeholder: "Search or select your college",
	    width: '100%'
	});

	// Set saved value
	$("#college").val("<%= college %>").trigger('change');
});
</script>

</body>
</html>
