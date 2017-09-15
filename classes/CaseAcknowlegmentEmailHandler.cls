global class CaseAcknowlegmentEmailHandler implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String subject = email.subject;
        System.debug(LoggingLevel.INFO,'In Email service->');
        //subject format Case: {!Case.CaseNumber} - {!Case.Subject} - P1 Notification
        System.debug(LoggingLevel.INFO,'Sub->'+subject.indexOf('Case #'));
        if(subject.contains('Case #')){
            String casenumber = subject.substring(subject.indexOf('Case #')+6,subject.indexOf('Case #')+14);
            System.debug(LoggingLevel.INFO,'Case No->'+casenumber);
            String body = email.plainTextBody;
            System.debug(LoggingLevel.INFO,'Body->'+body);
            System.debug(LoggingLevel.INFO,'html Body->'+email.htmlBody);
            
            Case caseobj;
            List<Case> caseList = [Select Id, P1_Acknowledgement__c, P5_Acknowledgement__c, P30_Acknowledgement__c
             from Case where CaseNumber =:casenumber limit 1];
             Boolean isupdate=false;
             if(caselist.size()>0){
                caseobj = caseList.get(0);
                //List<Task> taskList = new List<Task>();
                //if(body.contains('In line with our commitment to customer satisfaction through P1/P5/P30 strategy, please acknowledge the complaint/case logged in 24 hrs/ 1 business day')){
                if(subject.contains('P1 Notification')){
                    caseobj.P1_Acknowledgement__c = true;
                    caseobj.Complaint_Acknowledgement_Info__c = body;
                    isupdate = true;
                }           
                //else if(body.contains('There is a follow up that has to be done prior to')){
                if(subject.contains('P5 Follow Up Reminder')){              
                    caseobj.P5_Acknowledgement__c = true;
                    caseobj.Complaint_Acknowledgement_Info__c = body;
                    isupdate = true;
                }
                //else if(body.contains('In line with our commitment to customer satisfaction through P1/P5/P30 strategy, please acknowledge the complaint/case logged in 24 hrs/ 1 business day. See case description for more information')){
                if(subject.contains('P30 Notification')){
                    caseobj.P30_Acknowledgement__c = true;
                    caseobj.Complaint_Acknowledgement_Info__c = body;                    
                    isupdate = true;                            
                }
                System.debug(LoggingLevel.INFO,'P30_Acknowledgement__c->'+caseobj.P30_Acknowledgement__c);
                System.debug(LoggingLevel.INFO,'P5_Acknowledgement__c->'+caseobj.P5_Acknowledgement__c);
                System.debug(LoggingLevel.INFO,'P1_Acknowledgement__c->'+caseobj.P1_Acknowledgement__c);
                //insert taskList;
                if(isupdate)
                    update caseobj;
             }
        }
        result.success = true;      
        return result;
      }
}