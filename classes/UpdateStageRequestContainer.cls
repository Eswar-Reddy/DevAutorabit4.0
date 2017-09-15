public class UpdateStageRequestContainer {

    public String SiteID;
    public String token;
    public List<RequestWrapper> opportunities;

    public UpdateStageRequestContainer(List<Sobject> objects)
    {
        opportunities = new List<RequestWrapper>();

        for(Sobject sObj : objects)
        {
            opportunities.add(new RequestWrapper(sObj));
        }
    }

    public String getJSONString()
    {
        return JSON.serialize(this);
    }

    public class RequestWrapper {

        public String salesforceId;
        public String SharerID;
        public String FriendID;
        public String DealerID;
        public String stat_id;
        public String status;

        public RequestWrapper(Sobject obj)
        {
            if(obj instanceof Lead){
                salesforceId = (String)obj.Id;
                sharerId = (String)obj.get(Lead.Sharer_Id__c);
                friendId = (String)obj.get(Lead.Friend_Id__c);
                DealerID = String.isBlank((String)obj.get(Lead.Dealer_Name__c)) ? 'DUMMY' : (String)obj.get(Lead.Dealer_Name__c);
                stat_id = (String)obj.get(Lead.stat_id__c);
                status = (String)obj.get(Lead.Status);
            } else if(obj instanceof Opportunity) {
                salesforceId = (String)obj.Id;
                sharerId = (String)obj.get(Opportunity.Sharer_Id__c);
                friendId = (String)obj.get(Opportunity.Friend_Id__c);
                DealerID = String.isBlank((String)obj.get(Opportunity.Dealer_Selection__c)) ? 'DUMMY' : (String)obj.get(Opportunity.Dealer_Selection__c);
                stat_id = (String)obj.get(Opportunity.stat_id__c);
                status = (String)obj.get(Opportunity.StageName);
            }
        }
    }
}