@isTest
private class SunPower_Five9_Integration_TEST {
    
    private static testmethod void test_contact() {
        Account acc1;
        Contact con1;
    
        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1];
        User u = [SELECT Id, Email, Username FROM User WHERE Id = :UserInfo.getUserId()];
        
        acc1 = new Account();
        acc1.RecordTypeId = rt.Id;
        acc1.Name='Test_SF9IntAcc1';
        acc1.BillingCountry='USA';
        acc1.BillingState ='CA';
        acc1.BillingCity='San Jose';
        acc1.BillingStreet='123 SF9IntAcc1';
        acc1.BillingPostalCode = '95763';
        acc1.Primary_PSR__c = u.Id;
        insert acc1; 

        con1=new Contact();
        con1.AccountId = acc1.Id;
        con1.LastName = 'TestSF9IntCon1';
        con1.Phone = '1234567891';
        insert con1;

        Test.setFixedSearchResults(new List <Id>{con1.Id});
        SunPower_Five9_Integration.SalesforceResponse resp = SunPower_Five9_Integration.findAccountbyPhone(con1.Phone);
        system.assertEquals(acc1.Id, resp.sfId);
        system.assertEquals(acc1.Id, resp.sfPopId);
        system.assertEquals('1', resp.multId);
        system.assertEquals(u.Username, resp.psrId);
        
    }

    private static testmethod void test_account() {
        Account acc1;

        RecordType rt = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1];
        User u = [SELECT Id, Email, Username FROM User WHERE Id = :UserInfo.getUserId()];
        
        acc1 = new Account();
        acc1.RecordTypeId = rt.Id;
        acc1.Name='Test_SF9IntAcc1';
        acc1.BillingCountry='USA';
        acc1.BillingState ='CA';
        acc1.BillingCity='San Jose';
        acc1.BillingStreet='123 SF9IntAcc1';
        acc1.BillingPostalCode = '95763';
        acc1.Primary_PSR__c = u.Id;
        acc1.Phone = '1234567891';
        insert acc1; 

        Test.setFixedSearchResults(new List <Id>{acc1.Id});
        SunPower_Five9_Integration.SalesforceResponse resp = SunPower_Five9_Integration.findAccountbyPhone(acc1.Phone);
        system.assertEquals(acc1.Id, resp.sfId);
        system.assertEquals(acc1.Id, resp.sfPopId);
        system.assertEquals('1', resp.multId);
        system.assertEquals(u.Username, resp.psrId);
        
    }
}