/*********************************************************************
    Name  : TestPostVisitFollowupSurveyManagement
    Author: Appirio Offshore (Hemant)
    Date  : Dec 29,2011
    Related Case: 00083101
    Description:This is a Test Class For Class "PostVisitFollowupSurveyManagement".
*********************************************************************/

@isTest 
private  class TestPostVisitFollowupSurveyManagement{
    
    @isTest
    private static void postVisitFollowupSurveyManagementTestEU(){
    
      // get account
      Account acc = TestDataUtility.setUpAccount(NULL,'', true);
        
      // get contact  
      Contact cont = TestDataUtility.setUpContact(acc.Id, false);
      cont.Phone = '98 76 54 32 10';
      cont.Email = 'testEmailAddress@test.com';
      insert cont;
      
      // get Opportunity
	  Opportunity testOpp;
      
      // get Partner User
      User test_user = TestDataUtility.setUpPartnerPortalUserByContact('EU Partner Delegated Administrator',cont);
      System.runAs(test_user){ 
        //Start new context        
        Test.startTest();
      	// get Opportunity
       	Account acc1 = TestDataUtility.setUpAccount(NULL,'', true);
       	testOpp = TestDataUtility.setUpOpportunity(acc1.Id, Date.today(), false);
       	testOpp.CampaignId = TestDataUtility.setUpCampaign().Id;
       	insert testOpp; 
        Test.stopTest();
      } 

      // get Post_Visit_Follow_Up_Survey__c
      Post_Visit_Follow_Up_Survey__c pvSurvey = TestDataUtility.setUpPostVisitFollowUpSurvey(acc.Id, testOpp.Id,cont.Id);
      
      // update Post_Visit_Follow_Up_Survey__c   
      pvSurvey.Opportunity_Alliance_Program_Lead__c = true;  
      pvSurvey.Status_Survey__c = 'No Response Received';
      update pvSurvey;
    }
    
    @isTest
    private static void postVisitFollowupSurveyManagementTestNA(){
      
      // get account
      Account acc = TestDataUtility.setUpAccount(NULL,'', true);
	  acc.BillingCountry = 'CA';
      update acc;
              
      // get contact  
      Contact cont = TestDataUtility.setUpContact(acc.Id, false);
      cont.Phone = '9876543210';
      cont.Email = 'testEmailAddress@test.com';
      insert cont;
      
      // get Opportunity
	  Opportunity testOpp;
      
      // get Partner User
      User test_user = TestDataUtility.setUpPartnerPortalUserByContact('Partner Delegated Administrator',cont);
      System.runAs(test_user){ 
        //Start new context        
        Test.startTest();
      	// get Opportunity
       	Account acc1 = TestDataUtility.setUpAccount(NULL,'', true);
       	testOpp = TestDataUtility.setUpOpportunity(acc1.Id, Date.today(), false);
       	testOpp.CampaignId = TestDataUtility.setUpCampaign().Id;
       	insert testOpp; 
        Test.stopTest();
      } 

      // get Post_Visit_Follow_Up_Survey__c
      Post_Visit_Follow_Up_Survey__c pvSurvey = TestDataUtility.setUpPostVisitFollowUpSurvey(acc.Id, testOpp.Id,cont.Id);
      
      // update Post_Visit_Follow_Up_Survey__c
      pvSurvey.Opportunity_Alliance_Program_Lead__c = true;     
      pvSurvey.Status_Survey__c = 'No Response Received';
      update pvSurvey;
    }
}