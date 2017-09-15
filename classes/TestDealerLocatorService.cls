@isTest(SeeAllData=True)
public with sharing class TestDealerLocatorService {
    
    //Existing
    static testMethod void createDealerTest() {
	    string zip='95051';
	    integer rd=30;
	    string accType='Commercial';
	    Test.startTest(); 
	    DealerLocatorService.fetchDealers(zip,rd,accType);
	    DealerLocatorService.fetchAllDealers();
	    Test.stopTest();
    }
    
    //Existing    
    static testMethod void createDealerTest1() {
	    string zip='95051';
	    integer rd=30;
	    string accType='Authorized-Partner-Residential';
	    Test.startTest();
	    DealerLocatorService.fetchDealers(zip,rd,accType);
	    DealerLocatorService.fetchAllDealers();
	    Test.stopTest();
    }
    
static Account CreateDealer(String DealerName) {
       //RecordType PartnerRecordTypeAccount = [Select r.Id, r.SobjectType, r.Name From RecordType r where sobjecttype ='Account' and Name= 'Partner' LIMIT 1];
       
        Account a = new Account();
        a.Name 										= DealerName; //'Really Bright Solar';
        a.Type 										= 'Premier-Partner-Residential'; //PartnerRecordTypeAccount .Id;
            
        a.Dealer_Score_Total__c 					= 78;
        a.Dealer_Locator_Phone__c 					= '888-888-8888';
        a.Phone 									= '888-888-8888';
        a.BillingStreet      						= '150 Corona St';
        a.BillingCity        						= 'Denver';
        a.BillingState         						= 'CO';
        a.BillingCountry         					= 'United States';
        a.BillingPostalCode     					= '80218';
        a.website             						= 'www.sunpowercorp.com';
        a.Oracle_Account_Number__c 					= '123';
        a.Description 								= 'None';
        a.Partner_Facts__c 							= 'None';
        a.Status__c 								= 'Active';
        a.Dealer_Locator_Opt_Out__c 				= false;
        a.Lead_Flow_Opt_Out__c  					= false;
        a.Alliance_Program_Partner__c 				= true;
        a.Geolocation__Latitude__s 					= 39.718887;
        a.Geolocation__Longitude__s 				= -104.974036;

        insert a;
        
        //2. Insert CoverageArea__c
        CoverageArea__c ca = new CoverageArea__c();
        ca.Account__c 					= a.id;
        ca.Geolocation__Latitude__s 	= 39.718887;
        ca.Geolocation__Longitude__s 	= -104.974036;
        ca.Radius__c 				    = 1000;
    	ca.Sector__c = 'Residential';
        insert ca;
        
		Business_Registration__c br = new Business_Registration__c();
		br.Name 				= a.billingstate;
		br.Account__c 		= a.id;
		//br.Expires_On__c 	= a.Contractors_Lic_Expiry__c;
		br.License_Number__c = '000000';
		br.Country__c 			= a.billingCountry;
		br.State__c 			= a.billingstate;
   		insert br;        
        return a;
}

    static testMethod void testfindDealers() {
    	Account a = CreateDealer('Test Dealer1');

		list<DealerLocatorService.ResultRow> resultRows = new list<DealerLocatorService.ResultRow>();
		resultRows = DealerLocatorService.findDealers('125 Corona', 'Denver', 'CO', '80218', 'United States', '');
		system.assert(resultRows.size() > 0);
    }
    
    static testMethod void testfetchDealers() {
    	Account a = CreateDealer('Test Dealer2');

		list<DealerLocatorService.ResultRow> resultRows = new list<DealerLocatorService.ResultRow>();
		resultRows = DealerLocatorService.fetchDealers('80218', 10, '');
		system.assert(resultRows.size() > 0);
    }        
    
 }