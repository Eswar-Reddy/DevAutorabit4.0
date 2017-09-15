/********************************************************************************************
Name   : IssueManagement
Author : Jitendra Kothari
Date   : Sep 26, 2011
Usage  : Class for triggers on Issue Object to keep mapping of Related Case Owner to Case_Owner__c field.
Case   : 00079081
********************************************************************************************/
public class IssueManagement {
    private static String userKeyPrefix = User.SObjectType.getDescribe().getKeyPrefix();
    
     public static void CaseHasIssueFieldUpdate(Issues__c[] issueList){
        List<Case> caseListTemp = new List<Case>();
       
         
         Set<id> caseIds = new Set<Id>();
         for(Issues__c issue : issueList){
            caseIds.add(issue.Case__c);
         }
         
        
         List<Case> caseList = [select   Has_Issues__c,Id from Case where Id in :caseIds];  
        
         for(Case ca : caseList){
             ca.Has_Issues__c = True;
             caseListTemp.add(ca);
         }
         update caseListTemp;
    }
    
    
    public static void copyOwnerFromCase(List<Issues__c> issueList, Map<Id, Issues__c> oldIssueMap){        
        Set<Id> caseIds = new Set<Id>();
        for(Issues__c issue : issueList){
            if((oldIssueMap == null && issue.Case__c != null) 
                || (oldIssueMap != null && issue.Case__c != null && oldIssueMap.get(issue.Id).Case__c != issue.Case__c))
                caseIds.add(issue.Case__c);
            if(issue.Case__c == null)
                issue.Case_Owner__c = null;
        }
        if(caseIds.size() == 0) return;
        Map<Id, Case> caseMap = new Map<Id, Case>([Select OwnerId from Case where Id in :caseIds]);
        for(Issues__c issue : issueList){
            if(caseMap.get(issue.Case__c).OwnerId == null) continue;
            String ownerId = caseMap.get(issue.Case__c).OwnerId;
            if(ownerId.Contains(userKeyPrefix))
                issue.Case_Owner__c = caseMap.get(issue.Case__c).OwnerId;
        }
    }
    
    public static void copyOwnerToIssues(List<Case> lstCasesNew,Map<ID,Case> mapOldCs){     
        Set<Id> caseIds = new Set<Id>();
        for(Case c : lstCasesNew){
            if(mapOldCs == null) continue;
            //String ownerId = mapOldCs.get(c.Id).OwnerId;          
            //ownerId.Contains(userKeyPrefix) && 
            if(c.OwnerId != null && mapOldCs.get(c.Id).OwnerId != c.OwnerId)
                caseIds.add(c.Id);          
        }
        if(caseIds.size() == 0) return;
        List<Issues__c> issueList = [Select Case_Owner__c, Case__r.OwnerId from Issues__c where Case__c in :caseIds];
        if(issueList.size() == 0) return;
        for(Issues__c issue : issueList){
            String ownerId = issue.Case__r.OwnerId;
            if(ownerId.Contains(userKeyPrefix))
                issue.Case_Owner__c = issue.Case__r.OwnerId;
            else
                issue.Case_Owner__c = null;
        }
        update issueList;
    }
    
}