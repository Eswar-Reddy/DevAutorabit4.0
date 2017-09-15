/*******************************************************************************************
Date				Author				Comment		
********************************************************************************************
										Usage  : Mock Class for Testing REST_DesignItems Rest Resource Class

*/
@isTest
global class REST_DesignItemsMockHttpResponse implements HttpCalloutMock {

   // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) 
    {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
}