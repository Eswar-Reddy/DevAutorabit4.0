trigger InvoiceDocuments on Invoice_Documents__c (before insert, before update) {
    if(Util.isSkipTrigger('Invoice_Documents__c', null) || util.gethealthyTestSwitch()) return;
    TriggerDispatcher.execute(Invoice_Documents__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
}