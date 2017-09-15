/* Class:     DesignManagement
 * Purpose:   This class will use to handle all event from Design object Triggers. It is based on send email and final desing logic.
 * Refernce:  Pivotal # #127833599 & 127833081
 * UpdatedBy: Raee$
 * Date:      8/24/2016
 */
public class DesignManagement {
    static public Id proposalRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Proposal Design').getRecordTypeId();
    static public Id projectRecordType = Schema.SObjectType.Design__c.getRecordTypeInfosByName().get('Project Design').getRecordTypeId();   
    static public Id commercialOpptyRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Commercial').getRecordTypeId();   
    static public Id systemOpptyRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Systems').getRecordTypeId();   
    
    public static void beforeDesignUpdate(List<Design__c> designList, Map<Id,Design__c> oldDesignMap) {
        populateDesignFields(designList, oldDesignMap);     
    }
    
    public static void beforeDesignInsert(List<Design__c> designList) { 
        populateDesignFields(designList, null);       
    }

    public static void afterDesignUpdate(List<Design__c> designList, List<Design__c> oldDesignList, Map<Id,Design__c> oldDesignMap) {
        
        updateRelatedObjects(designList);
        selectPrimaryPSRDesign(designList);
        SendEmailonDesignDateUpdate(designList, oldDesignList); 
        // Done for case # 00062214
        //sendEmailOnDesignComplete(designList,oldDesignMap);//This is commented as the request is accomplished in method  sendEmailOnDesignCompleteOrCancelled               
        // Done for case # 00066565
        sendEmailOnDesignCompleteOrCancelled(designList,oldDesignMap); 
    }

    public static void afterDesignInsert(List<Design__c> designList) {
         selectPrimaryPSRDesign(designList);                    
    }
   
  /* Method:    deleteFinalDesignSite 
   * Param:     List of sObject,Object name 
   * Retrun:    None
   * Purpose:   This method made primary design as per Project/Design record type
   * Reference: Pivotal # #127833599 & 127833081
   * CreatedBy: Raee$   
   * Date:      8/22/2016
   */ 
     public static void deleteFinalDesignSite(List<sObject> sObjectList,String objectName) {        
        Map<Id,Design__c> mapOfsiteFinalDesign = new Map<Id,Design__c>();
        List<Id> objId = new List<Id>();
        for(sObject sObj :sObjectList){
            objId.add(sObj.Id);
        }
        for (Design__c design : [Select Id,Site__c,Final_Design__c 
                                 From Design__c  
                                 where ((Opportunity__r.Business_Unit__c = 'NA Commercial' 
                                         AND Opportunity__r.RecordTypeId =: systemOpptyRecordType) 
                                         OR  Opportunity__r.RecordTypeId =: commercialOpptyRecordType)
                                 AND Final_Design__c = true
                                 AND (Id in :objId OR Site__c in: objId)]) {  
             if(objectName == 'Design')
                mapOfsiteFinalDesign.put(design.Id,design);  
              if(objectName == 'Site')
                mapOfsiteFinalDesign.put(design.Site__c,design);                            
        }
        for(sObject sObj :sObjectList){ 
          if(mapOfsiteFinalDesign.containsKey(sObj.Id)){              
             sObj.addError(System.Label.FinalDesignDeleteError);
          }
        }      
     } 

    public static void updateRelatedObjects(List<Design__c> designList) {

        List<Id> psrIds = new List<Id>();
        Map<Id,PSR__c> PSRs = new Map<Id,PSR__c> ();
        List<PSR__c> updatedPSRs = new List<PSR__c>();
      
        for(Design__c design : designList) {       
            if (design.PSR__c != null) {
                psrIds.add(design.PSR__c);  
            }   
        } //end-for
        
        // get all psr records
        if(psrIds.size()>0) {
            PSRs = new Map<Id,PSR__c> ([select id, array_layout_completed__c, electrical_support_completed__c, 
                                        cost_estimate_completed__c, Design_Tracking__c FROM PSR__c 
                                        where id in :psrIds]);        
        }   //end-if

        PSR__c psr = null;        
            
        for(Design__c design : designList) {       
            if (design.Primary_PSR_Design__c && design.PSR__c != null && PSRs.size()>0 && PSRs.containsKey(design.PSR__c)) {
                psr=PSRs.get(design.PSR__c);

                if(psr.array_layout_completed__c != design.Date_Design_Completed__c || psr.Design_Tracking__c != design.Design_Tracking__c) {            
                    psr.array_layout_completed__c = design.Date_Design_Completed__c;
                    psr.Design_Tracking__c = design.Design_Tracking__c;                             
                    updatedPSRs.add(psr);
                }
            }   
        }   //end-for
      
        if (updatedPSRs.size()>0)
            update updatedPSRs;
    }   //end-method
    
    
    public static void populateDesignFields(List<Design__c> designList, Map<ID, Design__c> oldDesignMap) {

        List<Id> siteIds = new List<Id> ();
        Map<Id,Site_Information_Form__c> sites = new Map<Id,Site_Information_Form__c> ();

        RecordType proposalDesignRecType = null;
        RecordType projectDesignRecType = null;

        Schema.DescribeSObjectResult d = Schema.SObjectType.Design__c; 
        Map<ID,Schema.RecordTypeInfo> rtMapByID = d.getRecordTypeInfosById();           
        ID proposalDesignRecordTypeId = null;
        
        for(ID recID : rtMapByID.keySet()) {
            if(rtMapByID.get(recID).name == 'Proposal Design') {
                proposalDesignRecType = new RecordType(ID=recID);                            
            }  
            if(rtMapByID.get(recID).name == 'Project Design') {
                projectDesignRecType = new RecordType(ID=recID);              
            }         
        }

        Set<String> moduleTypes = new Set<String>();
        for(Schema.PicklistEntry p : Design__c.ModuleTypeAndWattage__c.getDescribe().getPicklistValues()) {
                moduleTypes.add(p.getValue());
        }
              
        // Done for case # 00062214 
        /* Popoulating the PSR Owner Field */      
        List<Id> PSRIds = new List<Id> ();
        Map<Id,PSR__c> PSRMap = new Map<Id,PSR__c> ();       

        // get all sites associated with the designs
        for(Design__c design : designList) {
            //Start for case # 00068041
            System.debug('Test->'+design.Status__c);

            //End for case # 00068041
            if(design.site__c != null){
                siteIds.add(design.site__c);    
            } 
          
            // Done for case # 00062214           
            if(design.PSR__c != null){
                PSRIds.add(design.PSR__c);    
            }
            
            if(proposalDesignRecType != null && design.RecordTypeId == proposalDesignRecType.Id) { 
                if(design.Status__c != null && design.Status__c == 'Awaiting Approval' 
                  && design.Original_Submit_Date__c == null) {
                    design.Original_Submit_Date__c = System.today();
                }
                
                //KCM_02112017: pivotal 138459593
                if(oldDesignMap != null) {
                    if (oldDesignMap.get(design.Id).Status__c != 'Completed' &&
                        design.Status__c == 'Completed') {
                        design.Date_Design_Completed__c = System.Today();
                        design.Design_Completed_Date__c = System.Now();                  
                    }
                    
                    if (oldDesignMap.get(design.Id).Dealer_Status__c != 'Design In Progress' &&
                        design.Dealer_Status__c == 'Design In Progress') {
                        design.Design_Started_Date__c = System.Now();
                    }

                    //Crystal - added module type mapping
                    if(oldDesignMap.get(design.Id).Module_Type__c != design.Module_Type__c && String.isNotBlank(design.Module_Type__c)) {
                      if(!moduleTypes.isEmpty() && moduleTypes.contains(design.Module_Type__c)) {
                        design.ModuleTypeandWattage__c = design.Module_Type__c;
                      }
                    }
                }
                
                String ownerId = design.OwnerId;
                if (String.IsNotBlank(ownerId) && ownerId.startsWith(User.SobjectType.getDescribe().getKeyPrefix())) {
                    design.Proposal_Designer__c = ownerId;  
                }                           
            }
              

            if (projectDesignRecType != null && design.RecordTypeId == projectDesignRecType.Id) {
                String ownerId = design.OwnerId;
                if (String.IsNotBlank(ownerId) && ownerId.startsWith(User.SobjectType.getDescribe().getKeyPrefix())) {
                    design.Project_Designer__c = ownerId;  
                }                           
            }
                    
        }
      
        // get all site records
        if (siteIds.size()>0) {
            sites = new Map<Id,Site_Information_Form__c> ([select id, Opportunity_del__c from Site_Information_Form__c
                                                            where id in :siteIds]);       
        }
        
        // get all PSR records
        if (PSRIds.size()>0) {
            PSRMap = new Map<Id,PSR__c> ([select id, OwnerId from PSR__c where id in :PSRIds]);       
        }

        for(Design__c design : designList) {       
            if (design.site__c != null && sites.containsKey(design.site__c)) {
                design.opportunity__c = sites.get(design.site__c).Opportunity_del__c;
            }               

            if (design.PSR__c != null && design.PSR_Owner__c == null && PSRMap.size()>0 && PSRMap.containsKey(design.PSR__c)) {
                design.PSR_Owner__c = PSRMap.get(design.PSR__c).OwnerId;
            }
        }

    } 

    public static void selectPrimaryPSRDesign(List<Design__c> designList) {

        List<Id> psrIds = new List<Id> ();
        List<Id> primaryDesignIds = new List<Id> ();
        List<Design__c> updateDesigns = new List <Design__c>();

        /* get all designs where Active == true */      
        for(Design__c design : designList) {         
            if (design.Primary_PSR_Design__c) {
                primaryDesignIds.add(design.Id);    
                psrIds.add(design.PSR__c);
            }   
        }   //end-for      
                        
                        
        /* get all other designs from their PSRs where the Active == True */
        /* These designs must be set to Active = False 
            because only 1 design per site can be the primary design */
        
        for (Design__c design : [Select d.Site__c, d.PSR__c, d.RecordType.SobjectType, d.RecordType.DeveloperName, 
                                d.RecordType.Name, d.RecordTypeId, d.Primary_PSR_Design__c From Design__c d 
                                where d.RecordType.SobjectType  = 'Design__c' 
                                AND (d.RecordType.DeveloperName = 'Proposal_Design')
                                AND d.Primary_PSR_Design__c = true
                                AND d.Id not in :primaryDesignIds 
                                AND d.PSR__c in :psrIds ]) {
                                    
            design.Primary_PSR_Design__c = false;
            updateDesigns.add(design);                      
        }
                        
        if (updateDesigns.size()>0)
            update updateDesigns;
    }      
    
    public static void SendEmailonDesignDateUpdate(List<Design__c> designList , List<Design__c> oldDesignList) {
        System.debug('+++ TEST');
        List<Id> oppIds = new List<Id>();
        Map<Id,Opportunity> mapOpps = new Map<Id,Opportunity> ();
        Map<Id,OpportunityTeamMember> oppTeamMember = New Map<Id,OpportunityTeamMember>();

        List<String> lstSalesAnalyst = new List<String>();
        List<String> lstSalesPerson = new List<String>();
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
     
        Map<Id,Design__c> mapNewDesign = new Map<Id,Design__c> ();
        for (Design__c newDesign : designList) {         
            mapNewDesign.put(newDesign.Id ,newDesign );
        }
        
        Set<String> setOppID = new Set<String>();
        for(Design__c oldDesign : oldDesignList) {
            if (!(oldDesign.Status__c!='Completed' && mapNewDesign.get(oldDesign.id).Status__c=='Completed') 
                && (oldDesign.Date_Design_Completed__c !=  mapNewDesign.get(oldDesign.Id).Date_Design_Completed__c)
                && oldDesign.Opportunity__c!=null ) { 
                    setOppID.Add(oldDesign.Opportunity__c);
            }
        }
      
        List<EmailTemplate> lstemailTemp =  new List<EmailTemplate>();
            if(setOppID.size()>0) {
                lstemailTemp = [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Design_Completed_Date_field_VF' and isActive = true] ;
            }         
      
        for(Design__c oldDesign : oldDesignList) {
            if (!(oldDesign.Status__c!='Completed' && mapNewDesign.get(oldDesign.id).Status__c=='Completed') 
            && (oldDesign.Date_Design_Completed__c !=  mapNewDesign.get(oldDesign.Id).Date_Design_Completed__c)) {
            
                List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name, User.Email, TeamMemberRole , OpportunityId from OpportunityTeamMember 
                where OpportunityId = :oldDesign.Opportunity__c and TeamMemberRole in ('Sales Person','Sales Analyst') ];
         
                if (oppTeamMem.size() > 0) {
                    for (OpportunityTeamMember oppTeam :oppTeamMem  ) {
                        if (oppTeam.TeamMemberRole == 'Sales Analyst') 
                            lstSalesAnalyst.add(oppTeam.User.Email);
                        else  
                            lstSalesPerson.add(oppTeam.User.Email);
                    }
                }
          
                if(lstSalesAnalyst.Size() > 0) {
                    Map<String,ID> emailTemplates = new Map<String,ID>();
                    //Fetch Email Templates

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(lstemailTemp.get(0).Id);
                        mail.setToAddresses(lstSalesAnalyst);
                        mail.setTargetObjectId(oldDesign.OwnerId);
                        mail.setWhatId(oldDesign.Id);
                        mail.saveAsActivity=false;
                        
                    if(mail.getTemplateId()!=null)
                        emailMessages.add(mail);   
                }
            }
        }
       
        if(emailMessages.size()>0) {
            List<Messaging.SendEmailResult> sendEmailResults = new List<Messaging.SendEmailResult>();
            if (Util.byPassValidation() == false) {
                sendEmailResults = Messaging.sendEmail(emailMessages);
            }

            Messaging.SendEmailError[] emailErrors;
            for (Messaging.SendEmailResult sendEmailResult : sendEmailResults) {
                if (sendEmailResult.isSuccess() == false) {
                    //emailSent = false;
                    System.debug('Debug: Error(s) sending email:');
                    emailErrors = sendEmailResult.getErrors();
                    for (Messaging.SendEmailError error : emailErrors) {
                        System.debug('---Debug: Error Message---' + error.getMessage());
                    }
                    break;
                }
            }
        }  
    }  
    
           
    public static void SendEmailonDesignAssignedtoDesigner(List<Design__c> designList , List<Design__c> oldDesignList) {

        List<Id> oppIds = new List<Id>();
        Map<Id,Opportunity> mapOpps = new Map<Id,Opportunity> ();
        Map<Id,OpportunityTeamMember> oppTeamMember = New Map<Id,OpportunityTeamMember>();

        List<String> lstSalesTeam = new List<String>();
        List<Messaging.Email> emailMessages = new List<Messaging.Email>();
        List<EmailTemplate> lstemailTemp = new List<EmailTemplate> (); //=  [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Design_Assignment_Email_Template' and isActive = true] ;
        Map<Id,Design__c> mapOldDesign = new Map<Id,Design__c> ();     
        String strFlag = 'false';
      
        List<Contact> lstDelCont = new List<Contact>();
        if (oldDesignList != null) {
            for (Design__c oldDesign : oldDesignList) {
                mapOldDesign.put(oldDesign.Id ,oldDesign );
            }
        }
      
        for(Design__c design : designList) {
            if (oldDesignList == null || design.OwnerId !=  mapOldDesign.get(design.Id).OwnerId ) {
                strFlag = 'true';
                break;
            }
        }
      
        if (strFlag == 'true') lstemailTemp =  [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Design_Assignment_Email_Template' and isActive = true] ;
        else
            return;
      
        for(Design__c design : designList) { 
            User usr = [Select id, Email from User where id = :design.OwnerId];
            //lstSalesTeam.add(usr.Email);
            System.Debug('-----New Design owner  -----' + design.OwnerId);
        
            //System.Debug('-----old Design Owner -----' + mapOldDesign.get(design.Id).OwnerId );
            if (oldDesignList == null || design.OwnerId !=  mapOldDesign.get(design.Id).OwnerId ) {
                List<OpportunityTeamMember> oppTeamMem = [Select id, User.Name,User.Email, TeamMemberRole, OpportunityId from OpportunityTeamMember where OpportunityId = :design.Opportunity__c and TeamMemberRole in ('Sales Person','Sales Analyst') ];
          
                if (oppTeamMem.size() > 0) {
                    for (OpportunityTeamMember oppTeam :oppTeamMem  ) {
                        lstSalesTeam.add(oppTeam.User.Email);
                    }
                }
            
                List<Contact> cntlst = [Select id, Email from Contact where Email = :usr.Email limit 1];
                Contact cnt;
                if(cntlst.size() == 0) {
                    cnt = new Contact(LastName = 'SendEmailMytest', Email = usr.Email);
                    insert cnt;
                    lstDelCont.add(cnt);
                }
                else {
                    cnt = cntlst[0];
                }
           
                if(lstSalesTeam.Size() > 0) {
                    Map<String,ID> emailTemplates = new Map<String,ID>();
                    //Fetch Email Templates

                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setTemplateId(lstemailTemp.get(0).Id);
                        mail.setToAddresses(lstSalesTeam);
                        mail.setTargetObjectId(cnt.Id);
                        mail.setWhatId(design.Id);
                        // mail.setWhatId(design.Id);
                        mail.saveAsActivity=false;
                        
                    if(mail.getTemplateId()!=null)
                        emailMessages.add(mail);   
                }
            }
        }
        
        if(emailMessages.size()>0) {
            List<Messaging.SendEmailResult> sendEmailResults = new List<Messaging.SendEmailResult>();
            if (Util.byPassValidation() == false) {
                sendEmailResults = Messaging.sendEmail(emailMessages);
            }
            
            if (lstDelCont.size() > 0)
                delete lstDelCont;

            Messaging.SendEmailError[] emailErrors;
            for (Messaging.SendEmailResult sendEmailResult : sendEmailResults) {
                if (sendEmailResult.isSuccess() == false) {
                    //emailSent = false;
                    System.debug('Debug: Error(s) sending email:');
                    emailErrors = sendEmailResult.getErrors();
                    for (Messaging.SendEmailError error : emailErrors) {
                        System.debug('---Debug: Error Message---' + error.getMessage());
                    }
                    break;
                }
            }
        }  
    } 
    
    // Done for case # 00066565
    /* Whenever Design on a PSR go to 'Completed' or 'Cancelled' status,
       It send a notification to all owners of related objects(Design,Estimate,SingleLine) on the PSR and user 'Sunpower Archive'.*/
    private static void sendEmailOnDesignCompleteOrCancelled(List<Design__c> designList,Map<Id,Design__c> oldDesignMap) {        
        // List of associated PSR IDs
        List<ID> psrIDsList = new List<ID>();                             
        
        //If Design is completed or cancelled. 
        //CompletedDate check is added on cancelled also to restrict the email being sent twice because completedDate is updated through workflow
        for(Design__c design : designList) {        
            if( (design.Status__c == 'Completed' && oldDesignMap.get(design.id).Status__c != 'Completed' && design.Date_Design_Completed__c == Date.Today())
                || (design.Status__c == 'Cancelled' && oldDesignMap.get(design.id).Status__c != 'Cancelled' && design.Date_Design_Completed__c == Date.Today())
                && design.PSR__c != null ) {               
                psrIDsList.Add(design.PSR__c);
            }
        }
        
        // Calling the method from class PSRManagement to send email notification               
        if(psrIDsList.size()>0) { 
            PSRManagement.sendEmailOnCompletedOrCancelledStatusOfRelatedObjects(psrIDsList,'Design');
        }
    }
}