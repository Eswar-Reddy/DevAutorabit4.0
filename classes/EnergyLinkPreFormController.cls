public class EnergyLinkPreFormController {
    public String language {get; private set;}
    public String liveAgentUrl{get; private set;} //This variable will take the Url value from Live Agent Configuration and will map it inside VF page
    public  List<Live_Agent_Url_Configuration__c> liveAgentCOnfigurationValues = Live_Agent_Url_Configuration__c.getAll().values(); // getting values from Live Agent Custom Setting
    //Changes related to Offline compatibility
    public String errorMsg {get; private set;}
    public String sessionId {get; private set;}
    public Boolean isNotBlankSessionId {get; private set;}    // debug. display this instead of sessionId. security
    public String availabilityStatus {get; private set;}
    public Integer availabilityStatusCode {get; private set;}
    public String availabilityRequestBody {get; private set;}
    public Object availabilityMessages {get; private set;}
    public Object availabilityType {get; private set;}
    public Boolean isAvailable {get; private set;}
    public Boolean showDebug {get; private set;}
    public String deploymentHostName {get; private set;}
    public String preChatHostName {get; private set;}
    public String liveAgentAPIEndpoint {get; private set;}
    public Boolean getVisitorLocation {get; private set;}
    public String org_id {get; private set;}    
    public String deployment_id {get; private set;}    
    public String button_id {get; private set;}   
    public EnergyLinkPreFormController() {
        
        language = 'en-US';
        if(liveAgentCOnfigurationValues !=null && liveAgentCOnfigurationValues.size() > 0){
            liveAgentUrl=String.valueOf(liveAgentCOnfigurationValues[0].Url__c);
            button_id=String.valueOf(liveAgentCOnfigurationValues[0].buttonid__c);
            deployment_id =String.valueOf(liveAgentCOnfigurationValues[0].deploymentId__c);  
            
        }
        else{
            liveAgentUrl='https://d.la4-c2-chi.salesforceliveagent.com/chat';
        }
        
        showDebug = false;
        isNotBlankSessionId = false;
        CustomSetting cs = getCustomSetting();
        showDebug = cs.showDebug;
        deploymentHostName = cs.deploymentHostName;
        preChatHostName = cs.preChatHostName;
        liveAgentAPIEndpoint = cs.liveAgentAPIEndpoint;
        //getVisitorLocation = cs.getVisitorLocation; 
        org_id = cs.org_id;
        // get session id
        SessionIdRequest req = new SessionIdRequest();
        req.consumerKey = cs.consumerKey;
        req.consumerSecret = cs.consumerSecret;
        req.userName = cs.userName;
        req.pwToken = decode(cs.pwToken);
        SessionIdResponse resp = getSessionId(req);
        sessionId = resp.sessionId;
        if (String.IsNotBlank(sessionId)) {
            isNotBlankSessionId = true;
        }
        errorMsg = resp.errorMsg;    
        if (String.IsNotBlank(errorMsg)) {
            errorMessage(errorMsg);
        }
        setCustomDetails();
    }
    
    /*
Function     : setCustomDetails
Parameter    : 
Returen Type : 
Summary      : This Function will update ButtonAvailabilityRequest based on Live_Agent_Settings__c  Custom Settings
*/
    public void setCustomDetails() {
        // get button availability
        if (String.IsNotBlank(sessionId)) {
            ButtonAvailabilityRequest req = new ButtonAvailabilityRequest();
            req.liveAgentAPIEndpoint = liveAgentAPIEndpoint;
            req.sessionId = sessionId;
            req.org_id = org_id;
            req.deployment_id = deployment_id;
            req.button_id = button_id;
            ButtonAvailabilityResponse resp = getButtonAvailability(req);
            isAvailable = resp.isAvailable;
            availabilityStatus = resp.availabilityStatus;
            availabilityStatusCode = resp.availabilityStatusCode;
            availabilityRequestBody = resp.availabilityRequestBody;
            availabilityMessages = resp.availabilityMessages;
            availabilityType = resp.availabilityType;
            errorMsg = resp.errorMsg;
            if (String.IsNotBlank(errorMsg)) {
                errorMessage(errorMsg);
            }
        }
    }
    /*
Function     : getButtonAvailability
Parameter    : ButtonAvailabilityRequest 
Returen Type : ButtonAvailabilityResponse 
Summary      : This function get the availability of Live Agent user based on Org Id,deployment Id and button Id
*/
    public static ButtonAvailabilityResponse getButtonAvailability(ButtonAvailabilityRequest baReq) {
        ButtonAvailabilityResponse resp = new ButtonAvailabilityResponse();
        Boolean isAvailable = false;
        String availabilityStatus;
        Integer statusCode;
        Integer availabilityStatusCode;
        String availabilityRequestBody;
        Object availabilityMessages;
        Object availabilityType;
        String errorMsg;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        String liveAgentAPIEndpoint = baReq.liveAgentAPIEndpoint;
        // remove ending / if specified
        if (String.IsNotBlank(liveAgentAPIEndpoint) && liveAgentAPIEndpoint.endsWith('/')) {
            liveAgentAPIEndpoint = liveAgentAPIEndpoint.left(liveAgentAPIEndpoint.length()-1);
        }
        String endPoint = liveAgentAPIEndpoint + '/Visitor/Availability';
        endPoint += '?org_id=' + baReq.org_id + '&deployment_id=' + baReq.deployment_id + '&Availability.ids=' + baReq.button_id;
        req.setEndpoint(endPoint);
        req.setHeader('Authorization', 'OAuth ' + baReq.sessionId);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-LIVEAGENT-API-VERSION', '36');
        req.setHeader('X-PrettyPrint', '1');
        req.setMethod('GET');
        HttpResponse res = null;
        try {
            res = h.send(req);
            if (res != null) {
                String status = res.getStatus();
                statusCode = res.getStatusCode();
                availabilityStatus = status;    // debug
                availabilityStatusCode = statusCode;    // debug
                availabilityRequestBody = res.getBody();    // debug
                Map <String, Object> mapBody = (Map <String, Object>)JSON.deserializeUntyped(res.getBody());
                availabilityMessages = mapBody.get('messages');
                if (availabilityMessages != null) {
                    List<Object> messagesList = (List<Object>)(mapBody.get('messages'));
                    for (Object obj : messagesList) {
                        Map<String, Object> messages = (Map<String, Object>)obj;
                        availabilityType = messages.get('type');
                        if (messages.get('type') == 'Availability') {
                            Map<String, Object> message = (Map<String, Object>)messages.get('message');
                            List<Object> resultList = (List<Object>)message.get('results');
                            for (Object resultObj : resultList) {
                                Map<String, Object> result = (Map<String, Object>)resultObj;
                                if (result.get('id') == baReq.button_id) {
                                    if (result.get('isAvailable') != null) {
                                        isAvailable = (Boolean)result.get('isAvailable');
                                    }
                                }
                            }
                            break;
                        }
                    }
                }
            }
        } catch(Exception e) {
            errorMsg = 'Error while getting button status: ' + e.getMessage();
        }
        resp.isAvailable = isAvailable;
        resp.availabilityStatus = availabilityStatus;
        resp.availabilityStatusCode = availabilityStatusCode;
        resp.availabilityRequestBody = availabilityRequestBody;
        resp.availabilityMessages = availabilityMessages;
        resp.availabilityType = availabilityType;    
        resp.errorMsg = errorMsg;
        return resp;        
    }
    /*
Function     : getSessionId
Parameter    : SessionIdRequest 
Returen Type : 
Summary      : This function get the session Id by using Connected App LiveAgentIntegration with  OAuth 2.0
*/
    public static SessionIdResponse getSessionId(SessionIdRequest siReq) {
        SessionIdResponse resp = new SessionIdResponse();
        String sessionId;
        String errorMsg;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/oauth2/token');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=password&client_id=' + siReq.consumerKey + '&client_secret=' + siReq.consumerSecret + '&username=' + siReq.userName + '&password=' + siReq.pwToken);
        Http http = new Http();
        HttpResponse sessionResponse;
        try {
            sessionResponse = http.send(req);
            if (sessionResponse != null) {
                Integer sessionStatusCode = sessionResponse.getStatusCode();
                if (sessionStatusCode == 200) {
                    String body = sessionResponse.getBody();
                    if (String.IsNotBlank(body)) {
                        Map <String, Object> mapBody = (Map <String, Object>)JSON.deserializeUntyped(body);
                        sessionId = (String)mapBody.get('access_token');
                    }
                } else {
                    errorMsg = 'Session Response has error:: '+ sessionResponse.getStatusCode() + '--' + sessionResponse.getStatus();
                }
            }  
        } catch (Exception e) {
            errorMsg = e.getMessage();
        } 
        resp.sessionId = sessionId;
        resp.errorMsg = errorMsg;
        return resp;
    }
    @testVisible
    private void setSessionId(String sessionId) {
        this.sessionId = sessionId;
    }
    /*
Function     : getCustomSetting
Parameter    : 
Returen Type : 
Summary      : This Function get all the values of Custom Setting Live_Agent_Settings__c  
*/
    public static CustomSetting getCustomSetting() {
        CustomSetting cs = new CustomSetting();    
        for (Live_Agent_Settings__c setting : Live_Agent_Settings__c.getAll().values()) {    
            if (setting.Value__c != null) {
                if (setting.Name.equalsIgnoreCase('consumerKey')) {
                    cs.consumerKey = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('consumerSecret')) {
                    cs.consumerSecret = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('userName')) {
                    cs.userName = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('pwToken')) {
                    cs.pwToken = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('showDebug')) {
                    if ('true'.equalsIgnoreCase(setting.Value__c)) {
                        cs.showDebug = true;
                    }
                } else if (setting.Name.equalsIgnoreCase('deploymentHostName')) {
                    cs.deploymentHostName = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('preChatHostName')) {
                    cs.preChatHostName = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('liveAgentAPIEndpoint')) {
                    cs.liveAgentAPIEndpoint = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('org_id')) {
                    cs.org_id = setting.Value__c;
                } else if (setting.Name.equalsIgnoreCase('getVisitorLocation')) {
                    if ('true'.equalsIgnoreCase(setting.Value__c)) {
                        cs.getVisitorLocation = true;
                    }
                }
            }
        }
        return cs;    
    }
    /*
Function     : decode
Parameter    : String
Returen Type : String
Summary      : This Function will get the decoded String from Live_Agent_Settings__c  Custom Settings - password to actual password
*/
    private static String decode(String encodedStr) {
        String retStr; 
        if (String.IsNotBlank(encodedStr)) {   
            Blob b = EncodingUtil.base64Decode(encodedStr);
            retStr = b.toString();
        }
        return retStr;    
    }
    /*
Function     : errorMessage
Parameter    : String
Returen Type : 
Summary      : This Function will capture the error in the class and display it on VF page 
*/
    private void errorMessage(String msg) {
        errorMsg = msg;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
    }
    public class ButtonAvailabilityRequest {
        public String liveAgentAPIEndpoint; 
        public String sessionId; 
        public String org_id;
        public String deployment_id;
        public String button_id;    
        public String errorMsg;     
    }
    public class ButtonAvailabilityResponse {
        public Boolean isAvailable; 
        public String availabilityStatus;
        public Integer availabilityStatusCode;
        public String availabilityRequestBody;
        public Object availabilityMessages;
        public Object availabilityType;    
        public String errorMsg;     
    }
    public class SessionIdRequest {
        public String consumerKey;    
        public String consumerSecret;    
        public String userName;    
        public String pwToken;    
    }
    public class SessionIdResponse {
        public String sessionId;     
        public String errorMsg;     
    }
    public class CustomSetting {
        public String consumerKey;    
        public String consumerSecret;    
        public String userName;    
        public String pwToken; 
        public Boolean showDebug = false;  
        public String deploymentHostName;
        public String preChatHostName;
        public String liveAgentAPIEndpoint;
        public String org_id;
        public Boolean getVisitorLocation = false;  
    } 
}