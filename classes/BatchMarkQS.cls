global class BatchMarkQS implements Database.Batchable<sObject>{

   global String Query;

   
   global BatchMarkQS()
   { 

   Query='Select Id,createddate,Locked_Scenario__c,DM__c,(Select Id From Quotes__r) From Quote_Summary__c WHERE Locked_Scenario__c = null ORDER BY createddate asc '; 

        system.debug('kkkkkkkk Query kkkkkkkkk'+Query);
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      System.debug('kkkk query kkkk'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<Quote_Summary__c> lstQS)
   {
              
    List<Quote_Summary__c> QSToUpdate = new List<Quote_Summary__c>();
        
        for (Quote_Summary__c qs : lstqs)
        {
           if (qs.Quotes__r.size() > 1)
           {
                if (qs.Quotes__r.size() == 3)
                   {
                     qs.DM__c = 603033;    //## Update Here 
                   }

                else if(qs.Quotes__r.size() == 2) 
                   {
                     qs.DM__c = 603032;   //## Update Here 
                   }
                QSToUpdate.add(qs);            
           }    
        }
        
        if(QSToUpdate .size() > 0)
        {
            update QSToUpdate ;
        }       
    }
    
    global void finish(Database.BatchableContext ctx)
    {       
            AsyncApexJob a = [SELECT id, ApexClassId, 
                           JobItemsProcessed, TotalJobItems, 
                           NumberOfErrors, CreatedBy.Email 
                           FROM AsyncApexJob 
                           WHERE id = :ctx.getJobId()];
            
            String emailMessage = 'Your batch job(BatchMarkQS) has finished.  It executed ' 
            
                 + a.totalJobItems 
                 + ' batches.  Of which, ' + a.jobitemsprocessed 
                 + ' processed without any exceptions thrown and ' 
                 + a.numberOfErrors +
                 ' batches threw unhandled exceptions.'
                 
            /*   
                 + '  Of the batches that executed without error, ' 
                 + failedUpdates 
                 + ' records were not updated successfully.'
            */
            ;
            
            Messaging.SingleEmailMessage mail = 
                  new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'amit.saha@birlasoft.com'};
            String[] ccAddresses = new String[] {'amitsahabirlasoft@gmail.com'};
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            mail.setReplyTo('amit.saha@birlasoft.com');
            mail.setSenderDisplayName('Batch Job Summary');
            mail.setSubject('Batch job completed');
            mail.setPlainTextBody(emailMessage);
            mail.setHtmlBody(emailMessage);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] 
                               { mail });
     }

}