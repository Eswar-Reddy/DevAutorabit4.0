@isTest
public class AlliancePartnerUtility_Test {
   
   @testSetup static void insertTestData() {
        UserManagement.IS_TEST = true;
        
        Id imuaId = Schema.SObjectType.Project_Installation_Setting__c.getRecordTypeInfosByName().get('IM User Assignment').getRecordTypeId();
        
        Account a = new Account(Name = 'TestAcct' , BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345');
        insert a;

        // Create Partner Account
        Account partner = new Account(Name = 'SPRI - Fremont', BillingCity = 'San Jose', BillingState = 'CA', BillingCountry = 'US', BillingStreet = '123 Main St', BillingPostalCode = '12345', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Partner').getRecordTypeId());
        insert partner;

        // Create test opportunity
        Opportunity o = new Opportunity(Name = 'TestOppt', AccountId = a.Id, CloseDate = system.today(), StageName = 'Contract Signed', Partner_Account_Id__c = partner.Id);
        insert o;

        // Create test Quote
        Quote q = new Quote(OpportunityId = o.Id, Name = 'Test Quote');
        insert q;

        // Create Installation Model
        Installation_Model__c ipim = new Installation_Model__c(Name = 'TPS CA Loan', Financing_Option__c = 'Cash', Roles__c='IP', State__c = 'CA', Type__c='Manual');
        insert ipim;
        
        
        List<Account> partnerAccount = new List<Account> ();
            partnerAccount.add(TestUtils.createAccount('Test Partner IP', TestUtils.getPartnerRecordTypeId(), false));
            partnerAccount.add(TestUtils.createAccount('Test Partner DRIP', TestUtils.getPartnerRecordTypeId(), false));
        insert partnerAccount;
        
        List<Contact> partnerContact = new List<Contact>();
          partnerContact.add(TestUtils.createContact( 'Test Partner Account IP', partnerAccount[0].Id, false));
          partnerContact.add(TestUtils.createContact( 'Test Partner Account DRIP', partnerAccount[1].Id, false));
              partnerContact[0].Email = 'testalliancePartner1@test.com';
              partnerContact[1].Email = 'testalliancePartner2@test.com';
          insert partnerContact; 
     
        List<User> partnerUser =  new List<user>();
         partnerUser.add(TestUtils.createPartnerPortalUser( partnerContact[0], false));
         partnerUser.add(TestUtils.createPartnerPortalUser( partnerContact[1], false));
          partnerUser[0].FirstName = 'AlliancePartnerUser0';
          partnerUser[1].FirstName = 'AlliancePartnerUser1';
          partnerUser[0].username = 'User0' + partnerUser[0].username;
          partnerUser[1].username = 'User1'+ partnerUser[1].username;
          partnerUser[0].Alias = 'User0' + partnerUser[0].Alias;
          partnerUser[1].Alias = 'User1'+ partnerUser[1].Alias;
          partnerUser[0].CommunityNickname = 'User0';
          partnerUser[1].CommunityNickname = 'User1';    
        insert partnerUser;
        
        List<Project_Installation_Setting__c> pisList = new List<Project_Installation_Setting__c>();
            Project_Installation_Setting__c pis = new Project_Installation_Setting__c(RecordTypeId = imuaId, Installation_Model__c = ipim.Id, Installation_Partner__c = partnerAccount[0].Id, Partner_Role__c = 'IP', User__c = partnerUser[0].Id, Role__c = 'Project Manager', State__c = 'CA');
            pisList.add(pis);
            Project_Installation_Setting__c pis1 = new Project_Installation_Setting__c(RecordTypeId = imuaId, Installation_Model__c = ipim.Id, Installation_Partner__c = partnerAccount[1].Id, Partner_Role__c = 'DRIP', User__c = partnerUser[1].Id, Role__c = 'Project Manager', State__c = 'CA');
            pisList.add(pis1);
        insert pisList;

        Residential_Project__c testProject = new Residential_Project__c();
        testProject.RecordTypeId = Schema.SObjectType.Residential_Project__c.getRecordTypeInfosByName().get('TPS').getRecordTypeId();
        testProject.Account__c = a.Id;
        testProject.Opportunity__c = o.Id;
        testProject.Quote__c = q.Id;
        testProject.Installation_Model__c = ipim.Id;
        testProject.Status__c = 'Active'; //Hold, Cancelled or Completed
        testProject.Name = 'TestResidentialProject';
        testProject.CurrencyIsoCode = 'USD';
        insert testProject;
      }
    
    static testMethod void testOppTeamMemberInsert() {
      // TO DO: implement unit test
         
         Residential_Project__c testProject = [select Id,Name from Residential_Project__c where Name = 'TestResidentialProject'];
         List<Account> lstAccount = [select Id,Name from Account where Name ='Test Partner IP' OR Name = 'Test Partner DRIP'];
         
         system.debug('-----' + testProject);
         
         Test.startTest();
          Id apRecType = Schema.SObjectType.Alliance_Partner__c.getRecordTypeInfosByName().get('Project Alliance Partner').getRecordTypeId();
          Alliance_Partner__c ap = new Alliance_Partner__c(Residential_Project__c = testProject.Id, Role__c = 'IP', Partner_Account__c = lstAccount[0].Id, recordTypeId = apRecType);
          insert ap;
          
          ap.Partner_Account__c = lstAccount[1].Id;
          update ap;
        Test.stopTest();
    }
}