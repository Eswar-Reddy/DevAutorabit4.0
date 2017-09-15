/************************************************************************************************
Created By: Sita Reeves Redpoint - Residential Installation Project
Created On: 5/23/16

************************************************************************************************/
trigger ProjectTaskTrigger on Project_Task__c (after insert, after update, after delete, before insert, before delete, before update) {

    Diagnostics.push('Project Task trigger fired');
    	TriggerDispatcher.execute(Project_Task__c.sObjectType, Trigger.new, Trigger.old,Trigger.newMap, Trigger.oldMap);
    Diagnostics.pop();
}