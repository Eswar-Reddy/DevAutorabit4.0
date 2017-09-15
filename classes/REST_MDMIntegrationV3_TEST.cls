@isTest(SeeAllData=true)
private class REST_MDMIntegrationV3_TEST {

    static testMethod void testAccountInsert() {

        RestRequest req1 = new RestRequest(); 
        RestResponse res1 = new RestResponse();
        req1.requestURI = '/services/apexrest/REST_CustomerIntegration/v1/*';  
 
        String acc='{'+
  '"ObjectType": "Account",'+
  '"ObjectList": ['+
    '{'+
      '"Action": "Insert",'+
      '"AccountFirstName": "Test",'+
      '"AccountLastName": "TestRMDMIntV3Test1",'+
      '"ExternalSourceId": "987987",'+
      '"ExternalSourceName": "SMS",'+
      '"PartnerId": "0018000000UqM8i",'+
      '"RecordType": "Residential Customer",'+
      '"TransactionType": "Cash",'+
      '"IsCustomer": "True",'+
      '"ContactEmail": "testRMDMIntV3@test1.com",'+
      '"ContactPhone": "4996543299",'+
      '"BillingStreet": "838 Blossom Hill Rd",'+
      '"BillingCity": "San Jose",'+
      '"BillingState": "CA",'+
      '"BillingPostalCode": "95123",'+
      '"BillingCountry": "United States",'+
      '"CurrencyIsoCode": "USD"'+
    '}'+
  ']'+
'}';
        
        
        req1.requestBody = Blob.valueof(acc);
        //req.httpMethod = 'POST';
        RestContext.request = req1;
        RestContext.response = res1;
        REST_MDMIntegrationV3.DesignInfo mdmds = new REST_MDMIntegrationV3.DesignInfo();
        REST_MDMIntegrationV3.updateRecords();
        
        
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/REST_CustomerIntegration/v1/*';
        req2.requestBody = Blob.valueof(acc);
        //req.httpMethod = 'POST';
        RestContext.request = req2;
        RestContext.response = res2;

        REST_MDMIntegrationV3.updateRecords();

    }
    
    
    static testMethod void testAccountUpdate() {
        
        Account a = [select Id from Account where RecordType.Name='Residential Customer' limit 1 ];
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/REST_CustomerIntegration/v1/*';  
 
       String acc='{'+
  '"ObjectType": "Account",'+
  '"ObjectList": ['+
    '{'+
      '"Action": "Update",'+
      '"AccountFirstName": "Test",'+
      '"AccountLastName": "TestRMDMIntV3Test1",'+
      '"ExternalSourceId": "987987",'+
      '"ExternalSourceName": "SMS",'+
      '"PartnerId": "0018000000UqM8i",'+
      '"RecordType": "Residential Customer",'+
      '"TransactionType": "Cash",'+
      '"IsCustomer": "True",'+
      '"ContactEmail": "testRMDMIntV3@test1.com",'+
      '"ContactPhone": "4996543299",'+
      '"BillingStreet": "838 Blossom Hill Rd",'+
      '"BillingCity": "San Jose",'+
      '"BillingState": "CA",'+
      '"BillingPostalCode": "95123",'+
      '"BillingCountry": "United States",'+
      '"CurrencyIsoCode": "USD"'+
      '}'+
  ']'+
'}';
        
        
        req.requestBody = Blob.valueof(acc);
        //req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        REST_MDMIntegrationV3.updateRecords();
    }
}