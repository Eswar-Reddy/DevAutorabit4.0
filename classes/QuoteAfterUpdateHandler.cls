public without sharing class QuoteAfterUpdateHandler extends TriggerHandlerBase {

    public QuoteAfterUpdateHandler() {}

    private Map<ID, Quote> oldMap;
    private Map<ID, Quote> newMap;
    private List<Quote> newList;
    private List<Quote> oldList;
    private Map<Integer, Quote> qualifyOriginalLeaseNumberMap = new Map<Integer, Quote>();
    private List<Id> lstQIds = new List<Id>();
    private List<Quote> lstQuoteToUpdateOppStage = new List<Quote> ();
    private List<Quote> LeaseDocQuoteSummmary = new List<Quote>();
    private list<Id> isSummaryLocked = new List<id>();
    private list<Id> poQuoteIds = new list<Id>();
     private Map<Id,Id> amendedQuotemap = new Map<Id,Id>(); 

    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        this.newMap = (Map<ID, Quote>)newMap;
        this.oldMap = (Map<ID, Quote>)oldMap;
        this.newList = (List<Quote>)newList;
        this.oldList = (List<Quote>)oldList;

        for (Integer i=0; i<this.newList.size(); i++) {
            Id recId = this.newList[i].Id;
            Quote newRec = this.newMap.get(recId);
            Quote oldRec = this.oldMap.get(recId);
            if (newRec.Original_Lease_Number__c != oldRec.Original_Lease_Number__c) {
                qualifyOriginalLeaseNumberMap.put(i, newRec);
            }
        }
        // collect Only Valid Quotes to Create PO and filtering the records
        if(Label.CreatePOSwitch == 'ON'){
            for(Quote qt: this.newList){
                Quote oldRec = this.oldMap.get(qt.Id);
                if((qt.QuoteType__c == 'Loan' || qt.QuoteType__c == 'Lease' || qt.QuoteType__c == 'Cash') && qt.Is_Locked__c && ((qt.Lease_Doc_Signed__c && qt.Lease_Doc_Signed__c != oldRec.Lease_Doc_Signed__c && qt.Installation_Model__c != null) || (qt.Lease_Doc_Signed__c && qt.Installation_Model__c != null && oldRec.Installation_Model__c == null))){
                    lstQIds.add(qt.Id);
                }
            }
        }
        // check quote id's to filter out non economic amendements
        Id amendId = AgreementUtility.amendmentRecTypeId;
        for(echosign_dev1__SIGN_Agreement__c ag : [SELECT Quote__c, RecordTypeId, Change_Order_Type__c FROM echosign_dev1__SIGN_Agreement__c WHERE Quote__c IN :lstQIds]) {
            if(ag.RecordTypeId != amendId || ag.RecordTypeId == amendId && ag.Change_Order_Type__c == 'Economic Amendment') {
                poQuoteIds.add(ag.Quote__c);
            }
        }
        // filtering the Quote to Update opp Stage, Business unit and RLC.
        for(Quote qtnew : this.newList){
            for(Quote qtold : this.oldList){
                if(qtnew.Id == qtold.Id && qtnew.Lease_Doc_Signed__c == TRUE && qtnew.Lease_Doc_Signed__c != qtold.Lease_Doc_Signed__c) {
                    lstQuoteToUpdateOppStage.add(qtnew);
                }
            }
        }
        // filtering records to udpate AmendmentType and Update Lease doc
        for(Quote Q : this.newList){
            Quote oldRec = this.oldMap.get(Q.Id);
            if(Q.Lease_Doc_Signed__c != oldRec.Lease_Doc_Signed__c){
                LeaseDocQuoteSummmary.add(Q);
                break;
            }
        }
        // filtering records to Update Lease doc
        for(Quote q: this.newList) {
            Quote oldRec = this.oldMap.get(Q.Id);
            if((this.oldMap == null && q.Is_Locked__c) ||  (this.oldMap != null && oldRec.Is_Locked__c != true && q.Is_Locked__c)) {
                isSummaryLocked.add(q.Quote_Summary__c);
            }   
        }
       // filtering the amendment quote records for reassigning downstream objects
       for(Quote q : this.newList){
            if(q.Amendment_Doc_Signed__c && this.oldMap.get(Q.Id).Amendment_Doc_Signed__c <> true && q.Amended_Lease__c <> null){
                  amendedQuotemap.put(q.amended_lease__c,q.id);
            }
        } 
     }

    public override void start() {
        if (qualifyOriginalLeaseNumberMap.size() > 0) {
            CaseLeasePayment.updateCase(qualifyOriginalLeaseNumberMap);
        }
        // function to update Opp Stage,Business & RLC
        QuoteTriggerUtility.updateOppStage(lstQuoteToUpdateOppStage);

        // function from Quote management to send Email to SalesAnalyst.
        QuoteManagement.SendApprovalEmailtoSalesAnalyst(newList,OldList);

        // function to Create the Purchase order
        if(!poQuoteIds.isEmpty()){
            QuoteTriggerUtility.CreatePurchaseOrderandPurchaseOrderLine(poQuoteIds);
        }
        if(isSummaryLocked.size() > 0){
            QuoteTriggerUtility.QuoteSummaryIsLocked(isSummaryLocked);
        }
        if(LeaseDocQuoteSummmary.size() > 0){
            QuoteTriggerUtility.updateLeaseDoc(LeaseDocQuoteSummmary);
        }
        if(!amendedQuotemap.isEmpty())
            QuoteTriggerUtility.reassignDownStreamObject(amendedQuotemap); 
    }

    public override void finish(Boolean fromStart) {}

}