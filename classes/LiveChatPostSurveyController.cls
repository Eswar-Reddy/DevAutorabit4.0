public class LiveChatPostSurveyController {

    public String language {get; private set;}
    public String message {get; private set;}
    public List <LineWrapper> lineWrapperList {get; private set;}
    public Boolean surveyRendered {get; private set;}
    public Boolean thankYouRendered {get; private set;}
    public Boolean surveyEnabled {get; private set;}
    
    public String chatKey {get; private set;}

    public LiveChatPostSurveyController() {
        // init
        language = 'en-US';
        surveyRendered = true;
        thankYouRendered = false;
        surveyEnabled = false;
        
        chatKey = ApexPages.currentPage().getParameters().get('chatKey');

        loadCustomSetting();
        loadLineWrapperList();
    }
    
    private void loadLineWrapperList() {
        lineWrapperList = new List <LineWrapper>();
        List <Question__c> questionList = getQuestions();
        for (Question__c question : questionList) {
            lineWrapperList.add(new LineWrapper(question));
        }
        for (Integer i=0; i<lineWrapperList.size(); i++) {
            lineWrapperList[i].rowNum = i+1;
        }
    }
    
    private void loadCustomSetting() {
        Map <String, Live_Agent_Settings__c> settingMap = Live_Agent_Settings__c.getAll();    
        if (settingMap != null && settingMap.size() > 0) {
            for (String name : settingMap.keySet()) {
                Live_Agent_Settings__c setting = settingMap.get(name);
                if (name == 'Enable Post Chat Survey') {                
                    if (setting.Value__c == 'true') {
                        surveyEnabled = true;
                    }
                }                
            }
        }
    }
    
    private static List <Question__c> getQuestions() {
        List <Question__c> questionList = [SELECT Id, Name, Active__c, Application__c, Question__c, Sequence__c, Topic__c, Type__c,
                (SELECT Id, Name, Answer__c, Choice__c, Score__c FROM Answers__r ORDER BY Choice__c ASC)
            FROM Question__c
            WHERE Application__c = 'Live Chat Survey' AND Active__c = true
            ORDER BY Sequence__c ASC];    
        return questionList;    
    }
    
    public void submitSurvey() {
        
        try {
            List <Live_Chat_Survey_Response__c> respList = new List <Live_Chat_Survey_Response__c>();
            for (Integer i=1; i<=lineWrapperList.size(); i++) {
                LineWrapper w = lineWrapperList[i-1];
                Live_Chat_Survey_Response__c resp = new Live_Chat_Survey_Response__c();
                resp.ChatKey__c = chatKey;
                resp.Question__c = w.question.Question__c;
                resp.Topic__c = w.question.Topic__c;
                 
                if (w.question.Type__c == 'Single Choice') {
                    if (String.IsNotBlank(w.selectedAnswer) && w.answerMap.containsKey(w.selectedAnswer)) {
                        resp.Answer__c = w.answerMap.get(w.selectedAnswer).Answer__c;
                        resp.Actual_Score__c = w.answerMap.get(w.selectedAnswer).Score__c;
                    }
                } else if (w.question.Type__c == 'Text Area') {
                    resp.Answer__c = w.selectedAnswer;
                }
                
                resp.Min_Score__c = w.minScore;
                resp.Max_Score__c = w.maxScore;
                resp.Sequence__c = w.question.Sequence__c;
                respList.add(resp);
            }
            if (respList.size() > 0) {
                insert respList;
            }
    
        } catch (Exception e) {
            message = e.getMessage();
            return;
        } 
        surveyRendered = false;
        thankYouRendered = true;
    }
    
    public class LineWrapper {
        public Integer rowNum {get; private set;}
        public Question__c question {get; private set;}
        public List <SelectOption> answerOptions {get; private set;}
        public String selectedAnswer {get; set;}
        private Map <String, Answer__c> answerMap;    
        public Decimal minScore {get; private set;}
        public Decimal maxScore {get; private set;}
        public LineWrapper(Question__c question) {
            this.question = question;
            answerOptions = new List <SelectOption>();
            answerMap = new Map <String, Answer__c>(); 
            if (question != null && question.Answers__r != null) {
                for (Answer__c answer : question.Answers__r) {
                    answerOptions.add(new SelectOption(answer.Id, answer.Answer__c));
                    answerMap.put(answer.Id, answer);
                    
                    if (answer.Score__c != null) {
                        if (this.minScore == null || this.minScore > answer.Score__c) {
                            this.minScore = answer.Score__c;
                        }
                        if (this.maxScore == null || this.maxScore < answer.Score__c) {
                            this.maxScore = answer.Score__c;
                        }
                    }
                } 
            }
        }
    }

}