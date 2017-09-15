/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 15 2009
**Last Modified- 
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller Async
*****************************************************/

@isTest
private class TestAsync{
	@isTest
  public static void checkAsync(){  
    List<User> uList= [select Id,IsActive from User where ID != :UserInfo.getUserId()and isActive = true LIMIT 1];
    if(uList != null && uList.size() > 0){
      //Async.DeactivatePortalUser(uList[0].id); 
      Test.startTest();     
      Async.DeactivateAllPortalUsersForAccount(uList[0].id);
      Async.ChangeProfileAllPortalUsersForAccount(uList[0].id);     
      User u;
      u = [select Id, Name from User where Id != :UserInfo.getUserId() Limit 1];
      if(u != null){     
        //Async.DeactivatePortalUser(u.Id);
      }
      Test.stopTest();     
    }    
  }
  
  @isTest
  public static  void checkUserManagement(){
    //TestUserManagement.Test_UserUpdate();
    //TestCheckContactDuplicate.testcheckContactDuplicate();      
  }
}