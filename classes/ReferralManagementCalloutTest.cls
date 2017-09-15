@isTest
public class ReferralManagementCalloutTest {

    static Lead testLead;
    static Opportunity testOpportunity;
    static Account testAccount;
    static Contact testContact;
    static final string MOCK_NOTES = 'actor';
    static final string MOCK_MESSAGE = 'bleepblorp';
    static final String ALLOWED_STAGE = 'Coach';
    static final String ANOTHER_ALLOWED_STAGE = 'Player';
    static final String ALLOWED_STATUS = 'Chiweenie';
    static final String ANOTHER_ALLOWED_STATUS = 'Lab';
    public static final string MOCK_FRIENDID = 'joey';

    public static Integer numberOfUpdateStageCallouts = 0;

    static void setup()
    {
        testLead = TestUtils.createLeads(1,false)[0];
        testLead.Status = ALLOWED_STATUS;
        testLead.Sharer_Id__c = 'RHCP';

        testAccount = TestUtils.createAccount('dixie', true);
        testContact = TestUtils.createContact('land', testAccount.Id, true);
        testOpportunity = TestUtils.createOpportunities(1, testAccount.Id, testContact.Id, false)[0];

        TestUtils.createReferrralManagementLeadStatus(new Set<String>{ALLOWED_STATUS, ANOTHER_ALLOWED_STATUS});
        TestUtils.createReferralManagementOpportunityStages(new List<String>{testOpportunity.StageName, ALLOWED_STAGE, ANOTHER_ALLOWED_STAGE});
        TestUtils.createReferralManagementCustomSetting(true);
    }

    static testMethod void invokeAddFriendCalloutFutureTest()
    {
        setup();
        insert testLead;

        String leadsJSON = JSON.serialize(new List<Lead>{testLead});

        Test.startTest();
            ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();
            ReferralManagementCallout.invokeAddFriendCalloutFuture(leadsJSON);

        Test.stopTest();

        Lead actualLead = [SELECT Friend_Id__c FROM Lead WHERE Id = :testLead.Id];

        // Nathan. case 00562712_Ambassador (referrer) direct entry method
        // reusing Friend_Id__c of Lead. we need to remove entire referral management code base later
        // System.assertEquals(MOCK_FRIENDID, actualLead.Friend_Id__c, 'The friend Id should be set');
    }

    static testMethod void performAddFriendCalloutTest()
    {
        setup();
        insert testLead;

        List<Lead> testLeads = new List<Lead> {testLead};

        AddFriendRequestContainer requestContainer = new AddFriendRequestContainer(testLeads);

        Test.startTest();
            ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();
            ReferralManagementCallout.performAddFriendCallout(requestContainer);

        Test.stopTest();

        Lead actualLead = [SELECT Friend_Id__c, Lead_Qualification_Notes__c FROM Lead WHERE Id = :testLead.Id];

        // Nathan. case 00562712_Ambassador (referrer) direct entry method
        // reusing Friend_Id__c of Lead. we need to remove entire referral management code base later
        // System.assertEquals(MOCK_FRIENDID, actualLead.Friend_Id__c, 'The friendId should be set');
        // System.assertEquals(MOCK_NOTES, actualLead.Lead_Qualification_Notes__c, 'The Additional notes should be populated');
    }

    static testMethod void invokeUpdateStageCalloutFutureTest()
    {
        setup();
        insert testOpportunity;

        String leadsJSON = JSON.serialize(new List<Opportunity>{testOpportunity});

        Test.startTest();

            try {
                ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();
                ReferralManagementCallout.invokeUpdateStageCalloutFuture(leadsJSON);
            } catch (Exception e) {
                System.assert(false, 'No errors should occur');
            }

        Test.stopTest();
    }

    static testMethod void performUpdateStageCalloutTest()
    {
        setup();
        insert testOpportunity;

        List<Opportunity> testOpportunities = new List<Opportunity> {testOpportunity};

        UpdateStageRequestContainer requestContainer = new UpdateStageRequestContainer(testOpportunities);

        Test.startTest();

            try {
                ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();
                ReferralManagementCallout.performUpdateStageCallout(requestContainer);
            } catch (Exception e) {
                System.assert(false, 'No errors should occur');
            }

        Test.stopTest();
    }

    static testMethod void executeSocialAnnexCalloutsOnInsert() {
        setup();

        ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();

        Opportunity testOpportunityWithFriendId = TestUtils.createOpportunities(1, testAccount.Id, testContact.Id, false)[0];
        Opportunity testOpportunityWithOutFriendId = TestUtils.createOpportunities(1, testAccount.Id, testContact.Id, false)[0];

        testOpportunityWithFriendId.Friend_Id__c = 'carebear';
        testOpportunityWithFriendId.StageName = ALLOWED_STAGE;

        testOpportunityWithOutFriendId.StageName = ALLOWED_STAGE;

        List<Opportunity> allOpportunities = new List<Opportunity>{testOpportunityWithFriendId, testOpportunityWithOutFriendId};
        Test.startTest();
        insert allOpportunities;

        testOpportunityWithOutFriendId.Friend_Id__c = null;
        update testOpportunityWithOutFriendId;

        

            try {
                ReferralManagementCallout.executeSocialAnnexCalloutsOnInsert(allOpportunities);
            } catch(Exception e) {
                System.assert(false, 'Should not get any errors: ' + e);
            }

        Test.stopTest();

        Opportunity actualOpportunity = [SELECT Friend_Id__c FROM Opportunity WHERE Id = :testOpportunityWithOutFriendId.Id];

        System.assertEquals(ReferralManagementCalloutTest.MOCK_FRIENDID, actualOpportunity.Friend_Id__c, 'The friend Id should be set correctly');
    }

    static testMethod void executeSocialAnnexCalloutsOnInsert_withoutFriendId_withoutSharerId() {
        setup();

        ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();

        Opportunity testOpportunityWithOutFriendId = TestUtils.createOpportunities(1, testAccount.Id, testContact.Id, false)[0];

        testOpportunityWithOutFriendId.Sharer_Id__c = null;
        testOpportunityWithOutFriendId.StageName = ALLOWED_STAGE;

        List<Opportunity> allOpportunities = new List<Opportunity>{testOpportunityWithOutFriendId};
        insert allOpportunities;

        Test.startTest();

            try {
                ReferralManagementCallout.executeSocialAnnexCalloutsOnInsert(allOpportunities);
            } catch(Exception e) {
                System.assert(false, 'Should not get any errors: ' + e);
            }

        Test.stopTest();

        Opportunity actualOpportunity = [SELECT Friend_Id__c FROM Opportunity WHERE Id = :testOpportunityWithOutFriendId.Id];

        System.assertEquals(null, actualOpportunity.Friend_Id__c, 'The friend id should not be set if the sharer id is null');
    }

    static testMethod void executeSocialAnnexCalloutsOnUpdate() {
        setup();

        ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();

        Opportunity testOpportunityWithFriendId = TestUtils.createOpportunities(1, testAccount.Id, testContact.Id, false)[0];

        testOpportunityWithFriendId.Friend_Id__c = 'carebear';
        testOpportunityWithFriendId.StageName = ALLOWED_STAGE;

        List<Opportunity> allOpportunities = new List<Opportunity>{testOpportunityWithFriendId};
        insert allOpportunities;

        List<Opportunity> allOldOpportunities = allOpportunities.deepClone(true);
        for(Opportunity oldOpportunity : allOldOpportunities) {
            oldOpportunity.StageName = ANOTHER_ALLOWED_STAGE;
        }

        Test.startTest();
            numberOfUpdateStageCallouts = 0;

            try {
                ReferralManagementCallout.executeSocialAnnexCalloutsOnUpdate(allOpportunities, new Map<Id, Opportunity>(allOldOpportunities));
            } catch(Exception e) {
                System.assert(false, 'Should not get any errors: ' + e);
            }

        Test.stopTest();

        //System.assertEquals(1, numberOfUpdateStageCallouts, 'We should call an update stage when there is a friend id');
    }

    static testMethod void executeSocialAnnexCalloutsOnInsert_lead_withoutFriendId() {
        setup();

        ReferralManagementCallout.socialAnnexInstance = new SocialAnnexMock();

        testLead.Friend_Id__c = null;
        insert testLead;

        testLead.Friend_Id__c = null;
        update testLead;

        Test.startTest();

            try {
                ReferralManagementCallout.executeSocialAnnexCalloutsOnInsert(new List<Lead>{testLead});
            } catch(Exception e) {
                System.assert(false, 'Should not get any errors: ' + e);
            }

        Test.stopTest();

        Lead actual = [
            SELECT Friend_Id__c
            FROM Lead
            WHERE Id = :testLead.Id
        ];

        // Nathan. case 00562712_Ambassador (referrer) direct entry method
        // reusing Friend_Id__c of Lead. we need to remove entire referral management code base later
        // System.assertEquals(ReferralManagementCalloutTest.MOCK_FRIENDID, actual.Friend_Id__c, 'The friend Id should be set correctly');
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
                responseWrapper.FriendId = MOCK_FRIENDID;
                responseWrapper.Notes = MOCK_NOTES;
                response.sObjects.add(responseWrapper);
            }

            return response;
        }

        public override Boolean updateStage(UpdateStageRequestContainer request) {
            numberOfUpdateStageCallouts++;
            return true;
        }

        public override GetUsersResponseContainer getUsers(GetUsersRequestContainer request){
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
            responseContainer.message = 'message';
            responseContainer.opportunities.add(responseWrapper);

            return responseContainer;

        }
    }
}