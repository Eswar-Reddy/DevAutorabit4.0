@isTest
private class TestReferralManagementLeadTrigger {
    static final Integer NUM_LEADS = Limits.getLimitQueries() + 1;
    static final String ALLOWED_STATUS = 'Chiweenie';
    static final String ANOTHER_ALLOWED_STATUS = 'Lab';
    static final string MOCK_MESSAGE = 'message';
    static final string MOCK_FRIENDID = 'joey';

    public static Integer numberOfUpdateStageCallouts = 0;

    static List<Lead> leads;

    static void setup() {
        TestUtils.createReferrralManagementLeadStatus(new Set<String>{ALLOWED_STATUS, ANOTHER_ALLOWED_STATUS});

        leads = TestUtils.createLeads(NUM_LEADS, false);
        for(Lead lead : leads) {
            lead.Status = ALLOWED_STATUS;
            lead.Sharer_Id__c = 'RHCP';
        }
    }

    static testMethod void bulkInsert() {
        setup();

        for(Lead lead : leads) {
            lead.Friend_Id__c = null;
        }

        ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();

        Test.startTest();
            insert leads;
        Test.stopTest();

        List<Lead> actuals = [
            SELECT Friend_Id__c
            FROM Lead
            WHERE Id IN :leads
        ];

        System.assertEquals(NUM_LEADS, actuals.size(), 'The number of leads should match');

        for(Lead lead : actuals) {
            // Nathan. case 00562712_Ambassador (referrer) direct entry method
            // reusing Friend_Id__c of Lead. we need to remove entire referral management code base later
            // System.assertEquals(MOCK_FRIENDID, lead.Friend_Id__c, 'The friend id should get pulled back');
        }
    }

    public class SocialAnnexMock extends SocialAnnex {

        public SocialAnnexMock() {
            super();
        }

        public override AddFriendResponseContainer addFriend(AddFriendRequestContainer request) {
            AddFriendResponseContainer response = new AddFriendResponseContainer();

            response.message = MOCK_MESSAGE;
            for(AddFriendRequestContainer.RequestWrapper sobj : request.sObjects)
            {
                AddFriendResponseContainer.ResponseWrapper responseWrapper = new AddFriendResponseContainer.ResponseWrapper();
                responseWrapper.salesforceId = sobj.salesforceId;
                responseWrapper.friendId = MOCK_FRIENDID;
                response.sObjects.add(responseWrapper);
            }

            return response;
        }

        public override Boolean updateStage(UpdateStageRequestContainer request) {
            numberOfUpdateStageCallouts++;
            return true;
        }

        public override GetUsersResponseContainer getUsers(GetUsersRequestContainer request) {
            return null;
        }
    }
}