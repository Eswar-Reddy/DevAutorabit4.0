public without sharing class CaseBeforeInsertHandler extends TriggerHandlerBase {

    public CaseBeforeInsertHandler() {}
    
    private List<Case> newList;
    private List<Case> oldList;
    private Map<ID, Case> newMap;
    private Map<ID, Case> oldMap;
    private Map<Integer, Case> leasePaymentQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> leasePaymentSPVTQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> opportunityQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> dealerInstallerNotificationQualifyMap = new Map<Integer, Case>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Case>)newList;
        this.oldList = (List<Case>)oldList;
        this.newMap = (Map<ID, Case>)newMap;
        this.oldMap = (Map<ID, Case>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            Case newCase = this.newList[i];
            // exclude spvt cases. lease payment is set in SPVT Fail Lease Payment Flow 
            if (newCase.SPVT_Case__c != true) {
                leasePaymentQualifyMap.put(i, newCase);
            } else {
                leasePaymentSPVTQualifyMap.put(i, newCase);
                dealerInstallerNotificationQualifyMap.put(i, newCase);
            }
            if (newCase.Opportunity__c != null) {
                opportunityQualifyMap.put(i, newCase);
            }
        }
        
    }
    
    public override void start() {
        if (leasePaymentQualifyMap.size() > 0) {
            CaseLeasePayment.setLeasePayment(leasePaymentQualifyMap);
        }
        if (leasePaymentSPVTQualifyMap.size() > 0) {
            CaseLeasePayment.setLeaseNumberSPVT(leasePaymentSPVTQualifyMap);
        }
        if (opportunityQualifyMap.size() > 0) {
            CaseOpportunity.setCommercialProject(opportunityQualifyMap);
        }
        if (dealerInstallerNotificationQualifyMap.size() > 0) {
            SPVTCaseNotification.setDealerInstallerNotification(dealerInstallerNotificationQualifyMap);
        }
    }
    
    public override void finish(Boolean fromStart) {}

}