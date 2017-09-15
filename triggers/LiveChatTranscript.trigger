trigger LiveChatTranscript on LiveChatTranscript (before insert, before update, after insert, after update) {
    if(Util.isSkipTrigger('LiveChatTranscript',null) || util.gethealthyTestSwitch()) return;
    TriggerDispatcher.execute(LiveChatTranscript.sObjectType, Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
}