@isTest
global class F9Web2CampaignMockHttpReponse implements HttpCalloutMock {
    
        global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Location', 'http://localhost?');
        
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(302);
        return res;
    }

}