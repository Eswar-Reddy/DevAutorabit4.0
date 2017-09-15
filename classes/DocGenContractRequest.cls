public with sharing class DocGenContractRequest {

    public Map<String,Map<String,String>> sObjectFieldMap {get;private set;}
    public Map<String,DocGenContractRequest__c> jsonFieldAPIMap {get;private set;}
    public List<DocGenContractRequest__c> settings {get;private set;}
    public Quote quoteRecordToSend {get;set;}
    public Account accountRecordToSend {get;set;}
    public Account partnerAccountRecord {get;set;}
    public User partnerUserRecord {get;set;}
    public List<Lease_Schedule__c> leasePaymentList {get;set;}
    public System_Production__c systemProduction {get;set;}
    public List<Contact> contactList;
    public List<Contact> primaryContact;
    public Map<Integer,String> monthMap;
    public String Date_Today;
    public Id quoteId{get;set;}
    public String request;
    public Exception_Log__c exceptionLog;
    public Sunpower_Spectrum_Debug_Log__c spectrumDebugLog;
    public List<sObject> sObjectList;

    public DocGenContractRequest(){
        monthMap = new map<Integer,String>();
        monthMap.put(1,'January');
        monthMap.put(2,'February');
        monthMap.put(3,'March');
        monthMap.put(4,'April');
        monthMap.put(5,'May');
        monthMap.put(6,'June');
        monthMap.put(7,'July');
        monthMap.put(8,'August');
        monthMap.put(9,'September');
        monthMap.put(10,'October');
        monthMap.put(11,'November');
        monthMap.put(12,'December');

        String month1 = monthMap.get(Date.today().month());
        Integer day1 = Date.today().day();
        Integer year1 = Date.today().year();
        Date_Today = month1 + ' '+day1+','+year1;
        loadSettings();
        request = null;
        exceptionLog = null;
        spectrumDebugLog = new Sunpower_Spectrum_Debug_Log__c();
        spectrumDebugLog.Name = 'Error';
        sObjectList = null;
    }

    private void loadSettings(){
        sObjectFieldMap = new Map<String,Map<String,String>>();
        jsonFieldAPIMap = new Map<String,DocGenContractRequest__c>();


        //Instance method of List Custom Settings to get all in the list
        settings = DocGenContractRequest__c.getAll().values();
        for(DocGenContractRequest__c ss : settings){

            // sObjectFieldMap
            if(!sObjectFieldMap.containsKey(ss.sObject_Name__c))
                sObjectFieldMap.put(ss.sObject_Name__c,new Map<String,String>());
            //Populates Map with JsonString and actual apiname. then, we will insert this map to sObjectFieldMap
            Map<String,String> jsonFieldMap = sObjectFieldMap.get(ss.sObject_Name__c);
            if(ss.Name != null)
                jsonFieldMap.put(ss.Name,ss.Field_API_Name__c);
            else
                jsonFieldMap.put(ss.Field_API_Name__c,ss.Field_API_Name__c);
            sObjectFieldMap.put(ss.sObject_Name__c,jsonFieldMap);
            // jsonFieldAPIMap
            jsonFieldAPIMap.put(ss.Name,ss);
        }
    }

    public List<sObject> sendDataToDocGen(echosign_dev1__SIGN_Agreement__c agrment,Id quoteId,Id recordTypeId,String waterMark,String agreementName,String addnlRecipient,String changeOrderType,string documentType){
        try{
            sObjectList = new List<sObject>();
            this.quoteId = quoteId;
            populateRecords();
            request = buildJSON(agrment,waterMark,changeOrderType,documentType);
            handleRequest(request,quoteRecordToSend,recordTypeId,agreementName,addnlRecipient,changeOrderType,Null,NUll);

        }
        catch(Exception e){
            exceptionLog = new Exception_Log__c();
            exceptionLog.Quote__c = quoteId;
            exceptionLog.Error_Message__c = e.getMessage();
            exceptionLog.Stack_Trace__c = e.getStackTraceString();
            system.debug('Error is '+e.getMessage()+ ' and stack trace is '+e.getStackTraceString());
        }
        sObjectList.add(exceptionLog);
        sObjectList.add(spectrumDebugLog);
        return sObjectList;

    }

    public void populateRecords(){

        quoteRecordToSend = Database.query(buildQuery('SELECT id,Account__c,CreatedById,Partner_Account_Id__c,OpportunityId,Account__r.Name,','Quote',' FROM Quote WHERE Id = :quoteId'));
        Id accId = quoteRecordToSend.Account__c;
        Id partnerAccountId = quoteRecordToSend.Partner_Account_Id__c;
        Id partnerUserId = quoteRecordToSend.CreatedById;
        contactList = Database.query('SELECT id,Name FROM Contact where AccountId = :accId AND primary__c = false AND Include_in_Lease_Doc__c = true limit 1');
        primaryContact = Database.query(buildQuery('SELECT id,','Contact',' FROM Contact where AccountId = :accId AND Primary__c = true limit 1'));
        partnerAccountRecord = Database.query(buildQuery('SELECT id,','Partner Account',' FROM Account where id = :partnerAccountId'));
        accountRecordToSend = Database.query(buildQuery('SELECT id,Partner_Account__r.Channel__c,Name,','Account',' FROM Account WHERE Id = :accId'));
        partnerUserRecord = Database.query(buildQuery('SELECT id,','User',' FROM User where Id = :partnerUserId'));
        leasePaymentList = Database.query(buildQuery('SELECT id,','Lease_Schedule__c',' FROM Lease_Schedule__c WHERE Quote__c = :quoteId'));
        systemProduction = Database.query(buildQuery('SELECT id,','System_Production__c',' FROM System_Production__c WHERE Quote__c = :quoteId'));
    }

    private String buildJSON(echosign_dev1__SIGN_Agreement__c agrment,String waterMark,String changeOrderType,string documentType){
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('apiKey',String.valueOf(DocGen_Callout_Settings__c.getAll().get('DocGen').apiKey__c));
        gen.writeStringField('templateName','');
        gen.writeStringField('watermark',waterMark);
        gen.writeFieldName('nameValuePairs');
        gen.writeStartArray();
        gen.writeStartObject();
            gen.writeStringField('name', 'Note');
            if(quoteRecordToSend.Ecobee_User__c)
                gen.writeStringField('value',Label.Ecobee);
            else
                gen.writeStringField('value', '');
        gen.writeEndObject();
        // Added for Cancellation template
          gen.writeStartObject();
            gen.writeStringField('name', 'changeOrderType');
            gen.writeStringField('value', changeOrderType);
         gen.writeEndObject();
       gen.writeStartObject();
            gen.writeStringField('name', 'documentType');
            gen.writeStringField('value', documentType);
         gen.writeEndObject();
        gen.writeStartObject();
        system.debug('quoteRecordToSend.System_Cost__c:'+quoteRecordToSend.System_Cost__c);
            gen.writeStringField('name', 'NetSystemPrice');
            if(quoteRecordToSend.System_Cost__c != null && quoteRecordToSend.Solar_Rebate_Amount__c != null){
                double NetSystemPrice = (quoteRecordToSend.System_Cost__c - quoteRecordToSend.Solar_Rebate_Amount__c).SetScale(2);
                 gen.writeStringField('value',formatCurrency(NetSystemPrice.format()));
            }
            else
                gen.writeStringField('value', '');
        gen.writeEndObject();
        gen.writeStartObject();
            gen.writeStringField('name', 'NetContractPrice');
            if(quoteRecordToSend.Total_Contract_Price__c != null && quoteRecordToSend.Solar_Rebate_Amount__c != null){
                Decimal netContractPrice = (quoteRecordToSend.Total_Contract_Price__c - quoteRecordToSend.Solar_Rebate_Amount__c).SetScale(2);
                 gen.writeStringField('value',formatCurrency(netContractPrice.format()));
            }
            else
                gen.writeStringField('value', '');
        gen.writeEndObject();

         if(agrment <> Null && (changeOrderType == 'Cancellation'|| changeOrderType == 'Notice of Cancellation')){
            String month1 =  monthMap.get(agrment.echosign_dev1__DateSignedDate__c.month());
            Integer day1 = agrment.echosign_dev1__DateSignedDate__c.day();
            Integer year1 = agrment.echosign_dev1__DateSignedDate__c.year();
            string sCounterSignDate = month1 + ' '+day1+','+year1;
            gen.writeStartObject();
              gen.writeStringField('name', 'date');
              gen.writeStringField('value', sCounterSignDate);
            gen.writeEndObject(); 
        }
        else {
        if(Date_Today != ''){
            gen.writeStartObject();
            gen.writeStringField('name', 'date');
            gen.writeStringField('value', Date_Today);
            gen.writeEndObject();
          }
        } 

     // Cancellation and NOC should have contact added through Amendment. 
     // It shouldn't get the value from TempContact2 because Quote doesn't get updated for Contact whose credit check is not done.  
       if((changeOrderType == 'Cancellation'|| changeOrderType == 'Notice of Cancellation')&& contactList != null && contactList.size() > 0){
             gen.writeStartObject();
              gen.writeStringField('name', 'customerNameCo');
              gen.writeStringField('value', contactList.get(0).Name);
            gen.writeEndObject();    
         }
        else if(quoteRecordToSend.Temp_Contact_2__c <> null){
            gen.writeStartObject();
              gen.writeStringField('name', 'customerNameCo');
              gen.writeStringField('value',quoteRecordToSend.Temp_Contact_2__c);
            gen.writeEndObject();    
          }  

        // code used to send Quote record and settings to build the JSON string with name:value pair for Account and Quote
        for(DocGenContractRequest__c nhc : settings){

            if(nhc.sObject_Name__c != null && nhc.sObject_Name__c != 'Lease_Schedule__c'){
                gen.writeStartObject();
                gen.writeStringField('name',nhc.Name);
                if(nhc.sObject_Name__c.equalsIgnoreCase('Quote')){
                    if(quoteRecordToSend.get(nhc.Field_API_Name__c) != null)
                      settingValues(nhc,String.valueOf(quoteRecordToSend.get(nhc.Field_API_Name__c)),gen);
                    else
                      gen.writeStringField('value','');
                }

                else if(nhc.sObject_Name__c.equalsIgnoreCase('Account')){
                    if(accountRecordToSend.get(nhc.Field_API_Name__c) != null)
                        settingValues(nhc,String.valueOf(accountRecordToSend.get(nhc.Field_API_Name__c)),gen);
                    else
                        gen.writeStringField('value','');
                }
                else if(nhc.sObject_Name__c.equalsIgnoreCase('System_Production__c')){
                    if(systemProduction.get(nhc.Field_API_Name__c) != null)
                        settingValues(nhc,String.valueOf(systemProduction.get(nhc.Field_API_Name__c)),gen);
                    else
                        gen.writeStringField('value','');
                }
                else if(nhc.sObject_Name__c.equalsIgnoreCase('Partner Account')){
                    if(partnerAccountRecord.get(nhc.Field_API_Name__c) != null)
                        settingValues(nhc,String.valueOf(partnerAccountRecord.get(nhc.Field_API_Name__c)),gen);
                    else
                        gen.writeStringField('value','');
                }
                else if(nhc.sObject_Name__c.equalsIgnoreCase('Contact')){
                    if(primaryContact != null && primaryContact.get(0).get(nhc.Field_API_Name__c) != null)
                        settingValues(nhc,String.valueOf(primaryContact.get(0).get(nhc.Field_API_Name__c)),gen);
                    else
                        gen.writeStringField('value','');
                }
                else if(nhc.sObject_Name__c.equalsIgnoreCase('User')){
                    if(partnerUserRecord != null && partnerUserRecord.get(nhc.Field_API_Name__c) != null)
                        settingValues(nhc,String.valueOf(partnerUserRecord.get(nhc.Field_API_Name__c)),gen);
                    else
                        gen.writeStringField('value','');
                }
                gen.writeEndObject();
            }
            else if(nhc.sObject_Name__c == null){
                gen.writeStartObject();
                gen.writeStringField('name',nhc.Name);
                gen.writeStringField('value',nhc.Field_API_Name__c);
                gen.writeEndObject();
            }
        }
        // including fields of Lease Schedule
        Integer i = 0;
        for(Lease_Schedule__c ls : leasePaymentList){
             String year = ls.Guarantee_Year__c != null ? ls.Guarantee_Year__c.split(' ',2).get(1) : '0';
            for(String lsField : sobjectFieldMap.get('Lease_Schedule__c').keySet()) {
                   DocGenContractRequest__c nhs = jsonFieldAPIMap.get(lsField);
                   gen.writeStartObject();
                   gen.writeStringField('name',lsField+year);
                   if(ls.get(sobjectFieldMap.get('Lease_Schedule__c').get(lsField)) != null)
                       settingValues(nhs,String.valueOf(ls.get(sobjectFieldMap.get('Lease_Schedule__c').get(lsField))),gen);
                   else
                       gen.writeStringField('value','');
                   gen.writeEndObject();

            }
        }
        gen.writeEndArray();
        gen.writeEndObject();
        gen.close();
        System.debug('GEN: ' + gen.getAsString());
        return gen.getAsString();
    }

    private void settingValues(DocGenContractRequest__c docGen,String value,JSONGenerator gen){
        if(docGen.Field_Type__c == null || docGen.Field_Type__c == 'String'){
            gen.writeStringField('value', value);
        }
        else if(docGen.Field_Type__c == 'DecimalRound'){
            gen.writeNumberField('value', Decimal.valueOf(value).round(System.RoundingMode.CEILING));
        }
        else if(docGen.Field_Type__c == 'Integer'){
            gen.writeNumberField('value', Integer.valueOf(value));
        }
        else if(docGen.Field_Type__c == 'Decimal'){
            gen.writeNumberField('value', Decimal.valueOf(value));
        }
        else if(docGen.Field_Type__c != null && docGen.Field_Type__c.contains('Scale')){
            gen.writeStringField('value', formatCurrency(Decimal.valueOf(value).setScale(Integer.valueOf(docGen.Field_Type__c.right(1))).format()));
        }
        else if(docGen.Field_Type__c == 'Currency'){
            gen.writeStringField('value', formatCurrency(Double.valueOf(value).format()));
        }
        else if(docGen.Field_Type__c == 'RangeNumber' && (value.contains('-'))){
            gen.writeStringField('value', Double.valueOf(value.split('-',2).get(0)).format() + '-' + Double.valueOf(value.split('-',2).get(1)).format());
        }
        else if(docGen.Field_Type__c == 'RangeNumber' && (value.contains('to'))){
            gen.writeStringField('value', Double.valueOf(value.split('to',2).get(0)).format() + '-' + Double.valueOf(value.split('to',2).get(1)).format());
        }
        else if(docGen.Field_Type__c == 'Comma'){
             gen.writeStringField('value', Double.valueOf(value.split('to',2).get(0)).format());
        }
        else if(docGen.Field_Type__c == 'RangeCurrency' && (value.contains('-'))){
            gen.writeStringField('value', formatCurrency(Double.valueOf(value.split('-',2).get(0)).format()) + '-' + formatCurrency(Double.valueOf(value.split('-',2).get(1)).format()));
        }
        else if(docGen.Field_Type__c == 'RangeCurrency' && (value.contains('to'))){
            gen.writeStringField('value', formatCurrency(Double.valueOf(value.split('to',2).get(0)).format()) + '-' + formatCurrency(Double.valueOf(value.split('to',2).get(1)).format()));
        }
        else if(docGen.Field_Type__c == 'DecimalRoundCurrency'){
            gen.writeStringField('value', formatCurrency(Decimal.valueOf(value).round(System.RoundingMode.CEILING).format()));
        }
        else{
            gen.writeStringField('value', value);
        }
    }

    public static String formatCurrency(String s) {
        s = + s;
        if (!s.contains('.')) {
            s = s + '.00';
        } else {
          Integer dPos = s.indexOf('.');
          if (s.length() - dPos < 3) { s = s + '0'; }
        }
        return s;
    }
    private String buildQuery(String selectStatement,String objectName,String finalString){
        Set<String> fields = new Set<String>();
        Map<String,String> jsonNameFieldAPIName = new Map<String,String>();
        jsonNameFieldAPIName = sObjectFieldMap.get(objectName);
        system.debug('field map is '+jsonNameFieldAPIName);
        if(jsonNameFieldAPIName != null){
            for(String field : jsonNameFieldAPIName.values()){
                fields.add(field.toLowerCase());
            }
            for(String s :fields){
                selectStatement += s + ',';
            }
        }


        //Remove the hanging comma from the query
        selectStatement = selectStatement.subString(0,selectStatement.length() - 1);
        selectStatement += finalString;
	return selectStatement;
    }

    public echosign_dev1__SIGN_Agreement__c handleRequest(String requestBody, Quote qt,Id agreementRecordType,String agreementName,String additionalRecipient,String changeOrderType,string newNotes,Id coSignee){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(DocGen_Callout_Settings__c.getAll().get('DocGen').EndPoint_Contract__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000);
        request.setBody(requestBody);
        Http http1 = new Http();
        HttpResponse res;

        if(!Test.isRunningTest()){
            res = http1.send(request);
            if(res.getStatusCode() != 200){
                system.debug('Response is '+res.getStatus());
            }
            spectrumDebugLog.JSON_Payload__c = requestBody;
            spectrumDebugLog.Quote__c = qt.Id;
            spectrumDebugLog.Account__c = qt.Account__c;
            spectrumDebugLog.Response__c = 'Response is '+res+ ' and status is '+res.getStatus();
            spectrumDebugLog.Response_Status_Code__c = res.getStatusCode();
        }

        if((res != null && res.getStatusCode() == 200) || Test.isRunningTest()){

            // Creating th Agreement record
            echosign_dev1__SIGN_Agreement__c newAgreement = new echosign_dev1__SIGN_Agreement__c();

            newAgreement.recordTypeId = agreementRecordType;
            newAgreement.Quote__c = qt.Id;
            newAgreement.Account__c = qt.Account__c;
            newAgreement.Opportunity__c = qt.OpportunityId;
           // newAgreement.Name = qt.Account__r.Name + '-Lease Document-' + qt.Consolidated_Lease_Number__c + '-' + String.valueOf(System.today());
            newAgreement.Name = agreementName;
            newAgreement.echosign_dev1__Status__c = 'Draft';
            newAgreement.echosign_dev1__Recipient__c = (primaryContact != null && primaryContact.size() > 0) ? primaryContact.get(0).id : null ;
        if(changeOrderType == 'HomeOwner Information Change')
            newAgreement.echosign_dev1__Recipient2__c = coSignee;  
        else 
            newAgreement.echosign_dev1__Recipient2__c = (contactList != null && contactList.size() > 0) ? contactList.get(0).id : null ;
            newAgreement.Agreement_Name__c = agreementName;
            newAgreement.echosign_dev1__More_Recipients__c = additionalRecipient;
            newAgreement.Change_Order_Type__c = changeOrderType;
            newAgreement.Notes__c = newNotes;
            system.debug('---New Agreement----' + newAgreement);
            insert newAgreement;
            spectrumDebugLog.Name = String.valueOf(newAgreement.Id);
            // creating the attachment and attaching it to the agreement record and also creating the request as an attachment to Quote
            List<Attachment> attachmentList = new List<Attachment>();

            // Attachment of the response to the agreement record
            Attachment newAttachment = new Attachment();
            newAttachment.ParentId = newAgreement.Id;
            newAttachment.Body = Test.isRunningTest()? Blob.valueOf(requestBody) : res.getBodyAsBlob();
            newAttachment.Name = agreementName;
            attachmentList.add(newAttachment);

            // adding the attachment of response to the Quote record
            newAttachment = new Attachment();
            newAttachment.ParentId = qt.Id;
            newAttachment.Body = Test.isRunningTest()? Blob.valueOf(requestBody) : res.getBodyAsBlob();
            newAttachment.Name = 'DocGen Contract Response.pdf';
            attachmentList.add(newAttachment);

            // adding the attachment of request to the Quote record
            newAttachment = new Attachment();
            newAttachment.ParentId = qt.Id;
            newAttachment.Body = Blob.valueOf(requestBody);
            newAttachment.Name = 'DocGen Contract Request.txt';
            attachmentList.add(newAttachment);
            insert attachmentList;

            return newAgreement;
        }

      return null;
    } // end of http handleRequest method
} // end of class