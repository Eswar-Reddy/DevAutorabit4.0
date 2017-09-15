public class HelixPPADocGenHandler {

    public static Response callDocGen(Request request) {
        Response response = new Response();    
    
        if (request != null) {
            if (request.jsonGenerator != null) {
                response.httpRequest = new HttpRequest();
                response.httpRequest.setEndpoint(DocGen_Callout_Settings__c.getAll().get('DocGen').EndPoint_Contract__c);
                response.httpRequest.setMethod('POST');
                response.httpRequest.setHeader('Content-Type', 'application/json');
                response.httpRequest.setTimeout(120000);
                response.httpRequest.setBody(request.jsonGenerator.getAsString());
                Http http = new Http();
                
                try {
                    response.httpResponse = http.send(response.httpRequest);
                    Integer statusCode = response.httpResponse.getStatusCode();
                    if (statusCode >= 400) {
                        response.errorMessage = 'Error in DocGen response statusCode: ' + statusCode + ' status: ' + response.httpResponse.getStatus();
                    } else {
                        response.isSuccess = true;
                    }
                } catch(Exception e) {
                    response.errorMessage = 'Error while sending DocGen request: ' + e.getMessage();
                }
            } else {
                response.errorMessage = 'HelixPPADocGenHandler request.jsonGenerator is null';
            }
        } else {
            response.errorMessage = 'HelixPPADocGenHandler request is null';
        }
        
        return response;    
    }
    
    public class Request {
        public JSONGenerator jsonGenerator;
    }
    public class Response {
        public Boolean isSuccess;
        public String errorMessage;
        public HttpRequest httpRequest; 
        public HttpResponse httpResponse; 
        public Response() {
            isSuccess = false;
        }   
    }
    
}