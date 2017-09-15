/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 11 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for trigger AfterAccountGeographyInsert
*****************************************************/

public class TestAfterAccountGeographyInsert{
	@isTest
  public static void checkAfterAccountGeographyInsert(){
    List<Account_Geography__c> lstTest = new List<Account_Geography__c>();
    
    Account accountObj = new Account();
    accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;
    
    Account_Geography__c accGeo = new Account_Geography__c();
    accGeo.Account__c = accountObj.Id;
    accGeo.Postal_Code__c = '123456';
    lstTest.add(accGeo);
    
    insert lstTest;    
    
    TestTerritoryManagement.checkTerritoryManagement();
    TestAccountManagement.Test_AccountUpdate();
  }
}