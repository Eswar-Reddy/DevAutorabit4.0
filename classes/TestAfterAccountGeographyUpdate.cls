/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 11 2009
**Last Modified- Kapil Goutam
**Last Modified On- June 17 2009   
**Desciption- Test class for trigger AfterAccountGeographyUpdate
*****************************************************/

public class TestAfterAccountGeographyUpdate{
	@isTest
  public static void checkAfterAccountGeographyUpdate(){
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
    insert accGeo;
    
    Account_Geography__c accGeoToUpdate = new Account_Geography__c(Id=accGeo.Id); 
    List<Account_Geography__c> lstTest = new List<Account_Geography__c>();
    lstTest.add(accGeoToUpdate);    
    update lstTest;
    
    TestTerritoryManagement.checkTerritoryManagement();
    TestAccountManagement.Test_AccountUpdate();    
  }
}