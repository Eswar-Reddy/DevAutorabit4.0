/*
    Project Field Edit Validation
    -----------------------------
    Installation Partner                    ------> Technical Sales Project Manager, Regional Operations Manager
    Homeowner Scheduled Installation Date   ------> Project Coordinator, Regional Operations Manager
    Priority                                ------> Regional Operations Manager
    Sales Order Number                      ------> Partner Support Representative, Technical Sales Project Manager
    Status                                  ------> Regional Operations Manager
    Installation Model 						------> Project Manager
    Purchase Order 		                    ------> Partner Support Representative
*/

public with sharing class ResidentialProjectValidationUtility {

	// Validate that the current user has permission to update specific fields
	public static Map<Id, String> fieldValidation(List<Residential_Project__c> newProjects, Map<Id, Residential_Project__c> oldProjectMap){

		Map<Id, String> errorMap = new Map<Id, String>();
		Boolean bypassVal = [SELECT ByPassValidation__c FROM User WHERE Id =: UserInfo.getuserId() LIMIT 1].ByPassValidation__c;
		Boolean runVal = Test.isRunningTest() ? TRUE : bypassVal ? FALSE : TRUE ;

		// Create map of all Team Members for a specific project
		Map<Id, List<Project_Team_Member__c>> roleMap = new Map<Id, List<Project_Team_Member__c>>();
		for(Residential_Project__c rp : newProjects){
			roleMap.put(rp.Id, new List<Project_Team_Member__c>());
		}
		for(Project_Team_Member__c ptm : [SELECT Id, User__c, Role__c, Residential_Project__c FROM Project_Team_Member__c WHERE Residential_Project__c IN: newProjects AND User__c =: UserInfo.getUserId()]){
			if(roleMap.containsKey(ptm.Residential_Project__c)){
				roleMap.get(ptm.Residential_Project__c).add(ptm);
			}else{
				roleMap.put(ptm.Residential_Project__c, new List<Project_Team_Member__c>{ptm});
			}
		}

		// Loop through fields that were updated and validate the current user is playing the right role for edit access
		if(runVal){
			for(Residential_Project__c p : newProjects){
	            Residential_Project__c oldP = oldProjectMap.get(p.Id);

	            if(p.RecordTypeId == ResidentialProjectUtility.spdId){

		            if(p.Project_Template__c != NULL && oldP.Project_Template__c != NULL ){

		            	if(roleMap.containsKey(p.Id)){

			            	/* Status */
				            if(oldP.Status__c != p.Status__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Regional Operations Manager' || ptm.Role__c == 'PC Supervisor' || ptm.Role__c == 'Installation Partner Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Status can only be changed by the Regional Operations Manager, Installation Partner Manager or PC Supervisor');
				            }

				            /* Homeowner Schedule Installation Date */
				            if(oldP.Homeowner_Scheduled_Installation_Date__c != p.Homeowner_Scheduled_Installation_Date__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Project Coordinator' || ptm.Role__c == 'Regional Operations Manager' || ptm.Role__c == 'Scheduler') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Homeowner Scheduled Installation Date can only be edited by the Project Coordinator or Regional Operations Manager or Scheduler');
				            }

				            /* Priority */
				            if(oldP.Priority__c != p.Priority__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Regional Operations Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Priority can only be edited by the Regional Operations Manager');
				            }

				            /* Sales Order Number */
				            if(oldP.Sales_Order_Number__c != p.Sales_Order_Number__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Partner Support Representative' || ptm.Role__c == 'Technical Sales Project Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Sales Order Number Date can only be edited by the Partner Support Representative or the Technical Sales Project Manager');
				            }
			            }else{
			            	if(oldP.Sales_Order_Number__c != p.Sales_Order_Number__c || oldP.Priority__c != p.Priority__c || oldP.Homeowner_Scheduled_Installation_Date__c != p.Homeowner_Scheduled_Installation_Date__c || oldP.Status__c != p.Status__c || oldP.Installation_Partner__c != p.Installation_Partner__c) errorMap.put(p.Id,'You have restricted edit access to this project because you are not assigned to a  project team member role.');
			            }
			        }
			    }
			    if(p.RecordTypeId == ResidentialProjectUtility.tpsId){
			    	if(p.Project_Template__c != NULL && oldP.Project_Template__c != NULL){

			    		if(roleMap.containsKey(p.Id)){

			                /* Installation Model */
			            	if(oldP.Installation_Model__c != p.Installation_Model__c){
			                    Boolean valid = FALSE;
			                    for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
			                        if(ptm.Role__c == 'Project Manager' || ptm.Role__c == 'Technical Sales Project Manager') valid = TRUE;
			                    }
			                    if(valid == FALSE) errorMap.put(p.Id,'Installation Model can only be edited by the Project Manager or Technical Sales Project Manager');
			                }

			            	/* Status */
				            if(oldP.Status__c != p.Status__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Project Manager' || ptm.Role__c == 'PC Supervisor' || ptm.Role__c == 'Installation Partner Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Status can only be changed by the Project Manager, Installation Partner Manager or PC Supervisor');
				            }

				            /* Priority */
				            if(oldP.Priority__c != p.Priority__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Project Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Priority can only be edited by the Project Manager');
				            }

				            /* Sales Order Number */
				            if(oldP.Sales_Order_Number__c != p.Sales_Order_Number__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Partner Support Representative' ) valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Sales Order Number Date can only be edited by the Partner Support Representative');
				            }
			            }else{
		            		if(oldP.Sales_Order_Number__c != p.Sales_Order_Number__c || oldP.Priority__c != p.Priority__c || oldP.Status__c != p.Status__c || oldP.Installation_Model__c != p.Installation_Model__c) errorMap.put(p.Id,'You have restricted edit access to this project because you are not assigned to a  project team member role.');
			            }
			        }
			    }
			    if(p.RecordTypeId == ResidentialProjectUtility.nhId){

			    	if(p.Project_Template__c != NULL && oldP.Project_Template__c != NULL){

			    		if(roleMap.containsKey(p.Id)){
					    	/* Priority */
				            if(oldP.Priority__c != p.Priority__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Project Administrator' || ptm.Role__c == 'Project Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Priority can only be edited by the Project Administrator or Project Manager');
				            }
				            /* Status */
				            if(oldP.Status__c != p.Status__c){
				                Boolean valid = FALSE;
				                for(Project_Team_Member__c ptm : roleMap.get(p.Id)){
				                    if(ptm.Role__c == 'Project Manager' || ptm.Role__c == 'Project Admin' || ptm.Role__c == 'Installation Partner Manager') valid = TRUE;
				                }
				                if(valid == FALSE) errorMap.put(p.Id,'Status can only be changed by the Project Manager, Installation Partner Manager or Project Admin');
				            }
				            /* Purchase Order */
				            if(oldP.Purchase_Order__c != p.Purchase_Order__c) {
				            	Boolean valid = FALSE;
				            	for(Project_Team_Member__c ptm : roleMap.get(p.Id)) {
				            		if(ptm.Role__c == 'Partner Support Representative') valid = TRUE;
				            	}
				            	if(valid == FALSE) errorMap.put(p.Id,'Purchase Order can only be edited by the Partner Support Representative');
				            }
				            /* Sales Order Number */
				            if(oldP.Sales_Order_Number__c != p.Sales_Order_Number__c) {
				            	Boolean valid = FALSE;
				            	for(Project_Team_Member__c ptm : roleMap.get(p.Id)) {
				            		if(ptm.Role__c == 'Partner Support Representative') valid = TRUE;
				            	}
				            	if(valid == FALSE) errorMap.put(p.Id,'Sales Order Number can only be edited by the Partner Support Representative');
				            }
			            }else{
			            	if(oldP.Status__c != p.Status__c || oldP.Priority__c != p.Priority__c) errorMap.put(p.Id,'You have restricted edit access to this project because you are not assigned to a  project team member role.');
			            }
			        }
			    }
		    }
		}
	    return errorMap;
	}

	// check to ensure user can create material lines or purchase order
	public static Boolean canCreate(Id rpId, String objectType) {
		Boolean result = false;
		// map for objects and set of roles for create rights
		Map<String, Set<String>> objectTypesMap = new Map<String, Set<String>>();
		objectTypesMap.put('StandardLineItem__c', new Set<String> {'Design Engineer', 'Engineer of Record', 'Partner Support Representative'});
		objectTypesMap.put('Purchase_Order__c', new Set<String> {'Partner Support Representative'});

		// check roles for user
		for(Project_Team_Member__c ptm : [SELECT Role__c FROM Project_Team_Member__c WHERE Residential_Project__c =: rpId AND User__c =: UserInfo.getUserId()]) {
			Set<String> roles = objectTypesMap.get(objectType);
			if(roles != null && roles.contains(ptm.Role__c)) result = true;
		}
		return result;
	}
}