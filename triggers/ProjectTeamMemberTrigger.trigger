/************************************************************************************************
Created By: Sita Reeves Redpoint - Residential Installation Project
Created On: 5/31/16
************************************************************************************************/
trigger ProjectTeamMemberTrigger on Project_Team_Member__c (after update, after insert) {

	Diagnostics.push('Project Team Member trigger fired');
    
    TriggerDispatcher.execute(Project_Team_Member__c.sObjectType, Trigger.new, Trigger.old,Trigger.newMap, Trigger.oldMap);
  
  	Diagnostics.pop();
}