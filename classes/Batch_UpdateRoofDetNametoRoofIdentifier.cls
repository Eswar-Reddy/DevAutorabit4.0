/**
 * Created by cdevarapalli on 4/6/17.
 * Updates Name field on the Roof Details for which there is Roof Identifier.
 */

global class Batch_UpdateRoofDetNametoRoofIdentifier implements Database.Batchable<sObject>, Database.Stateful{


    // instance member to retain state across transactions
    global final String Query;
    global final boolean updateRoofDetails;
    global Set<Id> updatedRoofDetailsIdSet = new Set<Id>();
    global Set<Id> processedQuoteIdsSet = new Set<Id>();
    
    global Batch_UpdateRoofDetNametoRoofIdentifier(String q, boolean buRDt){
        Query = q;
        updateRoofDetails = buRDt;
    }

    //Start
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Integer quotesProcessedinthisBatch = 0;
        Set<Id> allquoteIdSet = new Set<Id>();
        Savepoint sp =  Database.setSavepoint();
        Map<Id,Map<String,Roof_Details__c>> qtIdMaproofIndexRDtMap = new Map<Id,Map<String,Roof_Details__c>>();
        List<Roof_Details__c> roofDetailsList = new List<Roof_Details__c>();
        List<Roof_Details__c> toUpdateroofDetailsList = new List<Roof_Details__c>();
        
        try {

            for (Sobject s : scope) {
                Roof_Details__c rDt = (Roof_Details__c)s;
                if (rDt.Quote_Id__c != null){
                    allquoteIdSet.add(rDt.Quote_Id__c);
                }
            }

            Map<Id,Quote> allQuotesMap = new Map<Id,Quote>([SELECT
                                                            Id
                                                            FROM Quote
                                                            WHERE Quote_Wizard__c = null
                                                            AND Is_Locked__c = true
                                                            AND Id in :allquoteIdSet]);
            System.debug('allQuotesMap size ----->' + allQuotesMap.size());

            if(!allQuotesMap.isEmpty())
                roofDetailsList = [SELECT
                                    Name,
                                    Description__c,
                                    CreatedDate,
                                    Quote_Id__c
                                    FROM Roof_Details__c
                                    WHERE Quote_Id__c in :allQuotesMap.keySet()
                                    ORDER BY CREATEDDATE ASC];
            System.debug('roofDetailsList ----->' + roofDetailsList.size());

            for (Roof_Details__c rDt : roofDetailsList) {
                        if(qtIdMaproofIndexRDtMap.containsKey(rDt.Quote_Id__c)){

                            Integer i = qtIdMaproofIndexRDtMap.get(rDt.Quote_Id__c).keySet().size();
                            i++;
                            System.debug('-----> Inside containsKey ----->'+i);
                            qtIdMaproofIndexRDtMap.get(rDt.Quote_Id__c).put(String.valueOf(i),rDt);
                        }
                        else{
                            qtIdMaproofIndexRDtMap.put(rDt.Quote_Id__c, new Map<String,Roof_Details__c>{'1' => rDt});
                        }
            }

            System.debug('qtIdMaproofIndexRDtMap----->'+qtIdMaproofIndexRDtMap);
            for(String qtId : qtIdMaproofIndexRDtMap.keySet()){
                for(String ri : qtIdMaproofIndexRDtMap.get(qtId).keySet()){
                    System.debug('Roof Detail Index ----->'+ ri);
                    System.debug('Rood Detail ----->'+qtIdMaproofIndexRDtMap.get(qtId).get(ri)+'/n');
                }

            }

            for(Map<String,Roof_Details__c> rooIndexRDtMap : qtIdMaproofIndexRDtMap.values()){
                for(String roofIndex : rooIndexRDtMap.keySet()){
                    Roof_Details__c rDt = rooIndexRDtMap.get(roofIndex);
                    rDt.Name  = 'Roof '+roofIndex;
                    toUpdateroofDetailsList.add(rDt);
                }
            }
            System.debug('toUpdateroofDetailsList size ----->' + toUpdateroofDetailsList.size());

            if(!toUpdateroofDetailsList.isEmpty() && updateRoofDetails)
                update toUpdateroofDetailsList;

            for(Roof_Details__c rDt : toUpdateroofDetailsList){
                updatedRoofDetailsIdSet.add(rDt.Id);
            }
            
            if(!allQuotesMap.isEmpty())
            processedQuoteIdsSet.addAll(allQuotesMap.keySet());

        }catch(Exception e){
            quotesProcessedinthisBatch = 0;
            System.debug('Exception Message----->'+e.getMessage());
            System.debug('Exception StackTrace----->'+e.getStackTraceString());
            Database.rollback(sp);

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
            message.subject = ' Batch_UpdateRoofDetNametoRoofIdentifier Exception Email';
            message.plainTextBody = e.getMessage() + '   ' + e.getStackTraceString();
            Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            if (results[0].success) {
                System.debug('The email was sent successfully.');
            } else {
                System.debug('The email failed to send: ' + results[0].errors[0].message);
            }

        }


    }

    //Finish
    global void finish(Database.BatchableContext BC){

        String emailTextBodyString = 'Number of Locked Quotes Processed: '+String.valueOf(processedQuoteIdsSet.size())+ '\n';
        emailTextBodyString = emailTextBodyString + 'Number of Roof Details Updated: '+String.valueOf(updatedRoofDetailsIdSet.size())+ '\n';

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
        message.subject = ' Batch_UpdateRoofDetNametoRoofIdentifier Finish Email';
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