@isTest
public class SurveyUtilityTest {

    private static testMethod void testSalesSurvey() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForSalesSurvey conditions
        td.oppty_1.Lead_Manufacturer__c = 'SunPower';
        td.oppty_1.StageName = '12% - Qualified Opportunity';    // <> 'Installation Completed'
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Post_Visit_Follow_Up_Survey__c> surveyList = [SELECT Id FROM Post_Visit_Follow_Up_Survey__c 
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
    }

    private static testMethod void testInstallSurvey_cash_nonSPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForInstallSurvey conditions
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Installation_Completed_Date__c = system.today();    
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Customer_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM Customer_Survey_Result__c
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(true, surveyList[0].Cash__c);        
        system.assertEquals(false, surveyList[0].Lease__c);        
    }

    private static testMethod void testInstallSurvey_cash_SPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForInstallSurvey conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Installation_Completed_Date__c = system.today(); 
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = system.today().addDays(-10);    // <= system.today()  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Customer_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM Customer_Survey_Result__c
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(true, surveyList[0].Cash__c);        
        system.assertEquals(false, surveyList[0].Lease__c);        
    }

    private static testMethod void testInstallSurvey_cash_SPD_Date_PTO_Blank() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForInstallSurvey conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Installation_Completed_Date__c = system.today(); 
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = null;    // <= system.today()  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Customer_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM Customer_Survey_Result__c
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(0, surveyList.size());        
    }

    private static testMethod void testInstallSurvey_cash_SPD_Date_PTO_gt_today() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForInstallSurvey conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Installation_Completed_Date__c = system.today(); 
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = system.today().addDays(1);    // <= system.today()  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Customer_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM Customer_Survey_Result__c
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(0, surveyList.size());        
    }

    private static testMethod void testInstallSurvey_lease_nonSPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForInstallSurvey conditions
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Installation_Completed_Date__c = system.today(); 
        td.oppty_1.Lease__c = true;
        td.oppty_1.Lease_Placed_in_Service__c = true;  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Customer_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM Customer_Survey_Result__c
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(false, surveyList[0].Cash__c);        
        system.assertEquals(true, surveyList[0].Lease__c);        
    }

    private static testMethod void testInstallSurvey_lease_SPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppForInstallSurvey conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Installation_Completed_Date__c = system.today(); 
        td.oppty_1.Lease__c = true;
        td.oppty_1.Lease_Placed_in_Service__c = true;  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <Customer_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM Customer_Survey_Result__c
            WHERE Opportunity_ID__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(false, surveyList[0].Cash__c);        
        system.assertEquals(true, surveyList[0].Lease__c);        
    }

    private static testMethod void test1YearSurvey_cash_nonSPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppFor1YrSurveys conditions
        td.oppty_1.StageName = 'Installation Completed';
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <X1Y_Satisfaction_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM X1Y_Satisfaction_Survey_Result__c
            WHERE Opportunity__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(true, surveyList[0].Cash__c);        
        system.assertEquals(false, surveyList[0].Lease__c);        
    }

    private static testMethod void test1YearSurvey_cash_SPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppFor1YrSurveys conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = system.today().addDays(-10);    // <= system.today()  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <X1Y_Satisfaction_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM X1Y_Satisfaction_Survey_Result__c
            WHERE Opportunity__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(true, surveyList[0].Cash__c);        
        system.assertEquals(false, surveyList[0].Lease__c);        
    }

    private static testMethod void test1YearSurvey_lease_nonSPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppFor1YrSurveys conditions
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Lease__c = true;
        td.oppty_1.Lease_Placed_in_Service__c = true;  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <X1Y_Satisfaction_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM X1Y_Satisfaction_Survey_Result__c
            WHERE Opportunity__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(false, surveyList[0].Cash__c);        
        system.assertEquals(true, surveyList[0].Lease__c);        
    }

    private static testMethod void test1YearSurvey_lease_SPD() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppFor1YrSurveys conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = system.today().addDays(-10);    // <= system.today()  
        td.oppty_1.Lease__c = true;
        td.oppty_1.Lease_Placed_in_Service__c = true;  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <X1Y_Satisfaction_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM X1Y_Satisfaction_Survey_Result__c
            WHERE Opportunity__c = :td.oppty_1.Id];

        system.assertEquals(1, surveyList.size());        
        system.assertEquals(false, surveyList[0].Cash__c);        
        system.assertEquals(true, surveyList[0].Lease__c);        
    }

    private static testMethod void test1YearSurvey_cash_SPD_Date_PTO_Blank() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppFor1YrSurveys conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = null;    // <= system.today()  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <X1Y_Satisfaction_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM X1Y_Satisfaction_Survey_Result__c
            WHERE Opportunity__c = :td.oppty_1.Id];

        system.assertEquals(0, surveyList.size());        
    }

    private static testMethod void test1YearSurvey_cash_SPD_Date_PTO_gt_today() {
        SurveyUtilityTestData td = new SurveyUtilityTestData(); 
        td.createTestData();
        
        // isValidOppFor1YrSurveys conditions
        td.oppty_1.Partner_Account_Id__c = td.spdPartnerAccount_1.Id;
        td.oppty_1.StageName = 'Installation Completed';
        td.oppty_1.Date_PTO_Letter_Received_Promised__c = system.today().addDays(1);    // <= system.today()  
           
        insert td.oppty_1;
        
        // verify sales survey is create
        List <X1Y_Satisfaction_Survey_Result__c> surveyList = [SELECT Id, Cash__c, Lease__c FROM X1Y_Satisfaction_Survey_Result__c
            WHERE Opportunity__c = :td.oppty_1.Id];

        system.assertEquals(0, surveyList.size());        
    }

}