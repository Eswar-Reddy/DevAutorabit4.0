@isTest
global class F9ApptReminder_Test implements HttpCalloutMock {
    
    static TestMethod void TestF9ReminderCallout_Fail() {
        
        List<Id> oppIdsForCallout = new List<Id>();
        
        Account a = TestClassFactory.testAccount('Testname', TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
        insert a;
        
        Contact c = TestClassFactory.testContact('TestlastName', 'testcon123@nomail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
        c.Phone = '555-555-1212';
		c.AccountId = a.Id;        
        
        Opportunity o = TestClassFactory.testOpportunity('TestOppname', 'Appointment Confirmed', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
        o.AccountId = a.Id;
        o.Primary_Contact__c = c.Id;
        insert o;
        oppIdsForCallout.add(o.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new F9ApptReminder_Test());
        
        F9ApptReminderOutbound.sendFive9ApptReminder(oppIdsForCallout);
        Test.stopTest();
        
    }

    static TestMethod void TestF9ReminderCallout_Pass() {

        Five9WebserviceCalloutSettings__c f9Settings = new Five9WebserviceCalloutSettings__c();
        f9Settings.Name = 'Five9';
        f9Settings.ListName__c = 'Test';
        f9Settings.MasterSwitchOn__c = true;
        f9Settings.Reminder_List__c = 'Test';
        f9Settings.F9key__c = 'salesforce_id';
        f9Settings.APIURL__c = 'https://api.five9.com/web2campaign/AddToList';
        f9Settings.EndpointURL__c = 'https://api.five9.com/wsadmin/v3/AdminWebService';
        f9Settings.Domain_Name__c = 'SunPower';
        f9Settings.Username__c = 'test@sunpower.com';
        f9Settings.SPDF9List__c = 'Test';
        insert f9Settings;
        
        List<Id> oppIdsForCallout = new List<Id>();
        
        Account a = TestClassFactory.testAccount('Testname', TestClassFactory.retrieveRecordTypeID('Account', 'Residential Customer'));
        insert a;
        
        Contact c = TestClassFactory.testContact('TestlastName', 'testcon123@nomail.com', TestClassFactory.retrieveRecordTypeID('Contact', 'Customer'));
        c.Phone = '555-555-1212';
        c.AccountId = a.Id;        
        
        Opportunity o = TestClassFactory.testOpportunity('TestOppname', 'Appointment Confirmed', Date.today().addDays(30), TestClassFactory.retrieveRecordTypeID('Opportunity', 'Home Owner'));
        o.AccountId = a.Id;
        o.Primary_Contact__c = c.Id;
        insert o;
        oppIdsForCallout.add(o.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new F9ApptReminder_Test());
        
        F9ApptReminderOutbound.sendFive9ApptReminder(oppIdsForCallout);
        Test.stopTest();
        
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }

}