@IsTest (SeeAllData=true)
public with sharing class TestDealerUtilityII {


	public TestDealerUtilityII() {
		TestALRCommon.CreateCustomSetting();
	}

	static Lead CreateLeadPlain(String CompanyName, String Source_System, String Lead_Inferred_Quality, String Lead_Data_Quality) {
			Lead l = TestALRCommon.CreateRawLead(CompanyName, Source_System, Lead_Inferred_Quality, Lead_Data_Quality);
			insert l;
			return l;
		}    	

		
	static Lead CreateLeadDealerAssigned(String CompanyName, String Source_System, String Lead_Inferred_Quality, String Lead_Data_Quality, Id DealerId) {
			Lead l = TestALRCommon.CreateRawLead(CompanyName, Source_System, Lead_Inferred_Quality, Lead_Data_Quality);
			l.Dealer_Locator_Selection__c = DealerId;
			insert l;
			return l;
		}    	

	static Opportunity CreateOpportunityWithGenericCampaign(String OppName) {

			Campaign c = new Campaign(Name ='Test', Type = 'Other');
	        insert c;

			Account partner1 = TestALRCommon.CreateDealer('Partner1');
			
	        Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	        cp.enabled__c = true;
	        cp.Name = 'A';
	        cp.Partner__c = partner1.Id;
	        insert cp;

			Account partner2 = TestALRCommon.CreateDealer('Partner2');
			
	        cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	        cp.enabled__c = true;
	        cp.Name = 'B';
	        cp.Partner__c = partner2.Id;
	        insert cp;

	                                                                              		
			RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
		    Account a = TestALRCommon.CreateHomeOwnerAccount('Test100');
			Opportunity o = new Opportunity();
			o.RecordTypeId = RecordTypeOpportunity.Id;
			o.CampaignId = c.Id;
			o.AccountId = a.Id;
			o.Name = OppName;
			o.StageName = 'New Opportunity';
			o.Lead_Manufacturer__c = 'SunPower';
			o.CloseDate = System.Today();
			Test.startTest();
	        insert o;
	        Test.stopTest();
	        return o;                        
	                                
		}    

	static Opportunity CreateOpportunityWithPaidCampaign(String OppName, Boolean IncludeAlreadyAssigned) {

			Campaign c = new Campaign(Name ='Test', Type = 'Other', AssignRandomPartner__c = true);
	        insert c;

			Account partner1 = TestALRCommon.CreateDealer('Partner1');
			
	        Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	        cp.enabled__c = true;
	        cp.Name = 'A';
	        cp.Partner__c = partner1.Id;
	        insert cp;

			Account partner2 = TestALRCommon.CreateDealer('Partner2');
			
	        cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	        cp.enabled__c = true;
	        cp.Name = 'B';
	        cp.Partner__c = partner2.Id;
	        insert cp;

	 		RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];

	 
	 		if (IncludeAlreadyAssigned == true) {
			    RecordType RecordTypeOpportunityCommercial = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Commercial' LIMIT 1];
			   
			    Account a2 = TestALRCommon.CreateHomeOwnerAccount('Test300');
				Opportunity o2 = new Opportunity();
				o2.RecordTypeId = RecordTypeOpportunityCommercial.Id;
				o2.CampaignId = c.Id;
				o2.AccountId = a2.Id;
				o2.Name = OppName;
				o2.StageName = 'Contacted';
				o2.Lead_Manufacturer__c = 'Partner';
				o2.CloseDate = System.Today();
		        insert o2;
	 			
	 			
	 			Dealer_Assignment_Audit__c daa = new Dealer_Assignment_Audit__c();
	 			daa.Campaign__c = c.id;
	 			daa.Dealer_Assigned__c = partner1.id;
	 			daa.Opportunity__c = o2.id;
	 			insert daa;
	 		}
	                                                                              		
		    Account a = TestALRCommon.CreateHomeOwnerAccount('Test100');
			Opportunity o = new Opportunity();
			o.RecordTypeId = RecordTypeOpportunity.Id;
			o.CampaignId = c.Id;
			o.AccountId = a.Id;
			o.Name = OppName;
			o.StageName = 'New Opportunity';
			o.Lead_Manufacturer__c = 'SunPower';
			o.CloseDate = System.Today();
			Test.startTest();
	        insert o;
	        Test.stopTest();
	        return o;                        
	                                
		}    
		
	static Opportunity CreateOpportunityWithAllianceCampaign(String OppName) {

			Campaign c = new Campaign(Name ='Test', Type = 'Alliance');
	        insert c;

			Account partner1 = TestALRCommon.CreateDealer('Partner1');
			
	        Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	        cp.enabled__c = true;
	        cp.Name = 'A';
	        cp.Partner__c = partner1.Id;
	        insert cp;

			Account partner2 = TestALRCommon.CreateDealer('Partner2');
			
	        cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	        cp.enabled__c = true;
	        cp.Name = 'B';
	        cp.Partner__c = partner2.Id;
	        insert cp;
	                                                                                      		
			RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
		    Account a = TestALRCommon.CreateHomeOwnerAccount('Test100');
			Opportunity o = new Opportunity();
			o.RecordTypeId = RecordTypeOpportunity.Id;
			o.CampaignId = c.Id;
			o.AccountId = a.Id;
			o.Name = OppName;
			o.StageName = 'New Opportunity';
			o.Lead_Manufacturer__c = 'SunPower';
			o.CloseDate = System.Today();
			Test.startTest();
	        insert o;
	        Test.stopTest();
	        return o;                        
	                                
	}     


    static testMethod void testOpportunityWithGenericCampaignAssigned() {
		CreateOpportunityWithGenericCampaign('TestCampaign1');
    }
    
    static TestMethod void testDealerUtilSetLeadAutoConvert() {
    	List<Lead> leadList = new List<Lead>();
    	Lead testLead = new Lead();
    	testLead.lastName = 'testcoLeads';
    	testLead.company = 'testcoLeads';
    	testLead.email = 'testcoleads@noemail.com';
    	testLead.Country = 'USA';
    	testLead.Theater__c = 'North America';
    	testLead.Source_System__c =  'Eloqua';
    	testLead.Lead_Inferred_Quality__c = 'Review';
    	testLead.Lead_Data_Quality__c = 'Qualified';
    	testLead.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead.Lead_Manufacturer__c = 'SunPower';
    	testLead.RLC_Type__c = 'Residential';
    	testLead.Status = 'Open';
    	leadList.add(testLead);

    	Lead testLead2 = new Lead();
    	testLead2.lastName = 'testcoLeads';
    	testLead2.company = 'testcoLeads';
    	testLead2.email = 'testcoleads@noemail.com';
    	testLead2.Country = 'USA';
    	testLead2.Theater__c = 'North America';
    	testLead2.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead2.Lead_Manufacturer__c = 'SunPower';
    	testLead2.RLC_Type__c = 'Residential';
    	testLead2.Status = 'Open';
    	leadList.add(testLead2);

    	Lead testLead3 = new Lead();
    	testLead3.lastName = 'testcoLeads';
    	testLead3.company = 'testcoLeads';
    	testLead3.email = 'testcoleads@noemail.com';
    	testLead3.Country = 'USA';
    	testLead3.Theater__c = 'North America';
    	testLead3.Source_System__c =  'Eloqua';
    	testLead3.Lead_Inferred_Quality__c = 'Reject';
    	testLead3.Lead_Data_Quality__c = 'Qualified';
    	testLead3.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead3.Lead_Manufacturer__c = 'SunPower';
    	testLead3.RLC_Type__c = 'Residential';
    	testLead3.Status = 'Open';
    	leadList.add(testLead3);

    	Lead testLead4 = new Lead();
    	testLead4.lastName = 'testcoLeads';
    	testLead4.company = 'testcoLeads';
    	testLead4.email = 'testcoleads@noemail.com';
    	testLead4.Country = 'USA';
    	testLead4.Theater__c = 'North America';
    	testLead4.Source_System__c =  'Eloqua';
    	testLead4.Lead_Inferred_Quality__c = 'Accept';
    	testLead4.Lead_Data_Quality__c = 'Qualified';
    	testLead4.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead4.Lead_Manufacturer__c = 'SunPower';
    	testLead4.RLC_Type__c = 'Residential';
    	testLead4.Status = 'Open';
    	leadList.add(testLead4);

    	Lead testLead5 = new Lead();
    	testLead5.lastName = 'testcoLeads';
    	testLead5.company = 'testcoLeads';
    	testLead5.email = 'testcoleads@noemail.com';
    	testLead5.Country = 'USA';
    	testLead5.Theater__c = 'North America';
    	testLead5.Source_System__c =  'Eloqua';
    	testLead5.Lead_Inferred_Quality__c = 'Review';
    	testLead5.Lead_Data_Quality__c = 'Disqualified';
    	testLead5.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead5.Lead_Manufacturer__c = 'SunPower';
    	testLead5.RLC_Type__c = 'Residential';
    	testLead5.Status = 'Open';
    	leadList.add(testLead5);

    	Lead testLead6 = new Lead();
    	testLead6.lastName = 'testcoLeads';
    	testLead.company = 'testcoLeads';
    	testLead6.email = 'testcoleads@noemail.com';
    	testLead6.Country = 'USA';
    	testLead6.Theater__c = 'North America';
    	testLead6.Source_System__c =  'Eloqua';
    	testLead6.Lead_Inferred_Quality__c = 'Review';
    	testLead6.Lead_Data_Quality__c = 'Undetermined';
    	testLead6.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead6.Lead_Manufacturer__c = 'SunPower';
    	testLead6.RLC_Type__c = 'Residential';
    	testLead6.Status = 'Open';
    	leadList.add(testLead6);

    	Test.startTest();
    	DealerUtility.SetLeadAutoConvert(leadList);
    	Test.stopTest();
    }  

    static TestMethod void dealerUtilUpdateContactRole() {

    	Set<Id> oppIDs = new Set<Id>();
    	try {
    		OpportunityContactRole o = [SELECT Id, OpportunityID FROM OpportunityContactRole  WHERE Opportunity.CreatedDate = LAST_N_DAYS: 10 
    						AND Opportunity.StageName = 'New Opportunity' AND Opportunity.RecordType.Name = 'Home Owner' 
    						AND Opportunity.Primary_Contact__c != null AND Opportunity.PartnerAccountID != null LIMIT 1];
    		if(o.OpportunityID != null)
    			oppIds.add(o.OpportunityID);
		} catch (exception e) {
    			system.debug('query exception');
		}


    	Test.startTest();
    	if(!oppIds.isEmpty())
    		DealerUtility.updateContactRole(oppIds);
    	Test.stopTest();
	}

	static TestMethod void dealerUtilConvertLead() {
		Lead testLead = new Lead();
    	testLead.lastName = 'testcoLeads';
    	testLead.company = 'testcoLeads';
    	testLead.email = 'testcoleads@noemail.com';
    	testLead.Country = 'USA';
    	testLead.Theater__c = 'North America';
    	testLead.Source_System__c =  'Eloqua';
    	testLead.Lead_Inferred_Quality__c = 'Review';
    	testLead.Lead_Data_Quality__c = 'Qualified';
    	testLead.RecordTypeId = TestClassFactory.retrieveRecordTypeId('Lead', 'Residential');
    	testLead.Lead_Manufacturer__c = 'SunPower';
    	testLead.RLC_Type__c = 'Residential';
    	testLead.Status = 'Contacted';
    	testLead.LeadSource = 'Web';
    	insert testLead;

    	testLead.isAutoConvert__c = true;

    	Test.startTest();
    	DealerUtility.ConvertLead(testLead, new GeocodeAsyncHandler.GeoInfo());
    	Test.stopTest();
	}

	static TestMethod void dealerUtilFixOppName() {
		List<Opportunity> opps = new List<Opportunity>();
		Opportunity o = TestClassFactory.testOpportunity('tstOpp' + System.today(), 'New Opportunity', Date.today(), TestClassFactory.retrieveRecordTypeId('Opportunity', 'Home Owner'));
		opps.add(o);

		Test.startTest();
		DealerUtility.FixOpportunityName(opps);
		Test.stopTest();

	}    


}