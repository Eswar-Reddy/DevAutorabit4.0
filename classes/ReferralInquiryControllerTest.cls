@isTest
private class ReferralInquiryControllerTest {

    static final String SHARER_EMAIL = 'hullabaloo';
    static final String SHARER_FNAME = 'hotchip';
    static final String SHARER_LNAME = 'yankydoodle';
    static final String FRIEND_EMAIL = 'ballyhoo';
    static final String FRIEND_FNAME = 'hitchbot';
    static final String FRIEND_LNAME = 'timpani';
    static ApexPages.StandardController stdOpp;

    static void setup(){
        Account testAccount = TestUtils.createAccount('Sunpower Test', true);
        Contact testContact = TestUtils.createContact('Sunpower Test', testAccount.Id, true);
        Opportunity testOpp = TestUtils.createOpportunities(1, testAccount.Id, testContact.Id, true)[0];
        stdOpp = new ApexPages.StandardController(testOpp);
    }
    
    static testMethod void searchTest_Friend() {
        
        setup();
        ReferralInquiryController controller = new ReferralInquiryController(stdOpp);
        ReferralInquiryController.socialAnnexInstance = new SocialAnnexMock();

        controller.searchType = ReferralManagementCallout.FRIEND_TYPE;
        controller.firstname = FRIEND_FNAME;
        controller.lastName = FRIEND_LNAME;
        controller.email = FRIEND_EMAIL;

        Test.startTest();
            controller.search();
        Test.stopTest();

        List<ReferralInquiryController.ResponseRow> actuals = controller.responseRows;

        System.assertEquals(1, actuals.size(), 'One row should be returned');
        System.assertEquals(SHARER_EMAIL, actuals[0].email, 'The sharer email should be set');
        System.assertEquals(SHARER_FNAME, actuals[0].firstName, 'The sharer first name should be set');
        System.assertEquals(SHARER_LNAME, actuals[0].lastName, 'The sharer last name should be set');
    }

    static testMethod void searchTest_Sharer() {

        setup();
        ReferralInquiryController controller = new ReferralInquiryController(stdOpp);
        ReferralInquiryController.socialAnnexInstance = new SocialAnnexMock();

        controller.searchType = ReferralManagementCallout.SHARER_TYPE;
        controller.firstname = SHARER_FNAME;
        controller.lastName = SHARER_LNAME;
        controller.email = SHARER_EMAIL;

        Test.startTest();
            controller.search();
        Test.stopTest();

        List<ReferralInquiryController.ResponseRow> actuals = controller.responseRows;

        System.assertEquals(1, actuals.size(), 'One row should be returned');
        System.assertEquals(FRIEND_EMAIL, actuals[0].email, 'The friend email should be set');
        System.assertEquals(FRIEND_FNAME, actuals[0].firstName, 'The friend first name should be set');
        System.assertEquals(FRIEND_LNAME, actuals[0].lastName, 'The friend last name should be set');
    }

    public class SocialAnnexMock extends SocialAnnex {

        public SocialAnnexMock() {
            super();
        }

        public override AddFriendResponseContainer addFriend(AddFriendRequestContainer request) {
            AddFriendResponseContainer response = new AddFriendResponseContainer();
            return response;
        }

        public override Boolean updateStage(UpdateStageRequestContainer request) {
            return true;
        }

        public override GetUsersResponseContainer getUsers(GetUsersRequestContainer request){
            GetUsersResponseContainer.ResponseWrapper responseWrapper = new GetUsersResponseContainer.ResponseWrapper();
            responseWrapper.SharerId = 'sfid';
            responseWrapper.FriendId = 'friendId';
            responseWrapper.Sharer_email = SHARER_EMAIL;
            responseWrapper.Sharer_first_name = SHARER_FNAME;
            responseWrapper.Sharer_last_name = SHARER_LNAME;
            responseWrapper.Friend_first_name = FRIEND_FNAME;
            responseWrapper.Friend_last_name = FRIEND_LNAME;
            responseWrapper.Friend_email = FRIEND_EMAIL;
            responseWrapper.referralDate = 'date';
            responseWrapper.Status = 'status';

            GetUsersResponseContainer responseContainer = new GetUsersResponseContainer();
            responseContainer.message = 'message';
            responseContainer.opportunities.add(responseWrapper);

            return responseContainer;

        }
    }
}