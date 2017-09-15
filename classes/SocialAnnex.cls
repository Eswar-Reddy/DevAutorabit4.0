public abstract class SocialAnnex {
    public static final String UPDATE_STAGE_MESSAGE_SUCCESSFUL = 'Update Successful';

    public abstract AddFriendResponseContainer addFriend(AddFriendRequestContainer request);

    public abstract Boolean updateStage(UpdateStageRequestContainer request);

    public abstract GetUsersResponseContainer getUsers(GetUsersRequestContainer request);

    public class SocialAnnexReal extends SocialAnnex {
        final ReferralManagementEndpoint__c setting;

        public SocialAnnexReal(ReferralManagementEndpoint__c setting){
            super();
            this.setting = setting;
        }

        // This does a callout to social annex to request a friend id
        public override AddFriendResponseContainer addFriend(AddFriendRequestContainer request) {
System.Debug('Social Annex Add Friend Callout Request:' + request);
            request.siteId = setting.Site_Id__c;
            request.token = setting.Login_Token__c;

            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(setting.Add_Friend__c);
            httpRequest.setMethod('POST');
            httpRequest.setBody(request.getJSONString());

            HttpResponse response = new Http().send(httpRequest);
System.Debug('Social Annex Add Friend Callout Response:' + response.getBody());
            return AddFriendResponseContainer.convertToContainer(response.getBody());
        }

        // This does a callout to social annex to update the status in the referral management dashboard
        public override Boolean updateStage(UpdateStageRequestContainer request) {
System.Debug('Social Annex Update Stage Callout Request:' + request);
            request.siteId = setting.Site_Id__c;
            request.token = setting.Login_Token__c;

            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(setting.Update_Stage__c);
            httpRequest.setMethod('POST');
            httpRequest.setBody(request.getJSONString());

            HttpResponse response = new Http().send(httpRequest);
System.Debug('Social Annex Update Stage Callout Result:' + response.getBody());
            UpdateStageResponseContainer parsedResposne = UpdateStageResponseContainer.convert(response.getBody());
            if(parsedResposne.message != UPDATE_STAGE_MESSAGE_SUCCESSFUL) {
                ExLog.log('Got an unsuccessful response when updating stages: ' + response.getBody());

                return false;
            }

            return true;
        }

        // This does a search for sharers or friends based on first name, last name, and email
        public override GetUsersResponseContainer getUsers(GetUsersRequestContainer request){
System.Debug('Get User Response Callout Request:' + request);
            request.siteId = setting.Site_Id__c;

            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint(setting.Get_Users__c);
            httpRequest.setMethod('POST');
            httpRequest.setBody(request.getJSONString());

            HttpResponse response = new Http().send(httpRequest);
System.Debug('Get User Response Callout Result:' + response.getBody());
            return GetUsersResponseContainer.convertToContainer(response.getBody());
        }
    }
}