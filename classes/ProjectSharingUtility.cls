/************************************************************************************************
Created By: Sita Reeves Redpoint (Residential Installation Project Mgmt)
Created On: 7/20/16
 
Purpose: This utility manages the custom sharing for the Residential Project and all child records

Access to Project Mgmt permission sets grant Read All access to users.
When a user is assigned to a project team member role they are granted read/write access to the 
project and tasks.
If any team member assignment changes on a project the custom sharing records are deleted and 
recreated for the new team members to keep access in sync. Templates are excluded from this sharing.

************************************************************************************************/

public without sharing class ProjectSharingUtility {
	public static void shareWithTeamMembers(Set<Id> projects) {
		List<Residential_Project__Share> sharesToInsert = new List<Residential_Project__Share>();
		List<NH_Community__Share> commsharesToInsert = new List<NH_Community__Share>();
		delete [SELECT Id FROM Residential_Project__Share WHERE ParentId IN: projects AND (RowCause =: Schema.Residential_Project__Share.RowCause.Project_Team_Member__c OR RowCause =: Schema.Residential_Project__Share.RowCause.External_User_Role_Hierarchy__c) ];
		
		// Sets for external role hierarchy gathering
		Set<Id> allParentRoles = new Set<Id>();
		Set<Id> baseParentRoles = new Set<Id>();
		Set<Id> ndParentRoles = new Set<Id>();
		Set<Id> rdParentRoles = new Set<Id>();
		Map<Id, List<Id>> roleMap = new Map<Id, List<Id>>();

		for(Project_Team_Member__c m : [SELECT Residential_Project__c, Residential_Project__r.Community__c, User__c, User__r.UserRoleId, User__r.UserRole.PortalType, User__r.UserRole.ParentRoleId, User__r.ContactId FROM Project_Team_Member__c WHERE Residential_Project__c IN: projects AND User__c != NULL AND User__r.isActive = TRUE]){
			Residential_Project__Share rpShare = new Residential_Project__Share();
			rpShare.ParentId = m.Residential_Project__c;
			rpShare.UserorGroupId = m.User__c;
			rpShare.RowCause = Schema.Residential_Project__Share.RowCause.Project_Team_Member__c;
			rpShare.AccessLevel = 'Edit';
			sharesToInsert.add(rpShare);

			/* 
			if(m.User__r.UserRole.PortalType == 'Partner' && m.Residential_Project__r.Community__c != NULL){
				NH_Community__Share nhShare = new NH_Community__Share();
				nhShare.ParentId = m.Residential_Project__r.Community__c;
				nhShare.UserorGroupId = m.User__c;
				nhShare.RowCause = Schema.NH_Community__Share.RowCause.Project_Team_Member__c;
				nhShare.AccessLevel = 'Read';
				commsharesToInsert.add(nhShare);
			}*/
			// If external user, get their parent role
			if(m.User__r.UserRole.PortalType == 'Partner') {
				baseParentRoles.add(m.User__r.UserRole.ParentRoleId);
				if(roleMap.containsKey(m.User__r.UserRole.ParentRoleId)){
					roleMap.get(m.User__r.UserRole.ParentRoleId).add(m.Residential_Project__c);
				}else{
					roleMap.put(m.User__r.UserRole.ParentRoleId, new List<Id>{m.Residential_Project__c});
				}
			}

		}

		for(Project_Task__c pt : [SELECT Id, Assigned_To__c, Residential_Project__c FROM Project_Task__c WHERE Residential_Project__c IN: projects AND Assigned_To__c != NULL AND Assigned_To__r.isActive = TRUE]){
			Residential_Project__Share rpShare = new Residential_Project__Share();
			rpShare.ParentId = pt.Residential_Project__c;
			rpShare.UserorGroupId = pt.Assigned_To__c;
			rpShare.RowCause = Schema.Residential_Project__Share.RowCause.Project_Team_Member__c;
			rpShare.AccessLevel = 'Edit';
			sharesToInsert.add(rpShare);
		}

		// Go up another step in role hierarchy
		allParentRoles.addAll(baseParentRoles);
		for(UserRole parent : [SELECT Id, ParentRoleId FROM UserRole WHERE Id IN: baseParentRoles AND PortalType = 'Partner']){
			ndParentRoles.add(parent.ParentRoleId);
			if(roleMap.containsKey(parent.ParentRoleId)){
				roleMap.get(parent.ParentRoleId).addAll(roleMap.get(parent.Id));
			}else{
				roleMap.put(parent.ParentRoleId, new List<Id>(roleMap.get(parent.Id)));
			}

		}
		allParentRoles.addAll(ndParentRoles);

		// Go up another step in role hierarchy
		if(ndParentRoles.size() >0 ){
			for(UserRole parent : [SELECT Id, ParentRoleId FROM UserRole WHERE Id IN: ndParentRoles AND PortalType = 'Partner']){
				rdParentRoles.add(parent.ParentRoleId);

				if(roleMap.containsKey(parent.ParentRoleId)){
					roleMap.get(parent.ParentRoleId).addAll(roleMap.get(parent.Id));
				}else{
					roleMap.put(parent.ParentRoleId, new List<Id>(roleMap.get(parent.Id)));
				}
			}
			allParentRoles.addAll(rdParentRoles);
		}

		// Provide access for all users higher in the role hierarchy
		for(User u : [SELECT Id, UserRoleId FROM User WHERE UserRoleId IN: allParentRoles AND isActive = TRUE AND UserRole.PortalType = 'Partner']){
			Set<Id> projSet = new Set<Id>();
			projSet.addAll(roleMap.get(u.UserRoleId));
			for(Id rId : projSet){
				Residential_Project__Share rpShare = new Residential_Project__Share();
				rpShare.ParentId = rId;
				rpShare.UserorGroupId = u.Id;
				rpShare.RowCause = Schema.Residential_Project__Share.RowCause.External_User_Role_Hierarchy__c;
				rpShare.AccessLevel = 'Edit';
				sharesToInsert.add(rpShare);
			}
		}

		insert sharesToInsert;
		insert commsharesToInsert;
	}
}