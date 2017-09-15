@isTest
public class QuoteRedirectTest {
    public static testMethod void testRedirect_partnerUser(){  
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
        
        Account commercialAccount = TestFactory_StandardObjects.createCommercialCustomerAccount();
        insert commercialAccount;
        
        Opportunity opp = TestFactory_Commercial.createNewCVARCustomer(partnerAccount.id, commercialAccount.id);
        insert opp;
        
        Quote ppaQuote = TestFactory_Commercial.createPPAQuote(opp.id);
        insert ppaQuote;
              
        ApexPages.StandardController sc = new ApexPages.StandardController(ppaQuote);
        QuoteRedirect qc = new QuoteRedirect(sc);                              

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
            Test.setCurrentPage(qc.redirect());
            Test.stopTest();
        }
    }
    
    public static testMethod void testRedirect_internalUser(){  
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
        
        Account commercialAccount = TestFactory_StandardObjects.createCommercialCustomerAccount();
        insert commercialAccount;
        
        Opportunity opp = TestFactory_Commercial.createNewCVARCustomer(partnerAccount.id, commercialAccount.id);
        insert opp;
        
        Quote ppaQuote = TestFactory_Commercial.createPPAQuote(opp.id);
        insert ppaQuote;
              
        ApexPages.StandardController sc = new ApexPages.StandardController(ppaQuote);
        QuoteRedirect qc = new QuoteRedirect(sc);  
        
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
            Test.setCurrentPage(qc.redirect());
            Test.stopTest();
        }
    }
}