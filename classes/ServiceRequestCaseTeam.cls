public class ServiceRequestCaseTeam {

    public static void addToCaseTeamOnSROwnerChange(Map<Integer, WorkOrder> qualifyMap) {
        Boolean canAddToCaseTeam = false;
        String caseTeamRole = 'Service Request Owner';
        
        // load custom setting
        List <Service_Request_Settings__c> settingList = [SELECT Name, Default_Value__c 
            FROM Service_Request_Settings__c 
            WHERE Name LIKE 'SR_%'
            ORDER BY Name ASC];    
        for (Service_Request_Settings__c setting : settingList) {
            if (String.IsNotBlank(setting.Default_Value__c)) {
                if (setting.Name.equalsIgnoreCase('SR_CaseTeam_AddSROwner')) {
                    if (setting.Default_Value__c.equalsIgnoreCase('true')) {
                        canAddToCaseTeam = true;
                    }
                } else if (setting.Name.equalsIgnoreCase('SR_CaseTeam_Role')) {
                    caseTeamRole = setting.Default_Value__c;
                }
            }
        }
        
        if (canAddToCaseTeam == false) { 
            return;     
        } 
        
        // looks like there is a bug after sandbox refresh. this is not fetching in SIT but works in production
        // CaseTeamRole ctr = [SELECT Id, Name FROM CaseTeamRole WHERE Name = :caseTeamRole LIMIT 1];
        CaseTeamRole ctr;
        for (CaseTeamRole rec : [SELECT Id, Name FROM CaseTeamRole]) {
            if (rec.Name == caseTeamRole) {
                ctr = rec;
            }
        }
        if (ctr == null) {
            system.debug('Case team role not found: ' + caseTeamRole);
            return;
        }
        
        // get existing case team members
        Map <String, Set <String>> caseId_memberIdSet_map = new Map <String, Set <String>>(); 
        Set <String> caseIdSet = new Set <String>();   
        for (WorkOrder wo : qualifyMap.values()) {
            if (wo.CaseId != null) {        
                caseIdSet.add(wo.CaseId);
            }
        }
        if (caseIdSet.size() > 0) {
            for (Case c : [SELECT Id, (SELECT MemberId FROM TeamMembers) FROM Case WHERE Id IN :caseIdSet]) {
                Set <String> memberIdSet = new Set <String>();
                if (caseId_memberIdSet_map.containsKey(c.Id)) {
                    memberIdSet = caseId_memberIdSet_map.get(c.Id);
                } 
                for (CaseTeamMember ctm : c.TeamMembers) {
                    memberIdSet.add(ctm.MemberId);
                } 
                caseId_memberIdSet_map.put(c.Id, memberIdSet);          
            }
        
        }

        List <CaseTeamMember> ctmList = new List <CaseTeamMember>();
        String userKeyPrefix = User.SObjectType.getDescribe().getKeyPrefix();
        for (WorkOrder wo : qualifyMap.values()) {
            if (wo.CaseId != null && caseId_memberIdSet_map.containsKey(wo.CaseId)) {        
                Set <String> memberIdSet = caseId_memberIdSet_map.get(wo.CaseId);
                if (memberIdSet.contains(wo.OwnerId) == false) {
                    String ownerId = wo.OwnerId;
                    if (String.IsNotBlank(ownerId) && ownerId.startsWith(userKeyPrefix)) {
                        CaseTeamMember ctm = new CaseTeamMember();
                        ctm.ParentId = wo.CaseId;    
                        ctm.MemberId = wo.OwnerId;
                        ctm.TeamRoleId = ctr.Id;  
                        ctmList.add(ctm);
                    }                
                }
            }
        }

        if (ctmList.size() > 0) {
            Database.SaveResult[] srList = Database.insert(ctmList, false);
            for (Integer i=0; i<srList.size(); i++) {
                Database.SaveResult sr = srList[i]; 
                if (sr.isSuccess()) {
                } else {
                    String errMsg = 'The following error has occurred while inserting case team member: ';
                    for(Database.Error err : sr.getErrors()) {
                        errMsg += err.getStatusCode() + ': ' + err.getMessage();                    
                        errMsg += '. Fields that affected this error: ' + err.getFields();
                    } 
                    system.debug(errMsg);                   
                }                
            }
        }     
            
    }
    
}