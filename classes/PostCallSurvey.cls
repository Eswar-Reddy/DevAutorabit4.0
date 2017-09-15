public class PostCallSurvey{
    
    
    /*
Function     : createPostCallSurveyObjectWithContactLastSurveyDateUpdate
Parameter    : List<Case>
Returen Type : 
Summary      : This function accept Case list, create Post Call Survey Object for each closed cases and update related contact date field for last survey sent date Issue_Resolution_Survey_Sent_date__c so that a person won't receive a survey email twice in a week  
Calling Class: Trigger -afterCaseInsertUpdate
*/
    
    Public Static void createPostCallSurveyObjectWithContactLastSurveyDateUpdate(List<Case> lstCases)
    {
        List<Post_Call_Survey__c> lstPCS=new List<Post_Call_Survey__c>();
        List<Contact>contactListToUpdateIssueResolutionSentSurveydate=new List<Contact>(); //Contact List to update contact field:  Issue Resolution Survey Sent date
        
        for(Case c:lstCases)
        { 
            lstPCS.add(new Post_Call_Survey__c(Name='Issue Resolution-Transactional Survey',Contact__c=c.ContactID,Case__c=c.ID,Survey_Status__c='Invitation Sent'));    
            contactListToUpdateIssueResolutionSentSurveydate.add(new Contact(Id = c.ContactID,Issue_Resolution_Survey_Sent_date__c=System.today())); // Updating associated contact with Issue Resolution Survey Sent date as Today
            
        }
        
        
        if(lstPCS.size()>0)
        {
            insert lstPCS;
        }
        
        if(contactListToUpdateIssueResolutionSentSurveydate.size()>0){
            update contactListToUpdateIssueResolutionSentSurveydate;
        }
    }
    
}