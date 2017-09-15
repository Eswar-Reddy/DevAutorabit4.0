@isTest
public class EnergyLinkPostSurveyControllerTest {

    private static testMethod void test_load() {
        EnergyLinkPostSurveyControllerTestData td = new EnergyLinkPostSurveyControllerTestData();
        td.createTestData();
        
        EnergyLinkPostSurveyController controller = new EnergyLinkPostSurveyController();
        system.assertEquals(1, controller.lineWrapperList.size());
        system.assertEquals(5, controller.lineWrapperList[0].answerOptions.size());
        system.assertEquals(true, controller.surveyRendered);
        system.assertEquals(false, controller.thankYouRendered);
    }

    private static testMethod void test_submit() {
        EnergyLinkPostSurveyControllerTestData td = new EnergyLinkPostSurveyControllerTestData();
        td.createTestData();
        
        EnergyLinkPostSurveyController controller = new EnergyLinkPostSurveyController();
        controller.lineWrapperList[0].selectedAnswer = td.a_12.Id;
        controller.submitSurvey();
        
        List <Live_Chat_Survey_Response__c> responseList = [SELECT Id, Answer__c, Question__c FROM Live_Chat_Survey_Response__c];
        system.assertEquals(1, responseList.size());
        system.assertEquals('q_1', responseList[0].Question__c);
        system.assertEquals('a_12', responseList[0].Answer__c);
        system.assertEquals(false, controller.surveyRendered);
        system.assertEquals(true, controller.thankYouRendered);
        
    }
    
}