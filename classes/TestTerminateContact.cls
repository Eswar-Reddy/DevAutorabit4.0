/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller TerminateContact
***************************************************
*****************************************************/


public class TestTerminateContact{
  @isTest
  public static void Test_TerminateContact(){
    
    Contact contactObj = new Contact(FirstName='TestFName',LastName='TestLname',Terminated__c=True);    
    insert contactObj;
    
    test.startTest();
    Account accountObj = new Account();
    accountObj.Name = 'Test' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.BillingCity = 'san mateo';
    accountObj.BillingStreet = 'Concar drive';
    accountObj.BillingPostalCode ='94402';
    accountObj.BillingState ='California';
    accountObj.BillingCountry = 'USA';
    
    accountObj.ShippingCity = 'san mateo';
    accountObj.ShippingStreet = 'Concar drive';
    accountObj.ShippingState = 'California'; 
    accountObj.ShippingPostalCode ='94402';
    accountObj.ShippingCountry = 'USA'; 
    insert accountObj;   
    test.stopTest();
    
    Certification__c certObj = new Certification__c();
    //certObj.Contact__c = contactObj.Id;
    certObj.Account__c = accountObj.Id;
    insert certObj;
    
    Apexpages.Standardcontroller sController = new ApexPages.Standardcontroller(contactObj);
    TerminateContact controller= new TerminateContact(sController);
    PageReference page;
    page= controller.Proceed();
    page = controller.cancel();
        
    //TestCertificationManagement.checkCertificationManagement();
    
    // Below 2 test class calls commented by Paritosh-Birlasoft
    //TestAccountManagement.Test_AccountUpdate();
    //TestAccountManagement.Test_TerminatedAccountUpdate();
    
  }
}