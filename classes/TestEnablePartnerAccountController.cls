/*******************************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 08 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller EnablePartnerAccountController
*****************************************************/
@isTest
private class TestEnablePartnerAccountController{
    @isTest
  public static void checkEnablePartnerAccountController1(){    
    Account accountObj = new Account();
    accountObj.Name = 'test Account' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;
    
    Contact contactObj = new Contact();
    contactObj.AccountId = accountObj.Id;
    contactObj.LastName = 'test' + DateTime.now();
    contactObj.FirstName = 'test' + DateTime.now();
    insert contactObj;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(accountObj);
    EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
    testObj.selectedAccountIds = accountObj.Id;
    testObj.reloadData();
    testObj.displayPartnerAccounts();    
    testObj.displayNonPartnerAccounts();
    testObj.activatePartnerPortalUsers();

    Test.stopTest();
  }
  public static testmethod void testEnablePartnerAccController(){
    
    
    List<Account> lstAccount = new List<Account>();
    Account accountObj = new Account();
    accountObj.Name = 'test Account' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    //accountObj.isPartner = false;
    lstAccount.add(accountObj);
    //insert accountObj;
    
    Account accountObj1 = new Account();
    accountObj1.Name = 'test Account1' + DateTime.now();
    accountObj1.Type ='Commercial';
    accountObj1.billingCity = 'TestCity';
    accountObj1.BillingCountry = 'TestCountry';
    accountObj1.BillingPostalCode = '12345';
    accountObj1.BillingState = 'TestState';
    accountObj1.BillingStreet = 'TestStreet';
    //accountObj1.IsPartner = true;
    //accountObj1.isPartner = false;
    //insert accountObj1;
    lstAccount.add(accountObj1);
    
    
    Account accountObj2 = new Account();
    accountObj2.Name = 'test Account2' + DateTime.now();
    accountObj2.Type ='Commercial';
    accountObj2.billingCity = 'TestCity';
    accountObj2.BillingCountry = 'TestCountry';
    accountObj2.BillingPostalCode = '12345';
    accountObj2.BillingState = 'TestState';
    accountObj2.BillingStreet = 'TestStreet';
    //accountObj1.isPartner = false;
    //insert accountObj2;
    lstAccount.add(accountObj2);
    
    insert lstAccount;
    
   // Account accountObj3 = new Account(Id= lstAccount.get(1).Id);
   // accountObj3.IsPartner = false;
    //update accountObj3;
    
    List<Contact> lstContact = new List<Contact>();
    Contact contactObj = new Contact();
    contactObj.AccountId = accountObj.Id;
    contactObj.LastName = 'test' + DateTime.now();
    contactObj.FirstName = 'test' + DateTime.now();
    contactObj.Email = 'testa123@email.com';
    lstContact.add(contactObj);
    //insert contactObj;
    
    
    Contact contactObj1 = new Contact();
    contactObj1.AccountId = accountObj1.Id;
    contactObj1.LastName = 'test' + DateTime.now();
    contactObj1.FirstName = 'test' + DateTime.now();
    contactObj1.Email = 'testb345@email.com';
    //insert contactObj1;
    lstContact.add(contactObj1);
    
    
    Contact contactObj2 = new Contact();
    contactObj2.AccountId = accountObj2.Id;
    contactObj2.LastName = 'test' + DateTime.now();
    contactObj2.FirstName = 'test' + DateTime.now();
    contactObj2.Email = 'testc567@email.com';
    //insert contactObj2;
    lstContact.add(contactObj2);
    insert lstContact;
    
    Test.startTest();
    User usr = [Select id,name from User where isActive = true limit 1];
    System.runAs(usr){
       
        ApexPages.StandardController controller = new ApexPages.StandardController(accountObj);
        EnablePartnerAccountController contr = new EnablePartnerAccountController(controller);
        contr.selectedAccountIds = accountObj.id + ',' + accountObj1.id;
        contr.lstTestAccountIds.add(accountObj2.id);
        
        List<Set<Id>> lstSetUserIds = new List<Set<Id>>();
        Set<Id> setIds = new Set<Id>();
        setIds.add(contactObj.id);
        lstSetUserIds.add(setIds);
        contr.isAlreadyCreated(contactObj.id,lstSetUserIds);
        contr.enableAsPartner();
        contr.enablePartnerPortalLogin();
        contr.getUser(contactObj1);
        contr.getSelectedAccountIdSet();
    }
   Test.stopTest(); 
  }
  public static testMethod void checkEnablePartnerAccountController2(){    
    Account accountObj = new Account();
    accountObj.Name = 'test Account' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;
    //accountObj.isPartner = true;
    //update accountObj;
    
    Contact contactObj = new Contact();
    contactObj.AccountId = accountObj.Id;
    contactObj.LastName = 'test' + DateTime.now();
    contactObj.FirstName = 'test' + DateTime.now();
    contactObj.Email = 'testchecking@testing.com';
    
    insert contactObj;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(accountObj);
    EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
    testObj.selectedAccountIds = accountObj.Id;
    testObj.enableAsPartner();
   // testObj.enablePartnerPortalLogin();
    //testObj.activatePartnerPortalUsers();
    Test.stopTest();
  }
  public static testMethod void checkEnablePartnerPortalLogin(){    
    Account accountObj = new Account();
    accountObj.Name = 'Account1' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;
    //accountObj.isPartner = true;
    //update accountObj;
    
    Contact contactObj = new Contact();
    contactObj.AccountId = accountObj.Id;
    contactObj.LastName = 'LastName' + DateTime.now();
    contactObj.FirstName = 'FirstName' + DateTime.now();
    contactObj.Email = 'checking@gmail.com';
    
    insert contactObj;
    
    
    
    User usr = [Select id,name from User where isActive = true limit 1];
    System.runAs(usr){
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(accountObj);
        EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
        testObj.selectedAccountIds = accountObj.Id;
        testObj.enablePartnerPortalLogin();
        Test.stopTest();
        
    }
    
  }
  /* Function for Checking / Updating Partner Profiles */
    @isTest
    public static void testupdatePartnerProfilesRoles(){
        Set<ID> uIds = new Set<ID>();
        Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
        acct.Type ='Commercial';
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';
        insert acct;
        Contact cont = new Contact (firstname='test' ,lastname= 'test');
        cont.Email= '1hello@world.com';
        cont.accountId=acct.Id;
        insert cont;
        acct.isPartner= true;
        upsert acct;
        Test.startTest();
        String username = 'test123@testing.com';
        User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo123';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            //insert user;
        }
        ApexPages.StandardController controller = new ApexPages.StandardController(acct);
        EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
        testObj.selectedAccountIds = acct.Id;
        testObj.updatePartnerProfilesRoles();
        //testObj.isAlreadyCreated(contactObj,new List<User>{user});
        Test.stopTest();
    }   
  
  
  @isTest
    public static void testupdatePartnerProfilesRoles2(){
        Set<ID> uIds = new Set<ID>();
        Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
        acct.Type ='Commercial';
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';
        insert acct;
        Contact cont = new Contact (firstname='test' ,lastname= 'test');
        cont.Email= '2hello@world.com';
        cont.accountId=acct.Id;
        cont.Profile_Temp__c ='Partner Executive';
        cont.Role_Temp__c ='Partner Executive';
        insert cont;
        acct.isPartner= true;
        upsert acct;
        String username = '4hello2@test.com';
        User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo123';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        user.Edit_Partner_Users__c = true;
        Test.startTest();
        List<Profile> lstProfile = [select Id from Profile where Name = 'EU Partner Sales'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            //insert user;
        }
        ApexPages.StandardController controller = new ApexPages.StandardController(acct);
        EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
        testObj.selectedAccountIds = acct.Id;
        testObj.updatePartnerProfilesRoles();
        Test.stopTest();
    }
    //madhuri   
    
    @isTest
    public static void testupdatePartnerProfilesRoles3(){
        //Set<ID> uIds = new Set<ID>();
        
        Account acct = new Account(name= 'test222' + String.ValueOf(DateTime.Now()));
        acct.Type ='Commercial';
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';
        insert acct;
        
        Contact cont = new Contact (firstname='test' ,lastname= 'test');
        cont.Email= '3hello@world.com';
        cont.accountId=acct.Id;
        cont.Profile_Temp__c ='Partner Delegated Administrator';
        cont.Role_Temp__c ='Partner User';
        insert cont;
        
        acct.isPartner= true;
        upsert acct;
        
        String username = 'hello2@test.com';
        User user = new User(LastName = 'Hello222'+String.ValueOf(DateTime.Now()) ,FirstName = 'W'+ String.ValueOf(DateTime.Now()));
        user.ContactId = cont.Id;
        user.Username = username;
        user.Alias = 'yoo123';
        user.CommunityNickname = username.subString(0,7);
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.Email = cont.Email;
        user.LocaleSidKey = 'en_US';
        user.Edit_Partner_Users__c = true;
        List<Profile> lstProfile = [select Id from Profile where Name = 'Partner Delegated Administrator'];
        if(lstProfile.Size()>0){
            user.ProfileId = lstProfile[0].Id;
            insert user;
            
            System.runAs(user){
                Test.startTest();
                ApexPages.StandardController controller = new ApexPages.StandardController(acct);
                EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
                testObj.selectedAccountIds = acct.Id;
                testObj.updatePartnerProfilesRoles();
                testObj.checkPartnerContact();
                testObj.changeSelectedView();
                 Test.stopTest();
                
            }
           
        }
        
    }  
 
    @isTest
    public static void enableAsPartner(){
                
        Account acct = new Account(name= 'Account1' + String.ValueOf(DateTime.Now()));
        acct.Type ='Commercial';
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';
        insert acct;
        
        User user = [select id,name from user where isActive=true limit 1];
        System.runAs(user){
                Test.startTest();
                ApexPages.StandardController controller = new ApexPages.StandardController(acct);
                EnablePartnerAccountController testObj = new EnablePartnerAccountController(controller,true);
                testObj.selectedAccountIds = acct.Id;
                testObj.enableAsPartner();
                Test.stopTest();
                
        }
        
        
    } 
    
  
    
  /* Function for Checking / Updating Partner Profiles */
    
  public static testMethod void checkUserManagement(){
    //TestUserManagement.Test_UserUpdate();
  }
}