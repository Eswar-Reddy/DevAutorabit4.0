/**********************************************************************
Class                   :   InlineActivityOnObject
Desciption              :   Controller apex class for vf page InlineActivityOnOpportunity,InlineActivityOnAccount,InlineActivityOnContact.
************************************************************************/

public with Sharing class InlineActivityOnObject{

      public String objectId{get;set;}
      public List<Task> lstTask {get;set;}
      public List<Event> lstEvent {get;set;}
      public List<Opportunity> opps{get;set;}
      public List<Account> acts{get;set;}
      public List<Contact> conts{get;set;}
      public String urlStr{get;set;}  
      public boolean listpanel {get;set;}
      public String EditRecordId{get;set;}
      public String closeTaskId{get;set;}
      public string DeleteRecId{get;set;}
      public string PreFix{get;set;}
      public string opportunityPreFix{get;set;}
      public string AccountPreFix{get;set;}
      public string contactPreFix{get;set;}
      public boolean isRefresh{get;set;}
      public List<Activities> lstActivities {get;set;}
      public boolean accessToDelete{get;set;}
      

      public InlineActivityOnObject(ApexPages.StandardController InlineTask){
          isRefresh = false;    
          accessToDelete = true;
      
          //Current Opportunity record       
          objectId = ApexPages.currentPage().getParameters().get('ID');   
         
          //For Identify the Object
          if(objectId!=null){
              opportunityPreFix = Opportunity.SObjectType.getDescribe().getKeyPrefix();
              AccountPreFix = Account.SObjectType.getDescribe().getKeyPrefix();
              contactPreFix = Contact.SObjectType.getDescribe().getKeyPrefix();              
              preFix = objectId.subString(0,3);
          }
         
          lstActivities = new List<Activities>();
          lstTask = new List<Task>();
          lstEvent = new List<Event>();
          
          //Get the record of Task and Event for Opportunity and Account
          if(PreFix == opportunityPreFix  || PreFix == AccountPreFix )
          {           
            lstTask = [SELECT Id,IsClosed,RecordType.Name,WhatId,Who.Name,Subject,Status,Priority,Owner.Name,ActivityDate FROM Task where WhatId=:objectId and RecordType.Name ='Task visible to everyone' order by IsClosed];
            lstEvent =[SELECT Id, RecordType.Name,Who.Name,WhatId, Subject,Owner.Name FROM Event where WhatId=:objectId and RecordType.Name ='Event visible to everyone'];
          }
          //Get the record of Task and Event for Contact
         else if(PreFix == contactPreFix)
         {
            lstTask = [SELECT Id,IsClosed,RecordType.Name,WhatId,Who.Name,WhoId,Subject,Status,Priority,Owner.Name,ActivityDate FROM Task where WhoId=:objectId and RecordType.Name ='Task visible to everyone' order by IsClosed];
            lstEvent = [SELECT Id, RecordType.Name,Who.Name,WhoId,WhatId, Subject,Owner.Name FROM Event where WhoId=:objectId and RecordType.Name ='Event visible to everyone'];
         } 
          //Select Task records
          
          for(Task t: lstTask){            
              Activities act = new Activities();
              act.activityId= t.Id;
              act.Name = t.Who.Name;
              act.Subject = t.Subject; 
              act.OwnerName = t.Owner.Name;
              act.isTask = true;
              act.isClosed = t.IsClosed;
              lstActivities.Add(act);
              
          }
          //Select Event records
          for(Event e: lstEvent){
              Activities act = new Activities();
              act.activityId= e.Id;
              act.Name = e.Who.Name;
              act.Subject = e.Subject;  
              act.OwnerName = e.Owner.Name;  
              act.isTask = False;               
              lstActivities.Add(act);
          }               
          
         //Display message if list not conatins record        
         if(lstActivities.size()>0 && lstActivities.size()!=null ){
            listpanel = true;           
         }
         else{
           listpanel = false;           
         }      
         //opps=[Select Id,Name,AccountId from Opportunity where id=:objectId ];
         
         opps = new List<Opportunity>(); 
         acts = new List<Account>();
         conts = new List<Contact>();
         
         if(PreFix == opportunityPreFix){
         for(Opportunity op :[Select Id,Name,AccountId from Opportunity where id=:objectId ]){
             opps.add(op);
         }
         }
         else if(PreFix == AccountPreFix)
         {
          for(Account ac :[Select Id,Name from Account where id=:objectId ]){
             acts.add(ac);
          }
         }
         else if(PreFix == contactPreFix)
         {
           for(Contact ct :[Select Id,Name,AccountId from Contact where id=:objectId ]){
             conts.add(ct);
          }
         }
      } 
     
     //Action function called from button 'New Task' on page 'InlineTaskOnOpportunity'.      
      public PageReference newTask(){     
      //when New Task created from Opportunity
      if(PreFix == opportunityPreFix)
      {      
         if(opps.size()>0 && opps[0].AccountId !=null)
         {      
           urlStr= '/setup/ui/recordtypeselect.jsp?ent=Task&retURL=/'+ opps[0].Id +'&save_new_url=' + EncodingUtil.urlEncode('/00T/e?who_id='+ opps[0].AccountId + '&what_id='+ opps[0].Id  + '&retURL=/'+ opps[0].Id, 'UTF-8');        
         }
         else
         {
          urlStr= '/setup/ui/recordtypeselect.jsp?ent=Task&retURL=/'+ opps[0].Id +'&save_new_url=' + EncodingUtil.urlEncode('/00T/e?who_id='+ opps[0].Id + '&what_id='+ opps[0].Id  + '&retURL=/'+ opps[0].Id, 'UTF-8');        
         }         
        
      }
       //when New Task created from Account
      else if(acts.size()>0 && PreFix == AccountPreFix)
      {
          urlStr= '/setup/ui/recordtypeselect.jsp?ent=Task&retURL=/'+ acts[0].Id +'&save_new_url=' + EncodingUtil.urlEncode('/00T/e?who_id='+ acts[0].Id + '&what_id='+ acts[0].Id  + '&retURL=/'+ acts[0].Id, 'UTF-8');        
      }
      //when New Task created from Contact
      else if(conts.size()>0 && PreFix == contactPreFix)
      {
          urlStr= '/setup/ui/recordtypeselect.jsp?ent=Task&retURL=/'+ conts[0].Id +'&save_new_url=' + EncodingUtil.urlEncode('/00T/e?who_id='+ conts[0].Id + '&what_id='+ conts[0].Id  + '&retURL=/'+ conts[0].Id, 'UTF-8');        
      }
      return null;
     }
            
     //Action function called from button 'New event' on page 'InlineTaskOnOpportunity'.
     public PageReference newEvent(){
      //when New Event created from Opportunity
      if(opps.size()>0 && PreFix == opportunityPreFix)
      {
       if(opps[0].AccountId !=null){      
         urlStr = '/setup/ui/recordtypeselect.jsp?ent=Event&retURL=/' +opps[0].Id+ '&save_new_url='+EncodingUtil.urlEncode('/00U/e?who_id=' +opps[0].AccountId + '&what_id='+opps[0].Id+ '&retURL='+ opps[0].Id, 'UTF-8');        
       }else{
         urlStr = '/setup/ui/recordtypeselect.jsp?ent=Event&retURL=/' +opps[0].Id+ '&save_new_url='+EncodingUtil.urlEncode('/00U/e?who_id=' +opps[0].Id + '&what_id='+opps[0].Id+ '&retURL='+ opps[0].Id, 'UTF-8');        
       }
      }
       //when New Event created from Account
      else if(acts.size()>0 && PreFix == AccountPreFix)
      {
         urlStr = '/setup/ui/recordtypeselect.jsp?ent=Event&retURL=/' + acts[0].Id + '&save_new_url='+EncodingUtil.urlEncode('/00U/e?who_id=' + acts[0].Id + '&what_id='+acts[0].Id+ '&retURL='+ acts[0].Id, 'UTF-8');        
      }
       //when New Event created from Contact
      else if(conts.size()>0 && PreFix == contactPreFix)
      {
        urlStr = '/setup/ui/recordtypeselect.jsp?ent=Event&retURL=/' + conts[0].Id+ '&save_new_url='+EncodingUtil.urlEncode('/00U/e?who_id=' + conts[0].Id + '&what_id='+conts[0].Id+ '&retURL='+ conts[0].Id, 'UTF-8'); 
      }
      return null;
     }
     
     //Action function called from link 'Edit' on page 'InlineTaskOnOpportunity'.   
     Public PageReference EditLink(){     
      if(opps.size()>0 && PreFix == opportunityPreFix)
      { 
        urlStr='/'+EditRecordId+'/e?retURL='+ opps[0].Id;     
      }
      else if(acts.size()>0 && PreFix == AccountPreFix)
      {
        urlStr='/'+EditRecordId+'/e?retURL='+ acts[0].Id;    
      }
      else if(conts.size()>0 && PreFix == contactPreFix)
      {
        urlStr='/'+EditRecordId+'/e?retURL='+ conts[0].Id;    
      }
      return null;
     }
     
     //Action function called when close the task from link 'Cls' on page 'InlineTaskOnOpportunity'.   
     Public PageReference CloseLink(){
      if(opps.size()>0 && PreFix == opportunityPreFix)
      {
         urlStr ='/'+closeTaskId+'/e?close=1&retURL='+opps[0].Id;
      }
      else if(acts.size()>0 && PreFix == AccountPreFix)
      {
         urlStr ='/'+closeTaskId+'/e?close=1&retURL='+acts[0].Id;
      }
      else if(conts.size()>0 && PreFix == contactPreFix)
      {
         urlStr ='/'+closeTaskId+'/e?close=1&retURL='+conts[0].Id;
      }
      return null;
     }
     
     //Action function called when delete the Event from link 'Del' on page 'InlineTaskOnOpportunity'.   
     Public PageReference DeleteEvent(){       
       Event ev = new Event(id=DeleteRecId);
       try{
           delete ev; 
           isRefresh= true;                                    
       }catch(Exception e){      
          accessToDelete = false;       
          return null;              
       }
        return null;      
     }
     
     //Wrapper class
     public class Activities{
        public String activityId{get;set;}
        public String Name{get;set;}
        public String Subject{get;set;}
        public string OwnerName{get;set;}
        public Boolean isTask{get;set;}
        public Boolean isClosed{get;set;}
         //constructor
         public Activities(){
             activityId ='';
             name = '';
             Subject ='';
             OwnerName='';
             isTask =false;
             isClosed =False;
         }
     }

}