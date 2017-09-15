@isTest
public class TestAPICallouts{
    static testMethod void Test_APICallouts()
    {
        Test.startTest();
        APICallouts.isRunningTest = true;
        Id recordPartnerId = [SELECT Id,Name FROM RecordType WHERE Name = 'Partner' and Sobjecttype = 'Account' limit 1].id;
        Account objP1 = new Account(Name = 'test22',recordtypeId=recordPartnerId ,BillingStreet='Adriatic Way', BillingCity='Santa Clara', BillingState='CA', BillingPostalCode='95051', BillingCountry='United States',Theater__c ='North America',Phone='1234567895',Type='Elite-Partner-Combo');
        Insert objP1;
        APICallouts.setLocation(objP1.Id,null);
        Test.stopTest();
    } 
    static testMethod void Test_APICallouts1()
    {
        Test.startTest();
        APICallouts.isRunningTest = true;
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
        APICallouts.setLocation(null,obj_L.ID);
        Test.stopTest();
    } 
}