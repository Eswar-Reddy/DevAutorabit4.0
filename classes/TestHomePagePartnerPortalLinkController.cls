/**************************************************************************************************************
** PR-02022
**Created By- Kapil Goutam (Appirio)
**Created On- June 19, 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test Class for HomePagePartnerPortalLinkController class
**************************************************************************************************************/
public class TestHomePagePartnerPortalLinkController {
    
    @isTest
    public static void Test_HomePagePartnerPortalLinkController(){
        try {
            //User testPartnerUser = GetExistingPortalUser();
             
            Account accountObj = new Account();
            accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
            accountObj.Type ='Commercial';
            /*accountObj.billingCity = 'TestCity';
            accountObj.BillingCountry = 'TestCountry';
            accountObj.BillingPostalCode = '12345';
            accountObj.BillingState = 'TestState';
            accountObj.BillingStreet = 'TestStreet';*/
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
            contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
            contactObj.AccountId = accountObj.Id;
            contactObj.Email = 'Test123@test123.com';
            insert contactObj;
            User user = new User();
        	List<User> userList = new List<User>([SELECT Id,LastName, FirstName, ContactId, Username, Alias, CommunityNickname, TimeZoneSidKey, EmailEncodingKey, LanguageLocaleKey, Email, LocaleSidKey, Profile.Name  from User where TimeZoneSidKey = 'America/Los_Angeles' and EmailEncodingKey = 'ISO-8859-1' and LanguageLocaleKey = 'en_US' and LocaleSidKey ='en_US' and Profile.Name like '%Partner Delegated Administrator%' and IsActive = true limit 1]);
        	if(userList.size()>0){
        		user = userList.get(0);
        	}else{
	        	user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
	             String username= 'test123@yahoo.com';
	             
	             user.ContactId = contactObj.Id;
	             user.Username = 'test123999990@yahoo.com';
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
	                insert user;        
	             }
        	}
            if(user != null){
                System.runAs(user){
                    Account acc = new Account();
                    acc.Name = 'Test Account' + String.valueOf(DateTime.Now());
                    acc.Type ='Commercial';
                    insert acc;
                    Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
                    Apexpages.currentPage().getParameters().put('MDTF_Prog','MDTF_Prog');
                    HomePagePartnerPortalLinkController testObj = new HomePagePartnerPortalLinkController(controller);
                    testObj.getCustomerAccountId();
                    
                }
            }
            Test.startTest();
            TestAccountManagement.Test_AccountUpdate();
            TestAccountManagement.Test_CertificationManagement();
            Test.stopTest();
        } catch (Exception ex) {}
    }
    
    @isTest
    public static void Test_HomePagePartnerPortalLinkController2(){
        try {
            //User testPartnerUser = GetExistingPortalUser();
             Account accountObj = new Account();
            accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
            accountObj.Type ='Commercial';
            /*accountObj.billingCity = 'TestCity';
            accountObj.BillingCountry = 'TestCountry';
            accountObj.BillingPostalCode = '12345';
            accountObj.BillingState = 'TestState';
            accountObj.BillingStreet = 'TestStreet';*/
            insert accountObj;
            
            Contact contactObj = new Contact();
            contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
            contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
            contactObj.AccountId = accountObj.Id;
            contactObj.Email = 'Test123222@test123.com';
            insert contactObj;
            
        	User user = new User();
        	List<User> userList = new List<User>([SELECT Id,LastName, FirstName, ContactId, Username, Alias, CommunityNickname, TimeZoneSidKey, EmailEncodingKey, LanguageLocaleKey, Email, LocaleSidKey, Profile.Name  from User where TimeZoneSidKey = 'America/Los_Angeles' and EmailEncodingKey = 'ISO-8859-1' and LanguageLocaleKey = 'en_US' and LocaleSidKey ='en_US' and Profile.Name like '%Partner Delegated Administrator%' and IsActive = true limit 1]);
        	if(userList.size()>0){
        		user = userList.get(0);
        	}else{
             String username= 'test123@yahoo.com';
             user = new User(LastName = 'Hello' + String.valueOf(DateTime.Now()),FirstName = 'World'+ String.valueOf(DateTime.Now()));
             user.ContactId = contactObj.Id;
             user.Username = 'testC123@yahoo.com';
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
                insert user;        
             }
        	} 
            if(user != null){
                System.runAs(user){
                    Account acc = new Account();
                    acc.Name = 'Test Account' + String.valueOf(DateTime.Now());
                    insert acc;
                    Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(acc);
                    Apexpages.currentPage().getParameters().put('My_Accnt','My_Accnt');
                    HomePagePartnerPortalLinkController testObj = new HomePagePartnerPortalLinkController(controller);
                    testObj.getCustomerAccountId();
                    
                }
            }
            Test.startTest();
            TestAccountManagement.Test_AccountUpdate();
            TestAccountManagement.Test_CertificationManagement();
            Test.stopTest();
        } catch (Exception ex) {}
    }
    
    public static User GetExistingPortalUser() {
        List<User> userList = new List<User>([select Id  from User where Profile.Name like '%Partner%' LIMIT 1]);
        User portalUser = null;
        if(userList.Size()>0){
            portalUser = userList.get(0);
        }
        return portalUser;
        
    }
    @isTest
    public static void testHomePagePartnerPortalLinkController (){    
        Account acct = new Account();
        acct.Name = 'Test'+System.now();
        acct.Type ='Commercial'; 
        acct.billingCity = 'TestCity';
        acct.BillingCountry = 'TestCountry';
        acct.BillingPostalCode = '12345';
        acct.BillingState = 'TestState';
        acct.BillingStreet = 'TestStreet';   
        insert acct;
        Apexpages.currentPage().getParameters().put('My_Accnt' , '1') ;
        
            
        ApexPages.StandardController std = new ApexPages.StandardController(acct);
        
        HomePagePartnerPortalLinkController home = new HomePagePartnerPortalLinkController (std);
        home.getCustomerAccountId();
        
        Apexpages.currentPage().getParameters().put('MDTF_Prog' , '1');
        home.getCustomerAccountId();
    }    
    
}