public class TestTermination {
    
    @isTest
    static void Test_TerminateAccount(){
      Account acct = new Account();
      acct.Name = 'test Account' + DateTime.now();
      acct.Status__c = 'Active';
      acct.Type ='Commercial';
      acct.BillingCity = 'san mateo';
      acct.BillingStreet = 'Concar drive';
      acct.BillingPostalCode ='94402';
      acct.BillingCountry = 'USA'; 
      insert acct;
      
      Contact contact = new Contact();
      contact.accountID=acct.Id;
      contact.FirstNAme='TestFName' + DateTime.now();
      contact.Email ='aatest@test.com';
      contact.LastName='TestLName' + DateTime.now();
      insert contact;
      
      ApexPages.StandardController cont = new ApexPages.StandardController(acct);
      TerminateAccount terminateAcc = new TerminateAccount(cont);
      terminateAcc .getOptions();
      terminateAcc.Proceed();
      terminateAcc.status = 'Active';
      terminateAcc.Proceed();
      terminateAcc.status = 'Terminating';
      terminateAcc.Proceed();
      terminateAcc.status = 'Terminated';
      terminateAcc.Proceed();
      terminateAcc .Cancel();
    }
    
    @isTest
    static void Test_TerminateContact(){
      Account acct = new Account();
      acct.Name = 'test Account' + DateTime.now();
      acct.Type ='Commercial';
      acct.BillingCity = 'san mateo';
      acct.BillingStreet = 'Concar drive';
      acct.BillingPostalCode ='94402';
      acct.BillingCountry = 'USA'; 
      insert acct;
      
      Contact contact = new Contact();
      contact.accountID = acct.Id;
      contact.FirstNAme='TestFName' + DateTime.now();
      contact.Email ='aatest@test.com';
      contact.LastName='TestLName' + DateTime.now();
      insert contact;
      
      ApexPages.StandardController cont = new ApexPages.StandardController(contact);
      TerminateContact terminateCon = new TerminateContact(cont);
      terminateCon.Proceed();    
      terminateCon.Cancel();
    }
    
    //@isTest
    //public static void Test_Async(){      
    //  List<User> uList= [select Id,IsActive from User where ID != :UserInfo.getUserId()and isActive = true LIMIT 1 ];
    //  if(uList != null && uList.size()>0)
    //      Async.DeactivatePortalUser(uList[0].id);
    //}     
}