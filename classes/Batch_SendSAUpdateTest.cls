@isTest
private class Batch_SendSAUpdateTest {
    static Account account;
    static Contact contact;
    static final String ALLOWED_STAGE = 'Stage';

    static void setup() {
        account =  TestUtils.createAccount('account', true);
        contact = TestUtils.createContact('contact', account.Id, true);

        TestUtils.createReferralManagementOpportunityStages(new List<String>{ALLOWED_STAGE});
        TestUtils.createReferralManagementCustomSetting(true);
    }

    static testMethod void sendSocialAnnexUpdate() {
        setup();

        SocialAnnexMock mock = new SocialAnnexMock(true);
        ReferralManagementCallout.socialAnnexInstance = mock;
        List<Opportunity> opportunities = TestUtils.createOpportunities(10, account.Id, contact.Id, false);
        for(Opportunity opportunity : opportunities) {
            opportunity.Send_Social_Annex_Update__c = true;
            opportunity.Friend_Id__c = 'friendid';
            opportunity.Sharer_Id__c = 'sharerid';
            opportunity.StageName = ALLOWED_STAGE;
        }
        ReferralManagementCallout.inBatchContext = true;
        insert opportunities;

        Test.startTest();
            Database.executeBatch(new Batch_SendSAUpdate(Pluck.ids(opportunities)));
        Test.stopTest();

        System.assertEquals(1, mock.numUpdateStageCalls, 'When there are opportunities that we need to send an update for, we should have called out to social annex');

        List<Opportunity> actuals = [
            SELECT Send_Social_Annex_Update__c
            FROM Opportunity
            WHERE Id IN :opportunities
        ];
        System.assertEquals(opportunities.size(), actuals.size(), 'We should have the same number of opportunities after the batch is run');
        for(Opportunity actual : actuals) {
            System.assert(!actual.Send_Social_Annex_Update__c, 'When an opportunity has been processed we should uncheck the send social annex update checkbox');
        }
    }

    static testMethod void sendSocialAnnexUpdateFailure() {
        setup();

        SocialAnnexMock mock = new SocialAnnexMock(false);
        ReferralManagementCallout.socialAnnexInstance = mock;
        List<Opportunity> opportunities = TestUtils.createOpportunities(10, account.Id, contact.Id, false);
        for(Opportunity opportunity : opportunities) {
            opportunity.Send_Social_Annex_Update__c = true;
            opportunity.Friend_Id__c = 'friendid';
            opportunity.Sharer_Id__c = 'sharerid';
            opportunity.StageName = ALLOWED_STAGE;
        }
        ReferralManagementCallout.inBatchContext = true;
        insert opportunities;

        Test.startTest();
            Database.executeBatch(new Batch_SendSAUpdate(Pluck.ids(opportunities)));
        Test.stopTest();

        System.assertEquals(1, mock.numUpdateStageCalls, 'When there are opportunities that we need to send an update for, we should have called out to social annex');

        List<Opportunity> actuals = [
            SELECT Send_Social_Annex_Update__c
            FROM Opportunity
            WHERE Id IN :opportunities
        ];
        System.assertEquals(opportunities.size(), actuals.size(), 'We should have the same number of opportunities after the batch is run');
        for(Opportunity actual : actuals) {
            System.assert(actual.Send_Social_Annex_Update__c, 'When an opportunity has been processed unsuccessfully, we should not uncheck the send social annex update checkbox');
        }
    }

    static testMethod void doNotSendSocialAnnexUpdate() {
        setup();

        SocialAnnexMock mock = new SocialAnnexMock(true);
        ReferralManagementCallout.socialAnnexInstance = mock;
        List<Opportunity> opportunities = TestUtils.createOpportunities(10, account.Id, contact.Id, false);
        for(Opportunity opportunity : opportunities) {
            opportunity.Send_Social_Annex_Update__c = false;
            opportunity.Friend_Id__c = 'friendid';
            opportunity.Sharer_Id__c = 'sharerid';
            opportunity.StageName = ALLOWED_STAGE;
        }
        ReferralManagementCallout.inBatchContext = true;
        insert opportunities;

        Test.startTest();
            Database.executeBatch(new Batch_SendSAUpdate(Pluck.ids(opportunities)));
        Test.stopTest();

        System.assertEquals(0, mock.numUpdateStageCalls, 'When there are no opportunities, we should not send an update');

        List<Opportunity> actuals = [
            SELECT Send_Social_Annex_Update__c
            FROM Opportunity
            WHERE Id IN :opportunities
        ];
        System.assertEquals(opportunities.size(), actuals.size(), 'We should have the same number of opportunities after the batch is run');
        for(Opportunity actual : actuals) {
            System.assert(!actual.Send_Social_Annex_Update__c, 'The checkbox should be left alone when it is unchecked');
        }
    }

    public class SocialAnnexMock extends SocialAnnex {
        Boolean updateStageResponse;
        Integer numUpdateStageCalls;

        public SocialAnnexMock(Boolean updateStageResponse) {
            super();

            this.updateStageResponse = updateStageResponse;
            numUpdateStageCalls = 0;
        }

        public override AddFriendResponseContainer addFriend(AddFriendRequestContainer request) {
            return null;
        }

        public override Boolean updateStage(UpdateStageRequestContainer request) {
            numUpdateStageCalls++;
            return updateStageResponse;
        }

        public override GetUsersResponseContainer getUsers(GetUsersRequestContainer request){
            return null;
        }
    }
}