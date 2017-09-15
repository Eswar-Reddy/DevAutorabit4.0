global class FivePercentageDownPayment implements Messaging.InboundEmailHandler{
     global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
    {
         Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String subject = email.subject;
        System.debug(LoggingLevel.INFO,'In Email service->');
        //subject format Case: {!Case.CaseNumber} - {!Case.Subject} - P1 Notification
        System.debug(LoggingLevel.INFO,'Sub->'+subject.indexOf('006'));
        if(subject.contains('006')){
            String opportunityid = subject.substring(subject.indexOf('006'),subject.indexOf('006')+15);
            System.debug(LoggingLevel.INFO,'opportunityid'+opportunityid);
            Opportunity objOpportunity = [Select Name,PartnerAccountID,AccountID,LastModifiedBy.Name,Down_Payment_Invoice_Number__c,Sales_Order_Number__c,owner.email,CRSM__c,CRSM__r.email,(Select OpportunityId,role,contactID,contact.Email From OpportunityContactRoles),id From Opportunity where id =:opportunityid];
            //Account objAccount = [Select id,(Select role,contactID,contact.Email From AccountContactRoles) from Account where id=:objOpportunity.AccountID limit 1];
            List<String> lstSalesTeam = new List<String>();
            ID contactID = null;
            //Contact objContact = [Select id from Contact limit 1 ];
            String stgCommercialPSR = null;
            for(AccountContactRole accountContactRole :[SELECT role,contactID,contact.Email,Account.Commercial_PSR__r.email from AccountContactRole where AccountId =:objOpportunity.PartnerAccountID]){
                System.debug('----------accountContactRole'+accountContactRole);
                if(accountContactRole.role =='Finance Manager'){
                    lstSalesTeam.add(accountContactRole.Contact.Email);
                    contactID = accountContactRole.ContactId;
                    stgCommercialPSR =  accountContactRole.Account.Commercial_PSR__r.email;
                    }
                
            }
            System.debug('----------lstSalesTeam'+lstSalesTeam);
            lstSalesTeam.add(objOpportunity.owner.email);
            
            String[] lstSalesTeamCC = new String[] {};
            String[] lstSalesTeamBCC = new String[] {'Julie.Canlubo@sunpowercorp.com'};
            if(objOpportunity.CRSM__c != null && objOpportunity.CRSM__r.email != null){
                        lstSalesTeamCC = new String[] {objOpportunity.CRSM__r.email};
            }
            if(stgCommercialPSR != null)
                lstSalesTeamCC.add(stgCommercialPSR);
            
            System.debug('-------------lstSalesTeam'+lstSalesTeam);
            List<EmailTemplate> lstemailTemp =  [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'X5_Down_Payment_Email' and isActive = true] ;
            List<Messaging.Email> emailMessages = new List<Messaging.Email>();
           
            List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();
            System.debug('-----Opportunity.id'+objOpportunity.id);
            String oppid=objOpportunity.Id;
            String attachmanetName = 'Down Payment Invoice_#'+objOpportunity.Down_Payment_Invoice_Number__c+'_'+objOpportunity.name;
            System.debug('-----attachmanetName='+attachmanetName);
            //String strQuery = 'Select id,ParentId,name,Body from Attachment where ParentId =:oppid and Name like \'%'+ objOpportunity.Down_Payment_Invoice_Number__c + '%\'';
            String strQuery = 'Select id,ParentId,name,Body from Attachment where ParentId =:oppid and Name like \''+ attachmanetName + '%\'';
            list<Attachment> listAttachment = database.query(strQuery);
            System.Debug('--- listAttachment ---' +listAttachment);
            Messaging.EmailFileAttachment attach ;
            for (Attachment objAttach :  listAttachment) {
                attach = new Messaging.EmailFileAttachment();
                attach.setBody(objAttach.body);
                attach.setFileName(objAttach.Name);
                lstAttachments.add(attach);
            }
            list<Contact> listContactJulie =[Select id from Contact where email like '%julie.delrosario@sunpowercorp.com%'];
            if(listContactJulie.size()==0)
                listContactJulie  = [Select id from Contact limit 1];
            //lstSalesTeam.add('cachedpraveen@gmail.com');
            //lstSalesTeam.add('Julie.Canlubo@sunpowercorp.com');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstemailTemp.get(0).Id);
                    mail.setToAddresses(lstSalesTeam);
                    mail.setbccAddresses(lstSalesTeamBCC);
                    mail.setCcAddresses(lstSalesTeamCC);
                    mail.setSenderDisplayName(objOpportunity.LastModifiedBy.Name);
                    //mail.setTargetObjectId(UserInfo.getUserId());
                    if(contactID != null){
                        mail.setTargetObjectId(contactID);
                        mail.setWhatId(objOpportunity.Id);
                    }else{
                        if(listContactJulie.size()>0 && listContactJulie!= null){
                            
                            mail.setTargetObjectId(listContactJulie.get(0).id);
                          }
                    }
                        
                    
                    mail.saveAsActivity=true;
                    if(mail.getTemplateId()!=null)
                       emailMessages.add(mail); 
                    if (lstAttachments.size() > 0 ) {
                       System.Debug('--- total lstAttachments ---' +lstAttachments.size());
                        mail.setFileAttachments(lstAttachments);
                    }
             if(emailMessages.size()>0){
                List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(emailMessages);
            
             for (Messaging.SendEmailResult sendEmailResult : sendEmailResults) {
             Messaging.SendEmailError[] emailErrors;
                 
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
        return result;
    }
}