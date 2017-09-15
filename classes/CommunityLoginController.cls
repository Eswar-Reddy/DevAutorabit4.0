global class CommunityLoginController {
    global String username{get;set;}
    global String password{get;set;}
    global String strtURL{get;set;}
    global String strtURL1{get;set;}
    global String isCommunity{get;set;}
    global integer LoginComm{get;set;}
    global string commv{get;set;}
    
    
    public CommunityLoginController(){
        username = ApexPages.currentPage().getParameters().get('un');
        password = ApexPages.currentPage().getParameters().get('pw');

        Community_EndPoint__c ce = Community_EndPoint__c.getValues('SPWRCommunity');
        if(ce.Use_Encryption__c){
            username = EncryptionUtil.decryptString(username,Label.DynamicProposalSecretKey);
            password = EncryptionUtil.decryptString(password,Label.DynamicProposalSecretKey);
        }
        
        isCommunity = ApexPages.currentPage().getParameters().get('comm');
		strtURL1 = ApexPages.currentPage().getParameters().get('startURL');
        system.debug('************new start url='+strtURL1);
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
   
    public String usrLang{get; set;}
    public String welcomeMsg{get; set;}
    public String cookieValue{get; set;}
    public String languageSelected{get; set;}
    public String usrLangCode{get; set;}
    public String mainHeader{get;set;}
    public String portalLoginHeader{get;set;}
    public String currentServer{get;set;}
    
    
    public void setWelcomeMsg(){
        List<Portal_Login_Page_Setup__c> plpList = new List<Portal_Login_Page_Setup__c>();
        Map<String,Portal_Login_Page_Setup__c> plpMap = new Map<String,Portal_Login_Page_Setup__c>();
        
        plpList = [select Language__c,Main_Header__c,Welcome_Message__c,PoralLoginHeader__c from Portal_Login_Page_Setup__c];
        
        for(Portal_Login_Page_Setup__c plp:plpList){
            plpMap.put(plp.Language__c,plp);
        }
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
    
    
    public pageReference login(){
        String currentServer = '';
        strtURL='';
       PageReference pr;
       PageReference p;
        if(System.currentPageReference().getParameters().get('startURL')!=null){
            strtURL=System.currentPageReference().getParameters().get('startURL');
            system.debug('************old start url='+strtURL);
            strtURL=currentServer+strtURL;
        }
        
        ApexPages.currentPage().getParameters().put('comm',commv);        
		System.debug('commv----->'+commv);

        if(username!=null || password !=null){
            if(strtURL1==null || strtURL1==''){
            pr = Site.login(username, password,'/apex/CHome?sfdc.tabName=01r340000004dsw');
            }else{
            pr = Site.login(username, password,'/apex/Communitieslanding?&startURL='+strtURL1);
            }
            return pr;   
        }else{	
            return null;
        }

		
        
    }
       
}