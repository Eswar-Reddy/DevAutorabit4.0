@isTest
private class Test_OnFulfillmentController 
{  
    public static testMethod void testOnFulfillmentController(){
       String username ='hello10101@world.com';
       User user = new User(LastName = 'Hello2222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
       user.Username = username;
       user.Alias = 'yoo123';
       user.Country_Domain__c ='rvar-fr';
       user.Country = 'Italy';
       user.Country_Domain__c = 'rvar-us';
       user.Division ='SunPower EU';
       user.CommunityNickname = username.subString(0,7);
       user.TimeZoneSidKey = 'America/Los_Angeles';
       user.EmailEncodingKey = 'ISO-8859-1';
       user.LanguageLocaleKey = 'en_US';
       user.Email = 'testInspectionReportEU@tt.com';
       user.LocaleSidKey = 'en_US';
       user.Web_User__c = True;
       user.ByPassValidation__c = False;
       user.SmartStore_ID__c = 'Test';      
       List<Profile> lstProfile = [select Id from Profile where Name = 'System Administrator'];
       if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
        }
       List<UserRole> lstUserRole = [Select Id,Name From UserRole where Name='Technical Services Engineer']; 
       if(lstUserRole.Size()>0){
           user.UserRoleId = lstUserRole[0].Id;
           insert user;
       }
     
       System.RunAs(user){
           OnFulfillmentController controller = new OnFulfillmentController();
       }
    }
}