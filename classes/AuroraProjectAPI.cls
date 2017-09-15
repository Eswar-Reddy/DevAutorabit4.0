public without sharing class AuroraProjectAPI {

    public static GetProjectPageResponse getProjectPage(GetProjectPageRequest request) {
        GetProjectPageResponse response = new GetProjectPageResponse();
        
        if (String.IsNotBlank(request.auroraProjectId)) {
            response.projectPageReference = getProjectPageReference(request.auroraProjectId);
        } else {
            String errMsg = 'Aurora project id is required';
            response.errorMessageList.add(errMsg);
        }
    
        return response;
    }
    
    private static PageReference getProjectPageReference(String auroraProjectId) {
        // get from custom settings
        AuroraAPIUtil.CustomSetting setting = AuroraAPIUtil.getCustomSetting();
        PageReference pr = new PageReference(setting.auroraAuthURL + '/' + setting.userType + setting.auroraRedirectURI + 'projects/' + auroraProjectId);
        return pr;    
    }

    public static CreateProjectResponse createProject(CreateProjectRequest request) {
        CreateProjectResponse response = new CreateProjectResponse();
    
        User currentUser = AuroraAPIUtil.getUser(UserInfo.getUserId());
        
        Site_Information_Form__c site = new Site_Information_Form__c();
        if (String.IsBlank(request.siteId)) {
            String errMsg = 'siteId parameter is required';
            response.errorMessageList.add(errMsg);
        } else {
            site = AuroraAPIUtil.getSite(request.siteId);
            if (site.Id == null) {
                String errMsg = 'Salesforce site record not found for site id: ' + request.siteId;
                response.errorMessageList.add(errMsg);
            } else if (currentUser.ContactId != null && site.External_Project_Id__c != null) {
                String errMsg = 'Site already has aurora external project id: ' + site.External_Project_Id__c;
                response.errorMessageList.add(errMsg);
            } else if (currentUser.ContactId == null && site.Internal_Project_Id__c != null) {
                String errMsg = 'Site already has aurora internal project id: ' + site.Internal_Project_Id__c;
                response.errorMessageList.add(errMsg);
            } else {
                AuroraCreateProjectResponse auroraResp = createAuroraProject(site);
                
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
                    if (bodyMap.containsKey('project')) {
                        Map <String, Object> projectMap = (Map <String, Object>)bodyMap.get('project');
                        if (projectMap.containsKey('id')) {
                            response.auroraProjectId = (String)projectMap.get('id');
                            response.projectPageReference = getProjectPageReference(response.auroraProjectId);
                        } else {
                            String errMsg = 'Aurora project creation failed. Project id not found in httpResponseBody.';
                            errMsg += '\n' + 'httpResponseStatusCode: ' + httpResponseStatusCode;
                            errMsg += '\n' + 'httpResponseStatus: ' + httpResponseStatus;
                            errMsg += '\n' + 'httpResponseBody: ' + httpResponseBody;
                            response.errorMessageList.add(errMsg); 
                        }
                    } else {
                        String errMsg = 'Aurora project creation failed. Project not found in httpResponseBody.';
                        errMsg += '\n' + 'httpResponseStatusCode: ' + httpResponseStatusCode;
                        errMsg += '\n' + 'httpResponseStatus: ' + httpResponseStatus;
                        errMsg += '\n' + 'httpResponseBody: ' + httpResponseBody;
                        response.errorMessageList.add(errMsg); 
                    }
                } else {
                    String errMsg = 'Aurora project creation failed.';
                    errMsg += '\n' + 'httpResponseStatusCode: ' + httpResponseStatusCode;
                    errMsg += '\n' + 'httpResponseStatus: ' + httpResponseStatus;
                    errMsg += '\n' + 'httpResponseBody: ' + httpResponseBody;
                    response.errorMessageList.add(errMsg); 
                }
            }
        }
    
        return response;
    }
    
    private static AuroraCreateProjectResponse createAuroraProject(Site_Information_Form__c site) {
        AuroraCreateProjectResponse response = new AuroraCreateProjectResponse();
        
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

        Account customer = AuroraAPIUtil.getAccount(site.Account__c);
        system.debug('customer: ' + customer);

        List <Contact> contactList = AuroraAPIUtil.getContactList(customer.Id);
        system.debug('contactList.size(): ' + contactList.size());
        
        AuroraCreateProjectParams project = new AuroraCreateProjectParams();
        project.external_provider_id = site.Id;
        
        //KCM_02212017: Pivotal 140102229
        if (site.Site_Name__c != Null || site.Site_Name__c != '') {
            project.name = site.Site_Name__c;
        } else {
            project.name = site.Name;
        }
        project.customer_salutation = contactList.size() > 0 ? contactList[0].Salutation : '';
        project.customer_first_name = contactList.size() > 0 ? contactList[0].FirstName : '';
        project.customer_last_name = contactList.size() > 0 ? contactList[0].LastName : '';
        project.customer_address = AuroraAPIUtil.getCustomerAddress(customer);
        project.address = AuroraAPIUtil.getSiteAddress(site);
        project.project_type = 'commercial';
        //project.latitude = Decimal.valueOf(site.Site_Latitude_Y_coordinate__c);
        //project.longitude = Decimal.valueOf(site.Site_Longitude_X_coordinate__c);
        system.debug('project: ' + project);
        
        AuroraCreateProjectRequest request = new AuroraCreateProjectRequest();
        request.AuroraKey = setting.AuroraKey;
        request.Timestamp = AuroraAPIUtil.getUrlEncoded(AuroraAPIUtil.getTimestamp());
        request.project = project;
        request.Signature = getSignature(setting.tenant_Id, setting.client_Secret, request);
        system.debug('request: ' + request);
        
        String requestJSON = JSON.serialize(request);
        
        Httprequest httpReq = new HttpRequest();
        httpReq.setMethod('POST');
        httpReq.setHeader('Content-Type', 'application/json');
        httpReq.setHeader('Accept', 'application/json');
        httpReq.setEndpoint(setting.endpoint_URL + '/v2/tenants/' + setting.tenant_Id + '/projects');
        httpReq.setBody(requestJSON);
        
        Http http = new Http();
        HttpResponse httpRes = http.send(httpReq);    
        
        response.httpReq = httpReq;
        response.httpRes = httpRes;
        
        return response;
    }
    
    private static String getSignature(String tenant_Id, String client_Secret, AuroraCreateProjectRequest request) {
        String signature;
        
        String canonicalStr = 'POST';
        canonicalStr += '\n' + '/v2/tenants/'+ tenant_Id + '/projects';
        canonicalStr += '\n' + 'AuroraKey=' + request.AuroraKey;
        canonicalStr += '\n' + 'Timestamp=' + request.Timestamp;
        canonicalStr += '\n' + 'project.address=' + AuroraAPIUtil.getUrlEncoded(request.project.address);
        canonicalStr += '&' + 'project.customer_address=' + AuroraAPIUtil.getUrlEncoded(request.project.customer_address);
        canonicalStr += '&' + 'project.customer_first_name=' + AuroraAPIUtil.getUrlEncoded(request.project.customer_first_name);
        canonicalStr += '&' + 'project.customer_last_name=' + AuroraAPIUtil.getUrlEncoded(request.project.customer_last_name);
        canonicalStr += '&' + 'project.customer_salutation=' + AuroraAPIUtil.getUrlEncoded(request.project.customer_salutation);
        canonicalStr += '&' + 'project.external_provider_id=' + AuroraAPIUtil.getUrlEncoded(request.project.external_provider_id);
        canonicalStr += '&' + 'project.name=' + AuroraAPIUtil.getUrlEncoded(request.project.name);
        canonicalStr += '&' + 'project.project_type=' + AuroraAPIUtil.getURLEncoded(request.project.project_type);
        canonicalStr += '\n';
        signature = AuroraAPIUtil.generateHmacSHA256Signature(canonicalStr, client_Secret);
        signature = signature.substring(0, signature.length()-1);
        
        return signature;
    }
    
    public class CreateProjectRequest {
        public String siteId;    
    }
    
    public class CreateProjectResponse {
        public List <String> errorMessageList = new List <String>();
        public PageReference projectPageReference;
        public String auroraProjectId;
        public HttpRequest httpReq;
        public HttpResponse httpRes;
    }

    private class AuroraCreateProjectParams {
        private String external_provider_id;
        private String name;
        private String customer_salutation;
        private String customer_first_name;
        private String customer_last_name;
        private String customer_address;
        private String address;
        private String project_type = 'commerical';
        //private Decimal latitude;
        //private Decimal longitude;
    
    }
    
    private class AuroraCreateProjectRequest {
        private String AuroraKey;
        private String Timestamp;
        private String Signature;
        AuroraCreateProjectParams project;
    }
    
    private class AuroraCreateProjectResponse {
        HttpRequest httpReq;
        HttpResponse httpRes;
    }
    
    public class GetProjectPageRequest {
        public String auroraProjectId;    
    }
    
    public class GetProjectPageResponse {
        public List <String> errorMessageList = new List <String>();
        public PageReference projectPageReference;
    }

}