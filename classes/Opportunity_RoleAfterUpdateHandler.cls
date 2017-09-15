public with sharing class Opportunity_RoleAfterUpdateHandler extends TriggerHandlerBase {
    
    // -------- Constants --------
    Map<String, String> approvalStatusMap = new Map<String, String> {
        'Approved (PR1)' => 'Firm Offer Approval', 'Approved (PR2)' => 'Customer Deal Approval', 
        'Rejected (PR1)' => 'Firm Offer Approval', 'Rejected (PR2)' => 'Customer Deal Approval',
        'Rejected' => 'Standard Contract', 'Approved' => 'Standard Contract'
    };
    
    
    
    // -------- Constructor --------
    public Opportunity_RoleAfterUpdateHandler() {}

    // -------- Variables --------
    Set<Id> roleIdsForDocCreation;
    

    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, Opportunity_Role__c> qualifiedRoles;
    Map<ID, Opportunity_Role__c> newRoleMap;
    Map<Id, Opportunity_Role__c> runningTransactionMap = new Map<Id, Opportunity_Role__c>();
    Set<Id> idsForDocApprovals;
    Set<String> approvalLevels;
    Map<Id, List<UC_Document__c>> documentDataMap;//oppRoleToListDocs

    //---------Sets for queries---- 


    //DML Collections
    Map<Id, UC_Document__c> documentsToUpdate;

    //Begin Evaluation
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        newRoleMap = (Map<ID, Opportunity_Role__c>)newMap;
        Map<ID, Opportunity_Role__c> oldRoleMap = (Map<ID, Opportunity_Role__c>)oldMap;
        List<Opportunity_Role__c> newRoleList = (List<Opportunity_Role__c>)newList;
        List<Opportunity_Role__c> oldRoleList = (List<Opportunity_Role__c>)oldList;
        qualifiedRoles = new Map<Id, Opportunity_Role__c>(); 

        //collections
        roleIdsForDocCreation = new Set<Id>(); //#120127355
        idsForDocApprovals = new Set<Id>();
        approvalLevels = new Set<String>();


        System.debug('Begin qualification for ' + newRoleMap.size() + ' after update');
        //begin qualification
        for(Id i : newRoleMap.keySet()) {
            Opportunity_Role__c oppRole = newRoleMap.get(i);
            Opportunity_Role__c oldOppRole = oldRoleMap.get(i);

            System.debug('Status: ' + oppRole.Status__c);
            System.debug('Old Status: ' + oldOppRole.Status__c);
            if(oppRole.Business_Unit__c == 'NA Commercial' && oppRole.Status__c != null && oppRole.Status__c != oldOppRole.Status__c
               && String.isNotBlank(oppRole.Contract_Type__c) && String.isNotBlank(oppRole.SPWR_Deal_Type_text__c)
               && OpportunityRolesUtility.dealTypeToContractTypeMap.containsKey(oppRole.SPWR_Deal_Type_text__c)
               && OpportunityRolesUtility.dealTypeToContractTypeMap.get(oppRole.SPWR_Deal_Type_text__c) == oppRole.Contract_Type__c) {
                   
                   if(OpportunityRolesUtility.statusToDocTypeMap.containsKey(oppRole.Status__c) && !runningTransactionMap.containsKey(oppRole.Id)) {
                       System.debug('match!');
                       runningTransactionMap.put(oppRole.Id, oppRole);
                       roleIdsForDocCreation.add(i);
                       qualifiedRoles.put(i, oppRole);
                   }
                   
                   if(approvalStatusMap.containsKey(oppRole.Status__c)) {
                       idsForDocApprovals.add(i);
                       approvalLevels.add(approvalStatusMap.get(oppRole.Status__c));
                       qualifiedRoles.put(i, oppRole);
                   }
            }

            System.debug('Contract Status: ' + oppRole.Contract_Status__c);
            System.debug('Old Contract Status: ' + oldOppRole.Contract_Status__c);
            if(oppRole.Business_Unit__c == 'NA Commercial' && String.isNotBlank(oppRole.Contract_Status__c) 
                && oppRole.Contract_Status__c != oldOppRole.Contract_Status__c
                && String.isNotBlank(oppRole.SPWR_Deal_Type_text__c) && String.isNotBlank(oppRole.Contract_Type__c) 
                && OpportunityRolesUtility.dealTypeToContractTypeMap.containsKey(oppRole.SPWR_Deal_Type_text__c)
                && OpportunityRolesUtility.dealTypeToContractTypeMap.get(oppRole.SPWR_Deal_Type_text__c) == oppRole.Contract_Type__c) {
                    if(approvalStatusMap.containsKey(oppRole.Contract_Status__c)) {
                        idsForDocApprovals.add(i);
                        approvalLevels.add(approvalStatusMap.get(oppRole.Contract_Status__c));
                        qualifiedRoles.put(i, oppRole);
                    }
            } 

        }

    }


    public override void start() {

        System.debug('Start processing for ' + qualifiedRoles.size() + ' records');

        //queries, etc.
        documentDataMap = new Map<Id, List<UC_Document__c>>();
        documentsToUpdate = new Map<Id, UC_Document__c>();
        if(idsForDocApprovals != null && !idsForDocApprovals.isEmpty()) {
            for(UC_Document__c d : [SELECT Id, Document_Status__c, Opportunity_Role__c, Document_Type__c 
                                    FROM UC_Document__c 
                                    WHERE Opportunity_Role__c IN: idsForDocApprovals
                                    AND Document_Type__c IN: approvalLevels]) {
                if(documentDataMap.containsKey(d.Opportunity_Role__c)) {
                    documentDataMap.get(d.Opportunity_Role__c).add(d);
                } else {
                    documentDataMap.put(d.Opportunity_Role__c, new List<UC_Document__c>());
                    documentDataMap.get(d.Opportunity_Role__c).add(d);
                }
            }
        }


        if(qualifiedRoles == null || qualifiedRoles.isEmpty()) return;


        for(Id i : qualifiedRoles.keySet()) {
            Opportunity_Role__c oppRole = qualifiedRoles.get(i);

            if(idsForDocApprovals.contains(i) && documentDataMap != null && !documentDataMap.isEmpty() && documentDataMap.containsKey(i)) {
                updateDocumentStatus(oppRole, documentDataMap.get(i));
            }
            
        }


        if(roleIdsForDocCreation != null && !roleIdsForDocCreation.isEmpty()) {
            OpportunityRolesUtility.processOppRoleDocumentCreation(roleIdsForDocCreation);
        }

    }


    public override void finish(Boolean fromStart) {

        if(fromStart) {

            if(documentsToUpdate != null && !documentsToUpdate.isEmpty()) {
                update documentsToUpdate.values();
            }

        }
    }


    //Private methods
    private void updateDocumentStatus(Opportunity_Role__c role, List<UC_Document__c> docList) {

        if(role == null || docList == null || docList.isEmpty()
            || (!approvalStatusMap.containsKey(role.Status__c) && !approvalStatusMap.containsKey(role.Contract_Status__c))) return;

        for(UC_Document__c d : docList) {
            if(d.Document_Type__c == approvalStatusMap.get(role.Status__c)) {
                if(role.Status__c.containsIgnoreCase('Approved')) {
                    d.Document_Status__c = 'Approved';
                    documentsToUpdate.put(d.Id, d);
                }
                else if(role.Status__c.containsIgnoreCase('Rejected')) {
                    d.Document_Status__c = 'Rejected';
                    documentsToUpdate.put(d.Id, d);
                }
            }
            else {
                if(d.Document_Type__c ==approvalStatusMap.get(role.Contract_Status__c)) {
                    if(role.Contract_Status__c.containsIgnoreCase('Approved')) {
                        d.Document_Status__c = 'Approved';
                        documentsToUpdate.put(d.Id, d);
                    }
                    else if(role.Contract_Status__c.containsIgnoreCase('Rejected')) {
                        d.Document_Status__c = 'Rejected';
                        documentsToUpdate.put(d.Id, d);
                    }
                }
            }
        }
    }

}