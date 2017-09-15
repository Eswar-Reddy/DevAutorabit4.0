public class communityChangePassword {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword() {
        Site.changePassword(newPassword, verifyNewPassword, oldpassword); 
        PageReference p = Page.chome;        
        return p;      
    }     
    
     public communityChangePassword() {}
    
     
}