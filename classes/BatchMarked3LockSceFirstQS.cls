global class BatchMarked3LockSceFirstQS implements Database.Batchable<sObject>{

   global String Query;

   
   global BatchMarked3LockSceFirstQS()
   {        
   // Make change here when new Data MIgration
    Query='Select Id,Account_Name__c,Comments__c,CPR_Company_ID__c,CPR_License_ID__c,CPR_QuoteID__c,Create_Amendment_Doc__c,Create_Lease_Docs__c,Create_Termination_Doc__c,CurrencyIsoCode,Dealer_Account__c,Dealer_Installer__c,Dealer__c,Description__c,Edit_Quote_in_CPR__c,Install_Date__c,IsDeleted,Islocked__c,Lease_Doc_Signed__c,Lease_Doc_Terminated__c,Lease_Number__c,Lease_to_be_Amended__c,Lessee__c,Locked_Scenario_Formula__c,Locked_Scenario__c,Name,Old_Lease_Number__c,Old_Quote__c,Opportunity__c,Override_30KW_Limit__c,Override__c,OwnerId,Primary_PSR__c,Quote_Number__c,Quote_View__c,View_Quote__c,(Select Id,Quote_Summary__c From Quotes__r   ORDER BY  Lease_Number__c limit 1) FROM Quote_Summary__c WHERE DMDone__c = 6030330 OR DMDone__c = 6030320 order by createddate asc';   
    
        
        system.debug('kkkkkkkk Query kkkkkkkkk'+Query);
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      System.debug('kkkk query kkkk'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<Quote_Summary__c> lstQS)
   {
        List<Quote> quoteToUpdate = new List<Quote>();
        List<Quote_Summary__c> quoteSummaryToUpdate = new List<Quote_Summary__c>();         
        
        for(Quote_Summary__c cs : lstQS)
        { 
            if(cs.Locked_Scenario__c == null)
            {
            for(Quote qt : cs.Quotes__r)
              {
                  cs.Locked_Scenario__c = qt.Id;
              }  
              
            quoteSummaryToUpdate.add(cs);   
            }           
        }

        if(quoteSummaryToUpdate .size() > 0)
        {
            update quoteSummaryToUpdate ;
        }
    }
    
    global void finish(Database.BatchableContext ctx)
    {       
            AsyncApexJob a = [SELECT id, ApexClassId, 
                           JobItemsProcessed, TotalJobItems, 
                           NumberOfErrors, CreatedBy.Email 
                           FROM AsyncApexJob 
                           WHERE id = :ctx.getJobId()];
            
            String emailMessage = 'Your batch job (BatchMarked3LockSceFirstQS)has finished.  It executed ' 
            
                 + a.totalJobItems 
                 + ' batches.  Of which, ' + a.jobitemsprocessed 
                 + ' processed without any exceptions thrown and ' 
                 + a.numberOfErrors +
                 ' batches threw unhandled exceptions.' ;
            
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