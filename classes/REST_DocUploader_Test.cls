@isTest
global class REST_DocUploader_Test {
	
	static TestMethod void testInputs1() {
		
		Design__c d = new Design__c();
        insert d;
        System.assertNotEquals(null, d.Id);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DocUploaderMock());

        RestRequest req = new RestRequest();
        req.addParameter('FileName', 'Test');
        req.addParameter('parentIds', d.Id);
        req.addParameter('attachmentOnly', 'false');
        req.requestBody = Blob.valueOf('Test');

        String res = REST_DocUploader.processRequest(req); 
        Test.stopTest();

	}
	
	static TestMethod void testInputs2() {
		
		Design__c d = new Design__c();
        insert d;
        System.assertNotEquals(null, d.Id);

        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DocUploaderMock());

        RestRequest req = new RestRequest();
        req.addParameter('FileName', 'Test');
        req.addParameter('parentIds', d.Id);
        req.addParameter('attachmentOnly', 'true');
        req.requestBody = Blob.valueOf('Test');

        String res = REST_DocUploader.processRequest(req); 
        Test.stopTest();
	}

	static TestMethod void testNegatives1() {
		
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DocUploaderMock());

        RestRequest req = new RestRequest();
        req.addParameter('FileName', 'Test');
        req.addParameter('parentIds', TestClassFactory.getFakeId(Document__c.sObjectType));
        req.addParameter('attachmentOnly', 'true');
        req.requestBody = Blob.valueOf('Test');

        String res = REST_DocUploader.processRequest(req);

        try {
        	REST_DocUploader.attachDoc();
        } catch(Exception e) {
        	System.debug('expected exception ' + e);
        }
        Test.stopTest();
	}

	static TestMethod void testNegatives2() {

		Sunpower_Spectrum_Debug_Log__c l = new Sunpower_Spectrum_Debug_Log__c();
		insert l;
		
		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DocUploaderMock());

        RestRequest req = new RestRequest();
        req.addParameter('FileName', 'Test');
        req.addParameter('parentIds', l.Id);
        req.addParameter('attachmentOnly', 'true');
        req.requestBody = Blob.valueOf('Test');

        REST_DocUploader.dmlSuccess = false;
        String res = REST_DocUploader.processRequest(req);
       
        Test.stopTest();
	}


	global class DocUploaderMock implements HttpCalloutMock {

		global HTTPResponse respond(HTTPRequest req) {

	        HttpResponse response = new HttpResponse();
	        response.setBody('{"":""}');
	        response.setStatusCode(200);
	        response.setStatus('Success');

	        return response;

	    }
	}
	
}