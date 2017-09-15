@isTest
private class SocialAnnexTest {

    final static String ADD_FRIEND_ENDPOINT = 'Elton';
    final static String UPDATE_STAGE_ENDPOINT = 'John';
    final static String GET_USERS_ENDPOINT = 'Necrodancer';
    final static string MOCK_FRIENDID = 'joey';
    static ReferralManagementEndpoint__c settings;

    static void setup() {
        settings = TestUtils.createReferralManagementCustomSetting(false);
    }

    static testMethod void addFriend() {
        final Integer NUM_OBJECTS = 2;

        setup();

        SocialAnnex.SocialAnnexReal socialAnnexInstance = new SocialAnnex.SocialAnnexReal(settings);

        List<Lead> testLeads = TestUtils.createLeads(NUM_OBJECTS,true);

        AddFriendRequestContainer requestContainer = new AddFriendRequestContainer(testLeads);

        Test.setMock(HttpCalloutMock.class, new MockAddFriendResponse());

        Test.startTest();
            AddFriendResponseContainer actual = socialAnnexInstance.addFriend(requestContainer);
        Test.stopTest();

        System.assertEquals(NUM_OBJECTS, actual.sObjects.size(), 'The correct number of objects should be returned');
        for(AddFriendResponseContainer.ResponseWrapper wrapper : actual.sObjects) {
            System.assertEquals(MOCK_FRIENDID, wrapper.friendId, 'Friend Id should be set');
        }
    }

    static testMethod void updateStage() {
        final Integer NUM_OBJECTS = 2;

        setup();

        SocialAnnex.SocialAnnexReal socialAnnexInstance = new SocialAnnex.SocialAnnexReal(settings);

        List<Lead> testLeads = TestUtils.createLeads(NUM_OBJECTS,true);

        UpdateStageRequestContainer requestContainer = new UpdateStageRequestContainer(testLeads);

        Test.setMock(HttpCalloutMock.class, new MockUpdateStageResponse(SocialAnnex.UPDATE_STAGE_MESSAGE_SUCCESSFUL));

        Test.startTest();
            Boolean actual = socialAnnexInstance.updateStage(requestContainer);
        Test.stopTest();

        List<Exception_log__c> actuals = [
            SELECT Id
            FROM Exception_log__c
        ];
        System.assert(actuals.isEmpty(), 'No logged exceptions should be recorded');

        System.assert(actual, 'The callout should be successful');
    }

    static testMethod void updateStage_fail() {
        final Integer NUM_OBJECTS = 2;

        setup();

        SocialAnnex.SocialAnnexReal socialAnnexInstance = new SocialAnnex.SocialAnnexReal(settings);

        List<Lead> testLeads = TestUtils.createLeads(NUM_OBJECTS,true);

        UpdateStageRequestContainer requestContainer = new UpdateStageRequestContainer(testLeads);

        Test.setMock(HttpCalloutMock.class, new MockUpdateStageResponse('not successful'));

        Test.startTest();
            socialAnnexInstance.updateStage(requestContainer);
        Test.stopTest();

        List<Exception_log__c> actuals = [
            SELECT Id
            FROM Exception_log__c
        ];
        System.assertEquals(1, actuals.size(), 'a logged exception should be recorded');
    }

    static testMethod void getUsers() {
        final Integer NUM_OBJECTS = 2;

        setup();

        SocialAnnex.SocialAnnexReal socialAnnexInstance = new SocialAnnex.SocialAnnexReal(settings);

        GetUsersRequestContainer requestContainer = new GetUsersRequestContainer(ReferralManagementCallout.FRIEND_TYPE, 'fname', 'lname', 'fname@lname.com', 'friendId');

        Test.setMock(HttpCalloutMock.class, new MockGetUsersResponse(SocialAnnex.UPDATE_STAGE_MESSAGE_SUCCESSFUL));

        Test.startTest();
            GetUsersResponseContainer actual = socialAnnexInstance.getUsers(requestContainer);
        Test.stopTest();

        System.assert(!actual.opportunities.isEmpty(), 'A response should be returned');
    }

    class MockAddFriendResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals(settings.Add_Friend__c, req.getEndpoint());
            System.assertEquals('POST', req.getMethod());
            AddFriendResponseContainer responseContainer = new AddFriendResponseContainer();
            responseContainer.sObjects = new List<AddFriendResponseContainer.ResponseWrapper>();
            AddFriendRequestContainer requestContainer = (AddFriendRequestContainer) JSON.deserialize(req.getBody(), AddFriendRequestContainer.class);

            for(AddFriendRequestContainer.RequestWrapper requestWrapper : requestContainer.sObjects) {
                AddFriendResponseContainer.ResponseWrapper response = new AddFriendResponseContainer.ResponseWrapper();
                response.salesforceId = requestWrapper.salesforceId;
                response.friendId = MOCK_FRIENDID;
                response.Notes = 'notes';
                responseContainer.sObjects.add(response);
            }

            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JSON.serialize(responseContainer));
            res.setStatusCode(200);
            return res;
        }
    }

    class MockUpdateStageResponse implements HttpCalloutMock {
        String message;

        public MockUpdateStageResponse(String message) {
            this.message = message;
        }

        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals(settings.Update_Stage__c, req.getEndpoint());
            System.assertEquals('POST', req.getMethod());

            UpdateStageResponseContainer.OpportunityObject opportunityObject = new UpdateStageResponseContainer.OpportunityObject();
            opportunityObject.salesforceId = 'sfid';
            opportunityObject.FriendID = 'friendId';
            opportunityObject.SharerID = 'sharerId';
            opportunityObject.stat_id = 'statId';
            opportunityObject.DealerID = 'dealerId';
            opportunityObject.status = 'status';

            UpdateStageResponseContainer responseContainer = new UpdateStageResponseContainer();
            responseContainer.message = this.message;
            responseContainer.token = 'some token';
            responseContainer.opportunities.add(opportunityObject);

            HttpResponse res = new HttpResponse();
            res.setBody(JSON.serialize(responseContainer));
            res.setStatusCode(200);
            return res;
        }
    }

    class MockGetUsersResponse implements HttpCalloutMock {
        String message;

        public MockGetUsersResponse(String message) {
            this.message = message;
        }

        public HTTPResponse respond(HTTPRequest req) {
            System.assertEquals(settings.Get_Users__c, req.getEndpoint());
            System.assertEquals('POST', req.getMethod());

            GetUsersResponseContainer.ResponseWrapper responseWrapper = new GetUsersResponseContainer.ResponseWrapper();
            responseWrapper.SharerId = 'sfid';
            responseWrapper.FriendId = 'friendId';
            responseWrapper.Sharer_email = 'sharerId';
            responseWrapper.Sharer_first_name = 'statId';
            responseWrapper.Sharer_last_name = 'dealerId';
            responseWrapper.Friend_first_name = 'fname';
            responseWrapper.Friend_last_name = 'lname';
            responseWrapper.ReferralDate = 'date';
            responseWrapper.Status = 'status';

            GetUsersResponseContainer responseContainer = new GetUsersResponseContainer();
            responseContainer.message = this.message;
            responseContainer.opportunities.add(responseWrapper);

            HttpResponse res = new HttpResponse();
            res.setBody(JSON.serialize(responseContainer));
            res.setStatusCode(200);
            return res;
        }
    }
}