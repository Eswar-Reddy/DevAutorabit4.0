@IsTest
public with sharing class TestDealerUtilityIII {

	@TestSetup
	static void createALRTheaters() {
		List<ALR_Theaters__c> theaters = new List<ALR_Theaters__c>();
		ALR_Theaters__c record1 = new ALR_Theaters__c(name = 'North America');
		theaters.add(record1);
		ALR_Theaters__c record2 = new ALR_Theaters__c(name = 'Central America and the Caribbean');
		theaters.add(record2);
		ALR_Theaters__c record3 = new ALR_Theaters__c(name = 'Europe');
		theaters.add(record3);

		insert theaters;
	}
	public TestDealerUtilityIII() {
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

		Account partner = TestClassFactory.CreateDealer('testdealer1', 'North America');
		
	    Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	    cp.enabled__c = true;
	    cp.Name = 'A';
	    cp.Partner__c = partner.Id;
	    insert cp;

	                                                                          		
		RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
	    Account a = TestClassFactory.testAccount('testHOAccount', TestClassFactory.RetrieveRecordTypeId('Account', 'Residential Customer'));
	    a.Theater__c = 'North America';
	    a.BillingCountry = 'United States';
	    a.Geolocation__Latitude__s = 39.718887;
        a.Geolocation__Longitude__s = -104.974036;
	    insert a;

		Opportunity o = new Opportunity();
		o.RecordTypeId = RecordTypeOpportunity.Id;
		o.CampaignId = c.Id;
		o.AccountId = a.Id;
		o.Name = OppName;
		o.StageName = 'New Opportunity';
		o.Lead_Manufacturer__c = 'SunPower';
		o.CloseDate = System.Today();
		o.Theater__c = 'North America';
	    insert o;
	    return o;                        
	                            
	}    

	static Opportunity CreateOpportunityWithPaidCampaign(String OppName) {
		
		Campaign c = new Campaign(Name ='Test', Type = 'Other', AssignRandomPartner__c = true);
	    insert c;

		Account partner = TestClassFactory.CreateDealer('testdealer1', 'North America');
		
	    Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	    cp.enabled__c = true;
	    cp.Name = 'A';
	    cp.Partner__c = partner.Id;
	    insert cp;

	                                                                          		
		RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
	    Account a = TestClassFactory.testAccount('testHOAccount', TestClassFactory.RetrieveRecordTypeId('Account', 'Residential Customer'));
	    a.Theater__c = 'North America';
	    a.BillingCountry = 'United States';
	    a.Geolocation__Latitude__s = 39.718887;
        a.Geolocation__Longitude__s = -104.974036;
	    insert a;

		Opportunity o = new Opportunity();
		o.RecordTypeId = RecordTypeOpportunity.Id;
		o.CampaignId = c.Id;
		o.AccountId = a.Id;
		o.Name = OppName;
		o.StageName = 'New Opportunity';
		o.Lead_Manufacturer__c = 'SunPower';
		o.Theater__c = 'North America';
		o.CloseDate = System.Today();
		o.Dealer_Selection__c = partner.Id;
		o.Dealer_Assignment_Date__c = Date.today();
	    insert o;
	    return o;                        
	                            
	}    

	static Opportunity CreateOpportunityWithAllianceCampaign(String OppName) {

		Campaign c = new Campaign(Name ='Test', Type = 'Alliance');
	    insert c;

		Account partner = TestClassFactory.CreateDealer('testdealer1', 'North America');
		
	    Campaign_Partner__c cp  = new Campaign_Partner__c(Campaign__c = c.Id);
	    cp.enabled__c = true;
	    cp.Name = 'A';
	    cp.Partner__c = partner.Id;
	    insert cp;

	                                                                          		
		RecordType RecordTypeOpportunity = [Select  r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Opportunity' and Name = 'Home Owner' LIMIT 1];
	    Account a = TestClassFactory.testAccount('testHOAccount', TestClassFactory.RetrieveRecordTypeId('Account', 'Residential Customer'));
	    a.BillingCountry = 'United States';
	    a.Theater__c = 'North America';
	    a.Geolocation__Latitude__s = 39.718887;
        a.Geolocation__Longitude__s = -104.974036;
	    insert a;

		Opportunity o = new Opportunity();
		o.RecordTypeId = RecordTypeOpportunity.Id;
		o.CampaignId = c.Id;
		o.AccountId = a.Id;
		o.Name = OppName;
		o.StageName = 'New Opportunity';
		o.Lead_Manufacturer__c = 'SunPower';
		o.Theater__c = 'North America';
		o.CloseDate = System.Today();
	    insert o;
	    return o;                        
	                            
	}    
	/*
	static void CreateCustomSetting() {
	    //Add the Custom Setting
	    DealerGeneral__c dg = new DealerGeneral__c();
		dg.Email_Address_For_ALR_Alerts__c 				= 'test@sunpowercorp.com';
		dg.Enable_ALR_Process__c 								= true;
		dg.Enforce_Agreement_Check_Dealer_Search__c 	= false;
		dg.Google_Client_Id_Maps__c 							= '';
		dg.Google_Private_key_Maps__c 						= '';
		dg.Lead_Test_First_Name__c 							= 'SPWR Test';
	    insert dg;

	}
	*/
	static testMethod void testOpportunityWithGenericCampaignAssigned() {
		//TestALRCommon.CreateCustomSetting();		
		Opportunity o = CreateOpportunityWithGenericCampaign('TestCampaign1');
		if(o.Id != null) {
			List<Opportunity> oppIds = new List<Opportunity>();
			oppIds.add(o);
			Test.startTest();
			DealerUtility.AutoAssign(oppIds);
			Test.stopTest();
		}
	}

	static testMethod void testOpportunityWithPaidCampaignAssigned() {
		//TestALRCommon.CreateCustomSetting();
		Opportunity o = CreateOpportunityWithPaidCampaign('TestCampaign2');
		if(o.Id != null) {
			List<Opportunity> oppIds = new List<Opportunity>();
			oppIds.add(o);
			Test.startTest();
			DealerUtility.AutoAssign(oppIds);
			Test.stopTest();
		}
	}

	static testMethod void testOpportunityWithAllianceCampaignAssigned() {
		//TestALRCommon.CreateCustomSetting();
		Opportunity o = CreateOpportunityWithAllianceCampaign('TestCampaign3');
		if(o.Id != null) {
			List<Opportunity> oppIds = new List<Opportunity>();
			oppIds.add(o);
			Test.startTest();
			DealerUtility.AutoAssign(oppIds);
			Test.stopTest();
		}
	}        

}