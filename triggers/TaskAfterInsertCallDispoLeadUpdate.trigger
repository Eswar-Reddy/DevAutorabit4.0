/*
Trigger to update lead status based on call result received from solar advisor in Five9

Trigger:            TaskAfterInsertCallDispoLeadUpdate
Date:               04/03/2015
Version:            1
Last Updated:       12/14/2015
    *   Stubbed
    *  Completed
Updates: 
Modified By : 
Modified On : 
Summary : 


////////////////////////////////////////////////////////////////////////////////
*/

trigger TaskAfterInsertCallDispoLeadUpdate on Task (after insert){
    //Collections and Variables
    String leadPrefix = String.valueOf(Lead.SObjectType.getDescribe().getKeyPrefix());
    String optyPrefix = String.valueOf(Opportunity.SObjectType.getDescribe().getKeyPrefix());
    List<Task> tasksForLeadUpdates = new List<Task>();//tasks that qualify
    List<Task> tasksForOptyUpdates = new List<Task>();//tasks that qualify
    List<Opportunity> optytoUpdate = new List<Opportunity>();//collection of opty with new status
    List<Lead> leadsToUpdate = new List<Lead>();//dml collection of leads with new status
    Set<Id> leadIdsForIncrement = new Set<Id>();
    
    Map<String, F9CallDispositions__c> callDispoMap = new Map<String, F9CallDispositions__c>();
    //Collect Call Dispositions from F9 setting for comparison
    for(F9CallDispositions__c f : F9CallDispositions__c.getAll().values()) {
        callDispoMap.put(f.Disposition__c, f);
    }
    
    if(callDispoMap.isEmpty()) return;//just in case
    
    //Begin qualifying tasks
    for(Task newTask : trigger.new) {
        if(newTask.CallDisposition != null && newTask.Subject.Contains('Call')  
           && newTask.CallDisposition != '' && callDispoMap.keySet().contains(newTask.CallDisposition) 
           && newTask.Five9__Five9AgentExtension__c != null && newTask.Five9__Five9AgentExtension__c != '') {
            if(newTask.WhoId != null && String.valueOf(newTask.WhoId).startsWith(leadPrefix)) {
                tasksForLeadUpdates.add(newTask);
                //Test
                System.debug('newTask.CallDisposition: ' + newTask.CallDisposition);
                if(newTask.CallDisposition.ContainsIgnoreCase('Attempt')) {
                    leadIdsForIncrement.add(newTask.WhoId);
                }
            }
            if(newTask.WhatId != null && String.valueOf(newTask.WhatId).startsWith(optyPrefix)) {
                   tasksForOptyUpdates.add(newTask);
            }
        }
    }
    
    System.debug('leadIdsForIncrement: ' + leadIdsForIncrement);
    Map<Id, Lead> leadDataMap = new Map<Id, Lead>();
    if(!leadIdsForIncrement.isEmpty()) {
        for(Lead l : [SELECT Id, Call_Attempt__c FROM Lead WHERE Id IN: leadIdsForIncrement]) {
            leadDataMap.put(l.Id, l);
        }
    }
    System.debug('leadDataMap: ' + leadDataMap);
    
    //finally loop through leads/tasks, update lead field with status and add to list for dml
    if(tasksForLeadUpdates != null && !tasksForLeadUpdates.isEmpty()) {
        for(Task t : tasksForLeadUpdates) {
            for(String s : callDispoMap.keySet()) {
                if(s == t.CallDisposition) {
                    Lead l = new Lead(Id = t.WhoId);
                    l.Status = callDispoMap.get(s).Lead_Status__c;
                    l.Reason__c = callDispoMap.get(s).Reason__c;
                    
                    if(!leadDataMap.isEmpty() && leadDataMap.containsKey(t.WhoId)) {
                        System.debug('match');
                        if(leadDataMap.get(t.WhoId).Call_Attempt__c != null) {
                        System.debug('leadDataMap.get(t.WhoId).Call_Attempt__c = ' + leadDataMap.get(t.WhoId).Call_Attempt__c);
                            l.Call_Attempt__c = (leadDataMap.get(t.WhoId).Call_Attempt__c + 1);
                        } else {
                            l.Call_Attempt__c = 1;
                        }
                    }                  
                    
                    if(callDispoMap.get(s).Trigger_Eloqua_Follow_Up__c != null && callDispoMap.get(s).Trigger_Eloqua_Follow_Up__c != false) 
                        l.Fourth_follow_up__c = callDispoMap.get(s).Trigger_Eloqua_Follow_Up__c;
                    if(callDispoMap.get(s).Trigger_No_Contact_Activities__c != null && callDispoMap.get(s).Trigger_No_Contact_Activities__c != false)
                        l.Fifth_follow_up__c = callDispoMap.get(s).Trigger_No_Contact_Activities__c;
                    if(callDispoMap.get(s).Consultation_Type__c != null)
                        l.Consultation_Type__c = callDispoMap.get(s).Consultation_Type__c;
                    leadsToUpdate.add(l);
                }
            }
        }
    }
    
    //finally loop through leads/tasks, update lead field with status and add to list for dml
    if(tasksForOptyUpdates != null && !tasksForOptyUpdates.isEmpty()){
        for(Task t : tasksForOptyUpdates) {
            for(String s : callDispoMap.keySet()) {
                if(s == t.CallDisposition) {
                    Opportunity  O = new Opportunity(Id = t.WhatId);
                    o.StageName = callDispoMap.get(s).Lead_Status__c;
                    o.Reason_Won_Lost__c = callDispoMap.get(s).Reason__c;
                    if(o.StageName =='Opportunity Lost') {
                    o.closeDate = system.today();
                    }
                    OptyToUpdate.add(o);
                }
            }
        }
    }
    
    //finish with dml
    if(!leadsToUpdate.isEmpty()) {
        update leadsToUpdate;
    }
     //finish with dml opty
    if(!OptyToUpdate.isEmpty()) {
        update OptyToUpdate;
    }
}