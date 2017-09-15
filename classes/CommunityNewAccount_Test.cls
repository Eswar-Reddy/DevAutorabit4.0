@isTest
public class CommunityNewAccount_Test{
    private static User u;
    private static Contact c;

    //SHARED TESTS
    public static TestMethod void dependentPicklistTest() {
        Test.startTest();

        DependentPicklistHandler.CustomDependentPicklist results = CommunityNewAccount.getDependentPicklist('Industry');
        System.assertEquals(results.success, true);
        System.assertNotEquals(results.optionsMap, null);

        Test.stopTest();
    }

    public static TestMethod void test_getOppPicklists_Commercial() {
        Test.startTest();

        ResultMessage message = CommunityNewAccount.getOpportunityPicklists(CommunityNewAccount.COMMERCIAL);
        System.assertNotEquals(message, null);
        System.assertNotEquals(message.payloadMap, null);
        System.assert(String.isBlank(message.message));

        Test.stopTest();
    }

    public static TestMethod void test_getOppPicklists_Resi() {
        Test.startTest();

        ResultMessage message = CommunityNewAccount.getOpportunityPicklists(CommunityNewAccount.HOME_OWNER);
        System.assertNotEquals(message, null);
        System.assertNotEquals(message.payloadMap, null);
        System.assert(String.isBlank(message.message));

        Test.stopTest();
    }

    public static TestMethod void test_getOppPicklists_Blank() {
        Test.startTest();

        ResultMessage message = CommunityNewAccount.getOpportunityPicklists('');
        System.assertNotEquals(message, null);
        System.assertEquals(message.success, false);
        System.assert(String.isNotBlank(message.message));

        Test.stopTest();
    }

    //CVAR TESTS
    public static testMethod void createNewCustomer(){
        CommunityNewAccount.NewCustomer newCustomerInput = getCVARCustomer();
        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;

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
            SPCommunityCustomer.createNewCustomer(newCustomerInput);
            Test.stopTest();
        }
    }

    public static testMethod void createNewCustomer_InvalidUser(){
        CommunityNewAccount.NewCustomer newCustomerInput = getCVARCustomer();

        //call remote action method and pass the NewCustomer as parameter
        Test.startTest();
        SPCommunityCustomer.createNewCustomer(newCustomerInput);
        Test.stopTest();

    }

    public static testMethod void createNewCustomer_InvalidAccount(){
        CommunityNewAccount.NewCustomer newCustomerInput = getCVARCustomer();
        newCustomerInput.accountName = null;
        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;

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
            SPCommunityCustomer.createNewCustomer(newCustomerInput);
            Test.stopTest();
        }
    }

    public static testMethod void createNewCustomer_InvalidOpportunity(){
        CommunityNewAccount.NewCustomer newCustomerInput = getCVARCustomer();
        newCustomerInput.closeDate = null;
        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;

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
            SPCommunityCustomer.createNewCustomer(newCustomerInput);
            Test.stopTest();
        }
    }

    public static testMethod void createNewCustomer_InvalidContact(){
        CommunityNewAccount.NewCustomer newCustomerInput = getCVARCustomer();
        newCustomerInput.lastName = null;
        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;

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
            SPCommunityCustomer.createNewCustomer(newCustomerInput);
            Test.stopTest();
        }
    }

    private static CommunityNewAccount.NewCustomer getCVARCustomer() {
        CommunityNewAccount.NewCustomer newCustomerInput = new CommunityNewAccount.NewCustomer();
        newCustomerInput.accountType = 'Commercial';
        newCustomerInput.accountName = 'Test Account';
        newCustomerInput.firstName = 'Test FName';
        newCustomerInput.lastName = 'TestLName';
        newCustomerInput.email = 'Test_TestLName@testemail.erg';
        newCustomerInput.phone = '1234567890';
        newCustomerInput.latitude = 37.4049265;
        newCustomerInput.longitude = -121.9450918;
        newCustomerInput.street = '66 Rio Robles';
        //newCustomerInput.street2 = - TODO: Check how this currently functions
        newCustomerInput.state = 'CA';
        newCustomerInput.city = 'San Jose';
        newCustomerInput.postalCode = '95134';
        newCustomerInput.country = 'United States';
        newCustomerInput.industry = '';
        newCustomerInput.vertical = '';
        newCustomerInput.closeDate = System.Today();
        newCustomerInput.installationDate = System.Today() + 30;
        newCustomerInput.codDate = System.Today() + 15;
        newCustomerInput.dealType = ''; 

        return newCustomerInput; 
    }
    

    //RVAR TESTS
    private static testMethod void testResidentialInput(){
        //initialize a NewCustomer input parameter
        CommunityNewAccount.NewCustomer newCustomerInput = new CommunityNewAccount.NewCustomer();
        
        newCustomerInput.accountType = 'Home Owner';
        newCustomerInput.accountName = 'Test Account';
        newCustomerInput.firstName = 'Test FName';
        newCustomerInput.lastName = 'TestLName';
        newCustomerInput.email = 'Test_TestLName@testemail.erg';
        newCustomerInput.phone = '1234567890';
        newCustomerInput.latitude = 37.4049265;
        newCustomerInput.longitude = -121.9450918;
        newCustomerInput.street = '66 Rio Robles';
        //newCustomerInput.street2 = - TODO: Check how this currently functions
        newCustomerInput.state = 'CA';
        newCustomerInput.city = 'San Jose';
        newCustomerInput.postalCode = '95134';
        newCustomerInput.country = 'United States';
        newCustomerInput.industry = '';
        newCustomerInput.vertical = '';
        newCustomerInput.closeDate = System.Today();
        newCustomerInput.installationDate = System.Today() + 30;
        newCustomerInput.codDate = System.Today() + 15;
        newCustomerInput.dealType = '';            
        //newCustomerInput.Lead_Referral_Name =
        
        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;

        c = TestFactory_StandardObjects.createPartnerContact(partnerAccount.Id);
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
            CommunityNewAccount.createNewCustomer(newCustomerInput);
            Test.stopTest();
        }
    }
}