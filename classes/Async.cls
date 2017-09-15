//*********************************************************************
//Name : Async
//Created On : 9th March,2009
//Created By : Appirio (Ritesh)
//Implementation:
//Modified by: Appirio (Prakash G.)
// Contains methods with @future annonation to house
// long running methods and transaction involving Mixed DML
// operation ie. Portal User object and Contact
//**********************************************************************

global class Async {

  //--------------------------------------------------------//
  //Deactivate Portal User by setting IsActive status to false
  //-------------------------------------------------------//
  @future
  public static void DeactivatePortalUser(Id userId){
    List<User> lstUser = [select Id,IsActive,contact.Terminated__c,Portal_User_Type__c from User where Id = :userId];
    if(lstUser.size() == 0) {
      return;
    }
    lstUser[0].IsActive = false;
    //Case#00091742 - When a user partner account is deactivated via the terminate button, change portal user type
    if(lstUser[0].contact.Terminated__c && lstUser[0].Portal_User_Type__c=='LMS Only User'){
        lstUser[0].Portal_User_Type__c = 'SFDC User';
    }
    
    update lstUser;
  }
  
  //--------------------------------------------------------//
  //Deactivate All Portal users
  //-------------------------------------------------------// 
  @future
  public static void DeactivateAllPortalUsersForAccount(Id accountId) {
    for(List<Contact> lstContact :[select Id from Contact where AccountId = :accountId]) {
      for(List<User> lstUser :[select Id,IsActive,contact.Terminated__c,Portal_User_Type__c from User where ContactId IN :lstContact and IsActive = true]) {
        for(User user :lstUser) {
           user.IsActive = false; 
           //Case#00091742 - When a user partner account is deactivated via the terminate button, change portal user type
           if(user.Portal_User_Type__c=='LMS Only User'){
               user.Portal_User_Type__c = 'SFDC User';
           }   
        }
        update lstUser;
      } 
    }
  }
  //--------------------------------------------------------//
  //Change Profile for All Portal users
  //-------------------------------------------------------// 
  @future
  public static void ChangeProfileAllPortalUsersForAccount(Id accountId) {
    List<Profile> profileList = [select Id,Name from Profile where name = 'Partner Restricted' Limit 1];
    Profile profile=null;
    
    if(profileList != null && profileList.size()>0)
        profile = profileList[0];
    else
        return;
        
    for(List<Contact> lstContact :[select Id from Contact where AccountId = :accountId]) {
      for(List<User> lstUser :[select Id,IsActive from User where ContactId IN :lstContact]) {
        for(User user :lstUser) {
          user.ProfileID = profile.id;    
        }
        update lstUser;
      } 
    }
  }
}