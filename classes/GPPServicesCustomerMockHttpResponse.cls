/********************************************************************************************
Author : Birlasoft
Usage  : Mock Class for Testing GPPServicesCustomer Rest Resource Class
Edits  :    
        2014-03-13  : Formatted & Removed Unused lines.
********************************************************************************************/

@isTest
global class GPPServicesCustomerMockHttpResponse implements HttpCalloutMock 
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