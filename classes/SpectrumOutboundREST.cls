public with sharing class SpectrumOutboundREST {
    
    
    //@TestVisible public static Map<Id,Boolean> opportunitySuccessMap {get;set;}
    
    //private SpectrumCredentials__c credentials {get;set;}
    
    //private String httpResponseDebug {get;set;}
    
    
    ////This is the wrapper object returned in the responses. Used in the batch and the future calls in the triggers to evaluate successes,failures.
    //public class SpectrumResult{
    //    public Id recordId {get;set;}
    //    public String result {get;set;}
    //    public String accountId {get;set;}
    //    public String accountName {get;set;}
    //    public Boolean isSuccess {
    //        get {
    //            if(isSuccess == null) 
    //                isSuccess = false;
    //            return isSuccess;
    //        }
    //        set;
    //    }
    //    public SpectrumResult(){
            
    //    }
    //    public SpectrumResult(Id i , Boolean b , String s){
    //        recordId = i;
    //        isSuccess = b;
    //        result = s;
    //    }
    //}
    
    //private void createDebugLogs(){
    //    List<SpectrumDebugUtility.debugLog> logs = new List<SpectrumDebugUtility.debugLog>();
        
    //    for(OpportunityWrapper opp :wrappedOpportunities){
    //        SpectrumDebugUtility.debugLog log = new SpectrumDebugUtility.debugLog();
    //        log.opportunityId = opp.opp.Id;
    //        log.accountId = opp.acc.Id;
    //        log.service = 'Lead Outbound To Spectrum';
    //        log.jsonPayload = buildJson();
    //        log.response = httpResponseDebug;
    //        logs.add(log);
    //    }
        
    //    SpectrumDebugUtility.generateDebugLog(logs);
    //}
    
    //@TestVisible private String jsonBuiltString {get;set;}
    //SpectrumJSONServices jsonSettings {get; private set;}
    //List<Opportunity> recordsToSendToSpectrum {get;private set;}
    //private List<OpportunityWrapper> wrappedOpportunities {get;set;}
    //private Integer resendCount {get;private set;}
    //private String queryString {get;set;}
    //private Set<Id> oppIds {get;set;}
    
    //public SpectrumOutboundREST(){
    //    wrappedOpportunities = new List<OpportunityWrapper>();
    //    jsonSettings = new SpectrumJSONServices();
    //    credentials = SpectrumCredentials__c.getOrgDefaults();
    //    resendCount = 0;
    //}
    
    //public List<SpectrumResult> sendRecordsToSpectrum(Set<Id> oppIds){
    //    List<SpectrumResult> results = new List<SpectrumResult>();
    //    this.oppIds = oppIds;
    //    queryRecords();
        
    //    populateWrapperList();
        
    //    HttpResponse response;
        
    //    try{
    //        response = handleRequest();
    //    }catch(Exception e){
    //        SunPowerException.recordErrorService('SpectrumOutboundREST','Spectrum Request',e,'Outbound Lead Service Call');
    //        throw new SunpowerException();
    //    }
        
    //    /*******TEST*/
    //    if(Test.isRunningTest() && opportunitySuccessMap != null){
    //        for(Id i : opportunitySuccessMap.keySet()){
    //            results.add(new SpectrumResult(i,opportunitySuccessMap.get(i),opportunitySuccessMap.get(i) == true ? 'success' : 'failed'));
    //        }
    //        return results;
    //    }
        
    //    results = handleResponse(response);
        
        
    //    if(Test.isRunningTest())
    //        jsonBuiltString = buildJSON();
    //    /**************/
    //    System.debug('RESULTS' + results);
        
    //    createDebugLogs();
        
    //    return results;
    //}
    ////wraps all the objects into one objects. Spectrum has one object, SFDC has 4. This puts them into one wrapper
    //private void populateWrapperList(){
    //    Map<Id,List<Contact>> accountContactMap = new Map<Id,List<Contact>>();
        
    //    for(Opportunity o  : recordsToSendToSpectrum){
    //        accountContactMap.put(o.AccountId,new List<Contact>());
    //    }
        
    //    Set<Id> accIds = accountContactMap.keySet();
        
    //    List<Contact> contactsToSend = Database.query(buildContactQuery());
        
    //    for(Contact con : contactsToSend){
    //        if(accountContactMap.containsKey(con.AccountId)){
    //            accountContactMap.get(con.AccountId).add(con);
    //        }
    //    }
        
    //    for(Opportunity o : recordsToSendToSpectrum){
    //        OpportunityWrapper wrapper = new OpportunityWrapper();
    //        wrapper.opp = o;
    //        wrapper.acc = o.Account;
    //        if(accountContactMap.get(o.AccountId).size() == 1){
    //            wrapper.primaryContact = accountContactMap.get(o.AccountId)[0];
    //        }
    //        else if(accountContactMap.get(o.AccountId).size() == 2){
    //            for(Contact con : accountContactMap.get(o.AccountId)){
    //                if(con.Primary__c)
    //                    wrapper.primaryContact = con;
    //                else
    //                    wrapper.secondaryContact = con;
    //            }
    //        }
    //        else if(accountContactMap.get(o.AccountId).size() > 2){
    //            for(Contact con : accountContactMap.get(o.AccountId)){
    //                if(con.Primary__c)
    //                    wrapper.primaryContact = con;
    //            }
    //        }
    //        wrappedOpportunities.add(wrapper);
    //    }
    //    System.debug('Wrapped Opportunity' + wrappedOpportunities);
    //}
    ////dynamically builds query based on custom settings.
    //public String buildQuery(){
        
    //    String queryString = 'SELECT ';
        
    //    //Iterate through field map constructed in loadSettings call and build dynamic query
    //    for(String sOuter : jsonSettings.sObjectFieldMap.keySet()){
    //        Map<String,String> innerMap = jsonSettings.sObjectFieldMap.get(sOuter);
    //        for(String sInner : innerMap.keySet()){
    //            if(sOuter.equalsIgnoreCase('Opportunity'))
    //                queryString += innerMap.get(sInner) + ',';
    //            else if(sOuter.equalsIgnoreCase('Account'))
    //                queryString += 'Account.' + innerMap.get(sInner) + ',';
    //            else if(sOuter.equalsIgnoreCase('Contact'))
    //                queryString += 'Primary_Contact__r.' + innerMap.get(sInner) + ',';
    //            else if(sOuter.equalsIgnoreCase('Campaign'))                                //sktemp
    //                queryString += 'Campaign.' + innerMap.get(sInner) + ',';                //sktemp
    //        }
    //    }
    //    //Remove the hanging comma from the query
    //    queryString = queryString.subString(0,queryString.length() - 1);             
    //    queryString += ' FROM Opportunity WHERE Id IN :oppIds';                  
    //    return queryString;
        
    //}
    ////builds the contact query for use in setting the primary and secondary contact.
    //private String buildContactQuery(){
    //    String queryString = 'SELECT ';
        
    //    Set<String> contactFields = new Set<String>();
    //    contactFields.add('primary__c');
    //    contactFields.add('id');
    //    contactFIelds.add('accountid');
    //    for(String sOuter : jsonSettings.sObjectFieldMap.keySet()){
    //        Map<String,String> innerMap = jsonSettings.sObjectFieldMap.get(sOuter);
    //        for(String sInner : innerMap.keySet()){
    //            if(sOuter.equalsIgnoreCase('Contact') || sOuter.equalsIgnoreCase('SecondaryContact'))
    //                contactFields.add(innerMap.get(sInner).toLowerCase());
    //        }
    //    }
        
    //    for(String s :contactFields){
    //        queryString += s + ',';
    //    }
    //    //Remove the hanging comma from the query
    //    queryString = queryString.subString(0,queryString.length() - 1);
        
    //    queryString += ' FROM Contact WHERE AccountId IN :accIds';
        
    //    return queryString;
        
    //}
    
    
    ////makes the actual queries.
    //private void queryRecords(){
    //    Diagnostics.push('IFMToSpectrum-queryRecords');
    //    try{
    //        recordsToSendToSpectrum = Database.query(buildQuery());
    //    }
    //    catch(Exception e){
    //        SunPowerException.recordErrorService('SpectrumOutboundREST','queryRecords',e,'Outbound Lead Service Call');
    //        throw new SunpowerException();
    //    }
    //    finally{
    //        Diagnostics.pop();
    //    }
        
    //}
    
    
    ////Builds JSON String utilizing JSONGenerator class
    //private String buildJSON(){
        
    //    JSONGenerator gen = JSON.createGenerator(true);
    //    gen.writeStartObject();
    //    gen.writeNullField('responseStatus');
    //    gen.writeStringField('userName',credentials.Username__c);
    //    gen.writeStringField('password',credentials.Password__c);
    //    gen.writeFieldName('clientList');
    //    gen.writeStartArray();
        
        
    //    for(OpportunityWrapper opp :wrappedOpportunities){
    //        //MAIN JSON OBJECT
    //        gen.writeStartObject();
    //        for(SpectrumSettings__c ssOuter : jsonSettings.jsonObjectMap.get(null)){
    //            System.debug('ssOuter: ' + ssOuter);
    //            writeJsonField(gen,ssOuter,opp);
    //        }
    //        //gen.writeStringField('pconGender','Not known');
    //        gen.writeEndObject();
    //    }
        
        
        
    //    gen.writeEndArray();
    //    gen.writeEndObject();
    //    gen.close();
    //    System.debug('GEN: ' + gen.getAsString());
    //    return gen.getAsString();
    //}
    ////writes the fields to their correct jey value location in the json
    //private void writeJsonField(JSONGenerator gen,SpectrumSettings__c ssOuter,OpportunityWrapper opp){
    //    if(ssOuter.JSON_Name__c == 'companyName' || ssOuter.JSON_Name__c == 'creditApplicationCheck' || ssOuter.JSON_Name__c == 'referredByName1')
    //        return;
        
    //    if(ssOuter.sObject_Name__c.equalsIgnoreCase('Opportunity')){  
    //        if(ssOuter.JSON_Name__c == 'referredByName'){                   //sktemp
    //            if(opp.opp.Referred_By__c != null)      
    //                writeJsonForValue(gen,ssOuter,String.valueOf(opp.opp.Referred_By__c));
    //            else if(opp.opp.Referred_By1__c != null)
    //                writeJsonForValue(gen,ssOuter,String.valueOf(opp.opp.Referred_By1__r.name));
    //            else
    //                gen.writeNullField(ssOuter.JSON_Name__c);
    //        } 
    //        else   
    //        {
    //            if(ssOuter.Field_API_Name__c.contains('.')){
    //                String[] sObjectField = ssOUter.Field_API_Name__c.split('\\.');
    //                if(opp.opp.getsObject(sObjectField[0]) == null){
    //                    gen.writeNullField(ssOuter.JSON_Name__c);
    //                }
    //                else
    //                    writeJsonForValue(gen,ssOuter,String.valueOf(opp.opp.getsObject(sObjectField[0]).get(sObjectField[1])));
    //            }
    //            else{
    //                writeJsonForValue(gen,ssOuter,String.valueOf(opp.opp.get(ssOuter.Field_API_Name__c)));
    //            }
    //        }
    //    }
    //    else if(ssOuter.sObject_Name__c.equalsIgnoreCase('Account')){
    //        if(opp.acc == null)
    //            gen.writeNullField(ssOuter.JSON_Name__c);
    //        else
    //            writeJsonForValue(gen,ssOuter,String.valueOf(opp.acc.get(ssOuter.Field_API_Name__c)));
    //    }
    //    else if(ssOuter.sObject_Name__c.equalsIgnoreCase('Contact')){
    //        if(opp.primaryContact == null)
    //            gen.writeNullField(ssOuter.JSON_Name__c);
    //        else
    //            writeJsonForValue(gen,ssOuter,String.valueOf(opp.primaryContact.get(ssOuter.Field_API_Name__c)));
    //    }
    //    else if(ssOuter.sObject_Name__c.equalsIgnoreCase('Campaign')){          //sktemp
    //        if(ssOuter.JSON_Name__c == 'campaignShortDescription')           
    //            writeJsonForValue(gen,ssOuter,String.valueOf(opp.opp.Campaign.Short_Description__c));
    //    }
    //    else if(ssOuter.sObject_Name__c.equalsIgnoreCase('ContactSecondary')){
    //        if(opp.secondaryContact == null)
    //            gen.writeNullField(ssOuter.JSON_Name__c);
    //        else
    //            writeJsonForValue(gen,ssOuter,String.valueOf(opp.secondaryContact.get(ssOuter.Field_API_Name__c)));
    //    }
    //}
    
    ////dynamically writes the value in the json based on the Outbound_Type__c defined in the custom settings.
    //private void writeJsonForValue(JSONGenerator gen,SpectrumSettings__c sett,String value){
    //    System.debug(value);
        
    //    //SET DEFAULT VALUE IF NULL
    //    if((value == null || value == 'null' || value == '') && sett.Default_Value__c != null)
    //        value = sett.Default_Value__c;
        
        
    //    if(value == null || value == 'null' || value == ''){
    //        gen.writeNullField(sett.JSON_Name__c);
    //    }
    //    else if(sett.Outbound_Type__c == null){
    //        if(sett.Json_Name__c.equalsIgnoreCase('conPhone') || sett.Json_Name__c.equalsIgnoreCase('conMobilePhone')){
    //            value = value.replace('(', '').replace(')','').replace('-','').replaceAll('\\s','');
    //        }
    //        gen.writeStringField(sett.JSON_Name__c,customEncoding(value));
    //    }
    //    else if(sett.Outbound_Type__c == 'Boolean'){
    //        gen.writeBooleanField(sett.JSON_Name__c, Boolean.valueOf(value));
    //    }
    //    else if(sett.Outbound_Type__c == 'Double'){
    //        gen.writeNumberField(sett.JSON_Name__c, Double.valueOf(value));
    //    }
    //    else if(sett.Outbound_Type__c == 'Integer'){
    //        gen.writeNumberField(sett.JSON_Name__c, Integer.valueOf(value));
    //    }
    //    else if(sett.Outbound_Type__c == 'Long'){
    //        gen.writeNumberField(sett.JSON_Name__c, Long.valueOf(value));
    //    }
    //    else if(sett.Outbound_Type__c == 'Date'){
    //        Date dt = Date.valueOf(value);
    //        String dtString = dt.Year() + '-' + (String.valueOf(dt.Month()).length() == 1 ? '0' + dt.Month() : String.valueOf(dt.Month())) + '-' + (String.valueOf(dt.Day()).length() == 1 ? '0' + dt.Day() : String.valueOf(dt.Day()));
    //        gen.writeStringField(sett.JSON_Name__c,dtString);
    //    }
    //    else if(sett.Outbound_Type__c == 'DateTime'){
    //        gen.writeStringField(sett.JSON_Name__c,DateTime.valueOf(value).format('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'));
    //    }
    //    else if(sett.Outbound_Type__c == 'Text' || sett.Outbound_Type__c == 'String'){
    //        if(sett.Json_Name__c.equalsIgnoreCase('conPhone') || sett.Json_Name__c.equalsIgnoreCase('conMobilePhone')){
    //            value = value.replaceAll('(', '').replaceAll(')','').replaceAll('-','').replaceAll('\\s','');
    //        }
    //        gen.writeStringField(sett.JSON_Name__c,customEncoding(value));
    //    }
    //}
    
    //private String customEncoding(String value){
    //    value = value.replaceAll('%','%25');
    //    value = value.replaceAll('&','%26');
    //    return value;
    //}
    
    
    ////Sends request by implementing proxy_informatica class
    //private HttpResponse handleRequest(){
        
    //    //TODO Load Username and Password from settings
    //    ProxySpectrum stub = new ProxySpectrum(credentials.Endpoint__c);
    //    HTTPRequest request = stub.buildRequest(buildJSON());

    //    HTTPResponse response = stub.sendRequest(request);

    //    return response;
    //}
    
    //private List<SpectrumResult> handleResponse(HTTPResponse httpResp){
    //    List<SpectrumResult> results = new List<SpectrumResult>();
    //    //TODO failure handling if failure then do these
    //    /*failureNotification();
    //    HTTPResponse response = resend();*/
    //    System.debug('RESPONSE BODY: '+ httpResp.getBody());
    //    httpResponseDebug = httpResp.getBody();
    //    JsonParser responseParser;
    //    try{
    //    responseParser = Json.createParser(httpResp.getBody());
    //    }
    //    catch(Exception e){
    //        System.debug('error happened while parsing the response '+e.getStackTraceString());
    //        SunPowerException.recordErrorService('SpectrumOutboundREST','handleResponse','JSON Payload: ' + httpResponseDebug + ' EXCEPTION: ' + e.getMessage(),'Outbound Lead Service Call');
    //        return new List<SpectrumResult>{new SpectrumResult(null,false,httpResp.getBody())};
    //    }
    //    finally{
            
    //    }
    //    Boolean insideArray = false;
        
    //    try{
    //        while(responseParser.nextToken() != null){
                
    //            String currentField = responseParser.getCurrentName();
    //            JSONToken currentToken = responseParser.getCurrentToken();
                
    //            if(currentToken == JsonToken.START_ARRAY)
    //                insideArray = true;
                    
    //            if(insideArray){
    //                if(currentToken == JsonToken.START_OBJECT){
    //                    try{
    //                        SpectrumResult sr = (SpectrumResult)responseParser.readValueAs(SpectrumResult.class);
    //                        if(!sr.result.containsIgnoreCase('Fail'))
    //                            sr.isSuccess = true;
    //                        results.add(sr);
    //                    }
    //                    catch(Exception e){
    //                        SunPowerException.recordErrorService('SpectrumOutboundREST','handleResponse','JSON Payload: ' + httpResponseDebug + ' EXCEPTION: ' + e.getMessage(),'Outbound Lead Service Call');
    //                    }
                        
    //                }
    //            }
    //        }
    //    }
    //    catch(Exception e){
    //        System.debug('error happened after parsing the response '+e.getStackTraceString());
    //        SunPowerException.recordErrorService('SpectrumOutboundREST','handleResponse','JSON Payload: ' + httpResponseDebug + ' EXCEPTION: ' + e.getMessage(),'Outbound Lead Service Call');
    //    }
        
        
    //    return results;
        
    //}
    
    //private HTTPResponse resend(){
    //    HTTPResponse resendResponse = handleRequest();
    //    handleResponse(resendResponse);
    //    return resendResponse;
    //}
    
    //private class opportunityWrapper{
    //    public Account acc {get;set;}
    //    public Contact primaryContact {get;set;}
    //    public Contact secondaryContact {get;set;}
    //    public Opportunity opp {get;set;}
    //}
    
    
}