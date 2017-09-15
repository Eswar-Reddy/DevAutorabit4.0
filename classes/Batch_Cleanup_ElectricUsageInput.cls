//
global class Batch_Cleanup_ElectricUsageInput implements Database.Batchable<sObject>, Database.Stateful{

        global final String Query;

        global Batch_Cleanup_ElectricUsageInput(String q, boolean d) {
            Query=q;
        }

        //Start
        global Database.QueryLocator start(Database.BatchableContext BC){

            return Database.getQueryLocator(query);
        }

        //Execute
        global void execute(Database.BatchableContext BC, List<sObject> scope){
            List<Electric_Rate_Usage_Input__c> toUpdateElectricRateUsageInputs = new List<Electric_Rate_Usage_Input__c>();

            try {

                for (Sobject s : scope) {
                    Electric_Rate_Usage_Input__c erui = (Electric_Rate_Usage_Input__c)s;
                    erui.Usage__c = null;
                    erui.Annual_Usage__c = null;
                    erui.Monthly_bill__c = null;
                    erui.Annual_Bill__c = null;
                    erui.Current_Rate__c = null;
                    erui.Current_rate_code__c = null;
                    erui.Proposed_rate__c = null;
                    erui.Proposed_rate_code__c = null;
                    erui.Utility_Description__c = null;
                    erui.Monthly_Jan__c = null;
                    erui.Monthly_Feb__c = null;
                    erui.Monthly_Mar__c = null;
                    erui.Monthly_Apr__c = null;
                    erui.Monthly_May__c = null;
                    erui.Monthly_Jun__c = null;
                    erui.Monthly_Jul__c = null;
                    erui.Monthly_Aug__c = null;
                    erui.Monthly_Sep__c = null;
                    erui.Monthly_Oct__c = null;
                    erui.Monthly_Nov__c = null;
                    erui.Monthly_Dec__c = null;
                    toUpdateElectricRateUsageInputs.add(erui);
                }

                if(!toUpdateElectricRateUsageInputs.isEmpty())
                    update toUpdateElectricRateUsageInputs;

            }catch (Exception e){
                System.debug('Exception Message----->'+e.getMessage());
                System.debug('Exception StackTrace----->'+e.getStackTraceString());
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
                message.subject = ' Batch_Cleanup_ElectricUsageInput Exception Email';
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

            String emailTextBodyString = 'Finished updating Electric Rate Usage Inputs';

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
            message.subject = ' Batch_Cleanup_ElectricUsageInput Finish Email';
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