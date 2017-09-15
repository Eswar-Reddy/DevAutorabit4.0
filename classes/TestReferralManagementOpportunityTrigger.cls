@isTest
private class TestReferralManagementOpportunityTrigger {
    static Account testAccount;
    static Contact testContact;
    static final String ALLOWED_STAGE = 'Coach';

    static void setup()
    {
        testAccount = TestUtils.createAccount('dixie', true);
        testContact = TestUtils.createContact('land', testAccount.Id, true);

        TestUtils.createReferralManagementCustomSetting(true);
        TestUtils.createReferralManagementOpportunityStages(new List<String>{ALLOWED_STAGE});
    }

    static testMethod void bulkUpdate() {
        setup();

        //final Integer NUM_OPPORTUNITIES = 200;
        final Integer NUM_OPPORTUNITIES = 1;

        List<Opportunity> testOpportunities = TestUtils.createOpportunities(NUM_OPPORTUNITIES, testAccount.Id, testContact.Id, true);

        for(Opportunity testOpportunity : testOpportunities) {
            testOpportunity.Sharer_Id__c = 'sharingIsCaring';
            testOpportunity.Friend_Id__c = 'carebear';
            testOpportunity.StageName = ALLOWED_STAGE;
        }

        Test.startTest();

            ReferralManagementCallout.socialAnnexInstance = new ReferralManagementCalloutTest.SocialAnnexMock();
            try {
                update testOpportunities;
            } catch(Exception e) {
                System.assert(false, 'Should not get any errors: ' + e);
            }

        Test.stopTest();
    }

    static testMethod void bulkInsert() {
        setup();

        //final Integer NUM_OPPORTUNITIES = 100;
        final Integer NUM_OPPORTUNITIES = 1;

        List<Opportunity> testOpportunitiesWithFriendId = TestUtils.createOpportunities(NUM_OPPORTUNITIES, testAccount.Id, testContact.Id, false);
        List<Opportunity> testOpportunitiesWithOutFriendId = TestUtils.createOpportunities(NUM_OPPORTUNITIES, testAccount.Id, testContact.Id, false);

        List<Opportunity> allOpportunities = new List<Opportunity>(testOpportunitiesWithFriendId);
        allOpportunities.addAll(testOpportunitiesWithOutFriendId);

        for(Opportunity testOpportunity : testOpportunitiesWithFriendId) {
            testOpportunity.Friend_Id__c = 'carebear';
        }

        for(Opportunity testOpportunity : allOpportunities) {
            testOpportunity.StageName = ALLOWED_STAGE;
        }

        Test.startTest();

            ReferralManagementCallout.socialAnnexInstance = new ReferralManagementCalloutTest.SocialAnnexMock();
            try {
                insert allOpportunities;
            } catch(Exception e) {
                System.assert(false, 'Should not get any errors: ' + e);
            }

        Test.stopTest();

        List<Opportunity> actualOpportunities = [SELECT Friend_Id__c FROM Opportunity WHERE Id IN :testOpportunitiesWithoutFriendId];

        for(Opportunity actualOpportunity : actualOpportunities) {
            System.assertEquals(ReferralManagementCalloutTest.MOCK_FRIENDID, actualOpportunity.Friend_Id__c, 'The friend Id should be set correctly');
        }
    }
}