/*
Test class for Helix Design Studio: inline design request page and design summary output
Commercial Scrum Team
Last update: 2/7/2017
Classes covered: 
InlineDesignRequestController
HelixDesignSummaryController


*/

@isTest
private class InlineDesignRequestController_Test {

    @isTest 
    private static void testInlineDesignRequest_nonAuroraUser() {

        Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;      

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        System.runAs(currentUser) {
            Opportunity testOpp = TestClassFactory.testOpportunity('TestOpp1', '12% - Qualified Opportunity', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeID('Opportunity', 'Commercial'));
            testOpp.AccountId = testPartner.Id;
            insert testOpp;
            System.assertNotEquals(null, testOpp.Id);

            Site_Information_Form__c site = new Site_Information_Form__c();
            site.Opportunity_del__c = testOpp.Id;
            site.Site_Address__c = '425 County Road 39A';
            site.Site_City__c = 'Southampton';
            site.Site_State__c = 'NY';
            site.Site_Zip_Postal_Code__c = '11968';
            site.Site_Country__c = 'United States';
            insert site;
            System.assertNotEquals(null, site.Id);
            
            Design__c design = new Design__c();
            design.Status__c = 'STATUS_CUSTOMER_SERVICE';
            design.Site__c = site.Id;
            design.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
            design.Date_Design_Completed__c = date.newInstance(2000,12,12);
            design.Design_Tracking__c = system.today();
            design.HelixDesignType__c = 'Helix Roof';
            design.Project_Contact_Person__c = partnerContact.Id;
            design.DealerName__c =  testPartner.Id;
            design.Record_Drawings_Actual_Submit__c = system.today();
            design.Record_Drawings_Red_lines_Received__c=date.newInstance(2011,12,12);
            design.Permit_Award_Actual__c=date.newInstance(2011,2,12);
            design.Plan_Check_Actual_Submit__c=date.newInstance(2011,3,23);
            design.Client_Approve_Package__c=date.newInstance(2011,2,2);
            design.Client_Review_Actual_Submit__c=date.newInstance(2009,2,2);
            design.X75_Percent_Briefing_Meeting__c=date.newInstance(2010,12,2);
            design.Opportunity__c = testOpp.Id;
            design.Design_Originated_By__c = 'Request';  
            insert design; 
           
            Test.startTest();

                PageReference pageRef = Page.InlineDesignRequest;
                Test.setCurrentPage(pageRef);
                ApexPages.currentPage().getParameters().put('Id', testOpp.Id);

                ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
                InlineDesignRequestController  controller = new InlineDesignRequestController (sc);
                List<Site_Information_Form__c> sites = controller.siteList;
                Boolean isAurora = controller.auroraUser;

                PageReference pageRef2 = Page.HelixDesignSummary;
                Test.setCurrentPage(pageRef2);
                ApexPages.currentPage().getParameters().put('Id', design.Id);

                ApexPages.StandardController sc2 = new ApexPages.StandardController(design);
                HelixDesignSummaryController controller2 = new HelixDesignSummaryController(sc2);

            Test.stopTest();
        }
    }

    @isTest 
    private static void testInlineDesignRequest_AuroraUser() {

        Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

        Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;      

        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role,
                                    business_function__c = 'Commercial Aurora Design Licensee');

        System.runAs(currentUser) {
          Opportunity testOpp = TestClassFactory.testOpportunity('TestOpp1', '12% - Qualified Opportunity', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeID('Opportunity', 'Commercial'));
          testOpp.AccountId = testPartner.Id;
          insert testOpp;
          System.assertNotEquals(null, testOpp.Id);

          Site_Information_Form__c site = new Site_Information_Form__c();
            site.Opportunity_del__c = testOpp.Id;
            site.Site_Address__c = '425 County Road 39A';
            site.Site_City__c = 'Southampton';
            site.Site_State__c = 'NY';
            site.Site_Zip_Postal_Code__c = '11968';
            site.Site_Country__c = 'United States';
            insert site;
            System.assertNotEquals(null, site.Id);
            
            Design__c design = new Design__c();
            design.Status__c = 'STATUS_CUSTOMER_SERVICE';
            design.Site__c = site.Id;
            design.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
            design.Date_Design_Completed__c = date.newInstance(2000,12,12);
            design.Design_Tracking__c = system.today();
            design.HelixDesignType__c = 'Helix Roof';
            design.Project_Contact_Person__c = partnerContact.Id;
            design.DealerName__c =  testPartner.Id;
            design.Record_Drawings_Actual_Submit__c = system.today();
            design.Record_Drawings_Red_lines_Received__c=date.newInstance(2011,12,12);
            design.Permit_Award_Actual__c=date.newInstance(2011,2,12);
            design.Plan_Check_Actual_Submit__c=date.newInstance(2011,3,23);
            design.Client_Approve_Package__c=date.newInstance(2011,2,2);
            design.Client_Review_Actual_Submit__c=date.newInstance(2009,2,2);
            design.X75_Percent_Briefing_Meeting__c=date.newInstance(2010,12,2);
            design.Opportunity__c = testOpp.Id;
            design.Design_Originated_By__c = 'Indirect';  
            insert design; 
           
            Test.startTest();

            PageReference pageRef = Page.InlineDesignRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('Id', testOpp.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            InlineDesignRequestController  controller = new InlineDesignRequestController (sc);
            List<Site_Information_Form__c> sites = controller.siteList;

            Test.stopTest();
        }
    }
}