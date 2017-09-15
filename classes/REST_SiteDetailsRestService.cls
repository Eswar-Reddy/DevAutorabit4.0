@RestResource(urlMapping='/SitetestInfo/*')
global with sharing class REST_SiteDetailsRestService {

  
   public static Map<String,String> siteDeatilsResponse=new Map<String, String>(); // Map for Json Response
    
    public static String query= 'Select ';
    public static List<SiteInfoSettings__c> allSiteFieldsValues = SiteInfoSettings__c.getAll().values();// Get All records Value from Custom Settings
    public static Set<String> siteFields = new Set<String>(); // Preparing Set for all keys of ResponseMap to map json and api name
    public static String sIFId; //String to get Param
    public static String apiName;//dynamic API name from custom setting
    public static String jsonName;//dynamic Json name from custom setting
    public static String objectName; //dynamic object name from custom setting
    public static Map<String,String> mapResponse=new Map<String,String>();//To store API name with corresponding Json Name
    public static Integer countListSize=0;// To control dynamic API , after every field adition
    
    @HttpGet
    global static void getAllSiteInfo(){
        
        RestRequest req = RestContext.request; //Rest Request
        RestResponse res = RestContext.response;//Rest Resposne
        sIFId=  req.params.get('SIFID');  //get SIFID from request
        
        System.debug('Custom Settings Values allSiteFieldsValues :::'+allSiteFieldsValues );
        try{
            
            //Check if Custom Setting is not Null & Blank
            if(allSiteFieldsValues !=null && allSiteFieldsValues.size() > 0){ 
                countListSize=allSiteFieldsValues.size();          
                Integer iCount=0; // To remove last , from dynamic query
                //Iterating on custom setting
                for(SiteInfoSettings__c siteSetting : allSiteFieldsValues){
                    
                    apiName=String.valueOf(siteSetting.FieldApiname__c);//getting dynamic apiname from custom setting
                    jsonName=String.valueOf(siteSetting.Json_Name__c); //getting dynamic jsonName from custom setting
                    objectName=String.valueOf(siteSetting.sObject_Name__c);//getting dynamic ObjectName from custom setting
                    siteDeatilsResponse.put(jsonName,''); //Create blank response Map in case if any field is empty on UI
                    siteFields.add(apiName);// To iterate over map for making response map based on Json name 
                    mapResponse.put(apiName,jsonName); // To track API name to corresponding Json name
                    query=query+apiName;//Adding apiname to query
                    
                    if(iCount !=countListSize-1){
                        query=query+','; // Adding , to query
                    }
                    
                    iCount++;
                    
                }
               
                generateResponseMap(query,siteFields,objectName); //Calling method to run dynamic query and response map population
            }
            
            System.debug('Response Map  : ' + siteDeatilsResponse);
            JSONGenerator jsonResponse = JSON.createGenerator(true);
            jsonResponse.writeStartObject();
            jsonResponse.writeObjectField('SiteDetails',siteDeatilsResponse); // Writing Map as an Object
            jsonResponse.writeEndObject();
            String result = jsonResponse.getAsString();
            System.debug('Response String : ' + result );
            res.responseBody = blob.valueOf(result); // Writing Response
            
        }
        
        catch(Exception e) {
            
            String error = formatErrorMessage('Error :::  ' + e.getMessage(),'getAllSiteInfo()',errorCode.QUERY);
            res.responseBody = blob.valueOf(error);
            return;
            
        }
        
    } 
    
    public static void generateResponseMap(String querySend,Set<String> response,String ObjectNamepass){
        query=querySend+ ' From '+ObjectNamepass+' WHERE Name =:sIFId'; 
        System.debug('query tobe run ::: '+query);
        sObject siteObject=database.query(query);
               
        for(String key :response){
            
            // Condition 1 for Relationship Field Handling 
            if(key.contains('.')){
                String fieldValue = key.substringAfter('.'); //Getting Field Name
                String relation = key.substringBefore('.'); // Getting Relationship Name
                if(siteObject !=null && (siteObject.getSObject(relation)) !=null){
                    String relObjChild = (String)(siteObject.getSObject(relation)).get(fieldValue); // TypeCast to String
                    siteDeatilsResponse.put(String.valueOf(mapResponse.get(key)),relObjChild); // Putting Value in response Map with key as Json name
                }
            }
            
            
            else{
                //Condition 2 or Normal Field apI handling
                if(siteObject !=null && siteObject.get(key) != null){
                    
                    siteDeatilsResponse.put(String.valueOf(mapResponse.get(key)),String.valueOf(siteObject.get(key))); // Putting Value in response Map with key as Json name
                }
                
            }
            
        }  
        
       
        
    }
    
    public static String formatErrorMessage(String errorMessage, String requestType, errorCode err){
        String errorCode = errorCodeMap.get(err);
        
        
        JSONGenerator jsonResponse = JSON.createGenerator(false);
        jsonResponse.writeStartObject();
        jsonResponse.writeBooleanField('success',false);
        if(requestType != null)
            jsonResponse.writeStringField('requestType',requestType);
        else
            jsonResponse.writeStringField('requestType','None Specified');
        if(errorMessage != null)
            jsonResponse.writeStringField('errorMessage',errorMessage);
        else
            jsonResponse.writeNullField('errorMessage');
        if(errorCode != null)
            jsonResponse.writeStringField('errorCode',errorCode);
        else
            jsonResponse.writeNullField('errorCode');
        
        return jsonResponse.getAsString();
    }
    
    private static Map<errorCode,String> errorCodeMap = new Map<errorCode,String>{errorCode.DML=>'800 - DML ERROR',errorCode.JSON=>'801  - JSON ERROR',
        errorCode.CALLOUT=>'802 - CALLOUT ERROR',errorCode.REQUESTTYPE=>'803 - REQUEST TYPE NOT SPECIFIED', errorCode.UNKNOWN=>'804 - UNKNOWN EXCEPTION',errorCode.INPUT=>
        '805 - MISSING REQUIRED INPUT/INPUT INVALID',errorCode.QUERY=>'806 - QUERY ERROR'};
            
            public enum errorCode{DML,JSON,CALLOUT,REQUESTTYPE,UNKNOWN,INPUT,QUERY}
    
}