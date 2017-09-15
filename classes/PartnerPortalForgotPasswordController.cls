public class PartnerPortalForgotPasswordController {

    public String username {get; set;}
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}   
    public String languageSelected{get; set;}
    public String usrLangCode{get; set;}
    public String portalLoginHeader{get;set;}
    public String backtoLogin{get; set;}
    
    public PartnerPortalForgotPasswordController() {
        usrLangCode = ApexPages.currentPage().getHeaders().get('Accept-Language');
        usrLangCode = usrLangCode.split(',')[0].toLowerCase();
        LanguageISOCodeMapping__c liso = LanguageISOCodeMapping__c.getValues(usrLangCode);
        if(liso!=null)
            languageSelected = liso.Language__c;
        setWelcomeMsg();
    }
    
    public void setWelcomeMsg(){

        List<Portal_Login_Page_Setup__c> plpList = new List<Portal_Login_Page_Setup__c>();
        Map<String,Portal_Login_Page_Setup__c> plpMap = new Map<String,Portal_Login_Page_Setup__c>();
        
        plpList = [select Language__c,PoralLoginHeader__c,BackToLogin__c from Portal_Login_Page_Setup__c];
        
        for(Portal_Login_Page_Setup__c plp:plpList){
            plpMap.put(plp.Language__c,plp);
        }
        System.debug('plpMap ----- '+plpMap);
        
        portalLoginHeader=plpMap.get('English').PoralLoginHeader__c;
        backtoLogin=plpMap.get('English').BackToLogin__c;
        if(languageSelected != null){
            portalLoginHeader=plpMap.get(languageSelected).PoralLoginHeader__c;
            backtoLogin=plpMap.get(languageSelected).BackToLogin__c;
        }
    }
    
    public PageReference forgotPassword() {
        
        
        List<User> usrList = new List<User>();
        usrList=[select Id from User where username=:username];
        
        if(usrList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Username'));
            return null;
        }
        
        //System.resetPassword(u.Id,true);
        
        boolean success = Site.forgotPassword(username);
        PageReference pr = Page.partnerportalforgotpasswordconfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
        
    }
    
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }
    
    
}