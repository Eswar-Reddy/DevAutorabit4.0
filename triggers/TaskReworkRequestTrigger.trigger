/************************************************************************************************
Created By: Sita Reeves Redpoint - Residential Installation Project
Created On: 8/11/16

************************************************************************************************/
trigger TaskReworkRequestTrigger on Task_Rework_Request__c (after insert, after update) {

	Diagnostics.push('Task Rework Request trigger fired');
    	TriggerDispatcher.execute(Task_Rework_Request__c.sObjectType, Trigger.new, Trigger.old,Trigger.newMap, Trigger.oldMap);
    Diagnostics.pop();

}