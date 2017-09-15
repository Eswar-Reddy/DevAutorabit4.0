@isTest
public class TestSetGeolocation  {  
  static testMethod void Test_SetGeolocation(){
     
        Test.startTest();
        LocationCallouts.isRunningTest = true;
        Id recordPartnerId = [SELECT Id,Name FROM RecordType WHERE Name = 'Partner' and Sobjecttype = 'Account' limit 1].id;
        Account objP1 = new Account(Name = 'test22',recordtypeId=recordPartnerId ,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
        Insert objP1;
        // Call batch Method
        BatchCalCloseOppRatio oppBatch = new BatchCalCloseOppRatio (); 
        oppBatch.query ='Select Id,Name, RecordTypeId ,Opportunity_Close__c From Account where RecordTypeId = \''+ recordPartnerId +'\'' ;
        
        Database.executeBatch(oppBatch);
        Test.stopTest();
     
  }
  static testMethod void Test_SetGeoloc(){
        Test.startTest();
        LocationCallouts.isRunningTest = true;
        Lead obj_L = new Lead();
        obj_L.City='Santa Clara';
        obj_L.Status='new';
        obj_L.LeadSource='Affilate'; 
        obj_L.LastName = 'Test1';
        obj_L.Email='a@gmail.com';
        obj_L.Company='ABC';
        obj_L.Lead_Manufacturer__c='SunPower';
        obj_L.Country='United states';
        obj_L.PostalCode='95051';
        obj_L.State='CA';
        obj_L.Street='Adriatic Way';
        Insert obj_L;
        obj_L.LastName = 'Test2';
        update obj_L;
        Test.stopTest();
     
  }
}