@isTest
global class LiveChatMockButtonOnlineResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        String body = '{"messages":[{"type":"Availability", "message":{"results":[{"id":"57354000000006d","isAvailable":true}]}}]}';
        res.setBody(body);
        
        return res;
    }
}