global class CVAROrderAcknowledgementEmailService implements Messaging.InboundEmailHandler{
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
            Opportunity Opportunity = [Select PartnerAccountID,LastModifiedBy.Name,Down_Payment_Invoice_Number__c,Sales_Order_Number__c,owner.email,CRSM__c,CRSM__r.email,(Select OpportunityId,role,contactID,contact.Email From OpportunityContactRoles),id From Opportunity where id =:opportunityid];
            List<String> lstSalesTeam = new List<String>();
            list<ID> listContact = new list<ID>();
            lstSalesTeam.add(Opportunity.owner.email);
            String[] lstSalesTeamCC = new String[] {};
            String[] lstSalesTeamBCC = new String[] {'Julie.Canlubo@sunpowercorp.com'};
            if(Opportunity.CRSM__c != null && Opportunity.CRSM__r.email != null){
                        lstSalesTeamCC = new String[] {Opportunity.CRSM__r.email};
            }
            list<Account> listAccount = [Select id,Commercial_PSR__r.email from Account where id=:Opportunity.PartnerAccountID];
            
            if(listAccount != null && listAccount.size()>0){
                Account objAccount = listAccount.get(0);
                if(objAccount.Commercial_PSR__c != null)
                    lstSalesTeamCC.add(objAccount.Commercial_PSR__r.email);
            }                
            list<Contact> listContactJulie =[Select id from Contact where email like '%julie.delrosario@sunpowercorp.com%'];
            if(listContactJulie.size()==0)
                listContactJulie  = [Select id from Contact limit 1];
//            Contact objContact =[Select id from Contact where email like '%julie.delrosario@sunpowercorp.com%'];
            System.debug('-------------lstSalesTeam'+lstSalesTeam);
            List<EmailTemplate> lstemailTemp =  [select Id, DeveloperName from EmailTemplate  where DeveloperName = 'CVAR_Order_Acknowledgement' and isActive = true] ;
            List<Messaging.Email> emailMessages = new List<Messaging.Email>();
            List<Messaging.EmailFileAttachment> lstAttachments = new List<Messaging.EmailFileAttachment>();
            System.debug('-----Opportunity.id'+Opportunity.id);
            String oppid=Opportunity.Id;
            Messaging.EmailFileAttachment attach ;
            //lstSalesTeam.add('cachedpraveen@gmail.com');
            //lstSalesTeam.add('Julie.Canlubo@sunpowercorp.com');
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(lstemailTemp.get(0).Id);
                    mail.setToAddresses(lstSalesTeam);
                    mail.setbccAddresses(lstSalesTeamBCC);
                    mail.setCcAddresses(lstSalesTeamCC);
                    mail.setSenderDisplayName(Opportunity.LastModifiedBy.Name);
                    //mail.setTargetObjectId(UserInfo.getUserId());
                    if(listContactJulie.size()>0 && listContactJulie!= null){
                        mail.setTargetObjectId(listContactJulie.get(0).id);
                      }
                    mail.setWhatId(Opportunity.Id);
                    mail.saveAsActivity=true;
                    if(mail.getTemplateId()!=null)
                       emailMessages.add(mail); 
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