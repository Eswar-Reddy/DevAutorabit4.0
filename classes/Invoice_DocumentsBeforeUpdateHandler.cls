public without sharing class Invoice_DocumentsBeforeUpdateHandler extends TriggerHandlerBase {

    public Invoice_DocumentsBeforeUpdateHandler() {}
    
    private List<Invoice_Documents__c> newList;
    private List<Invoice_Documents__c> oldList;
    private Map<ID, Invoice_Documents__c> newMap;
    private Map<ID, Invoice_Documents__c> oldMap;
    private Map<Integer, Invoice_Documents__c> statusQualifyMap = new Map<Integer, Invoice_Documents__c>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Invoice_Documents__c>)newList;
        this.oldList = (List<Invoice_Documents__c>)oldList;
        this.newMap = (Map<ID, Invoice_Documents__c>)newMap;
        this.oldMap = (Map<ID, Invoice_Documents__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Invoice_Documents__c newRec = this.newList[i];
            Invoice_Documents__c oldRec = this.oldMap.get(newRec.Id);
            if (newRec.Status__c != oldRec.Status__c) {
                statusQualifyMap.put(i, this.newList[i]);
            }          
        }
    }
    
    public override void start() {
        if (statusQualifyMap.size() > 0) {
            InvoiceDocumentsApprovalUtil.setRequiredDocumentsApprovedFlag(statusQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}