@isTest
public with sharing class TestDealerUtilityIV 
{

	@TestSetup
	static void createALRTheaters() {
		List<ALR_Theaters__c> theaters = new List<ALR_Theaters__c>();
		ALR_Theaters__c record1 = new ALR_Theaters__c(name = 'North America');
		theaters.add(record1);
		ALR_Theaters__c record2 = new ALR_Theaters__c(name = 'Central America and the Caribbean');
		theaters.add(record2);
		ALR_Theaters__c record3 = new ALR_Theaters__c(name = 'Europe');
		theaters.add(record3);
		ALR_Theaters__c record4 = new ALR_Theaters__c(name = 'null');
		theaters.add(record4);

		insert theaters;
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

        createDealerAssignment(o.Id, c.Id, partner.Id);
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

        createDealerAssignment(o.Id, c.Id, partner.Id);
        return o;                        
                                
	} 

	static Opportunity CreateOpportunityWithAllianceCampaign(String OppName) {

		Campaign c = new Campaign(Name ='Test', Type = 'Alliance');
        insert c;

		Account partner = TestClassFactory.CreateDealer('testdealer1', 'North America');
		partner.Opportunity_Recipient__c = UserInfo.getUserId();
		
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
        insert o;

        createDealerAssignment(o.Id, c.Id, partner.Id);
        return o;                        
                                
	}  

	 static testMethod void testOpportunityWithGenericCampaignAssigned() {
		//TestALRCommon.CreateCustomSetting();		
		Opportunity o = CreateOpportunityWithGenericCampaign('TestCampaign1');
		if(o.Id != null) {
			Set<Id> oppIds = new Set<Id>();
			oppIds.add(o.ID);
			Test.startTest();
			DealerUtility.AutoAssignBulk(oppIds);
			Test.stopTest();
		}
    }
    
    static testMethod void testOpportunityWithPaidCampaignAssigned() {
		//TestALRCommon.CreateCustomSetting();
		Opportunity o = CreateOpportunityWithPaidCampaign('TestCampaign2');
		if(o.Id != null) {
			Set<Id> oppIds = new Set<Id>();
			oppIds.add(o.ID);
			Test.startTest();
			DealerUtility.AutoAssignBulk(oppIds);
			Test.stopTest();
		}
    }
    
    static testMethod void testOpportunityWithAllianceCampaignAssigned() {
		//TestALRCommon.CreateCustomSetting();
		Opportunity o = CreateOpportunityWithAllianceCampaign('TestCampaign3');
		if(o.Id != null) {
			Set<Id> oppIds = new Set<Id>();
			oppIds.add(o.ID);
			Test.startTest();
			DealerUtility.AutoAssignBulk(oppIds);
			Test.stopTest();
		}
    } 

    private static void createDealerAssignment(ID oppID, ID campId, ID dealerId) {
    	Dealer_Assignment_Audit__c daa = new Dealer_Assignment_Audit__c();
        daa.Opportunity__c = oppId;
        daa.Dealer_Assigned__c = dealerId;
        daa.Campaign__c = campId;
        daa.Assignment_Date__c = Date.today();
        insert daa;
    }       
}