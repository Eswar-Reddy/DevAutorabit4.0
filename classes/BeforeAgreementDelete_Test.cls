@isTest(SeeAllData=true)
public class BeforeAgreementDelete_Test {
    static testMethod void BeforeAgreementDeleteTest()
     {
     echosign_dev1__SIGN_Agreement__c agreement = new echosign_dev1__SIGN_Agreement__c();
     agreement.name = 'Test Lease Document';
     agreement.echosign_dev1__Status__c = 'Draft';
     insert agreement;  
     Delete agreement;
     }

}