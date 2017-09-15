@isTest
public class RoofDetailsListController_Test {
	
    static testMethod void testRoofDetailsLoad(){
        List<Account> residentialAccountInsert = new List<Account>();
        List<Residential_Project__c> residentialProjectInsert = new List<Residential_Project__c>();
        List<Roof_Details__c> roofDetailsInsert = new List<Roof_Details__c>();
        
        Id residentialAccountId = TestUtils.getResidentialRecordTypeId();
        
        Account acct = TestUtils.CreateAccount('TestAccountOne',residentialAccountId,TRUE);
        residentialAccountInsert.add(acct);
        
		Residential_Project__c resProj = new Residential_Project__c(Name = 'Brad Brannon', Account__c = residentialAccountInsert[0].Id);        
    	residentialProjectInsert.add(resProj);
        
        Roof_Details__c roofDetail = new Roof_Details__c(Name = 'Roof1', 
                                                         Account__c = residentialAccountInsert[0].id,
                                                         Description__c = 'Test Description',
                                                         Pitch__c = '5:12(23)',
                                                         Direction__c = 180,
                                                         Jan__c = 98,
                                                         Feb__c = 97,
                                                         Mar__c = 96,
                                                         Apr__c = 95,
                                                         May__c = 94,
                                                         Jun__c = 93,
                                                         Jul__c = 92,
                                                         Aug__c = 91,
                                                         Sep__c = 90,
                                                         Oct__c = 91,
                                                         Nov__c = 92,
                                                         Dec__c = 93);
        roofDetailsInsert.add(roofDetail);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(resProj);
        RoofDetailsListController testResProj = new RoofDetailsListController(sc);
        
        PageReference pageRef = Page.RoofDetailsList;
        Test.setCurrentPage(pageRef);
    }
}