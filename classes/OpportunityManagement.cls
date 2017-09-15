/************************************************************
Class ::    OpportunityManagement
Author::    Appirio(Prakash G.)
Requester:: Bipin Nepani
PR::        PR-02115,1933
*************************************************************/

public class OpportunityManagement {
    String separator='~';
    Map<Id,Set<String>> allOpportunityPSRUsers= new Map<Id,Set<String>>();
/*
    Main Function call on Opportunity Trigger After Update
*/
    public void onOpportunityAfterUpdate(Map<ID,Opportunity> newMap, Map<ID,Opportunity> oldMap){
        /****************************
        System.debug('Eneres here::');
        Map<id,Opportunity> newFetchedOpps = new Map<ID,Opportunity>([select ID,OwnerId,Owner.UserType from Opportunity where id in :newMap.keySet()]);
        Map<String,ID> emailTemplates = new Map<String,ID>();
        Set<String> templates = new Set<String>();
        templates.add('OppStatusChanged_VF');
        templates.add('OppStageChanged_VF');
        templates.add('Opportunity_Activation_VF');
        templates.add('Opportunity_Abandoned_56_days_VF');
        templates.add('Opportunity_Abandoned_7_days_VF');
        templates.add('Opportunity_Abandoned_90_days_VF');
        
       // allOpportunityPSRUsers = getAllOpportunityPSRUserEmails(newMap.values());
        //Fetch Email Templates
        for(EmailTemplate eTemp:[select Id, DeveloperName from EmailTemplate 
            where name in :templates and isActive = true]){
                
                emailTemplates.put(eTemp.DeveloperName, eTemp.ID);
        }
        ***************************/
        /* ---------------------------------------------------- */        
        /* RWu - alerts commented in order to update Opportunity stage and status */
        /* ---------------------------------------------------- */
        /*****************************
        System.debug('Templates Size::'+emailTemplates.size());
        //Send Alert on Opportunity Status Changed
        //sendAlertOnOpportunityStatusChanged(emailTemplates,newMap,oldMap);
        System.debug('Send Alerts on Opportunity Status change called::');
        //Send Alert on Opportunity Stage Changed
        //sendAlertOnOpportunityStageChanged(emailTemplates,newMap,oldMap);
        //Send Alert when Oooportunity Abondoned by (7-days, 56-days , 90-days) To Assigned PSR Users       
        //sendAlertToAssignedPSRsonAbondoned(emailTemplates,newMap,oldMap,newFetchedOpps);
        //Send Alert when opportunity is activayed to the Assigned PSR Users 
        //sendAlertToAssignedPSRsonActive(emailTemplates,newMap,oldMap,newFetchedOpps);
        System.debug('Send Alerts on Opportunity Stage changed called::');
       *******************************/
    }
    /*
        Responsible for send Alert To PSR and RSM to Send Email when Status is chaged to:-
        ::Active
        ::ClosedXXXXX   
    */
   /* private void sendAlertOnOpportunityStatusChanged(Map<String,ID> emailTemplates,Map<ID,Opportunity> newMap, Map<ID,Opportunity> oldMap){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();

        Map<Id,Opportunity> filteredOpportunities = new Map<Id,Opportunity>();

        //IF status is change to Active /Closed-Lost /Closed-Won
        for(Opportunity opp:newMap.values()){
            if(opp.Opportunity_Status__c != null && opp.Opportunity_Status__c == 'Active' && opp.Opportunity_Status__c != oldMap.get(opp.Id).Opportunity_Status__c){
                filteredOpportunities.put(opp.id,opp);          
            }else if(opp.Opportunity_Status__c != null && (opp.Opportunity_Status__c.indexOf('Closed')>=0) && opp.Opportunity_Status__c != oldMap.get(opp.Id).Opportunity_Status__c){
                filteredOpportunities.put(opp.id,opp);          
            }
        }
        System.debug('filtered opportunities on Status Changed::'+ filteredOpportunities.size()); 
        Map<Id,Set<String>> oppAsignedPSRUsers = new Map<Id,Set<String>>();
        if(allOpportunityPSRUsers != null && allOpportunityPSRUsers.keySet() != null){
            for(ID oppid: allOpportunityPSRUsers.keySet()){
                if(filteredOpportunities.get(oppid) != null)
                    oppAsignedPSRUsers.put(oppid,allOpportunityPSRUsers.get(oppid));
            }
        } 
        //getOpportunityPSRUserEmails(filteredOpportunities);
        if(filteredOpportunities != null && filteredOpportunities.values() != null){
            for(Opportunity opp:filteredOpportunities.values()){
                    if(opp.RSM_Email__c != null && opp.RSM_Email__c != ''){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(emailTemplates.get('OppStatusChanged_VF'));
                        mail.setToAddresses(new String[] {opp.RSM_Email__c});
                        mail.setTargetObjectId(opp.ownerID);
                        mail.setWhatId(opp.id);
                        mail.saveAsActivity=false;
                        if(mail.getTemplateId()!=null)
                            emailMessages.add(mail);
                    }
                    if(oppAsignedPSRUsers != null && oppAsignedPSRUsers.get(opp.ID) != null){
                        for(String uEmail:oppAsignedPSRUsers.get(opp.ID)){
                            String []userEmail = uEmail.split(separator);
                            System.debug('Here the values::'+userEmail[0] + '::::'+userEmail[1]);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(new String[] {userEmail[1]});
                            mail.setTemplateId(emailTemplates.get('OppStatusChanged_VF'));
                            mail.setTargetObjectId(userEmail[0]);
                            mail.setWhatId(opp.id);
                            mail.saveAsActivity=false;
                            if(mail.getTemplateId()!=null)
                                emailMessages.add(mail);
                        }
                    }
            }
        }
        
        if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        }           
    } */      
   /* 
    private void sendAlertOnOpportunityStageChanged(Map<String,ID> emailTemplates,Map<ID,Opportunity> newMap, Map<ID,Opportunity> oldMap){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        Map<Id,Opportunity> filteredOpportunities = new Map<Id,Opportunity>();
        //IF status is change to Active /Closed-Lost /Closed-Won
        for(Opportunity opp:newMap.values()){
            if(opp.StageName != null && opp.StageName == '75% - Proposal/Price Quote' && opp.StageName != oldMap.get(opp.Id).StageName){
                filteredOpportunities.put(opp.id,opp);          
            }
        } 
        System.debug('filtered opportunities on Stage Changed::'+ filteredOpportunities.size());
        Map<Id,Set<String>> oppAsignedPSRUsers = new Map<Id,Set<String>>();
        if(allOpportunityPSRUsers != null && allOpportunityPSRUsers.keySet() != null){
            for(ID oppid: allOpportunityPSRUsers.keySet()){
                if(filteredOpportunities.get(oppid) != null)
                    oppAsignedPSRUsers.put(oppid,allOpportunityPSRUsers.get(oppid));
            }
        }
        if(filteredOpportunities != null &&  filteredOpportunities.values() != null){
            for(Opportunity opp:filteredOpportunities.values()){
                if(opp.RSM_Email__c != null && opp.RSM_Email__c != ''){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(emailTemplates.get('OppStageChanged_VF'));
                        mail.setToAddresses(new String[] {opp.RSM_Email__c});
                        mail.setWhatId(opp.id);
                        mail.saveAsActivity=false;
                        mail.setTargetObjectId(opp.ownerID);
                        if(mail.getTemplateId()!=null)
                            emailMessages.add(mail);
                    }
                    if(oppAsignedPSRUsers != null && oppAsignedPSRUsers.get(opp.ID)!= null){
                        for(String uEmail:oppAsignedPSRUsers.get(opp.ID)){
                            String []userEmail = uEmail.split(separator);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(new String[] {userEmail[1]});
                            mail.setTemplateId(emailTemplates.get('OppStageChanged_VF'));
                            mail.setTargetObjectId(userEmail[0]);
                            mail.setWhatId(opp.id);
                            mail.saveAsActivity=false;
                            if(mail.getTemplateId()!=null)
                                emailMessages.add(mail);
                        }
                    }
            }
        }
        System.debug('Email Messages Size::'+ emailMessages.size());
        if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        }           
    }*/
    //Fetch Assigned PSR Users emails by their PSRIds and return Map contain Opportunity Owner and Liust of their Users  
    public Map<Id,Set<String>> getOpportunityPSRUserEmails(List<Opportunity> oppList){
        Map<ID,List<String>>userAssignedPSR = new Map<ID,List<String>>();
        Map<Id,Set<String>> assignedUserEmails = new Map<Id,Set<String>>(); 
        Set<ID> assignedUserIDs = new Set<ID>();
        Set<ID> ownerIDs = new Set<ID>(); 
        System.debug('Enters in getOpportunityPSRUserEmails oppList::' + oppList.size());
        for(Opportunity opp:oppList){
            ownerIDs.add(opp.ownerID);
        }
        System.debug('Enters in getOpportunityPSRUserEmails ownerIds::' + ownerIDs);
        if(ownerIDs == null || ownerIDs.size()==0)
            return null;
        for(User u:[select id,Contact.Account.Assigned_PSR_IDS__c from User where id in:ownerIDs and ContactID != null]){
            if(u.Contact.Account.Assigned_PSR_IDS__c != null && u.Contact.Account.Assigned_PSR_IDS__c != ''){
                for(String  s: u.Contact.Account.Assigned_PSR_IDS__c.split('\\,')){
                    if(userAssignedPSR.get(u.ID)==null){
                        System.debug('Enters in getOpportunityPSRUserEmails loop user Added::' + s);
                        List<String> ul = new List<String>();
                        ul.add(s);
                        userAssignedPSR.put(u.id,ul);
                    }else{
                        userAssignedPSR.get(u.ID).add(s);
                    }
                    assignedUserIDs.add(s);
                }
            }                       
        }//ends of For loop
        for(User u:[select id,Email from User where id in:assignedUserIDs]){
            for(Opportunity opp:OppList){
                if(userAssignedPSR.get(opp.ownerID) == null) 
                    continue;
                for(String s:userAssignedPSR.get(opp.ownerID)){
                    System.debug('Enters in getOpportunityPSRUserEmails insside loop user Added::' + s + ' == ' + String.valueOf(u.ID));
                    if(s == String.valueOf(u.ID)){
                        if(assignedUserEmails.get(opp.ownerID) == null){
                            Set<String> strList = new Set<String>();
                            strList.add(u.ID+separator+u.Email);
                            assignedUserEmails.put(opp.ownerID,strList);
                         }else{
                            assignedUserEmails.get(opp.ownerID).add(u.ID+separator+u.Email);
                        }
                    }
                }
            }           
        }
        Map<ID,Set<String>> oppAsignedPSRUsers = new Map<ID,Set<String>>();
        for(Opportunity opp:oppList){
            if(assignedUserEmails != null && assignedUserEmails.get(opp.ownerID) != null)
                oppAsignedPSRUsers.put(opp.ID,assignedUserEmails.get(opp.ownerID));
        }
        System.debug('Here values return :::' + oppAsignedPSRUsers);
        return  oppAsignedPSRUsers; 
    }
    
    /*
        public Map<Id,Set<String>> getAllOpportunityPSRUserEmails(List<Opportunity> oppList){
        Map<ID,List<String>>userAssignedPSR = new Map<ID,List<String>>();
        Map<Id,Set<String>> assignedUserEmails = new Map<Id,Set<String>>(); 
        Set<ID> assignedUserIDs = new Set<ID>();
        Set<ID> ownerIDs = new Set<ID>(); 
        System.debug('Enters in getOpportunityPSRUserEmails oppList::' + oppList.size());
        for(Opportunity opp:oppList){
            ownerIDs.add(opp.ownerID);
        }
        System.debug('Enters in getOpportunityPSRUserEmails ownerIds::' + ownerIDs);
        if(ownerIDs == null || ownerIDs.size()==0)
            return null;
        for(User u:[select id,Contact.Account.Assigned_PSR_IDS__c from User where id in:ownerIDs and ContactID != null]){
            if(u.Contact.Account.Assigned_PSR_IDS__c != null && u.Contact.Account.Assigned_PSR_IDS__c != ''){
                for(String  s: u.Contact.Account.Assigned_PSR_IDS__c.split('\\,')){
                    if(userAssignedPSR.get(u.ID)==null){
                        System.debug('Enters in getOpportunityPSRUserEmails loop user Added::' + s);
                        List<String> ul = new List<String>();
                        ul.add(s);
                        userAssignedPSR.put(u.id,ul);
                    }else{
                        userAssignedPSR.get(u.ID).add(s);
                    }
                    assignedUserIDs.add(s);
                }
            }                       
        }//ends of For loop
        for(User u:[select id,Email from User where id in:assignedUserIDs]){
            for(Opportunity opp:OppList){
              if(!opp.Call_Trigger__c){    
                    // Conditon put here as per the error logs recd as on 03 Aug 2009 (Null Pointer exception) starts
                        if(userAssignedPSR.get(opp.ownerID) == null) 
                            continue;
                    // Conditon put here as per the error logs recd as on 03 Aug 2009 (Null Pointer exception) ends    
                    for(String s:userAssignedPSR.get(opp.ownerID)){
                        System.debug('Enters in getOpportunityPSRUserEmails insside loop user Added::' + s + ' == ' + String.valueOf(u.ID));
                        if(s == String.valueOf(u.ID)){
                            if(assignedUserEmails.get(opp.ownerID) == null){
                                Set<String> strList = new Set<String>();
                                strList.add(u.ID+separator+u.Email);
                                assignedUserEmails.put(opp.ownerID,strList);
                            }else{
                                assignedUserEmails.get(opp.ownerID).add(u.ID+separator+u.Email);
                            }
                        }
                    }
                }
                else{
                    opp.Call_Trigger__c = false;
                }  
            }           
        }
        Map<ID,Set<String>> oppAsignedPSRUsers = new Map<ID,Set<String>>();
        for(Opportunity opp:oppList){
            if(oppAsignedPSRUsers != null && oppAsignedPSRUsers.get(opp.ownerID)!= null)
                oppAsignedPSRUsers.put(opp.ID,assignedUserEmails.get(opp.ownerID));
        }
        System.debug('Here values return :::' + oppAsignedPSRUsers);
        return  oppAsignedPSRUsers; 
    }
    */
    
    /*
        Opportunity Owner must be Partner and Account.Assigned_PSR_IDS__c fields must contains user ids with , separated be there and Opportunity  RSM_Email__c contains Email
        
    */
    @isTest
    public static void testOpportunityStatusAfterUpdate(){
    //Create Partner Account and Opp related account
     
    //Account acct = new Account(name='OppMangt'+String.valueOf(DateTime.now()));
    //Account acct1 = new Account(name='OppMangtUser'+String.valueOf(DateTime.now()));
    //List<Account> listAccount = new List<Account>();
    //listAccount.add(acct);
    //listAccount.add(acct1);
    //insert listAccount;
    //Create Contact
    //acct.IsPartner =true;
    //update acct;
    //Contact cont = new Contact(firstname='OppMangt'+String.valueOf(DateTime.now()), lastname = 'OppMangt'+String.valueOf(DateTime.now()));
    //cont.AccountId = acct.ID;
    //insert cont;
    //Create Lead and convert
    //Lead lead1 = new Lead(name='OppMangt'+String.valueOf(DateTime.now())');
    
        
    //Test start
        //update opportunity to make status ='Active'
    //Test end
    }
    @isTest
    public static void  testOpportunityStageAfterUpdate(){
    //Create Account
    //Create Contact
    //Create Opportunity
    //Test start
        //update opportunity to make stage ='75% - Proposal/Price Quote'
    //Test end
        
        
    }
    //method will be called from trigger Task Update
    public static void afterUpdateTask(Map<ID,Task> newMap, Map<ID,Task> oldListTask){
        
        Set<String> setOpp;
        String status,subject;
        
        if(newMap.Size()>0){
            
            setOpp = new Set<String>();
            String preFix=Opportunity.SObjectType.getDescribe().getKeyPrefix();
            String oppId;
            for(Task t:newMap.values()){
            
                oppId = t.WhatId;
                status = t.Status;
                subject = t.Subject;
                if(status!=null && oppId!=null  
                    && status.toUpperCase() == 'COMPLETED' 
                    && subject.toUpperCase() == 'SCHEDULE A SITE VISIT' 
                    && oppId.startsWith(preFix) 
                    && status != oldListTask.get(t.Id).Status){
                    setOpp.add(oppId);
                }
            }
            
            List<Opportunity> listOpp = 
                new List<Opportunity>([Select Id, RSM_Email__c, OwnerId 
                    From Opportunity where Id in :setOpp]);
                
            if(listOpp.Size()>0){
                Map<String,ID> emailTemplates = new Map<String,ID>();
                //Fetch Email Templates
                for(EmailTemplate eTemp:
                    [select Id, DeveloperName 
                        from EmailTemplate 
                        where name = 'OppTaskCompleted_VF' and isActive = true]){
                            
                        emailTemplates.put(eTemp.DeveloperName,eTemp.ID);
                }
               sendMailToPSR_RSM(listOpp,emailTemplates);
            }
        }   
    }
    //method used to send mail to RSM & PSR
    public static void sendMailToPSR_RSM(List<Opportunity> listOpp, Map<String,ID> emailTemplates){
        String separator='~';
        String pid;
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        OpportunityManagement oppMgmt = new OpportunityManagement();
        Map<Id,Set<String>> mapOpp = oppMgmt.getOpportunityPSRUserEmails(listOpp);
        if(mapOpp != null && mapOpp.size()>0){
            for(Opportunity opp:listOpp){
                if(opp.RSM_Email__c != null && opp.RSM_Email__c != ''){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(emailTemplates.get('OppTaskCompleted_VF'));
                    mail.setToAddresses(new String[] {opp.RSM_Email__c});
                    mail.setTargetObjectId(opp.ownerID);
                    mail.setWhatId(opp.id);
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId()!=null)
                        emailMessages.add(mail);
                }
                pid = opp.Id;
                if(mapOpp.get(pid) != null){
                    for(String uEmail:mapOpp.get(pid)){
                        String []userEmail = uEmail.split(separator);
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new String[] {userEmail[1]});
                        mail.setTemplateId(emailTemplates.get('OppTaskCompleted_VF'));
                        mail.setTargetObjectId(userEmail[0]);
                        mail.setWhatId(opp.id);
                        mail.saveAsActivity=false;
                        if(mail.getTemplateId()!=null)
                            emailMessages.add(mail);
                    }
                }
            }
        }
        if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        }       
    }
    
    /*Method for call on Before Update */
        public void onBeforeUpdateOpportunity(List<Opportunity> oppList, List<Opportunity> oppList_Old ){
            
                    Map<Id,String> mapOldValues  = null;
                    if(oppList_Old != null && oppList_Old.Size()>0){
                        mapOldValues = new Map<Id, String>();
                        for(Opportunity oppOld:oppList_Old){
                            if(oppOld.System_Size_KwP__c != null)
                                mapOldValues.put(oppOld.id, String.valueOf(oppOld.System_Size_KwP__c));
                        }
                    }
                     
                    //String id = Userinfo.getUserId();
                    String uType = UserInfo.getUserType();
                    //List<User> userList = [select id,UserType from User where id =:id LIMIT 1];
                    //User u = null;
                    //if(userList != null && userList.size()>0)
                        //u= userList[0];
                    if(uType != 'PowerPartner') return;
                    double oldSystemSize;
                    for(Opportunity opp:oppList){
                        if(!opp.Call_Trigger__c){
                            if(mapOldValues.size()>0)
                                oldSystemSize = double.valueOf(mapOldValues.get(opp.id));
                            
                            if(opp.type =='Commercial'){
                                if(opp.isApproved__c == false){
                                    if(oldSystemSize != null && oldSystemSize > 500){ 
                                        //opp can not be updated if not approved yet & size >500  :: case  700 >>300 
                                        //opp.addError('Opportunity must be approved before any update.');
                                    }
                                }
                                else{ //means isApproved == true , after approved opp system size can not be editable
                                    if(oldSystemSize != opp.System_Size_KwP__c)
                                        opp.addError('Approved Opportunity System Size can not be changed.');
                                }
                            }
                        }
                        else{
                            opp.Call_Trigger__c = false;
                        }    
                    }
        }
    /*Method for call on Before Update */
    /*
    private void sendAlertToAssignedPSRsonAbondoned(Map<String,ID> emailTemplates,Map<ID,Opportunity> newMap, Map<ID,Opportunity> oldMap,Map<id,Opportunity> newFetchedOpps ){
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        Map<Id,Opportunity> filteredOpportunities7Days = new Map<Id,Opportunity>();
        Map<Id,Opportunity> filteredOpportunities56Days = new Map<Id,Opportunity>();
        Map<Id,Opportunity> filteredOpportunities90Days = new Map<Id,Opportunity>();
        //IF status is change to Active /Closed-Lost /Closed-Won
        for(Opportunity opp:newMap.values()){
            if(opp.type != 'Residential') continue;
            if((opp.Opportunity_Status__c == 'Dead' || opp.Opportunity_Status__c == 'On-Hold')&& dayDifference(DateTime.Now(),opp.LastModifiedDate)>90){
                filteredOpportunities90Days.put(opp.id,opp);                    
            }else if(newFetchedOpps.get(opp.id).owner.UserType =='Partner' || newFetchedOpps.get(opp.id).owner.UserType =='PowerPartner' && dayDifference(DateTime.Now(),opp.LastModifiedDate)>56){
                filteredOpportunities56Days.put(opp.id,opp);
            }else if(opp.StageName =='New Opportunity' && dayDifference(DateTime.Now(),opp.LastModifiedDate)>7){// Svilla-RLC sales Stage Proj
                filteredOpportunities7Days.put(opp.id,opp);
            }
        }
        if(filteredOpportunities7Days.size()>0)
            sendAlertToPSRUsersonAbondoned(filteredOpportunities7Days,emailTemplates.get('Opportunity_Abandoned_7_days_VF'),emailMessages);
        if(filteredOpportunities56Days.size()>0)
            sendAlertToPSRUsersonAbondoned(filteredOpportunities56Days,emailTemplates.get('Opportunity_Abandoned_56_days_VF'),emailMessages);
        if(filteredOpportunities90Days.size()>0)
            sendAlertToPSRUsersonAbondoned(filteredOpportunities90Days,emailTemplates.get('Opportunity_Abandoned_90_days_VF'),emailMessages);
        System.debug('Email Messages Size::'+ emailMessages.size());
        if(emailMessages.size()>0){
            Messaging.sendEmail(emailMessages);
        }           
    }*/
    public void sendAlertToPSRUsersonAbondoned(Map<Id,Opportunity>filteredOpportunities,String templateID,List<Messaging.Email> emailMessages){
        Map<Id,Set<String>> oppAsignedPSRUsers = new Map<Id,Set<String>>();
        if(allOpportunityPSRUsers != null && allOpportunityPSRUsers.keySet() != null){
            for(ID oppid: allOpportunityPSRUsers.keySet()){
            system.debug('@@filteredOpportunities.get(oppid)'+filteredOpportunities.get(oppid));
                if(filteredOpportunities.get(oppid) != null)
                    oppAsignedPSRUsers.put(oppid,allOpportunityPSRUsers.get(oppid));
            }
        }
        if(filteredOpportunities != null && filteredOpportunities.values() != null){ 
            for(Opportunity opp:filteredOpportunities.values()){
                    if(oppAsignedPSRUsers != null && oppAsignedPSRUsers.get(opp.ID) != null){
                        for(String uEmail:oppAsignedPSRUsers.get(opp.ID)){
                        system.debug('@@oppAsignedPSRUsers.get(opp.ID)'+oppAsignedPSRUsers.get(opp.ID));
                            system.debug('@@templateID'+templateID);
                            String []userEmail = uEmail.split(separator);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setToAddresses(new String[] {userEmail[1]});
                            mail.setTemplateId(templateID);
                            mail.setTargetObjectId(userEmail[0]);
                            mail.setWhatId(opp.id);
                            mail.saveAsActivity=false;
                            system.debug('@@mail.getTemplateId()'+mail.getTemplateId());
                            if(mail.getTemplateId()!=null)
                                emailMessages.add(mail);
                        }
                    }
            }
        }
    }
    
    /* Commented for Sunpower Case # 00031743 */
    /*
    //Send Alert when opportunity is activayed to the Assigned PSR Users 
    public void sendAlertToAssignedPSRsonActive(Map<String,ID> emailTemplates,Map<ID,Opportunity> newMap, Map<ID,Opportunity> oldMap,Map<id,Opportunity> newFetchedOpps ){
        system.debug('@@newMap.values()'+newMap.values());
        //To preapare list of emails
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        //Map of opportunityID and Opportunity detail
        Map<Id,Opportunity> filteredOpportunities = new Map<Id,Opportunity>();
        //Prepare the map of those opportunities whose fields has been modified and is_abandoned_by_partner field is true
        for(Opportunity opp:newMap.values()){        
            if(oldMap.containskey(opp.id)){
                Opportunity oppOld = oldMap.get(opp.id);
                if(( opp.Site_Audit_Submitted__c != oppOld.Site_Audit_Submitted__c || opp.Initial_Site_Audit_Response_Date__c != oppOld.Initial_Site_Audit_Response_Date__c || opp.Approved_Layout_Submission__c != oppOld.Approved_Layout_Submission__c || opp.BOM_Created_Date__c != oppOld.BOM_Created_Date__c ||  opp.Financing_in_Place__c != oppOld.Financing_in_Place__c || opp.Rebate_Applied__c != oppOld.Rebate_Applied__c || opp.Rebate_Confirmed__c != oppOld.Rebate_Confirmed__c || opp.EPA_Draft_Date__c != oppOld.EPA_Draft_Date__c || opp.EPA_Generated__c != oppOld.EPA_Generated__c || opp.End_Customer_Contract__c != oppOld.End_Customer_Contract__c || opp.Verbal_Commitment__c != oppOld.Verbal_Commitment__c || opp.PO_Submitted_Date__c != oppOld.PO_Submitted_Date__c || opp.PO_Receipt_Date__c != oppOld.PO_Receipt_Date__c || opp.StageName != oppOld.StageName || opp.Opportunity_Status__c != oppOld.Opportunity_Status__c )&&(opp.Is_Abandonded__c)){                    
                    filteredOpportunities.put(opp.id,opp); 
                }
            }
        }
        //Prepare email list for PSR users
        if(filteredOpportunities.size()>0){            
            sendAlertToPSRUsersonAbondoned(filteredOpportunities,emailTemplates.get('Opportunity_Activation_VF'),emailMessages);
        }
        
        //Send email        
        if(emailMessages.size()>0){        
            Messaging.sendEmail(emailMessages);
        } 
    }
    */
    /**************************************/
    
    public Long dayDifference(DateTime startDate, DateTime endDate){
        Long startT = startDate.getTime();
        Long endT = endDate.getTime();
        Long days = ((startT-endT)/1000)/60/60/24;
        System.debug('Days is::'+ days);
        return days;
    }
    
    
}