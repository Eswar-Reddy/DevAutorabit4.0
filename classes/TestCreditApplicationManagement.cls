/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 30 2009
**Last Modified- Kapil G.
**Last Modified On-  July 13 2009 
**Desciption- Test class for controller CreditApplicationManagement
*****************************************************/

public class TestCreditApplicationManagement{
 @isTest
  public static void test_CreditApplicationManagement(){
    //setup test data
   
   RecordType recType = Database.query('select id from RecordType where name like \'Partner%\' and SobjectType=\'Account\'');
    Account accountObj = new Account();
    accountObj .RecordTypeId = recType.Id;    
    accountObj .Name = 'TestDuplicate';
    accountObj .Type ='Partner'; 
    accountObj .billingCity = 'TestCity';
    accountObj .BillingCountry = 'TestCountry';
    accountObj .BillingPostalCode = '12345';
    accountObj .BillingState = 'TestState';
    accountObj .BillingStreet = 'TestStreet';
    accountObj .ShippingCountry  = 'TestShippingCountry'; 
    accountObj .ShippingStreet = 'TestShippingStreet';
    accountObj .ShippingCity = 'TestShippingcity';
    accountObj .ShippingPostalCode = '45345';
    insert accountObj ;
  
    Credit_Application__c creditAppObj = new Credit_Application__c(); 
    creditAppObj.Account__c = accountObj.Id;
    creditAppObj.Credit_Limit_Requested__c = 1000;
    creditAppObj.Bank_Reference_Name__c = 'TestReference';
    creditAppObj.Trade_Reference_1_Company__c = 'Trade Reference1';
    creditAppObj.Trade_Reference_1_Phone__c = '12345' ;
    creditAppObj.Trade_Reference_2_Company__c = 'Trade Reference1';
    creditAppObj.Trade_Reference_2_Phone__c = '6789';
    creditAppObj.Federal_Tax_ID__c = '123456';
    creditAppObj.VAT_Number__c = '123456789';

    insert creditAppObj;
    
    creditAppObj.Credit_Limit__c = 10000;   
    creditAppObj.Notarized_Personal_Guaranty__c = true;
    creditAppObj.Resale_Certificate_Form__c = true;
    creditAppObj.Status__c = 'Ready for Review';
    
    update creditAppObj;
  }
}