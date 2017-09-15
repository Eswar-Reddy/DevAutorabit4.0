//Started By: Nikki De Guzman - CS
//This is a test class for updateDealerLocator trigger
@isTest
private class UpdateDealerLocator_Test{
   
     static testMethod void testAddAccountApproval(){
        //Create Account
        Account acct = new Account(Name = 'TestNikki_Account');
            acct.Type = 'Commercial';
            acct.BillingCity = 'Manila';
            acct.BillingCountry = 'Philippines';
            acct.BillingStreet = 'Paseo';
            acct.BillingPostalCode = '1231';
            acct.Theater__c = 'Europe';

            insert acct;
      
      //Get RecordtypeId of Partner Promotion      
      Id recTypeId = Schema.SObjectType.Account_Approvals__c.getRecordTypeInfosByName().get('Partner General Approvals').getRecordTypeId();
      
      //Create Account Approval
      Account_Approvals__c acctApp = new Account_Approvals__c();
            acctApp.account__c = acct.Id;
            acctApp.recordTypeId = recTypeId;
            acctApp.Approval_Request__c = 'Dealer Locator Opt Out';
            Test.startTest();
            insert acctApp;
            
            // Test that the trigger correctly updated Dealer_Locator_Opt_Out in the parent account
            Account_Approvals__c acctAppTest = [Select Account__r.Dealer_Locator_Opt_Out__c 
                                                From Account_Approvals__c Where Account__c =: acct.Id 
                                                AND recordType.developerName = 'Partner_Promotion'];
            System.assertEquals(true, acctAppTest.Account__r.Dealer_Locator_Opt_Out__c);
            
            Test.StopTest();
    }
}