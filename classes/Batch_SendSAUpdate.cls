global class Batch_SendSAUpdate implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {
    Set<Id> opportunityIds;

    global Batch_SendSAUpdate(Set<Id> ids) {
        opportunityIds = ids;
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        ReferralManagementCallout.inBatchContext = true;

        return Database.getQueryLocator(''
            + ' SELECT ' + String.join(SobjectService.getAllFields(Opportunity.SobjectType), ', ')
            + ' FROM Opportunity'
            + ' WHERE Send_Social_Annex_Update__c = true'
            + ' AND Id IN :opportunityIds'
        );
    }

    global void execute(Database.BatchableContext context, List<Opportunity> opportunities) {
        // send sa callout to update status
        Boolean successful = ReferralManagementCallout.executeSocialAnnexCalloutsOnInsertBatch(opportunities);

        // if callout is successful
        if(successful) {
            // uncheck the opportunity checkboxes
            List<Opportunity> toUpdate = new List<Opportunity>();
            for(Opportunity opportunity : opportunities) {
            	System.Debug('SendSAUpdate opportunity name:' + opportunity.Name);
            	System.Debug('SendSAUpdate opportunity id:' + opportunity.Id);
                toUpdate.add(new Opportunity
                    ( Id = opportunity.Id
                    , Send_Social_Annex_Update__c = false
                    ));
            }

            try {
                update toUpdate;
            } catch(DMLException e) {
                ExLog.log(e);
                throw e;
            }
        }
    }

    global void finish(Database.BatchableContext context) {
    }
}