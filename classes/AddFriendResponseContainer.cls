public class AddFriendResponseContainer {

    public List<ResponseWrapper> sObjects;
    public String message;

    public AddFriendResponseContainer() {
        sObjects = new List<ResponseWrapper>();
    }

    public static AddFriendResponseContainer convertToContainer(String jsonString) {
        return (AddFriendResponseContainer)JSON.deserialize(jsonString, AddFriendResponseContainer.class);
    }

    public class ResponseWrapper {
        public String salesforceId;
        public String FriendId;
        public String stat_id;
        public String DealerId;
        public String Notes;
    }
}