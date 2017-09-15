public without sharing class CaseBeforeUpdateHandler extends TriggerHandlerBase {

    public CaseBeforeUpdateHandler() {}
    
    private List<Case> newList;
    private List<Case> oldList;
    private Map<ID, Case> newMap;
    private Map<ID, Case> oldMap;
    private Map<Integer, Case> emailRollupQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> accountChangeQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> leasePaymentChangeQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> leaseNumberChangeQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> opportunityChangeQualifyMap = new Map<Integer, Case>();
    private Map<Integer, Case> commercialProjectChangeQualifyMap = new Map<Integer, Case>();

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newList = (List<Case>)newList;
        this.oldList = (List<Case>)oldList;
        this.newMap = (Map<ID, Case>)newMap;
        this.oldMap = (Map<ID, Case>)oldMap;
        
        for (Integer i=0; i<this.newList.size(); i++) {
            String caseId = this.newList[i].Id;
            Case newCase = this.newList[i];
            Case oldCase;
            if (this.oldMap != null && this.oldMap.containsKey(caseId)) {
                oldCase = this.oldMap.get(caseId);
            }
            if (oldCase != null) {
                // exclude spvt cases. lease payment is set in SPVT Fail Lease Payment Flow 
                if (newCase.SPVT_Case__c != true) {
                    // when account is changed, automatically pull lease payment of that account
                    // if account remains same allow user to select a lease payment and update lease number
                    if (oldCase.AccountId != newCase.AccountId) {
                        accountChangeQualifyMap.put(i, newCase);
                    } else if (oldCase.Lease_Payment__c != newCase.Lease_Payment__c) {
                        leasePaymentChangeQualifyMap.put(i, newCase);
                    } else if (oldCase.Lease__c != newCase.Lease__c) {
                        leaseNumberChangeQualifyMap.put(i, newCase);
                    }
                }
                if (oldCase.Opportunity__c != newCase.Opportunity__c) {
                    opportunityChangeQualifyMap.put(i, newCase);
                } else if (oldCase.Commercial_Project_num__c != newCase.Commercial_Project_num__c) {
                    commercialProjectChangeQualifyMap.put(i, newCase);
                }
            }
            emailRollupQualifyMap.put(i, newCase);
        }
        
    }
    
    public override void start() {
        if (accountChangeQualifyMap.size() > 0) {
            CaseLeasePayment.setLeasePayment(accountChangeQualifyMap);
        }
        if (leasePaymentChangeQualifyMap.size() > 0) {
            CaseLeasePayment.setLeaseNumber(leasePaymentChangeQualifyMap);
        }
        if (leaseNumberChangeQualifyMap.size() > 0) {
            CaseLeasePayment.setLeaseNumber(leaseNumberChangeQualifyMap);
        }
        if (opportunityChangeQualifyMap.size() > 0) {
            CaseOpportunity.setCommercialProject(opportunityChangeQualifyMap);
        }
        if (commercialProjectChangeQualifyMap.size() > 0) {
            CaseOpportunity.setCommercialProject(commercialProjectChangeQualifyMap);
        }
        if (emailRollupQualifyMap.size() > 0) {
            CaseEmailRollup.rollup(emailRollupQualifyMap.values());
        } 
    }
    
    public override void finish(Boolean fromStart) {}

}