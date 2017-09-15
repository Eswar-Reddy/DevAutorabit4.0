/*******************************
//Created By- Ritesh Srivastava
//Created On- Sep 26 2016
//Description- Test Class For CreateStandardAccount class  case : 00664384
//Version - 1.0
********************************/
    @isTest
private class TestCreateStandardAccount {

    @isTest
    static void TestCreateStandardAccount(){
        
        Partner_Application__c partnerlocal =  new  Partner_Application__c();
        partnerlocal.Zip__c = '302020';
        partnerlocal.Zip__c = 'testmethod';
        partnerlocal.State__c = 'test State';
        partnerlocal.Address__c = 'TestAddress';
        partnerlocal.Phone__c = '123456';
        //partnerlocal.Country__c = 'Test Country';//for Case#00072314
        partnerlocal.Country__c = 'United Kingdom';//for Case#00072314
        partnerlocal.Bill_To_Country__c='United Kingdom';
        partnerlocal.Theater__c = 'Europe';//for Case#00072314
        partnerlocal.Company_Name__c = 'ABC Ltd.';
        partnerlocal.City__c = 'Test City';
        partnerlocal.First_Name__c= 'First Name' +String.valueOf(DateTime.Now());
        partnerlocal.Last_Name__c = 'Last Name' +String.valueOf(DateTime.Now());
        partnerlocal.Email__c = 'tes12366t@66test66.com';
        insert partnerlocal;
        System.currentPageReference().getParameters().put('PId', partnerlocal.Id);        
        CreateStandardAccount obj = new CreateStandardAccount();
        obj.isCreateAccount = true;
        obj.isCreateContact = true;
        obj.confirm();
        obj.cancel();
        delete partnerlocal;
         
    }
     
}