import java.io.File;

public class User {
	private int userId;
	private String username;
	private File profilePic;
	private String description;
	private boolean isAdmin;
	
	
	public int getUserId() {
		return userId;
	}
	
	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public String getUsername() {
		return username;
	}
	
	public void setUsername(String username) {
		this.username = username;
	}
	
	public File getProfilePic() {
		return profilePic;
	}
	
	public void setProfilePic(File profilePic) {
		this.profilePic = profilePic;
	}
	
	public String getDescription() {
		return description;
	}
	
	public void setDescription(String description) {
		this.description = description;
	}
	
	public boolean isAdmin() {
		return isAdmin;
	}
	
	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
}