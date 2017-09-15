public with sharing class Opportunity_RoleAfterInsertHandler extends TriggerHandlerBase {

	// -------- Constants --------
  
    
    // -------- Constructor --------
	public Opportunity_RoleAfterInsertHandler() {}

	// -------- Variables --------
    Set<Id> roleIdsForDocCreation;
    
    
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Id, Opportunity_Role__c> qualifiedRoles;
    Map<ID, Opportunity_Role__c> newRoleMap;


    //---------Sets for queries---- 



    //DML Collections




  	//Begin Evaluation
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	newRoleMap = (Map<ID, Opportunity_Role__c>)newMap;
        Map<ID, Opportunity_Role__c> oldRoleMap = (Map<ID, Opportunity_Role__c>)oldMap;
        List<Opportunity_Role__c> newRoleList = (List<Opportunity_Role__c>)newList;
        List<Opportunity_Role__c> oldRoleList = (List<Opportunity_Role__c>)oldList;
        qualifiedRoles = new Map<Id, Opportunity_Role__c>(); 

        //collections
        roleIdsForDocCreation = new Set<Id>(); //#120127355

        System.debug('qualification afterInsert for ' + newRoleMap.size() + ' records');
        //begin qualification
        for(Id i : newRoleMap.keySet()) {
        	Opportunity_Role__c oppRole = newRoleMap.get(i);
        	if(oppRole.Business_Unit__c == 'NA Commercial' && OpportunityRolesUtility.statusToDocTypeMap.containsKey(oppRole.Status__c) 
               && String.isNotBlank(oppRole.Contract_Type__c) && String.isNotBlank(oppRole.SPWR_Deal_Type_text__c)
               && OpportunityRolesUtility.dealTypeToContractTypeMap.containsKey(oppRole.SPWR_Deal_Type_text__c)
               && OpportunityRolesUtility.dealTypeToContractTypeMap.get(oppRole.SPWR_Deal_Type_text__c) == oppRole.Contract_Type__c) {
                   roleIdsForDocCreation.add(oppRole.Id);
                   qualifiedRoles.put(oppRole.Id, oppRole);
            }
        }
        
	}


	public override void start() {

		System.debug('Start processing for ' + qualifiedRoles.size() + ' records');
		//queries, etc.



		if(qualifiedRoles == null || qualifiedRoles.isEmpty()) return;

	/* - uncomment to use for single record processing in the future
		for(Id i : qualifiedRoles.keySet()) {
			Opportunity_Role__c oppRole = qualifiedRoles.get(i);

			
		}
	*/

		if(roleIdsForDocCreation != null && !roleIdsForDocCreation.isEmpty()) {
            OpportunityRolesUtility.processOppRoleDocumentCreation(roleIdsForDocCreation);
        }

	}


	public override void finish(Boolean fromStart) {

		if(fromStart) {

        
		}
	}



	



}