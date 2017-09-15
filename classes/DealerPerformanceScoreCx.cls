public class DealerPerformanceScoreCx {

    public List<DealerPerformanceScoreUtility.MetricWrapper> lMetricWrappers {get; set;}
    
    //Standard Controller Constructor getting used by DealerAccountEmbed VF Page
    public DealerPerformanceScoreCx(ApexPages.StandardController controller) {
        
        Account acc = (Account) controller.getRecord();
        
        if(acc == null || acc.Id == null) return;
        
        lMetricWrappers = new List<DealerPerformanceScoreUtility.MetricWrapper>();
        lMetricWrappers = DealerPerformanceScoreUtility.calculateScores(acc.Id);
    }   
    
    //Custom Controller Constructor getting used by DealerAccount VF Page
    public DealerPerformanceScoreCx() {
        
        User usr = [SELECT Id, Name, ContactId, Contact.AccountId 
                        FROM User 
                        WHERE Id =: Userinfo.getUserId() 
                        AND (UserType = 'Partner' OR UserType = 'PowerPartner') 
                        LIMIT 1];

        if(usr == null || usr.ContactId == null || usr.Contact.AccountId == null) return;
        
        lMetricWrappers = new List<DealerPerformanceScoreUtility.MetricWrapper>();
        lMetricWrappers = DealerPerformanceScoreUtility.calculateScores(usr.Contact.AccountId);
    }    
}