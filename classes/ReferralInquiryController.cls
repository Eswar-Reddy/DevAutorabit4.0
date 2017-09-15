public with sharing class ReferralInquiryController {
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public String searchType {get; set;}
    public String friendId {get; set;}
    public List<ResponseRow> responseRows {get; set;}

    @TestVisible private static SocialAnnex socialAnnexInstance {
        get {
            if(socialAnnexInstance == null) {
                ReferralManagementEndpoint__c settings = ReferralManagementEndpoint__c.getInstance();
                socialAnnexInstance = new SocialAnnex.SocialAnnexReal(settings);
            }
            return socialAnnexInstance;
        }
        set;
    }

    public ReferralInquiryController(ApexPages.StandardController stdController){
        Id opptyId = stdController.getRecord().Id;
        Opportunity opp = [SELECT Primary_Contact_Last_Name__c, Primary_Contact_First_Name__c, Primary_Contact_Email__c FROM Opportunity WHERE Id = :opptyId];
        lastName = opp.Primary_Contact_Last_Name__c;
        firstName = opp.Primary_Contact_First_Name__c;
        email = opp.Primary_Contact_Email__c;
        searchType = 'Friend';
        friendId = null;
        responseRows = new List<ResponseRow>();
    }

    public void search() {
        responseRows.clear();
        GetUsersResponseContainer response;
        try {
            response = socialAnnexInstance.getUsers(new GetUsersRequestContainer(searchType, firstName, lastName, email, friendId));
        } catch(System.JSONException e) {
            error(e.getMessage());
            return;
        }

        if(response == null) {
            error('Error parsing response');
            return;
        }

        if(response.opportunities == null) {
            error('The following message was returned from Social Annex: ' + response.message);
            return;
        }

        for(GetUsersResponseContainer.ResponseWrapper wrapper : response.opportunities) {
            if(searchType == ReferralManagementCallout.SHARER_TYPE) {
                ResponseRow row = new ResponseRow(wrapper.Friend_first_name, wrapper.Friend_last_name, wrapper.ReferralDate, wrapper.Status, wrapper.Friend_email);
                responseRows.add(row);
            } else {
                ResponseRow row = new ResponseRow(wrapper.Sharer_first_name, wrapper.Sharer_last_name, wrapper.ReferralDate, wrapper.Status, wrapper.Sharer_email);
                responseRows.add(row);
            }
        }
    }

    private void error(String msg) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }

    public class ResponseRow {
        public String firstName {get; set;}
        public String lastName {get; set;}
        public String referralDate {get; set;}
        public String status {get; set;}
        public String email {get; set;}

        public ResponseRow(String firstName, String lastName, String referralDate, String status, String email) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.referralDate = referralDate;
            this.status = status;
            this.email = email;
        }
    }
}