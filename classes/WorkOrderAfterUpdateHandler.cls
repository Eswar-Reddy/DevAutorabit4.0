public without sharing class WorkOrderAfterUpdateHandler extends TriggerHandlerBase {

    public WorkOrderAfterUpdateHandler() {}
    
    private List<WorkOrder> newList;
    private List<WorkOrder> oldList;
    private Map<ID, WorkOrder> newMap;
    private Map<ID, WorkOrder> oldMap;
    private Map<Integer, WorkOrder> qualifyMapSRClose = new Map<Integer, WorkOrder>();
    private Map<Integer, WorkOrder> qualifyMapSROwnerChange = new Map<Integer, WorkOrder>();
    private Map<Integer, WorkOrder> qualifyEmailNotification = new Map<Integer, WorkOrder>();
    
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<WorkOrder>)newList;
        this.oldList = (List<WorkOrder>)oldList;
        this.newMap = (Map<ID, WorkOrder>)newMap;
        this.oldMap = (Map<ID, WorkOrder>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            WorkOrder newRec = this.newList[i];
            if (newRec.Id != null && this.oldMap != null && this.oldMap.containsKey(newRec.Id)) {
                WorkOrder oldRec = this.oldMap.get(newRec.Id);
                if (newRec.Status == 'Closed' && newRec.Status != oldRec.Status) {
                    qualifyMapSRClose.put(i, this.newList[i]);
                }          
                if (newRec.OwnerId != oldRec.OwnerId) {
                    qualifyMapSROwnerChange.put(i, this.newList[i]);
                    qualifyEmailNotification.put(i, this.newList[i]);
                }          
            } 
                
        }
        
    }
    
    public override void start() {
        ServiceRequestUtil.createTaskOnSRClose(qualifyMapSRClose);
        ServiceRequestTask.createTaskOnSROwnerChange(qualifyMapSROwnerChange);
        ServiceRequestCaseTeam.addToCaseTeamOnSROwnerChange(qualifyMapSROwnerChange);
        ServiceRequestEmail.sendEmail(qualifyEmailNotification);
    }
    
    public override void finish(Boolean fromStart) {}

}