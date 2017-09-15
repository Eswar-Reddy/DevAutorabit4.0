@isTest
public class TEST_MockAgreementAPiCallout implements HttpCalloutMock{
    
    Boolean isMockResponseSuccessful;
    
    public TEST_MockAgreementAPiCallout(Boolean isMockResponseSuccessful) {
        this.isMockResponseSuccessful = isMockResponseSuccessful;
    }
    
    public HttpResponse respond(HttpRequest rqst) {
        HttpResponse hResp = new HttpResponse();
        
        if(this.isMockResponseSuccessful) {
            hResp.setStatusCode(200);
            hResp.setStatus('OK');
            hResp.setBody('Callout successful');
        } else {
            throw new REST_QuoteException('Read Timed Out');
        }
        return hResp;
    }

}