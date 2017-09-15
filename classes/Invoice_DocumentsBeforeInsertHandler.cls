public without sharing class Invoice_DocumentsBeforeInsertHandler extends TriggerHandlerBase {

    public Invoice_DocumentsBeforeInsertHandler() {}
    
    private List<Invoice_Documents__c> newList;
    private List<Invoice_Documents__c> oldList;
    private Map<ID, Invoice_Documents__c> newMap;
    private Map<ID, Invoice_Documents__c> oldMap;
    private Map<Integer, Invoice_Documents__c> qualifyMap = new Map<Integer, Invoice_Documents__c>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Invoice_Documents__c>)newList;
        this.oldList = (List<Invoice_Documents__c>)oldList;
        this.newMap = (Map<ID, Invoice_Documents__c>)newMap;
        this.oldMap = (Map<ID, Invoice_Documents__c>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Invoice_Documents__c newRec = this.newList[i];
            qualifyMap.put(i, newRec);
        }
        
    }
    
    public override void start() {
        if (qualifyMap.size() > 0) {
            InvoiceDocumentsApprovalUtil.setRequiredDocumentsApprovedFlag(qualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}