/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 09 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller TerminateAccount
*****************************************************/


public class TestTerminateAccount {
    @isTest
    public static void Test_TerminateAccount()
    {
        Account newAccount = new Account(name = 'TestName',Status__c = 'testStatus');
        newAccount.Type ='Commercial';
        newAccount.Type ='Commercial';
	    newAccount.BillingCity = 'san mateo';
	    newAccount.BillingStreet = 'Concar drive';
	    newAccount.BillingPostalCode ='94402';
	    newAccount.BillingCountry = 'USA'; 
        
        insert newAccount;
       
        Apexpages.Standardcontroller controller = new ApexPages.Standardcontroller(newAccount);
      
        TerminateAccount controllerObj = new TerminateAccount(controller);
        PageReference page ;
        page = controllerObj.Proceed(); 
        
        controllerObj.status = 'testStatus';
        page = controllerObj.Proceed();
        
        controllerObj.status = 'Terminating';
        page = controllerObj.Proceed();
        
        controllerObj.status = 'Terminated';
        page = controllerObj.Proceed();
           
        
                 
        List<selectoption> pickListValue = controllerObj.getOptions();
      
        page = controllerObj.Cancel();
    }   

}