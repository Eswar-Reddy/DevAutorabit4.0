/********************************************************************************************
Author : Birlasoft
Usage  : Mock Class for Testing GPPServices Rest Resources
Edits  : 2014-07-08: Renamed the class from "GPPServicesCustomerMockHttpResponse" to "GPPServicesMockHttpResponse"   
        
********************************************************************************************/

@isTest
global class GPPServicesMockHttpResponse implements HttpCalloutMock 
{
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