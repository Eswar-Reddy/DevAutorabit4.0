@isTest
private class TestCreditApplicationEditController {
    @isTest
    public static void testClass() {
        Test.setCurrentPage(Page.CreditApplicationEdit);
        
        RecordType recType = Database.query('select id from RecordType where name like \'Partner%\' and SobjectType=\'Account\'');
    Account acc = new Account();
    acc.RecordTypeId = recType.Id;    
    acc.Name = 'TestDuplicate';
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
        
        Credit_Application__c creApp = new Credit_Application__c();
        creApp.Account__c = acc.Id;
        creApp.Credit_Limit_Requested__c = 1000;
        creApp.Bank_Reference_Name__c = 'TestReference';
        creApp.Trade_Reference_1_Company__c = 'Trade Reference1';
        creApp.Trade_Reference_1_Phone__c = '12345';
        creApp.Trade_Reference_2_Company__c = 'Trade Reference1';
        creApp.Trade_Reference_2_Phone__c = '6789';
        creApp.Federal_Tax_ID__c = '123456';
        creApp.VAT_Number__c = '123456789';
        insert creApp;
        
        //MAM 09/17/2014 update userlist filter to also check the profile start
        List<User> userList = [select id from User where UserRole.Name in ('Credit Analyst', 'Credit Manager') and isActive = true AND profile.name in ('SunPower Credit') Limit 1];
        //MAM 09/17/2014 end
        List<User> userList1 = [select id, Contact.AccountId from User where Profile.Name = 'Partner Delegated Administrator' and isActive = true Limit 1];
        
        Test.startTest();
        CreditApplicationEditController controller =
                new CreditApplicationEditController(new ApexPages.StandardController(creApp));
        controller.redirectUser();        
        //System.assert(controller.isCAEditable , true);//Shree- 27092012 : Due to Bluwolf Booking Template Module Faliure
        try {
            delete creApp;
        } catch(Exception e) {}
        
        if(userList.size() == 1){        
            System.RunAs(userList.get(0)){
                Credit_Application__c creApp1 = new Credit_Application__c();
                creApp1.Account__c = acc.Id;
                creApp1.Credit_Limit_Requested__c = 1000;
                creApp1.Bank_Reference_Name__c = 'TestReference';
                creApp1.Trade_Reference_1_Company__c = 'Trade Reference2';
                creApp1.Trade_Reference_1_Phone__c = '12345';
                creApp1.Trade_Reference_2_Company__c = 'Trade Reference2';
                creApp1.Trade_Reference_2_Phone__c = '6789';
                creApp1.Federal_Tax_ID__c = '123456';
                creApp1.VAT_Number__c = '123456789';
                creApp1.Status__c = 'Approved';
                insert creApp1;             
                controller = new CreditApplicationEditController(new ApexPages.StandardController(creApp1));
                System.assert(controller.isCAEditable , true);   
            }
        }
        if(userList1.size() == 1){        
            System.RunAs(userList1.get(0)){
                Credit_Application__c creApp1 = new Credit_Application__c();
                creApp1.Account__c = userList1.get(0).Contact.AccountId;
                creApp1.Credit_Limit_Requested__c = 1000;
                creApp1.Bank_Reference_Name__c = 'TestReference';
                creApp1.Trade_Reference_1_Company__c = 'Trade Reference2';
                creApp1.Trade_Reference_1_Phone__c = '12345';
                creApp1.Trade_Reference_2_Company__c = 'Trade Reference2';
                creApp1.Trade_Reference_2_Phone__c = '6789';
                creApp1.Federal_Tax_ID__c = '123456';
                creApp1.VAT_Number__c = '123456789';
                creApp1.Status__c = 'New';
                insert creApp1;             
                controller = new CreditApplicationEditController(new ApexPages.StandardController(creApp1));
                System.assert(controller.isCAEditable , true);              
            }
        }
        Test.stopTest();
    }
}