@isTest
private class HelixDesignRequestUtilities_Test {
	
	@isTest 
	private static void testHeadlines() {
		
		List<APPR_PUB__Headline__c> headlines = new List<APPR_PUB__Headline__c>();
		for(Integer i = 0; i < 5; i++) {
			APPR_PUB__Headline__c headline = new APPR_PUB__Headline__c();
			headline.Name = 'Test'+i;
			headline.Display_Name__c = 'Test'+i;
	        headline.APPR_PUB__Long_Description__c = 'Test'+i;
	        headline.APPR_PUB__Tab__c = 'DesignRequestForm'; 
	        headline.APPR_PUB__Active__c = True;
	        headlines.add(headline);
	    }
	    insert headlines;

	    Test.startTest();

	    ApexPages.StandardController sc = new ApexPages.StandardController(headlines[0]);
	    HelixDesignRequestUtilities controller = new HelixDesignRequestUtilities(sc);

	    Test.stopTest();

	}
	
	@isTest 
	private static void testDocuments() {

		Account testPartner = TestClassFactory.CreateDealer('TestDealer', 'North America');

		Contact partnerContact = TestClassFactory.testContact('lastName', 'testpartnercon@noemail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Partner'));
        partnerContact.AccountId = testPartner.Id;
        partnerContact.Authorized_To_Order__c = TRUE;
        insert partnerContact;

        Design__c d = new Design__c();
        insert d;
        System.assertNotEquals(null, d.Id); 

        Document__c finalDoc = new Document__c();
        finalDoc.Document_Type__c = 'Commercial Design Deliverables';
        finalDoc.Design__c = d.Id;
        finalDoc.Name = 'Test';
        insert finalDoc;     
        
        UserRole role = [SELECT Id FROM UserRole WHERE Name LIKE '%Partner Executive' LIMIT 1];

        Id execProfileId = SFDCSpecialUtilities.getProfileIdByName('Partner Executive');

        User currentUser = new User(alias = 'cashman1', email = partnerContact.Email, 
                          emailencodingkey='UTF-8', lastname='Testing', 
                          languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = execProfileId,  country='United States', 
                          communityNickName = 'cashman1', timezonesidkey='America/Los_Angeles', 
                          username=string.valueOf(math.random())+'u1@testorg.com',
                          contactId=partnerContact.Id, UserRole = role);

        System.runAs(currentUser) {

        	HelixDesignRequestUtilities.fetchDesignDocuments(d.Id);            

            List<Document__c> docs = new List<Document__c>();
            for(Integer i = 0; i < 3; i++) {
            	Document__c doc = new Document__c();
            	doc.Design__c = d.Id;
            	docs.add(doc);
            }
            insert docs;

			List<Attachment> atts = new List<Attachment>();
			for(Document__c record : docs) {	
				Attachment a = new Attachment();
				a.ParentId = record.Id;
				a.Name = 'test';
				a.Body = Blob.valueOf('Test');
				atts.add(a);
			}
			insert atts;

			Test.startTest();

	    	HelixDesignRequestUtilities.fetchDesignDocuments(d.Id);

	    	d.Status__c = 'Completed';
	    	d.Dealer_Status__c = 'Design Delivered';
	    	update d;

	    	HelixDesignRequestUtilities.fetchDesignDocuments(d.Id);

	    	ApexPages.StandardController sc = new ApexPages.StandardController(d);
	    	HelixDesignRequestUtilities controller = new HelixDesignRequestUtilities(sc);

	    	controller.docIdToDelete = docs[0].Id;
	    	controller.deleteDesignDocuments();

	    	controller.docIdToDelete = null;
	    	controller.deleteDesignDocuments();

	    	Test.stopTest();
    	}
	}

	@isTest
	private static void testNegatives() {

		Test.startTest();
		
		HelixDesignRequestUtilities.fetchDesignDocuments('123456');

		Test.stopTest();
	}
	
}