/**************************************************
** PR- 01923
**Created By- Kapil Goutam
**Created On- June 10 2009
**Last Modified- 
**Last Modified On-   
**Desciption- Test class for Controller 
*****************************************************/
public class TestCreditAppPdfController {
    @isTest
    public static void Test_CreditAppPdfController(){
        Credit_Application__c creditApp = new Credit_Application__c();
        creditApp.Credit_Limit_Requested__c = 1000;        
        creditApp.Bank_Reference_Name__c = 'TestReference';
        creditApp.Trade_Reference_1_Company__c = 'Trade Reference1';
        creditApp.Trade_Reference_1_Phone__c = '12345' ;
        creditApp.Trade_Reference_2_Company__c = 'Trade Reference1';
        creditApp.Trade_Reference_2_Phone__c = '6789';
        creditApp.Federal_Tax_ID__c = '1234';
        creditApp.VAT_Number__c = '56789';
        insert creditApp;
        
        Apexpages.currentPage().getParameters().put('id', creditApp.Id);
        Apexpages.Standardcontroller controller = new Apexpages.Standardcontroller(creditApp);
        CreditAppPdfController creditPdf = new CreditAppPdfController(controller);
        //TestCreditApplicationManagement.test_CreditApplicationManagement();
        
    }

}