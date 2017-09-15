/**
 * Created by cdevarapalli on 3/29/17.
 * Batch Class to Retrofit Non EDDiE quotes to adhere to the EDDiE Data Mode
 * Inserts missing Inverter Configurations
 * Inserts Roof Designs
 * Inserts Inverter Lists
 * Updates Roof Details
 */

global class Batch_RetrofitQuotesforEDDiE implements Database.Batchable<sObject>, Database.Stateful{

    // instance member to retain state across transactions
    global Integer quotesProcessed = 0;
    global Integer quoteswithRoofDetails = 0;
    global Integer quoteswithNoRoofDetails = 0;
    global Integer totalNoofRoofDetailsUpdated = 0;
    global Set<Id> quoteswithNoRDtSet = new Set<Id>();
    global List<Quote> quoteswithNoRDtList = new List<Quote>();
    global Set<String> inverterModelSetInserted = new Set<String>();
    global Set<Id> noIdentifierRDetIdSet = new Set<Id>();
    global final String Query;
    global final boolean insertRoofDesigns;
    global final boolean insertInverterConfigs;
    global final boolean insertInverterLists;
    global final boolean updateRoofDetails;

    global Batch_RetrofitQuotesforEDDiE(String q, boolean biRD, boolean biIC, boolean biIL, boolean buRDt) {
        Query = q;
        insertRoofDesigns = biRD;
        insertInverterConfigs = biIC;
        insertInverterLists = biIL;
        updateRoofDetails = buRDt;
    }

    //Start
    global Database.QueryLocator start(Database.BatchableContext BC){

        return Database.getQueryLocator(query);
    }


    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Integer quotesProcessedinthisBatch = 0;
        Savepoint sp =  Database.setSavepoint();

        try {
            Map<Id, Quote> quotesMap = new Map<Id, Quote>();                            // Map of All Quotes for this Batch
            List<Roof_Design__c> toInsertRoofDesignsList = new List<Roof_Design__c>();  //
            Map<Id,Id> quoteIdRoofDesignIdMap = new Map<Id,Id>();                       //
            List<Roof_Details__c> toUpdateRoofDetailsList = new List<Roof_Details__c>();//
            Set<String> quoteswithRDtSet = new Set<String>();                           //Set of Quote Ids with Roof Details
            Map<String, List<Roof_Details__c>> quoteIdListRoofDetailsMap = new Map<String, List<Roof_Details__c>>();
            Set<String> thisBatchInverterModelSet = new Set<String>();
            List<Inverter_Configuration__c> toInsertICList = new List<Inverter_Configuration__c>();
            Map<String,Id> invNameICIdMap = new Map<String,Id>();
            Map<Id,Map<String,Roof_Details__c>> qtIdMaproofIndexRDtMap = new Map<Id,Map<String,Roof_Details__c>>();
            List<InverterList__c> toInsertInverterLists = new List<InverterList__c>();
            Map<String,String> indexplusRoofDesignIdandInvListIdMap = new Map<String,String>();

            for (Sobject s : scope) {
                Quote q = (Quote)s;
                if (q.Quote_Wizard__c == null && q.Equinox_Designs__r.isEmpty()) {
                    quotesMap.put(q.Id,q);
                    quotesProcessedinthisBatch ++;
                }
            }
            System.debug('quotesMap----- Size>' + quotesMap.size());

            //---------------------------Querying Roof Details-------------------------//
            List<Roof_Details__c> roofDetailsList = new List<Roof_Details__c>([
                    SELECT  Name,
                            Description__c,
                            Quote__c,Quote_Id__c,
                            Roof_Design__c,
                            Inverter_Model__c
                    FROM Roof_Details__c
                    WHERE Quote_Id__c in :quotesMap.keySet()
            ]);
            System.debug('roofDetailsList----->' + roofDetailsList);


            //---------------------------Preparing Quote Roof Details and Quote with Roof Details Set-------------------------//
            for (Roof_Details__c rDt : roofDetailsList) {
                if (quoteIdListRoofDetailsMap.containsKey(rDt.Quote_Id__c)) {
                    quoteIdListRoofDetailsMap.get(rDt.Quote_Id__c).add(rDt);
                } else {
                    quoteIdListRoofDetailsMap.put(rDt.Quote_Id__c, new List<Roof_Details__c>{rDt});
                }
                quoteswithRDtSet.add(rDt.Quote_Id__c);
            }
            System.debug('quoteswithRDtSet----->' + quoteswithRDtSet);
            System.debug('quoteswithRDtSet Size----->' + quoteswithRDtSet.size());
            System.debug('quoteIdListRoofDetailsMap----->' + quoteIdListRoofDetailsMap);

            for(Quote qt: quotesMap.values()){
                if(quoteswithRDtSet.contains(qt.Id)){
                    quoteswithRoofDetails++;
                }
                else{
                    quoteswithNoRDtSet.add(qt.Id);
                    quoteswithNoRDtList.add(qt);
                    quoteswithNoRoofDetails++;
                }

                if(qt.Inverter_Model__c != null){
                    thisBatchInverterModelSet.add(qt.Inverter_Model__c);
                }
                if(qt.Inverter_Model_2__c != null){
                    thisBatchInverterModelSet.add(qt.Inverter_Model_2__c);
                }
                if(qt.Inverter_Model_3__c != null){
                    thisBatchInverterModelSet.add(qt.Inverter_Model_3__c);
                }
                if(qt.Inverter_Model_4__c != null){
                    thisBatchInverterModelSet.add(qt.Inverter_Model_4__c);
                }
            }

            //--------------------------Inserting Roof Designs---------------------------//
            for(String qtId : quoteswithRDtSet) {
                toInsertRoofDesignsList.add(new Roof_Design__c(Quote__c = qtId, Type__c = 'Actual', Status__c = 'Locked',
                        RecordTypeId = '01234000000UQTl', EDDiE_Retrofit__c = true));
            }
            System.debug('toInsertRoofDesignsList Size----->' + toInsertRoofDesignsList.size());
            System.debug('toInsertRoofDesignsList----->' + toInsertRoofDesignsList);

            if(!toInsertRoofDesignsList.isEmpty() && insertRoofDesigns)
                insert toInsertRoofDesignsList;
            System.debug('Roof Designs Inserted ----->');
            for(Roof_Design__c rd : toInsertRoofDesignsList){
                quoteIdRoofDesignIdMap.put(rd.Quote__c, rd.Id);
            }
            System.debug('quoteIdRoofDesignIdMap----->'+quoteIdRoofDesignIdMap);



            //---------------------------Inserting Inverter Model Configurations----------------------//
            List<Inverter_Configuration__c> icList = new List<Inverter_Configuration__c>([SELECT
                                                                                            Id,
                                                                                            Name
                                                                                            FROM Inverter_Configuration__c]);

            for(Inverter_Configuration__c ic : icList){
                invNameICIdMap.put(ic.Name, ic.Id);
            }
            System.debug('Existing Inverters ----->'+invNameICIdMap);

            for(String imName : thisBatchInverterModelSet){
                if(!invNameICIdMap.keySet().contains(imName)){
                    if(imName.length()>80)
                        imName = imName.substring(0,80);
                    toInsertICList.add(new Inverter_Configuration__c(Name = imName));
                }
            }
            System.debug('Inverters to Insert ----->'+toInsertICList);

            if(!toInsertICList.isEmpty() && insertInverterConfigs)
                insert toInsertICList;

            for(Inverter_Configuration__c ic : toInsertICList){
                invNameICIdMap.put(ic.Name, ic.Id);
            }
            System.debug('All Inverters Map ----->'+invNameICIdMap);


            //----------------------------Making a Map of Quote and Roof Details------------------------------//
            for(String qtId : quoteswithRDtSet){
                for (Roof_Details__c rDt : quoteIdListRoofDetailsMap.get(qtId)) {
                    //System.debug('rDt----->'+rDt);
                    for (integer i=1; i<=4; i++) {
                        String roofIndex = String.valueOf(i);
                        if((rDt.Name != null && rDt.Name.contains('Roof '+roofIndex))){
                            if(qtIdMaproofIndexRDtMap.containsKey(qtId)){
                                qtIdMaproofIndexRDtMap.get(qtId).put(roofIndex, rDt);
                                break;
                            }
                            else{
                                qtIdMaproofIndexRDtMap.put(qtId, new Map<String,Roof_Details__c>{roofIndex => rDt});
                                break;
                            }
                            System.debug('qtIdMaproofIndexRDtMap----->'+qtIdMaproofIndexRDtMap);
                        }
                        else {
                            noIdentifierRDetIdSet.add(rDt.Id);
                        }
                    }

                }
            }
            System.debug('qtIdMaproofIndexRDtMap----->'+qtIdMaproofIndexRDtMap);


            //----------------------------Updating Roof Details--------------------------//
            for(String qtId : quoteswithRDtSet){
                Quote qt = quotesMap.get(qtId);
                if(qtIdMaproofIndexRDtMap.get(qt.Id) != null){
                    for (String roofIndex : qtIdMaproofIndexRDtMap.get(qt.Id).KeySet()) {
                        String imanFieldName = 'Inverter_Manufacturer_Roof'+roofIndex+'__c';
                        String mpsFieldName = 'Modules_Per_String_Roof'+roofIndex+'__c';
                        String tpsrFieldName = 'Total_Parallel_Strings_Roof'+roofIndex+'__c';
                        String imodFieldName = roofIndex == '1'? 'Inverter_Model__c' :
                                (roofIndex == '2' ? 'Inverter_Model_2__c':
                                        (roofIndex == '3' ? 'Inverter_Model_3__c' :
                                                (roofIndex == '4' ? 'Inverter_Model_4__c' : null)));
                        String inquFieldName = roofIndex == '1'? 'Inverter_Quantity__c' :
                                (roofIndex == '2' ? 'Inverter_Quantity_2__c':
                                        (roofIndex == '3' ? 'Inverter_Quantity_3__c' :
                                                (roofIndex == '4' ? 'Inverter_Quantity_4__c' : null)));

                        qtIdMaproofIndexRDtMap.get(qt.Id).get(roofIndex).Inverter_Manufacturer__c = (String)qt.get(imanFieldName);
                        qtIdMaproofIndexRDtMap.get(qt.Id).get(roofIndex).Modules_per_strings__c = (Decimal)qt.get(mpsFieldName);
                        qtIdMaproofIndexRDtMap.get(qt.Id).get(roofIndex).Total_parallel_strings__c = (Decimal)qt.get(tpsrFieldName);
                        qtIdMaproofIndexRDtMap.get(qt.Id).get(roofIndex).Inverter_Model__c = (String)qt.get(imodFieldName);
                        qtIdMaproofIndexRDtMap.get(qt.Id).get(roofIndex).Inverter_Count__c = (Decimal)qt.get(inquFieldName);
                        qtIdMaproofIndexRDtMap.get(qt.Id).get(roofIndex).Roof_Design__c = quoteIdRoofDesignIdMap.get(qt.Id);
                    }
                }
            }
            System.debug('qtIdMaproofIndexRDtMap----->'+qtIdMaproofIndexRDtMap);



            //--------------------------Inserting Inverter List for Roof Details--------------------//
            for(String qtId : quoteswithRDtSet){
                if(qtIdMaproofIndexRDtMap.get(qtId) != null) {
                    for (String roofIndex : qtIdMaproofIndexRDtMap.get(qtId).KeySet()) {
                        Roof_Details__c rDt = qtIdMaproofIndexRDtMap.get(qtId).get(roofIndex);
                        if (rDt.Inverter_Count__c > 0) {
                            String icName = (rDt.Inverter_Model__c != null && rDt.Inverter_Model__c.length() > 80) ?
                                    rDt.Inverter_Model__c.substring(0,80) : rDt.Inverter_Model__c;
                            toInsertInverterLists.add(new InverterList__c(Name = icName, InverterConfiguration__c =
                                    invNameICIdMap.get(icName), Index__c = Integer.valueOf(roofIndex),
                                    RoofDesign__c = quoteIdRoofDesignIdMap.get(qtId), EDDiE_Retrofit__c = true));
                        }
                    }
                }
            }

            if(!toInsertInverterLists.isEmpty() && insertInverterLists)
                insert toInsertInverterLists;
            System.debug('toInsertInverterLists----->'+toInsertInverterLists);
            for(InverterList__c il : toInsertInverterLists){
                indexplusRoofDesignIdandInvListIdMap.put(String.valueOf(il.Index__c) + il.RoofDesign__c,il.Id);
            }
            System.debug('indexplusRoofDesignIdandInvListIdMap----->'+indexplusRoofDesignIdandInvListIdMap);



            //----------------------------Updating Roof Details and adding to Updating List--------------------------//
            for(String qtId : quoteswithRDtSet) {
                if(qtIdMaproofIndexRDtMap.get(qtId) != null) {
                    for (String roofIndex : qtIdMaproofIndexRDtMap.get(qtId).KeySet()) {
                        Roof_Details__c rDt = qtIdMaproofIndexRDtMap.get(qtId).get(roofIndex);

                        if (rDt.Inverter_Count__c > 0) {
                            rDt.Inverter_List__c = indexplusRoofDesignIdandInvListIdMap.get(roofIndex + rDt.Roof_Design__c);
                        } else if ((rDt.Inverter_Count__c == 0 || rDt.Inverter_Count__c == null) && Integer.valueOf(roofIndex) > 1) {
                            String beforeroofIndex = String.valueOf(Integer.valueOf(roofIndex) - 1);
                            if (qtIdMaproofIndexRDtMap.get(qtId).containsKey(beforeroofIndex)
                                    && qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c > 0) {
                                rDt.Inverter_List__c = indexplusRoofDesignIdandInvListIdMap.get(beforeroofIndex + rDt.Roof_Design__c);
                            } else if (qtIdMaproofIndexRDtMap.get(qtId).containsKey(beforeroofIndex)
                                    && (qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c == 0 || qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c == 0)
                                    && Integer.valueOf(beforeroofIndex) > 1) {
                                beforeroofIndex = String.valueOf(Integer.valueOf(beforeroofIndex) - 1);
                                if (qtIdMaproofIndexRDtMap.get(qtId).containsKey(beforeroofIndex)
                                        && qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c > 0) {
                                    rDt.Inverter_List__c = indexplusRoofDesignIdandInvListIdMap.get(beforeroofIndex + rDt.Roof_Design__c);
                                } else if (qtIdMaproofIndexRDtMap.get(qtId).containsKey(beforeroofIndex)
                                        && (qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c == 0 || qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c == 0)
                                        && Integer.valueOf(beforeroofIndex) > 1) {
                                    beforeroofIndex = String.valueOf(Integer.valueOf(beforeroofIndex) - 1);
                                    if (qtIdMaproofIndexRDtMap.get(qtId).containsKey(beforeroofIndex)
                                            && qtIdMaproofIndexRDtMap.get(qtId).get(beforeroofIndex).Inverter_Count__c > 0) {
                                        rDt.Inverter_List__c = indexplusRoofDesignIdandInvListIdMap.get(beforeroofIndex + rDt.Roof_Design__c);
                                    }
                                }
                            }
                        }
                        System.debug('rDt----->'+rDt);
                        toUpdateRoofDetailsList.add(rDt);
                    }
                }
            }
            System.debug('toUpdateRoofDetailsList Size ----->'+toUpdateRoofDetailsList.size());
            System.debug('toUpdateRoofDetailsList----->'+toUpdateRoofDetailsList);

            //-------------------------------------Finally Updating Roof Details--------------------------//
            if(!toUpdateRoofDetailsList.isEmpty() && updateRoofDetails){
                update toUpdateRoofDetailsList;
            }

            totalNoofRoofDetailsUpdated = totalNoofRoofDetailsUpdated + toUpdateRoofDetailsList.size();
            quotesProcessed = quotesProcessed + quotesProcessedinthisBatch;
            for(Inverter_Configuration__c iConfig : toInsertICList){
                inverterModelSetInserted.add(iConfig.Name);
            }
            System.debug('<----- Roof Details Updated ----->');
        }catch(Exception e){
            quotesProcessedinthisBatch = 0;
            System.debug('Exception Message----->'+e.getMessage());
            System.debug('Exception StackTrace----->'+e.getStackTraceString());
            Database.rollback(sp);

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
            message.subject = ' Batch_RetrofitQuotesforEDDiE Exception Email';
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

        System.debug('quotesProcessed----->'+quotesProcessed);
        System.debug('quoteswithRoofDetails----->'+quoteswithRoofDetails);
        System.debug('quoteswithNoRoofDetails----->'+quoteswithNoRoofDetails);
        System.debug('quoteswithNoRDtSet----->'+quoteswithNoRDtSet);
        System.debug('noIdentifierRDetIdSet----->'+noIdentifierRDetIdSet);
        System.debug('noIdentifierRDetIdSet size----->'+noIdentifierRDetIdSet.size());

        String quoteswithNoRDtSetString = '\n'+'Locked Quotes with No Roof Details:'+'\n';

        for(Quote qt : quoteswithNoRDtList){
            quoteswithNoRDtSetString = quoteswithNoRDtSetString + '-----> ' + qt.Id +'     '+ qt.CreatedBy.Name +'     '+ qt.CreatedDate +'\n';
        }

        String insertedinverterModels = 'Inverter Configurations insterted for :'+'\n';
        for(String icN : inverterModelSetInserted){
            System.debug('----->'+icN+'\n');
            insertedinverterModels = insertedinverterModels + '-----> '+icN+'\n';
        }

        String emailTextBodyString = 'Number of Locked Quotes Processed: '+String.valueOf(quotesProcessed)+ '\n';
        emailTextBodyString += 'Number of Locked Quotes with Roof Details: '+String.valueOf(quoteswithRoofDetails) + '\n';
        emailTextBodyString += 'Number of Locked Quotes without Roof Details: '+String.valueOf(quoteswithNoRoofDetails)+'\n';
        emailTextBodyString += 'Number of Inverter Models inserted: '+ String.valueOf(inverterModelSetInserted.size()) + '\n';
        emailTextBodyString += 'Number of Roof Details updated: '+ String.valueOf(totalNoofRoofDetailsUpdated) + '\n';
        emailTextBodyString += quoteswithNoRDtSetString + '\n' + insertedinverterModels;

        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] {'cdevarapalli@sunpowercorp.com'};
        message.subject = ' Batch_RetrofitQuotesforEDDiE Finish Email';
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