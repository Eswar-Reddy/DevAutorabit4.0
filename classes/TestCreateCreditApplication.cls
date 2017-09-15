/*************************************************************************
Name     : TestCreateCreditApplication
Author   : Aslam Bari
Date     : May 01, 2009
Last Modified- Kapil Goutam
Date- July 13 2009
Usage    : This class is used to test class CreateCreditApplication.
**************************************************************************/
public class TestCreateCreditApplication{
   
    @isTest
    static void testController(){
       RecordType recType = Database.query('select id from RecordType where name like \'Partner%\' and SobjectType=\'Account\'');
    Account testAct = new Account();
    testAct.RecordTypeId = recType.Id;    
    testAct.Name = 'TestDuplicate1';
    testAct.Type ='Partner'; 
    testAct.billingCity = 'TestCity';
    testAct.BillingCountry = 'TestCountry';
    testAct.BillingPostalCode = '12345';
    testAct.BillingState = 'TestState';
    testAct.BillingStreet = 'TestStreet';
    testAct.ShippingCountry  = 'TestShippingCountry'; 
    testAct.ShippingStreet = 'TestShippingStreet';
    testAct.ShippingCity = 'TestShippingcity';
    testAct.ShippingPostalCode = '45345';
    insert testAct;
        
       
        
        PageReference pg = Page.CreateCreditApplication;
        pg.getParameters().put('id',testAct.Id);
        Test.setCurrentPage(pg);
        CreateCreditApplication controller = new CreateCreditApplication();        
        PageReference pgTest = controller.saveCreditApplication();
                
        pg.getParameters().put('id','invalidid');
        Test.setCurrentPage(pg);
        controller = new CreateCreditApplication();
        pgTest = controller.saveCreditApplication();        
        
        TestCreditApplicationManagement.test_CreditApplicationManagement();
    }    
}