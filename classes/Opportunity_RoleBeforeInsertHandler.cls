public with sharing class Opportunity_RoleBeforeInsertHandler extends TriggerHandlerBase {

  	// -------- Constants --------
  
    
    // -------- Constructor --------
  	public Opportunity_RoleBeforeInsertHandler() {}

  	// -------- Variables --------
  	Map<Id, Opportunity> oppDataMap;
    
    
    
    // -------- Properties --------
    // Qualified records for actions
    private Map<Integer, Opportunity_Role__c> qualifiedRoles;


    //---------Sets for queries---- 
    Set<Id> oppIds;


    //DML Collections




    //Begin Evaluation
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
        Map<ID, Opportunity_Role__c> oldRoleMap = (Map<ID, Opportunity_Role__c>)oldMap;
        List<Opportunity_Role__c> newRoleList = (List<Opportunity_Role__c>)newList;
        List<Opportunity_Role__c> oldRoleList = (List<Opportunity_Role__c>)oldList;
        qualifiedRoles = new Map<Integer, Opportunity_Role__c>(); 

        //collections
        oppIds = new Set<Id>();

        System.debug('qualification beforeInsert for ' + newRoleList.size() + ' records');
        //begin qualification
        for(Integer i = 0; i < newRoleList.size(); i++) {
          	Opportunity_Role__c oppRole = newRoleList.get(i);
        	if(String.isNotBlank(oppRole.Opp_Name__c) ) {
        		oppIds.add(oppRole.Opp_Name__c);
        		qualifiedRoles.put(i, oppRole);
        	} 
        }
        
  	}


  	public override void start() {

	    System.debug('Start processing for ' + qualifiedRoles.size() + ' records');
	    //queries, etc.
	    oppDataMap = new Map<Id, Opportunity>();


	    if(qualifiedRoles == null || qualifiedRoles.isEmpty()) return;

	    if(oppIds != null && !oppIds.isEmpty()) {
	    	for(Opportunity o : [SELECT Id, AccountId FROM Opportunity WHERE Id IN: oppIds]) {
	    		oppDataMap.put(o.Id, o);
	    	}
	    }

	  	for(Integer i = 0; i < qualifiedRoles.size(); i++) {
	      	Opportunity_Role__c oppRole = qualifiedRoles.get(i);

	    	if(String.isNotBlank(oppRole.Opp_Name__c) && !oppDataMap.isEmpty() && oppDataMap.containsKey(oppRole.Opp_Name__c)) {
	    		oppRole.Account__c = oppDataMap.get(oppRole.Opp_Name__c).AccountId;
	    	}  
	    }

  	}


  	public override void finish(Boolean fromStart) {

	    if(fromStart) {

	        
	    }
  	}
}