trigger ResidentialProjectTrigger on Residential_Project__c ( before update, before insert, after insert, after update,before delete) {
	Diagnostics.push('Residential Project trigger fired');
    
    TriggerDispatcher.execute(Residential_Project__c.sObjectType, Trigger.new, Trigger.old,Trigger.newMap, Trigger.oldMap);
  
  	Diagnostics.pop();
}