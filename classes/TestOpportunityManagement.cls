public class TestOpportunityManagement{
  
  @isTest
  public static void checkOpportunityManagement1(){    
    List<User> lstUser = new List<User>();
    Account accObj;
    lstUser = [select Id, Name, Contact.AccountId from User where ContactId != null and IsActive =true Limit 1];
    if(lstUser.size() > 0){
      string AccountID = lstUser[0].Contact.AccountId;
      List<Account> lstAccount = [select Id, Assigned_PSR_IDS__c from Account where ID = :AccountID];
      if(lstAccount.size() > 0){
        accObj = lstAccount[0];
        accObj.Assigned_PSR_IDS__c = lstUser[0].Id;
        update accObj;
      }
    }
    
    Map<ID, Opportunity> newMap = new Map<ID, Opportunity>();
    Map<ID, Opportunity> oldMap = new Map<ID, Opportunity>();
    Opportunity oppObj = new Opportunity();
    oppObj.Name = 'testOpp';
    oppObj.StageName = '25% - Site Audit Completed';
    oppObj.CloseDate = Date.today();    
    insert oppObj;
    oldMap.put(oppObj.Id, oppObj);
    
    Opportunity newOpp = new Opportunity(Id = oppObj.Id);
    newOpp.Opportunity_Status__c = 'Active';
    if(lstUser.size() > 0){    
      newOpp.OwnerId = lstUser[0].Id;
    }
    newOpp.RSM_Email__c = 'test@testing.com';
    newOpp.StageName = '75% - Proposal/Price Quote';
    update newOpp;
    newMap.put(newOpp.Id, newOpp);
    
    OpportunityManagement testObj = new OpportunityManagement();    
    testObj.onOpportunityAfterUpdate(newMap, oldMap); 
    List<EmailTemplate> lstTemplate = new List<EmailTemplate>();
    lstTemplate = [select Id, DeveloperName from EmailTemplate Limit 1];
    if(lstTemplate.size() > 0){      
          
      //testObj.sendAlertToPSRUsersonAbondoned(newMap, lstTemplate[0].Id, new List<Messaging.Email>());
    }  
  }
  
  @isTest
  public static void checkOpportunityManagement(){
    try {
    List<User> lstUser = new List<User>();
    Account accObj;
    lstUser = [select Id, Name, Contact.AccountId from User where ContactId != null Limit 1];
    if(lstUser.size() > 0){
      string AccountID = lstUser[0].Contact.AccountId;
      List<Account> lstAccount = [select Id, Assigned_PSR_IDS__c from Account where ID = :AccountID];
      if(lstAccount.size() > 0){
        accObj = lstAccount[0];
        accObj.Assigned_PSR_IDS__c = lstUser[0].Id;
        update accObj;
      }
    }
     
    Opportunity oppObj = new Opportunity();
    oppObj.Name = 'testOpp';
    oppObj.StageName = '25% - Site Audit Completed';
    oppObj.CloseDate = Date.today();
    oppObj.RSM_Email__c = 'testEmail@gmail.com';
    if(lstUser.size() > 0){    
      oppObj.OwnerId = lstUser[0].Id;
    }   
    oppObj.Probability = 25; 
    insert oppObj;
    
    Map<Id, Task> oldMap = new Map<Id, Task>();
    Map<Id, Task> newMap = new Map<Id, Task>();
    
    Task taskObj = new Task();
    taskObj.WhatId = oppObj.Id;
    taskObj.status = 'Test';
    taskObj.subject = 'Test Task';
    insert taskObj; 
    oldMap.put(taskObj.Id, taskObj);
    
    Task newTask = new Task(Id = taskObj.Id);
    newTask.WhatId = oppObj.Id;
    newTask.status = 'Completed';
    newTask.subject = 'SCHEDULE A SITE VISIT';
    update newTask;
    newMap.put(newTask.Id, newTask);   
    
    OpportunityManagement.afterUpdateTask(newMap, oldMap);
     
    }
    catch(Exception ex){}   
  }
  //madhuri
  
  @isTest
  public static void onBeforeUpdateOpportunity(){
    try {
    List<User> lstUser = new List<User>();
    Account accObj;
    lstUser = [select Id, Name, Contact.AccountId from User where ContactId != null  Limit 1];
    if(lstUser.size() > 0){
      string AccountID = lstUser[0].Contact.AccountId;
      List<Account> lstAccount = [select Id, Assigned_PSR_IDS__c from Account where ID = :AccountID];
      if(lstAccount.size() > 0){
        accObj = lstAccount[0];
        accObj.Assigned_PSR_IDS__c = lstUser[0].Id;
        update accObj;
      }
    }
    List<Opportunity> oldOpp = new List<Opportunity>();
    List<Opportunity> newOpp = new List<Opportunity>();
    
    Opportunity oppObj = new Opportunity();
    oppObj.Name = 'testOpp';
    oppObj.StageName = '25% - Site Audit Completed';
    oppObj.CloseDate = Date.today();
    if(lstUser.size() > 0){    
      oppObj.OwnerId = lstUser[0].Id;
    }   
    oppObj.Probability = 25; 
    insert oppObj;
    oldOpp.add(oppObj);
    
    Opportunity newOppObj = new Opportunity(Id=oppObj.id);
    newOppObj.Name = 'testOpp';
    newOppObj.StageName = '75% - Proposal/Price Quote';
    newOppObj.CloseDate = Date.newInstance(1990,12,12);
    if(lstUser.size() > 0){    
      newOppObj.OwnerId = lstUser[0].Id;
    }   
    newOppObj.Probability = 25; 
    update newOppObj ;
    newOpp.add(newOppObj);
    
    OpportunityManagement opp = new OpportunityManagement();
    opp.onBeforeUpdateOpportunity(oldOpp,newOpp); 
    
    }
    catch(Exception ex){}   
  }
}