public class RMACaseTeam {

    public static void addToCaseTeamOnRMAOwnerChange(Map<Integer, RMA__c> qualifyMap) {
        Boolean canAddToCaseTeam = false;
        String caseTeamRole = 'RMA Owner';
        
        // load custom setting
        for (RMA_Settings__c setting : RMA_Settings__c.getAll().values()) {
            if (String.IsNotBlank(setting.Value__c)) {
                if (setting.Name.equalsIgnoreCase('CaseTeam_AddRMAOwner')) {
                    if (setting.Value__c.equalsIgnoreCase('true')) {
                        canAddToCaseTeam = true;
                    }
                } else if (setting.Name.equalsIgnoreCase('CaseTeam_RMAOwnerRole')) {
                    caseTeamRole = setting.Value__c;
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
        for (RMA__c rma : qualifyMap.values()) {
            if (rma.Case__c != null) {        
                caseIdSet.add(rma.Case__c);
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
        for (RMA__c rma : qualifyMap.values()) {
            if (rma.Case__c != null && caseId_memberIdSet_map.containsKey(rma.Case__c)) {        
                Set <String> memberIdSet = caseId_memberIdSet_map.get(rma.Case__c);
                if (memberIdSet.contains(rma.RMA_Owner__c) == false) {
                    String ownerId = rma.RMA_Owner__c;
                    if (String.IsNotBlank(ownerId) && ownerId.startsWith(userKeyPrefix)) {
                        CaseTeamMember ctm = new CaseTeamMember();
                        ctm.ParentId = rma.Case__c;    
                        ctm.MemberId = rma.RMA_Owner__c;
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