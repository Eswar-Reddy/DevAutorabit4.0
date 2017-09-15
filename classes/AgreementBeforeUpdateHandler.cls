public class AgreementBeforeUpdateHandler extends TriggerHandlerBase {
    // -------- Constants --------
    Id draftRecTypeId = AgreementUtility.draftRecTypeId;
    Id leaseRecTypeId = AgreementUtility.leaseRecTypeId;

    // -------- Constructor --------
    public AgreementBeforeUpdateHandler() { }

    // -------- Variables --------

    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, echosign_dev1__SIGN_Agreement__c> qualifiedAgreements;

    //---------Sets for queries----

    //Begin evaluation
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Diagnostics.push('AgreementAfterInsert qualifyStartingRecords');

        Map<ID, echosign_dev1__SIGN_Agreement__c> newAgreementMap = (Map<ID, echosign_dev1__SIGN_Agreement__c>)newMap;
        Map<ID, echosign_dev1__SIGN_Agreement__c> oldAgreementMap = (Map<ID, echosign_dev1__SIGN_Agreement__c>)oldMap;

        qualifiedAgreements = new Map<Id, echosign_dev1__SIGN_Agreement__c>();

        for(Id i : newAgreementMap.keySet()) {
            echosign_dev1__SIGN_Agreement__c agg = newAgreementMap.get(i);
            echosign_dev1__SIGN_Agreement__c oldAgg = oldAgreementMap.get(i);

            if(agg.echosign_dev1__Status__c == 'Signed' && oldAgg.echosign_dev1__Status__c != agg.echosign_dev1__Status__c) {
                calculateStatusSLA(agg);
            }

            if(agg.RecordTypeId != oldAgg.RecordTypeId) {
                if(agg.RecordTypeId == draftRecTypeId)
                	AgreementUtility.setMessageFields(agg, 'Draft');
                if(agg.RecordTypeId == leaseRecTypeId)
                    AgreementUtility.setMessageFields(agg, 'Lease');
            }
        }
    }

    public override void start() {
        //begin processing qualified records
        for(Id i : qualifiedAgreements.keySet()) {
            echosign_dev1__SIGN_Agreement__c agg = qualifiedAgreements.get(i);
        }
    }

    //perform DML as necessary
    public override void finish(Boolean fromStart) {
        if(fromStart) {}
        Diagnostics.pop();
    }

    //inner methods
    private static void calculateStatusSLA(echosign_dev1__SIGN_Agreement__c agg) {
        if(agg.Days_Unsigned_No_Weekend_Estimate__c != null) {
            if(agg.Days_Unsigned_No_Weekend_Estimate__c <= 5)
                agg.Signed_Within_5_Days__c = 'Yes';
            else if(agg.Days_Unsigned_No_Weekend_Estimate__c > 5)
                agg.Signed_Within_5_Days__c = 'No';
        }
    }
}