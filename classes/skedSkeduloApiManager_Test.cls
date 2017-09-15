@isTest
public class skedSkeduloApiManager_Test {

    static testmethod void TestDispatchApi() {
        Map<string, sObject> mapTestData = skedDataSetup.setupSkeduloApiTestData();
        sked__Resource__c siteSurveyor1 = (sked__Resource__c)mapTestData.get('siteSurveyor1');
        
        Test.startTest();
        Map<Id, sked__Job__c> mapJob = new Map<Id, sked__Job__c>([SELECT Id FROM sked__Job__c]);
                
        skedSkeduloApiManager_MockTest mockClass = new skedSkeduloApiManager_MockTest();
		mockClass.resourceId = siteSurveyor1.Id;
		Test.setMock(HttpCalloutMock.class, mockClass);
		
        mockClass.calloutMethod = 'dispatch';
        skedSkeduloApiManager.dispatchJobs(mapJob.keySet());
		
        mockClass.calloutMethod = 'dispatch_error';
        skedSkeduloApiManager.dispatchJobs(mapJob.keySet());
		
        mockClass.calloutMethod = 'dispatch_error_salesforce_side';
        skedSkeduloApiManager.dispatchJobs(mapJob.keySet());
        
        Test.stopTest();
    }

    static testmethod void TestDispatchApiError1() {
        Map<string, sObject> mapTestData = skedDataSetup.setupSkeduloApiTestData();
        sked__Resource__c siteSurveyor1 = (sked__Resource__c)mapTestData.get('siteSurveyor1');
        
        Test.startTest();
        Map<Id, sked__Job__c> mapJob = new Map<Id, sked__Job__c>([SELECT Id FROM sked__Job__c]);
                
        skedSkeduloApiManager_MockTest mockClass = new skedSkeduloApiManager_MockTest();
		mockClass.resourceId = siteSurveyor1.Id;
		Test.setMock(HttpCalloutMock.class, mockClass);
		
        mockClass.calloutMethod = 'dispatch_error';
        skedSkeduloApiManager.dispatchJobs(mapJob.keySet());
        
        Test.stopTest();
    }

    static testmethod void TestDispatchApiError2() {
        Map<string, sObject> mapTestData = skedDataSetup.setupSkeduloApiTestData();
        sked__Resource__c siteSurveyor1 = (sked__Resource__c)mapTestData.get('siteSurveyor1');
        
        Test.startTest();
        Map<Id, sked__Job__c> mapJob = new Map<Id, sked__Job__c>([SELECT Id FROM sked__Job__c]);        
        
        skedSkeduloApiManager_MockTest mockClass = new skedSkeduloApiManager_MockTest();
		mockClass.resourceId = siteSurveyor1.Id;
		Test.setMock(HttpCalloutMock.class, mockClass);
		
        mockClass.calloutMethod = 'dispatch_error_salesforce_side';
        skedSkeduloApiManager.dispatchJobs(mapJob.keySet());
        
        Test.stopTest();
    }
    
}