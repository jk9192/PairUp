package com.yourpackage;

public class PairProfile {
    private int profileId;
    private String name;
    private String email;
    private String skills;
    private String profilePicture; 

    
    public PairProfile(int profileId, String name, String email, String skills, String profilePicture) {
        this.profileId = profileId;
        this.name = name;
        this.email = email;
        this.skills = skills;
        this.profilePicture = profilePicture;
    }

    // getters
    public int getProfileId() { return profileId; }
    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getSkills() { return skills; }
    public String getProfilePicture() { return profilePicture; }
}
