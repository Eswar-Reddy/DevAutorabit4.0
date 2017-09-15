trigger WorkOrder on WorkOrder (before insert, before update, after insert, after update) {
    if(Util.isSkipTrigger('WorkOrder', null) || util.gethealthyTestSwitch()) return;
    TriggerDispatcher.execute(WorkOrder.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
}