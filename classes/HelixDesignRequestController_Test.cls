@isTest
private class HelixDesignRequestController_Test {

    private static String tier1 = 'Tier 1';
    private static String tier2 = 'Tier 2';
    private static String defaultVoltage = '480/277 V 3-phase';
    private static String defaultModuleType = 'SPR-E20-435-COM';

	
	@isTest 
	private static void testRoofTier1() {

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

	        Site_Information_Form__c site = getSite(testOpp.Id);
            insert site;
            System.assertNotEquals(null, site.Id);

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('siteId', site.Id);

			ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);
            List<String> msgs = controller.errorMessages;            
            String s = controller.testString;

            controller.saveANDQuit();

            controller.objSite.Nominal_AC_Voltage__c = defaultVoltage;
            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(30);
            controller.savePage1();
            System.assertEquals(controller.errorMessages.size(), 0, controller.errorMessages);

            controller.objDesign.HelixDesignType__c = controller.helixRoof;
            controller.objDesign.ModuleTypeandWattage__c = defaultModuleType;
            controller.setSelectedModule();

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Design_Package_Type__c = tier1;
            d.SetbackDistanceServiceableVent__c = 1;
            d.SetbackDistanceHVAC__c = 1;
			d.Partner_Comments__c = 'TEST COMMENTS';
            d.MaxOuttheRoofSpace__c = true;
            d.HelixDesignType__c = controller.helixRoof;
            d.ModuleTypeandWattage__c = defaultModuleType;

            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg.success, true, msg);
            System.assertEquals(200, msg.payloadMap.get('StatusCode'), msg);

			controller.toDisclaimer();

			controller.submitDesign();

            controller.fetchInfo();

            Test.stopTest();
        }

	}

	@isTest 
	private static void testRoofTier2() {

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

	        Site_Information_Form__c site = getSite(testOpp.Id);
            insert site;
            System.assertNotEquals(null, site.Id);

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('siteId', site.Id);

			ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);

            List<SelectOption> o1 = controller.roofTypeOptions;
            List<SelectOption> o2 = controller.roofMembraneOptions;
            List<SelectOption> o3 = controller.airBarrierOptions;

            controller.objSite.Nominal_AC_Voltage__c = defaultVoltage;
            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(30);
            controller.savePage1();

            controller.objDesign.HelixDesignType__c = controller.helixRoof;
            controller.objDesign.ModuleTypeandWattage__c = defaultModuleType;
            controller.setSelectedModule();

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Design_Package_Type__c = tier2;
            d.SetbackDistanceServiceableVent__c = 1;
            d.SetbackDistanceHVAC__c = 1;
            d.Partner_Comments__c = 'TEST COMMENTS';
            d.MaxOuttheRoofSpace__c = true;
            d.HelixDesignType__c = controller.helixRoof;
            d.ModuleTypeandWattage__c = defaultModuleType;

            //try with no roof first
            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg.success, true, msg);
            System.assertEquals(msg.payloadMap.get('StatusCode'), 403, msg);
            
            Roof_Details__c roof = new Roof_Details__c();
            roof.Height__c = 123;
            roof.Parapet_Wall_Height__c = 1;
            roof.Roof_Slope__c = 1;
            roof.Anchoring_Allowed__c = true;
            roof.With_Roof_Load_Limit__c = true;
            roof.Roof_Load_Limit_Amount_psf__c = 1;
            roof.Roof_Membrane__c = o2[1].getValue();
            roof.Functional_Air_Barrier__c = o3[1].getValue();
            roof.Roof_Type__c = o1[1].getValue();
            roof.Snow_Load__c = 12;
            roof.Roof_Construction__c = 'Existing Roof';
            roof.Design__c = d.Id;

            ResultMessage rfMsg = HelixDesignRequestController.insertNewRoof(JSON.serialize(roof));
            System.assertNotEquals(rfMsg.success, false, rfMsg);

            ResultMessage msg2 = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg2.success, true, msg2);

            String roofId = '';

            ResultMessage rfIdMsg = HelixDesignRequestController.fetchRoofDetails(d.Id);
            System.assertEquals(rfIdMsg.success, true, rfIdMsg);
            List<Roof_Details__c> details = (List<Roof_Details__c>)rfIdMsg.payloadMap.get('details');
            roofId = details[0].Id;

            ResultMessage msg3 = HelixDesignRequestController.deleteSelectedRoof(roofId);
            System.assertEquals(msg3.success, true, msg3);

            Test.stopTest();
        }
	}

    @isTest 
    private static void testTracker() {

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

            Site_Information_Form__c site = getSite(testOpp.Id);
            insert site;

            System.assertNotEquals(null, site.Id);

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('siteId', site.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);
            List<SelectOption> o1 = controller.gcrOptions;
            List<SelectOption> o2 = controller.voltageOptions;
            List<SelectOption> o3 = controller.stateOptions;

            controller.objSite.Nominal_AC_Voltage__c = o2[1].getValue();
            controller.objSite.Site_State__c = o3[1].getValue();
            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(30);
            controller.savePage1();
            System.assertEquals(0, controller.errorMessages.size(), controller.errorMessages);

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Partner_Comments__c = 'TEST COMMENTS';
            d.TargetAnnualProduction__c = 111;
            d.GCR_Requirement__c = '0.6';
            d.HelixDesignType__c = 'Helix Tracker';
            d.ModuleTypeandWattage__c = null;

            //try with no module type first
            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg.success, true, msg);
            System.assertEquals(msg.payloadMap.get('StatusCode'), 403, msg);

            
            controller.objDesign.HelixDesignType__c = 'Helix Tracker';
            controller.objDesign.ModuleTypeandWattage__c = defaultModuleType;
            controller.setSelectedModule();

            ResultMessage msg2 = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg2.success, true, msg2);
            System.assertEquals(msg2.payloadMap.get('StatusCode'), 200, msg2);

            d.GCR_Requirement__c = 'apple';//test catch
            ResultMessage msg3 = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg3.success, true, msg3);
            System.assertEquals(msg3.payloadMap.get('StatusCode'), 400, msg3);

            controller.pageNo = '1';
            controller.navigate();
            controller.pageNo = '2';
            controller.navigate();
            controller.pageNo = '3';
            controller.navigate();
            controller.pageNo = '4';
            controller.navigate();

            controller.toAttachments();

            controller.toDisclaimer();

            controller.objDesign.Dealer_Status__c = null;

            controller.submitDesign();

            Test.stopTest();
        }
    }

    @isTest
    private static void testCarportTier1() {

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

            Site_Information_Form__c site = getSite(testOpp.Id);
            insert site;
            System.assertNotEquals(null, site.Id);

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('siteId', site.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);
            List<String> msgs = controller.errorMessages;            
            String s = controller.testString;

            controller.objSite.Nominal_AC_Voltage__c = defaultVoltage;
            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(30);
            controller.savePage1();
            System.assertEquals(controller.errorMessages.size(), 0, controller.errorMessages);

            controller.objDesign.HelixDesignType__c = controller.helixRoof;
            controller.objDesign.ModuleTypeandWattage__c = defaultModuleType;
            controller.setSelectedModule();

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Design_Package_Type__c = tier1;
            d.Partner_Comments__c = 'TEST COMMENTS';
            d.MaxOuttheRoofSpace__c = true;
            d.HelixDesignType__c = controller.helixRoof;
            d.ModuleTypeandWattage__c = defaultModuleType;
            d.Separate_DC_switch_required__c = true;
            d.Branding__c = true;

            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg.success, true, msg);
            System.assertEquals(200, msg.payloadMap.get('StatusCode'), msg);

            controller.toAttachments();

            controller.toDisclaimer();

            controller.submitDesign();

            Test.stopTest();
        }

    }

    @isTest
    private static void testCarportTier2() {
        
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

            Site_Information_Form__c site = getSite(testOpp.Id);
            insert site;
            System.assertNotEquals(null, site.Id);

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('siteId', site.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);
            List<String> msgs = controller.errorMessages;            
            String s = controller.testString;

            controller.objSite.Nominal_AC_Voltage__c = defaultVoltage;
            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(30);
            controller.savePage1();
            System.assertEquals(controller.errorMessages.size(), 0, controller.errorMessages);

            controller.objDesign.HelixDesignType__c = 'Helix Carport';
            controller.objDesign.ModuleTypeandWattage__c = defaultModuleType;
            controller.setSelectedModule();

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Design_Package_Type__c = tier2;
            d.Partner_Comments__c = 'TEST COMMENTS';
            d.MaxOuttheRoofSpace__c = true;
            d.HelixDesignType__c = 'Helix Carport';
            d.ModuleTypeandWattage__c = defaultModuleType;
            d.Separate_DC_switch_required__c = true;
            d.Branding__c = true;
            d.Min_Clearance_Lower_Edge__c = 12;
            d.Topo_grade_change__c = true;
            d.Topo_grade_change_specify__c = 4;
            d.Soil_Subject_to_Liquefaction__c = false;
            d.Vertical_Uplift_Resistance_Skin_Friction__c = 100;
            d.Excessive_Undocumented_Fill__c = false;
            d.Vertical_Downward_Load_Skin_Friction__c = 300;
            d.Shallow_Bedrock__c = false;
            d.Allowable_Passive_Pressure__c = 100;
            d.Site_Located_in_a_Flood_Plain__c = false;

            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg.success, true, msg);
            System.assertEquals(200, msg.payloadMap.get('StatusCode'), msg);

            controller.toHelixDesignRequest();

            controller.toProductInfo();

            controller.toAttachments();

            controller.toDisclaimer();

            controller.submitDesign();

            Test.stopTest();
        }

    }

	@isTest 
	private static void testReload() {

		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

		Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        Design__c d = new Design__c();
        d.RecordTypeId = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
        insert d;      
        
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

            d.Site__c = site.Id;
            d.Opportunity__c = testOpp.Id;
            update d;

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('siteId', site.Id);
			ApexPages.currentPage().getParameters().put('designId', d.Id);

			ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);

            controller.setDesignType();

            controller.saveANDQuit();

            controller.returnToOpp();

            HelixDesignRequestUtilities util = new HelixDesignRequestUtilities(sc);
            List<SelectOption> o1 = util.gcrOptions;
            List<SelectOption> o2 = util.roofTypeOptions;
            List<SelectOption> o3 = util.roofMembraneOptions;
            List<SelectOption> o4 = util.airBarrierOptions;

            Test.stopTest();
        }
	}

    @isTest
    private static void testCreateNewSite() {

        UserManagement.IS_TEST = true;
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

            Site_Information_Form__c site = getSite(testOpp.Id);
            ResultMessage msg = HelixDesignRequestUtilities.createNewSite(JSON.serialize(site));
        }
    }
	
	
	@isTest 
	private static void testNegatives() {

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

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
			ApexPages.currentPage().getParameters().put('siteId', site.Id);

			ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);
            List<String> msgs = controller.errorMessages;
            String s = controller.testString;

            controller.savePage1();

            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(-1);
            controller.savePage1();

            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(2);

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Design_Package_Type__c = tier1;
            d.Partner_Comments__c = 'TEST COMMENTS';
            d.MaxOuttheRoofSpace__c = true;
            d.HelixDesignType__c = controller.helixRoof;
            d.ModuleTypeandWattage__c = defaultModuleType;
            d.Separate_DC_switch_required__c = true;
            d.Branding__c = true;

            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'seven');//throw casting error
            System.assertEquals(msg.success, false, msg);
            System.assertEquals(400, msg.payloadMap.get('StatusCode'), msg);

            controller.objDesign.GCR_Requirement__c = 'apple';//test catch
            controller.savePage1();
            controller.toHelixDesignRequest();
            controller.toProductInfo();
            controller.toAttachments();
            controller.toDisclaimer();
            controller.submitDesign();

            Test.stopTest();

        }
    }

    @isTest 
    private static void testRevision() {

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

            Site_Information_Form__c site = getSite(testOpp.Id);
            insert site;
            System.assertNotEquals(null, site.Id);

            Test.startTest();

            PageReference pageRef = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('siteId', site.Id);

            ApexPages.StandardController sc = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller = new HelixDesignRequestController(sc);
            List<String> msgs = controller.errorMessages;            
            String s = controller.testString;

            controller.saveANDQuit();

            controller.objSite.Nominal_AC_Voltage__c = defaultVoltage;
            controller.objDesign.Expected_Installation_Date__c = Date.today().addDays(30);
            controller.savePage1();
            System.assertEquals(controller.errorMessages.size(), 0, controller.errorMessages);

            controller.objDesign.HelixDesignType__c = controller.helixRoof;
            controller.objDesign.ModuleTypeandWattage__c = defaultModuleType;
            controller.setSelectedModule();

            Design__c d = new Design__c(Id = controller.objDesign.Id);
            d.Design_Package_Type__c = tier1;
            d.SetbackDistanceServiceableVent__c = 1;
            d.SetbackDistanceHVAC__c = 1;
            d.Partner_Comments__c = 'TEST COMMENTS';
            d.MaxOuttheRoofSpace__c = true;
            d.HelixDesignType__c = controller.helixRoof;
            d.ModuleTypeandWattage__c = defaultModuleType;

            ResultMessage msg = HelixDesignRequestController.saveDesignRequest(JSON.serialize(d), 'true');
            System.assertEquals(msg.success, true, msg);
            System.assertEquals(200, msg.payloadMap.get('StatusCode'), msg);

            controller.toDisclaimer();
            controller.submitDesign();

            controller.objDesign.Status__c = 'Completed';
            controller.objDesign.Dealer_Status__c = controller.designDeliveredStatus;
            update controller.objDesign;

            PageReference pageRef2 = Page.HelixDesignRequest;
            Test.setCurrentPage(pageRef2);
            ApexPages.currentPage().getParameters().put('siteId', site.Id);
            ApexPages.currentPage().getParameters().put('designId', controller.objDesign.Id);
            ApexPages.currentPage().getParameters().put('revision', 'Y');

            ApexPages.StandardController sc2 = new ApexPages.StandardController(testOpp);
            HelixDesignRequestController controller2 = new HelixDesignRequestController(sc2);

            Test.stopTest();
        }

    }


    private static Site_Information_Form__c getSite(Id oppId) {
        Site_Information_Form__c site = new Site_Information_Form__c();
            site.Opportunity_del__c = oppId;
            site.Site_Address__c = '425 County Road 39A';
            site.Site_City__c = 'Southampton';
            site.Site_State__c = 'NY';
            site.Site_Zip_Postal_Code__c = '11968';
            site.Site_Country__c = 'United States';
        return site;
    }	
}