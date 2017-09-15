/**
 * Created by cdevarapalli on 5/11/17.
 */

@IsTest
private class GetNewHomesCommunityDetailsREST_Test {

    static testMethod void testGetNewHomesCommunityDetails() {
        test.startTest();

        NH_Community__c nhCommunity = TestFactory_ResidentialProjMgmt.createNHCommunity(null, null);
        nhCommunity.Region__c = 'Test Region';
        insert nhCommunity;

        Campaign camp = TestFactory_StandardObjects.createTestCampaign();
        camp.Name = 'Test Campaign';
        camp.NH_Community__c = nhCommunity.Id;
        insert camp;

        Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(null, null);
        opp.CampaignId = camp.Id;
        insert opp;

        GetNewHomesCommunityDetailsREST.Response getNHCDetailsResp = new GetNewHomesCommunityDetailsREST.Response();

        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.addParameter('OpportunityId',opp.Id);
        RestContext.request = req;

        getNHCDetailsResp = GetNewHomesCommunityDetailsREST.doGet();

        test.stopTest();
    }

    static testMethod void testNoOpportunity() {
        test.startTest();

        GetNewHomesCommunityDetailsREST.Response getNHCDetailsResp = new GetNewHomesCommunityDetailsREST.Response();
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.addParameter('OpportunityId',null);
        RestContext.request = req;

        getNHCDetailsResp = GetNewHomesCommunityDetailsREST.doGet();

        test.stopTest();
    }

    static testMethod void testNoCampaign() {
        test.startTest();

        Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(null, null);
        insert opp;

        GetNewHomesCommunityDetailsREST.Response getNHCDetailsResp = new GetNewHomesCommunityDetailsREST.Response();

        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.addParameter('OpportunityId',opp.Id);
        RestContext.request = req;

        getNHCDetailsResp = GetNewHomesCommunityDetailsREST.doGet();

        test.stopTest();
    }

    static testMethod void testNoNHCommunity() {
        test.startTest();

        Campaign camp = TestFactory_StandardObjects.createTestCampaign();
        camp.Name = 'Test Campaign';
        insert camp;

        Opportunity opp = TestFactory_StandardObjects.createHomeOwnerOpportunity(null, null);
        opp.CampaignId = camp.Id;
        insert opp;

        GetNewHomesCommunityDetailsREST.Response getNHCDetailsResp = new GetNewHomesCommunityDetailsREST.Response();

        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.addParameter('OpportunityId',opp.Id);
        RestContext.request = req;

        getNHCDetailsResp = GetNewHomesCommunityDetailsREST.doGet();

        test.stopTest();
    }

}