global class partnerportalloginfortestingController {
    /*
    global String username{get;set;}
    global String password{get;set;}
    public String usrLang{get; set;}
    public String welcomeMsg{get; set;}
    public String cookieValue{get; set;}
    public String languageSelected{get; set;}
    public String usrLangCode{get; set;}
    public String mainHeader{get;set;}
    public String portalLoginHeader{get;set;}
    public String currentServer{get;set;}
    public Community_EndPoint__c ce = Community_EndPoint__c.getValues('SPWRCommunity');

    public partnerportalloginfortestingController(){
        currentServer='https://login.salesforce.com';
        if(UserInfo.getOrganizationId()!=Label.Production_Org_Id){
           currentServer='https://test.salesforce.com';
        }
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
        
        plpList = [select Language__c,Main_Header__c,Welcome_Message__c,PoralLoginHeader__c from Portal_Login_Page_Setup__c];
        
        for(Portal_Login_Page_Setup__c plp:plpList){
            plpMap.put(plp.Language__c,plp);
        }
        System.debug('plpMap ----- '+plpMap);
        
        if(!plpMap.isEmpty()){
            welcomeMsg=plpMap.get('English').Welcome_Message__c;
            mainHeader=plpMap.get('English').Main_Header__c;
            portalLoginHeader=plpMap.get('English').PoralLoginHeader__c;
            
            
            if(languageSelected != null){
                welcomeMsg=plpMap.get(languageSelected).Welcome_Message__c;
                mainHeader=plpMap.get(languageSelected).Main_Header__c;
                portalLoginHeader=plpMap.get(languageSelected).PoralLoginHeader__c;
            }
        }
    }
    
    //changing the login method to log user into the portal and not into the site
    public pageReference login(){
        String strtURL = '';
        String strtURL1 = '';
        PageReference pr;
        PageReference p;
        if(System.currentPageReference().getParameters().get('startURL')!=null){
            strtURL=System.currentPageReference().getParameters().get('startURL');
            strtURL=currentServer+strtURL;
            strtURL1 = System.currentPageReference().getParameters().get('startURL');
        }
        system.debug('*************start Url*=='+strtURL1);
        
        String encryptedUsername = username;
        String encryptedPassword = password;
        //Community_EndPoint__c ce = Community_EndPoint__c.getValues('SPWRCommunity');
        if(ce.Use_Encryption__c){
            encryptedUsername = EncryptionUtil.encryptString(username,Label.DynamicProposalSecretKey);
            encryptedPassword = EncryptionUtil.encryptString(password,Label.DynamicProposalSecretKey);
        }
        
        if(strtURL1==null || strtURL1==''){
            pr = Site.login(username, password,'/apex/partnerportallanding?un='+encryptedUsername+'&pw='+encryptedPassword+'&comm=y');
        }else{
            pr = Site.login(username, password,'/apex/partnerportallanding?un='+encryptedUsername+'&pw='+encryptedPassword+'&comm=y&startURL='+strtURL1);
        }
        return pr;
    }
    
    public PageReference authCurrentUser() {

        if(ce.ByPassPortalSite__c){
            String startURL = ApexPages.currentPage().getParameters().get('startURL');
            
            PageReference pr = new PageReference(ce.URL__c);
            
            if(startURL!=null){
                pr.getParameters().put('startURL',startURL);
                return pr;
            }  
            else
                return pr;
            
        }
            

        System.debug('User -----'+UserInfo.getUserType());
        if(UserInfo.getUserType() == 'Guest'){
            return null;
        }
        else if(UserInfo.getUserType() =='Standard'){
            return null;
        }
        else{
            //return Network.communitiesLanding();
            return new PageReference('/apex/partnerportallanding?un='+username+'&pw='+password);
        }
    }*/

}