public with sharing class ReferralManagementCallout {
    final static String LEAD_PREFIX = Lead.sObjectType.getDescribe().getKeyPrefix();
    final static String OPPORTUNITY_PREFIX = Opportunity.sObjectType.getDescribe().getKeyPrefix();
    public final static String FRIEND_TYPE = 'friend';
    public final static String SHARER_TYPE = 'sharer';

    static Boolean afterOpportunityInsertCalled = false;
    static Boolean afterOpportunityUpdateCalled = false;
    static Boolean afterLeadInsertCalled = false;

    public static Boolean inBatchContext {
        get {
            if(inBatchContext == null) {
                inBatchContext = false;
            }

            return inBatchContext;
        }

        set;
    }

    public static void executeSocialAnnexCalloutsOnInsert(List<Opportunity> oppties) {
        if(afterOpportunityInsertCalled || inBatchContext) {
            return;
        }

        afterOpportunityInsertCalled = true;

        List<Opportunity> withFriendId = Select.Field.isIn(Opportunity.StageName, new List<String>(opportunityStages))
                                    .andx( Select.Field.notNull(Opportunity.Sharer_Id__c))
                                    .andx( Select.Field.notNull(Opportunity.Friend_Id__c))
                                    .filter(oppties);

        List<Opportunity> withOutFriendId = Select.Field.isIn(Opportunity.StageName, new List<String>(opportunityStages))
                                    .andx( Select.Field.notNull(Opportunity.Sharer_Id__c))
                                    .andx( Select.Field.isNull(Opportunity.Friend_Id__c))
                                    .filter(oppties);


        if(!withFriendId.isEmpty()) {
            invokeUpdateStageCalloutFuture(JSON.serialize(withFriendId));
        }
        if(!withOutFriendId.isEmpty()) {
            invokeAddFriendCalloutFuture(JSON.serialize(withOutFriendId));
        }
    }

    public static Boolean executeSocialAnnexCalloutsOnInsertBatch(List<Opportunity> oppties) {
        List<Opportunity> withFriendId = Select.Field.isIn(Opportunity.StageName, new List<String>(opportunityStages))
                                    .andx( Select.Field.notNull(Opportunity.Sharer_Id__c))
                                    .andx( Select.Field.notNull(Opportunity.Friend_Id__c))
                                    .filter(oppties);

        List<Opportunity> withOutFriendId = Select.Field.isIn(Opportunity.StageName, new List<String>(opportunityStages))
                                    .andx( Select.Field.notNull(Opportunity.Sharer_Id__c))
                                    .andx( Select.Field.isNull(Opportunity.Friend_Id__c))
                                    .filter(oppties);

        Boolean successful = true;

        if(!withFriendId.isEmpty()) {
System.Debug('ReferralManagementCalloutOnInsertBatchWithFriendID: ' + withFriendId);
            successful = invokeUpdateStageCallout(withFriendId);
        }
        if(!withOutFriendId.isEmpty()) {
System.Debug('ReferralManagementCalloutOnInsertBatchWithoutFriendID: ' + withOutFriendId);
            invokeAddFriendCallout(withOutFriendId);
        }

        return successful;
    }

    public static void executeSocialAnnexCalloutsOnUpdate(List<Opportunity> newOppties, Map<Id, Opportunity> oldOpptiesMap) {
        if(afterOpportunityUpdateCalled || inBatchContext) {
            return;
        }

        afterOpportunityUpdateCalled = true;

        List<Opportunity> opportunitiesWithUpdatedStages = Select.Field.hasChanged(Opportunity.StageName)
                                                    .andx( Select.Field.isIn(Opportunity.StageName, new List<String>(opportunityStages)))
                                                    .andx( Select.Field.notNull(Opportunity.Sharer_Id__c))
                                                    .andx( Select.Field.notNull(Opportunity.Friend_Id__c))
                                                    .filter(newOppties, oldOpptiesMap);
        if(!opportunitiesWithUpdatedStages.isEmpty()) {
System.Debug('ReferralManagementCalloutOnUpdate: ' + opportunitiesWithUpdatedStages);
            invokeUpdateStageCalloutFuture(JSON.serialize(opportunitiesWithUpdatedStages));
        }
    }

    public static void executeSocialAnnexCalloutsOnInsert(List<Lead> leads) {
        if(afterLeadInsertCalled || inBatchContext) {
            return;
        }

        afterLeadInsertCalled = true;

        List<Lead> withSharerId = Select.Field.isIn(Lead.Status, new List<String>(leadStatuses))
                                        .andx( Select.Field.notNull(Lead.Sharer_Id__c))
                                        .filter(leads);


        if(!withSharerId.isEmpty()){
            invokeAddFriendCalloutFuture(JSON.serialize(withSharerId));
        }
    }

    @TestVisible private static SocialAnnex socialAnnexInstance {
        get {
            if(socialAnnexInstance == null) {
                ReferralManagementEndpoint__c socialAnnexSettings = ReferralManagementEndpoint__c.getInstance();
                socialAnnexInstance = new SocialAnnex.SocialAnnexReal(socialAnnexSettings);
            }

            return socialAnnexInstance;
        }
        set;
    }

    public static Set<String> opportunityStages {
        get {
            if(opportunityStages == null) {
                opportunityStages = Pluck.strings('Name', Referral_Management_Opportunity_Stages__c.getAll().values());
            }
            return opportunityStages;
        }
        private set;
    }

    public static Set<String> leadStatuses {
        get {
            if(leadStatuses == null) {
                leadStatuses = Pluck.strings('Name', Referral_Management_Lead_Status__c.getAll().values());
            }
            return leadStatuses;
        }
        private set;
    }

    @future(callout=true)
    public static void invokeAddFriendCalloutFuture(String sObjectsJson)
    {
        List<SObject> objs = (List<SObject>)JSON.deserialize(sObjectsJson, List<SObject>.class);
        invokeAddFriendCallout(objs);
    }

    public static void invokeAddFriendCallout(List<Sobject> objs)
    {
        performAddFriendCallout(new AddFriendRequestContainer(objs));
    }

    public static void performAddFriendCallout(AddFriendRequestContainer requestContainer)
    {
        AddFriendResponseContainer responseContainer = socialAnnexInstance.addFriend(requestContainer);
        List<sObject> objsToUpdate = new List<sObject>();

        for(AddFriendResponseContainer.ResponseWrapper responseWrapper : responseContainer.sObjects)
        {
            if(responseWrapper.salesforceId.startsWith(LEAD_PREFIX)){
                // Nathan. case 00562712_Ambassador (referrer) direct entry method
                // reusing Friend_Id__c of Lead. we need to remove entire referral management code base later
                // objsToUpdate.add(new Lead(Id = responseWrapper.salesforceId, Friend_Id__c = responseWrapper.FriendId, Lead_Qualification_Notes__c = responseWrapper.Notes));
            }else if (responseWrapper.salesforceId.startsWith(OPPORTUNITY_PREFIX)) {
                objsToUpdate.add(new Opportunity(Id = responseWrapper.salesforceId, Friend_Id__c = responseWrapper.FriendId, Lead_Qualification_Notes__c = responseWrapper.Notes));
            }
        }

        try{
            update objsToUpdate;
        }
        catch (DMLException e){
            ExLog.log(e);
        }
    }

    @future(callout=true)
    public static void invokeUpdateStageCalloutFuture(String sObjectsJson)
    {
        List<SObject> objs = (List<SObject>)JSON.deserialize(sObjectsJson, List<SObject>.class);
        invokeUpdateStageCallout(objs);
    }

    public static Boolean invokeUpdateStageCallout(List<Sobject> objs)
    {
        return performUpdateStageCallout(new UpdateStageRequestContainer(objs));
    }

    public static Boolean performUpdateStageCallout(UpdateStageRequestContainer requestContainer)
    {
        return socialAnnexInstance.updateStage(requestContainer);
    }
}