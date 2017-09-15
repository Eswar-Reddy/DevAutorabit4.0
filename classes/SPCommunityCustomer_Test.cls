@isTest
public class SPCommunityCustomer_Test{

    //test basic constructor
    private static TestMethod void testBasicConstructor() {

        Test.startTest();
        SPCommunityCustomer constructor = new SPCommunityCustomer();
        Test.stopTest();
    }
    
    
    public static testMethod void getRecordHistory(){        
        String parentId;        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
        
        parentId = partnerAccount.Id;
        
        SPCommunityCustomer.getRecordHistory(parentId);
    }

    public static TestMethod void getNotesAndAttachments() {
        String parentId;        
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
        
        parentId = partnerAccount.Id;

        Document__c d = new Document__c(Account__c = parentId);
        insert d;

        List<Attachment> atts = new List<Attachment>();
        Blob b = Blob.valueOf('Test');
        Attachment a = new Attachment(ParentId = parentId, Body = b, Name ='Test Att1');
        atts.add(a);
        Attachment a2 = new Attachment(ParentId = d.Id, Body = b, Name ='Test Att2');
        atts.add(a2);

        insert atts;

        Test.startTest();
        ResultMessage m = SPCommunityCustomer.getNotesAndAttachments(new List<String>{parentId});
        System.assertEquals(true, m.success);
        Test.stopTest();
    }

    public static TestMethod void getNotesAndAttachments_Negative() {

        Test.startTest();
        ResultMessage m = SPCommunityCustomer.getNotesAndAttachments(new List<String>());
        System.assertEquals(false, m.success);
        Test.stopTest();
    }

    public static TestMethod void getUserPermissions() {
        Opportunity o = TestFactory_Commercial.createNewCVARCustomer(null,null);

        Test.startTest();
        ResultMessage m = SPCommunityCustomer.getUserPermissionsEx(o.AccountId, o.Id);
        System.assertEquals(true, m.success);
        Test.stopTest();
    }
    
    public static testMethod void  getSiteList() {
        //create test opportunity record
        Account partnerAccount = TestFactory_StandardObjects.createPartnerAccount();
        insert partnerAccount;
        
        Opportunity opp = TestFactory_StandardObjects.createCvarOpportunity(partnerAccount.id, partnerAccount.id);
        insert opp;
        String opportunityId = opp.id;
                        
        SPCommunityCustomer.getSiteList(opportunityId); 
    } 
    
    public static testMethod void getOwnerList_UnauthorizedUser() {
       
        Test.startTest();
        
        ResultMessage message = SPCommunityCustomer.getOwnerList();
        System.assertEquals(message.err,SPCommunityErrorUtility.unauthorizedUser);
        System.assertEquals(message.success, false);

        Test.stopTest();
    }        
    
    public static testMethod void getOwnerList() {
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
            Test.startTest();
            
            ResultMessage message = SPCommunityCustomer.getOwnerList();
            System.assertEquals(message.err,null);
            System.assertEquals(message.success, true);
            
            Test.stopTest();
        }
    }
    
    public static testMethod void getDependentPicklist() {
        String controllingFieldName = 'Industry';        
        
        SPCommunityCustomer.getDependentPicklist(controllingFieldName);
    }

    public static testMethod void getDependentPicklist_Negative() {
        String controllingFieldName = '';

        DependentPicklistHandler.CustomDependentPicklist pList = new DependentPicklistHandler.CustomDependentPicklist();        
        
        SPCommunityCustomer.getDependentPicklist(controllingFieldName);
    }
    
    public static testMethod void getOpportunityPicklists(){  
        //blank accountType     
        SPCommunityCustomer.getOpportunityPicklists('');
        
        SPCommunityCustomer.getOpportunityPicklists('Commercial');
        
        SPCommunityCustomer.getOpportunityPicklists('Home Owner');
    }
    
    public static testMethod void getObjectPicklists(){
        //blank objectype
        SPCommunityCustomer.getObjectPicklists('');
        
        SPCommunityCustomer.getObjectPicklists('Opportunity');

        SPCommunityCustomer.getObjectPicklists('Contact');
    }
}