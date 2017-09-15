/*********************************************** 
**PR-01771
**by- Kapil Goutam
**on - May 20 2009  
**Description- Test Class for MDTF_AccountController Class
***********************************************/

@isTest //MAM 24.APR.2015 - Moved isTest prefix for the test class 
public class Test_MDTF_AccountController {
   
   public static testMethod void Test_MDTF_AccountController() { //MAM 24.APR.2015 add testMethod keyword
        Test.startTest();//MAM 24.APR.2015 add Test.startTest(); and Test.stopTest();
        Account acc = new Account();
        acc.Name = 'Test Account' + String.valueOf(DateTime.Now());
        acc.Override_Duplicate_Check__c = true;
        acc.Status__c = 'Terminated';
        acc.Type ='Commercial';
        acc.BillingCity = 'san mateo';
        acc.BillingStreet = 'Concar drive';
        acc.BillingPostalCode ='94402';
        acc.BillingCountry = 'USA';
        insert acc;
        //for Account Management Coverage
        TestAccountManagement.Test_TerminatedAccountUpdate();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        System.currentPageReference().getParameters().put('id', acc.id);
        MDTF_AccountController mdtfObj = new MDTF_AccountController(sc);
        Test.stopTest();//MAM 24.APR.2015 add Test.startTest(); and Test.stopTest();
   }
}