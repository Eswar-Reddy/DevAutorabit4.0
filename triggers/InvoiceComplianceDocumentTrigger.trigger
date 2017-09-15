trigger InvoiceComplianceDocumentTrigger on Invoice_Compliance_Document__c (before insert, after insert, before update, after update,after delete) {
    
    if(Util.isSkipTrigger('InvoiceComplianceDocumentTrigger',null)|| util.gethealthyTestSwitch())
        return;
    
    TriggerDispatcher.execute(Invoice_Compliance_Document__c.sObjectType, Trigger.new, Trigger.old, 
        Trigger.newMap, Trigger.oldMap);
     

}