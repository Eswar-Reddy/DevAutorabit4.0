@isTest(SeeAllData=True)
Public class TestPostSurveyCSATTaskClass {
    
    
    static testMethod void createPostCsatTaskTest() {
     
      Set<Id> opptIdsSet = new Set<Id>();   
      List<Opportunity> oppLt = new List<Opportunity>();
      String  HomeOwnerOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        
      Account a = new Account(name='testAcc');
      a.Type = 'Premier-Partner-Combo';
      a.BillingCity = 'Bischofsheim';
      a.BillingCountry = 'Germany';
      a.BillingStreet = 'Am Schindberg 27';      
      a.BillingPostalCode = '65474';
      //a.BillingState='HE';
      a.Theater__c = 'Europe';
      insert a;
      Account a1 = new Account(name='testAcc1');
      a1.Type = 'Premier-Partner-Combo';
      a1.BillingCity = 'Still';
      a1.BillingCountry = 'France';
      a1.BillingStreet = '181J, rue du Général de Gaulle';      
      a1.BillingPostalCode = '67190';
      //a.BillingState='HE';
      a1.Theater__c = 'Europe';
      insert a1;
      Account a2 = new Account(name='testAcc2');
      a2.Type = 'Premier-Partner-Combo';
      a2.BillingCity = 'Albignasego';
      a2.BillingCountry = 'Italy';
      a2.BillingStreet = 'Kanaaldijk 4a';      
      a2.BillingPostalCode = '2380';
      //a.BillingState='HE';
      a2.Theater__c = 'Europe';
      insert a2;
     
      
      Contact contactObj = new Contact();
      contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
      contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
      contactObj.AccountId = a.Id;
      contactObj.Phone = '9876543210';
      insert contactObj;
      
      Customer_Survey_Result__c  csr = new Customer_Survey_Result__c ();
     //csr.Name = 'testCSR';
      csr.Aggregate_Score__c = 55;
      csr.Survey_Response_Date__c = Date.newInstance(2011,4,23);
      csr.Partner_Account__c = a.Id;
      insert csr;
      User test_user =TestClassUtilities.getEUPartnerPortalUser(a);
      for(integer i=0; i<3; i++)
      {
      
      Opportunity testOpp = new Opportunity();
      if(i==0)
      {
      testOpp.AccountId=a.Id;
      }
      if(i==1)
      {
      testOpp.AccountId=a1.Id;
      }
      if(i==2)
      {
      testOpp.AccountId=a2.Id;
      }
      
      testOpp.Name = 'testOpp';
      testOpp.Theater__c = 'Europe';
      testOpp.OwnerId = test_user.Id;
      testOpp.RecordTypeId = HomeOwnerOppRecordTypeID;
      testOpp.stageName = 'Installation Completed';
      testOpp.Primary_Contact__c = contactObj.Id;
      testOpp.Customer_Satisfaction_Survey_opt_in__c = true;
      
      testOpp.CloseDate = Date.today();
      oppLt.add(testOpp);  
      }
      
      insert oppLt;  

      for(Opportunity opp:oppLt)
      {
      opptIdsSet.add(opp.id);
      }
      Date startDate = date.newinstance(Date.today().year(), 2, 1); 
      Date endDate = date.newinstance(Date.today().year(), 2, 28);
      
      Performance_Metric__c perfMetric = new Performance_Metric__c(Thea__c='North America',Performance_Period_Start_Date__c= startDate.adddays(-15),Performance_period_End_date__c =endDate.adddays(15)); 
      insert perfMetric;
      Test.startTest();    
        System.runAs(test_user){ 
        //Start new context        
        
        
        PostSurveyCSATTaskClass.createPostCsatTask(opptIdsSet);
        Test.stopTest();
      } 
      
     /*List<Task> taskList = [select id from task where  WhatId = :testOpp.Id];
      System.assertEquals(1,taskList.size());*/
    }
   
    
        
    static testMethod void createPostCsatTaskTest1() {
      Set<Id> opptIdsSet1 = new Set<Id>();   
      
      String  HomeOwnerOppRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Home Owner').getRecordTypeId();
        
      Account a = new Account(name='testAcc');
      a.Type = 'Elite-Partner-Combo';     
      a.BillingCity = 'hyd';
      a.BillingCountry = 'United States';
      a.BillingStreet = 'Al';
      a.BillingState='CA';
      a.BillingPostalCode = '95050';
      a.Theater__c = 'North America';
      insert a;
      
      Contact contactObj = new Contact();
      contactObj.FirstName = 'test' +String.valueOf(DateTime.Now());
      contactObj.LastName = 'test' + String.valueOf(DateTime.Now());
      contactObj.AccountId = a.Id;
      contactObj.Phone = '9876543210';
      insert contactObj;
      
      Customer_Survey_Result__c  csr = new Customer_Survey_Result__c ();
      //csr.Name = 'testCSR';
      csr.Aggregate_Score__c = 55;
      csr.Survey_Response_Date__c = Date.newInstance(2011,4,23);
      csr.Partner_Account__c = a.Id;
      insert csr;
      User test_user =TestClassUtilities.getEUPartnerPortalUser(a);
      Opportunity testOpp = new Opportunity();
      testOpp.Name = 'testOpp';
      testOpp.Theater__c = 'North America';
      testOpp.OwnerId = test_user.Id;
      testOpp.RecordTypeId = HomeOwnerOppRecordTypeID;
      testOpp.stageName = 'Installation Completed';
      testOpp.Primary_Contact__c = contactObj.Id;
      testOpp.Customer_Satisfaction_Survey_opt_in__c = true;
     // testOpp.AccountId=a.Id;
      testOpp.CloseDate = Date.today();              
      insert testOpp;  
      opptIdsSet1.add(testOpp.id); 
      Date startDate = date.newinstance(Date.today().year(), 2, 1); 
      Date endDate = date.newinstance(Date.today().year(), 2, 28);
      
      Performance_Metric__c perfMetric = new Performance_Metric__c(Thea__c='North America',Performance_Period_Start_Date__c= startDate.adddays(-15),Performance_period_End_date__c =endDate.adddays(15)); 
      insert perfMetric;
        System.runAs(test_user){ 
        //Start new context        
        Test.startTest();
        PostSurveyCSATTaskClass.createPostCsatTask(opptIdsSet1);
        Test.stopTest();
      } 
      
      
      }
        
     
}