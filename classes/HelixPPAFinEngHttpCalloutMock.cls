@isTest
global class HelixPPAFinEngHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('<?xml version="1.0"?><abc></abc>');
        res.setStatusCode(200);
        return res;
    }
}