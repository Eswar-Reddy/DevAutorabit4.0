@isTest
public class EnergyLinkPostSurveyControllerTestData {

    @TestVisible Question__c q_1;
    @TestVisible Answer__c a_11, a_12, a_13, a_14, a_15;
    
    @TestVisible
    private void createSettings() {
        List <Live_Agent_Settings__c> settingList = new List <Live_Agent_Settings__c>();
        settingList.add(getNewSetting('Enable Post Chat Survey', 'true'));
        
        insert settingList;
    }

    @TestVisible
    private void createTestData() {
        createSettings();
        // question
        q_1 = getNewQuestion('q_1', 'Single Choice', 'Energy Link Survey', 1, true);
        insert new List <Question__c>{q_1};
        // answer
        a_11 = getNewAnswer(q_1.Id, '1', 'a_11');
        a_12 = getNewAnswer(q_1.Id, '2', 'a_12');
        a_13 = getNewAnswer(q_1.Id, '3', 'a_13');
        a_14 = getNewAnswer(q_1.Id, '4', 'a_14');
        a_15 = getNewAnswer(q_1.Id, '5', 'a_15');
        insert new List <Answer__c>{a_11, a_12, a_13, a_14, a_15};
        
    }
    
    private static Question__c getNewQuestion(String question, String type, String application, Integer sequence, Boolean active) {
        Question__c q = new Question__c();
        q.Question__c = question;
        q.Type__c = type;
        q.Application__c = application;
        q.Sequence__c = sequence;
        q.Active__c = active;
        return q;    
    }
    
    private static Answer__c getNewAnswer(String questionId, String choice, String answer) {
        Answer__c a = new Answer__c();
        a.Question__c = questionId;
        a.Choice__c = choice;
        a.Answer__c = answer;
        return a;    
    } 
        
    @TestVisible
    private static Live_Agent_Settings__c getNewSetting(String name, String value) {
        return new Live_Agent_Settings__c(Name = name, Value__c = value);
    }

}