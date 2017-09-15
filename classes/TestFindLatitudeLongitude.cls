public class TestFindLatitudeLongitude implements HTTPCalloutMock {
    
    //override the respond method for HttpCalloutMock
    public HTTPResponse respond(HTTPRequest req) {
        //build a fake response
        HTTPResponse res = new HTTPResponse();
        //for parser method...string needs to be nested
        res.setBody('37.40502,-121.946544');
        res.setStatusCode(200);
        return res;
    }
    
    @isTest
    private static void Test_FindLatitudeLongitude1(){
        Account accountObj = new Account();
        accountObj.Name = 'Test' + DateTime.now();
        accountObj.Type ='Commercial';
        accountObj.BillingCity = 'san mateo';
        accountObj.BillingStreet = 'Concar drive';
        accountObj.BillingPostalCode ='94402';
        accountObj.BillingCountry = 'USA'; 
        insert accountObj;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestFindLatitudeLongitude());
        
        FindLatitudeLongitude.getLatitudeLongitude(accountObj.Id, 'referName'); 
        
        Test.stopTest();
    }
    
    @isTest
    private static void Test_FindLatitudeLongitude2(){
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestFindLatitudeLongitude());
        
        FindLatitudeLongitude.getLatitudeLongitudeOfAddress('Country', 'State', 'City', 'Street');   
        
        Test.stopTest();
    }
   
}