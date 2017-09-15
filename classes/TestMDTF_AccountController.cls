/**************************************************
** PR- 01923
**Created By- Harsh Mathur
**Created On- June 11 2009
**Last Modified- Harsh Mathur
**Last Modified On-  June 17 2009 
**Desciption- Test class for controller MDTF_AccountController
*****************************************************
*****************************************************/
@isTest //MAM 24.APR.2015 - Moved isTest prefix for the test class 
public class TestMDTF_AccountController{
  //@isTest
  public static testMethod void checkMDTF_AccountController(){ //MAM 24.APR.2015 add testMethod keyword
    
    Test.startTest();
    Account accountObj = new Account();
    accountObj.Name = 'Test' + DateTime.now();
    accountObj.Type ='Commercial';
    accountObj.BillingCity = 'san mateo';
    accountObj.BillingStreet = 'Concar drive';
    accountObj.BillingPostalCode ='94402';
    accountObj.BillingCountry = 'USA';
    
    accountObj.ShippingCity = 'san mateo';
    accountObj.ShippingStreet = 'Concar drive';
    accountObj.ShippingPostalCode ='94402';
    accountObj.ShippingCountry = 'USA'; 
    
    accountObj.Oracle_County__c = 'USA';
    
    insert accountObj;
    Test.stopTest();   
        
    SmartStore_Details__c smartStore = new SmartStore_Details__c();
    smartStore.Account__c = accountObj.Id;
    smartStore.Order_Number__c = '123456'; 
    smartStore.Order_Date__c = Date.today(); 
    smartStore.Product_Name__c = 'test product';
    smartStore.Qty_Ordered__c = 1000;
    smartStore.Price__c = 100;
    insert smartStore;
    
    MDTF_Fund_Summary__c FS = new MDTF_Fund_Summary__c(); 
    FS.Name = 'Test FS'; 
    FS.Spent__c = 50;       
    FS.Promotion_Description__c = 'TestDescription';
    FS.Allowance__c = 150;
    FS.Claimed_Amt__c = 200;
    FS.Approved__c = 200;
    FS.Balance__c = 200;
    FS.Expiration__c = System.today();
    //FS.Expiration__c = '1231';
    FS.Smart_Store_Purchase__c = 1200;
    FS.Account__c = accountObj.Id;
    FS.Frozen__c=12.20;
    FS.Promotion__c='12313';
    insert FS;
    
    MDTF_Claim__c claim = new MDTF_Claim__c(Name='123claim');
    claim.Account__c = accountObj.Id;
    claim.Name = 'Test Claim'; 
    claim.Activity_from_Date__c = System.today();       
    claim.Activity_to_Date__c = System.today();         
    claim.Approved_Amt__c = 150;
    claim.Claim_Number__c = '200';
    claim.Claimed_Amt__c = 200;
    claim.Paid_Amt__c = 200;
    claim.Promotion__c = 'Promo';
    insert claim; 
    
    MDTF_Activities__c Activity = new MDTF_Activities__c();
    Activity.Account__c = accountObj.Id;
    Activity.Name = 'Test Claim'; 
    Activity.Comment__c = 'Comment';        
    Activity.Promotion_Description__c = 'Comment';      
    Activity.RecordNumber__c = 150;
    Activity.Sum_of_Transaction_Amt__c = 200;
    Activity.Transaction_Month__c = '200';
    Activity.Promotion__c = 'Promo';
    insert Activity;
    
    
    
    ApexPages.CurrentPage().getParameters().put('Id', accountObj.Id);
    ApexPages.StandardController controller = new ApexPages.StandardController(accountObj);
    MDTF_AccountController testObj = new MDTF_AccountController(controller);
    String sortDir = testObj.getSortDirection();
    testObj.setSortDirection(sortDir); 
    testObj.sortExpression = 'name';
    testObj.sortExpression = 'name';  //MAM 24.APR.2015 - Simulated clicking the column for the 2nd Time
    testObj.sortSmartStore();
    //testObj.sortPriorApprovals();
    testObj.sortMdtfActivities();
    //testObj.sortMdtfTraining();
    testObj.sortMdtfClaim();
    testObj.sortMdtfFundSummary();
    testObj.sortMdtfTraining();
    System.assert(!testObj.getHasError());
    
    //TestAccountManagement.Test_AccountUpdate();
    //TestAccountManagement.Test_TerminatedAccountUpdate();
    //TestCertificationManagement.checkCertificationManagement();

    ApexPages.StandardController controller1 = new ApexPages.StandardController(accountObj);
    MDTF_AccountController testObj1 = new MDTF_AccountController(controller1);
    testObj1.sortExpression = 'Name-Id';
    testObj1.sortMdtfActivities(); 
    
    ApexPages.CurrentPage().getParameters().put('Id', ' ');
    ApexPages.StandardController controller3 = new ApexPages.StandardController(accountObj);
    MDTF_AccountController testObj3 = new MDTF_AccountController(controller3);
    System.assert(testObj3.getHasError()); 
  }
}