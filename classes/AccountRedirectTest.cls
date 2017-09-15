@isTest
public class AccountRedirectTest {

    /*public static testMethod void testRedirect_partnerUserNewUI(){  
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
              
        ApexPages.StandardController sc = new ApexPages.StandardController(partnerAccount);
        AccountRedirect ac = new AccountRedirect(sc);                              

        Contact c = TestFactory_StandardObjects.createPartnerContact(partnerAccount.Id);
        insert c;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = c.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=c.Id, UserRole = role,
                          Business_Function__c='Create PPA Quote');
                          
        insert currentUser;
                          
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'UI Phase 2 Access'];
        insert new PermissionSetAssignment(AssigneeId = currentUser.id, PermissionSetId = ps.Id);  
  
        System.runAs(currentUser) {        
            //call remote action method and pass the NewCustomer as parameter
            Test.startTest();
            Test.setCurrentPage(ac.redirect());
            Test.stopTest();
        }
    }*/
    
    public static testMethod void testRedirect_partnerUser(){  
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
              
        ApexPages.StandardController sc = new ApexPages.StandardController(partnerAccount);
        AccountRedirect ac = new AccountRedirect(sc);                              

        Contact c = TestFactory_StandardObjects.createPartnerContact(partnerAccount.Id);
        insert c;

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = c.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=c.Id, UserRole = role,
                          Business_Function__c='Create PPA Quote');                                  
  
        System.runAs(currentUser) {        
            //call remote action method and pass the NewCustomer as parameter
            Test.startTest();
            Test.setCurrentPage(ac.redirect());
            Test.stopTest();
        }
    }
    
    public static testMethod void testRedirect_internalUser(){  
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
              
        ApexPages.StandardController sc = new ApexPages.StandardController(partnerAccount);
        AccountRedirect ac = new AccountRedirect(sc);
        
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('System Administrator');

        User currentUser = new User(alias = 'cashman1', email = 'te@st.only', 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          UserRole = role,
                          Business_Function__c='Create PPA Quote');
  
        System.runAs(currentUser) {        
            //call remote action method and pass the NewCustomer as parameter
            Test.startTest();
            Test.setCurrentPage(ac.redirect());
            Test.stopTest();
        }
    }
}