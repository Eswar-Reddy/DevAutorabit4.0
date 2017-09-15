public class ActivityManagement{

    // Done for Case # 00073934
    private static final String TASK_SUBJECT_CREATE_BINDING_OFFER = 'Create Binding Offer';
    private static final String TASK_SUBJECT_CREATE_NEW_BUDGETARY_OFFER = 'Create Budgetary Offer';
    private static final String TASK_SUBJECT_CREATE_QUALIFY_OFFER = 'Create Qualified Offer';
    // Done for Case # 00075210
    private static final String TASK_SUBJECT_NEGOTIATE_CONTRACT = 'Negotiate Contract'; 
    // Done for Case # 00084718
    private static final String TASK_SUBJECT_CREATE_QUAL_STATEMENT = 'Create Statement of Qualifications';
   
    //Method called After Task Updated
    public static void AfterTaskUpdate(List<Task> lstTaskNew, Map<ID,Task> mapOldTask)
    {   
       setTaskFields(lstTaskNew,mapOldTask);
       // Done for case # 00062214
       sendEmailToPSROwner(lstTaskNew,mapOldTask);         
       
       //case#00066819
       PSRSiteAuditUpdatedNotification(lstTaskNew);
       
       // Done for Case # 00081930
       sendEmailOnPSRTaskCompletion(lstTaskNew,mapOldTask);       
    }
    
    //Start for Case# 00074957
    public static void sendEmailtoContact(List<Task> lstTaskNew, Map<ID,Task> mapOldTask){   
        Id ssoTaskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SSO Task').getRecordTypeId();     
        Set<Id> taskContactIDs = new Set<Id>();           
        Set<Id> taskLeadIDs = new Set<Id>();                  
        List<Task> taskList = new List<Task>(); 
        Map<Id, Lead> leadMap = new Map<Id, Lead>();
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        
        String contactKeyPrefix = Contact.SObjectType.getDescribe().getKeyPrefix();
        String leadKeyPrefix = Lead.SObjectType.getDescribe().getKeyPrefix();
        String lcId;
        for(Task ts:lstTaskNew){     
            if(ts.Status != null && ts.Status == 'Completed' && ts.RecordTypeId == ssoTaskRecTypeId){
                if(mapOldTask != null && mapOldTask.get(ts.Id).Status != null && mapOldTask.get(ts.Id).Status == ts.Status) 
                    continue;            
                taskList.add(ts);
                lcId = ts.WhoId;
                if(lcId.contains(contactKeyPrefix)) 
                    taskContactIDs.add(ts.WhoId);
                if(lcId.contains(leadKeyPrefix)) 
                    taskLeadIDs.add(ts.WhoId);
            }
        }
        if(taskContactIDs.size() == 0 && taskLeadIDs.size() == 0) return;
        
        if(taskContactIDs.size() > 0){
            contactMap = new Map<Id,Contact>([select Id, Name, Email from Contact where id in :taskContactIDs and Email != null]); 
        }
        if(taskLeadIDs.size() > 0){
            leadMap = new Map<Id,Lead>([select Id, Name, Email from Lead where id in :taskLeadIDs and Email != null]); 
        }
        if(contactMap.size() == 0 && leadMap.size() == 0) return;
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        for(Task ts: taskList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddress = new List<String>();                
                lcId = ts.WhoId;
                String lcName;
                if(lcId.contains(contactKeyPrefix) && contactMap.get(lcId) != null){
                    toAddress.add(contactMap.get(lcId).Email);
                    lcName = contactMap.get(lcId).Name;
                }
                if(lcId.contains(leadKeyPrefix) && leadMap.get(lcId) != null){
                    toAddress.add(leadMap.get(lcId).Email);
                    lcName = leadMap.get(lcId).Name;
                }
                if(lcName != null){
                    mail.saveAsActivity=false;
                    mail.subject = ts.Subject;
                    String urlStg;
                    /*if(SalesforceOrgUtils.isProductionOrg()){
                        urlStg='https://login.salesforce.com/'+ts.Id;
                        toAddress.add('salesforcearchives@sunpowercorp.com');
                    }else{
                        urlStg='https://cs12.salesforce.com/'+ts.Id;
                        toAddress.add('jkothari@appirio.com');
                    }*/
                    
                    urlStg = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ts.Id;
                    if(urlStg.contains('na'))
                        toAddress.add('salesforcearchives@sunpowercorp.com');
                    else
                        toAddress.add('jkothari@sunpowercorp.com');
                        
                    mail.setToAddresses(toAddress);
                    mail.htmlBody = lcName + ', the following SSO Task has been completed:<br/><br/>Subject: '+ts.subject+'<br/>SSO Task Category: '
                        + ts.SSO_Task_Category__c +'<br/>SSO Sub-Category: '+ ts.SSO_Task_Sub_Category__c 
                        + '<br/><br/>For more details, click the following link:<br/><a href="'+urlStg+'">SSO Task Link</a>';
                    emailMessages.add(mail);    
                }
                system.debug('Step 5->'+mail);
        }
        if(emailMessages.size()>0)
            Messaging.sendEmail(emailMessages);
    }
    //End for Case# 00074957
    
    // Done for Case # 00073934
    //Method called Before Task Inserted
    public static void BeforeTaskInsert(List<Task> lstTaskNew)
    {          
       setTaskFieldsBeforeInsert(lstTaskNew);
    }  
    private static void setTaskFields(List<Task> lstTaskNew, Map<ID,Task> mapOldTask)
    {                  
        Map<ID,PSR__c> mappsrlst = new Map<ID,PSR__c>();
        String preFix=PSR__c.SObjectType.getDescribe().getKeyPrefix();                          
        //If PSR related task is completed then update completion date on PSR
        for(Task ts:lstTaskNew){        
            // Done for Case # 00073906 [Setting Site Audit Tracking on PSR to Side Audit Task : Tracking_Date]
            /* if(ts.Status =='Completed' && ts.PSR_ID__c!=null && mapOldTask.containsKey(ts.id) && ts.Status != mapOldTask.get(ts.id).Status){               
                PSR__c p = new PSR__c(id=ts.PSR_ID__c);
                p.Site_Survey_Completed__c =Date.Today();
                psrlst.Add(p);
            }*/
            
            if(ts.PSR_ID__c!=null && mapOldTask.containsKey(ts.id)){
                Boolean updatePsr = false;
                PSR__c p = new PSR__c(id=ts.PSR_ID__c);
                
                // Done for Case# 00080847
                if((ts.Status =='Completed' || ts.Status =='Cancelled' )&& ts.Status != mapOldTask.get(ts.id).Status){               
                    p.Site_Survey_Completed__c =Date.Today();
                    updatePsr = true;
                }               
                if(ts.Tracking_Date__c != null && ts.Tracking_Date__c != mapOldTask.get(ts.id).Tracking_Date__c){
                    p.Site_Audit_Tracking__c = ts.Tracking_Date__c;
                    updatePsr = true;
                }               
                
                if(updatePsr){
                    mappsrlst.put(p.id,p);                   
                }
            }            
            // End Case # 00073906.
            
            //Case#00075916 , Case # 00081929 
            if( (ts.activityDate != mapOldTask.get(ts.ID).ActivityDate || ts.Completed_Date__c != mapOldTask.get(ts.ID).Completed_Date__c 
                    || ts.Status != mapOldTask.get(ts.ID).Status ) 
                    && ts.whatID!=null && string.valueOf(ts.whatID).startsWith(preFix)){
                        
                  PSR__c ps = new PSR__c(id=ts.whatID);
                  
                  //List to update should not have multiple enteries for the same PSR
                  if(mappsrlst.containsKey(ps.ID)){
                        ps = mappsrlst.get(ps.ID);
                  }
                  
                  Boolean isUpdated = false;
                  if(ts.Subject == TASK_SUBJECT_CREATE_BINDING_OFFER){                      
                        ps.Binding_Offer_Task_Original_Due__c = ts.activityDate;
                        ps.Create_Binding_Offer_Task_Completed_Date__c = Date.valueOf(ts.Completed_Date__c);
                        ps.Create_Binding_Offer_Task_Status__c = ts.Status;
                        isUpdated = true;
                  }
                  else if (ts.Subject == TASK_SUBJECT_CREATE_NEW_BUDGETARY_OFFER){
                        ps.Budgetary_Offer_Task_Original_Due__c = ts.activityDate;
                        ps.Budgetary_Offer_Task_Completed_Date__c = Date.valueOf(ts.Completed_Date__c);
                        ps.Budgetary_Offer_Task_Status__c = ts.Status;
                        isUpdated = true;
                  }
                  else if(ts.Subject == TASK_SUBJECT_CREATE_QUALIFY_OFFER){
                        ps.Qualified_Offer_Task_Original_Due__c = ts.activityDate;
                        ps.Create_Qualified_Task_Completed_Date__c = Date.valueOf(ts.Completed_Date__c);
                        ps.Create_Qualified_Task_Status__c = ts.Status;
                        isUpdated = true;
                  }
                  else if(ts.Subject == TASK_SUBJECT_NEGOTIATE_CONTRACT){
                        ps.Negotiate_Contract_Task_Original_Due__c = ts.activityDate;
                        ps.Negotiated_Contact_Task_Completed_Date__c = Date.valueOf(ts.Completed_Date__c);
                        ps.Negotiated_Contact_Task_Status__c = ts.Status;
                        isUpdated = true;   
                  }  
                  //Case#00084718
                  //Map values for creat qualification statement Task
                  else if(ts.Subject == TASK_SUBJECT_CREATE_QUAL_STATEMENT){
                        ps.Statement_of_Qual_Task_Original_Due_Date__c = ts.activityDate;
                        ps.Statement_of_Quali_Task_Completed_Date__c = Date.valueOf(ts.Completed_Date__c);
                        ps.Statement_of_Qualifications_Status__c = ts.Status;
                        isUpdated = true;   
                  }
                  
                  if(!mappsrlst.containsKey(ps.ID) && isUpdated){
                        mappsrlst.put(ps.ID,ps);    
                  }                               
            }
        }               
         
        if(mappsrlst.values().size()>0){                         
            update mappsrlst.values(); 
        }     
    }
    
    // Done for case # 00062214
    private static void sendEmailToPSROwner(List<Task> lstTaskNew, Map<ID,Task> mapOldTask)
    {        
        List<Id> psrIDs = new List<Id>();
        List<Id> taskOwnerIDs = new List<Id>();                             
        List<Task> taskList = new List<Task>();                             
        
        Map<Id,PSR__c> PSRMap = new Map<Id,PSR__c>();        
        //If Site Audit Task Object Owner is changed. 
        for(Task ts:lstTaskNew){        
            if(ts.OwnerId != mapOldTask.get(ts.id).OwnerId && ts.PSR_ID__c != null){               
                psrIDs.Add(ts.PSR_ID__c);
                taskList.Add(ts);
                taskOwnerIDs.add(ts.ownerId);
            }
        }               
        
        if(psrIDs.size()>0){                         
            PSRMap = new Map<Id,PSR__c>([select id,name,OwnerId,Owner.Email,Site_Surveyor__c from PSR__c where id in :PSRIds]); 
            List<Messaging.Email> emailMessages = new List<Messaging.Email>();
            Map<Id,User> userMap = new Map<Id,User>([select id,name from User where id IN : taskOwnerIDs]);        
            
            for(Task ts: taskList){        
                
                // Done for Case # 00067526
                // Set the field "Site Auditor" on the PSR object to the New Owner of the Site Audit Task.              
                PSRMap.get(ts.PSR_ID__c).Site_Surveyor__c = ts.OwnerId;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if(PSRMap.get(ts.PSR_ID__c).Owner != null && PSRMap.get(ts.PSR_ID__c).Owner.Email != null){
                    List<String> psrOwners = new String[]{PSRMap.get(ts.PSR_ID__c).Owner.Email};
                    mail.setToAddresses(psrOwners);
                    mail.saveAsActivity=false;
                    mail.subject = 'Site Audit Owner Change - "'+ ts.subject + '"';
                    mail.plainTextBody = 'Hi,\n\nThe owner of the Site Audit "'+ts.subject+'" has been changed.\nThe new Owner of the Site Audit is: "'+ userMap.get(ts.OwnerId).name +'".\nRelated PSR: "'+ PSRMap.get(ts.PSR_ID__c).name + '".\n\nThanks,';
                    emailMessages.add(mail);   
                }
            }    
            
            if(emailMessages.size()>0)
                List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emailMessages);
            
            // Done for Case # 00067526                
            if(PSRMap.size() > 0){                
                update PSRMap.values();
            }
        }            
    }
    
    // Done for case # 00050334
    /* method to change the Task Record Type from default record type "Task visible to SunPower only"
       to "Task visible to everyone" when an email is sent using template of folder"PSR" */
    public static void changeTaskRecordType(List<Task> taskList){
        //Start 83101
        String postVisitSurveyPrefix = Post_Visit_Follow_Up_Survey__c.SObjectType.getDescribe().getKeyPrefix();
        //End 83101
        Map<String,Schema.RecordTypeInfo> taskRecordTypeMapByName = Schema.SObjectType.Task.getRecordTypeInfosByName();
        Set<String> subjectSet = new Set<String>();
        String str = '';
        for(EmailTemplate emailTemp : [Select Subject, Folder.Name From EmailTemplate where Folder.Name = 'PSR' and IsActive = true]){//for case #00064666          
            if(emailTemp.Subject!=null && emailTemp.Subject.indexOf('{') != -1 && emailTemp.Subject.indexOf('}') != -1){//for case #00064666
                str = emailTemp.Subject.substring(0,emailTemp.Subject.indexOf('{')) +
                             emailTemp.Subject.substring(emailTemp.Subject.indexOf('}') + 1);   
                subjectSet.add(str.trim());
             }else if(emailTemp.Subject!=null){//for case #00064666
                 subjectSet.add(emailTemp.Subject);
             }                
        }
        for (Task tsk : taskList) {
            for(String sub : subjectSet){
                if(tsk.Subject != null && tsk.Subject.startsWith('Email:') && tsk.Subject.contains(sub)){
                    tsk.RecordTypeId = taskRecordTypeMapByName.get('Task visible to everyone').getrecordtypeid();
                    break;
                }    
            }
            
            //Start 83101 set RecordtypeID
            if((tsk.whatID != null && String.valueOf(tsk.whatID).startsWith(postVisitSurveyPrefix)) && tsk.Subject != null && (tsk.Subject.contains('Invitation Scheduled') || tsk.Subject.contains('Invitation Sent'))){
                tsk.RecordTypeId = taskRecordTypeMapByName.get('Task visible to SunPower only').getrecordtypeid();
            }
            //End 83101
        }
    }
    //Start for case #00064666
    public static void updateCSATActivity(List<Task> taskList){
        String csatPrefix = Customer_Survey_Result__c.SObjectType.getDescribe().getKeyPrefix();   
        Set<Id> postVisitSurveyids = new Set<Id>(); 
        //Start 83101
        String postVisitSurveyPrefix = Post_Visit_Follow_Up_Survey__c.SObjectType.getDescribe().getKeyPrefix();
        //End 83101
        Set<Id> csatids = new Set<Id>();
        String country = '' ;
        String subject = '' ;
        String ivString = '' ; 
        System.debug('taskList->'+taskList);
        System.debug('csatPrefix->'+csatPrefix);
        for (Task tsk : taskList) {
            ivString = tsk.WhatId;
            if(tsk.Subject != null && tsk.Subject == 'Customer Survey Result - Survey email notification' 
                && tsk.Status !=null && tsk.Status == 'Completed' && ivString.contains(csatPrefix))
                    csatids.add(tsk.WhatId);
                    
            //Start 83101
            if((tsk.whatID != null && String.valueOf(tsk.whatID).startsWith(postVisitSurveyPrefix)) && tsk.Subject != null && (tsk.Subject.contains('Invitation Scheduled') || tsk.Subject.contains('Invitation Sent'))){
                postVisitSurveyids.add(tsk.whatID);
            }
            //End 83101
        }
        ivString ='';
        System.debug('csatids->'+csatids);
        Map<Id, Customer_Survey_Result__c> CSRMap = new Map<Id, Customer_Survey_Result__c>();
        if(csatids.size() > 0){
            List<Customer_Survey_Result__c> CSRList = [SELECT Id, Name, CreatedById, Partner_Account__c,Partner_Account__r.Name, Account1__r.BillingCountry, Opportunity_ID__c, Opportunity_ID__r.Theater__c, Account1__c, Contact__c,Contact__r.Name from Customer_Survey_Result__c where Id in :csatids];
            for(Customer_Survey_Result__c csr : CSRList){
                CSRMap.put(csr.Id, csr);
            }   
        }
        
        //Start 83101
        Map<Id, Post_Visit_Follow_Up_Survey__c> postVisitSurveyMap = new Map<Id, Post_Visit_Follow_Up_Survey__c>();
        if(postVisitSurveyids.size()>0){
            postVisitSurveyMap = new Map<Id, Post_Visit_Follow_Up_Survey__c>([Select id,Customer_Account__r.ownerID, Opportunity_ID__r.ownerID,Opportunity_ID__r.Theater__c, Customer_Account__r.BillingCountry from Post_Visit_Follow_Up_Survey__c where id in :postVisitSurveyids]);
        }
        //End 83101
        
        if(CSRMap.size() == 0 && postVisitSurveyMap.size() == 0) return;
        
        System.debug('Map->'+CSRMap);
        for(Task tsk : taskList){
            //Start 83101 set AssignedTo and DueDate(CreationDate of task)
            if(tsk.whatID != null && postVisitSurveyMap.containsKey(tsk.whatID) && postVisitSurveyMap.get(tsk.whatID).Opportunity_ID__r.ownerID!=null){
                tsk.OwnerId = postVisitSurveyMap.get(tsk.whatID).Opportunity_ID__r.ownerID;
                tsk.ActivityDate = System.today();                  
            }
            Post_Visit_Follow_Up_Survey__c pvfus = postVisitSurveyMap.get(tsk.WhatId);
            if(pvfus != null){
                if(pvfus.Opportunity_ID__r.Theater__c == 'Europe') {
                   if(pvfus.Customer_Account__r.BillingCountry == 'Germany'){
                       ivString='q38kvgv144lwy';
                   } else if(pvfus.Customer_Account__r.BillingCountry == 'France') {
                       ivString='b8x151kjqfuyg';
                   } else if(pvfus.Customer_Account__r.BillingCountry == 'Italy') {
                       ivString='3912c1793252c3e';
                   }
                }else if(pvfus.Customer_Account__r.BillingCountry == 'United States' || pvfus.Customer_Account__r.BillingCountry == 'United States of America') {
                   ivString='1pm3rdwpde2epa';
                }           
               tsk.Description = 'http://survey.sunpowercorp.com/go?iv='+ivString+'&q1='+pvfus.Id;
            }
            //End 83101          
            
            if(!csatids.contains(tsk.WhatId)) return;
            Customer_Survey_Result__c csr = CSRMap.get(tsk.WhatId);
            System.debug('csr->'+csr);
            if(csr.Opportunity_ID__r.Theater__c == 'Europe') {
               if(csr.Account1__r.BillingCountry == 'Germany'){
                   ivString='3b126e4fcce6cd8';
                   //subject = 'Sehr geehrte/r '+csr.Contact__r.Name+' bitte teilen Sie Ihre Erfahrungen mit '+csr.Partner_Account__r.Name;
               } else if(csr.Account1__r.BillingCountry == 'France') {
                   ivString='3912cacaaaa6966';
                   //subject = 'Madame/Monsieur, '+csr.Contact__r.Name+' Donnez-nous votre avis sur '+csr.Partner_Account__r.Name;
               } else if(csr.Account1__r.BillingCountry == 'Italy') {
                   ivString='391274485de6bf7';
                   //subject = 'Gentile '+csr.Contact__r.Name+' La preghiamo di raccontarci della Sua esperienza con '+csr.Partner_Account__r.Name;
               }
            }else if(csr.Opportunity_ID__r.Theater__c == 'Central America and the Caribbean' || csr.Opportunity_ID__r.Theater__c == 'North America') {
               ivString='3ls95x2ymjv8u'; //Updated for case#00203732
               //subject = csr.Contact__r.Name+', please tell us about your experience with'+csr.Partner_Account__r.Name;
            }           
           tsk.Description = 'http://survey.sunpowercorp.com/go?iv='+ivString+'&q1='+csr.Account1__c+'&q2='+csr.Contact__c+'&q3='+csr.Partner_Account__c+'&q4='+csr.Opportunity_ID__c;
           tsk.OwnerId = csr.CreatedById;                       
       }
    }
    //end for case #00064666
    
    
    
   //Case#00066819 
   public static void PSRSiteAuditUpdatedNotification(List<Task> taskList){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        Set<String> psrIds = new Set<String>();
        for(Task tsk : taskList){
            if(tsk.PSR_ID__c != null )
                psrIds.add(tsk.PSR_ID__c);
        }
        
        Map<Id,PSR__c> mapPSRs = new Map<Id,PSR__c>([SELECT Id,Name,Business_Unit__c,Site_Survey_Due__c FROM PSR__c WHERE Id = : psrIds ]);
        Boolean isPSRUpdated = false;
                
        for(Task tsk : taskList){
            
            if(tsk.PSR_ID__c != null &&  mapPSRs.containsKey((Id)tsk.PSR_ID__c)){
                if(mapPSRs.get((Id)tsk.PSR_ID__c).Business_Unit__c == 'UPP Intl'){                  
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setToAddresses(Label.PSRSiteAuditNotificationRecipients.split(','));
                    mail.saveAsActivity=false;
                    mail.subject = 'Site Audit has been modified for ' + mapPSRs.get((Id)tsk.PSR_ID__c).Name;
                    mail.plainTextBody = 'Hi,\n\nAssociated Site Audit ' + tsk.Subject + ' has been modified for this PSR.' + '\n\nThanks,';
                    emailMessages.add(mail); 
                }
                
                //Case#00068745  
                system.debug('-------tsk.ActivityDate!=null-----------'+tsk.ActivityDate);                
                if(tsk.ActivityDate!=null && mapPSRs.get((Id)tsk.PSR_ID__c).Site_Survey_Due__c != tsk.ActivityDate){
                    mapPSRs.get((Id)tsk.PSR_ID__c).Site_Survey_Due__c = tsk.ActivityDate;
                    isPSRUpdated = true;
                }
            }
        }
        if(emailMessages.size()>0)
                List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emailMessages);
        
        //Case#00068745  
        if(isPSRUpdated && mapPSRs.size() > 0){
                update mapPSRs.values();
        }
    }
    
    // Done for Case # 00073934 [Mapping Comment field on Task to Comments field on PSR]
    private static void setTaskFieldsBeforeInsert(List<Task> lstTaskNew)
    {
        Set<ID> psrIdSet = new Set<ID>();
        List<Task> taskList = new List<Task>();
        
        for(Task tsk : lstTaskNew){
            if(tsk.Subject == TASK_SUBJECT_CREATE_BINDING_OFFER
                || tsk.Subject == TASK_SUBJECT_CREATE_NEW_BUDGETARY_OFFER
                || tsk.Subject == TASK_SUBJECT_CREATE_QUALIFY_OFFER
                // Done for Case # 00075210
                || tsk.Subject == TASK_SUBJECT_NEGOTIATE_CONTRACT 
                //Case#00084718
                || tsk.Subject == TASK_SUBJECT_CREATE_QUAL_STATEMENT){
                
                psrIdSet.add(tsk.whatId);
                taskList.add(tsk);
            }
        }
        
        if(psrIdSet.size() > 0){
            ID PSRTaskRecordTypeId = null;
            PSRTaskRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('PSR Task').getRecordTypeId();
            // Done for Case # 00075210 [Mapping Comment field on Task to Negotiate_Contract_Comments__c on PSR]
            // Map<Id,PSR__c> psrMap = new Map<Id,PSR__c>([select id,Binding_Offer_Comments__c,Qualified_Offer_Comments__c,Budgetary_Offer_Comments__c from PSR__c where ID IN:psrIdSet]);
            Map<Id,PSR__c> psrMap = new Map<Id,PSR__c>([select id,Binding_Offer_Comments__c,Qualified_Offer_Comments__c,Budgetary_Offer_Comments__c,Negotiate_Contract_Comments__c,Statement_of_Qualifications_Comments__c,
                                                        Statement_of_Qual_Task_Original_Due_Date__c,Binding_Offer_Task_Original_Due__c,
                                                        //Start 00101941
                                                        Opportunity__c, Opportunity__r.Name,
                                                        //End 00101941
                                                        Budgetary_Offer_Task_Original_Due__c,Qualified_Offer_Task_Original_Due__c,Negotiate_Contract_Task_Original_Due__c from PSR__c where ID IN:psrIdSet]);
            
            for(Task ts : taskList){
                if(ts.Subject == TASK_SUBJECT_CREATE_BINDING_OFFER){
                    ts.Description = psrMap.get(ts.whatId).Binding_Offer_Comments__c;                    
                    //Case#00075916-Set due date default value as psr orginal data if its not null 
                    if(psrMap.get(ts.whatId).Binding_Offer_Task_Original_Due__c!=null)
                        ts.activityDate =  psrMap.get(ts.whatId).Binding_Offer_Task_Original_Due__c;                 
                }else if(ts.Subject == TASK_SUBJECT_CREATE_NEW_BUDGETARY_OFFER){
                    ts.Description = psrMap.get(ts.whatId).Budgetary_Offer_Comments__c;                 
                    //Case#00075916-Set due date default value as psr orginal data if its not null 
                    if(psrMap.get(ts.whatId).Budgetary_Offer_Task_Original_Due__c!=null)
                        ts.activityDate =  psrMap.get(ts.whatId).Budgetary_Offer_Task_Original_Due__c;
                }else if (ts.Subject == TASK_SUBJECT_CREATE_QUALIFY_OFFER){
                    ts.Description = psrMap.get(ts.whatId).Qualified_Offer_Comments__c;
                    //Case#00075916-Set due date default value as psr orginal data if its not null 
                    if(psrMap.get(ts.whatId).Qualified_Offer_Task_Original_Due__c!=null)
                        ts.activityDate =  psrMap.get(ts.whatId).Qualified_Offer_Task_Original_Due__c;
                }
                // Done for Case # 00075210
                else if (ts.Subject == TASK_SUBJECT_NEGOTIATE_CONTRACT){
                    ts.Description = psrMap.get(ts.whatId).Negotiate_Contract_Comments__c;
                    //Case#00075916-Set due date default value as psr orginal data if its not null 
                    if(psrMap.get(ts.whatId).Negotiate_Contract_Task_Original_Due__c!=null)
                        ts.activityDate =  psrMap.get(ts.whatId).Negotiate_Contract_Task_Original_Due__c;
                } 
                // Done for Case # 00084718
                else if (ts.Subject == TASK_SUBJECT_CREATE_QUAL_STATEMENT){
                    ts.Description = psrMap.get(ts.whatId).Statement_of_Qualifications_Comments__c;
                    //Case#00084718-Set due date default value as psr orginal data if its not null 
                    if(psrMap.get(ts.whatId).Statement_of_Qual_Task_Original_Due_Date__c!=null)
                        ts.activityDate =  psrMap.get(ts.whatId).Statement_of_Qual_Task_Original_Due_Date__c;
                }                               
                ts.RecordTypeId = PSRTaskRecordTypeId;
                //Start 00101941
                if(psrMap.get(ts.whatId).Opportunity__c != null)
                    ts.Opportunity_Name__c =  psrMap.get(ts.whatId).Opportunity__r.Name;
                //End 00101941
            }            
        }
    }
    
    //Start for Case # 00081930
    public static void sendEmailOnPSRTaskCompletion(List<Task> lstTaskNew, Map<ID,Task> mapOldTask){

        List<Task> taskList = new List<Task>();
        Set<Id> taskCreatedByIdSet = new Set<Id>(); 
        //Added condition for TASK_SUBJECT_CREATE_QUAL_STATEMENT under case#00087978
        for(Task ts:lstTaskNew){     
            if(ts.Status == 'Completed' && mapOldTask.get(ts.Id).Status != ts.Status && ts.Completed_Date__c != null
                && (ts.Subject == TASK_SUBJECT_CREATE_BINDING_OFFER || ts.Subject == TASK_SUBJECT_CREATE_NEW_BUDGETARY_OFFER 
                    ||ts.Subject == TASK_SUBJECT_CREATE_QUALIFY_OFFER || ts.Subject == TASK_SUBJECT_NEGOTIATE_CONTRACT
                    || ts.Subject == TASK_SUBJECT_CREATE_QUAL_STATEMENT) ){
             
                taskList.add(ts);
                taskCreatedByIdSet.add(ts.CreatedById);
            }
        }   
        
        if(taskList.size() == 0 && taskCreatedByIdSet.size() == 0)
            return;
        Map<Id,User> userMap = new Map<Id,User>();
        String userEmmanuelBarryEmail = '';
        for(User u: [select Id, Name, Email from User where (id in :taskCreatedByIdSet or Name = 'Emmanuel Barry' ) and Email != null]){
            userMap.put(u.Id,u);
            if(u.Name == 'Emmanuel Barry'){
                userEmmanuelBarryEmail = u.Email;
            }
        }
        
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        for(Task ts: taskList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new List<String>{userEmmanuelBarryEmail,userMap.get(ts.CreatedById).Email};
            mail.saveAsActivity=false;
            mail.subject = 'Task '+ ts.Subject + ' has been completed.';
           
            
            String urlStg;
               
                    
                    urlStg = URL.getSalesforceBaseUrl().toExternalForm()+'/'+ts.whatId;
                    if(urlStg.contains('na'))
                        toAddresses.add('salesforcearchives@sunpowercorp.com');
                    else
                        toAddresses.add('jkothari@sunpowercorp.com');
                        
            mail.setToAddresses(toAddresses);
            mail.htmlBody = 'Hi,<br/><br/> The following PSR Task - "' +ts.subject+'" has been completed.<br/><br/>For related PSR details, click on the following link: <a href="'+urlStg+'">PSR Detail</a><br/><br/>Thanks,';
            emailMessages.add(mail);    
        }
    if(emailMessages.size()>0)
        Messaging.sendEmail(emailMessages);
    }   
    //End for Case # 00081930
    
}