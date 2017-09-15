trigger CreditCheckApplicationTrigger on Credit_Check_Request__c (before insert, after insert,after update) {


    if(Util.isSkipTrigger('CreditCheckApplicationTrigger',null)|| util.gethealthyTestSwitch())
        return;
    
    if(Trigger.isUpdate && Trigger.isAfter){
    	for(Credit_Check_Request__c cca : Trigger.new){
    		if((cca.Email_Counter__c != Trigger.oldMap.get(cca.id).Email_Counter__c) && cca.Email_Counter__c != 0){
    			CreditAppAfterUpdateHandler.callLoanPath(cca.id);
    		}	
    	}
    }
    else{
    TriggerDispatcher.execute(Credit_Check_Request__c.sObjectType, Trigger.new, Trigger.old, 
        Trigger.newMap, Trigger.oldMap);
	}
}