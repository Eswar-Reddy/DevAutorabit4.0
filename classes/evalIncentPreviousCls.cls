public class evalIncentPreviousCls {
	
    Id accId ;
    Public String accType;
    Boolean isActive,SRI;
    
    String UserId= userInfo.getuserId();
    User usr = [Select ContactId from User where id =:UserId]; //Name modified on 11/feb/10  
   
    String profileId = UserInfo.getProfileId(); 
    Profile userprofile = [select name from Profile where id=: this.profileId];
    public void AccntName(){
        try{
            Contact cObj = [Select Account.Id,Account.Type from Contact where Id =:usr.ContactId ];  // limit 1 modified on 11/feb/10 
            accId = cObj.Account.Id;   
            accType = cObj.Account.Type;
        } catch (System.QueryException e){
           // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
            //myMsg.addMessages(e);
        }          
    }
     
        
    Public PageReference getEvalPerformance(){
        AccntName();
        if(accId != null){
            PageReference nxtpage = new PageReference('/apex/performanceEvalpreviousPage?accId='+accId);
            return nxtPage ;
        }else{
            return null;
        }
    
    }
     
   
    Public PageReference IncentDetail;
    Public PageReference getIncentDetail(){
        AccntName();
        if(accId!= null){
            PageReference nxtpage = new PageReference('/apex/incentivePreviousPage?accId='+accId);
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
                evalIncentPreviousCls evi = new evalIncentPreviousCls();
                evi.AccntName();
                evi.getEvalPerformance();
                evi.getIncentDetail();
                evi.getisActive();  
                evi.getSRI();                     
            }
        }
        Profile p = [select id from profile where name='EU Partner Operations'];
        list<User> u2 =[select Id from User where profileid =:p.id and isactive = true and isActive = true limit 1];
        if (u2.size() > 0)
        system.runAs(u2[0]){
            evalIncentPreviousCls evii = new evalIncentPreviousCls();
            evii.accId = null;
            evii.getEvalPerformance();
            evii.getIncentDetail();
            evii.getisActive();
            evii.getSRI();
        }
        evalIncentPreviousCls evi2 = new evalIncentPreviousCls();
        evi2.getisActive();
       // evi2.getSRI();
        evi2.accId = null;
        evi2.getEvalPerformance();
        evi2.getIncentDetail();
        
        
    }
    
	

}