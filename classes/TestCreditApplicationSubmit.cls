/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller CreditApplicationSubmit 
*****************************************************/

public class TestCreditApplicationSubmit {
  @isTest
  public static void testCreditApplicationSubmit (){
    
    RecordType recType = Database.query('select id from RecordType where name like \'Partner%\' and SobjectType=\'Account\'');
    Account acct = new Account();
    acct.RecordTypeId = recType.Id;    
    acct.Name = 'TestDuplicate';
    acct.Type ='Partner'; 
    acct.billingCity = 'TestCity';
    acct.BillingCountry = 'TestCountry';
    acct.BillingPostalCode = '12345';
    acct.BillingState = 'TestState';
    acct.BillingStreet = 'TestStreet';
    acct.ShippingCountry  = 'TestShippingCountry'; 
    acct.ShippingStreet = 'TestShippingStreet';
    acct.ShippingCity = 'TestShippingcity';
    acct.ShippingPostalCode = '45345';
    insert acct;
    
    Contact contactObj = new Contact();
    contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
    contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
    contactObj.AccountId = acct.Id;
    contactObj.Email = 'Test123@test123.com';
    insert contactObj;
    
   
    Credit_Application__c creditApp = new Credit_Application__c();
    creditApp.Credit_Limit_Requested__c = 1000;
    creditApp.CurrencyIsoCode = 'USD';
    creditApp.Credit_Limit_Requested__c = 1000;
    creditApp.Bank_Reference_Name__c = 'TestReference';
    creditApp.Trade_Reference_1_Company__c = 'Trade Reference1';
    creditApp.Trade_Reference_1_Phone__c = '12345' ;
    creditApp.Trade_Reference_2_Company__c = 'Trade Reference1';
    creditApp.Trade_Reference_2_Phone__c = '6789';
    creditApp.Federal_Tax_ID__c = '123456';
    creditApp.VAT_Number__c = '123456789';
    creditApp.Account__c = acct.Id;
    insert creditApp;
    
    Test.startTest();
    System.assertEquals(System.Label.CASubmitError,CreditApplicationSubmit.Submit(creditApp.ID));
    
    Attachment attach=new Attachment();     
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId=creditApp.id;
    insert attach;
    
    System.assertEquals(null,CreditApplicationSubmit.Submit(creditApp.ID));
    Test.stopTest();
  }  
}