@isTest
private class TimelineServicesTest {

    static testMethod void testGetAccountIdToAgreement() {
        TestClassFactory.createAndInsertLeaseAgreementSettings();
        
        final String AGREEMENT_RECORDTYPE_NAME = 'Lease_Contract';

        Account account = TestUtils.createAccounts(1, true)[0];

        echosign_dev1__SIGN_Agreement__c agreement = TestUtils.createAgreements(new Set<Id>{account.Id} , false)[0];
        agreement.echosign_dev1__Status__c = TimelineServices.AGREEMENT_STATUS;
        agreement.RecordTypeId = TestUtils.leaseContactRecordType.Id;
        insert agreement;

        Attachment attachment = TestUtils.createAttachments(1, 'testname', false)[0];
        attachment.ParentId = agreement.Id;
        insert attachment;

        Test.startTest();
            Map<String, echosign_dev1__SIGN_Agreement__c> accountIdToAgreement = TimelineServices.getAccountIdToAgreement(new Set<Id>{account.Id}, new Set<String>{AGREEMENT_RECORDTYPE_NAME});
        Test.stopTest();

        String expectedKey = TimelineServices.buildAccountAgreementKey(account.Id, AGREEMENT_RECORDTYPE_NAME);
        System.assertEquals(new Set<String>{expectedKey}, accountIdToAgreement.keySet(), 'The key should be created correctly');

        echosign_dev1__SIGN_Agreement__c actualAgreement = accountIdToAgreement.get(expectedKey);
        List<Attachment> actualAttachments = actualAgreement.Attachments;

        System.assertEquals(1, accountIdToAgreement.size(), 'only one agreement should be returned');
        System.assertEquals(agreement.Id, actualAgreement.Id, 'The correct agreement should be returned');
        System.assertEquals(1, actualAttachments.size(), 'One attachment should be queried back');
        System.assertEquals(attachment.Id, actualAttachments[0].Id, 'The correct attachment should be returned');

    }

    static testMethod void partnerAccountTest() {
        User partnerUser = TestUtils.createLeasePartnerInfo();
        Account expectedAccount = [SELECT Id FROM Account ORDER BY CreatedDate DESC LIMIT 1];

        Test.startTest();
            Account actualAccount;
            System.runAs(partnerUser) {
                actualAccount = TimelineServices.partnerAccount;
            }

        Test.stopTest();

        System.assertEquals(expectedAccount.Id, actualAccount.Id, 'The partner account should be returned' );
    }
}