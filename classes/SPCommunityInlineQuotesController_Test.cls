@isTest
public class SPCommunityInlineQuotesController_Test {
    private static final string PPA_PROGRAM = 'Helix PPA Program';
    private static User u;
    private static Contact c;
    private static Opportunity o;
    private static Cost_Matrix__c costMatrix;
    private static PageReference pageRef;
    private static SPCommunityInlineQuotesController theController;

    private static TestMethod void testBasicConstructor() {

        costMatrix = TestFactory_Commercial.createCostMatrix(null);
        costMatrix.Technology_System_Category__c = 'Helix Carport';
        costMatrix.Available_Technology_Systems__c = 'P-Helix Carport V1.0';
        costMatrix.Active__c = true;
        insert costMatrix;
        o = TestFactory_Commercial.getNewCvarCustomer(null, null);
        
        Test.startTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        pageRef = Page.SPCommunityInlineQuotes;
        Test.setCurrentPage(pageRef);

        theController = new SPCommunityInlineQuotesController(sc);

        Test.stopTest();
    }

    private static TestMethod void testConstructorForPPA() {
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        partnerAccount.Special_Programs__c = PPA_PROGRAM;
        insert partnerAccount;
        System.assertNotEquals(partnerAccount.Id, null, 'Partner Account Insert Failed');

        c = TestFactory_StandardObjects.createPartnerContact(partnerAccount.Id);
        insert c;
        System.assertNotEquals(c.Id, null, 'Contact Creation Failed');

        o = TestFactory_Commercial.getNewCvarCustomer(partnerAccount.Id, null);
        System.assertNotEquals(o.Id, null, 'Opportunity Creation Failed');
        
        costMatrix = TestFactory_Commercial.createCostMatrix(null);
        costMatrix.Technology_System_Category__c = 'Helix Carport';
        costMatrix.Available_Technology_Systems__c = 'P-Helix Carport V1.0';
        costMatrix.Active__c = true;
        insert costMatrix;
        System.assertNotEquals(costMatrix.Id, null, 'Cost Matrix Creation Failed');

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
            Test.startTest();
            
            ApexPages.StandardController sc = new ApexPages.StandardController(o);
            pageRef = Page.SPCommunityInlineQuotes;
            Test.setCurrentPage(pageRef);

            theController = new SPCommunityInlineQuotesController(sc);

            Test.stopTest();
        }
    }

}