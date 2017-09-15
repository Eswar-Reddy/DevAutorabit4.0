trigger LeasePaymentTrigger on LeasePayment__c(before insert, before update, after insert, after update) {
    if(Util.isSkipTrigger('LeasePayment__c', null) || util.gethealthyTestSwitch()) return;
    TriggerDispatcher.execute(LeasePayment__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
}