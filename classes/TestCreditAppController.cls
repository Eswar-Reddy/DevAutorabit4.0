/******************
**Modified by- Anuradha Suthar
**Modified on - July 23 2009
**Description- Test class for Credit application Controller 
**************************/

public class TestCreditAppController {

    @isTest
    public static void test_CreditApplicationController(){
        Credit_Application__c creditApp = new Credit_Application__c();
        creditApp.Credit_Limit_Requested__c = 1000;
        creditApp.CurrencyIsoCode = 'USD';
        creditApp.Credit_Limit_Requested__c = 1000;
        creditApp.Bank_Reference_Name__c = 'TestReference';
        creditApp.Trade_Reference_1_Company__c = 'Trade Reference1';
        creditApp.Trade_Reference_1_Phone__c = '12345' ;
        creditApp.Trade_Reference_2_Company__c = 'Trade Reference1';
        creditApp.Trade_Reference_2_Phone__c = '6789';
        creditApp.Federal_Tax_ID__c = '123456';
        creditApp.VAT_Number__c = '123456789';
        insert creditApp;
        
        //Create Account
        RecordType recType = Database.query('select id from RecordType where name like \'Partner%\' and SobjectType=\'Account\'');
        Account acc = new Account();
        acc.RecordTypeId = recType.Id;    
        acc.Name = 'TestDuplicate12';
        acc.Type ='Partner'; 
        acc.billingCity = 'TestCity';
        acc.BillingCountry = 'TestCountry';
        acc.BillingPostalCode = '12345';
        acc.BillingState = 'TestState';
        acc.BillingStreet = 'TestStreet';
        acc.ShippingCountry  = 'TestShippingCountry'; 
        acc.ShippingStreet = 'TestShippingStreet';
        acc.ShippingCity = 'TestShippingcity';
        acc.ShippingPostalCode = '45345';
        insert acc;
        
        ApexPages.currentPage().getParameters().put('aid',acc.id);
        ApexPages.StandardController contrl = new ApexPages.StandardController(creditApp);
        //Apexpages.currentPage().getParameters().put(PId, )
        CreditApplicationController crAppControl = new CreditApplicationController(contrl);
        crAppControl.step1();
        crAppControl.step2();
        crAppControl.step3();
        crAppControl.step4();
        //crAppControl.creditApp.Credit_Limit_Requested__c = 1000;
        crAppControl.saveCreditApplication();
        //crAppControl.cancel();
        
        Attachment attach = new Attachment();
        attach.Name = 'Test'+ String.valueOf(DateTime.Now());
        attach.ParentId = crAppControl.creditAppId;
        attach.Body = Blob.valueOf('Test String'+ String.valueOf(DateTime.Now()));
        insert attach;
        
        LIst<Attachment> listAttachment = new List<Attachment>();
        listAttachment.add(attach);
        Attachment attach2 = new Attachment();
        attach2.Name = 'Test'+ String.valueOf(DateTime.Now());
        attach2.ParentId = crAppControl.creditAppId;
        attach2.Body = Blob.valueOf('Test String'+ String.valueOf(DateTime.Now()));
        insert attach2;
        crAppControl.idToRemove = attach2.Id;
        crAppControl.remove();
        listAttachment.add(attach);
        crAppControl.setAttachments(listAttachment);
        crAppControl.showAttachedFiles();
        crAppControl.step1_EU();
        crAppControl.step2_EU();
        crAppControl.step3_EU();
        crAppControl.step4_EU();
        crAppControl.cancel_EU();        
        crAppControl.cancel();
        
        TestCreditApplicationManagement.test_CreditApplicationManagement();     
    }
}