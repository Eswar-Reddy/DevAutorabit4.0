/*****************************
**Created By- 
**Created On-
**Last Modified- Kapil Goutam
**Last Modified On-  June 02 2009 
**Desciption- Controller class
*******************************/
public class ACBParanetLinkController{
   
    public String url{get;set;}
    String userId = UserInfo.getUserId();
    public String getUserId(){
        if(userId == null)
          userId = UserInfo.getUserId();
        return userId;  
    }
    String ACBParanetId{get;set;} 
    String accId{get;set;}
  
    public ACBParanetLinkController(){
       
        String baseUrl = 'http://sunpower.acbcoop.net/setuser.asp?pass=$unP0wer&login=';
        String defaultUrl = 'http://sunpower.acbcoop.net/';
        
        
        if(isPartnerProfileUser()){
          // if the current user is a partner user &&   
          //if the value is not set then return the "defualtURL"
              if(ACBParanetId == null){
                    url = defaultUrl;
                    return;
              }
              else{
                    url = baseUrl + ACBParanetId;
                    return;
              }
        }
        else if(isUserSunpowerOrSuperOrAdmin()){
            // If the current user is a sunpower user and has the profile of "SunPower Super User" or "SunPower User" or "System Administator"
            // then set the ACBParanetAcountID to "1-SUNPWR"
            ACBParanetId = '1-SUNPWR';     
            url = baseUrl + ACBParanetId;
            return;
        }
        else if(isInternalUser()){
            //is user internal user
            url = defaultUrl;
            return;
        }
        
    }
    //check is user is internal user
    private Boolean isInternalUser(){
        Boolean flag = false;
        List<User> listUser = new List<User>([Select Id, Profile.Name from User where Id =:userId and Profile.Name NOT in ('SunPower User','SunPower Partner Ambassador','SunPower Super User','System Administrator') and ContactId = null limit 1]);
        if(listUser.Size()>0){
            flag = true;
        }
        return flag;
    }
    //is user sunpower, sunpower supew user or system admin
    private Boolean isUserSunpowerOrSuperOrAdmin(){
        Boolean flag = false;
        List<User> listUser = new List<User>([Select Id, Profile.Name from User where Id =:userId and Profile.Name in ('SunPower User','SunPower Partner Ambassador','SunPower Super User','System Administrator') limit 1]);
        if(listUser.Size()>0){
            flag = true;
        }
        return flag;
    }
    //function checks whether the user is partner profile user  
    private Boolean isPartnerProfileUser(){
         Set<String> allProfileIds = null;
         Boolean isPartnerProfileUser = false;
         allProfileIds = getPartnerProfileList(); 
         if(allProfileIds != null){
            List<User> listUser = new List<User>([Select Id, Contact.AccountId from User where ProfileId in :allProfileIds and Id =:userId limit 1]);
            if(listUser.Size()>0){
                List<Account> listAccount = new List<Account>([Select Id, ACBParanet_ID__c from Account where Id=:listUser.get(0).Contact.AccountId limit 1]);
                if(listAccount.Size()>0){
                    ACBParanetId = listAccount.get(0).ACBParanet_ID__c;
                    accId = listAccount.get(0).Id;
                    isPartnerProfileUser = true;
                }
            }
        }
        return isPartnerProfileUser;
        
    }

    //function which return a set of all partner profiles Id
    private Set<String>  getPartnerProfileList(){
            Set<String> allProfileId = null;    
            List<Profile> listProfile = new List<Profile>([Select Id, Name from Profile where Name like '%Partner%']);
            if(listProfile.Size()>0){
                allProfileId = new Set<String>();   
                for(Profile p:listProfile){
                    allProfileId.add(p.Id);
                }//for end          
            }//if end   
            return allProfileId;    
    }
    
   
}