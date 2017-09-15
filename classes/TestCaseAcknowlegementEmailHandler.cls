/*********************************************************************
    Name  : TestCaseAcknowlegementEmailHandler
	Date  : July 18,2011
    Description: This is a Test Class For Class "CaseAcknowlegementEmailHandler".
*********************************************************************/


@isTest
private class TestCaseAcknowlegementEmailHandler {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        // Create a new email and envelope object
	    Messaging.InboundEmail email = new Messaging.InboundEmail();
	    Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
	         
	    // Set up your data if you need to
	    Case newCase = new Case();       
        newCase.Status = 'New';
        newCase.Type = 'Customer Complaint';
        newCase.P1_Notification_Email__c = true;
        newCase.Subject = 'Test';
        insert newCase;     
        newCase = [select CaseNumber,Subject from Case where Id=:newCase.Id limit 1];
        
	    // Create the email body
	    email.Subject ='Case #'+newCase.CaseNumber+' - '+newCase.Subject+' - P1 Notification';
	    email.fromAddress ='test@test.com';
	    if(SalesforceOrgUtils.isProductionOrg()){
	    	email.ccAddresses = new String[] {'caseacknowlegmentemailservice@10k0c3yxzth0w02v1mpfc1w5k.8zf1leaw.8.apex.salesforce.com'};
	    }else{	    
	    	email.ccAddresses = new String[] {'caseacknowlegmentemailservice@n-4gb07tivdwrjxznj7we2glooe.qhlkamaw.q.apex.sandbox.salesforce.com'};
	    }
	          
	    CaseAcknowlegmentEmailHandler edr = new CaseAcknowlegmentEmailHandler();	         
	    Test.startTest();
	    Messaging.InboundEmailResult result = edr.handleInboundEmail(email, env);
	    System.assert (result.success, 'InboundEmailResult returned a failure message');
	    email.Subject ='Case #'+newCase.CaseNumber+' - '+newCase.Subject+' - P5 Follow Up Reminder';
	    result = edr.handleInboundEmail(email, env);
	    System.assert (result.success, 'InboundEmailResult returned a failure message');
	    email.Subject ='Case #'+newCase.CaseNumber+' - '+newCase.Subject+' - P30 Notification';
	    result = edr.handleInboundEmail(email, env);	    
	    Test.stopTest();	         
	    System.assert (result.success, 'InboundEmailResult returned a failure message');
    }
}