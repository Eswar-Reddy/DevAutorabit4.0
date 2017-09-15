//Class to make API Calls to Integrate with Aurora Design Tool
public class AuroraAPICallHandler {
    
    private static String aurora_Key;
    private static String tenant_Id;
    private static String client_Secret;
    private static String endpoint_URL;
    private static Loan_Callout_Settings__c acs;
    //public static String auroraProjectId='';
    public static String errorMessage;
    public static List<SpectrumDebugUtility.debugLog> spExLogsList = new List<SpectrumDebugUtility.debugLog>();
    
    static{
        acs = Loan_Callout_Settings__c.getInstance('Aurora');
        aurora_Key = acs.Key__c; //'e77078b9-c612-42d4-8a2b-d10512f98862';
        tenant_Id = acs.Tenant_Id__c; //'e7f89e56-fc20-440d-bd5e-4bbbcfa37c7c';
        client_Secret = acs.Client_Secret__c;
        if(Userinfo.getOrganizationId()==Label.Production_Org_Id){
            endpoint_URL = acs.Endpoint_URL__c;
        }
        else{
            endpoint_URL = acs.Endpoint_URL_Sandbox__c;
        }
    }
    
    //-----------------------------------------CREATE PROJECT IN AURORA-------------------------------------------------//
    //method to create project in Aurora
    public static String CreateProjectfromAccount(Id accId,String actionType){
        
        String projectId;
        Httprequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        boolean partnerCreateDesign = false;

        Account custAcc = [SELECT Id,
                            Name,
                            Design_ProjectId__c,
                            External_Design_ProjectId__c,
                            ShippingStreet,
                            ShippingCity,
                            ShippingState,
                            ShippingPostalCode,
                            (select FirstName,LastName,Salutation from Contacts)
                            FROM Account
                            WHERE Id=:accId];
        System.debug('custAcc----->'+custAcc);

        try{
            
            if(Userinfo.getUserType() != 'Standard' && (actionType == 'CreateDesign'|| actionType == 'CreateProject')){
                User usr = [select contact.Account.Design_Tool_Organization_Id__c from User where Id=:Userinfo.getUserId()];
                tenant_Id = usr.contact.Account.Design_Tool_Organization_Id__c;

                if(actionType == 'CreateDesign')
                    partnerCreateDesign = true;
            }
            System.debug('partnerCreateDesign----->'+partnerCreateDesign);

            if(partnerCreateDesign && custAcc.External_Design_ProjectId__c != null)
                return custAcc.External_Design_ProjectId__c;

            if(!partnerCreateDesign && custAcc.Design_ProjectId__c  !=null)
                return custAcc.Design_ProjectId__c ;

            Contact con = custAcc.Contacts[0];
            String custAccAddress = AddressUtility.formatAccountAddressforAurora(custAcc);
            String custAccName = AddressUtility.streetCityStateforAurora(custAcc);
            AuroraJSONUtil.ProjectRequest projReq =  new AuroraJSONUtil.ProjectRequest();
            AuroraJSONUtil.Project proj = new AuroraJSONUtil.Project(custAcc.Id,custAccName,con.Salutation!=null?con.Salutation:'',con.FirstName!=null?con.FirstName:'',con.LastName,custAccAddress,custAccAddress);
            //AuroraJSONUtil.Project proj = new AuroraJSONUtil.Project(custAcc.Id,custAcc.Name,'Mr','FirstName','LastName','77 Rio Robles, San Jose, CA, 95134','77 Rio Robles, San Jose, CA, 95134');
            
            projReq.AuroraKey = aurora_Key;
            projReq.Timestamp = currentTimeStamp();
                        
            System.debug('proj----->'+proj);
            
            String canonicalStr = 'POST\n/v2/tenants/'+tenant_Id+'/projects\nAuroraKey='+aurora_Key+'\nTimestamp='+currentTimeStamp()+
                '\nproject.address='+proj.address.replaceAll(' ','%20')+'&project.customer_address='+proj.customer_address.replaceAll(' ','%20')+'&project.customer_first_name='+proj.customer_first_name.replaceAll(' ','%20')+'&project.customer_last_name='+proj.customer_last_name.replaceAll(' ','%20')+'&project.customer_salutation='+proj.customer_salutation.replaceAll(' ','%20')+'&project.external_provider_id='+proj.external_provider_id+'&project.name='+proj.name.replaceAll(' ','%20')+'\n';
            
            String signStr = '';
            signStr=generateHmacSHA256Signature(canonicalStr,client_Secret);
            
            
            signStr = signStr.substring(0,signStr.length()-1);
            System.debug('signStr----->'+signStr);
            
            projReq.Signature = signStr;
            projReq.project = proj;
            
            String projJSON = JSON.serialize(projReq);
            System.debug('canonicalStr----->'+canonicalStr);
            System.debug('projJSON----->'+projJSON);
            
            
            Http http = new Http();
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            
            request.setEndpoint(endpoint_URL+'/v2/tenants/'+tenant_Id+'/projects');
            request.setBody(projJSON); 
            
            response = http.send(request);
            System.debug('response----->'+response.getBody());
            
            if(response.getStatusCode()==200){
                // Parse JSON response to extract Project Id.
                Map<String, Object> jSonStrObjMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('jSonStrObjMap----->'+jSonStrObjMap);
                System.debug('project----->'+jSonStrObjMap.get('project'));
                
                Map<String,Object> projStrObjMap = (Map<String,Object>)jSonStrObjMap.get('project');
                projectId = (String)projStrObjMap.get('id');
                System.debug('project id----->'+projectId);
                if(projectId!=null){
                    if(!partnerCreateDesign)
                        custAcc.Design_ProjectId__c = projectId;
                    if(partnerCreateDesign)
                        custAcc.External_Design_ProjectId__c = projectId;
                    update custAcc;
                }
            }
            else{
                errorMessage = response.getStatus() + ': ' + response.getBody();
            }
        }catch(Exception e){
            errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(accId,'Create Aurora Project',request,response));
        }
        
        try {
            if(spExLogsList != null && !spExLogsList.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(spExlogsList);
            } 
        } catch(Exception e) {}
        
        return projectId;
    }
    
    
    //-----------------------------------------CREATE DESIGN IN AURORA-------------------------------------------------//
    //Method to check if Design Id exists for a given Roof Design. If not create Design in Aurora and update the design Id
    public static String CreateDesign(Roof_Design__c rd, String auroraProjectId){
        
        String designId;
        //auroraProjectId = rd.Account_Name__r.Design_ProjectId__c ;
            
        if(rd.Design_DesignId__c!=null)
            return rd.Design_DesignId__c;
        
        Httprequest request = new HttpRequest();
        HttpResponse response = new HttpResponse();
        
        try{

            if(Userinfo.getUserType() != 'Standard') {
                User usr = [select contact.Account.Design_Tool_Organization_Id__c from User where Id = :Userinfo.getUserId()];
                tenant_Id = usr.contact.Account.Design_Tool_Organization_Id__c;
            }

            AuroraJSONUtil.DesignRequest projDesignReq =  new AuroraJSONUtil.DesignRequest();
            AuroraJSONUtil.Design design = new AuroraJSONUtil.Design(rd.Id, auroraProjectId, rd.Name);
            
            projDesignReq.AuroraKey = aurora_Key;
            projDesignReq.Timestamp = currentTimeStamp();
            
            String designCanonicalStr = 'POST\n/v2/tenants/'+tenant_Id+'/designs\nAuroraKey='+aurora_Key+'\nTimestamp='+currentTimeStamp()+
                '\ndesign.external_provider_id='+design.external_provider_id+'&design.name='+design.name.replaceAll(' ','%20')+'&design.project_id='+design.project_id+'\n';
            
            String signStr = '';
            signStr=generateHmacSHA256Signature(designCanonicalStr,'1fa91382-f55f-4a92-9700-5bf77323d56d');
            
            signStr = signStr.substring(0,signStr.length()-1);
            System.debug('signStr----->'+signStr);
            
            projDesignReq.Signature = signStr;
            projDesignReq.design = design;
            
            String designJSON = JSON.serialize(projDesignReq);
            System.debug('designCanonicalStr----->'+designCanonicalStr);
            System.debug('designJSON----->'+designJSON);
            
            
            Http http = new Http();
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Accept', 'application/json');
            
            request.setEndpoint(endpoint_URL+'/v2/tenants/'+tenant_Id+'/designs');
            request.setBody(designJSON);
            
            response = http.send(request);
            System.debug('response----->'+response.getBody());
            
            if(response.getStatusCode()==200){
                // Parse JSON response to extract Project Id.
                Map<String, Object> jSonStrObjMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('jSonStrObjMap----->'+jSonStrObjMap);
                System.debug('design----->'+jSonStrObjMap.get('design'));
                
                Map<String,Object> projStrObjMap = (Map<String,Object>)jSonStrObjMap.get('design');
                designId = (String)projStrObjMap.get('id');
                System.debug('design id----->'+designId);
                if(designId!=null){
                    rd.Design_DesignId__c=designId;
                    update rd;
                }  
            }
            else{
                errorMessage = response.getStatus() + ': ' + response.getBody();
            }
            
        }catch(Exception e){
            errorMessage = e.getMessage();
            spExLogsList.add(prepDebugLog(rd.Account_Name__c,'Create Aurora Design',request,response));
        }
        
        try {
            if(spExLogsList != null && !spExLogsList.isEmpty()) {
                SpectrumDebugUtility.generateDebugLog(spExlogsList);
            } 
        } catch(Exception e) {}
        
        return designId;
    }
    
    //Method to genrate Signature for a String using provided Signature
    private static String generateHmacSHA256Signature(String saltValue, String secretKeyValue) {
        String algorithmName = 'HmacSHA256';
        Blob hmacData = Crypto.generateMac(algorithmName, Blob.valueOf(saltValue), Blob.valueOf(secretKeyValue));
        return EncodingUtil.base64Encode(hmacData);
    }
    
    //Method to get Current Time Stamp in format required by Aurora
    public static String currentTimeStamp(){
        return (datetime.now().format('yyyy-MM-dd HH:mm:ss', 'UTC')+' UTC').replaceAll(' ','%20');
    }
    
    public static SpectrumDebugUtility.debugLog prepDebugLog(Id accountId,String serviceName,Httprequest request,Httpresponse response){
        
        //build log of ob msg and response
        SpectrumDebugUtility.debugLog spExLog = new SpectrumDebugUtility.debugLog();
        spExlog.AccountId = accountId;
        spExLog.Service = serviceName;
        spExLog.Response = response.getBody(); 
        spExLog.responseCode = response.getStatusCode();
        spExLog.JSONPayload = request.getBody();
        return spExLog;
    }
}