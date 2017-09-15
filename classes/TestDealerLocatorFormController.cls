/**************************************************
** PR- 01923
**Created By- Anuradha
**Created On- December 21 , 2010
**Desciption- Test class for controller DealerLocatorFormController 
*****************************************************/

public class TestDealerLocatorFormController {
  @isTest
  public static void testDealerLocatorFormController(){
            
    Account acct = new Account();
    acct.Name = 'TestDuplicate';
    acct.Type ='Commercial'; 
    acct.billingCity = 'TestCity';
    acct.BillingCountry = 'TestCountry';
    acct.BillingPostalCode = '12345';
    acct.BillingState = 'TestState';
    acct.BillingStreet = 'TestStreet';   
    insert acct;
     
    ApexPages.currentPage().getParameters().put('id' , acct.Id);
    
    DealerLocatorFormController dealer = new DealerLocatorFormController ();
    dealer.getAccount();
    dealer.getName();
  }
}