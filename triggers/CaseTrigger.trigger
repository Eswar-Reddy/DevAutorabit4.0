trigger CaseTrigger on Case (before insert, before update, after insert) {
    if(Util.isSkipTrigger('Case', null) || util.gethealthyTestSwitch()) return;
    TriggerDispatcher.execute(Case.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
}