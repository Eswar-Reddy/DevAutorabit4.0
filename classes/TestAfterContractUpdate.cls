/************************************
**PR-01948
**By- Kapil Goutam
**On- May 21 2009
**Modified - 
**Modified On- 
**Description- Test Class for trigger AfterContractUpdate
**************************************/
public class TestAfterContractUpdate{
    @isTest
  public static void Test_AfterContractUpdate(){
   try {
    /*Account accountObj = new Account();
    accountObj.Name = 'Testing Account' +String.valueOf(DateTime.Now());
    accountObj.Type ='Commercial';
    accountObj.billingCity = 'TestCity';
    accountObj.BillingCountry = 'TestCountry';
    accountObj.BillingPostalCode = '12345';
    accountObj.BillingState = 'TestState';
    accountObj.BillingStreet = 'TestStreet';
    insert accountObj;*/
    Account accountObj = [Select id from Account limit 1];
    Contract newContract = new Contract();
    newContract.AccountId =accountObj.Id;
    insert newContract;
    
    TestContractManagement.checkInsertUpdateContract();
   } catch (Exception ex) {}
  }
}