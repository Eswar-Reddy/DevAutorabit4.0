// Created this class for the Case # 00180002 to seperate this email notification for Contract Approval email to be sent from daily to twice a week.
global class scheduledReminders1 implements Schedulable{ 
    
    private Id Reminder_Contract_Approval_EmailId;
    //private Id PDF_Notification_newId;
    //End for case # 00062001
    global void execute(SchedulableContext SC) {
        executeFunction();   
    }
     
    public void executeFunction(){
        //Start for case # 00062001
        getEmailTemplate();     
        
        String preFix = Opportunity_Role__c.SObjectType.getDescribe().getKeyPrefix();   
        
        //Prepare the set of those opportunityRole IDs for which approval process is pending        
        Set<String> setOpportunityRoleIDs = new Set<String>();    
        Map<String,String> mapProcessTarget = new Map<String,String>();    
        for(ProcessInstance pi : [Select id,targetObjectID from ProcessInstance where status='Pending']){        
            //Check if targetObjectID is of Opportunity Role        
            if(pi.targetObjectID!=null && String.valueof(pi.targetObjectID).startsWith(preFix)){  
                setOpportunityRoleIDs.Add(pi.targetObjectID);            
                mapProcessTarget.put(pi.ID,pi.targetObjectID);        
            }    
        }        
        //Sent reminders for those which are pending more tha    
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();    
        Date oneDayPredate = Date.Today().addDays(-1);    
        ReminderEmailAddress__c reminder = ReminderEmailAddress__c.getOrgDefaults();
        List<Contact> contacts = new List<Contact>([Select id, Email from Contact where Email =: reminder.Email__c]);
        
        if (contacts.isEmpty()){
            Contact cont = new Contact();
            cont.LastName = 'Dummy Contact';
            cont.Email = reminder.Email__c;
            insert cont;
            contacts.Add(cont);
        }
        if(Reminder_Contract_Approval_EmailId!=null){  
            //Start 00094939 
            Map<ID,Opportunity_Role__c> mapDRCApprovalOppRole = new Map<ID,Opportunity_Role__c>([Select id,recordtype.name from Opportunity_Role__c where id in :setOpportunityRoleIDs and recordtype.name='DRC Approval']);
            //End 00094939 
            for(ProcessInstanceWorkItem ppWI : [select id,actorID,actor.Email,processInstanceID,processInstance.targetObjectID from ProcessInstanceWorkItem where processInstance.targetObjectID in :setOpportunityRoleIDs and createdDate < :oneDayPredate and isDeleted=false]){                    
                //Start 00094939 - Skip mails for 'DRC Approval' Opportunity Roles
                if(mapDRCApprovalOppRole.containsKey(ppWI.processInstance.targetObjectID)){
                    continue;
                }
                //End 00094939
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
                mail.targetObjectID = contacts.get(0).ID;
                String[] toAddress = new String[]{ppWI.actor.Email};
                mail.SetToAddresses(toAddress );
                mail.SetWhatID(ppWI.processInstance.targetObjectID);           
                mail.saveAsActivity = false; 
                //mail.TemplateID = lstemailTemp.get(0).Id; //for case # 00062001 
                mail.TemplateID = Reminder_Contract_Approval_EmailId;//for case # 00062001
                
                mail.setSenderDisplayName('SunPower Corporation');
                mailList.Add(mail);    
            }        
        }
        
        //Send Email    
        if(mailList.size()>0){   
            //Mail should be sent only from production 
            if(userinfo.getorganizationID().contains('00D80000000ZF1L')){
                if(!Test.isRunningTest()) //Added for Case#00209658 : Single Email Limit Reached while deployment    
                    Messaging.sendEmail(mailList);    
            }
        }  
     }
    
  
    //Start for case # 00062001
    public void getEmailTemplate() {
        for(EmailTemplate eTemp : [select Id, DeveloperName from EmailTemplate  where DeveloperName in ('Reminder_Contract_Approval_Email','PDF_Notification_new') and isActive = true]){
            if(eTemp.DeveloperName == 'Reminder_Contract_Approval_Email')
                Reminder_Contract_Approval_EmailId = eTemp.Id;
            //else if(eTemp.DeveloperName == 'PDF_Notification_new')
             //   PDF_Notification_newId = eTemp.Id;
        }
   }
 
}