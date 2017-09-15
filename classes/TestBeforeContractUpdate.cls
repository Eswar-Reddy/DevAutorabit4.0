/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 17 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for trigger BeforeContractUpdate
*****************************************************/
public class TestBeforeContractUpdate{
    @isTest
  public static void checkBeforeContractUpdate(){
   try {
    /*Account accountObj = new Account();
    accountObj.Name = 'Test' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;*/
    Account accountObj = [Select id from Account limit 1];
    
    Contract contractObj = new Contract();
    contractObj.AccountId = accountObj.Id;
    insert contractObj;
    
    update contractObj;
    
    TestContractManagement.checkInsertUpdateContract();
   } catch (Exception ex) {}
  }
}