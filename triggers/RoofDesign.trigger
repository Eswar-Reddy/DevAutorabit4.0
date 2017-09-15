trigger RoofDesign on Roof_Design__c (before insert, after update) {

    if(Util.isSkipTrigger('RoofDesign', null) || util.gethealthyTestSwitch()) return;
    TriggerDispatcher.execute(Roof_Design__c.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
}