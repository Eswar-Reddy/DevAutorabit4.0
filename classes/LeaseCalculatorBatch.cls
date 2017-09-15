global with sharing class LeaseCalculatorBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable  {
    public String BATCH_QUERY{get; set;}
    
    global String error;
    
    global LeaseCalculatorBatch() {
            
        BATCH_QUERY = 'SELECT ID';
        
        for ( String selectField : LeaseCalcModel.scheduleSummaryFields )
        {
            BATCH_QUERY += ' , ' + selectField;
        }
        date startDate = date.newInstance(2014,08,12);
        
        BATCH_QUERY += ' FROM Lease_Schedule_Summary__c ';
        
 //where clause on a separate line so we can modify conditions
        BATCH_QUERY += 'WHERE Lease_Calculations_Finished__c = false';
        BATCH_QUERY += ' AND ( Placed_in_Service__c <> null ) ';
        System.debug('BATCH_QUERY is : ' + BATCH_QUERY );
        error = '';     
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(BATCH_QUERY);
    }
   
    global void execute(Database.BatchableContext BC, List<Sobject> leaseScheduleSummaries) {
        try {
            
            LeaseCalculator leaseCalculator = new LeaseCalculator(leaseScheduleSummaries);
            
            leaseCalculator.recordCalculations();
            
        }
        catch ( Exception ex ) {
            //write error message to record
            String exceptionString = ex.getMessage();
            exceptionString += '  \n  Line Number: ' + ex.getLineNumber();
            exceptionString += '  \n  ' + ex.getStackTraceString() +'\n\n';
            
            error += exceptionString;
            
        }
    }
    
    global void execute(SchedulableContext SC) {
        LeaseCalculatorBatch batch = new LeaseCalculatorBatch();
        Id batchProcessId = Database.executeBatch(batch, 1);
    }
        
    global void finish(Database.BatchableContext BC) {
        
        if (error != '') {
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id = :BC.getJobId()];
                            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch lease calculations failed ' + a.Status);
            
            mail.setPlainTextBody('The calculations failed!  Error: ' + error);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
       
    }
}