/*
 */
@isTest
private class TestALRConfiguration {
    
    private static ID ResidentialRecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Account.SobjectType).get('Home_Owner');
   
    static Id proposalQuoteRecTypeId = Schema.sObjectType.Quote.RecordTypeInfosByName.get('Proposal Quote').RecordTypeId;
    static List<CoverageArea__c> businessReg=new List<CoverageArea__c>();
    static List<CoverageArea__c> businessRegUpdate=new List<CoverageArea__c>();
    
    static testMethod void ALR_ConfigTest() {
        TestALRCommon.CreateCustomSetting();
        
        User sysAdmin = TestClassFactory.testUser('System Administrator', 'test@test.com', 'rtestp');
        sysAdmin.Country = 'USA';
        sysAdmin.Division = 'Test';
        sysAdmin.SOX_Profile_was_approval_received__c = true;
        insert sysAdmin;
        
        system.runAs(sysAdmin){
            
            list<ALR_Theaters__c> lstALR = new list<ALR_Theaters__c>();
            
            lstALR.add(TestClassFactory.testALRTheaterSetting());
            ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
            theater2.Name = 'Australia';
            lstALR.add(theater2);
            
            insert lstALR;
        }
        
        test.startTest();
        list<LeadAssignmentWrapper> lstLeadInfo = new list<LeadAssignmentWrapper>();
        
        Lead objLead1 = getLead('testnoCampaign@t.com','Test Company1');
        objLead1.Dealer_Name__c = system.label.SPDIds;
        objLead1.Lead_Manufacturer__c = null;
        
        // Invalid Lead_Manufacturer__c
        LeadAssignmentWrapper objLeadWrapp1 = new LeadAssignmentWrapper();
        objLeadWrapp1.lead = objLead1;
        lstLeadInfo.add(objLeadWrapp1);
        
        Lead objLead2 = getLead('testnoCampaign@t.com','Test Company1');
        objLead2.Dealer_Name__c = system.label.SPDIds;
        objLead2.Theater__c = null;
        
        // Invalid objLeadInfo.lead.Theater__c
        LeadAssignmentWrapper objLeadWrapp2 = new LeadAssignmentWrapper();
        objLeadWrapp2.lead = objLead2;
        lstLeadInfo.add(objLeadWrapp2);
        
        Account partner = TestALRCommon.Lead_CreateDealer('Partner1');
        partner.Opportunity_Recipient__c = UserInfo.getUserId();
        upsert partner;
        
        Account objAcc = TestClassFactory.testAccount('Test', ResidentialRecordTypeId);
        objAcc.Email__c = 'testnoCampaign@t.com';
        objAcc.Type = 'Elite';
        objAcc.BillingState = 'CO';
        objAcc.BillingStreet = '2905 Inca St';
        objAcc.BillingPostalCode = '80202';
        insert objAcc;
        
        ID oppHomeOwnerRT = TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner');
        Opportunity objOpp = TestClassFactory.testOpportunity('Test', 'New', system.today().addDays(20), oppHomeOwnerRT);
        objOpp.AccountId = objAcc.Id;
        objOpp.Partner_Account_Id__c = objAcc.Id;
        insert objOpp;
        
        // Create quote
        Quote objQuote = createQuote(objAcc,objOpp);
        insert objQuote;
        
        // Invalid Geo
        Lead objLead3 = getLead('testnoCampaign@t.com','Test Company1');
        LeadAssignmentWrapper objLeadWrapp3 = new LeadAssignmentWrapper();
        objLeadWrapp3.lead = objLead3;
        lstLeadInfo.add(objLeadWrapp3);
        insert objLead3;
        
        ALRConfiguration.isLeadValidforALR(lstLeadInfo);
        ALRConfiguration.isALREnabled();
        ALRConfiguration.getDealerGeneral();
        ALRConfiguration.SendEmailAlert('Subject','Body');
        ALRConfiguration.getRandomNumber(12);
        ALRConfiguration.auditUpdate('ALRConfiguration');     
      
        for(CoverageArea__c reg :[SELECT Sector__c FROM CoverageArea__c]){
            reg.Sector__c ='Residential';
            businessRegUpdate.add(reg);
        }
        update businessRegUpdate;
       
        list<LeadAssignmentWrapper> lstwrappers = new list<LeadAssignmentWrapper>();
        LeadAssignmentWrapper objLeadWrapp = new LeadAssignmentWrapper();
        objLeadWrapp.lead = objLead3;
        lstwrappers.add(objLeadWrapp);
        
        //Select q.Id, q.CreatedDate, q.Account__c, q.Name, q.Status From Quotes q WHERE q.CreatedDate >= LAST_N_DAYS:30
        // Dealer Map
        ALRConfiguration.calculateCompetition(lstwrappers);
        ALRConfiguration.failedAssignment(objLeadWrapp,'test');
        system.assertEquals('Authorized-Partner-Combo', ALRConfiguration.AUTHORIZED_PARTNER_COMBO);
        system.assertEquals('Authorized-Partner-Residential', ALRConfiguration.AUTHORIZED_PARTNER_RESIDENTIAL );
        system.assertEquals('Premier-Partner-Combo', ALRConfiguration.PREMIER_PARTNER_COMBO );
        system.assertEquals('Premier-Partner-Residential', ALRConfiguration.PREMIER_PARTNER_RESIDENTIAL );
        system.assertEquals('Elite-Partner-Combo', ALRConfiguration.ELITE_PARTNER_COMBO );
        system.assertEquals('Elite-Partner-Residential', ALRConfiguration.ELITE_PARTNER_RESIDENTIAL );
        system.assertEquals('Master-Partner-Residential', ALRConfiguration.MASTER_PARTNER_RESIDENTIAL );
        system.assertEquals('Master-Partner-Combo', ALRConfiguration.MASTER_PARTNER_COMBO );
        
        test.stopTest();
    }

    static TestMethod void testALRMisc() {
        //public static List <DealerResult> buildCoreDealerList(Map <Id, Account> dealerMap, 
              //LeadAssignmentWrapper objLead, 
              //DealerGeneral__c c, 
              //String foundCampaignId, 
              //String dealerPriority, 
              //Boolean useDealerMin, 
              //Boolean useDealerMax, 
              //Boolean omitFinancePartners){
        TestALRCommon.CreateCustomSetting();
        List<ALR_Theaters__c> lstALR = new List<ALR_Theaters__c>();
            
        lstALR.add(TestClassFactory.testALRTheaterSetting());
        ALR_Theaters__c theater2 = TestClassFactory.testALRTheaterSetting();
        theater2.Name = 'Australia';
        lstALR.add(theater2);
        
        insert lstALR;

        DealerGeneral__c dg = DealerGeneral__c.getInstance(UserInfo.getOrganizationId());

        Account testDealer = TestClassFactory.CreateDealer('Test Dealer', 'North America');
        System.assertNotEquals(null, testDealer.Id);

        List<CoverageArea__c> areas = new List<CoverageArea__c>();
        for(CoverageArea__c ca : [SELECT Id, Sector__c FROM CoverageArea__c WHERE Account__c =: testDealer.Id]) {
            ca.Sector__c = 'Residential';
            areas.add(ca);
        }
        update areas;

        Test.startTest();

        Map<Id, Account> dealerMap = DealerSOQLUtil.buildAllDealersMap();

        Set<String> dealerIds = new Set<String>();
        dealerIds.add(testDealer.Id);
        dealerMap = DealerSOQLUtil.buildAllDealersMapReassignment(dealerIds);
        
        Lead objLead1 = getLead('testnoCampaign@t.com','Test Company1');
        objLead1.Lead_Manufacturer__c = '';
        insert objLead1;

        objLead1.Lead_Manufacturer__c = 'SunPower';
        objLead1.Latitude = 39.718887;
        objLead1.Longitude = -104.974036;

        Lead_Dealer_Assignment_Audit__c ldaa = createLeadDealerAssignment(testDealer, new Campaign());
        List<Lead_Dealer_Assignment_Audit__c> auditList = DealerSOQLUtil.GetPreviouslyAssignedDealers(objLead1.Id);

        Campaign testCampaign = TestClassFactory.testCampaign('TestClassCampaign');
        insert testCampaign;

        Campaign testCampaign2 = DealerSOQLUtil.getCampaignById(testCampaign.Id);

        Campaign_Partner__c testCampaignPartner = TestClassFactory.testCampaignPartner('Test Partner', testCampaign.Id, testDealer.Id, true, 'Standard');
        insert testCampaignPartner;

        CampaignMember cm = new CampaignMember(LeadId = objLead1.Id, CampaignId = testCampaign.Id, Status = 'Responded');
        insert cm;

        LeadAssignmentWrapper objLeadWrapp = new LeadAssignmentWrapper();
        objLeadWrapp.lead = objLead1;

        Set<Id> leadIds = new Set<Id>();
        leadIds.add(objLead1.Id);
        List<Lead> leadList = DealerSOQLUtil.getLeadByIdforReassignment(leadIds);
        Map<Id, CampaignMember> members = DealerSOQLUtil.getCampaignMemberByLeadId(leadIds);

        Map<Id, map<Id, Integer>> countMap = DealerSOQLUtil.buildCampaignAssignmentCountMap(dealerMap);

        List<Campaign_Partner__c> camPartner = DealerSOQLUtil.getCampaignPartnerByCampIdandPartner(dealerMap.keySet(), testCampaign.Id);

        Id partnerRecTypeId = SFDCSpecialUtilities.getRecordTypeIdsByDeveloperName(Account.SObjectType).get('Partner');
        for(Account a : [SELECT Id, Name, Type, Account_Display_Name__c,Partner_Logo__c,Dealer_Score_Total__c, Dealer_Locator_Phone__c, 
                                Phone, BillingStreet, BillingCity, BillingState, BillingCountry, BillingPostalCode, 
                                Opportunity_Recipient__c, Website, Oracle_Account_Number__c, Description, Opportunity_Recipient__r.Email,
                                Partner_Facts__c, Alliance_Program_Partner__c, Dealer_Locator_Opt_Out__c, 
                                Additional_Opportunity_Email_Recipient__c,Lead_Flow_Opt_Out__c, Lead_Assignment_Count__c, 
                                Lead_Priority_Minimum__c, Lead_Priority_Maximum__c, Last_Assigned_Date__c, Priority_Assignment__c, 
                                Dealer_Tier__c, Business_Function__c, 
                                (SELECT Geolocation__Latitude__s, 
                                        Geolocation__Longitude__s, Radius__c, Account__c 
                                 FROM Coverage_Areas__r 
                                 WHERE Radius__c > 0
                                 AND Sector__c = 'Residential'), //Crystal added conditional for BU per req PT #116798891 - Re-Org Coverage Area Object
                                (SELECT Id 
                                 FROM  Agreements__r 
                                 WHERE Echosign_dev1__Status__c = 'Signed' 
                                 AND Agreement_Type_2__c = 'Partner Agreement' 
                                 AND Name LIKE '%Lead Handling Policy Agreement'), 
                                (SELECT Id, State__c, Country__c 
                                 FROM Business_Registrations__r), 
                                (SELECT Partner__c, Enabled__c, 
                                        Enable_Date__c, Disable_Date__c, 
                                        Partner_Type__c, Campaign__r.Type 
                                 FROM Campaign_Partners__r), 
                                (SELECT Campaign__c 
                                 //FROM Dealer_Assignment_Audit__r 
                                 FROM Lead_Dealer_Assignment_Audit__r
                                 WHERE Campaign__c != NULL AND Active_Assignment__c = 1) 
                         FROM Account 
                         WHERE RecordTypeId =: partnerRecTypeId]) {
            dealerMap.put(a.Id, a);
        }

        List<DealerResult> result = ALRConfiguration.buildCoreDealerList(dealerMap, objLeadWrapp, dg, testCampaign.Id, null, false, false, true);

        List<DealerResult> result2 = ALRConfiguration.cleanDealerList(ALRConfiguration.ALLIANCEPARTNERS, result);

        Test.stopTest();
    }
    
    static testMethod void ALR_SPDFive9Test()
    {
            
        Five9WebserviceCalloutSettings__c objFive9Web = new Five9WebserviceCalloutSettings__c();
        objFive9Web.Name = 'Five9';
        objFive9Web.APIURL__c = 'https://api.five9.com/web2campaign/AddToList';
        insert objFive9Web;
        
        test.startTest();
        Lead objLead = getLead('test@t.com','Test Company');
        insert objLead;
        
        list<Lead> lstLead = new list<Lead>();
        lstLead.add(objLead);
        
        // Added by Ganesh
        list<LeadAssignmentWrapper> lstLeadInfo = new list<LeadAssignmentWrapper>();
        LeadAssignmentWrapper objLeadWrapp2 = new LeadAssignmentWrapper();
        Lead objLead2 = getLead('testnoCampaign@t.com','Test Company1');
        objLead2.Dealer_Name__c = system.label.SPDIds;
        objLead2.Theater__c = null;
        objLeadWrapp2.lead = objLead2;
        
        //Added by Ritesh to test Delay campaign feature
        Campaign cNewParent = new Campaign(Name ='TestParent', Type = 'Other');
         insert cNewParent;
        Campaign cNew = new Campaign(Name ='Test', Type = 'Other');
        cNew.ParentId=cNewParent.Id;
        insert cNew;
        objLeadWrapp2.campaign=cNew;
        lstLeadInfo.add(objLeadWrapp2);
        system.debug('TEST lstLeadInfo '+lstLeadInfo);
        //Changes related to five 9 delay
        Five9CampaignDelaySettings__c setting = new Five9CampaignDelaySettings__c();
        setting.Name='Retail - OSH';
        setting.Campaign_Name__c= 'Retail - OSH';
        setting.Delay_in_mins__c= 2;
        setting.ListName__c= 'OSH_2_Hour_Delay';
        setting.CampaignId__c=String.valueOf(cNewParent.Id);
        insert setting;
       
        /* Done adding */
        
        Map<String, String> f9lead = new Map<String, String>();
        f9lead.put('F9list', 'test');
        Test.setMock(HttpCalloutMock.class, new F9Web2CampaignMockHttpReponse());
        ALRConfiguration.callfive9forSPDLead(lstLeadInfo);
        
        test.stopTest();
    }
    
    private static Lead getLead(String Email,String CompanyName){
     
      
        Lead newLead = TestClassFactory.testLead('TestLastName',CompanyName, Email);
        newLead.Street = '2905 Inca St';
        newLead.City = 'Denver';
        newLead.State = 'CO';
        newLead.PostalCode = '80202';
        newLead.MobilePhone = '4157588021';
        newlead.Phone = '4157588021';
        newLead.Country = 'United States';
        newLead.IsAutoConvert__c = FALSE;
        newLead.RecordTypeId = SFDCSpecialUtilities.GetRecordTypeIdsByDeveloperName(Lead.SobjectType).get('Residential');
        newLead.Theater__c = 'North America';
        newLead.Status = 'Marketing Qualified';
        newLead.Lead_Manufacturer__c =  system.label.ALR_Lead_SunPower;
        return newLead;
    }
    
    private static Quote createQuote(Account testAccount, Opportunity testOpp)
    {
    
    
        Quote testQuote = new Quote();
        testQuote.Name = 'testQuote123_' + Date.today();
        testQuote.OpportunityId = testOpp.Id;
        testQuote.Account__c = testAccount.Id;
        testQuote.BillingCity = testAccount.BillingCity;
        testQuote.BillingStreet = testAccount.BillingStreet;
        testQuote.BillingState = testAccount.BillingState;
        testQuote.BillingCountry = testAccount.BillingCountry;
        testQuote.First_Monthly_Payment_Base_Amount__c = 100.00;
        testQuote.InstallDate__c = 'July 2015';
        testQuote.RecordTypeId = proposalQuoteRecTypeId;
        testQuote.Sales_Tax__c = 0.0;
        testQuote.Lease_Annual_Escalation__c = 2.0;
        testQuote.System_Production_Year_1__c = 6197.06;
        testQuote.Customer_Electric_Utility__c = 'Pacific Gas and Electric Company (PG&E)';
        testQuote.Customer_Rate_Name__c = 'CA_PGE_E1_x_B';
        testQuote.Lessor__c = 'SunPower Capital, LLC';
        testQuote.Total_Energy__c = 6197;
        testQuote.QuoteType__c = 'Lease';
        testQuote.System_Cost__c = 30000;
        testQuote.Dealer_Fees__c = 16397.00;
        testQuote.Description = 'Quote Description';
        testQuote.Quote_type__c = 'Residential Lease Quotation';
        
        return testQuote;
       // insert testQuote;
    }
    
    static TestMethod void TestBuildNewHomesDealerList() {
    
       
        Account a = TestClassFactory.CreateDealer('TestdealerName', 'North America');
        
         for(CoverageArea__c reg :[SELECT Sector__c FROM CoverageArea__c]){
        reg.Sector__c ='Residential';
        businessRegUpdate.add(reg);
       }
       update businessRegUpdate;
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        insert c;
        
        List<Campaign_Partner__c> cps = new List<Campaign_Partner__c>();
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, a.Id, true, 'Standard');
        cps.add(cp);
        insert cps;
        
        Map<Id, Account> dealerMap = new Map<Id, Account>();
        dealerMap.put(a.Id, a);
        
        LeadAssignmentWrapper w = new LeadAssignmentWrapper();
        
        
        
        Test.startTest();
        ALRConfiguration.buildNewHomesDealerList(dealerMap, w, String.valueOf(c.Id), cps);   
        Test.stopTest();
    }
    
    static TestMethod void testRandomSelection() {
        Account a = TestClassFactory.CreateDealer('TestdealerName', 'North America');
        Account a2 = TestClassFactory.CreateDealer('Testdealer2', 'North America');
        
     for(CoverageArea__c reg :[SELECT Sector__c FROM CoverageArea__c]){
        reg.Sector__c ='Residential';
        businessRegUpdate.add(reg);
        }
       update businessRegUpdate;
 
               
        Test.startTest();
        
        List<Lead> leads = new List<Lead>();
        Lead l1 = TestClassFactory.testLead('lastName1', 'testcompany1', 'test1email@noemail.com');
        leads.add(l1);
        
        Lead l2 = TestClassFactory.testLead('lastName2', 'testcompany2', 'test2email@noemail.com');
        leads.add(l2);
        
        insert leads;
        
        Campaign c = new Campaign(Name ='Test', Type = 'Other');
        insert c;
        
        List<Campaign_Partner__c> cps = new List<Campaign_Partner__c>();
        Campaign_Partner__c cp  = TestClassFactory.testCampaignPartner('A', c.Id, a.Id, true, 'Standard');
        cps.add(cp);
        Campaign_Partner__c cp2  = TestClassFactory.testCampaignPartner('B', c.Id, a2.Id, true, 'Standard');
        cps.add(cp2);
        insert cps;
        
        List<DealerResult> drs = new List<DealerResult>();
        
        DealerResult dr1 = new DealerResult(a.Id,'Test','NoType',40.0,40.0,100.0,50.0,'888-888-8888','888-888-8888','125 Corona','Denver','CO','USA','80218','www.sunpowercorp.com','123','none','none',false,null, false, false);
        drs.add(dr1);
        DealerResult dr2 = new DealerResult(a2.Id,'Test','NoType',40.0,40.0,99.0,49.0,'888-888-8888','888-888-8888','125 Corona','Denver','CO','USA','80218','www.sunpowercorp.com','123','none','none',false,null, false, false);
        drs.add(dr2);

        List<Lead_Dealer_Assignment_Audit__c> auditList = new List<Lead_Dealer_Assignment_Audit__c>();
        Lead_Dealer_Assignment_Audit__c audit = createLeadDealerAssignment(a, c);
        audit.Lead__c = l1.Id;
        auditList.add(audit);
        
        Lead_Dealer_Assignment_Audit__c audit2 = createLeadDealerAssignment(a2, c);
        audit2.Lead__c = l2.Id;
        auditList.add(audit2);
        
        insert auditList;
        
        
        ALRConfiguration.GetSingleDealerBasedOnWeightedScore(drs, audit);
        ALRConfiguration.GetSingleDealerBasedOnRandomEvenDistribution(drs, c.Id);
        Test.stopTest();

    }
    
    private static Lead_Dealer_Assignment_Audit__c createLeadDealerAssignment(Account acc, Campaign cam)
    {
    
        Lead_Dealer_Assignment_Audit__c objDAA = new Lead_Dealer_Assignment_Audit__c();
        objDAA.Campaign__c = cam.id;
        objDAA.Dealer_Assigned__c = acc.id;
        objDAA.Assignment_Date__c = system.today();
        objDAA.ALR_Rule_Applied__c = 'Testing';
        objDAA.Name = 'Dealer Assigned 1';
        return objDAA;
    }
}