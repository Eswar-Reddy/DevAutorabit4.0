public without sharing class Project_Team_MemberAfterInsertHandler extends TriggerHandlerBase{
	// -------- Constants --------

	// -------- Variables --------
	List<Project_Team_Member__c> members;
	Map<Project_Team_Member__c, Id> templateInsert;
	Map<Project_Team_Member__c, Id> projectInsert;
	List<Project_Team_Member__c> nptmToInsert;
	Map<Id, Project_Task__c> tasksToUpdate;
	Set<Id> 					projectIds;
    
    // -------- Constructor --------
    public Project_Team_MemberAfterInsertHandler() {}

    //Begin processing
    public override void qualifyStartingRecords(List<sObject> newList, List<sObject> oldList, Map<ID, sObject> newMap, Map<ID, sObject> oldMap) {
    	Diagnostics.push('Project_Team_MemberAfterInsertHandler qualifyStartingRecords');

    	List<Project_Team_Member__c> 	newRecords 		= (List<Project_Team_Member__c>)newList;

    	members = [SELECT Id, User__c, Role__c, Project_Dashboard_User__c, Residential_Project__c, Residential_Project__r.Name, Residential_Project__r.Project_Number__c, Residential_Project__r.RecordType.Name FROM Project_Team_Member__c WHERE Id IN: newRecords];
    	templateInsert = new Map<Project_Team_Member__c, Id>();
    	projectInsert  = new Map<Project_Team_Member__c, Id>();
    	projectIds 	   = new Set<Id>();

    	for(Project_Team_Member__c ptm : members){
    		if(ptm.Residential_Project__r.RecordType.Name == 'Project Template'){
    			templateInsert.put(ptm, ptm.Residential_Project__c);
    		}else if(String.isNotBlank(ptm.Role__c) && ptm.User__c != NULL){
    			projectInsert.put(ptm, ptm.Residential_Project__c);
    		}
    		
    		if(ptm.Residential_Project__r.RecordType.Name != 'Project Template' && ptm.User__c != NULL){
    			/* Chatter Post */
    			String body = ' You have been assigned to a new project as the '+ptm.Role__c+' by '+UserInfo.getName()+'. The project name is '+ptm.Residential_Project__r.Name+' and the project number is '+ptm.Residential_Project__r.Project_Number__c+'. Please review the project to see what your responsibilities are.';
    			ProjectTaskUtility.postChatter(ptm.User__c, body, ptm.Residential_Project__c);

    			/* Sharing */
    			projectIds.add(ptm.Residential_Project__c);
    		}
    	}

	}

	public override void start() {

		if(templateInsert.size() > 0) {
			List<Residential_Project__c> cloneProjects = [SELECT Id, Project_Template__c FROM Residential_Project__c WHERE Project_Template__c IN: templateInsert.values() AND (Status__c = 'Active' OR Status__c = 'Hold')];
			nptmToInsert = new List<Project_Team_Member__c>();
			// A new project team member record was added to a template, propogate down to all clone projects
			for(Project_Team_Member__c ptm : templateInsert.keyset()){
				for(Residential_Project__c rp : cloneProjects){
					if(templateInsert.get(ptm) == rp.Project_Template__c){
						Project_Team_Member__c nptm = new Project_Team_Member__c();
						nptm.Role__c = ptm.Role__c;
						nptm.Residential_Project__c = rp.Id;
						nptm.Project_Dashboard_User__c = ptm.Project_Dashboard_User__c;
						nptmToInsert.add(nptm);
					}
				}
			}
		}
		if(projectInsert.size() > 0){
			List<Project_Task__c> tasksForAssign = [SELECT Id, Role_Assignment__c, Assigned_To__c, Residential_Project__c FROM Project_Task__c WHERE Residential_Project__c IN: projectInsert.values()];
			tasksToUpdate = new Map<Id, Project_Task__c>();
			// A new project tea member record was added to a project, check for matching task role assignment
			for(Project_Team_Member__c ptm : projectInsert.keyset()){
				for(Project_Task__c pt : tasksForAssign){
					if(ptm.Residential_Project__c == pt.Residential_Project__c && ptm.Role__c == pt.Role_Assignment__c){
						pt.Assigned_To__c = ptm.User__c;
						tasksToUpdate.put(pt.Id, pt);
					}
				}
			}
		}
	}

	public override void finish(Boolean fromStart) {
        if(fromStart) {
        	if(tasksToUpdate != NULL) update tasksToUpdate.values();
        	if(nptmToInsert != NULL)  insert nptmToInsert;
        	/* Sharing */
        	ProjectSharingUtility.shareWithTeamMembers(projectIds);
        }
        Diagnostics.pop();
    }
}