trigger StandardLineItemTrigger on StandardLineItem__c (before insert, before update, before delete) {
	Diagnostics.push('Standard Line Item trigger fired');

    TriggerDispatcher.execute(StandardLineItem__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);

    Diagnostics.pop();
}