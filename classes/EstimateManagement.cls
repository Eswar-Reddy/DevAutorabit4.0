public class EstimateManagement {

    public static void beforeEstimateUpdate(List<Estimate__c> estimateList, 
        List<Estimate__c> oldEstimateList){
        
      populateEstimateFields(estimateList);
      updateOldEstimator(estimateList,oldEstimateList);
    }

    public static void beforeEstimateInsert(List<Estimate__c> estimateList){
        
      populateEstimateFields(estimateList);

    }

    public static void afterEstimateUpdate(List<Estimate__c> estimateList, 
        List<Estimate__c> oldEstimateList,Map<ID,Estimate__c> mapOldEstimate){

              populateRelatedObjects(estimateList, mapOldEstimate);
              QuoteLineInfoUpdate(estimateList,mapOldEstimate);
              SendEmailonEstimateOwnerChangeORCompleteApproved(estimateList,oldEstimateList);
              
              // Done for case # 00066565
              sendEmailOnEstimateCompleteOrCancelled(estimateList,oldEstimateList); 
    }

    public static void afterEstimateInsert(List<Estimate__c> estimateList){
         QuoteLineInfoUpdate(estimateList,null);
         //populateRelatedObjects(estimateList);
         SendEmailonEstimateOwnerChangeORCompleteApproved(estimateList,null);
    }

    public static void populateRelatedObjects(List<Estimate__c> estimateList, Map<ID,Estimate__c> mapOldEstimate){

      List<Id> psrIds = new List<Id>();
      Map<Id,PSR__c> PSRs = new Map<Id,PSR__c> ();
      List<PSR__c> updatedPSRs = new List<PSR__c>();

      
      for(Estimate__c estimate : estimateList){         

        if (estimate.Primary_PSR_Estimate__c && estimate.PSR__c != null
                && (estimate.Estimate_Complete_Date__c != mapOldEstimate.get(estimate.Id).Estimate_Complete_Date__c
                || estimate.Estimate_Review_Track_Date__c != mapOldEstimate.get(estimate.Id).Estimate_Review_Track_Date__c)){
            psrIds.add(estimate.PSR__c);    
        }   

      }//end-for
        
      // get all psr records
      if (psrIds.size()>0){
        
        PSRs = new Map<Id,PSR__c> 
            ([select id, array_layout_completed__c, electrical_support_completed__c, 
                cost_estimate_completed__c, cost_estimate_tracking__c, electrical_support_tracking__c 
                from PSR__c 
              where id in :psrIds]);        
      }//end-if
      
      PSR__c psr = null;      
            
      for(Estimate__c estimate : estimateList){         

        if (estimate.Primary_PSR_Estimate__c
            && estimate.PSR__c != null
            && PSRs.size()>0 
            && PSRs.containsKey(estimate.PSR__c)
            && (estimate.Estimate_Complete_Date__c != mapOldEstimate.get(estimate.Id).Estimate_Complete_Date__c
            || estimate.Estimate_Review_Track_Date__c != mapOldEstimate.get(estimate.Id).Estimate_Review_Track_Date__c)){
            
                psr = PSRs.get(estimate.PSR__c);
                psr.cost_estimate_completed__c=estimate.Estimate_Complete_Date__c;
                psr.cost_estimate_tracking__c=estimate.Estimate_Review_Track_Date__c;
                
                updatedPSRs.add(psr);
        }   

      }//end-for
      
      if (updatedPSRs.size()>0)
        update updatedPSRs;

    }//end-method

    public static void populateEstimateFields(List<Estimate__c> estimateList){

      List<Id> siteIds = new List<Id>();
      Map<Id,Site_Information_Form__c> sites = new Map<Id,Site_Information_Form__c> ();

      List<Id> designIds = new List<Id>();
      Map<Id,Design__c> designs = new Map<Id,Design__c>();

      List<Id> quoteIds = new List<Id>();
      Map<Id,Quote> quotes = new Map<Id,Quote>();

      // Done for case # 00062214 
      /* Popoulating the PSR Owner Field */      
      List<Id> PSRIds = new List<Id> ();
      Map<Id,PSR__c> PSRMap = new Map<Id,PSR__c> (); 
      
      // get all sites/designs associated with the estimate      
      for(Estimate__c estimate : estimateList){         
        if (estimate.site__c != null){
            siteIds.add(estimate.site__c);  
        }   
        
        if (estimate.design__c != null){
            designIds.add(estimate.design__c);  
        }   

        if (estimate.quote__c != null){
            quoteIds.add(estimate.quote__c);    
        }
        
        if (estimate.PSR__c != null){
            PSRIds.add(estimate.PSR__c);  
        }   

      }

      // get all site records
      if (siteIds.size()>0){
        
        sites = new Map<Id,Site_Information_Form__c> 
            ([select id, Opportunity_del__c, Site_Name__c, Opportunity_del__r.name 
                from Site_Information_Form__c 
              where id in :siteIds]);       
      }

      // get all design records
      if (designIds.size()>0){
        
        designs = new Map<Id,Design__c> 
            ([select id, site__c, site__r.name, Opportunity__c, Opportunity__r.name 
                from Design__c 
              where id in :designIds]);         
      }

      // get all PSR records
      if (PSRIds.size()>0){
        PSRMap = new Map<Id,PSR__c> 
                    ([select id, OwnerId from PSR__c where id in :PSRIds]);       
      }
      
      // get all quote records
      //Comment By Venkat Ramesh
      
      if (quoteIds.size()>0){
        
        quotes = new Map<Id,Quote> 
            ([select id,Opportunity.name,Opportunity.id from Quote 
              where id in :quoteIds]);          
      }
      
      //End Comment
    //Add By Venkat Ramesh
    //List<Opportunity> oppList = [Select id,(select id, Opportunity.name from Quotes) from Opportunity];
     // for(Opportunity opp:oppList){
           // List<Quote> quoteList = new List<Quote>();
           // quoteList.addAll(opp.Quotes);
           // for(Quote qut:quoteList){
               // quotes.put(qut.id,qut);
          //  }
     // }

      //End Venkat Ramesh

      for(Estimate__c estimate : estimateList){
        
        if (estimate.design__c != null 
            && (estimate.site__c == null || estimate.opportunity__c == null)
            && designs.size()>0
            && designs.containsKey(estimate.design__c)){
                
            if (estimate.opportunity__c == null){
                estimate.opportunity__c = designs.get(estimate.design__c).Opportunity__c;
            }
        
            if (estimate.site__c == null){
                estimate.site__c = designs.get(estimate.design__c).site__c;
            }
        }               

                
        if (estimate.site__c != null 
            && estimate.opportunity__c == null
            && sites.size()>0
            && sites.containsKey(estimate.site__c)){
          
            estimate.opportunity__c = sites.get(estimate.site__c).Opportunity_del__c;
            
        }               


        if (estimate.quote__c != null 
            && estimate.opportunity__c == null
            && quotes.size()>0
            && quotes.containsKey(estimate.quote__c)){
          
            estimate.opportunity__c = quotes.get(estimate.quote__c).Opportunity.id;

                        
        }
        
        if (estimate.PSR__c != null
            && estimate.PSR_Owner__c == null
            && PSRMap.size()>0
            && PSRMap.containsKey(estimate.PSR__c)){
          estimate.PSR_Owner__c = PSRMap.get(estimate.PSR__c).OwnerId;
        }   
        
      }

    } 
    
    public static void updateOldEstimator(List<Estimate__c> newEstimateList, List<Estimate__c> oldEstimateList){
        
        Map<id,Estimate__c> mapNewEstimate ;
        if(newEstimateList != null && newEstimateList.size() > 0) {
            mapNewEstimate = new Map<id,Estimate__c>();
            for ( Estimate__c newEst :newEstimateList ) {
                if(newEst.Estimator__c != null)
                    mapNewEstimate.put(newEst.Id,newEst);
            }
            if(oldEstimateList != null && oldEstimateList.size() > 0) {
                
                for(Estimate__c oldEst :oldEstimateList ) {
                     if(oldEst.Estimator__c != null && mapNewEstimate.get(oldEst.Id) != null && oldEst.Estimator__c != mapNewEstimate.get(oldEst.Id).Estimator__c) {
                        mapNewEstimate.get(oldEst.Id).Old_Estimator__c = oldEst.Estimator__c;
                     }
                }
            }
        }
    }

    public static void SendEmailonEstimateOwnerChangeORCompleteApproved(List<Estimate__c> estimateList , List<Estimate__c> oldEstimateList){

      
      Map<Id,OpportunityTeamMember> oppTeamMember = New Map<Id,OpportunityTeamMember>();
      
    
      List<Messaging.Email> emailMessages = new List<Messaging.Email>();
      Map<Id,Estimate__c> mapOldEstimate = new Map<Id,Estimate__c> ();  
      List<EmailTemplate> lstemailTemp = new List<EmailTemplate>();
       
      
      Set<Id> estimateIds = new Set<Id> ();
      Set<Id> OppsIds = new Set<Id>();
      Set<String> ownerEmail = new  Set<String>();
      
      Map<Id, List<String>> mapEstimateIdEmail = new Map<Id, List<String>>();
      List<Design__c> lstDesign = new List<Design__c> ();
      Map<ID, Estimate__c> mapNewEstimate = new  Map<ID, Estimate__c>();
      List<OpportunityTeamMember> oppTeamMem = new List<OpportunityTeamMember>();
      List<Contact> lstcontactexist = new List<Contact>();
      List<Contact> lstcontactNew = new List<Contact>();
      Map<Id,String> mapEstIdEmail = new Map<Id, String>();
      Map<String,Contact> mapEmailtoContact = new Map<String,Contact>();
      
      if (oldEstimateList != null) {
      
        for (Estimate__c oldEstimate : oldEstimateList){
        
            mapOldEstimate.put(oldEstimate.Id ,oldEstimate );
        }
      }
      
      Boolean isSendEmail = false;
      for (Estimate__c est : estimateList) {
        
         if (oldEstimateList != null && est.Status__c !=  mapOldEstimate.get(est.id).Status__c && est.Estimate_Complete_Date__c == System.today() && est.Status__c == 'Completed' ) {              
             isSendEmail = true;
             estimateIds.add(est.Id);
             OppsIds.add(est.Opportunity__c);
          }
          else if (oldEstimateList == null || est.OwnerId !=  mapOldEstimate.get(est.id).OwnerId ) {
             isSendEmail = true;
             estimateIds.add(est.Id);
             OppsIds.add(est.Opportunity__c);
          }        
      }
      
      if(!isSendEmail){
          return;
      }
           
      if (estimateIds.size() > 0) {
        
        mapNewEstimate = new Map<ID, Estimate__c>([Select Id, Owner.Email , Estimator__r.Email, Estimate_Reviewer__r.Email, Opportunity__c, Design__c, Design__r.Name,Design__r.Owner.Email, Status__c, Estimate_Complete_Date__c from Estimate__c where Id in :estimateIds ]);
        //lstDesign = [Select id,OwnerId,Owner.Name, Owner.Email, Estimator__c, Estimator__r.Email,Design__c from Estimate__c where Design__c  in : estiamteIds];
                
        if (OppsIds.size() > 0) {
        
          oppTeamMem = [Select id, User.Name,User.Email, TeamMemberRole , OpportunityId from OpportunityTeamMember where OpportunityId in :OppsIds and TeamMemberRole in ('Sales Person','Sales Analyst') ];
                
        }
        
        if (mapNewEstimate.size() > 0) {
            
            for (Id estId : estimateIds) {
                
                String email = mapNewEstimate.get(estId).Owner.Email;
                mapEstIdEmail.put(estId,email);
                
            }
            
            if (mapEstIdEmail.size() > 0)
                lstcontactexist = [Select id, Email from Contact where Email in :mapEstIdEmail.values()];
            
            if (lstcontactexist.size() > 0) {
                
                for ( Contact cnt : lstcontactexist) {
                    
                    mapEmailtoContact.put(cnt.Email , cnt);
                }
            }
            
            for (String email : mapEstIdEmail.values()) {
                
                if (mapEmailtoContact.get(email) == null) {
                    
                    Contact cont = new Contact();
                    cont.LastName = 'testCOntactInsert';
                    cont.Email = email;
                    lstcontactNew.add(cont);
                    mapEmailtoContact.put(email,cont);
                }
            }
            
            insert lstcontactNew;
            
        }
      
                
        if ( mapNewEstimate.size() > 0) {
            List<EmailTemplate> emailTempList = [select Id, DeveloperName from EmailTemplate where DeveloperName in ('Estimate_Approval_Email_Template', 'Estimate_Assignment_Email_Template') and isActive = true];
            EmailTemplate eTemp1 = null;
            EmailTemplate eTemp2 = null;
            for (EmailTemplate e : emailTempList) {
                if (e.DeveloperName == 'Estimate_Approval_Email_Template') {
                    eTemp1 = e;
                } else if (e.DeveloperName == 'Estimate_Assignment_Email_Template') {
                    eTemp2 = e;
                }
            }
            
            for (Id estid : estimateIds) {
             
             List<String> lstEmailAdd = new List<String>(); 
             
             if ( mapNewEstimate.get(estid).Estimator__r.Email != null) {
                    lstEmailAdd.add(mapNewEstimate.get(estid).Estimator__r.Email);
                    System.Debug('-----Estimator__r.Email -----' + mapNewEstimate.get(estid).Estimator__r.Email);
                }
                if ( mapNewEstimate.get(estid).Estimate_Reviewer__r.Email != null) {
                    lstEmailAdd.add(mapNewEstimate.get(estid).Estimate_Reviewer__r.Email);
                    System.Debug('-----Estimate_Reviewer__r.Email  -----' + mapNewEstimate.get(estid).Estimate_Reviewer__r.Email);
                }
                 if ( mapNewEstimate.get(estid).Design__r.Owner.Email != null) {
                    lstEmailAdd.add(mapNewEstimate.get(estid).Design__r.Owner.Email);
                    System.Debug('-----Design__r.Owner.Email -----' + mapNewEstimate.get(estid).Design__r.Owner.Email);
                }       
                
                System.Debug('------ Opp team size---' + oppTeamMem.size());        
                if (oppTeamMem.size() > 0) {
                    
                    String oppid = mapNewEstimate.get(estid).Opportunity__c;
                    for (OpportunityTeamMember opTeam : oppTeamMem) {
                        
                        System.Debug('------ opTeam.User.Email---' + opTeam.User.Email);    
                        if (opTeam.OpportunityId == oppid ) {
                            
                            lstEmailAdd.add(opTeam.User.Email);
                            System.Debug('------ lstEmailAdd in owner change---' + lstEmailAdd);
                        }
                    }
                                     
                }
                //System.Debug('------ oldEstimateList.size() ---' + oldEstimateList.size() );
                //System.Debug('------ mapNewEstimate.get(estid).OwnerId ---' + mapNewEstimate.get(estid).OwnerId );
                //System.Debug('------ mapOldEstimate.get(estid).OwnerId ---' + mapOldEstimate.get(estid).OwnerId );
                
              if (eTemp1 != null && oldEstimateList != null && mapNewEstimate.get(estid).Status__c !=  mapOldEstimate.get(estid).Status__c && mapNewEstimate.get(estid).Estimate_Complete_Date__c == System.today() && mapNewEstimate.get(estid).Status__c == 'Completed' ) {
        
                //lstemailTemp = [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Estimate_Approval_Email_Template' and isActive = true] ;
                lstemailTemp = new EmailTemplate[]{eTemp1};
              }
              else if (eTemp2 != null && oldEstimateList == null || mapNewEstimate.get(estid).OwnerId !=  mapOldEstimate.get(estid).OwnerId ) {
                
                //lstemailTemp = [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'Estimate_Assignment_Email_Template' and isActive = true] ;
                lstemailTemp = new EmailTemplate[]{eTemp2};
              }// End else 
              
              if (lstEmailAdd.size() > 0) {
                
                    mapEstimateIdEmail.put(estid,lstEmailAdd );
              }
            }
        }
        
        for (Id estid : estimateIds) {
            
                System.Debug('------ mapEmailtoContact---' + mapEmailtoContact.size());
                System.Debug('------ mapEstIdEmail---' + mapEstimateIdEmail.size());
                System.Debug('------ lstemailTemplate ---' + lstemailTemp.size());
            if ( mapEmailtoContact.size() > 0 && mapEstimateIdEmail.size() > 0) {
            
                List<String> lstsendEmails = mapEstimateIdEmail.get(estid);
                
                List<String> lstValidEmails = GetToAddresses(lstsendEmails);
                
                Contact emailcont = mapEmailtoContact.get(mapNewEstimate.get(estid).Owner.Email);
                System.Debug('------ lstemailTemplate data ---' + lstemailTemp);
                if(lstValidEmails.Size() > 0 && emailcont != null && lstemailTemp.size() > 0 ){
                    
                    System.Debug('--------Contact emailcont----- ' + emailcont.Id);
                    System.Debug('--------lstsendEmails----- ' + lstsendEmails);
                    Map<String,ID> emailTemplates = new Map<String,ID>();
                    //Fetch Email Templates
                               
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstemailTemp.get(0).Id);
                    mail.setToAddresses(lstValidEmails);
                    mail.setTargetObjectId(emailcont.Id);
                    mail.setWhatId(estid);
                   // mail.setWhatId(design.Id);   
                    mail.saveAsActivity=false;
                    if(mail.getTemplateId()!=null)
                       
                         emailMessages.add(mail);   
                
                
                }
            }
        }
     
     
      if(emailMessages.size()>0){
         
          List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emailMessages);
          
          if (lstcontactNew.size() > 0)
           
             delete lstcontactNew;
          
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
  }

    public static List<string> GetToAddresses(List<String> lstemails){

    //  string regex='(\\w+)([\\.-]?\\w+)*@\\w+([\\.-]?\\w+)*\\.(\\w{2}|(com|net|org|edu|int|mil|gov|arpa|biz|aero|name|coop|info|pro|museum))';      
      //string regex='(\\w+)@(\\w+\\.)(\\w+)(\\.\\w+)*';
    string regex = '\\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}\\b';
      // string[] emails = sendTo.split(';');
       List<string> toAddresses = new List<string>(); 
       if (lstemails.size() > 0) {      
           for(string str : lstemails){          
             Pattern p = Pattern.compile(regex);
             Matcher m = p.matcher(str);
             if(m.matches())
               toAddresses.add(str);
           }    
       }   
       return toAddresses ;
    }


    // Done corresponding to the case-00037275
    //Method to ensure If the Estimate is linked to a Design after the Product (QuoteLineItem) is added to a Design, then QuoteLineItems of Design is added to the Estimate
    private static void QuoteLineInfoUpdate(List<Estimate__c> estimateList , Map<ID,Estimate__c> mapOldEstimate){
        Set<String> setDesign = new Set<String>();
        Map<String,String> mapOldDesignEstimate = new Map<String,String>();
        for(Estimate__c es : estimateList){
            //If Estimate is updated
            if(mapOldEstimate!=null && es.Design__c!=null && es.Design__c != mapOldEstimate.get(es.ID).Design__c){
                setDesign.Add(es.Design__c);
                if(mapOldEstimate.get(es.ID).Design__c != null)
                    mapOldDesignEstimate.put(mapOldEstimate.get(es.ID).Design__c,es.ID);
            }
            //If Estimate is inserted
            else if(mapOldEstimate==null && es.Design__c!=null){
                setDesign.Add(es.Design__c);                
            }
        }
        
        //Get all related QuoteLineItems
        List<QuoteLineItem> lstQLIToUpdate = new List<QuoteLineItem>();
        for(QuoteLineItem qli:[Select id,Estimate__c,Design__c from QuoteLineItem where Design__c in:setDesign or Design__c in:mapOldDesignEstimate.keySet()]){
            if(setDesign.contains(qli.Design__c)){
                lstQLIToUpdate.add(qli);                
            }
            //This check has been put to ensure that when a Design on Estimate is changed
            //then QuoteLineItem associated with old deasign should no longer associated with Estimate
            else if(mapOldDesignEstimate.containsKey(qli.Design__c) && qli.Estimate__c==mapOldDesignEstimate.get(qli.Design__c)){
                qli.Estimate__c = null;
                lstQLIToUpdate.add(qli);
            }
        }
        
        //On QuoteLineItem update the method "QuoteFieldvalues.UpdateQuoteInfo" will set the appropriate Estimate__c value
        if(lstQLIToUpdate.size()>0){
            update lstQLIToUpdate;
        }
    }
    
    // Done for case # 00066565
    /* Whenever Estimate on a PSR go to 'Completed' or 'Cancelled' status,
       It send a notification to all owners of related objects(Design,Estimate,SingleLine) on the PSR and user 'Sunpower Archive'.*/
    private static void sendEmailOnEstimateCompleteOrCancelled(List<Estimate__c> estimateList , List<Estimate__c> oldEstimateList)
    {
        // Preparing the old Estimate Map
        Map<Id,Estimate__c> oldEstimateMap = new Map<Id,Estimate__c> ();  
        if(oldEstimateList != null){
            for (Estimate__c oldEstimate : oldEstimateList){
                oldEstimateMap.put(oldEstimate.Id ,oldEstimate );
            }
        }
        // List of associated PSR IDs
        List<ID> psrIDsList = new List<ID>();                             
        
        //If Estimate is completed or cancelled. 
        //CompletedDate check is added on cancelled also to restrict the email being sent twice because completedDate is updated through workflow
        for(Estimate__c estimate : estimateList){        
            if((estimate.Status__c == 'Completed' && oldEstimateMap.get(estimate.id).Status__c != 'Completed' && estimate.Estimate_Complete_Date__c != null)
                || (estimate.Status__c == 'Cancelled' && oldEstimateMap.get(estimate.id).Status__c != 'Cancelled' && estimate.Estimate_Complete_Date__c != null)
                && estimate.PSR__c != null){                               
                psrIDsList.Add(estimate.PSR__c);
            }
        }
        
        // Calling the method from class PSRManagement to send email notification                
        if(psrIDsList.size()>0){ 
            PSRManagement.sendEmailOnCompletedOrCancelledStatusOfRelatedObjects(psrIDsList,'Estimate');
        }
    }        
    
}