public without sharing class Project_Team_MemberAfterUpdateHandler extends TriggerHandlerBase{
	// -------- Constants --------

	// -------- Variables --------
	public Map<Id, Map<String, Id>> teamMemberUpdate;
	public Map<Id, Project_Task__c> tasksToUpdate;
    public List<Project_Team_Member__c> ptmToUpdate;
    public Map<Id, List<Project_Team_Member__c>> ptmMap;
    Set<Id>                         projectIds;
    
    // -------- Constructor --------
    public Project_Team_MemberAfterUpdateHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	Diagnostics.push('Project_Team_MemberAfterUpdateHandler qualifyStartingRecords');

    	List<Project_Team_Member__c> 	newRecords 		= (List<Project_Team_Member__c>)newList;
    	Map<Id, Project_Team_Member__c> oldMapRecords 	= (Map<Id, Project_Team_Member__c>)oldMap;

    	List<Project_Team_Member__c> members = [SELECT Id, User__c, Role__c, Project_Dashboard_User__c, Residential_Project__c, Residential_Project__r.Name, Residential_Project__r.Project_Number__c, Residential_Project__r.RecordType.Name FROM Project_Team_Member__c WHERE Id IN: newRecords];
        teamMemberUpdate = new Map<Id, Map<String, Id>>();
        ptmMap = new Map<Id, List<Project_Team_Member__c>>();
        projectIds     = new Set<Id>();
    	
    	for(Project_Team_Member__c ptm : members){
    		Project_Team_Member__c oldPTM = oldMapRecords.get(ptm.Id);
    		if(ptm.User__c != oldPTM.User__c && ptm.User__c != NULL && ptm.Residential_Project__r.RecordType.Name != 'Project Template'){
    			if(teamMemberUpdate.containsKey(ptm.Residential_Project__c)){
    				teamMemberUpdate.get(ptm.Residential_Project__c).put(ptm.Role__c, ptm.User__c);
				}else{
					teamMemberUpdate.put(ptm.Residential_Project__c, new Map<String, Id>{ptm.Role__c => ptm.User__c});
				}
                /* Chatter Post */
                String body = ' You have been assigned to a new project as the '+ptm.Role__c+' by '+UserInfo.getName()+'. The project name is '+ptm.Residential_Project__r.Name+' and the project number is '+ptm.Residential_Project__r.Project_Number__c+'. Please review the project to see what your responsibilities are.';
                ProjectTaskUtility.postChatter(ptm.User__c, body, ptm.Residential_Project__c);

                /* Sharing */
                projectIds.add(ptm.Residential_Project__c);
    		}
            /* Project Dashboard User Change */
            if(ptm.Project_Dashboard_User__c != oldPTM.Project_Dashboard_User__c){
                if(ptmMap.containsKey(ptm.Residential_Project__c)){
                    ptmMap.get(ptm.Residential_Project__c).add(ptm);
                }else{
                    ptmMap.put(ptm.Residential_Project__c, new List<Project_Team_Member__c>{ptm});
                }
            }
            
    	}
	}

	public override void start() {

		tasksToUpdate   = new Map<Id, Project_Task__c>();
        ptmToUpdate     = new List<Project_Team_Member__c>();

		List<Project_Task__c> tasks = [SELECT Id, Residential_Project__c, Role_Assignment__c, Assigned_To__c FROM Project_Task__c WHERE Residential_Project__c IN: teamMemberUpdate.keyset() AND Status_Type__c != 'Completed' ];

		for(Project_Task__c t : tasks){
			for(String role : teamMemberUpdate.get(t.Residential_Project__c).keyset()){
				if(t.Role_Assignment__c == role) {
					t.Assigned_To__c = teamMemberUpdate.get(t.Residential_Project__c).get(role);
					tasksToUpdate.put(t.Id, t);
				}
			}
		} 

        /* Project Dashboard User Change */
        // If the Project Dashboard User flag has changed on a template Project Team Member record, propagate the change down to all the clones
        if(ptmMap.size() > 0){
            for(Project_Team_Member__c ptm : [SELECT Id, Role__c, Residential_Project__r.Project_Template__c, Project_Dashboard_User__c FROM Project_Team_Member__c WHERE Residential_Project__r.Project_Template__c IN: ptmMap.keyset()]){
                for(Project_Team_Member__c tm : ptmMap.get(ptm.Residential_Project__r.Project_Template__c)){
                    if(ptm.Role__c == tm.Role__c) {
                        ptm.Project_Dashboard_User__c = tm.Project_Dashboard_User__c;
                        ptmToUpdate.add(ptm);
                    }
                }
            }
        }
	}

	public override void finish(Boolean fromStart) {
        if(fromStart) {
        	update tasksToUpdate.values();
            update ptmToUpdate;
            ProjectSharingUtility.shareWithTeamMembers(projectIds);
        }
        Diagnostics.pop();
    }
}