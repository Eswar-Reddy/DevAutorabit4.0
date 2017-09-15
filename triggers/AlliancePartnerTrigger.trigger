/************************************************************************************************
Created By: Sita Reeves - Residential Installation Project
Created On: 9/2/16

************************************************************************************************/
trigger AlliancePartnerTrigger on Alliance_Partner__c (before insert,after insert, after update, after delete) {
	if(Util.isSkipTrigger('Alliance_Partner__c', null) || util.gethealthyTestSwitch()) return;
    Diagnostics.push('Alliance Partner trigger fired');
        TriggerDispatcher.execute(Alliance_Partner__c.sObjectType, Trigger.new, Trigger.old,Trigger.newMap, Trigger.oldMap);
    Diagnostics.pop();

}