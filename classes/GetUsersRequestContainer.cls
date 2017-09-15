public with sharing class GetUsersRequestContainer {

    public String SiteID;
    public List<RequestWrapper> opportunities;

    public GetUsersRequestContainer(String requestType, String firstName, String lastName, String email, string friendId)
        {
            opportunities = new List<RequestWrapper>();
            RequestWrapper reqWrapper = new RequestWrapper();

            if(requestType == ReferralManagementCallout.FRIEND_TYPE) {
                reqWrapper.Friend_first_name = sanitizeString(firstName);
                reqWrapper.Friend_last_name = sanitizeString(lastName);
                reqWrapper.Friend_email = sanitizeString(email);
                //reqWrapper.FriendId = sanitizeString(friendId);
            } else if (requestType == ReferralManagementCallout.SHARER_TYPE) {
                reqWrapper.Sharer_first_name = sanitizeString(firstName);
                reqWrapper.Sharer_last_name = sanitizeString(lastName);
                reqWrapper.Sharer_email = sanitizeString(email);
            }
            opportunities.add(reqWrapper);
        }

        private String sanitizeString(String s) {
            if(String.isBlank(s)) { return ''; }
            return String.escapeSingleQuotes(s.trim());
        }

        public String getJSONString()
        {
            return JSON.serialize(this);
        }

        public static GetUsersRequestContainer convertToContainer(String jsonString) {
            return (GetUsersRequestContainer)JSON.deserialize(jsonString, GetUsersRequestContainer.class);
        }

        public class RequestWrapper {
            public String SharerID;
            public String Sharer_email;
            public String Sharer_first_name;
            public String Sharer_last_name;

            public String FriendID;
            public String Friend_email;
            public String Friend_first_name;
            public String Friend_last_name;

            public Date ReferralDate;
            public String Status;
        }
}