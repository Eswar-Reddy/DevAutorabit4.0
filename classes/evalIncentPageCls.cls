public class evalIncentPageCls {
    public Id accId{get;set;}
    Public String accType;
    public String theater{get;set;}
    Boolean isActive,SRI;
    public string selectedTab {get;set;}
    public string prePeriod {get;set;}
    public string preYear {get;set;}
    
    public evalIncentPageCls(){
        AccntName();
        if(ApexPages.currentPage().getParameters().get('returnTab')!= null){
            System.debug('========1=============' + ApexPages.currentPage().getParameters().get('returnTab'));
            selectedTab = ApexPages.currentPage().getParameters().get('returnTab');
        }else{
            selectedTab = 'currentperiod';
        }
        //Case#00072543     
        prePeriod = PreviousPerformancePeriod__c.getAll().get('Period').value__c;       
        preYear = PreviousPerformancePeriod__c.getAll().get('Year').value__c;
        System.debug('----prePeriod-------'+prePeriod+'-------preYear-------'+preYear);
    }
    
    String UserId= userInfo.getuserId();
    User usr = [Select ContactId, LanguageLocaleKey, Country_Domain__c from User where id =:UserId]; //Name modified on 11/feb/10  
   
    String profileId = UserInfo.getProfileId(); 
    Profile userprofile = [select name from Profile where id=: this.profileId];
    public void AccntName(){
        try{
            Contact cObj = [Select Account.Id,Account.Type,Account.Theater__c from Contact where Id =:usr.ContactId ];  // limit 1 modified on 11/feb/10 
            accId = cObj.Account.Id;   
            accType = cObj.Account.Type;  
            theater = cObj.Account.Theater__c;        
        } catch (System.QueryException e){
           // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //myMsg.addMessages(e);
        }          
    }
    
    public Boolean getIsPartnerCombo(){
        AccntName();
         if(accType != null && PerformanceEvalCst.PARTNER_TYPE_COMBO.contains(accType)){
            return true;
        }else{
            return false;
        }   
    }
        
    Public PageReference getEvalPerformance(){
        AccntName();
        if(accId != null){
            PageReference nxtpage;
            
            if(accType != null && PerformanceEvalCst.PARTNER_TYPE_COMM.contains(accType) && theater == 'North America'){
                nxtpage = new PageReference('/apex/PerformanceEvalPageComm?accId='+accId);
            }else{
                nxtpage = new PageReference('/apex/PerformanceEvalPage?accId='+accId);
            }
            
            //PageReference nxtpage = new PageReference('/apex/PerformanceEvalPage?accId='+accId);
            return nxtPage ;
        }else{
            return null;
        }
    
    }
     
   
    Public PageReference IncentDetail;
    Public PageReference getIncentDetail(){
        AccntName();
        if(accId!= null){
            PageReference nxtpage;
            
            if(accType != null && PerformanceEvalCst.PARTNER_TYPE_COMM.contains(accType) && theater == 'North America'){
                nxtpage = new PageReference('/apex/incentrailComm?accId='+accId);
            }else{
                nxtpage = new PageReference('/apex/incentrail?accId='+accId);
            }
            //PageReference nxtpage = new PageReference('/apex/incentrail?accId='+accId);
            return nxtPage ;
        }else{
            return null;
        }
    }
    
    Public boolean IsFrenchPortal;
    Public boolean getIsFrenchPortal(){
        boolean frenchPortal = false;        
        if((UserInfo.getLocale() == 'fr' || UserInfo.getLocale() == 'FR') && UserInfo.getUserType()=='PowerPartner'){
            frenchPortal = true; 
        }
        return frenchPortal;
    }
    
    //Added for case 00064997
    public String imageToDisplay = 'None';
    public String getImageToDisplay(){
        string imgToDisplay;
        if (usr.Country_Domain__c.endsWith('BE') || usr.Country_Domain__c.endsWith('be')){
            if (usr.LanguageLocaleKey.endsWith('NL') || usr.LanguageLocaleKey.endsWith('nl'))
                imgToDisplay = 'Flemish';
            else if (usr.LanguageLocaleKey.endsWith('FR') || usr.LanguageLocaleKey.endsWith('fr'))
                imgToDisplay = 'French';
            
        }else if(usr.Country_Domain__c.endsWith('UK') || usr.Country_Domain__c.endsWith('uk')){//for Case# 00092720
        	imgToDisplay = 'UK';//for Case# 00092720
        }else
            imgToDisplay = 'None';
        return imgToDisplay;
    }
    //End of change for case 00064997   
    
    public Boolean getisActive(){
        if(userprofile.Name.equals('EU Partner Delegated Administrator')||userprofile.Name.equals('EU Partner Executive')||userprofile.Name.equals('Partner Delegated Administrator')||userprofile.Name.equals('Partner Executive')||userprofile.Name.equals('EU Residential Installer')||userprofile.Name.equals('System Administrator')||userprofile.Name.equals('Systemadministrator')||userprofile.Name.equals('Amministratore del sistema')){
            return true;    
        }else{         
            return false;
        }
    }
    
    public Boolean getSRI(){
        AccntName();
        if(accType.equals('Residential Installer')){
             return true;    
        }else{         
            return false;
        }
    }
    
    
    public static testMethod void tst001(){
        List<Account> acc = [select Id from Account where RecordType.Name='Partner' and Country_Domain__c='rvar-us'];
        list<id> accid = new list<id>();
        for(Account a : acc){
            accid.add(a.Id);
        }
        List<contact> cnt =[Select Id,name from Contact where Account.Id in :accid limit 5];
        list<String> cName = new list<String>();
        for(Contact c : cnt){
            cName.add(c.name);        
        }
        
        List<user> ulist = [select id from User where name in :cName and Country_Domain__c='rvar-us' and isActive = true];
        if(ulist.size()>0){
            Id uId = ulist.get(0).id;
            System.runAs(ulist[0]){
                evalIncentPageCls evi = new evalIncentPageCls();
                evi.AccntName();
                evi.getEvalPerformance();
                evi.getIncentDetail();
                evi.getisActive();  
                evi.getSRI(); 
                evi.getImageToDisplay();
                PageReference p =evi.getPreEvalPerformance();
                PageReference p1 = evi.getPreIncentDetail();
                Boolean b = evi.getIsPartnerCombo();  
                Boolean f = evi.getIsFrenchPortal();                  
            }
        }
        Profile p = [select id from profile where name='EU Partner Operations'];
        list<User> u2 =[select Id from User where profileid =:p.id and isactive = true and isActive = true limit 1];
        if (u2.size() > 0)
        system.runAs(u2[0]){
            evalIncentPageCls evii = new evalIncentPageCls();
            evii.accId = null;
            evii.getEvalPerformance();
            evii.getIncentDetail();
            evii.getisActive();
            evii.getSRI();
        }
        evalIncentPageCls evi2 = new evalIncentPageCls();
        evi2.getisActive();
       // evi2.getSRI();
        evi2.accId = null;
        evi2.getEvalPerformance();
        evi2.getIncentDetail();
        
        
    }
    
    
    /****************************Created by Prakash as on Jan 06 For Previous Tab************* on Portal*/
    Public PageReference getPreEvalPerformance(){
        AccntName();
        if(accId != null){
            PageReference nxtpage;
            
            if(accType != null && PerformanceEvalCst.PARTNER_TYPE_COMM.contains(accType) && theater == 'North America'){
                nxtpage = new PageReference('/apex/PerformanceEvalPreviousComm?accId='+accId+'&period='+prePeriod+'&year='+preYear);
            }else{
                nxtpage = new PageReference('/apex/PerformanceEvalPrevious?accId='+accId + '&period='+prePeriod+'&year='+preYear);
            }
            return nxtPage ;
        }else{
            return null;
        }
    
    }
     
   
    Public PageReference getPreIncentDetail(){
        AccntName();
        if(accId!= null){
            PageReference nxtpage;
            
            if(accType != null && PerformanceEvalCst.PARTNER_TYPE_COMM.contains(accType) && theater == 'North America'){
                nxtpage = new PageReference('/apex/incentiveDetailPreviousComm?accId='+accId +'&period='+prePeriod+'&year='+preYear);
            }else{
                nxtpage = new PageReference('/apex/IncentiveDetailPrevious?accId='+accId +'&period='+prePeriod+'&year='+preYear);
            }
            return nxtPage ;
        }else{
            return null;
        }
    }
    /*.......................*/
    
}