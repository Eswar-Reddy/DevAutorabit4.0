/********************************************************************************************
Name   : TestOpportunityNewController 
Author : Jitendra Kothari
Date   : Oct 10, 2011
Usage  : Test class of OpportunityNewController and LeadNewController
********************************************************************************************/
@isTest
private class TestOpportunityNewController {

    static testMethod void Test_OpportunityNewController() {
        // TO DO: implement unit test
        User u = [Select Id from User where Profile.Name in ('Sales Analyst - UPP','Sales Management - UPP','Sales Person - UPP','Sales Management') 
        			and isActive = true and Id != :Userinfo.getUserId() limit 1];
        Test.startTest();        
        ApexPages.StandardController contrl = new ApexPages.StandardController(new Opportunity());
        OpportunityNewController oppNew = new OpportunityNewController(contrl);
        oppNew.newUrl = '/apex/OpportunityNew?sfdc.override=1';
        oppNew.redirect();
        System.runAs(u){
        	oppNew.newUrl = '/apex/OpportunityNew?sfdc.override=1';
        	oppNew.redirect();
        }
        Test.stopTest();
    }
    static testMethod void Test_LeadNewController() {
        // TO DO: implement unit test
        Account acct = new Account();
	    acct.Name = 'TestDuplicate';
	    acct.Type ='Commercial'; 
	    acct.billingCity = 'TestCity';
	    acct.BillingCountry = 'TestCountry';
	    acct.BillingPostalCode = '12345';
	    acct.BillingState = 'TestState';
	    acct.BillingStreet = 'TestStreet';   
	    insert acct;
	    
	    Contact contactObj = new Contact(FirstName='TestFName',LastName='TestLname',Terminated__c=false,AccountId= acct.Id);    
    	insert contactObj;
    	
        Test.startTest();        
        ApexPages.StandardController contrl = new ApexPages.StandardController(new Lead());
        LeadNewController leadNew = new LeadNewController(contrl);
        leadNew.newUrl = '/apex/LeadNew?sfdc.override=1';
        ApexPages.currentPage().getParameters().put('CF'+System.Label.LeadContactFieldID+'_lkid',contactObj.Id);
    	ApexPages.currentPage().getParameters().put('CF'+System.Label.LeadAccountFieldID+'_lkid',acct.Id);
        leadNew.redirect();        
        Test.stopTest();
    }
}