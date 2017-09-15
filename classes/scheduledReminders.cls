global class scheduledReminders implements Schedulable{ 
    //Start for case # 00062001
    //private List<EmailTemplate> lstemailTemp = new List<EmailTemplate>([select Id,body, DeveloperName from EmailTemplate  where DeveloperName = 'Reminder_Contract_Approval_Email' and isActive = true]); 
    
    //Case #00180002 - Below variable is not used as related code has been moved to another class scheduledReminders1
    private Id Reminder_Contract_Approval_EmailId; 
    
    private Id PDF_Notification_newId;
    //End for case # 00062001
    global void execute(SchedulableContext SC) {
        executeFunction();   
    }
     
    public void executeFunction(){
    
       //Start for case # 00158641
        OpportunityRoleWorkflowActivate();
        //End for case # 00158641  
        
       //Start for case # 00195877
        InterconnectionApplnWorkflowActivate(); 
       //End for case # 00195877 
        //Start for case # 00062001
        getEmailTemplate();     
        SendEmailNotificationForEInvoice();
        //End for case # 00062001
        //Get the prefix of OpportunityRole object    
        String preFix = Opportunity_Role__c.SObjectType.getDescribe().getKeyPrefix();   
        
           
       /** START - Case#00180002 - Commneted below code as this has been moved to another class scheduledReminders1.
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
                Messaging.sendEmail(mailList);    
            }
        }
        //END - Case#00180002 - Commneted below code as this has been moved to another class scheduledReminders1. 
        **/ 
        
        
        //for case # 00040489
        /*Date currentDate = system.today();      
        List<Case> caseList = [Select P30_Reminder__c,P5_Reminder__c,Subject, OwnerId, Owner.Email, P30_Reminder_Date__c,P5_Reminder_Date__c,
            P5_Acknowledgement__c, P30_Acknowledgement__c,P30_Maturity_Date__c, P5_Maturity_Date__c,
            IsClosed, CaseNumber, Case_Age_Days__c From Case where (P5_Reminder__c = false or P30_Reminder__c = false) and
            (P5_Acknowledgement__c = false or (P5_Acknowledgement__c = true and P30_Acknowledgement__c = false))
            and IsClosed = false and Case_Age_Days__c > 0 and Case_Age_Days__c < 60 and P1_Notification_Email__c = True
            and Type ='Customer Complaint' and (P5_Reminder_Date__c <= :currentDate or P30_Reminder_Date__c <= :currentDate)
            and (P5_Maturity_Date__c >= :currentDate or P30_Maturity_Date__c >= :currentDate)];
            
        for(Case c:caseList){
            if(c.P5_Reminder_Date__c <= currentDate && c.P5_Maturity_Date__c >= currentDate){
                c.P5_Reminder__c = true;
                //c.P5_Reminder_Date__c = system.today()+1;DateCalculationUtility.getWorkingDay(system.today(), 1)
                c.P5_Reminder_Date__c = DateCalculationUtility.getWorkingDay(system.today(), 1);
            }
            else if(c.P30_Reminder_Date__c <= currentDate && c.P30_Maturity_Date__c >= currentDate){
                c.P30_Reminder__c = true;
                //c.P30_Reminder_Date__c = system.today()+7;
                c.P30_Reminder_Date__c = DateCalculationUtility.getWorkingDay(system.today(), 7);
            }
        }   
        update caseList;*/
        //for case # 00040489
        
        //Case#00077646
        //Ensure all commercial opportunities are populated with right CRSM
        oppCRSMUpdate();        
    }
    
    //Case#00077646
    //Ensure all commercial opportunities are populated with right CRSM
    public void oppCRSMUpdate(){
        List<Opportunity> lstOpp = new List<Opportunity>();       
        lstOpp = [Select id,CRSM__c,partnerAccountID,partnerAccount.CRSM__c,recordtypeID,recordtype.name, Days_Financing_Submitted_Option_Prov__c, Financing_Options_Provided_date__c 
                                                         from opportunity where 
                                                         (CRSM__c=null and partnerAccount.CRSM__c!=null and recordtype.name='Commercial') 
                                                         or ((Days_Financing_Submitted_Option_Prov__c=3 or Days_Financing_Submitted_Option_Prov__c=10) and Financing_Options_Provided_date__c=null)];
        
        
        if(lstOpp.size()==0){
            return;
        }
        
        //Same is done on opportunity trigger
        for(Opportunity opp : lstOpp){
            if(opp.CRSM__c==null && opp.partnerAccountID!=null && opp.partnerAccount.CRSM__c!=null && opp.recordtypeID!=null && opp.recordtype.name=='Commercial'){
                opp.CRSM__c = opp.partnerAccount.CRSM__c;
            }
            //Start 00105838
            //Setting field true will send alert through the workflow rule
            if((opp.Days_Financing_Submitted_Option_Prov__c==3 || opp.Days_Financing_Submitted_Option_Prov__c==10) && opp.Financing_Options_Provided_date__c==null){
                opp.Send_Financing_Alert__c = true;
            }
            //End 00105838
        }
        
        //Updated info
        update lstOpp;
    }  
    
    //Start for case # 00062001
    public void getEmailTemplate() {
        for(EmailTemplate eTemp : [select Id, DeveloperName from EmailTemplate  where DeveloperName in ('Reminder_Contract_Approval_Email','PDF_Notification_new') and isActive = true]){
            if(eTemp.DeveloperName == 'Reminder_Contract_Approval_Email')
            // Case # 00180002- below variable is not used in this class as related functionality has been moved to another class schedulereminders1
                Reminder_Contract_Approval_EmailId = eTemp.Id;
            else if(eTemp.DeveloperName == 'PDF_Notification_new')
                PDF_Notification_newId = eTemp.Id;
        }
            
    }
    
    //For Case # 00158641 ------------------------------------- 
        public void OpportunityRoleWorkflowActivate() 
        { 
            List<Opportunity_Role__c> lstOppR = new List<Opportunity_Role__c>(); 
            Opportunity_Role__c OppR = new Opportunity_Role__c(); 
            //Date currentDate = System.Today(); 

            //List<Opportunity_Role__c> lstOppRfet = [Select Id, DRC_Alert_Date__c, Opportunity_Stage__c, Contract_Status__c FROM Opportunity_Role__c Where Id =: OppR.Id]; 
            for (Opportunity_Role__c FOpp : [Select Id, DRC_Alert_checkbox__c, DRC_Alert_Date__c, Opportunity_Stage__c, Contract_Status__c FROM Opportunity_Role__c Where Contract_Status__c = 'Approved' AND (Opportunity_Stage__c != 'Closed Lost' OR Opportunity_Stage__c != 'Closed Won') AND DRC_Alert_Date__c =: System.Today()]) 
            { 
                FOpp.DRC_Alert_checkbox__c = True; 
                lstOppR.add(FOpp); 
            } 
            if(!lstOppR.isempty()){ 
            update lstOppR; 
            } 
        } 
// End Case # 00158641 ------------------------------------
    
    
    //For Case # 00195877 ------------------------------------- 
    public void InterconnectionApplnWorkflowActivate() 
        { 
            List<Interconnection_Application__c > lstIApp = new List<Interconnection_Application__c >(); 
                      
            for (Interconnection_Application__c Inapp : [SELECT Begin_Inspection_PTO_Activities_on__c,Id,Trigger_Workflow__c FROM Interconnection_Application__c WHERE Begin_Inspection_PTO_Activities_on__c =: System.Today() AND Trigger_Workflow__c = False]) 
            { 
                Inapp.Trigger_Workflow__c = True; 
                lstIApp.add(Inapp); 
            } 
            if(!lstIApp.isempty()){ 
            update lstIApp; 
            } 
        } 
        //End Case # 00195877 ------------------------------------- 
        
   public void SendEmailNotificationForEInvoice()
    {
        //check flag that this feature is enabled or not through custom setting                 
        List<SOAEmailNotification__c> soaEmailNotifications = SOAEmailNotification__c.getall().values();//Check the Custom Settings
        if(!soaEmailNotifications.isEmpty() && !soaEmailNotifications[0].IsExecuteTrigger__c)//If conditions do not meet terminate the operation 
            return ;
         List<SOA2TransactionDetails__c> lstSOATransDetails = new List<SOA2TransactionDetails__c>();   // custom field need to be update
        List<EmailRecipient__c> lstSOAEmlRes = new List<EmailRecipient__c>();//Email receipient record to be inserted
        for(Account acc: [SELECT id, name, 
                                 (SELECT Id, Communication_Sent__c, Partner__c 
                                  FROM SOA2TransactionDetails__r 
                                  WHERE Mail_Sent__c = 1 AND 
                                        Communication_Sent__c = false AND  
                                        Partner__r.Send_PDF_Notification__c = true AND 
                                        Partner__r.Theater__c != 'Australia'), 
                                 (SELECT Contact.Partner_Portal_User__r.Email, Contact.Email, 
                                         ContactId, AccountId 
                                  FROM AccountContactRoles 
                                  WHERE Role = 'Finance Manager' AND 
                                        Contact.Terminated__c = false AND 
                                        Contact.Partner_Portal_User__r.IsActive = true AND 
                                        Contact.Active_Partner_Portal_User__c = 'Yes' AND 
                                        Account.Send_PDF_Notification__c = true AND 
                                        Account.Theater__c != 'Australia') 
                          FROM Account 
                          WHERE IsPartner = true AND  
                                Status__c = 'Active'])
        {
            List<SOA2TransactionDetails__c> lstSOADetails = acc.SOA2TransactionDetails__r;//List of Related SOA2 Transaction details
            List<AccountContactRole> lstAccContRole = acc.AccountContactRoles;//List of Account Contact Roles
            if(!lstSOADetails.isEmpty() && !lstAccContRole.isEmpty())
            {
                 List<EmailRecipient__c> lstSOAEmlResTemp = new List<EmailRecipient__c>();
                
                for(SOA2TransactionDetails__c soaD: lstSOADetails)//Iterate SOA2Details
                {
                    for(AccountContactRole acr: lstAccContRole)//Iterate ContactRole
                    {
                      
                     lstSOAEmlResTemp.add(new EmailRecipient__c(SOA2TransactionDetail__c= soaD.Id,
                                                                                  Contact__c= acr.ContactId,
                                                                                  Contact_Email__c= acr.Contact.Email,
                                                                                  Communication_Sent__c= False));
                                                                                
                       
                    }//End for
                    
                    lstSOATransDetails.add(new SOA2TransactionDetails__c (Id = soaD.Id,Communication_Sent__c= True));
                   
                }//End for
                
                if((lstSOAEmlRes.size() + lstSOAEmlResTemp.size()) <= 10000)//Code block added to avoid the DML Governers Limit
                    lstSOAEmlRes.addAll(lstSOAEmlResTemp);
            }//End if
        }//End for
        
        if(!lstSOAEmlRes.isEmpty() && lstSOAEmlRes.size() <= 10000)
            insert lstSOAEmlRes;
        if(!lstSOATransDetails.isEmpty() && lstSOATransDetails.size() <= 10000)
         update lstSOATransDetails;     
    }//End Func SendEmailNotificationForEInvoice
    
    //End for case # 00062001
}