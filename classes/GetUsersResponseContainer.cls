public with sharing class GetUsersResponseContainer {
    public String message;
    public List<ResponseWrapper> opportunities;

    public GetUsersResponseContainer() {
        opportunities = new List<ResponseWrapper>();
    }

    public static GetUsersResponseContainer convertToContainer(String jsonString) {
        return (GetUsersResponseContainer)JSON.deserialize(jsonString.stripHtmlTags(), GetUsersResponseContainer.class);
    }

    public class ResponseWrapper {
        public String SharerId {get; set;}
        public String FriendId {get; set;}
        public String ReferralDate {get; set;}
        public String Status {get; set;}
        public String Sharer_email {get; set;}
        public String Friend_email {get; set;}
        public String Sharer_first_name {get; set;}
        public String Sharer_last_name {get; set;}
        public String Friend_first_name {get; set;}
        public String Friend_last_name {get; set;}
    }
}