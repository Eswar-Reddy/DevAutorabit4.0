global class BatchMarkQuote implements Database.Batchable<sObject>{

   global String Query;

   
   global BatchMarkQuote()
   {  

   //### Need to update here when new DM 
   
   Query='Select Id,DM__c,createddate,Locked_Scenario__c,(Select Id,DM__c From Quotes__r) From Quote_Summary__c WHERE (DM__c = 603033 OR DM__c = 603032) ORDER BY createddate asc ';    
        
   System.debug('kkkkkkkk Query kkkkkkkkk'+Query);
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      System.debug('kkkk query kkkk'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<Quote_Summary__c> lstQS)
   {
    List<Quote> quoteToUpdate = new List<Quote>(); 
        
        for (Quote_Summary__c qs : lstqs)
        {
           for(Quote qt : qs.Quotes__r)
           {
               
                if (qs.DM__c == 603033) //### Need to update here when new DM 
                 {
                   qt.DM__c = 603033; 
                 }

                else if (qs.DM__c == 603032)//### Need to update here when new DM 
                 {
                   qt.DM__c = 603032; 
                 }               
           }
           quoteToUpdate .addAll(qs.Quotes__r);
        }
        
        if(quoteToUpdate .size() > 0)
        {
            update quoteToUpdate ;
        }       
    }
    
    global void finish(Database.BatchableContext ctx)
    {       
            AsyncApexJob a = [SELECT id, ApexClassId, 
                           JobItemsProcessed, TotalJobItems, 
                           NumberOfErrors, CreatedBy.Email 
                           FROM AsyncApexJob 
                           WHERE id = :ctx.getJobId()];
            
            String emailMessage = 'Your batch job(BatchMarkQuote) has finished.  It executed ' 
            
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