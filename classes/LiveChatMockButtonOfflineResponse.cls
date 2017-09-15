@isTest
global class LiveChatMockButtonOfflineResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        
        String body = '{"messages":[{"type":"Availability", "message":{"results":[{"id":"57354000000006d"}]}}]}';
        res.setBody(body);
        
        return res;
    }
}