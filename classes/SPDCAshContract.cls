public with sharing class SPDCAshContract {

    public Map<String,Map<String,String>> sObjectFieldMap {get;private set;}
    public Map<String,SPD_Cash_Contract__c> jsonFieldAPIMap {get;private set;}
    public Map<String,List<SPD_Cash_Contract__c>> jsonObjectMap {get; private set;}
    private QuoteWrapper qWrapper {get;set;}
    public map<Integer,String> monthMap;
    public List<SPD_Cash_Contract__c> settings {get;private set;}
    public Quote quoteRecordToSend{get;set;}
    public Account accountRecordToSend{get;set;}
    public User u;
    public String Date_Today ;
    public  Id attachId{get;set;}
    public Contact con1;
    public Contact con;
    private Id quoteId{get;set;}
    String str  = '';

    public SPDCAshContract(){
        
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
    }


    private void loadSettings(){
        sObjectFieldMap = new Map<String,Map<String,String>>();
        jsonFieldAPIMap = new Map<String,SPD_Cash_Contract__c>();
        jsonObjectMap = new Map<String,List<SPD_Cash_Contract__c>>();

        //Instance method of List Custom Settings to get all in the list
        settings = SPD_Cash_Contract__c.getAll().values();
        for(SPD_Cash_Contract__c ss : settings){

            //JSON OBJECT MAP
        //    if(!jsonObjectMap.containsKey(ss.JSON_Object__c))
        //        jsonObjectMap.put(ss.JSON_Object__c,new List<NewHomes_Contract__c>());
         //   jsonObjectMap.get(ss.JSON_Object__c).add(ss);

            // sObjectFieldMap
            if(!sObjectFieldMap.containsKey(ss.sObject_Name__c.toLowerCase()))
                sObjectFieldMap.put(ss.sObject_Name__c.toLowerCase(),new Map<String,String>());
            
            //Populates Map with JsonString and actual apiname. The Json String will make the json object "pretty"
            Map<String,String> jsonFieldMap = sObjectFieldMap.get(ss.sObject_Name__c.toLowerCase());
            if(ss.Name != null)
                jsonFieldMap.put(ss.Name,ss.Field_API_Name__c);
            
            sObjectFieldMap.put(ss.sObject_Name__c,jsonFieldMap);
            // jsonFieldAPIMap
            jsonFieldAPIMap.put(ss.Name.toLowerCase(),ss);
        }   
    }


    public  void sendDataToDocGen(Id quoteId){
        this.quoteId = quoteId;
        u = new User();
        u = [Select id,Name,CounterSignature__c,HIS_Registration_Number__c from User where id =: userinfo.getuserid()];


        system.debug('quoteRecordToSend is 1 '+quoteRecordToSend);



        populateQuoteWrapper();
        
                            system.debug('quoteRecordToSend is 2 '+quoteRecordToSend);
        String jsonRequest = buildJSON();

        handleRequest(jsonRequest,quoteRecordToSend);

    }


    private void populateQuoteWrapper(){
        queryRecords();
        system.debug('quoteRecordToSend:'+quoteRecordToSend);
        qWrapper = new QuoteWrapper();
        qWrapper.quote = quoteRecordToSend;
        Id accId = quoteRecordToSend.Account__c;
        system.debug('@developer-->accId:'+accId);
        
        accountRecordToSend = Database.query(buildAccountQuery());
        system.debug('accountRecordToSend:'+accountRecordToSend);
        system.debug('accId:'+accId);
        qWrapper.acc = accountRecordToSend;
    }

    private String buildJSON(){

        // PayLoad is Case Sensitive. 
        String regNum = u.HIS_Registration_Number__c != null ? u.HIS_Registration_Number__c : '00000';
        con1 = new Contact();
        con = new Contact();
        con = MosaicUtilQueries.getContact(qWrapper.quote.Account__c);
        for(Contact cont :[Select id,Name,Include_in_Lease_Doc__c from contact where accountid =: qWrapper.acc.id order by CreatedDate ASC ] ){
            if(cont.id != con.id && cont.Include_in_Lease_Doc__c){
                con1 = cont;
            }
        }
         DocGen_Callout_Settings__c docgen = DocGen_Callout_Settings__c.getInstance('DocGen');
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeStringField('apiKey',docgen.SPDContract_Key__c);
            gen.writeStringField('watermark','');
            gen.writeStringField('templateName','');
            gen.writeFieldName('nameValuePairs');
            gen.writeStartArray();
                gen.writeStartObject();
                    gen.writeStringField('name', 'DocumentType'); 
                    gen.writeStringField('value', 'Agreement'); 
                gen.writeEndObject();  
                
                gen.writeStartObject();
                    gen.writeStringField('name', 'panelBrand'); 
                    gen.writeStringField('value', 'SunPower'); 
                gen.writeEndObject(); 

                gen.writeStartObject();
                    gen.writeStringField('name', 'salespersonName'); 
                    gen.writeStringField('value', userinfo.getName()); 
                gen.writeEndObject(); 

                gen.writeStartObject();
                    gen.writeStringField('name', 'Channel'); 
                    gen.writeStringField('value', 'Direct'); 
                gen.writeEndObject(); 

                gen.writeStartObject();
                    gen.writeStringField('name', 'registrationNum'); 
                    gen.writeStringField('value', regNum); 
                gen.writeEndObject(); 

                gen.writeStartObject();
                    gen.writeStringField('name', 'remainingbalance'); 
                    if(qWrapper.quote.get('System_Cost__c') != null){
                        str  = (Double.valueof(qWrapper.quote.get('System_Cost__c')) - (0.4 * Double.valueof(qWrapper.quote.get('System_Cost__c')))).format();
                        str = formatCurrency(str);
                        gen.writeStringField('value', str); 
                        //(Double.valueof(qWrapper.quote.get('System_Cost__c')) - (0.4 * Double.valueof(qWrapper.quote.get('System_Cost__c')))).setscale(2).format()
                    }
                    else
                        gen.writeStringField('value', '0');   
                gen.writeEndObject();

                gen.writeStartObject();
                    gen.writeStringField('name', '40ofTotalContrPrice'); 
                    if(qWrapper.quote.get('System_Cost__c') != null){
                        
                        str = (Double.valueof(qWrapper.quote.get('System_Cost__c'))*0.4).format();
                        str = formatCurrency(str);
                        gen.writeStringField('value',str); 
                            //Double.valueof(qWrapper.quote.get('System_Cost__c'))*0.4).setscale(2).format()
                    }
                    else
                        gen.writeStringField('value', '0');     
                gen.writeEndObject(); 


                gen.writeStartObject();
                    gen.writeStringField('name', 'Note'); 
                    if(qWrapper.quote.Ecobee_User__c)
                        gen.writeStringField('value',Label.Ecobee); 
                    else
                        gen.writeStringField('value', '');     
                gen.writeEndObject(); 

                gen.writeStartObject();
                    gen.writeStringField('name', 'customerNameCo');
                    if(con1.id != null) 
                    {
                        gen.writeStringField('value', con1.Name);    
                    }
                    else{
                        gen.writeStringField('value', ''); 
                    }
                    
                gen.writeEndObject(); 
                if(Date_Today != ''){
                    gen.writeStartObject();
                        gen.writeStringField('name', 'date'); 
                        gen.writeStringField('value', Date_Today); 
                    gen.writeEndObject(); 
                }

      

                // code used to send Quote record and settings to build the JSON string with name:value pair
                for(SPD_Cash_Contract__c spd : settings){
                    system.debug('Field_API_Name__c:'+spd.Field_API_Name__c);
                    gen.writeStartObject();
                    gen.writeStringField('name', spd.Name); 

                    if(spd.sObject_Name__c.equalsIgnoreCase('Quote'))

                        if(qWrapper.quote.get(spd.Field_API_Name__c) != null)
                            if(spd.Name == 'SystemPrice' || spd.Name == 'Rebate'){
                                
                                str = Double.valueof(qWrapper.quote.get(spd.Field_API_Name__c)).format();
                                str = formatCurrency(str);    
                                gen.writeStringField('value', str);
                                //Double.valueof(qWrapper.quote.get(spd.Field_API_Name__c)).format()
                            }
                            else    
                                gen.writeStringField('value', String.valueOf(qWrapper.quote.get(spd.Field_API_Name__c)));
                        else
                            gen.writeStringField('value', '');    
                    else if(spd.sObject_Name__c.equalsIgnoreCase('Account')){
    
                        if(qWrapper.acc.get(spd.Field_API_Name__c) != null)
                            gen.writeStringField('value', String.valueOf(qWrapper.acc.get(spd.Field_API_Name__c)));
                        else
                            gen.writeStringField('value', '');       
                    }    
                    
                
                    gen.writeEndObject();

                }
            gen.writeEndArray();
        gen.writeEndObject();
        gen.close();
        System.debug('GEN: ' + gen.getAsString());
        return gen.getAsString();

    }

    
    private void queryRecords(){
        system.debug('@developer-->quoteId:'+quoteId);
        
        String soql = buildQuoteQuery();
        system.debug('@developer-->soql:'+soql);
        
        quoteRecordToSend = Database.query(soql);
        system.debug('@developer-->quoteRecordToSend:'+quoteRecordToSend);
        system.debug('@developer-->quoteRecordToSend.Account__c:'+quoteRecordToSend.Account__c);
    }

    private String buildQuoteQuery(){
      //  String queryString = 'SELECT id,Account__c,Account__r.Account_Name__c,Partner_Account_Id__c,opportunity.description,Ecobee_User__c,System_Cost__c ,';
        String queryString = 'SELECT id,Account__c,Account__r.Account_Name__c,Partner_Account_Id__c,opportunity.description,Ecobee_User__c,';
        for(SPD_Cash_Contract__c spd : settings){
            if(spd.sObject_Name__c != null && spd.sObject_Name__c.equalsIgnoreCase('Quote')){
                queryString += spd.Field_API_Name__c + ',';
            }
            else if(spd.sObject_Name__c != null && spd.sObject_Name__c.equalsIgnoreCase('Account')){
                queryString += 'Account__r.' +spd.Field_API_Name__c + ',';
            }
            else if(spd.sObject_Name__c != null && spd.sObject_Name__c.equalsIgnoreCase('Partner Account')){
                queryString += 'Account__r.Partner_Account__r.' +spd.Field_API_Name__c + ',';
            }
            
        }

        //Remove the hanging comma from the query
        queryString = queryString.subString(0,queryString.length() - 1);
        
        queryString += ' FROM Quote WHERE Id = :quoteId';
         
        return queryString;
    }

    private String buildAccountQuery(){
        String queryString = 'SELECT ';
        
        Set<String> accountFields = new Set<String>();
        
        accountFields.add('id');

        Map<String,String> accountJSONNameFieldAPIName = new Map<String,String>();
        accountJSONNameFieldAPIName = sObjectFieldMap.get('Account');

        System.debug('account map is '+accountJSONNameFieldAPIName);
        
        for(String accountField : accountJSONNameFieldAPIName.values()){
            accountFields.add(accountField.toLowerCase());
        }
        
        for(String s :accountFields){
            queryString += s + ',';
        }
        //Remove the hanging comma from the query
        queryString = queryString.subString(0,queryString.length() - 1);
        
        queryString += ' FROM Account WHERE ID = :accId';
        
        return queryString;
    }


    private  void handleRequest(String body,Quote qt){
        string sResponse;
        List<Attachment> attList = new List<Attachment>();
        HttpRequest request = new HttpRequest();
        DocGen_Callout_Settings__c lcs = DocGen_Callout_Settings__c.getInstance('DocGen');
        request.setEndpoint(lcs.EndPoint_Contract__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setTimeout(60000);
        request.setBody(body);
        Http http1 = new Http();
        HttpResponse res;
        Blob retBlob;
            
        if(!Test.isRunningTest()){
            res = http1.send(request);
            sResponse = res.getBody();
            retBlob = res.getBodyAsBlob();
        }
        else{
           sResponse = 'dummy response for Test Class';
            retBlob = Blob.Valueof(body);
       }
       Blob requestBlob = Blob.valueof(body);
        Attachment attachmentTxt = new Attachment();
        attachmentTxt.parentId = qt.Id;
        attachmentTxt.name = 'SPDCashContractRequest.txt';
        attachmentTxt.body = requestBlob;
        attList.add(attachmentTxt);

        Attachment attachmentPDF = new Attachment();
        attachmentPdf.parentId = qt.Id;
        attachmentPdf.name = 'SPDCashContractResponse.pdf';
        attachmentPdf.body = retBlob;
        attList.add(attachmentPdf);

        Database.Insert(attList,false);
        
            
        system.debug('Response from Docgen' + sResponse);
        system.debug('Blob:' + retBlob);
        
        // Agreement Creation 
        Id lendingAgreementRecordTypeId = [select id,DeveloperName,name from RecordType where SobjectType = 'echosign_dev1__SIGN_Agreement__c' and DeveloperName = 'Cash_Contract'].id;
        
        
        echosign_dev1__SIGN_Agreement__c newLendingAgreement_Cash = new echosign_dev1__SIGN_Agreement__c();
        newLendingAgreement_Cash.recordTypeId = lendingAgreementRecordTypeId;
        newLendingAgreement_Cash.Quote__c = qt.Id;
        newLendingAgreement_Cash.Account__c = qt.Account__c;
        newLendingAgreement_Cash.Name = qt.Account__r.Account_Name__c + ' Cash Agreement';
        newLendingAgreement_Cash.echosign_dev1__Status__c = 'Draft';
        newLendingAgreement_Cash.echosign_dev1__Recipient__c = con.Id;
        newLendingAgreement_Cash.echosign_dev1__DateSent__c = System.Today();
        newLendingAgreement_Cash.Agreement_Name__c = qt.Account__r.Account_Name__c + ' Cash Agreement';
        if(con1.id != null){
            newLendingAgreement_Cash.echosign_dev1__Recipient2__c = con1.id;
        }
        if(u.CounterSignature__c != null && u.CounterSignature__c != '')
            newLendingAgreement_Cash.echosign_dev1__More_Recipients__c = u.CounterSignature__c;
        else
            newLendingAgreement_Cash.echosign_dev1__More_Recipients__c = 'aucountersignature@gmail.com';    
        insert newLendingAgreement_Cash;

        if(newLendingAgreement_Cash.id != null){
            Attachment contractPDF = new Attachment();
            contractPDF.parentId = newLendingAgreement_Cash.id;
            contractPDF.name = qt.Account__r.Account_Name__c+' CashContract.pdf';
            contractPDF.body = retBlob;
            Insert contractPDF;
            attachId = newLendingAgreement_Cash.id;
             
                      
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

    private class quoteWrapper{
        public Account acc {get;set;}
        public Quote quote {get;set;}
    }

}