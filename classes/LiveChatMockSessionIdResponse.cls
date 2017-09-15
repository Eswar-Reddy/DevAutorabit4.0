@isTest
global class LiveChatMockSessionIdResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        
        String body = '{"access_token" : "access_token_1"}';
        res.setBody(body);
        
        return res;
    }
}