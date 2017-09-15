@isTest
global class InlineDealerLocatorController_TEST {
        
    static TestMethod void testPreQualWithGeo() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        Account a = TestClassFactory.CreateDealer('dealerName', 'North America');
        CoverageArea__c ca;
        try {
            ca = [SELECT Id, Sector__c FROM CoverageArea__c WHERE Account__c =: a.Id];
            ca.Sector__c = 'Residential';
            update ca;
        } catch(Exception e) { System.debug('NO CA'); }
        
        Campaign c = TestClassFactory.testCampaign('Test Campaign');
        c.AssignRandomPartner__c = true;
                c.Requires_Lead_Pre_Qualification__c = true;
        insert c;
        
        Campaign_Partner__c cp = TestClassFactory.testCampaignPartner('name', c.id, a.id, true, 'Standard');
        insert cp;
        
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Lat__c = a.Geolocation__Latitude__s;
        l.log__c =  a.Geolocation__Longitude__s;           
    insert l;
        
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;
        insert cm;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
       
        Test.stopTest();        
    }
    
    static TestMethod void testMulitplePaidWithGeo() {
        
        List<Account> accounts = TestUtils.createAccounts(8, false);
        List<Account> updates = new List<Account>();
        for(Account a : accounts) {
            a.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Account', 'Partner');
            a.Type = 'Master-Partner-Residential';
            a.Status__c = 'Active';
            a.Dealer_Locator_Phone__c = '888-888-8888';
            a.Phone = '888-888-8888';
            a.BillingStreet = '150 Corona St';
            a.BillingCity = 'Denver';
            a.BillingState = 'CO';
            a.BillingCountry = 'United States';
            a.BillingPostalCode = '80218';
            a.Dealer_Locator_Opt_Out__c = false;
            a.Lead_Flow_Opt_Out__c = false;
            a.Alliance_Program_Partner__c = true;
            a.Geolocation__Latitude__s = 39.718887;
            a.Geolocation__Longitude__s = -104.974036;
            a.Theater__c = 'North America';
            updates.add(a);
        }
        updates[0].Type = 'Premier-Partner-Residential';
        insert updates;
        
        Test.startTest();
        
        Campaign c = TestClassFactory.testCampaign('Test Campaign');
        c.Campaign_ID__c = 'Test ' + Date.today();
        c.AssignRandomPartner__c = true;
        c.Description = 'Test';
        c.Short_Description__c = 'Test';
        c.IsActive = true;
        c.Promo_Code__c = 'TEST_PAID';
        insert c;
        
        List<CoverageArea__c> areas = new List<CoverageArea__c>();
        List<Campaign_Partner__c> cpartners = new List<Campaign_Partner__c>();
        List<Lead_Dealer_Assignment_Audit__c> audits = new List<Lead_Dealer_Assignment_Audit__c>();
        for(Account acc : updates) {
            CoverageArea__c ca = new CoverageArea__c();
            ca.Account__c = acc.Id;
            ca.Geolocation__Latitude__s = 39.718887;
            ca.Geolocation__Longitude__s = -104.974036;
            ca.Radius__c = 40;
            ca.Sector__c = 'Residential';
            areas.add(ca);
            Campaign_Partner__c cp = TestClassFactory.testCampaignPartner('name', c.id, acc.id, true, 'Standard');
            cpartners.add(cp);
            Lead_Dealer_Assignment_Audit__c la = new Lead_Dealer_Assignment_Audit__c(Campaign__c = c.id, Dealer_Assigned__c = acc.id, Assignment_Date__c = system.today(), ALR_Rule_Applied__c = 'Testing', Name = 'Dealer Assigned 1');
            audits.add(la);
        }
        insert areas;
        
        audits.remove(0);
        insert audits;
        
        cpartners[0].Partner_Type__c = 'Warm Transfer';
        cpartners[1].enabled__c = false;
        insert cpartners;
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Promo_Code__c = 'TEST_PAID';
        l.Lat__c = accounts[0].Geolocation__Latitude__s;
        l.log__c =  accounts[0].Geolocation__Longitude__s;           
    insert l;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext2 = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext2.getEligiblePartners();

        Test.stopTest();
    }
    
    static TestMethod void testStandardCampaignWithGeo() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        Account a = TestClassFactory.CreateDealer('dealerName', 'North America');
        
        CoverageArea__c ca;
        try {
            ca = [SELECT Id, Sector__c FROM CoverageArea__c WHERE Account__c =: a.Id];
            ca.Sector__c = 'Residential';
            update ca;
        } catch(Exception e) { System.debug('NO CA'); }
        
        Campaign c = TestClassFactory.testCampaign('Test Campaign');
        insert c;
        
        Campaign_Partner__c cp = TestClassFactory.testCampaignPartner('name', c.id, a.id, true, 'Standard');
        insert cp;
        
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Lat__c = a.Geolocation__Latitude__s;
        l.log__c =  a.Geolocation__Longitude__s;           
    insert l;
        
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;
        insert cm;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();    
    }
    
    static TestMethod void testStandardCampWithGeoNoCPS() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        List<Account> accounts = TestUtils.createAccounts(2, false);
        List<Account> updates = new List<Account>();
        for(Account a : accounts) {
            a.RecordTypeId = TestClassFactory.retrieveRecordTypeID('Account', 'Partner');
            a.Type = 'Master-Partner-Residential';
            a.Status__c = 'Active';
            a.Dealer_Locator_Phone__c = '888-888-8888';
            a.Phone = '888-888-8888';
            a.BillingStreet = '150 Corona St';
            a.BillingCity = 'Denver';
            a.BillingState = 'CO';
            a.BillingCountry = 'United States';
            a.BillingPostalCode = '80218';
            a.Dealer_Locator_Opt_Out__c = false;
            a.Lead_Flow_Opt_Out__c = false;
            a.Alliance_Program_Partner__c = true;
            a.Geolocation__Latitude__s = 39.718887;
            a.Geolocation__Longitude__s = -104.974036;
            a.Theater__c = 'North America';
            updates.add(a);
        }
        updates[0].Type = 'Premier-Partner-Residential';
        updates[1].Geolocation__Latitude__s = 46.9193762;
        updates[1].Geolocation__Longitude__s = -98.0082629; 
        insert updates;
        
        List<CoverageArea__c> areas = new List<CoverageArea__c>();
        for(Account acc : updates) {
            CoverageArea__c ca = new CoverageArea__c();
            ca.Account__c = acc.Id;
            ca.Geolocation__Latitude__s = acc.Geolocation__Latitude__s;
            ca.Geolocation__Longitude__s = acc.Geolocation__Longitude__s;
            ca.Radius__c = 40;
            ca.Sector__c = 'Residential';
            areas.add(ca);
        }
        insert areas;
        
        Campaign c = TestClassFactory.testCampaign('Test Campaign');
        insert c;
        
        Campaign_Partner__c cp = TestClassFactory.testCampaignPartner('test', c.Id, updates[1].Id, true, 'Standard');
        insert cp;
        
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Lat__c = updates[0].Geolocation__Latitude__s;
        l.log__c =  updates[0].Geolocation__Longitude__s;           
    insert l;
        
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;
        insert cm;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();    
    }
    
    static TestMethod void testPaidCampaignWithGeoNoCPS() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        Account a = TestClassFactory.CreateDealer('dealerName', 'North America');
        
        CoverageArea__c ca;
        try {
            ca = [SELECT Id, Sector__c FROM CoverageArea__c WHERE Account__c =: a.Id];
            ca.Sector__c = 'Residential';
            update ca;
        } catch(Exception e) { System.debug('NO CA'); }
        
        Campaign c = TestClassFactory.testCampaign('Test Campaign');
        c.Campaign_ID__c = 'Test ' + Date.today();
        c.AssignRandomPartner__c = true;
        c.Description = 'Test';
        c.Short_Description__c = 'Test';
        c.IsActive = true;
        insert c;
        
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Lat__c = a.Geolocation__Latitude__s;
        l.log__c =  a.Geolocation__Longitude__s;           
    insert l;
        
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;
        insert cm;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();    
    }
    
    static TestMethod void testStandardCampaignFailSafe() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        Account a = TestClassFactory.CreateDealer('dealerName', 'North America');
        
        CoverageArea__c ca;
        try {
            ca = [SELECT Id, Sector__c FROM CoverageArea__c WHERE Account__c =: a.Id];
            ca.Sector__c = 'Residential';
            update ca;
        } catch(Exception e) { System.debug('NO CA'); }
        
        Campaign c = TestClassFactory.testCampaign('Test Campaign');
        c.Campaign_ID__c = 'Test ' + Date.today();
        c.Description = 'Test';
        c.Short_Description__c = 'Test';
        c.IsActive = true;
        insert c;
        
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Lat__c = a.Geolocation__Latitude__s;
        l.log__c =  a.Geolocation__Longitude__s;           
    insert l;
        
        CampaignMember cm = new CampaignMember();
        cm.LeadId = l.Id;
        cm.CampaignId = c.Id;
        insert cm;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();    
    }
    
    static TestMethod void testNoCampaign() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
        
        Account a = TestClassFactory.CreateDealer('dealerName', 'North America');
        
        CoverageArea__c ca;
        try {
            ca = [SELECT Id, Sector__c FROM CoverageArea__c WHERE Account__c =: a.Id];
            ca.Sector__c = 'Residential';
            update ca;
        } catch(Exception e) { System.debug('NO CA'); }
        
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';
        l.Lat__c = a.Geolocation__Latitude__s;
        l.log__c =  a.Geolocation__Longitude__s;           
    insert l;
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();
    }
    
    static TestMethod void testNoAddress() {
        DealerGeneral__c dg = TestClassFactory.testDealerGeneralSetting();
        insert dg;
             
        //Begin page testing
        Test.startTest();
        
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        insert l;
        
        Test.setMock(HttpCalloutMock.class, new ZeroResultsMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);  
        Test.setCurrentPage(pageRef);
        
        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();
    }
    
    static TestMethod void testNoAreas() {
                
        Lead l = TestClassFactory.testLead('lastName', 'company', 'email@noemail.com');
        l.Status = 'Sales Accepted';
        l.Street = '150 Corona St';
        l.City = 'Denver';
        l.State = 'CO';
        l.PostalCode = '80218';
        l.Country = 'United States';           
    insert l;
        
        //Begin page testing
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new GeoCalloutMock());
        PageReference pageRef = Page.InlineDealerLocator;
        ApexPages.StandardController sc = new ApexPages.StandardController(l);
        ApexPages.currentPage().getParameters().put('id', l.Id);
        
        InlineDealerLocatorController ext = new InlineDealerLocatorController(sc);
        Test.setCurrentPage(pageRef);

        List<InlineDealerLocatorController.ListResult> dealers = ext.getEligiblePartners();
        
        Test.stopTest();
    }
        
    global class GeoCalloutMock implements HttpCalloutMock {

        global HTTPResponse respond(HTTPRequest req) {
            
            String body = '{"results" : [{"address_components" : [{"long_name" : "150","short_name" : "150","types" : [ "street_number" ]},{"long_name" : "Corona Street","short_name" : "Corona St","types" : [ "route" ]},{"long_name" : "Alamo Placita","short_name" : "Alamo Placita","types" : [ "neighborhood", "political" ]},{"long_name" : "Denver","short_name" : "Denver","types" : [ "locality", "political" ]},{"long_name" : "Denver County","short_name" : "Denver County","types" : [ "administrative_area_level_2", "political" ]},{"long_name" : "Colorado","short_name" : "CO","types" : [ "administrative_area_level_1", "political" ]},{"long_name" : "United States","short_name" : "US","types" : [ "country", "political" ]},{"long_name" : "80218","short_name" : "80218","types" : [ "postal_code" ]}],"formatted_address" : "150 Corona St, Denver, CO 80218, USA","geometry" : {"bounds" : {"northeast" : {"lat" : 339.7189044,"lng" : -104.9762374},"southwest" : {"lat" : 39.7189044,"lng" : -104.9740487}},"location" : {"lat" : 39.71890459999999,"lng" : -104.9740299},"location_type" : "RANGE_INTERPOLATED","viewport" : {"northeast" : {"lat" : 39.7202534802915,"lng" : -104.9726903197085},"southwest" : {"lat" : 39.7175555197085,"lng" : -104.9753882802915}}},"place_id" : "EiQxNTAgQ29yb25hIFN0LCBEZW52ZXIsIENPIDgwMjE4LCBVU0E","types" : [ "street_address" ]}],"status" : "OK"}';
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(body);
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class ZeroResultsMock implements HttpCalloutMock {
        
        global HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ZERO_RESULTS}');
            res.setStatusCode(200);
            return res;
        }
    } 
}