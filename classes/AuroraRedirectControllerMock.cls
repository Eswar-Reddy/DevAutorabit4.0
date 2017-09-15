@isTest
public class AuroraRedirectControllerMock implements HttpCalloutMock {

    public static Integer STATUS_CODE_200 = 200;
    public static String STATUS_200 = 'Success';
    public static String BODY_200 = 
        '{' +
            '"project":' +
            '{' +
                '"id": "db0791db-444c-44e5-b50c-e5e649118c0d",' +
                '"external_provider_id": "YourId123",' +
                '"name": "Special project at Solar Street 1 for Jane Doe",' +
                '"customer_salutation": "Mrs.",' +
                '"customer_first_name": "Jane",' +
                '"customer_last_name": "Doe",' +
                '"customer_address": "123 Main Street, Unit #12, City, CA, 93120",' +
                '"address" : "123 Main Street, Unit #12, City, CA, 93120",' +
                '"latitude": 0.0,' +
                '"longitude": 0.0' +
            '},' +
            '"design":' +
            '{' +
                '"id": "db0791db-444c-44e5-b50c-e5e649118c0e",' +
                '"external_provider_id": "YourId123ForThisDesign",' +
                '"project_id": "db0791db-444c-44e5-b50c-e5e649118c0e",' +
                '"name": "New Design"' +
            '}' +
        '}'
        ;

    public static Integer STATUS_CODE_401 = 401;
    public static String STATUS_401 = 'Unauthorized';
    public static String BODY_401 = '';
    
    public static Integer STATUS_CODE;
    public static String STATUS;
    public static String BODY;

    public HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(BODY);
        res.setStatusCode(STATUS_CODE);
        res.setStatus(STATUS);
        return res;
            
    }
    
}