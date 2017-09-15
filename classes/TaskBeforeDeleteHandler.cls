public class TaskBeforeDeleteHandler extends TriggerHandlerBase {

    public TaskBeforeDeleteHandler() {}
    
    private List<Task> newList;
    private List<Task> oldList;
    private Map<ID, Task> newMap;
    private Map<ID, Task> oldMap;
    private Map<Integer, Task> spvtQualifyMap = new Map<Integer, Task>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Task>)newList;
        this.oldList = (List<Task>)oldList;
        this.newMap = (Map<ID, Task>)newMap;
        this.oldMap = (Map<ID, Task>)oldMap;
        
        List <RecordType> rtList = [SELECT Id FROM RecordType 
            WHERE SObjectType = 'Task' AND DeveloperName = 'SPVT_Notification_Task' LIMIT 1];      
        String rtId;
        if (rtList.size() > 0) {
            rtId = rtList[0].Id;
        }
        
        List <User> uList = [SELECT Id, Profile.Name FROM User WHERE Id = :UserInfo.getUserId()];
        if (uList.size() == 0 || (uList.size() > 0 && uList[0].Profile.Name != 'System Administrator')) {
            for (Integer i=0; i<this.oldList.size(); i++) {
                Task oldRec = this.oldList[i];
                if (oldRec.RecordTypeId != null && oldRec.RecordTypeId == rtId) {
                    if (oldRec.Private__c == true) {
                        spvtQualifyMap.put(i, this.oldList[i]);
                    }
                }
            }
        }
    }
    
    public override void start() {
        for (Task t : spvtQualifyMap.values()) {
            t.addError('This is auto created SPVT task. You cannot delete it. Please contact System Administrator to delete it.');        
        }
    }
    
    public override void finish(Boolean fromStart) {}

}