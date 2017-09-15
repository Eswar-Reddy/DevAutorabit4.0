// Test Cases for DeleteNotesAttachment 

@isTest
Private class Test_DeleteNotesAttachment {

    static testMethod void DeleteNotesAtt() {

        TestClassFactory.createAndInsertLeaseAgreementSettings();
    
        echosign_dev1__SIGN_Agreement__c aggr = new echosign_dev1__SIGN_Agreement__c();
            insert aggr;
            
        Attachment attch = new Attachment();
            attch.ParentId = aggr.Id;
            attch.Name = 'hllo';
            attch.Body = Blob.valueOf('hiii');
            insert attch;
            
            delete attch;     
    
    }
}