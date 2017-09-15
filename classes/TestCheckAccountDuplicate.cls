/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- May 13 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller CheckAccountDuplicate
*****************************************************/

public class TestCheckAccountDuplicate{
	@isTest
  public static void testCheckAccountDuplicate(){
    Account acct = new Account();
    acct.Name = 'TestDuplicate';
    acct.Type ='Commercial'; 
    acct.billingCity = 'TestCity';
    acct.BillingCountry = 'TestCountry';
    acct.BillingPostalCode = '12345';
    acct.BillingState = 'TestState';
    acct.BillingStreet = 'TestStreet';   
    insert acct;
     
    Account accountDuplicateCheck2 = new Account(Name='TestDuplicate', Override_Duplicate_Check__c = true);
    accountDuplicateCheck2.Type ='Commercial';  
    accountDuplicateCheck2.billingCity = 'TestCity1';
    accountDuplicateCheck2.BillingCountry = 'TestCountry1';
    accountDuplicateCheck2.BillingPostalCode = '12345';
    accountDuplicateCheck2.BillingState = 'TestState1';
    accountDuplicateCheck2.BillingStreet = 'TestStreet1';  
    insert accountDuplicateCheck2;
    
    try{  
      Account accountDuplicateCheck3 = new Account(Name='TestDuplicate');
      accountDuplicateCheck3.Type ='Commercial'; 
      insert accountDuplicateCheck3;
    }
    catch(Exception ex){
    }     
    TestAccountManagement.Test_AccountUpdate();
    //TestAccountManagement.Test_TerminatedAccountUpdate();      
  }
}