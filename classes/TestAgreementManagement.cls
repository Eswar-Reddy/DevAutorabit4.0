/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for controller AgreementManagement
*****************************************************/

public class TestAgreementManagement{
  @isTest
  public static void checkInsertUpdateAgreement(){
    List<echosign_dev1__SIGN_Agreement__c> lstAgree = new List<echosign_dev1__SIGN_Agreement__c>();
    List<echosign_dev1__SIGN_Agreement__c> oldlstAgree = new List<echosign_dev1__SIGN_Agreement__c>();
    
    //Check for Agreement insert
    lstAgree.Add(new echosign_dev1__SIGN_Agreement__c(Name='Test'+Datetime.now().format()));
    insert lstAgree;
    
    //Check for Agreement update
    Account acc = new Account(Name='TestAcc'+Datetime.now().format());
    acc.Type ='Commercial';
    acc.billingCity = 'TestCity';
    acc.BillingCountry = 'TestCountry';
    acc.BillingPostalCode = '12345';
    acc.BillingState = 'TestState';
    acc.BillingStreet = 'TestStreet';
    insert acc;
    
    Contract con = new Contract(Name='TestContract'+Datetime.now().format(),AccountID=acc.id);
    insert con;
    
    lstAgree[0].echosign_dev1__Contract__c=con.id;
    lstAgree[0].echosign_dev1__Status__c='Draft';    
    update lstAgree;
    
    acc.Status__c = 'Terminated';
    //update acc;
    
    
  }
  
  @isTest
  public static void checkInsertUpdateAgreement2(){
   try {
  	TestContractManagement.checkInsertUpdateContract();
   } catch (Exception ex) {}
  }
}