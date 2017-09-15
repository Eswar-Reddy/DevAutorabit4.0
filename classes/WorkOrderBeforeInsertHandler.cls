public without sharing class WorkOrderBeforeInsertHandler extends TriggerHandlerBase {

    public WorkOrderBeforeInsertHandler() {}
    
    private List<WorkOrder> newList;
    private List<WorkOrder> oldList;
    private Map<ID, WorkOrder> newMap;
    private Map<ID, WorkOrder> oldMap;
    private Map<Integer, WorkOrder> closedQualifyMap = new Map<Integer, WorkOrder>();
    private Map<Integer, WorkOrder> actionCompletedQualifyMap = new Map<Integer, WorkOrder>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<WorkOrder>)newList;
        this.oldList = (List<WorkOrder>)oldList;
        this.newMap = (Map<ID, WorkOrder>)newMap;
        this.oldMap = (Map<ID, WorkOrder>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            WorkOrder newRec = this.newList[i];
            if (String.IsNotBlank(newRec.Status)) {
                if (newRec.Status.startsWithIgnoreCase('Closed')) {
                    if (newRec.Completed_Date__c == null) {
                        closedQualifyMap.put(i, this.newList[i]);
                    }
                } else if (newRec.Status.equalsIgnoreCase('Action Completed')) {
                    actionCompletedQualifyMap.put(i, this.newList[i]);
                }
            }          
                
        }
        
    }
    
    public override void start() {
        if (closedQualifyMap.size() > 0) {
            ServiceRequestUtil.setCompletedDate(closedQualifyMap);
        }
        if (actionCompletedQualifyMap.size() > 0) {
            ServiceRequestUtil.setDateActionCompleted(actionCompletedQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}