/************************************
**PR-01948
**By- Kapil Goutam
**On- May 21 2009
**Modified - 
**Modified On- 
**Description- Test Class for trigger AfterCertificationUpdate
**************************************
**************************************/
public class TestAfterCertificationUpdate{
	@isTest
  public static void Test_AfterCertificationUpdate(){    
    Account accountObj = new Account();
    accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;
      
    Contact contactObj = new Contact();
    contactObj.FirstName = 'Test' + String.valueOf(DateTime.Now()) ;
    contactObj.LastName = 'Test' + String.valueOf(DateTime.Now());
    contactObj.AccountId = accountObj.Id;
    insert contactObj;    
      
    Certification__c obj = new Certification__c();
    //obj.Contact__c = contactObj.Id;
    obj.Account__c = accountObj.Id;
    insert obj;
    List<Certification__c> lstTest = new List<Certification__c>();
    lstTest.add(obj);    
    update lstTest;
    
    delete lstTest;    
     
    TestCertificationManagement.checkCertificationManagement();
    TestAccountManagement.Test_AccountUpdate();
    TestCheckContactDuplicate.testcheckContactDuplicate(); 
  }
}