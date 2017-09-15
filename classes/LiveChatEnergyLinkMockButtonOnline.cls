@isTest
global class LiveChatEnergyLinkMockButtonOnline implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        String body = '{"messages":[{"type":"Availability", "message":{"results":[{"id":"57334000000GnMT","isAvailable":true}]}}]}';
        res.setBody(body);
        
        return res;
    }
}