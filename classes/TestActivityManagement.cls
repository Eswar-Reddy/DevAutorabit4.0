@isTest 
private  class TestActivityManagement{
    private static final String TASK_SUBJECT_CREATE_BINDING_OFFER = 'Create Binding Offer';
    @isTest
    private static void TestActivityManagement(){
        Test.startTest();
        
        Account accountObj= TestDataUtility.setUpAccount(null, 'Commercial Customer', false);        
        insert accountObj;
        
        PSR__c p = TestDataUtility.setUpPSR(true);
         
        task tsk = new Task();
        tsk = new Task(
        whatid=accountObj.Id,                    
        ActivityDate= Date.today().addDays(2),
        OwnerId=userinfo.getUserID(),
        Subject= 'Create Oracle Account',
        Description= 'Please create an account',
        Status = 'In Progress',
        PSR_ID__c = p.ID);
        
        insert tsk;
        
        tsk.Status = 'Completed';
        //MAM 09/16/2014 Update query to allow the the test class to assign the Task to a non-portal user start
        tsk.OwnerId = [select id from user where IsPortalEnabled=false AND IsActive = true limit 1][0].Id;
        //MAM 09/16/2014 end
        update tsk;
                
        tsk.Tracking_Date__c= Date.today();
        update tsk;
               
        Test.stopTest();
    }
    
    @isTest
    private static void TestActivityManagement1(){
        Id ssoTaskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('SSO Task').getRecordTypeId();   
        List<Task> taskList = new List<Task>();
        Account a = new Account(name='testAcc');
        a.Type = 'Premier-Partner-Combo';
        a.BillingCity = 'hyd';
        a.BillingCountry = 'Italy';
        a.BillingStreet = 'abc';
        a.BillingPostalCode = '1223454';
        a.Theater__c = 'Europe';
        insert a;
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'testOpp';
        testOpp.Business_Unit__c = 'UPP Intl';
        testOpp.Theater__c = 'Europe';
        testOpp.stageName = 'Installation Completed';
        testOpp.CloseDate = Date.today(); 
        testOpp.Country__c = 'India';
        insert testOpp;
        
        
        Customer_Survey_Result__c  csr = new Customer_Survey_Result__c ();
        csr.Aggregate_Score__c = 55;
        csr.Survey_Response_Date__c = Date.newInstance(2011,4,23);
        csr.Partner_Account__c = a.Id;
        csr.Opportunity_ID__c = testOpp.Id;
        insert csr;
        
        PSR__c p = new PSR__c();
        p.Site_Survey_Completed__c =Date.Today();
        p.Opportunity__c = testOpp.Id;
        insert p; 
                    
        task tsk = new Task();
        tsk = new Task(
        whatid=csr.Id,                    
        ActivityDate= Date.today().addDays(2),
        PSR_ID__c = p.Id,
        Subject= 'Customer Survey Result - Survey email notification',
        Description= 'Please create an account',
        Status = 'Completed');
        insert tsk;
        
         
        Contact contactObj = new Contact();
        contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
        contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
        contactObj.AccountId = a.Id;
        contactObj.LMS_Role__c='B-Owner/Training Liaison';
        insert contactObj;
        
        Lead lead1 = new Lead();    
        lead1.FirstName = 'Test';
        lead1.LastName = 'Commercial';
        lead1.Lead_Type__c='Commercial';
        lead1.Company = 'TEST Company A';
        lead1.Email = 'testEmail@test123.com';
        lead1.Phone = '09829098290';
        lead1.LeadSource = 'Web';
        lead1.OwnerId='00580000001zGxpAAE';
        insert lead1;
        
               
        tsk.WhoId = contactObj.Id; 
        taskList.add(tsk);
         
        task tsk2 = new Task();
        tsk2 = new Task(     
        WhatId  = p.Id,   
        ActivityDate= Date.today().addDays(2),
        PSR_ID__c = p.Id,
        Subject= 'Create Binding Offer',
        RecordTypeId = ssoTaskRecTypeId,
        Description= 'Please create an account',
        Status = 'In Progress');
        insert tsk2;
       
        tsk2.Status = 'Completed';
        tsk2.WhoId = lead1.Id;  
        tsk2.WhatId = null;
        taskList.add(tsk2);
        update taskList;
    }
    
    // Case # 00083101 testing PostVisitSurvey
    @isTest
    private static void postVisitSurveyTest(){      
        // get account
        Account acc = TestDataUtility.setUpAccount(NULL,'',true);
        
        // get contact  
        Contact cont = TestDataUtility.setUpContact(acc.Id,true);
      
        // get Opportunity
        Opportunity testOpp = TestDataUtility.setUpOpportunity(acc.Id, Date.today(),true);
      
        // get Post_Visit_Follow_Up_Survey__c
        Post_Visit_Follow_Up_Survey__c pvSurvey = TestDataUtility.setUpPostVisitFollowUpSurvey(acc.Id, testOpp.Id,cont.Id);
        pvSurvey.Customer_Account__c = acc.Id;
        update pvSurvey;
        
        // get Task
        task tsk = TestDataUtility.setUpTask('Completed', 'Invitation Scheduled', null, pvSurvey.Id);
    }

}