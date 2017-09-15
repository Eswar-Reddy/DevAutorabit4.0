/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 30 2009
**Last Modified By-Anuradha Suthar 
**Last Modified On- July 23 2009  
**Desciption- Test class for class TestPortalHomepage
*****************************************************/
public class TestPortalHomepage{
  @isTest
  public static void checkPortalHomepage(){
    //List<User> lstUser = new List<User>();
    //lstUser = [select Id from User where isActive = true and contactId != null Limit 1];
    //User userObj;    
    //userObj = lstUser[0];
    
    try{
    Account accountObj = new Account();
        accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
        accountObj.Type ='Commercial';
        accountObj.BillingCity = 'san mateo';
          accountObj.BillingStreet = 'Concar drive';
          accountObj.BillingPostalCode ='94402';
          accountObj.BillingCountry = 'USA'; 
        insert accountObj;
        
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = accountObj.Id;
        contactObj.Email = 'Test123222@test123.com';
        insert contactObj;
        
    
         String username= 'test123@yahoo.com';
         User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
         user.ContactId = contactObj.Id;
         user.Username = 'testD123@yahoo.com';
         user.Alias = 'hello';
         user.CommunityNickname = username.subString(0,7);
         user.TimeZoneSidKey = 'America/Los_Angeles';
         user.EmailEncodingKey = 'ISO-8859-1';
         user.LanguageLocaleKey = 'en_US';
         user.Email = contactObj.Email;
         user.LocaleSidKey = 'en_US';
         user.IsActive = true;
         List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
         if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            try {
              insert user;
            } catch(Exception ex){}     
         }
         
    Test.startTest();
    System.runAs(user){    
      PortalHomepage testObj = new PortalHomepage();
      String userId = testObj.userId;
      Boolean partnerAcc = testObj.isPremierPartnerAccount;  
      String userNameTest = testObj.userName;  
      boolean isPartner = testObj.isPartnerUser;
      boolean isEUPartner = testObj.isEUPartnerAccount;
      boolean isCommercial = testObj.isCommercialAccount;
      boolean isAuthorize = testObj.isAuthorizedAccount;
    }
    Test.stopTest();
    }
    catch(Exception ex){
        
    }
    
  }
  
  
  //madhuri
  
  //create an Italian user
  
  @isTest
  public static void checkPortalHomepage1(){
    try{
   
    
    Account account = createAccount();
    Contact contactObj = createContact(account);
        
    
     String username= 'test@yahoo.com';
     User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'User'+ String.valueOf(DateTime.Now()));
     user.ContactId = contactObj.Id;
     user.Username = 'testD123@yahoo.com';
     user.Alias = 'hello';
     user.CommunityNickname = username.subString(0,2);
     user.TimeZoneSidKey = 'Europe/Rome';
     user.EmailEncodingKey = 'ISO-8859-1';
     user.LanguageLocaleKey = 'it';
     user.Email = contactObj.Email;
     user.LocaleSidKey = 'it_IT';
     user.IsActive = true;
     List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
     if(lstProfile.Size()>0){
        user.ProfileId = lstProfile[0].Id;
        try {
          insert user;
        } catch(Exception ex){}     
     }
         
    Test.startTest();
    System.runAs(user){    
      PortalHomepage testObj = new PortalHomepage();
      boolean italianChk = testObj.isItalian;
    }
    Test.stopTest();
    }
    catch(Exception ex){
        
    }
    
  }
  
  //create an French user
  
  @isTest
  public static void checkPortalHomepage2(){
    try{
    
    Account account = createAccount();
    Contact contactObj = createContact(account);
        
    
     String username= 'test@yahoo.com';
     User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'User'+ String.valueOf(DateTime.Now()));
     user.ContactId = contactObj.Id;
     user.Username = 'testD123@yahoo.com';
     user.Alias = 'hello';
     user.CommunityNickname = username.subString(0,2);
     user.TimeZoneSidKey = 'Europe/Paris';
     user.EmailEncodingKey = 'ISO-8859-1';
     user.LanguageLocaleKey = 'fr';
     user.Email = contactObj.Email;
     user.LocaleSidKey = 'fr_BE';
     user.IsActive = true;
     List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
     if(lstProfile.Size()>0){
        user.ProfileId = lstProfile[0].Id;
        try {
          insert user;
        } catch(Exception ex){}     
     }
         
    Test.startTest();
    System.runAs(user){    
      PortalHomepage testObj = new PortalHomepage();
      boolean italianChk = testObj.isFrenchBE;
    }
    Test.stopTest();
    }
    catch(Exception ex){
        
    }
    
  }
  
  //create an Spanish user
  
  @isTest
  public static void checkPortalHomepage3(){
    try{
   
    Account account = createAccount();
    Contact contactObj = createContact(account);
        
    
     String username= 'test@yahoo.com';
     User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'User'+ String.valueOf(DateTime.Now()));
     user.ContactId = contactObj.Id;
     user.Username = 'testD123@yahoo.com';
     user.Alias = 'hello';
     user.CommunityNickname = username.subString(0,2);
     user.TimeZoneSidKey = 'Europe/Paris';
     user.EmailEncodingKey = 'ISO-8859-1';
     user.LanguageLocaleKey = 'es';
     user.Email = contactObj.Email;
     user.LocaleSidKey = 'es';
     user.IsActive = true;
     List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
     if(lstProfile.Size()>0){
        user.ProfileId = lstProfile[0].Id;
        try {
          insert user;
        } catch(Exception ex){}     
     }
         
    Test.startTest();
    System.runAs(user){    
      PortalHomepage testObj = new PortalHomepage();
      boolean italianChk = testObj.isSpanish;
    }
    Test.stopTest();
    }
    catch(Exception ex){
        
    }
    
  }
  
   //create an German user
  
   @isTest
  public static void checkPortalHomepage4(){
    try{
   
     Account account = createAccount();
     Contact contactObj = createContact(account);
        
    
     String username= 'test@yahoo.com';
     User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'User'+ String.valueOf(DateTime.Now()));
     user.ContactId = contactObj.Id;
     user.Username = 'testD123@yahoo.com';
     user.Alias = 'hello';
     user.CommunityNickname = username.subString(0,2);
     user.TimeZoneSidKey = 'America/Los_Angeles';
     user.EmailEncodingKey = 'ISO-8859-1';
     user.LanguageLocaleKey = 'de';
     user.Email = contactObj.Email;
     user.LocaleSidKey = 'de';
     user.IsActive = true;
     List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
     if(lstProfile.Size()>0){
        user.ProfileId = lstProfile[0].Id;
        try {
          insert user;
        } catch(Exception ex){}     
     }
         
    Test.startTest();
    System.runAs(user){    
      PortalHomepage testObj = new PortalHomepage();
      boolean italianChk = testObj.isGerman;
    }
    Test.stopTest();
    }
    catch(Exception ex){
        
    }
    
  }
  
  //create an Dutch user
  
   @isTest
  public static void checkPortalHomepage5(){
    try{
 
    Account account = createAccount();
    Contact contactObj = createContact(account);
        
    
     String username= 'test@yahoo.com';
     User user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'User'+ String.valueOf(DateTime.Now()));
     user.ContactId = contactObj.Id;
     user.Username = 'testD123@yahoo.com';
     user.Alias = 'hello';
     user.CommunityNickname = username.subString(0,2);
     user.TimeZoneSidKey = 'Europe/Paris';
     user.EmailEncodingKey = 'ISO-8859-1';
     user.LanguageLocaleKey = 'nl_NL';
     user.Email = contactObj.Email;
     user.LocaleSidKey = 'nl';
     user.IsActive = true;
     List<Profile> lstProfile = [select Id from Profile where Profile.Name like 'Partner Delegated Administrator' LIMIT 1];
     if(lstProfile.Size()>0){
        user.ProfileId = lstProfile[0].Id;
        try {
          insert user;
        } catch(Exception ex){}     
     }
         
    Test.startTest();
    System.runAs(user){    
      PortalHomepage testObj = new PortalHomepage();
      boolean italianChk = testObj.isDutch;
    }
    Test.stopTest();
    }
    catch(Exception ex){
        
    }
    
  }
  public static Account createAccount(){
    Account accountObj = new Account();
    accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.BillingCity = 'Abruzzo';
    accountObj.BillingStreet = 'Concar drive';
    accountObj.BillingPostalCode ='94402';
    accountObj.BillingCountry = 'Italy'; 
    insert accountObj;
    
    return accountObj;
  }
  
  public static Contact createContact(Account accountObj){
  
    Contact contactObj = new Contact();
    contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
    contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
    contactObj.AccountId = accountObj.Id;
    contactObj.Email = 'Test123222@test123.com';
    insert contactObj;
    
    return contactObj;
  
  }
}