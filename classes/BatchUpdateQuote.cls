global class BatchUpdateQuote implements Database.Batchable<sObject>
{
   global String Query;
   
   global BatchUpdateQuote()
   {        
        Query='Select id, (select id, quote__c, Current_Quantity_kWh__c from Electric_Bill_Details__r) from quote where createddate >= 2013-06-17T00:00:00.000Z And RecordtypeId=\'01280000000PzNK\' and Power_Used_Before_Solar_kWh_year__c=\'\' '; 
        
        //Query='Select id, (select id, quote__c, Current_Quantity_kWh__c from Electric_Bill_Details__r) from quote where Id = \'0Q0Q0000000MNmuKAG\'';       
      
        system.debug('kkkkkkkk Query kkkkkkkkk'+Query);
   }

   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      System.debug('kkkk query kkkk'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<Quote> qtEBList)
   {
        List<Quote> quoteToUpdate = new List<Quote>();
        Decimal powerUsedBeforeSolar;

        for(Quote qt : qtEBList)
        {   
            powerUsedBeforeSolar = 0;
            
            for(Electric_Bill_Detail__c eb : qt.Electric_Bill_Details__r)
            {
                powerUsedBeforeSolar += eb.Current_Quantity_kWh__c;
            }
            System.debug('qt.id : ' + qt.id + ' powerUsedBeforeSolar : ' + powerUsedBeforeSolar);
            
            if(powerUsedBeforeSolar != 0)
            {
                qt.Power_Used_Before_Solar_kWh_year__c = String.valueof(powerUsedBeforeSolar);
                quoteToUpdate.add(qt);
            }
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
            
            String emailMessage = 'Your batch job (BatchUpdateQuote)has finished.  It executed ' 
            
                 + a.totalJobItems 
                 + ' batches.  Of which, ' + a.jobitemsprocessed 
                 + ' processed without any exceptions thrown and ' 
                 + a.numberOfErrors +
                 ' batches threw unhandled exceptions.' ;
            
            Messaging.SingleEmailMessage mail = 
                  new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {'amit.saha@birlasoft.com'};
            String[] ccAddresses = new String[] {'amitsahabirlasoft@gmail.com','rehan.mohammad@birlasoft.com','Sandesh.Dongari@sunpowercorp.com'};
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