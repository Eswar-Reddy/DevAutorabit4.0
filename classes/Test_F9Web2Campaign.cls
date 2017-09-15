@isTest(seealldata='false')
private class Test_F9Web2Campaign {
     @isTest 
    static void testCallout() {
          Five9WebserviceCalloutSettings__c objFive9Web = new Five9WebserviceCalloutSettings__c();
        objFive9Web.Name = 'Five9';
        objFive9Web.APIURL__c = 'https://api.five9.com/web2campaign/AddToList';
        insert objFive9Web;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new F9Web2CampaignMockHttpReponse());
         Lead obj_L = new Lead();
        Map<String, String> f9lead = new Map<String, String>();
        /*obj_L.City='Santa Clara';
        obj_L.Status='new';
        obj_L.LeadSource='Affilate'; 
        obj_L.LastName = 'Test1';
        obj_L.Email='a@gmail.com';
        obj_L.Company='ABC';
        obj_L.Lead_Manufacturer__c='SunPower';
        obj_L.Country='United states';
        obj_L.PostalCode='95051';
        obj_L.State='CA';
        obj_L.Street='Adriatic Way';
        //Insert obj_L;*/
        
        //f9lead.put('F9domain', FIVE9WEBSERVICE.Domain_Name__c);			//required
        //f9lead.put('F9list', FIVE9WEBSERVICE.SPDF9list__c);				//required
        f9lead.put('F9list', 'test');
        //f9lead.put('F9key', FIVE9WEBSERVICE.F9key__c);					//typical use case
		F9Web2Campaign f9 = new F9Web2Campaign();             
       F9Web2CampaignResult res = f9.doPost(f9lead);
         Test.stopTest();
     }

}