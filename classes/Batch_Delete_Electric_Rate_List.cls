//
global class Batch_Delete_Electric_Rate_List implements Database.Batchable<sObject>, Database.Stateful{

    global final String Query;
    global final boolean deleteRecords;

    global Batch_Delete_Electric_Rate_List(String q, boolean d) {
        Query = q;
        deleteRecords = d;
    }

    //Start
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);
    }

    //Execute
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Electric_Rate_List__c> toDeleteElectric_rate_lists = new List<Electric_Rate_List__c>();

            for (Sobject s : scope) {
                Electric_Rate_List__c erl = (Electric_Rate_List__c)s;
                toDeleteElectric_rate_lists.add(erl);
            }

            if(deleteRecords && !toDeleteElectric_rate_lists.isEmpty())
                delete toDeleteElectric_rate_lists;
    }

    //Finish
    global void finish(Database.BatchableContext BC){

        String emailTextBodyString = 'Finished deleted Electric Rate Lists';

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
        message.subject = ' Batch_Delete_Electric_Rate_List Finish Email';
        message.plainTextBody = emailTextBodyString;
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
    }


}