/*******************************
//Created By- Kapil Goutam
//Created On- May 01 2009
//Last Modified on-
//Last Modified By-
//Description- Test Class For CreatePartnerAccount page
//Version - 1.0
********************************/
    @isTest
private class TestCreatePartnerAccount {

    @isTest
    static void TestCreatePartnerAccount(){
        
        Partner_Application__c partnerlocal =  new  Partner_Application__c();
        partnerlocal.Zip__c = '302020';
        partnerlocal.Zip__c = 'testmethod';
        partnerlocal.State__c = 'test State';
        partnerlocal.Address__c = 'TestAddress';
        partnerlocal.Phone__c = '123456';
        //partnerlocal.Country__c = 'Test Country';//for Case#00072314
        partnerlocal.Country__c = 'United Kingdom';//for Case#00072314
        partnerlocal.Theater__c = 'Europe';//for Case#00072314
        partnerlocal.Company_Name__c = 'ABC Ltd.';
        partnerlocal.City__c = 'Test City';
        partnerlocal.First_Name__c= 'First Name' +String.valueOf(DateTime.Now());
        partnerlocal.Last_Name__c = 'Last Name' +String.valueOf(DateTime.Now());
        partnerlocal.Email__c = 'tes12366t@66test66.com';
        insert partnerlocal;
        System.currentPageReference().getParameters().put('PId', partnerlocal.Id);        
        CreatePartnerAccount obj = new CreatePartnerAccount();
        obj.isCreateAccount = true;
        obj.isCreateContact = true;
        obj.confirm();
        obj.cancel();
        delete partnerlocal;
        
        //TestCheckContactDuplicate.testcheckContactDuplicate();     
        //TestPartnerApplicationManagement.Test_PartnerApplicationManagement();   
    }
     
}