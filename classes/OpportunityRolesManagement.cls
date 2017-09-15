public class OpportunityRolesManagement{
    public static void afterInsertUpdateDelete(List<Opportunity_Role__c> OppRoleList,Map<ID,Opportunity_Role__c> mapOldOppRole, boolean isInsert)
    {   
        setTransmissionCapacity(OppRoleList, mapOldOppRole, isInsert);         
    }    
    //start for case # 00057991
    static Id frameworkParentRecTypeId;
    static Id frameworkChildRecTypeId;    
    public static Map<String, Schema.RecordTypeInfo> nameToOppRoleRecordTypeInfoMap;
    static {
        nameToOppRoleRecordTypeInfoMap = Schema.SObjectType.Opportunity_Role__c.getRecordTypeInfosByName();
    }
    
    public static void afterInsertUpdateDeleteFramework(Map<ID,Opportunity_Role__c> mapNewOppRole, Map<ID,Opportunity_Role__c> mapOldOppRole, String operation){
    	
        frameworkParentRecTypeId = nameToOppRoleRecordTypeInfoMap.get('Framework Master Agreement').getRecordTypeId();
        frameworkChildRecTypeId = nameToOppRoleRecordTypeInfoMap.get('Framework Child').getRecordTypeId();
        List<Opportunity_Role__c> updateList = new List<Opportunity_Role__c>();        
        
        Map<ID,Opportunity_Role__c> parentRecords = new Map<ID,Opportunity_Role__c>();
        Map<ID,Opportunity_Role__c> childRecords = new Map<ID,Opportunity_Role__c>();
        Set<Id> parentIds = new Set<Id>();
        if(operation == 'Update' || operation == 'Insert'){
    		Contract_Notification_Submission(mapNewOppRole,mapOldOppRole);//for Case# 00077877
            for(Opportunity_Role__c oppRole : mapNewOppRole.values()){
                if(oppRole.RecordTypeId == frameworkChildRecTypeId){
                    childRecords.put(oppRole.Id, oppRole);
                    parentIds.add(oppRole.Parent_Framework_Agreement__c);
                    parentRecords.put(oppRole.Parent_Framework_Agreement__c, new Opportunity_Role__c(Id = oppRole.Parent_Framework_Agreement__c));
                    if(operation == 'Update' && mapOldOppRole.get(oppRole.Id).Parent_Framework_Agreement__c !=null && 
                        oppRole.Parent_Framework_Agreement__c != mapOldOppRole.get(oppRole.Id).Parent_Framework_Agreement__c){                      
                        parentRecords.put(mapOldOppRole.get(oppRole.Id).Parent_Framework_Agreement__c, new Opportunity_Role__c(Id = mapOldOppRole.get(oppRole.Id).Parent_Framework_Agreement__c));                     
                    }                   
                }                
            }
            if(childRecords.size() > 0 && operation == 'Insert')
                validateData(childRecords, parentIds);
            if(childRecords.size() > 0 && operation == 'Update')
                validateData(childRecords, mapOldOppRole, parentIds);                       
        }else if(operation == 'Delete'){
            for(Opportunity_Role__c oppRole : mapOldOppRole.values()){
                if(oppRole.RecordTypeId == frameworkChildRecTypeId){
                    parentRecords.put(oppRole.Parent_Framework_Agreement__c, new Opportunity_Role__c(Id = oppRole.Parent_Framework_Agreement__c));                    
                }
            }                         
        }       
        if(parentRecords.size()>0){         
            updateList.addAll(getFrameworksParentFieldsForUpdate(parentRecords));
        }           
        if(updateList.size() > 0){
            update updateList;
        }                   
    }
    
    public static void validateData(Map<ID,Opportunity_Role__c> mapNewOppRole, Set<Id> parentIds){
        Map<ID,Opportunity_Role__c> parentRecords = new Map<ID,Opportunity_Role__c>([Select Id, Amount_Remaining__c, MW_Remaining__c
         from Opportunity_Role__c where Id in :parentIds and RecordType.Name = 'Framework Master Agreement']);
        
        for(Opportunity_Role__c oppRole : mapNewOppRole.values()){
            Opportunity_Role__c parentOppRole = parentRecords.get(oppRole.Parent_Framework_Agreement__c);
            
            if(parentOppRole != null
                && (oppRole.Amount1__c != 0 || oppRole.MWs_on_Current_Oppty__c != 0)){
                if(parentOppRole.Amount_Remaining__c!=null && oppRole.Amount1__c > parentOppRole.Amount_Remaining__c){
                    oppRole.addError('Child agreement cannot be booked if the Child Amount exceeds the Amount Approved on Parent Agreement.');
                }
                if(parentOppRole.MW_Remaining__c != null 
                    && oppRole.MWs_on_Current_Oppty__c > parentOppRole.MW_Remaining__c){
                    oppRole.addError('Child agreement cannot be booked if the Child MWs on Current Oppty exceeds the MW Master Agreement Approved on Parent Agreement.');
                }
            }               
        }        
    }
    
    public static void validateData(Map<ID,Opportunity_Role__c> mapNewOppRole, Map<ID,Opportunity_Role__c> mapOldOppRole, Set<Id> parentIds){
        Map<ID,Opportunity_Role__c> parentRecords = new Map<ID,Opportunity_Role__c>([Select Id, Amount_Remaining__c, MW_Remaining__c
         from Opportunity_Role__c where Id in :parentIds and RecordType.Name = 'Framework Master Agreement']);
        
        for(Opportunity_Role__c oppRole : mapNewOppRole.values()){
            Opportunity_Role__c parentOppRole = parentRecords.get(oppRole.Parent_Framework_Agreement__c);
            Opportunity_Role__c oldOppRole = mapOldOppRole.get(oppRole.Id);
            if(parentOppRole != null && oldOppRole != null
                && (oppRole.Amount1__c != oldOppRole.Amount1__c 
                || oppRole.MWs_on_Current_Oppty__c != oldOppRole.MWs_on_Current_Oppty__c)){                
                if(parentOppRole.Amount_Remaining__c!=null && oppRole.Amount1__c - oldOppRole.Amount1__c > parentOppRole.Amount_Remaining__c){
                    oppRole.addError('Child agreement cannot be booked if the Child Amount exceeds the Amount Approved on Parent Agreement.');
                }
                if(parentOppRole.MW_Remaining__c != null 
                    && oppRole.MWs_on_Current_Oppty__c - oldOppRole.MWs_on_Current_Oppty__c > parentOppRole.MW_Remaining__c){
                    oppRole.addError('Child agreement cannot be booked if the Child MWs on Current Oppty exceeds the MW Master Agreement Approved on Parent Agreement.');
                }
            }
            if(parentOppRole != null && oldOppRole != null
                && (oppRole.Parent_Framework_Agreement__c != mapOldOppRole.get(oppRole.Id).Parent_Framework_Agreement__c)){
                if(parentOppRole.Amount_Remaining__c!=null && oppRole.Amount1__c > parentOppRole.Amount_Remaining__c){
                    oppRole.addError('Child agreement cannot be booked if the Child Amount exceeds the Amount Approved on Parent Agreement.');
                }
                if(parentOppRole.MW_Remaining__c != null 
                    && oppRole.MWs_on_Current_Oppty__c > parentOppRole.MW_Remaining__c){
                    oppRole.addError('Child agreement cannot be booked if the Child MWs on Current Oppty exceeds the MW Master Agreement Approved on Parent Agreement.');
                }   
            }               
        }        
    }
    
    public static List <Opportunity_Role__c> getFrameworksParentFieldsForUpdate(Map<ID,Opportunity_Role__c> mapNewOppRole){
        List <Opportunity_Role__c> updateList = new List <Opportunity_Role__c>();        
         
         ////Added for changes in requirements in case 00060028
         Map<ID,Opportunity_Role__c> childRecordsMap = new Map<ID,Opportunity_Role__c>([Select Id, Amount1__c, MWs_on_Current_Oppty__c, Parent_Framework_Agreement__c
        	,Direct_Project_Margin_2__c,Direct_Project_Margin2__c  //for case# 00060028 
         	from Opportunity_Role__c where Parent_Framework_Agreement__c in :mapNewOppRole.keySet() and RecordType.Name = 'Framework Child']);
         
        Map<ID,List<Opportunity_Role__c>> childRecords = new Map<ID,List<Opportunity_Role__c>>();                       
        for(Opportunity_Role__c oppRole : childRecordsMap.values()){
            List<Opportunity_Role__c> childRecordsList = childRecords.get(oppRole.Parent_Framework_Agreement__c);
            if(childRecordsList == null){
                childRecordsList = new List<Opportunity_Role__c>();
            }
            childRecordsList.add(oppRole);
            childRecords.put(oppRole.Parent_Framework_Agreement__c, childRecordsList);
        }
        for(Opportunity_Role__c oppRole : mapNewOppRole.values()){
            List<Opportunity_Role__c> childRecordsList = childRecords.get(oppRole.Id);
            Decimal amt1 = 0.0;
            Decimal mw1 = 0.0;            
            Decimal adm = 0.0;//for case#00060028
            Decimal adm1 = 0.0;//for case#00060028
            if(childRecordsList == null ){
                if(oppRole.Amount_Booked__c != amt1 || oppRole.MW_Applied1__c != mw1
                    ||oppRole.Ave_DM_of_Opportunities__c != adm || oppRole.Ave_DM1_of_Opportunities__c != adm1){//for case#00060028
                    oppRole.Amount_Booked__c = amt1;
                    oppRole.MW_Applied1__c = mw1;
                    oppRole.Ave_DM_of_Opportunities__c = adm;//for case#00060028
                    oppRole.Ave_DM1_of_Opportunities__c = adm1;//for case#00060028
                    updateList.add(oppRole);
                }
                 continue;
            }
            for(Opportunity_Role__c childOppRole : childRecordsList){
                amt1 = amt1 + childOppRole.Amount1__c;
                mw1 = mw1 + childOppRole.MWs_on_Current_Oppty__c;
                
                //Added for changes in case 00060028
                adm = adm + childOppRole.Direct_Project_Margin_2__c;
                if (childOppRole.Direct_Project_Margin2__c != null)
                    adm1 = adm1 + childOppRole.Direct_Project_Margin2__c;                
            }
            //start for case#00060028
            if(childRecordsList.size()>0){
                adm = adm/childRecordsList.size();
                adm1 = adm1/childRecordsList.size();
            }
            //end for case#00060028
            if(oppRole.Amount_Booked__c != amt1 || oppRole.MW_Applied1__c != mw1
                ||oppRole.Ave_DM_of_Opportunities__c != adm || oppRole.Ave_DM1_of_Opportunities__c != adm1){//for case#00060028
                oppRole.Amount_Booked__c = amt1;
                oppRole.MW_Applied1__c = mw1;
                //start for case#00060028
                oppRole.Ave_DM_of_Opportunities__c = adm;
                oppRole.Ave_DM1_of_Opportunities__c = adm1;
                //end for case#00060028
                updateList.add(oppRole);
            }
        }
        return updateList;
    }
    
    //end for case # 00057991
    //Case-00046612
    //Do not allow to exceed total Land Capacity than the capacity defined on Account
    //Case#00064969- Dependency updated to use Account instead of infrastructure Account
    public static void setTransmissionCapacity(List<Opportunity_Role__c> OppRoleList, Map<ID,Opportunity_Role__c> mapOldOppRole, boolean isInsert)
    {
        //Get accountID set if substation capacity of opportunity role is updated,added or deleted
        Set<String> setOppRoleAccount = new Set<String>();
        if(OppRoleList != null){
            for(Opportunity_Role__c oppRole : OppRoleList){
                //If Opportunity Role is being inserted or updated
                if(oppRole.Substation_Capacity_Mw__c>0 && oppRole.Account__c!=null && nameToOppRoleRecordTypeInfoMap.get('Substation')!=null && nameToOppRoleRecordTypeInfoMap.get('Substation').getRecordTypeId()== oppRole.recordtypeID){
                    setOppRoleAccount.add(oppRole.Account__c);
                }
                // Done for case # 00064969
                if(oppRole.Substation_Capacity_Mw__c>0 && oppRole.Account__c ==null && nameToOppRoleRecordTypeInfoMap.get('Substation')!=null && nameToOppRoleRecordTypeInfoMap.get('Substation').getRecordTypeId()== oppRole.recordtypeID){
                    oppRole.AddError('There must be a Account for the Opportunity Role. Please enter the Account Field.');
                }
                //If Opportunity Role is being updated
                //else if(mapOldOppRole!=null && oppRole.Substation_Capacity_Mw__c != mapOldOppRole.get(oppRole.ID).Substation_Capacity_Mw__c && oppRole.Account__c!=null){
                //    setOppRoleAccount.add(oppRole.Account__c);
                //}
            }
        }
        //If Opportunity Role is being deleted
        if(OppRoleList == null){
            for(Opportunity_Role__c oppRole : mapOldOppRole.values()){
                if(oppRole.Substation_Capacity_Mw__c>0 && oppRole.Account__c!=null && nameToOppRoleRecordTypeInfoMap.get('Substation')!=null && nameToOppRoleRecordTypeInfoMap.get('Substation').getRecordTypeId()== oppRole.recordtypeID){
                    setOppRoleAccount.add(oppRole.Account__c);
                }
            }
        }
        
        //Get all opportunity roles for above accounts
        //Prepare map of account with total Transmission capacity (substation capacity) used on all related opp Role
        Map<String,double> mapAccountCapacityUsed = new Map<String,double>();
        Map<String,double> mapAccountOldCapacityUsed = new Map<String,double>();
        Map<String,double> mapAccountCapacityAllowed = new Map<String,double>();
        for(Opportunity_Role__c oppRole : [Select id,Substation_Capacity_Mw__c,Account__c,Account__r.transmission_capacity__c,Account__r.transmission_capacity_used__c from Opportunity_Role__c where Account__c in :setOppRoleAccount and Substation_Capacity_Mw__c>0 and recordtype.name='Substation']){
            mapAccountOldCapacityUsed.put(oppRole.Account__c,oppRole.Account__r.transmission_capacity_used__c);
            
            double total = oppRole.Substation_Capacity_Mw__c;
            if(mapAccountCapacityUsed.containsKey(oppRole.Account__c)){
                total = mapAccountCapacityUsed.get(oppRole.Account__c) + oppRole.Substation_Capacity_Mw__c;            
            }
            mapAccountCapacityUsed.put(oppRole.Account__c, total);
            
            double cap = 0;
            if(oppRole.Account__r.transmission_capacity__c != null){
                cap = oppRole.Account__r.transmission_capacity__c;
            }
            mapAccountCapacityAllowed.put(oppRole.Account__c, cap);         
        }
        
        //Add error and prepare list of account that needs to be updated        
        //If opportunity roles are being inserted or updated then add error
        List<Account> lstUpdateAccount = new List<Account>();
        set<String> uniqueAccount = new set<String>();
        if(OppRoleList != null){
            for(Opportunity_Role__c oppRole : OppRoleList){
                //If capacity is used more than allowed
                if(mapAccountCapacityUsed.containskey(oppRole.Account__c) && mapAccountCapacityAllowed.containskey(oppRole.Account__c) && (mapAccountCapacityUsed.get(oppRole.Account__c)>mapAccountCapacityAllowed.get(oppRole.Account__c))){
                    oppRole.Substation_Capacity_Mw__c.AddError('Substation Capacity is increased than allowed Capacity. Please reduce the Substation Capacity.');
                }
                else if(!uniqueAccount.contains(oppRole.Account__c) && mapAccountCapacityUsed.containskey(oppRole.Account__c) && mapAccountOldCapacityUsed.containskey(oppRole.Account__c)){
                    //Go for update only if capacity used is changed
                    if(mapAccountCapacityUsed.get(oppRole.Account__c) != mapAccountOldCapacityUsed.get(oppRole.Account__c)){
                        Account acc = new Account(id=oppRole.Account__c);
                        acc.transmission_capacity_used__c = mapAccountCapacityUsed.get(oppRole.Account__c);
                        lstUpdateAccount.add(acc);
                        uniqueAccount.Add(oppRole.Account__c);
                    }
                }
            }     
        }  
        //If opportunity roles are being deleted then add error
        if(OppRoleList == null){
            for(Opportunity_Role__c oppRole : mapOldOppRole.values()){
                if(!uniqueAccount.contains(oppRole.Account__c) && mapAccountCapacityUsed.containskey(oppRole.Account__c)  && mapAccountOldCapacityUsed.containskey(oppRole.Account__c)){
                    //Go for update only if capacity used is changed
                        if(mapAccountCapacityUsed.get(oppRole.Account__c) != mapAccountOldCapacityUsed.get(oppRole.Account__c)){
                        Account acc = new Account(id=oppRole.Account__c);
                        acc.transmission_capacity_used__c = mapAccountCapacityUsed.get(oppRole.Account__c);
                        lstUpdateAccount.add(acc);
                        uniqueAccount.Add(oppRole.Account__c);
                    }
                }
            }
        }
        
        //Update Accounts
        if(lstUpdateAccount.size() > 0){
            update lstUpdateAccount;
        }
    }
    //Start for Case# 00077877
    private static void Contract_Notification_Submission(Map<ID,Opportunity_Role__c> mapNewOppRole, Map<ID,Opportunity_Role__c> mapOldOppRole){
    	Id notify_temp_Id; 
    	List<Messaging.Email> emailMessages = new List<Messaging.Email>();
    	List<String> mailToAddresses = new List<String>();
    	Map<Id,Set<String>> salesTeamMailAdd = new Map<Id,Set<String>>();
    	Map<Id,String> userEmailAddr = new Map<Id,String>();    	
    	Map<Id, Id> oppRoleMap = new Map<Id, Id>();    	
    	Set<Id> userSet = new Set<Id>();
    	Map<String,String> commonUserNames = new Map<String, String>{'Janice Fetzer'=> '','Eric Potts'=> '','Steven Silveira'=> '','SunPower Email Archives'=>'','Raphael Gernez'=>''};
    	
    	List<User> userList = new List<User>([Select Id, Business_Unit__c  from User where Id = :userInfo.getUserId()]);
    	User currentUser;
        if(userList!=null && userList.size()>0){
            currentUser = userList.get(0);
        }
        
    	Set<String> Sales_Team = new Set<String>{'Management','Operations','Sales','Finance','Supply Chain','Sales Person', 'Sales Analyst','Structured Finance','Proposal Designer','Construction Manager','Project Manager',
					'Estimator','Operations and Maintenance','Application Engineer','Energy Efficiency Specialist','Developer (Partner User)','SSR,Electrical Engineer','Project Engineer','Project Designer','Legal,Sales Manager'};
		
		for(Opportunity_Role__c oppRole : mapNewOppRole.values()){			
			if((currentUser.Business_Unit__c == 'NA Commercial' &&  oppRole.Quote_No__c != null && 
			   ((mapOldOppRole == null && oppRole.Contract_Status__c == 'In Review') || (mapOldOppRole != null && 
			   oppRole.Contract_Status__c == 'In Review' && mapOldOppRole.get(oppRole.Id).Contract_Status__c != oppRole.Contract_Status__c)) && 
			   (oppRole.RecordTypeId == nameToOppRoleRecordTypeInfoMap.get('EPC Customer').getRecordTypeId() ||
			   oppRole.RecordTypeId == nameToOppRoleRecordTypeInfoMap.get('Energy Off Taker (PPA)').getRecordTypeId() || 
			   oppRole.RecordTypeId == nameToOppRoleRecordTypeInfoMap.get('Project Financing Partner').getRecordTypeId() || 
			   oppRole.RecordTypeId == nameToOppRoleRecordTypeInfoMap.get('Components').getRecordTypeId() || 
			   oppRole.RecordTypeId == nameToOppRoleRecordTypeInfoMap.get('Reseller').getRecordTypeId()))){
		   			 if(oppRole.Opp_Name__c != null){
		   			 	oppRoleMap.put(oppRole.Id, oppRole.Opp_Name__c);			   			 
		   			 }else{
		   			 	oppRoleMap.put(oppRole.Id, null);
		   			 }
		   			 userSet.add(oppRole.CreatedById);
			   		 userSet.add(oppRole.LastModifiedById);   
		   }	
		}
		if(userSet.size() == 0) return;
		List<String> teamMailList = new List<String>();
		if(oppRoleMap.values().size() > 0){
			for(OpportunityTeamMember otm : [Select Id, OpportunityId, User.Email From OpportunityTeamMember where TeamMemberRole IN :Sales_Team And OpportunityId IN :oppRoleMap.values()]){
				if(!salesTeamMailAdd.containsKey(otm.OpportunityId))
	            	salesTeamMailAdd.put(otm.OpportunityId,new Set<String>());
	            salesTeamMailAdd.get(otm.OpportunityId).add(otm.User.Email);
			}
		}
		
		for(User usr :[Select Id, Email, Name From User Where Name IN :commonUserNames.keySet() Or Id IN :userSet]){			
			if(commonUserNames.containsKey(usr.Name)){
				commonUserNames.put(usr.Name,usr.Email);
			}else{
				userEmailAddr.put(usr.Id,usr.Email);
			}
			/*if(userSet.contains(usr.Id)){
				userEmailAddr.put(usr.Id,usr.Email);
			}*/
    	}
    	List<Contact> contacts = new List<Contact>([Select id, Email from Contact where Email =:commonUserNames.get('SunPower Email Archives')]);
        
        if (contacts.isEmpty()){
            Contact cont = new Contact();
            cont.LastName = 'Dummy Contact';
            cont.Email = commonUserNames.get('SunPower Email Archives');
            insert cont;
            contacts.Add(cont);
        }        
    	commonUserNames.remove('SunPower Email Archives');
        
        for(EmailTemplate eTemp:
                    [Select Id From EmailTemplate where DeveloperName = 'Contract_Notification_Submission_Email_Template']){
               notify_temp_Id =  eTemp.Id;  			
        }
        if(notify_temp_Id == null) return;
    	for(Opportunity_Role__c oppRole : mapNewOppRole.values()){    		 
    		 if(oppRoleMap.containsKey(oppRole.Id) ){
	    		 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	             mail.setTemplateId(notify_temp_Id);
	             
	             mail.setTargetObjectId(contacts.get(0).Id);
	             mail.setWhatId(oppRole.Id);                     
	             mail.saveAsActivity = false;
	             mailToAddresses.clear();             
	             
	             mailToAddresses.addAll(commonUserNames.values());
	             if(oppRole.Opp_Name__c!=null && salesTeamMailAdd != null && salesTeamMailAdd.get(oppRole.Opp_Name__c) != null)
	             	mailToAddresses.addAll(salesTeamMailAdd.get(oppRole.Opp_Name__c));
	             if(userEmailAddr.get(oppRole.LastModifiedById) != null)
	             	mailToAddresses.add(userEmailAddr.get(oppRole.LastModifiedById));
	             if(userEmailAddr.get(oppRole.CreatedById) != null)
	             	mailToAddresses.add(userEmailAddr.get(oppRole.CreatedById));
	             mail.setToAddresses(mailToAddresses);
	             for(String str:mailToAddresses)
	             	System.debug(str);
	             emailMessages.add(mail);
    		 }
    	}
    	
		if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        }
    }
    //End for Case# 00077877
}