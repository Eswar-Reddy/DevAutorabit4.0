trigger skedJobTrigger on sked__Job__c (before insert, after insert, after update) {

    if (Trigger.isBefore) {
        skedJobHandler.beforeInsert(Trigger.new);
    }
    else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            skedJobHandler.afterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate) {
     		skedJobHandler.afterUpdate(Trigger.new, Trigger.oldMap);       
        }
    }
    
}