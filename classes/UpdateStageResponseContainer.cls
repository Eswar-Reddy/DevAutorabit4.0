public class UpdateStageResponseContainer {

    public String message;
    public String token;
    public List<OpportunityObject> opportunities;

    public class OpportunityObject {
        public String salesforceId;
        public String FriendID;
        public String SharerID;
        public String stat_id;
        public String DealerID;
        public String status;
    }

    public UpdateStageResponseContainer() {
        opportunities = new List<OpportunityObject>();
    }

    public static UpdateStageResponseContainer convert(String s) {
        return (UpdateStageResponseContainer)JSON.deserialize(s, UpdateStageResponseContainer.class);
    }
}