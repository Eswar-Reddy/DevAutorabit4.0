public without sharing class AuroraDesignAPI {

    public static GetDesignPageResponse getDesignPage(GetDesignPageRequest request) {
        GetDesignPageResponse response = new GetDesignPageResponse();
        
        if (String.IsNotBlank(request.auroraDesignId)) {
            response.designPageReference = getDesignPageReference(request.auroraDesignId);
        } else {
            String errMsg = 'Aurora design id is required';
            response.errorMessageList.add(errMsg);
        }

        return response;
    }

    private static PageReference getDesignPageReference(String auroraDesignId) {
        // get from custom settings
        AuroraAPIUtil.CustomSetting setting = AuroraAPIUtil.getCustomSetting();
        PageReference pr = new PageReference(setting.auroraAuthURL + '/' + setting.userType + setting.auroraRedirectURI + 'designs/' + auroraDesignId);
        return pr;    
    }
    
    public static CreateDesignResponse createDesign(CreateDesignRequest request) {
        CreateDesignResponse response = new CreateDesignResponse();
    
        Design__c design = new Design__c();
        if (String.IsBlank(request.designId)) {
            String errMsg = 'designId parameter is required';
            response.errorMessageList.add(errMsg);
        } else {
            design = AuroraAPIUtil.getDesign(request.designId);
            if (design.Id == null) {
                String errMsg = 'Salesforce design record not found for design id: ' + request.designId;
                response.errorMessageList.add(errMsg);
            } else if (String.IsBlank(request.auroraProjectId)) {
                String errMsg = 'Aurora project id is required to create design';
                response.errorMessageList.add(errMsg);
            } else if (design.Roof_Design__r.Design_DesignId__c != null) {
                String errMsg = 'Aurora design id already exists in roof design: ' + design.Roof_Design__r.Design_DesignId__c;
                response.errorMessageList.add(errMsg);
            } else {
                AuroraCreateDesignResponse auroraResp = createAuroraDesign(request.auroraProjectId, design);
                
                // copy http request and response to write spectrum debug log
                response.httpReq = auroraResp.httpReq;
                response.httpRes = auroraResp.httpRes;
                
                String httpRequestEndPoint = auroraResp.httpReq.getEndPoint();
                String httpRequestBody = auroraResp.httpReq.getBody();
                Decimal httpResponseStatusCode = auroraResp.httpRes.getStatusCode();
                String httpResponseStatus = auroraResp.httpRes.getStatus();
                String httpResponseBody = auroraResp.httpRes.getBody();
                
                if (httpResponseStatusCode == 200) {
                    Map <String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(httpResponseBody);
                    if (bodyMap.containsKey('design')) {
                        Map <String, Object> projectMap = (Map <String, Object>)bodyMap.get('design');
                        if (projectMap.containsKey('id')) {
                            response.auroraDesignId = (String)projectMap.get('id');
                            response.designPageReference = getDesignPageReference(response.auroraDesignId);
                        } else {
                            String errMsg = 'Aurora design creation failed. Design id not found in httpResponseBody.';
                            errMsg += '\n' + 'httpResponseStatusCode: ' + httpResponseStatusCode;
                            errMsg += '\n' + 'httpResponseStatus: ' + httpResponseStatus;
                            errMsg += '\n' + 'httpResponseBody: ' + httpResponseBody;
                            response.errorMessageList.add(errMsg); 
                        }
                    } else {
                        String errMsg = 'Aurora design creation failed. Design not found in httpResponseBody.';
                        errMsg += '\n' + 'httpResponseStatusCode: ' + httpResponseStatusCode;
                        errMsg += '\n' + 'httpResponseStatus: ' + httpResponseStatus;
                        errMsg += '\n' + 'httpResponseBody: ' + httpResponseBody;
                        response.errorMessageList.add(errMsg); 
                    }
                } else {
                    String errMsg = 'Aurora design creation failed.';
                    errMsg += '\n' + 'httpResponseStatusCode: ' + httpResponseStatusCode;
                    errMsg += '\n' + 'httpResponseStatus: ' + httpResponseStatus;
                    errMsg += '\n' + 'httpResponseBody: ' + httpResponseBody;
                    response.errorMessageList.add(errMsg); 
                }
            }
        }
    
        return response;
    }
    
    private static AuroraCreateDesignResponse createAuroraDesign(String auroraProjectId, Design__c sfdcDesign) {
        AuroraCreateDesignResponse response = new AuroraCreateDesignResponse();
        
        User usr = AuroraAPIUtil.getUser(UserInfo.getUserId());
        system.debug('usr: ' + usr);
        
        // get from custom settings
        AuroraAPIUtil.CustomSetting setting = AuroraAPIUtil.getCustomSetting();

        if (Userinfo.getUserType() != 'Standard') {
            setting.tenant_Id = usr.contact.Account.Design_Tool_Organization_Id__c;
        }
        system.debug('tenant_Id: ' + setting.tenant_Id);
        system.debug('AuroraKey: ' + setting.AuroraKey);
        system.debug('client_Secret: ' + setting.client_Secret);
        system.debug('endpoint_URL: ' + setting.endpoint_URL);

        AuroraCreateDesignParams design = new AuroraCreateDesignParams();
        design.external_provider_id = sfdcDesign.Id;
        if (sfdcDesign.RecordType.DeveloperName == 'Project_Design') {
            String designPhase = sfdcDesign.Deal_Status__c != null ? sfdcDesign.Deal_Status__c : 'Proposal Design';
            String version = sfdcDesign.Revision_Letter__c != null ? sfdcDesign.Revision_Letter__c : 'A';
            design.name = sfdcDesign.Name + '-' + designPhase + '-' + version;
        } else {
            design.name = sfdcDesign.Name;
        }
        design.project_id = auroraProjectId;
        system.debug('design: ' + design);
        
        AuroraCreateDesignRequest request = new AuroraCreateDesignRequest();
        request.AuroraKey = setting.AuroraKey;
        request.Timestamp = AuroraAPIUtil.getUrlEncoded(AuroraAPIUtil.getTimestamp());
        request.design = design;
        request.Signature = getSignature(setting.tenant_Id, setting.client_Secret, request);
        system.debug('request: ' + request);
        
        String requestJSON = JSON.serialize(request);
        
        Httprequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setEndpoint(setting.endpoint_URL + '/v2/tenants/' + setting.tenant_Id + '/designs');
        httpReq.setBody(requestJSON);
        
        Http http = new Http();
        HttpResponse httpRes = http.send(httpReq);    
        
        response.httpReq = httpReq;
        response.httpRes = httpRes;
        
        return response;
    }
    
    private static String getSignature(String tenant_Id, String client_Secret, AuroraCreateDesignRequest request) {
        String signature;
        
        String canonicalStr = 'POST';
        canonicalStr += '\n' + '/v2/tenants/'+ tenant_Id + '/designs';
        canonicalStr += '\n' + 'AuroraKey=' + request.AuroraKey;
        canonicalStr += '\n' + 'Timestamp=' + request.Timestamp;
        canonicalStr += '\n' + 'design.external_provider_id=' + AuroraAPIUtil.getUrlEncoded(request.design.external_provider_id);
        canonicalStr += '&' + 'design.name=' + AuroraAPIUtil.getUrlEncoded(request.design.name);
        canonicalStr += '&' + 'design.project_id=' + AuroraAPIUtil.getUrlEncoded(request.design.project_id);
        canonicalStr += '\n';
        signature = AuroraAPIUtil.generateHmacSHA256Signature(canonicalStr, client_Secret);
        signature = signature.substring(0, signature.length()-1);
        
        return signature;
    }
    
    public class CreateDesignRequest {
        public String auroraProjectId;
        public String designId;    
    }
    
    public class CreateDesignResponse {
        public List <String> errorMessageList = new List <String>();
        public PageReference designPageReference;
        public String auroraDesignId;
        public HttpRequest httpReq;
        public HttpResponse httpRes;
    }

    private class AuroraCreateDesignParams {
        private String external_provider_id;
        private String name;
        private String project_id;
    }

    private class AuroraCreateDesignRequest {
        private String AuroraKey;
        private String Timestamp;
        private String Signature;
        AuroraCreateDesignParams design;
    }
    
    private class AuroraCreateDesignResponse {
        HttpRequest httpReq;
        HttpResponse httpRes;
    }

    public class GetDesignPageRequest {
        public String auroraDesignId;    
    }
    
    public class GetDesignPageResponse {
        public List <String> errorMessageList = new List <String>();
        public PageReference designPageReference;
    }

}